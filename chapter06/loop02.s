/* -- loop02.s */

.text
.global main
main:
    mov r1, #0       /* r1 ← 0 */
    mov r2, #1       /* r2 ← 1 */
    b check_loop     /* unconditionally jump at the end of the loop */
loop: 
    add r1, r1, r2   /* r1 ← r1 + r1 */
    add r2, r2, #1   /* r2 ← r2 + 1 */
check_loop:
    cmp r2, #22      /* compare r2 and 22 */
    ble loop         /* branch if r2 &lt;= 22 to the beginning of the loop */
end:
    mov r0, r1       /* r0 ← r1 */
    bx lr
