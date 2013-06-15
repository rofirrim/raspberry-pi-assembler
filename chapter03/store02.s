/* -- store02.s */

/* -- Data section */
.data

/* Ensure variable is 4-byte aligned */
.balign 4
/* Define storage for myvar1 */
myvar1:
    /* Contents of myvar1 is just '3' */
    .word 3

/* Ensure variable is 4-byte aligned */
.balign 4
/* Define storage for myvar2 */
myvar2:
    /* Contents of myvar2 is just '3' */
    .word 4

/* Ensure variable is 4-byte aligned */
.balign 4
/* Define storage for myvar3 */
myvar3:
    /* Contents of myvar3 is just '0' */
    .word 0

/* -- Code section */
.text

/* Ensure function section starts 4 byte aligned */
.balign 4
.global main
main:
    ldr r1, addr_of_myvar1 /* r1 ← &myvar1 */
    ldr r1, [r1]           /* r1 ← *r1 */
    ldr r2, addr_of_myvar2 /* r2 ← &myvar2 */
    ldr r2, [r2]           /* r1 ← *r2 */
    add r3, r1, r2         /* r3 ← r1 + r2 */
    ldr r4, addr_of_myvar3 /* r4 ← &myvar3 */
    str r3, [r4]           /* *r4 ← r3 */
    /* Clear registers to prove that
       we are actually something
       previously stored */
    mov r0, #0             /* r0 ← 0 */
    mov r1, #0             /* r1 ← 0 */
    mov r2, #0             /* r2 ← 0 */
    mov r3, #0             /* r3 ← 0 */
    mov r4, #0             /* r4 ← 0 */
    
    ldr r0, addr_of_myvar3
    ldr r0, [r0]
    bx lr

/* Labels needed to access data */
addr_of_myvar1 : .word myvar1
addr_of_myvar2 : .word myvar2
addr_of_myvar3 : .word myvar3
