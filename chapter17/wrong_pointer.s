/* wrong_pointer.s */

.data

.align 4
number_1  : .word 3
number_2  : .word 4

.text
.globl main

main:
    ldr r1, address_of_number_2  /* r1 ← &number_2 */
    str r1, pointer_to_number    /* pointer_to_number ← r1, this is pointer_to_number ← &number_2 */

    bx lr

pointer_to_number: .word number_1
address_of_number_2: .word number_2
