/* nested01.s */

.text

f:
    push {r4, r5, fp, lr} /* keep registers */
    mov fp, sp /* keep dynamic link */

    sub sp, sp, #8      /* make room for x (4 bytes)
                           plus 4 bytes to keep stack
                           aligned */
    /* x is in address "fp - 4" */

    mov r4, #1          /* r4 ← 0 */
    str r4, [fp, #-4]   /* x ← r4 */

    bl g                /* call (nested function) g */

    ldr r4, [fp, #-4]   /* r4 ← x */
    add r4, r4, #1      /* r4 ← r4 + 1 */
    str r4, [fp, #-4]   /* x ← r4 */

    mov sp, fp /* restore dynamic link */
    pop {r4, r5, fp, lr} /* restore registers */
    bx lr /* return */

    /* nested function g */
    g:
        push {r4, r5, fp, lr} /* keep registers */
        mov fp, sp /* keep dynamic link */

        /* At this point our stack looks like this

          Data | Address | Notes
         ------+---------+--------------------
           r4  | fp      |  
           r5  | fp + 4  |
           fp  | fp + 8  | This is the old fp
           lr  |
        */

        ldr r4, [fp, #+8] /* get the activation record
                             of my caller
                             (since only f can call me)
                           */

        /* now r4 acts like the fp we had inside 'f' */
        ldr r5, [r4, #-4] /* r5 ← x */
        add r5, r5, #1    /* r5 ← r5 + 1 */
        str r5, [r4, #-4] /* x ← r5 */

        mov sp, fp /* restore dynamic link */
        pop {r4, r5, fp, lr} /* restore registers */
        bx lr /* return */

.globl main

main :
    push {r4, lr} /* keep registers */

    bl f          /* call f */

    mov r0, #0
    pop {r4, lr}
    bx lr
