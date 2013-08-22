/* ifstring.s */
.data

.text

.globl main

main:
  cmp r0, #1                  /* r0 - 1 and update cpsr */
  beq case_1                  /* if r0 == 1 branch to case_1 */
  cmp r0, #2                  /* r0 - 2 and update cpsr */
  beq case_2                  /* if r0 == 2 branch to case_2 */
  cmp r0, #3                  /* r0 - 3 and update cpsr */
  beq case_3                  /* if r0 == 3 branch to case_3 */
  b case_default              /* branch to case_default */

  case_1:
   mov r0, #1                 /* r0 ← 1 */ 
   b after_switch             /* break */
 
  case_2:
   mov r0, #2                 /* r0 ← 2 */
   b after_switch             /* break */

  case_3:
   mov r0, #3                 /* r0 ← 3 */
   b after_switch             /* break */

  case_default:
   mov r0, #42                /* r0 ← 42 */
   b after_switch             /* break (unnecessary) */  

  after_switch:

  bx lr                       /* Return from main */
