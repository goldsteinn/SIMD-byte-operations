#include <assert.h>
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <x86intrin.h>


extern "C" char * strchr_avx2(char * b, char m);

#define COMPILER_BARRIER()              asm volatile("" : : : "memory");
#define COMPILER_DO_NOT_OPTIMIZE_OUT(X) asm volatile("" : : "r,m"(X) : "memory")
#define SIMPLE_ASSERT(X, Y)                                                    \
    if ((char *)(X) != (char *)(Y)) {                                          \
        fprintf(stderr, "%d: %p != %p\n", __LINE__, X, Y);                     \
    }


void
ctest_S() {
#if ONE_PAGE == 1 && ALIGNMENT == 0
    const uint32_t ub = 4096;
#else
    const uint32_t ub   = 8192;
#endif

#if ALIGNMENT == 0
    const uint32_t incr = 1;
#else
    const uint32_t incr = ALIGNMENT;
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
            addr[i] = mark;
            SIMPLE_ASSERT(strchr((char *)addr, mark),
                          strchr_avx2((char *)addr, mark));
            addr[i] = -1;
        }
    }
}


int
main(int argc, char ** argv) {
    uint64_t len = argc == 1 ? 10000 : atoi(argv[1]);
    ctest_S();
}