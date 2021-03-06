#ifndef _ASM_COMMON_H_
#define _ASM_COMMON_H_

#define AVX2_SIZE   32
#define AVX512_SIZE 64

#define L(name) .L##name

// clang-format off
#define START(name)                             \
    .align 16;                                  \
    .globl name;                                \
    .type name, @function;                      \
    name

    


#define END(name)                               \
    .size name, .-name

// clang-format on


#endif
