#include <assert.h>
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <x86intrin.h>
#include <sys/time.h>
#include <unistd.h>


extern "C" char * strchr_avx2(char * str, char chr);
extern "C" char * strlen_avx2(char * str);
extern "C" char * strcpy_avx2(char * src, char * dst);

#define COMPILER_BARRIER()              asm volatile("" : : : "memory");
#define COMPILER_DO_NOT_OPTIMIZE_OUT(X) asm volatile("" : : "r,m"(X) : "memory")
#define SIMPLE_ASSERT(X, Y)                                                    \
    if ((char *)(X) != (char *)(Y)) {                                          \
        fprintf(stderr, "%d: %p != %p\n", __LINE__, (void *)X, (void *)Y);     \
    }

uint64_t
strlen_wrapper(char * b) {
    return (uint64_t)((uint64_t)strlen_avx2(b) - (uint64_t)b);
}

void rand_str(char * mem, uint32_t len) {
    for(uint32_t i = 0; i < len; ++i) {
        mem[i] = 65 + (rand() % 26);
    }
    mem[len] = 0;
}

void
strcpy_test() {
    char * str0 = (char *)mmap(NULL, 3 * 4096, PROT_READ | PROT_WRITE,
                                     MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);

    char * str1 = (char *)mmap(NULL, 3 * 4096, PROT_READ | PROT_WRITE,
                                     MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    assert(!mprotect(str0 + 8192, 4096, PROT_NONE));
    assert(!mprotect(str1 + 8192, 4096, PROT_NONE));
    memset(str0, -1, 8192);
    memset(str1, -1, 8192);

    for(uint32_t i = 0; i < 8192; ++i) {
        for(uint32_t j = 0; j < 8192 - i; j += (rand() % 32)) {
            for(uint32_t k = 0; k < 32; ++k) {
                if (i + k + j >= 8192) {
                    continue;
                }
                rand_str(str0 + i + k, j);
                strcpy_avx2(str1 + i, str0 + i + k);
                if(strcmp(str0 + i + k, str1 + i)) {
                    fprintf(stderr, "(0)[%d][%d][%d]\n", i, j, k);
                    fprintf(stderr, "str0: %s\n", str0 + i + k);
                    fprintf(stderr, "str1: %s\n", str1 + i);
                    exit(-1);
                }
            }
            for(uint32_t k = 0; k < 32; ++k) {
                if (i + k + j >= 8192) {
                    continue;
                }
                rand_str(str0 + i, j);
                strcpy_avx2(str1 + i + k, str0 + i);
                if(strcmp(str0 + i, str1 + i + k)) {
                    fprintf(stderr, "(1)[%d][%d][%d]\n", i, j, k);
                    fprintf(stderr, "str0: %s\n", str0 + i);
                    fprintf(stderr, "str1: %s\n", str1 + i + k);
                    exit(-1);
                }
            }


        }
    }
    
    assert(!munmap(str0, 3 *  4096));
    assert(!munmap(str1, 3 *  4096));

}

void
ctest_S() {
#if ONE_PAGE == 1 && ALIGNMENT == 0
    const uint32_t ub     = 4096;
    const uint32_t off_ub = 4096 - 32;
#else
    const uint32_t ub     = 8192;
    const uint32_t off_ub = 8192;
#endif

#if ALIGNMENT == 0
    const uint32_t incr = 1;
#else
    const uint32_t incr   = ALIGNMENT;
#endif

    uint8_t   mark = 1;
    uint8_t * addr = (uint8_t *)mmap(NULL, 3 * 4096, PROT_READ | PROT_WRITE,
                                     MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);

    assert(addr != NULL);
    assert(!mprotect(addr + ub, 4096, PROT_NONE));
    memset(addr, -1, ub);
    addr[ub - 1] = 0;


    for (uint32_t i = 0; i < ub; ++i) {
        for (uint32_t off = 0; off < i; off += incr) {
            if (off >= off_ub) {
                continue;
            }


            addr[i] = 0;
            SIMPLE_ASSERT(strlen((char *)addr + off),
                          strlen_wrapper((char *)addr + off));
            addr[i] = mark;
            if(off) {
                addr[off - 1] = mark;
            }
            SIMPLE_ASSERT(strchr((char *)addr + off, mark),
                          strchr_avx2((char *)addr + off, mark));
            if(off) {
                addr[off - 1] = -1;
            }
            addr[i] = -1;
        }
    }
    assert(!munmap(addr, 3 *  4096));
}


int
main(int argc, char ** argv) {
    uint64_t len = argc == 1 ? 10000 : atoi(argv[1]);
    strcpy_test();
    exit(0);
    ctest_S();
}
