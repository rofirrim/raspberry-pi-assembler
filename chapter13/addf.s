/* -- addf.s */

.data

.align 4
array_of_floats_1: 
.float 1.2, 3.4, 5.6, 7.8, 9.10, 10.11, 12.13, 14.15

.align 4
array_of_floats_2:
.float 0.1, 0.2, 0.3, 0.4, 0.5,   0.6,   0.7,  0.8

.text

.global main
main:
    push {r4, r5, r6, lr}

    ldr r4, addr_of_array_of_floats_1
    fldmias r4, {s8-s15}                  /* Load 8 floats from [r4] to {s8-s15} */

    ldr r4, addr_of_array_of_floats_2
    fldmias r4, {s16-s23}                 /* Load 8 floats from [r4] to {s16-s23} */

    /* Set the LEN field of FPSCR to be 8 (value 7) */
    mov r5, #0b111                        /* r5 ← 7 */
    mov r5, r5, LSL #16                   /* r5 ← r5 << 16 */
    fmrx r4, fpscr                        /* r4 ← fpscr */
    orr r4, r4, r5                        /* r4 ← r4 | r5 */
    fmxr fpscr, r4                        /* fpscr ← r4 */

    fadds s24, s8, s16                    /* {s24-s31} ← {s8-s15} + {s16-s23} */

    /* Set the LEN field of FPSCR back to 1 (value 0) */
    mvn r5, r5                            /* r5 ← ~r5 */
    fmrx r4, fpscr                        /* r4 ← fpscr */
    and r4, r4, r5                        /* r4 ← r4 & r5 */
    fmxr fpscr, r4                        /* fpscr ← r4 */

    pop {r4, r5, r6, lr}
    mov r0, #0
    bx lr

addr_of_array_of_floats_1 : .word array_of_floats_1
addr_of_array_of_floats_2 : .word array_of_floats_2
