# define VPBROADCAST vpbroadcastb
# define VPCMPEQ vpcmpeqb
# define CHAR_REG sil
# define VZEROUPPER vzeroupper
# define VEC_SIZE 32


# define MIN_VERSION

# define L(name) .L##name

    
    .file "strchr.S"
    .text

    .align 16
    .globl custom_strchr
    .type custom_strchr, @function
custom_strchr:
    .cfi_startproc

    movl %edi, %ecx
    /* Broadcast CHAR to YMM0.  */
    vmovd %esi, %xmm0
    vpxor %xmm9, %xmm9, %xmm9
    VPBROADCAST %xmm0, %ymm0
        /* Check if we may cross page boundary with one vector load.
    */
    andl $(2 * VEC_SIZE - 1), %ecx
    cmpl $VEC_SIZE, %ecx
    ja L(cros_page_boundary)
    /* Check the first VEC_SIZE bytes.  Search for both CHAR and
    the
    null byte.  */
    vmovdqu (%rdi), %ymm8
    VPCMPEQ %ymm8, %ymm0, %ymm1
    VPCMPEQ %ymm8, %ymm9, %ymm2
    vpor %ymm1, %ymm2, %ymm1
        vpmovmskb %ymm1, %eax
        testl %eax, %eax
        jnz L(first_vec_x0)
        /* Align data for aligned loads in the loop.  */
        addq $VEC_SIZE, %rdi
        andl $(VEC_SIZE - 1), %ecx
        andq $-VEC_SIZE, %rdi
        jmp L(more_4x_vec)
        .p2align 4
L(cros_page_boundary):
        andl $(VEC_SIZE - 1), %ecx
        andq $-VEC_SIZE, %rdi
        vmovdqu (%rdi), %ymm8
        VPCMPEQ %ymm8, %ymm0, %ymm1
        VPCMPEQ %ymm8, %ymm9, %ymm2
        vpor %ymm1, %ymm2, %ymm1
        vpmovmskb %ymm1, %eax
        /* Remove the leading bytes.  */
        sarl %cl, %eax
        testl %eax, %eax
        jz L(aligned_more)
        /* Found CHAR or the null byte.  */
        tzcntl %eax, %eax
        addq %rcx, %rax
# ifdef USE_AS_STRCHRNUL
        addq %rdi, %rax
# else
        xorl %edx, %edx
        leaq (%rdi, %rax), %rax
        cmp (%rax), %CHAR_REG
        cmovne %rdx, %rax
# endif
        VZEROUPPER
        ret
        .p2align 4
L(aligned_more):
        addq $VEC_SIZE, %rdi
L(more_4x_vec):
        /* Check the first 4 * VEC_SIZE.  Only one VEC_SIZE at a time
           since data is only aligned to VEC_SIZE.  */
        vmovdqa (%rdi), %ymm8
        VPCMPEQ %ymm8, %ymm0, %ymm1
        VPCMPEQ %ymm8, %ymm9, %ymm2
        vpor %ymm1, %ymm2, %ymm1
        vpmovmskb %ymm1, %eax
        testl %eax, %eax
        jnz L(first_vec_x0)
        vmovdqa VEC_SIZE(%rdi), %ymm8
        VPCMPEQ %ymm8, %ymm0, %ymm1
        VPCMPEQ %ymm8, %ymm9, %ymm2
        vpor %ymm1, %ymm2, %ymm1
        vpmovmskb %ymm1, %eax
        testl %eax, %eax
        jnz L(first_vec_x1)
        vmovdqa (VEC_SIZE * 2)(%rdi), %ymm8
        VPCMPEQ %ymm8, %ymm0, %ymm1
        VPCMPEQ %ymm8, %ymm9, %ymm2
        vpor %ymm1, %ymm2, %ymm1
        vpmovmskb %ymm1, %eax
        testl %eax, %eax
        jnz L(first_vec_x2)
        vmovdqa (VEC_SIZE * 3)(%rdi), %ymm8
        VPCMPEQ %ymm8, %ymm0, %ymm1
        VPCMPEQ %ymm8, %ymm9, %ymm2
        vpor %ymm1, %ymm2, %ymm1
        vpmovmskb %ymm1, %eax
        testl %eax, %eax
        jnz L(first_vec_x3)
        addq $(VEC_SIZE * 4), %rdi
        /* Align data to 4 * VEC_SIZE.  */
        movq %rdi, %rcx
        andl $(4 * VEC_SIZE - 1), %ecx
        andq $-(4 * VEC_SIZE), %rdi
        .p2align 4
L(loop_4x_vec):
        /* Compare 4 * VEC at a time forward.  */
        vmovdqa (%rdi), %ymm5
        vmovdqa VEC_SIZE(%rdi), %ymm6
        vmovdqa (VEC_SIZE * 2)(%rdi), %ymm7
        vmovdqa (VEC_SIZE * 3)(%rdi), %ymm8
# ifdef MIN_VERSION
        vpxor %ymm5, %ymm0, %ymm1
        vpxor %ymm6, %ymm0, %ymm2
        vpxor %ymm7, %ymm0, %ymm3
        vpxor %ymm8, %ymm0, %ymm4

        vpminub %ymm5, %ymm1, %ymm1
        vpminub %ymm6, %ymm2, %ymm2
        vpminub %ymm7, %ymm3, %ymm3
        vpminub %ymm8, %ymm4, %ymm4

        vpminub %ymm1, %ymm2, %ymm5
        vpminub %ymm3, %ymm4, %ymm6

        vpminub %ymm5, %ymm6, %ymm5
        vpcmpeqb %ymm5, %ymm9, %ymm5

        vptest %ymm5, %ymm5
# else
        VPCMPEQ %ymm5, %ymm0, %ymm1
        VPCMPEQ %ymm6, %ymm0, %ymm2
        VPCMPEQ %ymm7, %ymm0, %ymm3
        VPCMPEQ %ymm8, %ymm0, %ymm4
        VPCMPEQ %ymm5, %ymm9, %ymm5
        VPCMPEQ %ymm6, %ymm9, %ymm6
        VPCMPEQ %ymm7, %ymm9, %ymm7
        VPCMPEQ %ymm8, %ymm9, %ymm8
        vpor %ymm1, %ymm5, %ymm1
        vpor %ymm2, %ymm6, %ymm2
        vpor %ymm3, %ymm7, %ymm3
        vpor %ymm4, %ymm8, %ymm4
        vpor %ymm1, %ymm2, %ymm5
        vpor %ymm3, %ymm4, %ymm6
        vpor %ymm5, %ymm6, %ymm5
        vpmovmskb %ymm5, %eax
        testl %eax, %eax
# endif
        jnz L(4x_vec_end)
        addq $(VEC_SIZE * 4), %rdi
        jmp L(loop_4x_vec)
        .p2align 4
L(first_vec_x0):
        /* Found CHAR or the null byte.  */
        tzcntl %eax, %eax
# ifdef USE_AS_STRCHRNUL
        addq %rdi, %rax
# else
        xorl %edx, %edx
        leaq (%rdi, %rax), %rax
        cmp (%rax), %CHAR_REG
        cmovne %rdx, %rax
# endif
        VZEROUPPER
        ret
        .p2align 4
L(first_vec_x1):
        tzcntl %eax, %eax
# ifdef USE_AS_STRCHRNUL
        addq $VEC_SIZE, %rax
        addq %rdi, %rax
# else
        xorl %edx, %edx
        leaq VEC_SIZE(%rdi, %rax), %rax
        cmp (%rax), %CHAR_REG
        cmovne %rdx, %rax

# endif
        VZEROUPPER
        ret
        .p2align 4
L(first_vec_x2):
        tzcntl %eax, %eax
# ifdef USE_AS_STRCHRNUL
        addq $(VEC_SIZE * 2), %rax
        addq %rdi, %rax
# else
        xorl %edx, %edx
        leaq (VEC_SIZE * 2)(%rdi, %rax), %rax
        cmp (%rax), %CHAR_REG
        cmovne %rdx, %rax
# endif
        VZEROUPPER
        ret
        .p2align 4
    L(4x_vec_end):
# ifdef MIN_VERSION
        vpcmpeqb %ymm1, %ymm9, %ymm1
# endif
        vpmovmskb %ymm1, %eax
        testl %eax, %eax
        jnz L(first_vec_x0)
# ifdef MIN_VERSION
        vpcmpeqb %ymm2, %ymm9, %ymm2
# endif
        vpmovmskb %ymm2, %eax
        testl %eax, %eax
        jnz L(first_vec_x1)
# ifdef MIN_VERSION
        vpcmpeqb %ymm3, %ymm9, %ymm3
# endif
        vpmovmskb %ymm3, %eax
        testl %eax, %eax
        jnz L(first_vec_x2)
# ifdef MIN_VERSION
        vpcmpeqb %ymm4, %ymm9, %ymm4
# endif
        vpmovmskb %ymm4, %eax
        testl %eax, %eax
L(first_vec_x3):
        tzcntl %eax, %eax
# ifdef USE_AS_STRCHRNUL
        addq $(VEC_SIZE * 3), %rax
        addq %rdi, %rax
# else
        xorl %edx, %edx
        leaq (VEC_SIZE * 3)(%rdi, %rax), %rax
        cmp (%rax), %CHAR_REG
        cmovne %rdx, %rax
# endif
        VZEROUPPER
        ret

        .cfi_endproc
        .size custom_strchr, .-custom_strchr
