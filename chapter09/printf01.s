/* -- printf01.s */
.data

/* First message */
.balign 4
message1: .asciz "Hey, type a number: "

/* Second message */
.balign 4
message2: .asciz "I read the number %d\n"

/* Format pattern for scanf */
.balign 4
scan_pattern : .asciz "%d"

/* Where scanf will store the number read */
.balign 4
number_read: .word 0

.balign 4
return: .word 0

.text

.global main
main:
    ldr r1, address_of_return        /* r1 ← &address_of_return */
    str lr, [r1]                     /* *r1 ← lr */

    ldr r0, address_of_message1      /* r0 ← &message1 */
    bl printf                        /* call to printf */

    ldr r0, address_of_scan_pattern  /* r0 ← &scan_pattern */
    ldr r1, address_of_number_read   /* r1 ← &number_read */
    bl scanf                         /* call to scanf */

    ldr r0, address_of_message2      /* r0 ← &message2 */
    ldr r1, address_of_number_read   /* r1 ← &number_read */
    ldr r1, [r1]                     /* r1 ← *r1 */
    bl printf                        /* call to printf */

    ldr r0, address_of_number_read   /* r0 ← &number_read */
    ldr r0, [r0]                     /* r0 ← *r0 */

    ldr lr, address_of_return        /* lr ← &address_of_return */
    ldr lr, [lr]                     /* lr ← *lr */
    bx lr                            /* return from main using lr */


address_of_message1 : .word message1
address_of_message2 : .word message2
address_of_scan_pattern : .word scan_pattern
address_of_number_read : .word number_read
address_of_return : .word return

/* External */
.global printf
.global scanf
