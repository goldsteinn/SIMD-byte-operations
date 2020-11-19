#include <assert.h>
#include <immintrin.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <unistd.h>
#include <x86intrin.h>


extern "C" char * strchr_avx2(char * str, char chr);
extern "C" char * strlen_avx2(char * str);
extern "C" char * strcpy_avx2(char * src, char * dst);
extern "C" void   memcpy_avx2(uint8_t * src, uint8_t * dst, uint64_t size);

#define COMPILER_BARRIER()              asm volatile("" : : : "memory");
#define COMPILER_DO_NOT_OPTIMIZE_OUT(X) asm volatile("" : : "r,m"(X) : "memory")
#define SIMPLE_ASSERT(X, Y)                                                    \
    if ((char *)(X) != (char *)(Y)) {                                          \
        fprintf(stderr, "%d: %p != %p\n", __LINE__, (void *)X, (void *)Y);     \
    }

#define MIN(X, Y) (X) < (Y) ? (X) : (Y)
#define MAX(X, Y) (X) < (Y) ? (Y) : (X)

uint64_t
strlen_wrapper(char * b) {
    return (uint64_t)((uint64_t)strlen_avx2(b) - (uint64_t)b);
}

void
rand_str(char * mem, uint32_t len) {
    for (uint32_t i = 0; i < len; ++i) {
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

    for (uint32_t pg = 0; pg < 8192; pg += 4096) {
        for (uint32_t off = 0; off < 256; ++off) {
            uint32_t i = (off < 128) ? (pg + off) : ((pg + 4096) - (off % 128));
            fprintf(stderr, "%d\n", i);
            for (uint32_t j = 0; j < 8192 - i; j += (rand() % 32)) {
                for (uint32_t k = 0; k < 32; ++k) {
                    if (i + k + j >= 8192) {
                        continue;
                    }
                    rand_str(str0 + i + k, j);
                    strcpy_avx2(str1 + i, str0 + i + k);
                    if (memcmp(str0 + i + k, str1 + i, j)) {
                        fprintf(stderr, "(0)[%d][%d][%d]\n", i, j, k);
                        fprintf(stderr, "str0: %s\n", str0 + i + k);
                        fprintf(stderr, "str1: %s\n", str1 + i);
                        exit(-1);
                    }
                }
                for (uint32_t k = 0; k < 32; ++k) {
                    if (i + k + j >= 8192) {
                        continue;
                    }
                    rand_str(str0 + i, j);
                    strcpy_avx2(str1 + i + k, str0 + i);
                    if (memcmp(str0 + i, str1 + i + k, j)) {
                        fprintf(stderr, "(1)[%d][%d][%d]\n", i, j, k);
                        fprintf(stderr, "str0: %s\n", str0 + i);
                        fprintf(stderr, "str1: %s\n", str1 + i + k);
                        exit(-1);
                    }
                }
            }
        }
    }

    assert(!munmap(str0, 3 * 4096));
    assert(!munmap(str1, 3 * 4096));
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


    for (uint32_t i = 64; i < ub; ++i) {
        for (uint32_t off = 32; off < i; off += incr) {
            if (off >= off_ub) {
                continue;
            }


            addr[i] = 0;
            SIMPLE_ASSERT(strlen((char *)addr + off),
                          strlen_wrapper((char *)addr + off));
            addr[i] = mark;
            if (off) {
                addr[off - 1] = mark;
            }
            SIMPLE_ASSERT(strchr((char *)addr + off, mark),
                          strchr_avx2((char *)addr + off, mark));
            if (off) {
                addr[off - 1] = -1;
            }
            addr[i] = -1;
        }
    }
    assert(!munmap(addr, 3 * 4096));
}

void
memcpy_check_region(uint8_t * buf, uint32_t start, uint32_t end) {
    uint8_t * guard_lo = (uint8_t *)((uint64_t)(buf + start) - 4096);
    uint8_t * guard_hi = buf + end;
    for (uint32_t i = 0; i < 4096; ++i) {
        assert(guard_lo[i] == (i % 256));
    }
    for (uint32_t i = start; i < end; ++i) {
        assert(buf[i] == (i % 256));
    }
    for (uint32_t i = 0; i < 4096; ++i) {
        assert(guard_hi[i] == (i % 256));
    }
}
void
memcpy_test() {
    const uint32_t N = 1024;

    uint8_t * buf0 =
        (uint8_t *)mmap(NULL, N * 4096 + 4096, PROT_READ | PROT_WRITE,
                        MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    uint8_t * buf1 =
        (uint8_t *)mmap(NULL, N * 4096 + 4096, PROT_READ | PROT_WRITE,
                        MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);


    assert(buf0 != NULL);
    assert(buf1 != NULL);
    assert(!mprotect(buf0 + N * 4096, 4096, PROT_NONE));
    assert(!mprotect(buf1 + N * 4096, 4096, PROT_NONE));

    for (uint32_t i = 0; i < 4096 * N; ++i) {
        buf0[i] = (i % 256);
    }

    buf1 += 4096;
    buf0 += 4096;




    for (uint32_t off = 0; off < 32; ++off) {
        fprintf(stderr, "%d\n", off);
        for (uint32_t i = 0; i < 8 * 32768; ++i) {
            uint8_t * guard_hi = buf1 + off + i;
            uint8_t * guard_lo = buf1 + off - 4096;
            for(uint32_t j = 0; j < 4096; ++j) {
                guard_hi[j] = j % 256;
            }
            for(uint32_t j = 0; j < 4096; ++j) {
                guard_lo[j] = j % 256;
            }
            
            
            memcpy_avx2(buf1 + off, buf0, i);
            memcpy_check_region(buf1 + off, 0, i);
        }
    }
    for (uint32_t off = 4064; off < 4096; ++off) {
        fprintf(stderr, "%d\n", off);
        for (uint32_t i = 0; i < 8 * 32768; ++i) {
            uint8_t * guard_hi = buf1 + off + i;
            uint8_t * guard_lo = buf1 + off - 4096;
            for(uint32_t j = 0; j < 4096; ++j) {
                guard_hi[j] = j % 256;
            }
            for(uint32_t j = 0; j < 4096; ++j) {
                guard_lo[j] = j % 256;
            }
            
            memcpy_avx2(buf1 + off, buf0, i);
            memcpy_check_region(buf1 + off, 0, i);
        }
    }

    assert(!munmap(buf0, N * 4096 + 4096));
    assert(!munmap(buf1, N * 4096 + 4096));
}

#define TEST_ARGS(X) (X) + 4096, (X)
#define TEST_FUNC    strcpy_avx2
void
perf_S() {
    char * addr = (char *)mmap(NULL, 3 * 4096, PROT_READ | PROT_WRITE,
                               MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    assert(!mprotect(addr + 8192, 4096, PROT_NONE));
    memset(addr, -1, 8192);
    addr[255]          = 0;
    uint64_t cmarks[5] = { 0 };

    cmarks[0] = _rdtsc();
    COMPILER_BARRIER()
    COMPILER_DO_NOT_OPTIMIZE_OUT(TEST_FUNC(TEST_ARGS(addr + 0)));
    COMPILER_BARRIER()
    cmarks[1] = _rdtsc();
    COMPILER_BARRIER()
    COMPILER_DO_NOT_OPTIMIZE_OUT(TEST_FUNC(TEST_ARGS(addr + 32)));
    COMPILER_BARRIER()
    cmarks[2] = _rdtsc();
    COMPILER_BARRIER()
    COMPILER_DO_NOT_OPTIMIZE_OUT(TEST_FUNC(TEST_ARGS(addr + 64)));
    COMPILER_BARRIER()
    cmarks[3] = _rdtsc();
    COMPILER_BARRIER()
    COMPILER_DO_NOT_OPTIMIZE_OUT(TEST_FUNC(TEST_ARGS(addr + 96)));
    COMPILER_BARRIER()
    cmarks[4] = _rdtsc();

    double difs[4];
    for (uint32_t i = 0; i < 4; ++i) {
        difs[i] = (double)(cmarks[i + 1] - cmarks[i]);
    }
    fprintf(stderr,
            "%-10s: %.3E\n"
            "%-10s: %.3E\n"
            "%-10s: %.3E\n"
            "%-10s: %.3E\n",
            "+ 0", difs[0], "+ 32", difs[1], "+ 64", difs[2], "+ 96", difs[3]);


    assert(!munmap(addr, 3 * 4096));
}

int
main(int argc, char ** argv) {
    uint64_t len = argc == 1 ? 10000 : atoi(argv[1]);
    memcpy_test();
    strcpy_test();
    ctest_S();
    perf_S();
}
