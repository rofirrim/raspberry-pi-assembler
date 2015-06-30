# motivation.s

naive_channel_mixing:
    /* r0 contains the base address of channel1 */
    /* r1 contains the base address of channel2 */
    /* r2 contains the base address of channel_out */
    /* r3 is the number of samples */
    /* r4 is the number of the current sample
          so it holds that 0 ≤ r4 < r3 */

    mov r4, #0              /* r4 ← 0 */
    b .Lcheck_loop          /* branch to check_loop */
    .Lloop:
      mov r5, r4, LSL #1    /* r5 ← r4 << 1 (this is r5 ← r4 * 2) */
                            /* a halfword takes two bytes, so multiply
                               the index by two. We do this here because
                               ldrsh does not allow an addressing mode
                               like [r0, r5, LSL #1] */
      ldrsh r6, [r0, r5]    /* r6 ← *{signed half}(r0 + r5) */
      ldrsh r7, [r1, r5]    /* r7 ← *{signed half}(r1 + r5) */
      add r8, r6, r7        /* r8 ← r6 + r7 */
      mov r8, r8, LSR #1    /* r8 ← r8 >> 1 (this is r8 ← r8 / 2)*/
      strh r8, [r2, r5]     /* *{half}(r2 + r5) ← r8 */
      add r4, r4, #1        /* r4 ← r4 + 1 */
    .Lcheck_loop:
      cmp r4, r3            /* compute r4 - r3 and update cpsr */
      blt .Lloop            /* if r4 < r3 jump to the
                               beginning of the loop */
      

better_channel_mixing:
    /* r0 contains the base address of channel1 */
    /* r1 contains the base address of channel2 */
    /* r2 contains the base address of channel_out */
    /* r3 is the number of samples */
    /* r4 is the number of the current sample
          so it holds that 0 ≤ r4 < r3 */

    mov r4, #0              /* r4 ← 0 */
    b .Lcheck_loop          /* branch to check_loop */
    .Lloop:
      ldr r6, [r0, r4]      /* r6 ← *(r0 + r4) */
      ldr r7, [r1, r4]      /* r7 ← *(r1 + r4) */
      shadd16 r8, r6, r7    /* r8[15:0] ← (r6[15:0] + r7[15:0]) >> 1*/
                            /* r8[31:16] ← (r6[31:16] + r7[31:16]) >> 1*/
      str r8, [r2, r4]      /* *(r2 + r4) ← r8 */
      add r4, r4, #2        /* r4 ← r4 + 2 */
    .Lcheck_loop:
      cmp r4, r3            /* compute r4 - r3 and update cpsr */
      blt .Lloop            /* if r4 < r3 jump to the
                               beginning of the loop */

.global main
main:
    mov r0, #0
    bx lr
