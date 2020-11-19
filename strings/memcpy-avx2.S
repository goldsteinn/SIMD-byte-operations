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

#ifndef LARGE_THRESHOLD
#define LARGE_THRESHOLD (4 * 32768)
#endif
    
    
    .file "memcpy-avx2"
    .text

    // rdi = char *
    // rsi = char *
    // rdx = uint64_t
START(memcpy_avx2):
    .cfi_startproc
    prefetcht0 (%rdi)
    prefetcht0 (%rsi)

    cmpq $(VEC_SIZE), %rdx
    jb L(LESS_1x_VEC)
    cmpq $(2 * VEC_SIZE), %rdx
    ja L(MORE_2x_VEC)

L(VEC_COPY_1x_2x):    
    vmovdqu (%rsi), %ymm0
    vmovdqu -(VEC_SIZE)(%rsi, %rdx), %ymm1
    vmovdqu %ymm0, (%rdi)
    vmovdqu %ymm1, -(VEC_SIZE)(%rdi, %rdx)    
    vzeroupper
    ret

L(MORE_2x_VEC):
    cmpq $(VEC_SIZE * 8), %rdx
	ja	L(MORE_8x_VEC)
	cmpq $(VEC_SIZE * 4), %rdx
	jb	L(VEC_COPY_2x_4x)

    vmovdqu (%rsi), %ymm0
    vmovdqu (VEC_SIZE)(%rsi), %ymm1
    vmovdqu (2 * VEC_SIZE)(%rsi), %ymm2
    vmovdqu (3 * VEC_SIZE)(%rsi), %ymm3

    vmovdqu -(VEC_SIZE)(%rsi, %rdx), %ymm4
    vmovdqu -(2 * VEC_SIZE)(%rsi, %rdx), %ymm5
    vmovdqu -(3 * VEC_SIZE)(%rsi, %rdx), %ymm6
    vmovdqu -(4 * VEC_SIZE)(%rsi, %rdx), %ymm7

    vmovdqu %ymm0, (%rdi)
    vmovdqu %ymm1, (VEC_SIZE)(%rdi)
    vmovdqu %ymm2, (2 * VEC_SIZE)(%rdi)
    vmovdqu %ymm3, (3 * VEC_SIZE)(%rdi)

    vmovdqu %ymm4, -(VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm5, -(2 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm6, -(3 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm7, -(4 * VEC_SIZE)(%rdi, %rdx)
    vzeroupper
    ret

L(MORE_8x_VEC):
    prefetcht0 64(%rsi)
    prefetcht0 128(%rsi)
    
    movl %edi, %ecx

    vmovdqu (%rsi), %ymm0
    andl $(VEC_SIZE - 1), %ecx
    subq $(VEC_SIZE), %rcx

    vmovdqu %ymm0, (%rdi)
    addq $(VEC_SIZE), %rdi
    subq %rcx, %rsi
    addq %rcx, %rdx
    andq $-(VEC_SIZE), %rdi
    cmpq $(LARGE_THRESHOLD), %rdx
    ja L(VEC_COPY_LARGE)
    
L(VEC_COPY_4x_LOOP):    
    vmovdqu (%rsi), %ymm0
    vmovdqu (VEC_SIZE)(%rsi), %ymm1
    vmovdqu (2 * VEC_SIZE)(%rsi), %ymm2
    vmovdqu (3 * VEC_SIZE)(%rsi), %ymm3
    addq $(4 * VEC_SIZE), %rsi
    subq $(4 * VEC_SIZE), %rdx

    vmovdqa %ymm0, (%rdi)
    vmovdqa %ymm1, (VEC_SIZE)(%rdi)
    vmovdqa %ymm2, (2 * VEC_SIZE)(%rdi)
    vmovdqa %ymm3, (3 * VEC_SIZE)(%rdi)
    addq $(4 * VEC_SIZE), %rdi
    cmpq $(4 * VEC_SIZE), %rdx
    ja L(VEC_COPY_4x_LOOP)
    
L(VEC_COPY_2x_4x):
    vmovdqu -(VEC_SIZE)(%rsi, %rdx), %ymm0
	vmovdqu -(2 * VEC_SIZE)(%rsi, %rdx), %ymm1
	vmovdqu -(3 * VEC_SIZE)(%rsi,%rdx), %ymm2
	vmovdqu -(4 * VEC_SIZE)(%rsi,%rdx), %ymm3
    
	vmovdqu %ymm0, -(VEC_SIZE)(%rdi, %rdx)
	vmovdqu %ymm1, -(2 * VEC_SIZE)(%rdi, %rdx)
	vmovdqu %ymm2, -(3 * VEC_SIZE)(%rdi,%rdx)
	vmovdqu %ymm3, -(4 * VEC_SIZE)(%rdi,%rdx)
    
L(8x_RET):
	vzeroupper
	ret


L(VEC_COPY_LARGE):
    prefetcht0 196(%rsi)
    prefetcht0 256(%rsi)
    prefetcht0 320(%rsi)
    prefetcht0 384(%rsi)
L(VEC_COPY_LARGE_LOOP):
    vmovdqu (%rsi), %ymm0
    vmovdqu (VEC_SIZE)(%rsi), %ymm1
    vmovdqu (2 * VEC_SIZE)(%rsi), %ymm2
    vmovdqu (3 * VEC_SIZE)(%rsi), %ymm3
    vmovdqu (4 * VEC_SIZE)(%rsi), %ymm4
    vmovdqu (5 * VEC_SIZE)(%rsi), %ymm5
    vmovdqu (6 * VEC_SIZE)(%rsi), %ymm6
    vmovdqu (7 * VEC_SIZE)(%rsi), %ymm7
    
    addq $(8 * VEC_SIZE), %rsi
    subq $(8 * VEC_SIZE), %rdx
    
    vmovntdq %ymm0, (%rdi)
    vmovntdq %ymm1, (VEC_SIZE)(%rdi)
    vmovntdq %ymm2, (2 * VEC_SIZE)(%rdi)
    vmovntdq %ymm3, (3 * VEC_SIZE)(%rdi)
    vmovntdq %ymm4, (4 * VEC_SIZE)(%rdi)
    vmovntdq %ymm5, (5 * VEC_SIZE)(%rdi)
    vmovntdq %ymm6, (6 * VEC_SIZE)(%rdi)
    vmovntdq %ymm7, (7 * VEC_SIZE)(%rdi)
    sfence
    addq $(8 * VEC_SIZE), %rdi
    cmpq $(8 * VEC_SIZE), %rdx
    ja L(VEC_COPY_LARGE_LOOP)
    
    vmovdqu -(1 * VEC_SIZE)(%rsi, %rdx), %ymm0
    vmovdqu -(2 * VEC_SIZE)(%rsi, %rdx), %ymm1
    vmovdqu -(3 * VEC_SIZE)(%rsi, %rdx), %ymm2
    vmovdqu -(4 * VEC_SIZE)(%rsi, %rdx), %ymm3

    vmovdqu -(5 * VEC_SIZE)(%rsi, %rdx), %ymm4
    vmovdqu -(6 * VEC_SIZE)(%rsi, %rdx), %ymm5
    vmovdqu -(7 * VEC_SIZE)(%rsi, %rdx), %ymm6
    vmovdqu -(8 * VEC_SIZE)(%rsi, %rdx), %ymm7
    
    vmovdqu %ymm0, -(1 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm1, -(2 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm2, -(3 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm3, -(4 * VEC_SIZE)(%rdi, %rdx)

    vmovdqu %ymm4, -(5 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm5, -(6 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm6, -(7 * VEC_SIZE)(%rdi, %rdx)
    vmovdqu %ymm7, -(8 * VEC_SIZE)(%rdi, %rdx)
    vzeroupper
    ret
    
L(LESS_1x_VEC):
    movl %edi, %ecx
    orl %esi, %ecx
    andl $(PAGE_SIZE - 1), %ecx
    cmpl $(PAGE_SIZE - VEC_SIZE), %ecx
    ja L(TRUE_SMALL_COPY)
    vmovdqu (%rsi), %ymm0
    vmovdqu (%rdi), %ymm1
    vmovd %edx, %xmm2
    vpbroadcastb %xmm2, %ymm2
    vpcmpgtb L(blend_base)(%rip), %ymm2, %ymm2
    vpblendvb %ymm2, %ymm0, %ymm1, %ymm1
    vmovdqu %ymm1, (%rdi)
    vzeroupper
    ret
    
L(TRUE_SMALL_COPY):    
    cmpl $16, %edx
    jae L(COPY16_31)

    cmpl $8, %edx
    jae L(COPY8_15)

    cmpl $4, %edx
    jae L(COPY4_7)

    cmpl $1, %edx
    ja L(COPY2_3)
    jb L(RET)

    movzbl	(%rsi), %ecx
	movb	%cl, (%rdi)
L(RET):
    ret

L(COPY16_31):
	vmovdqu	(%rsi), %xmm0
	vmovdqu	-16(%rsi,%rdx), %xmm1
	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm1, -16(%rdi,%rdx)
	ret

L(COPY8_15):
	movq	-8(%rsi,%rdx), %rcx
	movq	(%rsi), %rsi
	movq	%rcx, -8(%rdi,%rdx)
	movq	%rsi, (%rdi)
	ret
L(COPY4_7):
	movl	-4(%rsi,%rdx), %ecx
	movl	(%rsi), %esi
	movl	%ecx, -4(%rdi,%rdx)
	movl	%esi, (%rdi)
	ret
L(COPY2_3):
	movzwl	-2(%rsi,%rdx), %ecx
	movzwl	(%rsi), %esi
	movw	%cx, -2(%rdi,%rdx)
	movw	%si, (%rdi)
	ret
    
    .cfi_endproc
    END(memcpy_avx2)

    .section .rodata
    .p2align LOG_VEC_SIZE
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
    
