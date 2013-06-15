/* -- mult64.s */
.data

.align 8
message : .asciz "Multiplication of %lld by %lld is %lld\n"

.align 4
number_a_low: .word 3755744309
number_a_high: .word 2

number_b_low: .word 12345678
number_b_high: .word 0

.text

mult64:
   /* The argument will be passed in r0, r1 and r2, r3 and returned in r0, r1 */
   /* Keep the registers that we are going to write */
   push {r4, r5, r6, r7, r8, lr}
   /* For covenience, mov r0,r1 into r4,r5 */
   mov r4, r0   /* r0 ← r4 */
   mov r5, r1   /* r5 ← r1 */

   umull r0, r6, r2, r4    /* r0,r6 ← r2 * r4 */
   umull r7, r8, r3, r4    /* r7,r8 ← r3 * r4 */
   umull r4, r5, r2, r5    /* r4,r5 ← r2 * r5 */
   adds r2, r7, r4         /* r2 ← r7 + r4 and update cpsr */
   adc r1, r2, r6          /* r1 ← r2 + r6 + C */

   /* Restore registers */
   pop {r4, r5, r6, r7, r8, lr}
   bx lr                   /* Leave mult64 */

mult64_2:
   /* The argument will be passed in r0, r1 and r2, r3 and returned in r0, r1 */
   /* Keep the registers that we are going to write */
   push {r4, r5, r6, lr}

   /* For convenience, mov r0,r1 into r4,r5 */
   mov r4, r0   /* r0 ← r4 */
   mov r5, r1   /* r5 ← r1 */
   umull r0, r1, r2, r4    /* r0,r1 ← r2 * r4 */
   umlal r1, r6, r3, r4    /* r1 ← r1 + LO(r3*r4). r6 ← r6 + HI(r3*r4) */
   umlal r1, r6, r2, r5    /* r1 ← r1 + LO(r4*r3). r6 ← r6 + HI(r2*r5) */

   /* Restore registers */
   pop {r4, r5, r6, lr}
   bx lr

.global main
main:
    push {r4, r5, r6, r7, r8, lr}       /* Keep the registers we are going to modify */
    /* We have to load the number from memory because the literal value would
       not fit the instruction */
    ldr r4, addr_number_a_low       /* r4 ← &a_low  */
    ldr r4, [r4]                    /* r4 ← *r4 */
    ldr r5, addr_number_a_high      /* r5 ← &a_high  */
    ldr r5, [r5]                    /* r5 ← *r5 */

    ldr r6, addr_number_b_low       /* r6 ← &b_low  */
    ldr r6, [r6]                    /* r6 ← *r6 */
    ldr r7, addr_number_b_high      /* r7 ← &b_high  */
    ldr r7, [r7]                    /* r7 ← *r7 */

    /* Now prepare the call to mult64
    /* 
       The first number is passed in 
       registers r0,r1 and the second one in r2,r3
       Note that we pass 32-bit numbers, this is why
       the higher register will be zero
    */
    mov r0, r4                  /* r0 ← r4 */
    mov r1, r5                  /* r1 ← r5 */

    mov r2, r6                  /* r2 ← r6 */
    mov r3, r7                  /* r3 ← r7 */

    bl mult64                  /* call mult64 function */
    /* The result of the multiplication is in r0,r1 */
    
    /* Now prepare the call to printf */
    /* We have to pass &message, {r4,r5}, {r6,r7} and {r0,r1} */
#    push {r1}                   /* Push r1 onto the stack. 7th parameter */
#    push {r0}                   /* Push r0 onto the stack. 6th parameter */
#    push {r7}                   /* Push r7 onto the stack. 5th parameter */
#    push {r6}                   /* Push r6 onto the stack. 4th parameter */
    push {r0,r1}
    push {r6,r7}
    mov r3, r5                  /* r3 ← r5.                3rd parameter */
    mov r2, r4                  /* r2 ← r4.                2nd parameter */
    ldr r0, addr_of_message     /* r0 ← &message           1st parameter */
    bl printf                   /* Call printf */
    add sp, sp, #16             /* sp ← sp + 16 */
                                /* Pop the two registers we pushed above */

    mov r0, #0                  /* r0 ← 0 */
    pop {r4, r5, r6, r7, r8, lr}        /* Restore registers we kept */
    bx lr                       /* Leave main */

addr_of_message : .word message
addr_number_a_low: .word number_a_low
addr_number_a_high: .word number_a_high

addr_number_b_low: .word number_b_low
addr_number_b_high: .word number_b_high
