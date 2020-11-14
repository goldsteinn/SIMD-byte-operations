#include "asm-common.h"

/*
    strchr using avx2. Performs better than libc version for sizes >
	10^7. You can specify ALIGNMENT 0, 32, 64, 128 or ONE_PAGE 0, 1
	during preprocess for additional optimization.

    ALIGNMENT 0     -> normal strchr
    ALIGNMENT 32    -> assumes input 32 byte aligned
    ALIGNMENT 64    -> assumes input 64 byte aligned
    ALIGNMNET 128   -> assumes input 128 byte aligned

    ONE_PAGE 0      -> search might cross pages
    ONE_PAGE 1      -> assumes search is only on 1 page
*/


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

#if PAGE_SIZE != 4096
#error "PAGE_SIZE must be 4096"
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
    // rsi = char
START(strchr_avx2):
    .cfi_startproc
#if ALIGNMENT <= 32
    movl %edi, %ecx
#endif /* ALIGNMENT != 128 */
    
    // xmm9 = esi 
    // ymm9 = broadcast(xmm9) 
    vmovd %esi, %xmm9
    vpbroadcastb %xmm9, %ymm9
    
    // ymm0 = 0s 
    vpxor %xmm0, %xmm0, %xmm0

    // if we are at the end of a page cant do a full load 
#if ALIGNMENT != 128

#if ALIGNMENT == 0
#if ONE_PAGE == 0
    andl $(PAGE_SIZE - 1), %ecx
    cmpl $(PAGE_SIZE - VEC_SIZE), %ecx
    ja L(cross_page)
#endif /* ONE_PAGE == 0 */

    // not on page bound so safe to load 32 bytes 
    vmovdqu (%rdi), %ymm1

    // cmp vs rsi 
    vpcmpeqb %ymm1, %ymm9, %ymm2
    // cmp vs 0s 
    vpcmpeqb %ymm1, %ymm0, %ymm1

    // combine results 
    vpor %ymm1, %ymm2, %ymm1

    // test if any matches 
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)

    // increment and align 
    addq $(VEC_SIZE), %rdi
    andq $-(VEC_SIZE), %rdi


#endif /* ALIGNMENT == 0 */
    
    // either aligned 32, 64, 96, or 128

    // aligned 128 
    testq $(4 * VEC_SIZE - 1), %rdi
    jz L(ALIGNED_VEC_SIZE_4x)

    // if 64 aligned we only need the 128 check
#if ALIGNMENT <= 32
    // check for 32, 64, 96
    movl %edi, %ecx
    andl $(4 * VEC_SIZE - 1), %ecx

    // aligned 96 
    cmpl $(3 * VEC_SIZE), %ecx
    jz L(ALIGNED_VEC_SIZE_3x)
    
    // aligned 64 
    cmpl $(2 * VEC_SIZE), %ecx
    jz L(ALIGNED_VEC_SIZE_2x)

    vmovdqa (%rdi), %ymm1
    
    vpcmpeqb %ymm1, %ymm9, %ymm2
    vpcmpeqb %ymm1, %ymm0, %ymm1
    
    vpor %ymm1, %ymm2, %ymm1
    
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    
    addq $(VEC_SIZE), %rdi
#endif /* ALIGNMENT <= 32 */
        

// if alignment != 32 we will fall into this
#if ALIGNMENT <= 32
    .p2align 4
L(ALIGNED_VEC_SIZE_2x):
#endif /* ALIGNMENT <= 32 */
    
    vmovdqa (%rdi), %ymm1
    
    vpcmpeqb %ymm1, %ymm9, %ymm2
    vpcmpeqb %ymm1, %ymm0, %ymm1
    
    vpor %ymm1, %ymm2, %ymm1
    
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)

    addq $(VEC_SIZE), %rdi

#if ALIGNMENT <= 32    
    .p2align 4   
L(ALIGNED_VEC_SIZE_3x):
#endif /* ALIGNMENT <= 32 */
    vmovdqa (%rdi), %ymm1
    
    vpcmpeqb %ymm1, %ymm9, %ymm2
    vpcmpeqb %ymm1, %ymm0, %ymm1
    
    vpor %ymm1, %ymm2, %ymm1
    
    vptest %ymm1, %ymm1
    jnz L(YMM1_RET)
    
#if ONE_PAGE == 0
L(ALIGNED_VEC_SIZE_4x_add):
#endif /* ONE_PAGE == 0 */
    addq $(VEC_SIZE), %rdi
#endif /* ALIGNMENT != 128 */
    // main loop 
    .p2align 4   
L(ALIGNED_VEC_SIZE_4x):
    
    // load 4 vectors at once 
    vmovdqa (%rdi), %ymm1
    vmovdqa (VEC_SIZE)(%rdi), %ymm2
    vmovdqa (2 * VEC_SIZE)(%rdi), %ymm3
    vmovdqa (3 * VEC_SIZE)(%rdi), %ymm4
    addq $(4 * VEC_SIZE), %rdi
    
    // esi -> 0s 
    vpxor %ymm1, %ymm9, %ymm5
    vpxor %ymm2, %ymm9, %ymm6
    vpxor %ymm3, %ymm9, %ymm7
    vpxor %ymm4, %ymm9, %ymm8

    // select all 0s 
    vpminub %ymm1, %ymm5, %ymm1
    vpminub %ymm2, %ymm6, %ymm2
    vpminub %ymm3, %ymm7, %ymm3
    vpminub %ymm4, %ymm8, %ymm4

    // merge results 
    vpminub %ymm1, %ymm2, %ymm5
    vpminub %ymm3, %ymm4, %ymm6
    vpminub %ymm5, %ymm6, %ymm5

    // cmp for 0s 
    vpcmpeqb %ymm5, %ymm0, %ymm5

    vptest %ymm5, %ymm5
    jz L(ALIGNED_VEC_SIZE_4x)

    // we preemptively add 128 in main loop so need to decrement 
    subq $(4 * VEC_SIZE), %rdi


    // check if ymm1 -> ymm4 has result 
    // store cmp in ymm1 so L(YMM1_RET) can return 

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

    // impossible to run into page issues if alignment is >= 32 
#if ALIGNMENT == 0
#if ONE_PAGE == 0

    // this is pretty cold code
    .p2align 4
L(cross_page):
    // store misalignment in ecx 
    andl $(VEC_SIZE - 1), %ecx

    // align rdi 
    andq $-(VEC_SIZE), %rdi

    vmovdqa (%rdi), %ymm1
    vpcmpeqb %ymm1, %ymm9, %ymm2
    vpcmpeqb %ymm1, %ymm0, %ymm1
    vpor %ymm1, %ymm2, %ymm1

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
#endif
#endif
    
    .cfi_endproc
    END(strchr_avx2)

