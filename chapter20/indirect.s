.data     /* data section */
.align 4  /* ensure the next label is 4-byte aligned */
message: .asciz "Hello world\n"
.align 4  /* ensure the next label is 4-byte aligned */
ptr_of_fun: .word 0   /* we set its initial value zero */

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

.align 4
make_indirect_call:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    ldr r0, addr_ptr_of_fun  /* r0 ← &ptr_of_fun */
    ldr r0, [r0]             /* r0 ← *r0 */
    blx r0                   /* indirect call to r0 */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller */

.globl main /* state that 'main' label is global */
.align 4  /* ensure the next label is 4-byte aligned */
main:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */

    ldr r1, addr_say_hello   /* r1 ← &say_hello */
    ldr r0, addr_ptr_of_fun  /* r0 ← &addr_ptr_of_fun */
    str r1, [r0]             /* *r0 ← r1
                                this is
                                ptr_of_fun ← &say_hello */

    bl make_indirect_call    /* call make_indirect_call */

    mov r0, #0               /* return from the program, set error code */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller (the system) */

addr_ptr_of_fun: .word ptr_of_fun
addr_say_hello : .word say_hello
