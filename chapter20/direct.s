.data     /* data section */
.align 4  /* ensure the next label is 4-byte aligned */
message: .asciz "Hello world\n"

.text     /* text section (= code) */

.align 4  /* ensure the next label is 4-byte aligned */
say_hello:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    /* Prepare the call to printf */
    ldr r0, addr_of_message  /* r0 ← &message */
    bl printf                /* call printf */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller */

.align 4  /* ensure the next label is 4-byte aligned */
addr_of_message: .word message

.globl main /* state that 'main' label is global */
.align 4  /* ensure the next label is 4-byte aligned */
main:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    bl say_hello             /* call say_hello, directly, using the label */

    mov r0, #0               /* return from the program, set error code */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller (the system) */

