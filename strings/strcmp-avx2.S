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
    andl $(PAGE_SIZE - 1), %ecx
    andl $(PAGE_SIZE - 1), %edx
    
    // ymm0 = 0s 
    vpxor %xmm0, %xmm0, %xmm0

    cmpl $(PAGE_SIZE - (VEC_SIZE - 1), %ecx
    ja L(CROSS_PAGE_1x_FIRST)

    cmpl $(PAGE_SIZE - (VEC_SIZE - 1), %edx
    ja L(CROSS_PAGE_1x_FIRST_RSI)

    cmpl $(PAGE_SIZE - (4 * VEC_SIZE - 1), %edx
    ja L(CROSS_PAGE_4x_FIRST)

    // fall through not page crosses    
L(LOAD_PREP_RDI):
    vmovdqu (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm5
    vpminub %ymm1, %ymm5, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)

L(PREP_RDI):
    // get diff for rdi till next vec alignment
    negl %ecx
    andl $(VEC_SIZE - 1), %ecx

    // align rdi
    addq %rcx, %rdi

    // increment rsi by same amount
    addq %rcx, %rsi    

L(ALIGN_RDI):    
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
    // 2 loads to get both rdi and rsi past page
L(CROSS_PAGE_2x_FIRST):
    // ecx and edx as misalignments
    andl $(VEC_SIZE - 1), %ecx
    andl $(VEC_SIZE - 1), %edx

    // store max misalignment in r10
    movq %rcx, %r10
    cmpl %ecx, %edx

    // if same jump to second load (r10 will be correct)
    jz L(CROSS_PAGE_2x_L2)
    cmova %rdx, %r10

    // r8 / r9 as temporaries (already stored)
    subq %r10, %r8
    subq %r10, %r9

    // comparison 
    vmovdqu (%r8), %ymm1
    vcmpeqb (%r9), %ymm1, %xmm2
    vpminub %xmm1, %xmm2, %xmm1
    vpcmpeq %xmm1, %xmm0, %xmm1
    vpmovmskb %ymm1, %eax
    sarxq %r10, %rax, %rax
    testl %eax, %eax
    jnz L(EAX_RET)

    // start computing next misalignment
    movq %rcx, %r8
    cmpl %ecx, %edx
    cmovb %rdx, %r8

    // adjust rdi and rsi
    negq %r10
    andq $(VEC_SIZE - 1), %r10
    addq %r10, %rdi
    addq %r10, %rsi

    // compute next misalignment. r8 stores previous minimum
	// misalignment, r10 amount of bytes just compared, so r8 + r10
	// is next
    addq %r10, %r8
    movq %r8, %r10

L(CROSS_PAGE_2x_L2):
    // new temporaries with adjusted rdi / rsi
    movq %rdi, %r8
    movq %rsi, %r9
    subq %r10, %r8
    subq %r10, %r9

    // comparison
    vmovdqu (%r8), %ymm1
    vcmpeqb (%r9), %ymm1, %xmm2
    vpminub %xmm1, %xmm2, %xmm1
    vpcmpeq %xmm1, %xmm0, %xmm1
    vpmovmskb %ymm1, %eax
    sarxq %r10, %rax, %rax
    testl %eax, %eax
    jnz L(EAX_RET)

    // adjust rdi and rsi (both on fresh page now)
    negq %r10
    andq $(VEC_SIZE - 1), %r10
    addq %r10, %rdi
    addq %r10, %rsi

    // ecx needs to be misaligned (relative to VEC_SIZE)
	// for LOAD_PREP_RDI
    movl %edi, %ecx
    movl %esi, %edx
    jmp L(LOAD_PREP_RDI)

    .p2align 4
L(CROSS_PAGE_1x_FIRST_RSI):
    movq %rdi, %r9
    movq %rsi, %r8

    movl %ecx, %eax
    movl %edx, %ecx
    movl %eax, %edx
    jmp L(CROSS_PAGE_1x_FIRST_START)


    // called is rsi will cross page
    .p2align 4
L(CROSS_PAGE_1x_FIRST):
    
    // coming in we have
    // edx = rsi % PAGE_SIZE
    // ecx = rdi % PAGE_SIZE

    // temporaries so we can use same logic for either rdi or rsi
	// crossing. 
    movq %rdi, %r8
    movq %rsi, %r9


    // both rsi and rdi cross page
    cmpl $(PAGE_SIZE - VEC_SIZE), %edx
    L(CROSS_PAGE_2x_FIRST)

    .p2align 4
L(CROSS_PAGE_1x_FIRST_START):
    // r9 stores ptr crossing page, r8 ptr not crossing page

    // ecx stores amount we need to subtract from rsi for safe load
    andl $(VEC_SIZE - 1), %ecx

    // check if can do load by subtracting from rdi
    cmpl %edx, %ecx
    // cant subtract from r8 edx < ecx
    ja L(CROSS_PAGE_NO_PREV_LOAD)

    // can safely load from r8 - rcx
    subq %rcx, %r8
    subq %rcx, %r9

    // aligned load from rsi
    vmovdqa (%r9), %ymm1
    vcmpeqb (%r8), %ymm1, %ymm2
    vpminub %ymm1, %ymm2, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vpmovmskb %ymm1, %eax
    sarx %ecx, %eax, %eax
    testl %eax, %eax
    jnz L(EAX_RET)

    // this will align rdi
    jmp L(PREP_RDI)


    // if r8 is at the start of a page we cant subtract to store
    .p2align 4
L(CROSS_PAGE_NO_PREV_LOAD):
    // use xmm so we can adjust with shuffle
    cmpl $(VEC_SIZE / 2), %ecx
    jb L(CROSS_PAGE_SHUF_CMP)
    
    andq $-(VEC_SIZE / 2), %r9

    // fall through we can load xmm without hitting page
    vmovdqu (%r9), %xmm1
    vcmpeqb (%r8), %xmm1, %xmm2
    vpminub %xmm1, %xmm2, %xmm1
    vpcmpeq %xmm1, %xmm0, %xmm1
    vptest %xmm1, %xmm1
    jnz L(YMM1_RET)

    cmpl $(VEC_SIZE / 2), %ecx
    jz L(PREP_RDI)

    movl %ecx, %edx
    andl $((VEC_SIZE / 2) - 1), %edx

    addq $(VEC_SIZE / 2), %r8
    addq $(VEC_SIZE / 2), %r9

    .p2align 4
L(CROSS_PAGE_NO_PREV_SHUF_CMP):

    // creates a shuffle mask that will shift valid bytes to front
    vmovd %edx, %xmm3
    vpbroadcastb %xmm3, %xmm3
    vpaddb L(shuf_base)(%rip), %xmm3, %xmm3

    andq $-(VEC_SIZE / 2), %r9
    
    vmovdqu (%r9), %xmm1
    vpshufb %xmm3, %xmm1, %xmm1
    vcmpeqb (%r8), %xmm1, %xmm2
    vpminub %xmm1, %xmm2, %xmm1
    vpcmpeq %xmm1, %xmm0, %xmm1
    vpmovmskb %xmm1, %eax

    // process mask to remove bits from bytes that were shuffled to
	// the top and subtract edx to rdi to account for the change in
	// tzcntl result from the shift
    salx %edx, %eax, %eax
    movzwl %ax, %eax
    tesl %eax, %eax
    jnz L(EAX_RET)

    jmp L(PREP_RDI)

L(CROSS_PAGE_4x_FIRST):
    vmovdqu (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm5
    vpminub %ymm1, %ymm5, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    
    negl %ecx
    andl $(VEC_SIZE - 1), %ecx
    addq %rcx, %rdi
    addq %rcx, %rsi
    addl %ecx, %edx
    
    testl $(VEC_SIZE - 1), %edx
    jz L(ALIGN_RDI)
    
    cmpl $(PAGE_SIZE - VEC_SIZE), %edx
    ja L(CROSS_PAGE_4x_CROSS)
L(CROSS_PAGE_4x_LOOP_START)    
    vmovdqa (%rdi), %ymm1
    vcmpeqb (%rsi), %ymm1, %ymm5
    vpminub %ymm1, %ymm5, %ymm1
    vpcmpeq %ymm1, %ymm0, %ymm1
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    addq $(VEC_SIZE), %rdi
    addq $(VEC_SIZE), %rsi
    addl $(VEC_SIZE), %edx
    cmpl $(PAGE_SIZE - VEC_SIZE), %edx
    jb L(CROSS_PAGE_4x_LOOP_START)

    


    
    
    .cfi_endproc
    END(strchr_avx2)

    .data
L(shuf_base):
    .byte 0
    .byte 1
    .byte 2
    .byte 3
    .byte 4
    .byte 5
    .byte 6
    .byte 7
    .byte 8
    .byte 9
    .byte 10
    .byte 11
    .byte 12
    .byte 13
    .byte 14
    .byte 15
    
