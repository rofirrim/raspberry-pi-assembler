.data

.align 4
one_byte: .byte 205

.align 4
one_halfword: .hword 42445

.text

.globl main
main:
    push {r4, lr}

    ldr r0, addr_of_one_byte     /* r0 ← &one_byte */
    ldrb r0, [r0]                /* r0 ← *{byte}r0 */

    ldr r1, addr_of_one_halfword /* r1 ← &one_halfword */
    ldrh r1, [r1]                /* r1 ← *{half}r1 */

    pop {r4, lr}
    mov r0, #0
    bx lr

addr_of_one_byte: .word one_byte
addr_of_one_halfword: .word one_halfword
