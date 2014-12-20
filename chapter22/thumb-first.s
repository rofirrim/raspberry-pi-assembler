/* thumb-first.s */
.text

.code 16     /* Here we say we will use Thumb */
.align 2     /* Make sure instructions are aligned at 2-byte boundary */

thumb_function:
    mov r0, #2   /* r0 ← 2 */
    bx lr        /* return */

.code 32     /* Here we say we will use ARM */
.align 4     /* Make sure instructions are aligned at 4-byte boundary */

.globl main
main:
    push {r4, lr}

    blx thumb_function /* From ARM to Thumb we use blx */

    pop {r4, lr}
    bx lr
