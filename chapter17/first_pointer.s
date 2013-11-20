/* first_pointer.s */

.data

.align 4
number_1  : .word 3

.text
.globl main


main:
    ldr r0, pointer_to_number
    ldr r0, [r0]

    bx lr

pointer_to_number: .word number_1
