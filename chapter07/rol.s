/* -- rol.s */

.data

.balign 4
value: 
.int 0x12345678

.global main
.text
main:
    ldr r1, .Lcvalue
    ldr r1, [r1]
    mov r1, r1, ROL #1
    mov r1, r1, ROL #31

    eor r0, r0, r0
    bx lr
.Lcvalue: .word value
