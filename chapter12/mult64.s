/* -- mult64.s */

.data

.align 8
message : .asciz "Multiplication of %d by %d is %lld\n"

.align 4
number_a: .word 987654321
number_b: .word 1234567890

.text

mult64:
   /* The argument will be passed in r0, r1 and r2, r3 and returned in r0, r1 */
   /* Keep the registers that we are going to write */
   push {r4, r5, r6, r7, r8, lr}
   /* For covenience, mov r0,r1 into r4,r5 */
   mov r4, r0   /* r0 ← r4 */
   mov r5, r1   /* r5 ← r1 */

   smull r0, r6, r2, r4    /* r0,r6 ← r2 * r4 */
   smull r7, r8, r3, r4    /* r7,r8 ← r3 * r4 */
   smull r4, r5, r2, r5    /* r4,r5 ← r2 * r5 */
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
   smull r0, r1, r2, r4    /* r0,r1 ← r2 * r4 */
   smlal r1, r6, r3, r4    /* r1 ← r1 + LO(r3*r4). r6 ← r6 + HI(r3*r4) */
   smlal r1, r6, r2, r5    /* r1 ← r1 + LO(r4*r3). r6 ← r6 + HI(r2*r5) */

   /* Restore registers */
   pop {r4, r5, r6, lr}
   bx lr

.global main
main:
    push {r4, r5, r6, lr}       /* Keep the registers we are going to modify */
    /* We have to load the number from memory because the literal value would
       not fit the instruction */
    ldr r4, addr_number_a       /* r4 ← &a  */
    ldr r4, [r4]                /* r4 ← *r4 */
    ldr r5, addr_number_b       /* r5 ← &b  */
    ldr r5, [r5]                /* r5 ← *r5 */

    /* Now prepare the call to mult64
    /* 
       The first number is passed in 
       registers r0,r1 and the second one in r2,r3
       Note that we pass 32-bit numbers, this is why
       the higher register will be zero
    */
    mov r0, r4                  /* r0 ← r4 */
    mov r1, #0                  /* r1 ← 0 */

    mov r2, r5                  /* r2 ← r5 */
    mov r3, #0                  /* r3 ← 0 */

    bl mult64                   /* call mult64 function */
    /* The result of the multiplication is in r0,r1 */
    
    /* Now prepare the call to printf */
    /* We have to pass &message, r4, r5 and r0,r1 */
    /* Because of the calling convention &message and 
       r4, r5 will be passed in registers r0, r1 and r2.
       The result of mult64 (still in r0,r1) must be passed
       in the stack because we ran out registers for passing
       parameters. Technically we still have r3 but
       is not an even numbered register so it cannot have
       the lower part of a 64-bit number (by convention) */
    /* Note that arguments passed in the stack must be pushed
       in reverse order because we want parameters of lower positions
       to be in the stack in lower addresses (by convention) */
    push {r1}                   /* Push r1 onto the stack. 5th parameter */
    push {r0}                   /* Push r0 onto the stack. 4th parameter */
    mov r2, r5                  /* r2 ← r5.                3rd parameter */
    mov r1, r4                  /* r1 ← r4.                2nd parameter */
    ldr r0, addr_of_message     /* r0 ← &message           1st parameter */
    bl printf                   /* Call printf */
    add sp, sp, #8              /* sp ← sp + 8 */
                                /* Pop the two registers we pushed above */

    mov r0, #0                  /* r0 ← 0 */
    pop {r4, r5, r6, lr}        /* Restore registers we kept */
    bx lr                       /* Leave main */

addr_of_message : .word message
addr_number_a: .word number_a
addr_number_b: .word number_b
