#ifndef _FIND_BYTE_H_
#define _FIND_BYTE_H_

#include <immintrin.h>
#include <stdint.h>

enum conf { aligned = 0, non_aligned = 1 };

template<conf data_config = conf::aligned>
struct bseq_ops {

    static uint8_t * __attribute__((pure, noinline))
    _aligned_small_strchr(uint8_t * bytes, uint8_t target) {
        if constexpr (data_config == conf::aligned) {
            bytes = (uint8_t *)__builtin_assume_aligned(bytes, sizeof(__m512i));
        }

#pragma GCC diagnostic ignored "-Wuninitialized"
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
        uint64_t  mask;
        __m512i   cmp_target = _mm512_set1_epi8(target);
        __m512i   tmp0, tmp1;
        __mmask64 k0, k1;
#pragma GCC diagnostic push
#pragma GCC diagnostic push
        asm volatile(
            ".p2align 4\n\t"
            "1:\n\t"

            "vmovdqa64 (%[bytes]), %[tmp0]\n\t"
            "vptestnmb %[tmp0], %[tmp0], %[k0]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[k1]\n\t"

            "addq $64, %[bytes]\n\t"
            "kortestq %[k1], %[k0]\n\t"
            "jz 1b\n\t"

            "subq $64, %[bytes]\n\t"

            "korq %[k1], %[k0], %[k0]\n\t"
            "kmovq %[k0], %[mask]\n\t"

            "tzcntq %[mask], %[mask]\n\t"
            "addq %[mask], %[bytes]\n\t"
            : /* sink mask */
            [ mask ] "=&r"(mask),
            /* tmp zmm registers */
            [ tmp0 ] "=&v"(tmp0), [ tmp1 ] "=&v"(tmp1),
            /* tmp k mask registers */
            [ k0 ] "=&k"(k0), [ k1 ] "=&k"(k1),
            /* current ptr */
            [ bytes ] "+r"(bytes)
            : [ cmp_target ] "v"(cmp_target)
            :);

        return bytes;
    }

    static uint8_t * __attribute__((pure, noinline))
    _aligned_med_strchr(uint8_t * bytes, uint8_t target) {
        if constexpr (data_config == conf::aligned) {
            bytes = (uint8_t *)__builtin_assume_aligned(bytes, sizeof(__m512i));
        }

#pragma GCC diagnostic ignored "-Wuninitialized"
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
        uint64_t  mask;
        __m512i   cmp_target = _mm512_set1_epi8(target);
        __m512i   tmp0, tmp1;
        __mmask64 k0, k1, k2, k3;
#pragma GCC diagnostic push
#pragma GCC diagnostic push
        asm volatile(
            "testq $127, %[bytes]\n\t"
            "jz 2f\n\t"

            // if 64 byte align do one entry to get to 128 byte alignment
            "vmovdqa64 (%[bytes]), %[tmp0]\n\t"
            "vptestnmb %[tmp0], %[tmp0], %[k0]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[k1]\n\t"

            // we need this or because L3 expects final result in k0
            "korq %[k1], %[k0], %[k0]\n\t"

            "kortestq %[k0], %[k0]\n\t"
            "jnz 3f\n\t"

            // align to 128 (relevant if we hit the first case)
            "addq $64, %[bytes]\n\t"

            // main loop doing 128 bytes at a time
            ".p2align 4\n\t"
            "2:\n\t"

            "vmovdqa64 (%[bytes]), %[tmp0]\n\t"
            "vmovdqa64 64(%[bytes]), %[tmp1]\n\t"
            "vptestnmb %[tmp0], %[tmp0], %[k0]\n\t"
            "vptestnmb %[tmp1], %[tmp1], %[k2]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[k1]\n\t"
            "vpcmpeqb %[tmp1], %[cmp_target], %[k3]\n\t"

            "korq %[k1], %[k0], %[k0]\n\t"
            "korq %[k3], %[k2], %[k2]\n\t"

            "addq $128, %[bytes]\n\t"

            // if k2 or k0 done
            "kortestq %[k2], %[k0]\n\t"
            "jz 2b\n\t"
            "subq $128, %[bytes]\n\t"

            // try and get result from k0/k1
            ".p2align 4\n\t"
            "3:\n\t"
            "kmovq %[k0], %[mask]\n\t"
            "testq %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $64, %[bytes]\n\t"
            "kmovq %[k2], %[mask]\n\t"

            "4:\n\t"
            "tzcntq %[mask], %[mask]\n\t"
            "addq %[mask], %[bytes]\n\t"
            : /* sink mask */
            [ mask ] "=&r"(mask),
            /* tmp zmm registers */
            [ tmp0 ] "=&v"(tmp0), [ tmp1 ] "=&v"(tmp1),
            /* tmp k mask registers */
            [ k0 ] "=&k"(k0), [ k1 ] "=&k"(k1), [ k2 ] "=&k"(k2),
            [ k3 ] "=&k"(k3),
            /* current ptr */
            [ bytes ] "+r"(bytes)
            : [ cmp_target ] "v"(cmp_target)
            :);

        return bytes;
    }

    static uint8_t * __attribute__((pure, noinline))
    _aligned_large_strchr(uint8_t * bytes, uint8_t target) {
        if constexpr (data_config == conf::aligned) {
            bytes = (uint8_t *)__builtin_assume_aligned(bytes, sizeof(__m512i));
        }

#pragma GCC diagnostic ignored "-Wuninitialized"
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
        uint64_t  mask;
        __m512i   cmp_target = _mm512_set1_epi8(target);
        __m512i   tmp0, tmp1, tmp2, tmp3;
        __mmask64 k0, k1, k2, k3, k4, k5, k6, k7;
#pragma GCC diagnostic push
#pragma GCC diagnostic push
        asm volatile(
            "testq $255, %[bytes]\n\t"
            "jz 2f\n\t"
            "testq $127, %[bytes]\n\t"
            "jz 1f\n\t"

            // if 64 byte align do one entry to get to 128 byte alignment
            ".p2align 4\n\t"
            "vmovdqa64 (%[bytes]), %[tmp0]\n\t"
            "vptestnmb %[tmp0], %[tmp0], %[k0]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[k1]\n\t"

            // we need this or because L3 expects final result in k0
            "korq %[k1], %[k0], %[k0]\n\t"

            "kortestq %[k0], %[k0]\n\t"
            "jnz 3f\n\t"

            // align to 128 (relevant if we hit the first case)
            "addq $64, %[bytes]\n\t"

            // check if that brings us to 256 alignment
            "testq $255, %[bytes]\n\t"
            "jz 2f\n\t"

            ".p2align 4\n\t"
            "1:\n\t"
            "vmovdqa64 (%[bytes]), %[tmp0]\n\t"
            "vmovdqa64 64(%[bytes]), %[tmp1]\n\t"
            "vptestnmb %[tmp0], %[tmp0], %[k0]\n\t"
            "vptestnmb %[tmp1], %[tmp1], %[k2]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[k1]\n\t"
            "vpcmpeqb %[tmp1], %[cmp_target], %[k3]\n\t"

            "korq %[k1], %[k0], %[k0]\n\t"
            "korq %[k3], %[k2], %[k2]\n\t"

            // if k2 or k0 done
            "kortestq %[k2], %[k0]\n\t"
            "jnz 3f\n\t"

            // align to 256 (relevant if we hit the second case)
            "addq $128, %[bytes]\n\t"

            // main loop doing 256 bytes at a time
            ".p2align 4\n\t"
            "2:\n\t"
            "vmovdqa64 (%[bytes]), %[tmp0]\n\t"
            "vmovdqa64 64(%[bytes]), %[tmp1]\n\t"
            "vmovdqa64 128(%[bytes]), %[tmp2]\n\t"
            "vmovdqa64 192(%[bytes]), %[tmp3]\n\t"
            "vptestnmb %[tmp0], %[tmp0], %[k0]\n\t"
            "vptestnmb %[tmp1], %[tmp1], %[k2]\n\t"
            "vptestnmb %[tmp2], %[tmp2], %[k4]\n\t"
            "vptestnmb %[tmp3], %[tmp3], %[k6]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[k1]\n\t"
            "vpcmpeqb %[tmp1], %[cmp_target], %[k3]\n\t"
            "vpcmpeqb %[tmp2], %[cmp_target], %[k5]\n\t"
            "vpcmpeqb %[tmp3], %[cmp_target], %[k7]\n\t"

            "korq %[k1], %[k0], %[k0]\n\t"
            "korq %[k3], %[k2], %[k2]\n\t"
            "korq %[k5], %[k4], %[k4]\n\t"
            "korq %[k7], %[k6], %[k6]\n\t"

            "korq %[k2], %[k0], %[k1]\n\t"
            "korq %[k6], %[k4], %[k3]\n\t"

            "addq $256, %[bytes]\n\t"

            // if k3 or k1 not 0 done
            "kortestq %[k1], %[k3]\n\t"
            "jz 2b\n\t"
            "subq $256, %[bytes]\n\t"

            // try and get result from k0/k1
            ".p2align 4\n\t"
            "3:\n\t"
            "kmovq %[k0], %[mask]\n\t"
            "testq %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $64, %[bytes]\n\t"
            "kmovq %[k2], %[mask]\n\t"
            "testq %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $64, %[bytes]\n\t"
            "kmovq %[k4], %[mask]\n\t"
            "testq %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $64, %[bytes]\n\t"
            "kmovq %[k6], %[mask]\n\t"

            "4:\n\t"
            "tzcntq %[mask], %[mask]\n\t"
            "addq %[mask], %[bytes]\n\t"
            : /* sink mask */
            [ mask ] "=&r"(mask),
            /* tmp zmm registers */
            [ tmp0 ] "=&v"(tmp0), [ tmp1 ] "=&v"(tmp1), [ tmp2 ] "=&v"(tmp2),
            [ tmp3 ] "=&v"(tmp3),
            /* tmp k mask registers */
            [ k0 ] "=&k"(k0), [ k1 ] "=&k"(k1), [ k2 ] "=&k"(k2),
            [ k3 ] "=&k"(k3), [ k4 ] "=&k"(k4), [ k5 ] "=&k"(k5),
            [ k6 ] "=&k"(k6), [ k7 ] "=&k"(k7),
            /* current ptr */
            [ bytes ] "+r"(bytes)
            : [ cmp_target ] "v"(cmp_target)
            :);

        return bytes;
    }

    static uint8_t * __attribute__((pure, noinline))
    _aligned_strchr_avx2(uint8_t * bytes, uint8_t target) {
        if constexpr (data_config == conf::aligned) {
            bytes = (uint8_t *)__builtin_assume_aligned(bytes, sizeof(__m256i));
        }

#pragma GCC diagnostic ignored "-Wuninitialized"
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
        uint32_t mask;
        __m256i  cmp_target = _mm256_set1_epi8(target);
        __m256i  cmp_zero   = _mm256_set1_epi8(0);
        __m256i  tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
#pragma GCC diagnostic push
#pragma GCC diagnostic push
        asm volatile(
            "testq $127, %[bytes]\n\t"
            "jz 2f\n\t"
            "testq $63, %[bytes]\n\t"
            "jz 1f\n\t"

            // if 64 byte align do one entry to get to 128 byte alignment
            ".p2align 4\n\t"
            "vmovdqa (%[bytes]), %[tmp0]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_zero], %[tmp1]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[tmp0]\n\t"
            "vpor %[tmp0], %[tmp1], %[tmp0]\n\t"

            "vpmovmskb %[tmp0], %[mask]\n\t"

            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            // align to 64 (relevant if we hit the first case)
            "addq $32, %[bytes]\n\t"

            // check if that brings us to 128 alignment
            "testq $127, %[bytes]\n\t"
            "jz 2f\n\t"


            ".p2align 4\n\t"
            "1:\n\t"

            "vmovdqa (%[bytes]), %[tmp0]\n\t"
            "vmovdqa 32(%[bytes]), %[tmp2]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_zero], %[tmp1]\n\t"
            "vpcmpeqb %[tmp2], %[cmp_zero], %[tmp3]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[tmp0]\n\t"
            "vpcmpeqb %[tmp2], %[cmp_target], %[tmp2]\n\t"
            "vpor %[tmp0], %[tmp1], %[tmp0]\n\t"
            "vpor %[tmp2], %[tmp3], %[tmp2]\n\t"

            "vpor %[tmp0], %[tmp2], %[tmp1]\n\t"
            "vptest %[tmp1], %[tmp1]\n\t"
            "jnz 3f\n\t"


            // align to 128 (relevant if we hit the second case)
            "addq $64, %[bytes]\n\t"

            // main loop doing 128 bytes at a time
            ".p2align 4\n\t"
            "2:\n\t"
            "vmovdqa (%[bytes]), %[tmp0]\n\t"
            "vmovdqa 32(%[bytes]), %[tmp2]\n\t"
            "vmovdqa 64(%[bytes]), %[tmp4]\n\t"
            "vmovdqa 96(%[bytes]), %[tmp6]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_zero], %[tmp1]\n\t"
            "vpcmpeqb %[tmp2], %[cmp_zero], %[tmp3]\n\t"
            "vpcmpeqb %[tmp4], %[cmp_zero], %[tmp5]\n\t"
            "vpcmpeqb %[tmp6], %[cmp_zero], %[tmp7]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_target], %[tmp0]\n\t"
            "vpcmpeqb %[tmp2], %[cmp_target], %[tmp2]\n\t"
            "vpcmpeqb %[tmp4], %[cmp_target], %[tmp4]\n\t"
            "vpcmpeqb %[tmp6], %[cmp_target], %[tmp6]\n\t"

            "vpor %[tmp0], %[tmp1], %[tmp0]\n\t"
            "vpor %[tmp2], %[tmp3], %[tmp2]\n\t"
            "vpor %[tmp4], %[tmp5], %[tmp4]\n\t"
            "vpor %[tmp6], %[tmp7], %[tmp6]\n\t"

            "vpor %[tmp0], %[tmp2], %[tmp1]\n\t"
            "vpor %[tmp4], %[tmp6], %[tmp3]\n\t"

            "vpor %[tmp1], %[tmp3], %[tmp1]\n\t"

            "addq $128, %[bytes]\n\t"
            "vptest %[tmp1], %[tmp1]\n\t"
            "jz 2b\n\t"

            "subq $128, %[bytes]\n\t"

            // try and get result from k0/k1
            ".p2align 4\n\t"
            "3:\n\t"
            "vpmovmskb %[tmp0], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $32, %[bytes]\n\t"
            "vpmovmskb %[tmp2], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $32, %[bytes]\n\t"
            "vpmovmskb %[tmp4], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $32, %[bytes]\n\t"
            "vpmovmskb %[tmp6], %[mask]\n\t"

            "4:\n\t"
            "tzcntl %[mask], %[mask]\n\t"
            "addq %q[mask], %[bytes]\n\t"
            : /* sink mask */
            [ mask ] "=&r"(mask),
            /* tmp zmm registers */
            [ tmp0 ] "=&v"(tmp0), [ tmp1 ] "=&v"(tmp1), [ tmp2 ] "=&v"(tmp2),
            [ tmp3 ] "=&v"(tmp3), [ tmp4 ] "=&v"(tmp4), [ tmp5 ] "=&v"(tmp5),
            [ tmp6 ] "=&v"(tmp6), [ tmp7 ] "=&v"(tmp7),
            /* tmp k mask registers */
            /* current ptr */
            [ bytes ] "+r"(bytes)
            : [ cmp_target ] "v"(cmp_target), [ cmp_zero ] "v"(cmp_zero)
            :);

        return bytes;
    }

    static uint8_t * __attribute__((pure, noinline))
    _aligned_strchr_opt_avx2(uint8_t * bytes, uint8_t target) {
        if constexpr (data_config == conf::aligned) {
            bytes = (uint8_t *)__builtin_assume_aligned(bytes, sizeof(__m256i));
        }

#pragma GCC diagnostic ignored "-Wuninitialized"
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
        uint32_t mask;
        __m256i  cmp_target = _mm256_set1_epi8(target);
        __m256i  cmp_zero   = _mm256_set1_epi8(0);
        __m256i  tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7;
#pragma GCC diagnostic push
#pragma GCC diagnostic push
        asm volatile(
            "testq $127, %[bytes]\n\t"
            "jz 2f\n\t"
            "testq $63, %[bytes]\n\t"
            "jz 1f\n\t"

            // if 64 byte align do one entry to get to 128 byte alignment
            "vmovdqa (%[bytes]), %[tmp0]\n\t"
            "vpxor %[tmp0], %[cmp_target], %[tmp1]\n\t"
            "vpminub %[tmp0], %[tmp1], %[tmp0]\n\t"
            "vpcmpeqb %[tmp0], %[cmp_zero], %[tmp0]\n\t"
            "vpmovmskb %[tmp1], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            // align to 64 (relevant if we hit the first case)
            "addq $32, %[bytes]\n\t"

            // check if that brings us to 128 alignment
            "testq $127, %[bytes]\n\t"
            "jz 2f\n\t"


            "1:\n\t"

            "vmovdqa (%[bytes]), %[tmp0]\n\t"
            "vmovdqa 32(%[bytes]), %[tmp2]\n\t"
            "vpxor %[tmp0], %[cmp_target], %[tmp1]\n\t"
            "vpxor %[tmp2], %[cmp_target], %[tmp3]\n\t"
            "vpminub %[tmp0], %[tmp1], %[tmp0]\n\t"
            "vpminub %[tmp2], %[tmp3], %[tmp2]\n\t"
            "vpminub %[tmp0], %[tmp2], %[tmp1]\n\t"
            "vpcmpeqb %[tmp1], %[cmp_zero], %[tmp1]\n\t"

            "vptest %[tmp1], %[tmp1]\n\t"
            "jnz 3f\n\t"


            // align to 128 (relevant if we hit the second case)
            "addq $64, %[bytes]\n\t"

            // main loop doing 128 bytes at a time
            ".p2align 4\n\t"
            "2:\n\t"
            "vmovdqa (%[bytes]), %[tmp0]\n\t"
            "vmovdqa 32(%[bytes]), %[tmp2]\n\t"
            "vmovdqa 64(%[bytes]), %[tmp4]\n\t"
            "vmovdqa 96(%[bytes]), %[tmp6]\n\t"

            "vpxor %[tmp0], %[cmp_target], %[tmp1]\n\t"
            "vpxor %[tmp2], %[cmp_target], %[tmp3]\n\t"
            "vpxor %[tmp4], %[cmp_target], %[tmp5]\n\t"
            "vpxor %[tmp6], %[cmp_target], %[tmp7]\n\t"

            "vpminub %[tmp0], %[tmp1], %[tmp0]\n\t"
            "vpminub %[tmp2], %[tmp3], %[tmp2]\n\t"
            "vpminub %[tmp4], %[tmp5], %[tmp4]\n\t"
            "vpminub %[tmp6], %[tmp7], %[tmp6]\n\t"

            "vpminub %[tmp0], %[tmp2], %[tmp1]\n\t"
            "vpminub %[tmp4], %[tmp6], %[tmp3]\n\t"

            "vpminub %[tmp1], %[tmp3], %[tmp1]\n\t"
            "vpcmpeqb %[tmp1], %[cmp_zero], %[tmp1]\n\t"

            "addq $128, %[bytes]\n\t"
            "vptest %[tmp1], %[tmp1]\n\t"
            "jz 2b\n\t"

            "subq $128, %[bytes]\n\t"

            // try and get result from k0/k1
            ".p2align 4\n\t"
            "3:\n\t"
            "vpcmpeqb %[tmp0], %[cmp_zero], %[tmp0]\n\t"
            "vpmovmskb %[tmp0], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $32, %[bytes]\n\t"
            "vpcmpeqb %[tmp2], %[cmp_zero], %[tmp2]\n\t"
            "vpmovmskb %[tmp2], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $32, %[bytes]\n\t"
            "vpcmpeqb %[tmp4], %[cmp_zero], %[tmp4]\n\t"
            "vpmovmskb %[tmp4], %[mask]\n\t"
            "testl %[mask], %[mask]\n\t"
            "jnz 4f\n\t"

            "addq $32, %[bytes]\n\t"
            "vpcmpeqb %[tmp6], %[cmp_zero], %[tmp6]\n\t"
            "vpmovmskb %[tmp6], %[mask]\n\t"

            "4:\n\t"
            "tzcntl %[mask], %[mask]\n\t"
            "addq %q[mask], %[bytes]\n\t"
            : /* sink mask */
            [ mask ] "=&r"(mask),
            /* tmp zmm registers */
            [ tmp0 ] "=&v"(tmp0), [ tmp1 ] "=&v"(tmp1), [ tmp2 ] "=&v"(tmp2),
            [ tmp3 ] "=&v"(tmp3), [ tmp4 ] "=&v"(tmp4), [ tmp5 ] "=&v"(tmp5),
            [ tmp6 ] "=&v"(tmp6), [ tmp7 ] "=&v"(tmp7),
            /* tmp k mask registers */
            /* current ptr */
            [ bytes ] "+r"(bytes)
            : [ cmp_target ] "v"(cmp_target), [ cmp_zero ] "v"(cmp_zero)
            :);

        return bytes;
    }
};


#endif
