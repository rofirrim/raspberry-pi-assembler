.data     /* data section */

.align 4  /* ensure the next label is 4-byte aligned */
message_hello: .asciz "Hello %s\n"
.align 4  /* ensure the next label is 4-byte aligned */
message_bonjour: .asciz "Bonjour %s\n"

/* tags of kind of people */
.align 4  /* ensure the next label is 4-byte aligned */
person_english : .word say_hello /* tag for people
                                     that will be greeted 
                                     in English */
.align 4  /* ensure the next label is 4-byte aligned */
person_french : .word say_bonjour /* tag for people
                                     that will be greeted 
                                     in French */

/* several names to be used in the people definition */
.align 4
name_pierre: .asciz "Pierre"
.align 4
name_john: .asciz "John"
.align 4
name_sally: .asciz "Sally"
.align 4
name_bernadette: .asciz "Bernadette"

/* some people */
.align 4
person_john: .word name_john, person_english
.align 4
person_pierre: .word name_pierre, person_french
.align 4
person_sally: .word name_sally, person_english
.align 4
person_bernadette: .word name_bernadette, person_french

/* array of people */
people : .word person_john, person_pierre, person_sally, person_bernadette

.text     /* text section (= code) */

.align 4  /* ensure the next label is 4-byte aligned */
say_hello:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    /* Prepare the call to printf */
    mov r1, r0               /* r1 ← r0 */
    ldr r0, addr_of_message_hello
                             /* r0 ← &message_hello */
    bl printf                /* call printf */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller */

.align 4  /* ensure the next label is 4-byte aligned */
addr_of_message_hello: .word message_hello

.align 4  /* ensure the next label is 4-byte aligned */
say_bonjour:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */
    /* Prepare the call to printf */
    mov r1, r0               /* r1 ← r0 */
    ldr r0, addr_of_message_bonjour
                             /* r0 ← &message_bonjour */
    bl printf                /* call printf */
    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller */

.align 4  /* ensure the next label is 4-byte aligned */
addr_of_message_bonjour: .word message_bonjour

/* This function receives an address to a person */
.align 4
greet_person:
    push {r4, lr}            /* keep lr because we call printf, 
                                we keep r4 to keep the stack 8-byte
                                aligned, as per AAPCS requirements */

    /* prepare indirect function call */
    mov r4, r0               /* r0 ← r4, keep the first parameter in r4 */
    ldr r0, [r4]             /* r0 ← *r4, this is the address to the name
                                of the person and the first parameter
                                of the indirect called function*/

    ldr r1, [r4, #4]         /* r1 ← *(r4 + 4) this is the address
                                to the person tag */
    ldr r1, [r1]             /* r1 ← *r1, the address of the
                                specific greeting function */

    blx r1                   /* indirect call to r1, this is
                                the specific greeting function */

    pop {r4, lr}             /* restore r4 and lr */
    bx lr                    /* return to the caller */

.globl main /* state that 'main' label is global */
.align 4  /* ensure the next label is 4-byte aligned */
main:
    push {r4, r5, r6, lr}    /* keep callee saved registers that we will modify */

    ldr r4, addr_of_people   /* r4 ← &people */
    /* recall that people is an array of addresses (pointers) to people */

    /* now we loop from 0 to 4 */
    mov r5, #0               /* r5 ← 0 */
    b check_loop             /* branch to the loop check */

    loop:
      /* prepare the call to greet_person */
      ldr r0, [r4, r5, LSL #2]  /* r0 ← *(r4 + r5 << 2)   this is
                                   r0 ← *(r4 + r5 * 4)
                                   recall, people is an array of addresses,
                                   so this is
                                   r0 ← people[r5]
                                */
      bl greet_person           /* call greet_person */
      add r5, r5, #1            /* r5 ← r5 + 1 */
    check_loop:
      cmp r5, #4                /* compute r5 - 4 and update cpsr */
      bne loop                  /* if r5 != 4 branch to loop */

    mov r0, #0               /* return from the program, set error code */
    pop {r4, r5, r6, lr}     /* callee saved registers */
    bx lr                    /* return to the caller (the system) */

addr_of_people : .word people
