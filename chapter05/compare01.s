/* -- compare01.s */

.text
.global main
main:
    mov r1, #2       /* r1 ← 2 */
    mov r2, #2       /* r2 ← 2 */
    cmp r1, r2       /* r1 ← r2 */
    beq case_equal   /* branch to case_equal if Z = 1 */
case_different :
    mov r0, #2       /* r0 ← 2 */
    b end            /* branch to end */
case_equal:
    mov r0, #1       /* r0 ← 1 */
end:
    bx lr
