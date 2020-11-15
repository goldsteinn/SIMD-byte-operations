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
#ifndef LOG_4_VEC
#define LOG_4_VEC (LOG_VEC_SIZE + 2)
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

    .file "strchr-avx2.S"
    .text

    // rdi = char * 
    // rsi = char *
START(strcmp_avx2):
    .cfi_startproc

    movl %edi, %ecx
    movl %esi, %edx
    andl $(PAGE_SIZE - 1), %edx
    
    // ymm0 = 0s 
    vpxor %xmm0, %xmm0, %xmm0

    cmpl $(PAGE_SIZE - (VEC_SIZE - 1), %edx
    ja L(CROSS_PAGE_1x_FIRST)

    cmpl $(PAGE_SIZE - (4 * VEC_SIZE - 1), %edx
    ja L(CROSS_PAGE_4x_FIRST)


    // fall through not page crosses
L(PREP_RDI):
    vmovdqu (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm5
    vpminub %ymm1, %ymm5, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)

    // get diff for rdi till next vec alignment
    notq %ecx
    andl $(VEC_SIZE - 1), %ecx

    // align rdi
    addq %rcx, %rdi

    // increment rsi by same amount
    addq %rcx, %rsi

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
    vmovdqa (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm2
    vpminub %ymm1, %ymm2, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi
    addq $(VEC_SIZE), %rsi
    
L(ALIGNED_VEC_SIZE_2x):
    // 64 aligned
    vmovdqa (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm2
    vpminub %ymm1, %ymm2, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi
    addq $(VEC_SIZE), %rsi

L(ALIGNED_VEC_SIZE_3x):
    // 96 aligned
    vmovdqa (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm2
    vpminub %ymm1, %ymm2, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi
    addq $(VEC_SIZE), %rsi

L(PREP_4x_LOOP):
    // create a counter till next cross page load for rsi
    // + 128 because we decl at start of loop
    movl $(PAGE_SIZE + 128), %edx
    movl %esi, %ecx
    andl $(PAGE_SIZE - 1), %ecx
    subl %ecx, %edx

    // edx stores the counter
    sarl $(LOG_4_VEC), %edx

    .p2align 4
L(TEST_4x_LOOP):
    decl %edx
    jz L(CROSS_PAGE_4x)
L(ALIGNED_VEC_SIZE_4x):

    // load ymm1, ymm2 from rdi
    vmovdqa (%rdi), %ymm1
    vmovdqa (VEC_SIZE)(%rdi), %ymm2

    // CMP for equality with rsi
    vpcmpeqb (%rsi), %ymm1, %ymm5
    vpcmpeqb (VEC_SIZE)(%rsi), %ymm2, %ymm6

    // select 0s
    vpminub %ymm1, %ymm5, %ymm1
    vpminub %ymm2, %ymm6, %ymm2

    // repeat on ymm3, ymm4
    vmovdqa (2 * VEC_SIZE)(%rdi), %ymm3

    // interleave with min to avoid p01 execution unit bottleneck
    vpminub %ymm1, %ymm2, %ymm5
    
    vmovdqa (3 * VEC_SIZE)(%rdi), %ymm4
    vpcmpeqb (2 * VEC_SIZE)(%rsi), %ymm3, %ymm7
    vpcmpeqb (3 * VEC_SIZE)(%rsi), %ymm4, %ymm8
    vpminub %ymm3, %ymm7, %ymm3
    vpminub %ymm4, %ymm8, %ymm4

    // merge ymm1 - ymm4
    vpminub %ymm3, %ymm4, %ymm7
    vpminub %ymm5, %ymm7, %ymm5

    // test for any 0s in result
    vpcmpeqb %ymm5, %ymm0, %ymm5

    addq $(4 * VEC_SIZE), %rdi
    addq $(4 * VEC_SIZE), %rsi
    vptest %ymm5, %ymm5
    jz L(TEST_4x_LOOP)

    // stores amount we need to decr rdi / rsi by
    movl $(4 * VEC_SIZE), %eax

    // ymm1
    vpcmpeqb %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(DEC_YMM1_RET)
    movl $(3 * VEC_SIZE), %eax
    
    // ymm2 
    vpcmpeqb %ymm2, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(DEC_YMM1_RET)
    movl $(2 * VEC_SIZE), %eax

    // ymm3 
    vpcmpeqb %ymm3, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(DEC_YMM1_RET)
    movl $(VEC_SIZE), %eax

    // ymm4 
    vpcmpeqb %ymm4, %ymm0, %ymm1

L(DEC_YMM1_RET):
    subq %rax, %rdi
    subq %rax, %rsi
    
L(YMM1_RET):
    vpmovmskb %ymm1, %eax
L(EAX_RET):
    tzcntl %eax, %eax
    movzbl        (%rdi, %eax), %ecx
    movzbl        (%rsi, %eax), %eax
    subl %ecx, %eax
    vzeroupper
    ret

    
    .p2align 4
L(CROSS_PAGE_1x_FIRST):
    // this is only called from first load, we don't know if rdi is at
	// begining / end of a page so its requires so especially careful
	// and slow logic

    // coming in we have
    // edx = rsi % PAGE_SIZE
    // ecx = rdi

    // edx stores amount we need to subtract from rsi for safe load
    andl $(VEC_SIZE - 1), %edx

    // ecx stores amount of space we have to subtract from rdi
    andl $(PAGE_SIZE - 1), %ecx

    // check if can do load by subtracting from rdi
    cmpl %ecx, %edx
    // cant subtract from rdi ecx < edx
    ja L(CROSS_PAGE_NO_PREV_LOAD)

    // can safely load from rdi - rdx
    subq %rdx, %rdi
    subq %rdx, %rsi

    // aligned load from rsi
    vmovdqa (%rsi), %ymm1
    vcmpeqb (%rdi), %ymm1, %ymm2
    vpminub %ymm1, %ymm2, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vpmovmskb %ymm1, %eax
    sarx %edx, %eax, %eax
    testl %eax, %eax
    jnz L(EAX_RET)

    addq $(VEC_SIZE), %rdi
    addq $(VEC_SIZE), %rsi
    jmp L(PREP_RDI)

    // if rdi is at the start of a page we cant subtract to store
L(CROSS_PAGE_NO_PREV_LOAD):
    // use xmm so we can adjust with prsldq
    andl $((VEC_SIZE / 2) - 1), %edx
    andq $-(VEC_SIZE / 2), %rsi

    vmovdqa (%rsi), %xmm1
    
    vcmpeqb (%rdi), %xmm1, %xmm2
    vpminub %ymm1, %ymm2, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vpmovmskb %ymm1, %eax
    

    
    

    .cfi_endproc
    END(strchr_avx2)
