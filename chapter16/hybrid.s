/* hybrid.s */
.data

.text

.globl main

main:
  push {r4, r5, r6, lr}

  cmp r0, #1                /* r0 - 1 and update cpsr */
  blt case_default          /* if r0 < 1 then branch to case_default */
  cmp r0, #300              /* r0 - 300 and update cpsr */
  bgt case_default          /* if r0 > 300 then branch to case default */

  /* prepare the binary search. 
     r1 will hold the lower index
     r2 will hold the upper index
     r3 the base address of the case_value_table
  */
  mov r1, #0
  mov r2, #9
  ldr r3, addr_case_value_table /* r3 ← &case_value_table */

  b check_binary_search
  binary_search:
    add r4, r1, r2          /* r4 ← r1 + r2 */
    mov r4, r4, ASR #1      /* r4 ← r4 / 2 */
    ldr r5, [r3, +r4, LSL #2]   /* r5 ← *(r3 + r4 * 4). 
                               This is r5 ← case_value_table[r4] */
    cmp r0, r5              /* r0 - r5 and update cpsr */
    sublt r2, r4, #1        /* if r0 < r5 then r2 ← r4 - 1 */
    addgt r1, r4, #1        /* if r0 > r5 then r1 ← r4 + 1 */
    bne check_binary_search /* if r0 != r5 branch to binary_search */

    /* if we reach here it means that r0 == r5 */
    ldr r5, addr_case_addresses_table /* r5 ← &addr_case_value_table */
    ldr r5, [r5, +r4, LSL #2]   /* r5 ← *(r5 + r4*4) 
                               This is r5 ← case_addresses_table[r4] */
    mov pc, r5              /* branch to the proper case */
    
  check_binary_search:
    cmp r1, r2              /* r1 - r2 and update cpsr */
    ble binary_search       /* if r1 <= r2 branch to binary_search */

  /* if we reach here it means the case value
     was not found. branch to default case */
  b case_default

  case_1:
     mov r0, #1
     b after_switch
  case_2:
     mov r0, #2
     b after_switch
  case_3:
     mov r0, #3
     b after_switch
  case_24:
     mov r0, #24
     b after_switch
  case_25:
     mov r0, #95
     b after_switch
  case_26:
     mov r0, #96
     b after_switch
  case_97:
     mov r0, #97
     b after_switch
  case_98:
     mov r0, #98
     b after_switch
  case_99:
     mov r0, #99
     b after_switch
  case_300:
     mov r0, #300    /* The error code will be 44 */
     b after_switch

  case_default:
   mov r0, #42       /* r0 ← 42 */
   b after_switch    /* break (unnecessary) */  

  after_switch:

  pop {r4,r5,r6,lr}
  bx lr              /* Return from main */

case_value_table: .word 1, 2, 3, 24, 25, 26, 97, 98, 99, 300
addr_case_value_table: .word case_value_table

case_addresses_table:
    .word case_1
    .word case_2
    .word case_3
    .word case_24
    .word case_25
    .word case_26
    .word case_97
    .word case_98
    .word case_99
    .word case_300
addr_case_addresses_table: .word case_addresses_table
