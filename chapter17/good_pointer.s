/* good_pointer.s */

.data

.align 4
number_1  : .word 3
number_2  : .word 4
pointer_to_number: .word 0

.text
.globl main


main:
    ldr r0, addr_of_pointer_to_number
                             /* r0 ← &pointer_to_number */

    ldr r1, addr_of_number_2 /* r1 ← &number_2 */

    str r1, [r0]             /* *r0 ← r1.
                                This is actually
                                  pointer_to_number ← &number_2 */

    ldr r1, [r0]             /* r1 ← *r0.
                                This is actually
                                  r1 ← pointer_to_number
                                Since pointer_to_number has the value &number_2
                                then this is like
                                  r1 ← &number_2
                             */
                               

    ldr r0, [r1]             /* r0 ← *r1
                                Since r1 had as value &number_2
                                then this is like
                                   r0 ← number_2
                             */

    bx lr

addr_of_pointer_to_number: .word pointer_to_number
addr_of_number_1: .word number_1
addr_of_number_2: .word number_2
