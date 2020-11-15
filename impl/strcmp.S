
        .section .text.avx,"ax",@progbits
ENTRY (STRCMP)

        movl        %edi, %eax
        xorl        %edx, %edx
        /* Make %ymm7 all zeros in this function.  */
        vpxor        %ymm7, %ymm7, %ymm7
        orl        %esi, %eax
        andl        $(PAGE_SIZE - 1), %eax
        cmpl        $(PAGE_SIZE - (VEC_SIZE * 4)), %eax
        jg        L(cross_page)
        /* Start comparing 4 vectors.  */
        vmovdqu        (%rdi), %ymm1
        VPCMPEQ        (%rsi), %ymm1, %ymm0
        VPMINU        %ymm1, %ymm0, %ymm0
        VPCMPEQ        %ymm7, %ymm0, %ymm0
        vpmovmskb %ymm0, %ecx
        testl        %ecx, %ecx
        je        L(next_3_vectors)
        tzcntl        %ecx, %edx

        movzbl        (%rdi, %rdx), %eax
        movzbl        (%rsi, %rdx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(return_vec_size):
        tzcntl        %ecx, %edx

        movzbl        VEC_SIZE(%rdi, %rdx), %eax
        movzbl        VEC_SIZE(%rsi, %rdx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(return_2_vec_size):
        tzcntl        %ecx, %edx

        movzbl        (VEC_SIZE * 2)(%rdi, %rdx), %eax
        movzbl        (VEC_SIZE * 2)(%rsi, %rdx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(return_3_vec_size):
        tzcntl        %ecx, %edx

        movzbl        (VEC_SIZE * 3)(%rdi, %rdx), %eax
        movzbl        (VEC_SIZE * 3)(%rsi, %rdx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(next_3_vectors):
        vmovdqu        VEC_SIZE(%rdi), %ymm6
        VPCMPEQ        VEC_SIZE(%rsi), %ymm6, %ymm3
        VPMINU        %ymm6, %ymm3, %ymm3
        VPCMPEQ        %ymm7, %ymm3, %ymm3
        vpmovmskb %ymm3, %ecx
        testl        %ecx, %ecx
        jne        L(return_vec_size)
        vmovdqu        (VEC_SIZE * 2)(%rdi), %ymm5
        vmovdqu        (VEC_SIZE * 3)(%rdi), %ymm4
        vmovdqu        (VEC_SIZE * 3)(%rsi), %ymm0
        VPCMPEQ        (VEC_SIZE * 2)(%rsi), %ymm5, %ymm2
        VPMINU        %ymm5, %ymm2, %ymm2
        VPCMPEQ        %ymm4, %ymm0, %ymm0
        VPCMPEQ        %ymm7, %ymm2, %ymm2
        vpmovmskb %ymm2, %ecx
        testl        %ecx, %ecx
        jne        L(return_2_vec_size)
        VPMINU        %ymm4, %ymm0, %ymm0
        VPCMPEQ        %ymm7, %ymm0, %ymm0
        vpmovmskb %ymm0, %ecx
        testl        %ecx, %ecx
        jne        L(return_3_vec_size)
L(main_loop_header):
        leaq        (VEC_SIZE * 4)(%rdi), %rdx
        movl        $PAGE_SIZE, %ecx
        /* Align load via RAX.  */
        andq        $-(VEC_SIZE * 4), %rdx
        subq        %rdi, %rdx
        leaq        (%rdi, %rdx), %rax

        addq        %rsi, %rdx
        movq        %rdx, %rsi
        andl        $(PAGE_SIZE - 1), %esi
        /* Number of bytes before page crossing.  */
        subq        %rsi, %rcx
        /* Number of VEC_SIZE * 4 blocks before page crossing.  */
        shrq        $DIVIDE_BY_VEC_4_SHIFT, %rcx
        /* ESI: Number of VEC_SIZE * 4 blocks before page crossing.   */
        movl        %ecx, %esi
        jmp        L(loop_start)
        .p2align 4
L(loop):

        addq        $(VEC_SIZE * 4), %rax
        addq        $(VEC_SIZE * 4), %rdx
L(loop_start):
        testl        %esi, %esi
        leal        -1(%esi), %esi
        je        L(loop_cross_page)
L(back_to_loop):
        /* Main loop, comparing 4 vectors are a time.  */
        vmovdqa        (%rax), %ymm0
        vmovdqa        VEC_SIZE(%rax), %ymm3
        VPCMPEQ        (%rdx), %ymm0, %ymm4
        VPCMPEQ        VEC_SIZE(%rdx), %ymm3, %ymm1
        VPMINU        %ymm0, %ymm4, %ymm4
        VPMINU        %ymm3, %ymm1, %ymm1
        vmovdqa        (VEC_SIZE * 2)(%rax), %ymm2
        VPMINU        %ymm1, %ymm4, %ymm0
        vmovdqa        (VEC_SIZE * 3)(%rax), %ymm3
        VPCMPEQ        (VEC_SIZE * 2)(%rdx), %ymm2, %ymm5
        VPCMPEQ        (VEC_SIZE * 3)(%rdx), %ymm3, %ymm6
        VPMINU        %ymm2, %ymm5, %ymm5
        VPMINU        %ymm3, %ymm6, %ymm6
        VPMINU        %ymm5, %ymm0, %ymm0
        VPMINU        %ymm6, %ymm0, %ymm0
        VPCMPEQ        %ymm7, %ymm0, %ymm0
        /* Test each mask (32 bits) individually because for VEC_SIZE
           == 32 is not possible to OR the four masks and keep all bits
           in a 64-bit integer register, differing from SSE2 strcmp
           where ORing is possible.  */
        vpmovmskb %ymm0, %ecx
        testl        %ecx, %ecx
        je        L(loop)
        VPCMPEQ        %ymm7, %ymm4, %ymm0
        vpmovmskb %ymm0, %edi
        testl        %edi, %edi
        je        L(test_vec)
        tzcntl        %edi, %ecx

        movzbl        (%rax, %rcx), %eax
        movzbl        (%rdx, %rcx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(test_vec):

        VPCMPEQ        %ymm7, %ymm1, %ymm1
        vpmovmskb %ymm1, %ecx
        testl        %ecx, %ecx
        je        L(test_2_vec)
        tzcntl        %ecx, %edi

        movzbl        VEC_SIZE(%rax, %rdi), %eax
        movzbl        VEC_SIZE(%rdx, %rdi), %edx
        subl        %edx, %eax
        VZEROUPPER
        ret
        .p2align 4
L(test_2_vec):

        VPCMPEQ        %ymm7, %ymm5, %ymm5
        vpmovmskb %ymm5, %ecx
        testl        %ecx, %ecx
        je        L(test_3_vec)
        tzcntl        %ecx, %edi

        movzbl        (VEC_SIZE * 2)(%rax, %rdi), %eax
        movzbl        (VEC_SIZE * 2)(%rdx, %rdi), %edx
        subl        %edx, %eax
        VZEROUPPER
        ret
        .p2align 4
L(test_3_vec):

        VPCMPEQ        %ymm7, %ymm6, %ymm6
        vpmovmskb %ymm6, %esi
        tzcntl        %esi, %ecx

        movzbl        (VEC_SIZE * 3)(%rax, %rcx), %eax
        movzbl        (VEC_SIZE * 3)(%rdx, %rcx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(loop_cross_page):
        xorl        %r10d, %r10d
        movq        %rdx, %rcx
        /* Align load via RDX.  We load the extra ECX bytes which should
           be ignored.  */
        andl        $((VEC_SIZE * 4) - 1), %ecx
        /* R10 is -RCX.  */
        subq        %rcx, %r10
        /* This works only if VEC_SIZE * 2 == 64. */

        /* Check if the first VEC_SIZE * 2 bytes should be ignored.  */
        cmpl        $(VEC_SIZE * 2), %ecx
        jge        L(loop_cross_page_2_vec)
        vmovdqu        (%rax, %r10), %ymm2
        vmovdqu        VEC_SIZE(%rax, %r10), %ymm3
        VPCMPEQ        (%rdx, %r10), %ymm2, %ymm0
        VPCMPEQ        VEC_SIZE(%rdx, %r10), %ymm3, %ymm1
        VPMINU        %ymm2, %ymm0, %ymm0
        VPMINU        %ymm3, %ymm1, %ymm1
        VPCMPEQ        %ymm7, %ymm0, %ymm0
        VPCMPEQ        %ymm7, %ymm1, %ymm1
        vpmovmskb %ymm0, %edi
        vpmovmskb %ymm1, %esi
        salq        $32, %rsi
        xorq        %rsi, %rdi
        /* Since ECX < VEC_SIZE * 2, simply skip the first ECX bytes.  */
        shrq        %cl, %rdi
        testq        %rdi, %rdi
        je        L(loop_cross_page_2_vec)
        tzcntq        %rdi, %rcx

        movzbl        (%rax, %rcx), %eax
        movzbl        (%rdx, %rcx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(loop_cross_page_2_vec):
        /* The first VEC_SIZE * 2 bytes match or are ignored.  */
        vmovdqu        (VEC_SIZE * 2)(%rax, %r10), %ymm2
        vmovdqu        (VEC_SIZE * 3)(%rax, %r10), %ymm3
        VPCMPEQ        (VEC_SIZE * 2)(%rdx, %r10), %ymm2, %ymm5
        VPMINU        %ymm2, %ymm5, %ymm5
        VPCMPEQ        (VEC_SIZE * 3)(%rdx, %r10), %ymm3, %ymm6
        VPCMPEQ        %ymm7, %ymm5, %ymm5
        VPMINU        %ymm3, %ymm6, %ymm6
        VPCMPEQ        %ymm7, %ymm6, %ymm6
        vpmovmskb %ymm5, %edi
        vpmovmskb %ymm6, %esi
        salq        $32, %rsi
        xorq        %rsi, %rdi
        xorl        %r8d, %r8d
        /* If ECX > VEC_SIZE * 2, skip ECX - (VEC_SIZE * 2) bytes.  */
        subl        $(VEC_SIZE * 2), %ecx
        jle        1f
        /* Skip ECX bytes.  */
         shrq        %cl, %rdi
        /* R8 has number of bytes skipped.  */
        movl        %ecx, %r8d
1:
        /* Before jumping back to the loop, set ESI to the number of
           VEC_SIZE * 4 blocks before page crossing.  */
        movl        $(PAGE_SIZE / (VEC_SIZE * 4) - 1), %esi
        testq        %rdi, %rdi
        je        L(back_to_loop)
        tzcntq        %rdi, %rcx
        addq        %r10, %rcx
        /* Adjust for number of bytes skipped.  */
        addq        %r8, %rcx

        movzbl        (VEC_SIZE * 2)(%rax, %rcx), %eax
        movzbl        (VEC_SIZE * 2)(%rdx, %rcx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        .p2align 4
L(cross_page_loop):
        /* Check one byte/dword at a time.  */

        subl        %ecx, %eax
        jne        L(different)
        addl        $SIZE_OF_CHAR, %edx
        cmpl        $(VEC_SIZE * 4), %edx
        je        L(main_loop_header)


        movzbl        (%rdi, %rdx), %eax
        movzbl        (%rsi, %rdx), %ecx
        /* Check null char.  */
        testl        %eax, %eax
        jne        L(cross_page_loop)
        /* Since %eax == 0, subtract is OK for both SIGNED and UNSIGNED
           comparisons.  */
        subl        %ecx, %eax

L(different):
        VZEROUPPER
        ret


        .p2align 4
L(last_vector):
        addq        %rdx, %rdi
        addq        %rdx, %rsi

        tzcntl        %ecx, %edx


        movzbl        (%rdi, %rdx), %eax
        movzbl        (%rsi, %rdx), %edx
        subl        %edx, %eax

        VZEROUPPER
        ret
        /* Comparing on page boundary region requires special treatment:
           It must done one vector at the time, starting with the wider
           ymm vector if possible, if not, with xmm. If fetching 16 bytes
           (xmm) still passes the boundary, byte comparison must be done.
         */
        .p2align 4
L(cross_page):
        /* Try one ymm vector at a time.  */
        cmpl        $(PAGE_SIZE - VEC_SIZE), %eax
        jg        L(cross_page_1_vector)
L(loop_1_vector):
        vmovdqu        (%rdi, %rdx), %ymm1
        VPCMPEQ        (%rsi, %rdx), %ymm1, %ymm0
        VPMINU        %ymm1, %ymm0, %ymm0
        VPCMPEQ        %ymm7, %ymm0, %ymm0
        vpmovmskb %ymm0, %ecx
        testl        %ecx, %ecx
        jne        L(last_vector)
        addl        $VEC_SIZE, %edx
        addl        $VEC_SIZE, %eax

        cmpl        $(PAGE_SIZE - VEC_SIZE), %eax
        jle        L(loop_1_vector)
L(cross_page_1_vector):
        /* Less than 32 bytes to check, try one xmm vector.  */
        cmpl        $(PAGE_SIZE - 16), %eax
        jg        L(cross_page_1_xmm)
        vmovdqu        (%rdi, %rdx), %xmm1
        VPCMPEQ        (%rsi, %rdx), %xmm1, %xmm0
        VPMINU        %xmm1, %xmm0, %xmm0
        VPCMPEQ        %xmm7, %xmm0, %xmm0
        vpmovmskb %xmm0, %ecx
        testl        %ecx, %ecx
        jne        L(last_vector)
        addl        $16, %edx
        addl        $16, %eax


L(cross_page_1_xmm):
        /* Less than 16 bytes to check, try 8 byte vector.  NB: No need
           for wcscmp nor wcsncmp since wide char is 4 bytes.   */
        cmpl        $(PAGE_SIZE - 8), %eax
        jg        L(cross_page_8bytes)
        vmovq        (%rdi, %rdx), %xmm1
        vmovq        (%rsi, %rdx), %xmm0
        VPCMPEQ        %xmm0, %xmm1, %xmm0
        VPMINU        %xmm1, %xmm0, %xmm0
        VPCMPEQ        %xmm7, %xmm0, %xmm0
        vpmovmskb %xmm0, %ecx
        /* Only last 8 bits are valid.  */
        andl        $0xff, %ecx
        testl        %ecx, %ecx
        jne        L(last_vector)
        addl        $8, %edx
        addl        $8, %eax

L(cross_page_8bytes):
        /* Less than 8 bytes to check, try 4 byte vector.  */
        cmpl        $(PAGE_SIZE - 4), %eax
        jg        L(cross_page_4bytes)
        vmovd        (%rdi, %rdx), %xmm1
        vmovd        (%rsi, %rdx), %xmm0
        VPCMPEQ        %xmm0, %xmm1, %xmm0
        VPMINU        %xmm1, %xmm0, %xmm0
        VPCMPEQ        %xmm7, %xmm0, %xmm0
        vpmovmskb %xmm0, %ecx
        /* Only last 4 bits are valid.  */
        andl        $0xf, %ecx
        testl        %ecx, %ecx
        jne        L(last_vector)
        addl        $4, %edx

L(cross_page_4bytes):

        /* Less than 4 bytes to check, try one byte/dword at a time.  */


        movzbl        (%rdi, %rdx), %eax
        movzbl        (%rsi, %rdx), %ecx

        testl        %eax, %eax
        jne        L(cross_page_loop)
        subl        %ecx, %eax
        VZEROUPPER
        ret
END (STRCMP)

