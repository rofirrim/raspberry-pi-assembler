.data     /* data section */
.align 4  /* ensure the next label is 4-byte aligned */
message_1: .asciz "Hello\n"
.align 4  /* ensure the next label is 4-byte aligned */
message_2: .asciz "Bonjour\n"

.text     /* text section (= code) */

.align 4  /* ensure the next label is 4-byte aligned */
say_hello:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    /* Prepare the call to printf */
    ldr r0, addr_of_message_1 /* r0 ← &message */
    bl printf                 /* call printf */
    pop {r4, lr}              /* restore r4 and lr */
    bx lr                     /* return to the caller */

.align 4  /* ensure the next label is 4-byte aligned */
addr_of_message_1: .word message_1

.align 4  /* ensure the next label is 4-byte aligned */
say_bonjour:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    /* Prepare the call to printf */
    ldr r0, addr_of_message_2 /* r0 ← &message */
    bl printf                 /* call printf */
    pop {r4, lr}              /* restore r4 and lr */
    bx lr                     /* return to the caller */

.align 4  /* ensure the next label is 4-byte aligned */
addr_of_message_2: .word message_2

.align 4
greeter:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    blx r0                   /* indirect call to r0 */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller */

.globl main /* state that 'main' label is global */
.align 4  /* ensure the next label is 4-byte aligned */
main:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */

    ldr r0, addr_say_hello   /* r0 ← &say_hello */
    bl greeter               /* call greeter */

    ldr r0, addr_say_bonjour /* r0 ← &say_bonjour */
    bl greeter               /* call greeter */

    mov r0, #0               /* return from the program, set error code */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller (the system) */

addr_say_hello : .word say_hello
addr_say_bonjour : .word say_bonjour
