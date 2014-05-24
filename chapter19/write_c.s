/* write_c.s */

.data


greeting: .asciz "Hello world\n"
after_greeting:

.set size_of_greeting, after_greeting - greeting

.text

.globl main

main:
    push {r4, lr}
    mov r0, #1
    ldr r1, addr_of_greeting
    mov r2, #size_of_greeting
    bl write

    mov r0, #0

    pop {r4, lr}
    bx lr

addr_of_greeting : .word greeting
