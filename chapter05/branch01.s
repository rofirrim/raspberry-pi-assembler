/* -- branch01.s */

.text
.global main
main:
case_a:
    mov r0, #2
    b end
case_b :
    mov r0, #3
end:
    bx lr
