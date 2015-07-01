
.data
max16bit: .word 32767

.text

clipped_add16bit:
    /* first operand is in r0 */
    /* second operand is in r0 */
    /* result is left in r0 */
    push {r4, lr}             /* keep registers */
 
    ldr r4, addr_of_max16bit  /* r4 ← &max16bit */
    ldr r4, [r4]              /* r4 ← *r4 */
                              /* now r4 == 32767 (i.e. 2^15 - 1) */

    add r0, r0, r1            /* r0 ← r0 + r1 */
    cmp r0, r4                /* perform r0 - r4 and update cpsr */
    movgt r0, r4              /* if r0 > r4 then r0 ← r4 */
    bgt end                   /* if r0 > r4 then branch to end */
    
    mvn r4, r4                /* r4 ← ~r4
                                 now r4 == -32768 (i.e. -2^15) */
    cmp r0, r4                /* perform r0 - r4 and update cpsr */
    movlt r0, r4              /* if r0 < r4 then r0 ← r4 */
  
    end:

    pop {r4, lr}              /* restore registers */
    bx lr                     /* return */
addr_of_max16bit: .word max16bit

.globl main

main:
    mov r0, #0
    bx lr
