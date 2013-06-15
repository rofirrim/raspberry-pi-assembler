/* -- hello01.s */
.data

greeting: 
 .asciz "Hello world"

.balign 4
return: .word 0

.text

.global main
main:
    ldr r1, address_of_return     /*   r1 ← &address_of_return */
    str lr, [r1]                  /*   *r1 ← lr */

    ldr r0, address_of_greeting   /* r0 ← &address_of_greeting */
                                  /* First parameter of puts */

    bl puts                       /* Call to puts */
                                  /* lr ← address of next instruction */

    ldr r1, address_of_return     /* r1 ← &address_of_return */
    ldr lr, [r1]                  /* lr ← *r1 */
    bx lr                         /* return from main */

address_of_greeting: .word greeting
address_of_return: .word return

/* External */
.global puts
