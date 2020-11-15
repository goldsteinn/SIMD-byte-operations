#include "asm-common.h"

#ifndef ONE_PAGE
#define ONE_PAGE 0
#endif
#ifndef ALIGNMENT
#define ALIGNMENT 0
#endif
#ifndef PAGE_SIZE
#define PAGE_SIZE 4096
#endif
#ifndef VEC_SIZE
#define VEC_SIZE 32
#endif
#ifndef LOG_VEC_SIZE
#define LOG_VEC_SIZE 5
#endif

#if PAGE_SIZE != 4096 && PAGE_SIZE != 1048576
#error "PAGE_SIZE must be 4096 or 1048576"
#endif
#if VEC_SIZE != 32
#error "VEC_SIZE must be 32"
#endif
#if LOG_VEC_SIZE != 5
#error "VEC_SIZE must be 5"
#endif

    .file "strlen-avx2"
    .text

    // rdi = char *
START(strlen_avx2):
    .cfi_startproc
    
    movl %edi, %ecx

    // ymm0 = 0s 
    vpxor %xmm0, %xmm0, %xmm0

    // check if first load will cross page boundary
    andl $(PAGE_SIZE - 1), %ecx
    cmpl $(PAGE_SIZE - VEC_SIZE), %ecx
    ja L(CROSS_PAGE)

    vpcmpeqb (%rdi), %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)

    // align rdi
    addq $(VEC_SIZE), %rdi
    andq $-(VEC_SIZE), %rdi

    testq $(4 * VEC_SIZE - 1), %rdi
    jz L(ALIGNED_VEC_SIZE_4x)

    movl %edi, %ecx
    andl $(4 * VEC_SIZE - 1), %ecx

    // aligned 96 
    cmpl $(3 * VEC_SIZE), %ecx
    jz L(ALIGNED_VEC_SIZE_3x)
    
    // aligned 64 
    cmpl $(2 * VEC_SIZE), %ecx
    jz L(ALIGNED_VEC_SIZE_2x)

    // 32 aligned
    vpcmpeqb (%rdi), %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi

    // 64 aligned
L(ALIGNED_VEC_SIZE_2x):
    vpcmpeqb (%rdi), %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi

    // 96 aligned
L(ALIGNED_VEC_SIZE_3x):
    vpcmpeqb (%rdi), %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)

L(ALIGNED_VEC_SIZE_4x_add):
    addq $(VEC_SIZE), %rdi
    
    .p2align 4   
L(ALIGNED_VEC_SIZE_4x):

    // load 4 vecs at a time
    vmovdqa (%rdi), %ymm1
    vmovdqa (VEC_SIZE)(%rdi), %ymm2
    vmovdqa (2 * VEC_SIZE)(%rdi), %ymm3
    vmovdqa (3 * VEC_SIZE)(%rdi), %ymm4

    // select 0s from ymm1 - ymm4
    vpminub %ymm1, %ymm2, %ymm5
    vpminub %ymm3, %ymm4, %ymm6

    vpminub %ymm5, %ymm6, %ymm5

    // cmp for 0s
    vpcmpeqb %ymm5, %ymm0, %ymm5
    
    addq $(4 * VEC_SIZE), %rdi
    vptest %ymm5, %ymm5
    jz L(ALIGNED_VEC_SIZE_4x)

    // we preemptively add 128 in main loop so need to decrement 
    subq $(4 * VEC_SIZE), %rdi

    // ymm1 
    vpcmpeqb %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi

    // ymm2 
    vpcmpeqb %ymm2, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi

    // ymm3 
    vpcmpeqb %ymm3, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi

    // ymm4 
    vpcmpeqb %ymm4, %ymm0, %ymm1
    // ymm4 can just fall through 

L(YMM1_RET):
    vpmovmskb %ymm1, %eax
L(EAX_RET):
    tzcntl %eax, %eax
    addq %rdi, %rax
    vzeroupper
    ret


    // this is pretty cold code
    .p2align 4
L(CROSS_PAGE):
    // store misalignment in ecx 
    andl $(VEC_SIZE - 1), %ecx

    // align rdi 
    andq $-(VEC_SIZE), %rdi

    vpcmpeqb (%rdi), %ymm0, %ymm1
    
    // convert matches to bit vec 
    vpmovmskb %ymm1, %eax

    // drop bits from possible misalignment 
    sarx %ecx, %eax, %eax

    // check if any 1s 
    testl %eax, %eax
    jz L(ALIGNED_VEC_SIZE_4x_add)

    tzcntl %eax, %eax
    addq %rcx, %rdi
    addq %rdi, %rax
    vzeroupper
    ret
    
    .cfi_endproc
    END(strlen_avx2)
