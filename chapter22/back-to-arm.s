/* thumb-first.s */

.text

.data
message: .asciz "Hello world %d\n"

.code 16     /* Here we say we will use Thumb */
.align 2     /* Make sure instructions are aligned at 2-byte boundary */
thumb_function:
    push {r4, lr}         /* keep r4 and lr in the stack */
    mov r4, #0            /* r4 ← 0 */
    b check_loop          /* unconditional branch to check_loop */
    loop:             
       /* prepare the call to printf */
       ldr r0, addr_of_message  /* r0 ← &message */
       mov r1, r4               /* r1 ← r4 */
       blx printf               /* From Thumb to ARM we use blx.
                                   printf is a function
                                   in the C library that is implemented
                                   using ARM instructions */
       add r4, r4, #1           /* r4 ← r4 + 1 */
    check_loop:
       cmp r4, #4               /* compute r4 - 4 and update the cpsr */
       blt loop                 /* if the cpsr means that r4 &lt; 4 branch to loop */

    pop {r4, pc}          /* restore registers and return from function */
.align 4
addr_of_message: .word message

.code 32     /* Here we say we will use ARM */
.align 4     /* Make sure instructions are aligned at 4-byte boundary */
.globl main
main:
    push {r4, lr}

    blx thumb_function /* Switch from ARM to Thumb */

    pop {r4, lr}
    bx lr
