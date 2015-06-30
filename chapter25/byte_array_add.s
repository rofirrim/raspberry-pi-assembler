# byte_array_add.s

naive_byte_array_addition:
    /* r0 contains the base address of a */
    /* r1 contains the base address of b */
    /* r2 contains the base address of c */
    /* r3 is N */
    /* r4 is the number of the current item
          so it holds that 0 ≤ r4 < r3 */

    mov r4, #0             /* r4 ← 0 */
    b .Lcheck_loop0        /* branch to check_loop0 */

    .Lloop0:
      ldrb r5, [r0, r4]    /* r5 ← *{unsigned byte}(r0 + r4) */
      ldrb r6, [r1, r4]    /* r6 ← *{unsigned byte}(r1 + r4) */
      add r7, r5, r6       /* r7 ← r5 + r6 */
      strb r7, [r2, r4]    /* *{unsigned byte}(r2 + r4) ← r7 */
      add r4, r4, #1       /* r4 ← r4 + 1 */
    .Lcheck_loop0:
       cmp r4, r3          /* perform r4 - r3 and update cpsr */
       blt .Lloop0         /* if cpsr means that r4 < r3 jump to loop0 */

simd_byte_array_addition_0:
    /* r0 contains the base address of a */
    /* r1 contains the base address of b */
    /* r2 contains the base address of c */
    /* r3 is N */
    /* r4 is the number of the current item
          so it holds that 0 ≤ r4 < r3 */

    mov r4, #0             /* r4 ← 0 */
    b .Lcheck_loop1        /* branch to check_loop1 */

    .Lloop1:
      ldr r5, [r0, r4]     /* r5 ← *(r0 + r4) */
      ldr r6, [r1, r4]     /* r6 ← *(r1 + r4) */
      sadd8 r7, r5, r6     /* r7[7:0] ← r5[7:0] + r6[7:0] */
                           /* r7[15:8] ← r5[15:8] + r6[15:8] */
                           /* r7[23:16] ← r5[23:16] + r6[23:16] */
                           /* r7[31:24] ← r5[31:24] + r6[31:24] */
                           /* r7[x:y] means bits x to y of the register r7 */
      str r7, [r2, r4]     /* *(r2 + r4) ← r7 */
      add r4, r4, #4       /* r4 ← r4 + 4 */
    .Lcheck_loop1:
       cmp r4, r3          /* perform r4 - r3 and update cpsr */
       blt .Lloop1         /* if cpsr means that r4 < r3 jump to loop1 */
     
simd_byte_array_addition_1:
    /* r0 contains the base address of a */
    /* r1 contains the base address of b */
    /* r2 contains the base address of c */
    /* r3 is N */
    /* r4 is the number of the current item
          so it holds that 0 ≤ r4 < r3 */

    mov r4, #0             /* r4 ← 0 */
    sub r8, r3, #3         /* r8 ← r3 - 3
                              this is r8 ← N - 3 */
    b .Lcheck_loop2        /* branch to check_loop2 */

    .Lloop2:
      ldr r5, [r0, r4]     /* r5 ← *(r0 + r4) */
      ldr r6, [r1, r4]     /* r6 ← *(r1 + r4) */
      sadd8 r7, r5, r6     /* r7[7:0] ← r5[7:0] + r6[7:0] */
                           /* r7[15:8] ← r5[15:8] + r6[15:8] */
                           /* r7[23:16] ← r5[23:16] + r6[23:16] */
                           /* r7[31:24] ← r5[31:24] + r6[31:24] */
      str r7, [r2, r4]     /* *(r2 + r4) ← r7 */
      add r4, r4, #4       /* r4 ← r4 + 4 */
    .Lcheck_loop2:
       cmp r4, r8          /* perform r4 - r8 and update cpsr */
       blt .Lloop2         /* if cpsr means that r4 < r8 jump to loop2 */
                           /* i.e. if r4 < N - 3 jump to loop2 */

     /* epilog loop */
     b .Lcheck_loop3       /* branch to check_loop3 */
 
     .Lloop3: 
        ldrb r5, [r0, r4]  /* r5 ← *{unsigned byte}(r0 + r4) */
        ldrb r6, [r1, r4]  /* r6 ← *{unsigned byte}(r1 + r4) */
        add r7, r5, r6     /* r7 ← r5 + r6 */
        strb r7, [r2, r4]  /* *{unsigned byte}(r2 + r4) ← r7 */ 

        add r4, r4, #1     /* r4 ← r4 + 1 */
     .Lcheck_loop3:
        cmp r4, r3         /* perform r4 - r3 and update cpsr */
        blt .Lloop3        /* if cpsr means that r4 < r3 jump to loop 3 */

.global main
main:
    mov r0, #0
    bx lr
