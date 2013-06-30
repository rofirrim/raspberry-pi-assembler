/* division.s */

.data

.text

.globl main

unsigned_naive_longdiv:
    /* r0 contains N */
    /* r1 contains D */
    mov r2, r1             /* r2 ← r0. We keep D in r2 */
    mov r1, r0             /* r1 ← r0. We keep N in r1 */

    mov r0, #0             /* r0 ← 0. Set Q = 0 initially */

    b .Lloop_check0
    .Lloop0:
       add r0, r0, #1      /* r0 ← r0 + 1. Q = Q + 1 */
       sub r1, r1, r2      /* r1 ← r1 - r2 */
    .Lloop_check0:
       cmp r1, r2          /* compute r1 - r2 and update cpsr */
       bhs .Lloop0         /* branch if r1 >= r2 (C=0 or Z=1) */

    /* r0 already contains Q */
    /* r1 already contains R */
    bx lr

unsigned_longdiv:
    /* r0 contains N */
    /* r1 contains D */
    /* r2 contains Q */
    /* r3 contains R */
    push {r4, lr}
    mov r2, #0                 /* r2 ← 0 */
    mov r3, #0                 /* r3 ← 0 */

    mov r4, #32                /* r4 ← 32 */
    b .Lloop_check1
    .Lloop1:
        movs r0, r0, LSL #1    /* r0 ← r0 << 1 updating cpsr (sets C if 31st bit of r0 was 1) */
        adc r3, r3, r3         /* r3 ← r3 + r3 + C. This is equivalent to r3 ← (r3 << 1) + C */

        cmp r3, r1             /* compute r3 - r1 and update cpsr */
        subhs r3, r3, r1       /* if r3 >= r1 (C=1) then r3 ← r3 - r1 */
        adc r2, r2, r2         /* r2 ← r2 + r2 + C. This is equivalent to r2 ← (r2 << 1) + C */
    .Lloop_check1:
        subs r4, r4, #1        /* r4 ← r4 - 1 */
        bpl .Lloop1            /* if r4 >= 0 (N=0) then branch to .Lloop1 */

    pop {r4, lr}
    bx lr

better_unsigned_division :
    /* r0 contains N */
    /* r1 contains D */
    /* r2 contains Q */
    /* r3 tmp */

    mov r3, r1                 /* r3 ← r1 */
    cmp r3, r0, LSR #1         /* update cpsr with r3 - 2*r0 */
    .Lloop2:
    movls r3, r3, LSL #1       /* if r3 <= 2*r0 (C=0 or Z=1) then r3 ← 2*r3 */
    cmp r3, r0, LSR #1         /* update cpsr with r3 - 2*r0 */
    bls .Lloop2                /* branch to .Lloop2 if r3 <= 2*r0 (C=0 or Z=1) */

    mov r2, #0                 /* r2 ← 0 */

    .Lloop3:
    cmp r0, r3                 /* update cpsr with r0 - r3 */
    subhs r0, r0, r3           /* if r0 >= r3 then r0 ← r0 - r3 */
    adc r2, r2, r2             /* r2 ← r2 + r2 + C (if r0 >= r3 then C = 1 else C = 0) */

    mov r3, r3, LSR #1         /* r3 ← r3 >> 1 */
    cmp r3, r1                 /* update cpsr with r3 - r1 */
    bhs .Lloop3                /* if r3 >= r1 branch to .Lloop3 */
   
    bx lr

vfpv2_division:
    /* r0 contains N */
    /* r1 contains D */
    vmov s0, r0             /* s0 ← r0 (bit copy) */
    vmov s1, r1             /* s1 ← r1 (bit copy) */
    vcvt.f32.s32 s0, s0     /* s0 ← (float)s0 */
    vcvt.f32.s32 s1, s1     /* s1 ← (float)s1 */
    vdiv.f32 s0, s0, s1     /* s0 ← s0 / s1 */
    vcvt.s32.f32 s0, s0     /* s0 ← (int)s0 */
    vmov r0, s0             /* r0 ← s0 (bit copy). This is Q */
    bx lr

    
main:
    bx lr
