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
    // rsi = char *
START(strcpy_avx2):
    .cfi_startproc
    
    movl %esi, %ecx
    
    // ymm0 = 0s 
    vpxor %xmm0, %xmm0, %xmm0
    
    andl $(PAGE_SIZE - 1), %ecx
    cmpl $(PAGE_SIZE - VEC_SIZE), %ecx
    ja L(CROSS_PAGE)

L(START_CPY):
    vmovdqu (%rsi), %ymm1
    vpcmpeqb %ymm1, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)

    vmovdqu %ymm1, (%rdi)

    andl $(VEC_SIZE - 1), %ecx
    addq $(VEC_SIZE), %rsi
    movl $(VEC_SIZE), %edx
    subl %ecx, %edx
    andq $-(VEC_SIZE), %rsi
    addq %rdx, %rdi
    
    testl $(4 * VEC_SIZE - 1), %esi
    jz L(ALIGNED_128)
    vmovdqa (%rsi), %ymm1
    vpcmpeqb %ymm1, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)
    vmovdqu %ymm1, (%rdi)
    addq $(VEC_SIZE), %rsi
    addq $(VEC_SIZE), %rdi

    testl $(4 * VEC_SIZE - 1), %esi
    jz L(ALIGNED_128)
    vmovdqa (%rsi), %ymm1
    vpcmpeqb %ymm1, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)
    vmovdqu %ymm1, (%rdi)
    addq $(VEC_SIZE), %rsi
    addq $(VEC_SIZE), %rdi

    testl $(4 * VEC_SIZE - 1), %esi
    jz L(ALIGNED_128)
    vmovdqa (%rsi), %ymm1
    vpcmpeqb %ymm1, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)
    vmovdqu %ymm1, (%rdi)
    addq $(VEC_SIZE), %rsi
    addq $(VEC_SIZE), %rdi

L(ALIGNED_128):
    vmovdqa (%rsi), %ymm1
    vmovdqa (VEC_SIZE)(%rsi), %ymm2
    vmovdqa (2 * VEC_SIZE)(%rsi), %ymm3
    vmovdqa (3 * VEC_SIZE)(%rsi), %ymm4
    vpminub %ymm1, %ymm2, %ymm6
    vpminub %ymm3, %ymm4, %ymm7
    vpminub %ymm6, %ymm7, %ymm6
    vpcmpeqb %ymm6, %ymm0, %ymm6
    vptest %ymm6, %ymm6
    jnz L(COMMIT_ALIGNED_128)

    vmovdqu %ymm1, (%rdi)
    vmovdqu %ymm2, (VEC_SIZE)(%rdi)
    vmovdqu %ymm3, (2 * VEC_SIZE)(%rdi)
    vmovdqu %ymm4, (3 * VEC_SIZE)(%rdi)

    addq $(4 * VEC_SIZE), %rsi
    addq $(4 * VEC_SIZE), %rdi
    jmp L(ALIGNED_128)


L(COMMIT_ALIGNED_128):
    vpcmpeqb %ymm1, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)
    vmovdqu %ymm1, (%rdi)
    addq $(VEC_SIZE), %rsi
    addq $(VEC_SIZE), %rdi

    vmovdqa %ymm2, %ymm1
    vpcmpeqb %ymm2, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)
    vmovdqu %ymm1, (%rdi)
    addq $(VEC_SIZE), %rsi
    addq $(VEC_SIZE), %rdi

    vmovdqa %ymm3, %ymm1
    vpcmpeqb %ymm3, %ymm0, %ymm5
    vptest %ymm5, %ymm5
    jnz L(YMM1_RET)
    vmovdqu %ymm1, (%rdi)
    addq $(VEC_SIZE), %rsi
    addq $(VEC_SIZE), %rdi

    vmovdqa %ymm4, %ymm1
    vpcmpeqb %ymm4, %ymm0, %ymm5
    
    .p2align 4
L(YMM1_RET):
    vpmovmskb %ymm5, %edx
    leaq 1(%rdi), %rax
    movl %edi, %ecx
    tzcntl %edx, %edx
    andl $(PAGE_SIZE - 1), %ecx
    addq %rdx, %rax
    cmpl $(PAGE_SIZE - VEC_SIZE), %ecx
    ja L(SMALL_COPIES)

    .p2align
L(YMM1_PARTIAL_STORE):
    leal 1(%edx), %edx
    vmovdqu (%rdi), %ymm5
    vmovd %edx, %xmm6
    vpbroadcastb %xmm6, %ymm6
    vpcmpgtb L(blend_base)(%rip), %ymm6, %ymm6
    vpblendvb %ymm6, %ymm1, %ymm5, %ymm5
    vmovdqu %ymm5, (%rdi)
    vzeroupper
    ret

    
    
L(CROSS_PAGE):
    movq %rsi, %rax
    andq $-(VEC_SIZE), %rax
    vmovdqu (%rax), %ymm1
    vpcmpeqb %ymm1, %ymm0, %ymm5
    vpmovmskb %ymm5, %edx
    sarxl %ecx, %edx, %edx
    testl %edx, %edx
    jz L(START_CPY)

    tzcntl %edx, %edx
    leaq 1(%rdi), %rax
    addq %rdx, %rax

    .p2align 4
L(SMALL_COPIES):
    cmpl $15, %edx
    ja L(COPY17_32)

    cmpl $7, %edx
    ja L(COPY9_16)

    cmpl $3, %edx
    ja L(COPY5_8)
    je L(COPY4)

    cmpl $1, %edx
    ja L(COPY3)
    je L(COPY2)

    movb $0, (%rdi)
    vzeroupper
    ret
    
    .p2align 4
L(COPY2):
    movzwl (%rsi), %ecx
    movw %cx, (%rdi)
    vzeroupper
    ret
L(COPY3):
    movzwl (%rsi), %ecx
    movw %cx, (%rdi)
    movb $0, 2(%rdi)
    vzeroupper
    ret
L(COPY4):
    mov	(%rsi), %ecx
	mov	%ecx, (%rdi)
    vzeroupper
    ret
L(COPY5_8):
    movl (%rsi), %ecx
    mov %ecx, (%rdi)
	mov	-3(%rsi, %rdx), %ecx
	mov	%ecx, -3(%rdi, %rdx)    
    vzeroupper
    ret
L(COPY9_16):
    mov	(%rsi), %rcx
	mov	-7(%rsi, %rdx), %r8
	mov	%rcx, (%rdi)
	mov	%r8, -7(%rdi, %rdx)
    vzeroupper
    ret
L(COPY17_32):
	vmovdqu (%rsi), %xmm2
	vmovdqu -15(%rsi, %rdx), %xmm3
	vmovdqu %xmm2, (%rdi)
	vmovdqu %xmm3, -15(%rdi, %rdx)
    vzeroupper
    ret    

    .cfi_endproc
    END(strcpy_avx2)


    .data
L(blend_base):
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
    .byte 16
    .byte 17
    .byte 18
    .byte 19
    .byte 20
    .byte 21
    .byte 22
    .byte 23
    .byte 24
    .byte 25
    .byte 26
    .byte 27
    .byte 28
    .byte 29
    .byte 30
    .byte 31
    
