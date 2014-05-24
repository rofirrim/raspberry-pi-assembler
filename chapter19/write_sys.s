/* write_sys.s */

.data


greeting: .asciz "Hello world\n"
after_greeting:

.set size_of_greeting, after_greeting - greeting

.text

.globl main

main:
    push {r4, lr}

    /* Prepare the system call */
    mov r0, #1                  /* r0 ← 1 */
    ldr r1, addr_of_greeting    /* r1 ← &greeting */
    mov r2, #size_of_greeting   /* r2 ← sizeof(greeting) */

    mov r7, #4                  /* select system call 'write' */
    swi #0                      /* perform the system call */

    mov r0, #0
    pop {r4, lr}
    bx lr

addr_of_greeting : .word greeting
