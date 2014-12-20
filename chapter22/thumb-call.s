/* thumb-call.s */
.text

.code 16     /* Here we say we will use Thumb */
.align 2     /* Make sure instructions are aligned at 2-byte boundary */

thumb_function_2:
    mov r0, #2
    bx lr   /* A leaf Thumb function (i.e. a function that does not call
               any other function) returns using "bx lr" */

thumb_function_1:
    push {r4, lr}       /* Keep r4 and lr in the stack */
    bl thumb_function_2 /* From Thumb to Thumb we use bl */
    pop {r4, pc}  /* This is how we return from a non-leaf Thumb function */

.code 32     /* Here we say we will use ARM */
.align 4     /* Make sure instructions are aligned at 4-byte boundary */
.globl main
main:
    push {r4, lr}

    blx thumb_function_1 /* From ARM to Thumb we use blx */

    pop {r4, lr}
    bx lr
