/* squares.s */

.data

.align 4
message: .asciz "Sum of 1^2 + 2^2 + 3^2 + 4^2 + 5^2 is %d\n"

.text

    
sq: 
  ldr r1, [r0]   /* r1 ← (*r0) */
  mul r1, r1, r1 /* r1 ← r1 * r1 */
  str r1, [r0]   /* (*r0) ← r1 */
  bx lr

sq_sum5:
  push {fp, lr}         /* Keep fp and all callee-saved registers. */
  mov fp, sp            /* Set the dynamic link */

  sub sp, sp, #16      /* sp ← sp - 4. Allocate space for 4 integers in the stack */
  /* Keep parameters in the stack */
  str r0, [fp, #-16]    /* *(fp - 16) ← r0 */
  str r1, [fp, #-12]    /* *(fp - 12) ← r1 */
  str r2, [fp, #-8]     /* *(fp - 8) ← r2 */
  str r3, [fp, #-4]     /* *(fp - 4) ← r3 */

  /* At this point the stack looks like this
     | Value  |  Address(es)
     +--------+-----------------------
     |   r0   |  [fp, #-16], [sp]
     |   r1   |  [fp, #-12], [sp, #4]
     |   r2   |  [fp, #-8],  [sp, #8]
     |   r3   |  [fp, #-4],  [sp, #12]
     |   fp   |  [fp],       [sp, #16]
     |   lr   |  [fp, #4],   [sp, #20]
     |   e    |  [fp, #8],   [sp, #24]
     v
   Higher
   addresses
  */

  sub r0, fp, #16    /* r0 ← fp - 16 */
  bl sq              /* call sq(&a); */
  sub r0, fp, #12    /* r0 ← fp - 12 */
  bl sq              /* call sq(&b); */
  sub r0, fp, #8     /* r0 ← fp - 8 */
  bl sq              /* call sq(&c); */
  sub r0, fp, #4     /* r0 ← fp - 4 */
  bl sq              /* call sq(&d) */
  add r0, fp, #8     /* r0 ← fp + 8 */
  bl sq              /* call sq(&e) */

  ldr r0, [fp, #-16] /* r0 ← *(fp - 16). Loads a into r0 */
  ldr r1, [fp, #-12] /* r1 ← *(fp - 12). Loads b into r1 */
  add r0, r0, r1     /* r0 ← r0 + r1 */
  ldr r1, [fp, #-8]  /* r1 ← *(fp - 8). Loads c into r1 */
  add r0, r0, r1     /* r0 ← r0 + r1 */
  ldr r1, [fp, #-4]  /* r1 ← *(fp - 4). Loads d into r1 */
  add r0, r0, r1     /* r0 ← r0 + r1 */
  ldr r1, [fp, #8]   /* r1 ← *(fp + 8). Loads e into r1 */
  add r0, r0, r1     /* r0 ← r0 + r1 */

  mov sp, fp         /* Undo the dynamic link */
  pop {fp, lr}       /* Restore fp and callee-saved registers */
  bx lr

.globl main

main:
    push {r4, lr}          /* Keep callee-saved registers */

    /* Prepare the call to sq_sum5 */
    mov r0, #1             /* Parameter a ← 1 */
    mov r1, #2             /* Parameter b ← 2 */
    mov r2, #3             /* Parameter c ← 3 */
    mov r3, #4             /* Parameter d ← 4 */

    /* Parameter e goes through the stack,
       so it requires enlarging the stack */
    mov r4, #5             /* r4 ← 5 */
    sub sp, sp, #8         /* Enlarge the stack 8 bytes,
                              we will use only the
                              topmost 4 bytes */
    str r4, [sp]           /* Parameter e ← 5 */
    bl sq_sum5             /* call sq_sum5(1, 2, 3, 4, 5) */
    add sp, sp, #8         /* Shrink back the stack */

    /* Prepare the call to printf */
    mov r1, r0             /* The result of sq_sum5 */
    ldr r0, address_of_message
    bl printf              /* Call printf */

    pop {r4, lr}           /* Restore callee-saved registers */
    bx lr


address_of_message: .word message
