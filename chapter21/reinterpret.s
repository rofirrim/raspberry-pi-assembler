.data

.align 4
a_word: .word 0x11223344

.align 4
message_bytes : .asciz "byte #%d is 0x%x\n"
message_halfwords : .asciz "halfword #%d is 0x%x\n"
message_words : .asciz "word #%d is 0x%x\n"

.text

.globl main
main:
    push {r4, r5, r6, lr}  /* keep callee saved registers */

    ldr r4, addr_a_word    /* r4 ← &a_word */

    mov r5, #0             /* r5 ← 0 */
    b check_loop_bytes     /* branch to check_loop_bytes */

    loop_bytes:
        /* prepare call to printf */
        ldr r0, addr_message_bytes
                           /* r0 ← &message_bytes
                              first parameter of printf */
        mov r1, r5         /* r1 ← r5
                              second parameter of printf */
        ldrb r2, [r4, r5]  /* r2 ← *{byte}(r4 + r5)
                              third parameter of printf */
        bl printf          /* call printf */
        add r5, r5, #1     /* r5 ← r5 + 1 */
    check_loop_bytes:
        cmp r5, #4         /* compute r5 - 4 and update cpsr */
        bne loop_bytes     /* if r5 != 4 branch to loop_bytes */

    mov r5, #0             /* r5 ← 0 */
    b check_loop_halfwords /* branch to check_loop_halfwords */

    loop_halfwords:
        /* prepare call to printf */
        ldr r0, addr_message_halfwords
                           /* r0 ← &message_halfwords
                              first parameter of printf */
        mov r1, r5         /* r1 ← r5
                              second parameter of printf */
        mov r6, r5, LSL #1 /* r6 ← r5 * 2 */
        ldrh r2, [r4, r6]  /* r2 ← *{half}(r4 + r6)
                              this is r2 ← *{half}(r4 + r5 * 2)
                              third parameter of printf */
        bl printf          /* call printf */
        add r5, r5, #1     /* r5 ← r5 + 1 */
    check_loop_halfwords:
        cmp r5, #2         /* compute r5 - 2 and update cpsr */
        bne loop_halfwords /* if r5 != 2 branch to loop_halfwords */

    /* prepare call to printf */
    ldr r0, addr_message_words /* r0 ← &message_words
                                  first parameter of printf */
    mov r1, #0                 /* r1 ← 0
                                  second parameter of printf */
    ldr r2, [r4]               /* r1 ← *r4
                                  third parameter of printf */
    bl printf                  /* call printf */

    pop {r4, r5, r6, lr}   /* restore callee saved registers */
    mov r0, #0             /* set error code */
    bx lr                  /* return to system */

addr_a_word : .word a_word
addr_message_bytes : .word message_bytes
addr_message_halfwords : .word message_halfwords
addr_message_words : .word message_words
