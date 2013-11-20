/* array_by_value.s */

.data

.align 4

big_array :
.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21
.word 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41
.word 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61
.word 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81
.word 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100
.word 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116
.word 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132
.word 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148
.word 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164
.word 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180
.word 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196
.word 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212
.word 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228
.word 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244
.word 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255

.align 4

message: .asciz "The sum of 0 to 255 is %d\n"

.text
.globl main

sum_array_value : 
    push {r4, r5, r6, lr}

    /* We have passed all the data by value */

    /* r4 will hold the sum so far */
    mov r4, #0      /* r4 ← 0 */
    /* In r0 we have the number of items of the array */

    cmp r0, #1            /* r0 - #1 and update cpsr */
    blt .Lend_of_sum_array  /* if r0 < 1 branch to end_of_sum_array */
    add r4, r4, r1        /* add the first item */

    cmp r0, #2            /* r0 - #2 and update cpsr */
    blt .Lend_of_sum_array  /* if r0 < 2 branch to end_of_sum_array */
    add r4, r4, r2        /* add the second item */

    cmp r0, #3            /* r0 - #3 and update cpsr */
    blt .Lend_of_sum_array  /* if r0 < 3 branch to end_of_sum_array */
    add r4, r4, r3        /* add the third item */

    /* 
     The stack at this point looks like this
       |                | (lower addresses)
       |                |
       | lr             |  <- sp points here
       | r6             |  <- this is sp + 4
       | r5             |  <- this is sp + 8
       | r4             |  <- this is sp + 12
       | big_array[3]   |  <- this is sp + 16 (we want r5 to point here)
       | big_array[4]   |
       |     ...        |
       | big_array[255] |
       |                | 
       |                | (higher addresses)
    
    keep in r5 the address where the stack-passed portion of the array starts */
    add r5, sp, #16 /* r5 ← sp + 16 */

    /* in register r3 we will count how many items we have read
       from the stack. */
    mov r3, #0

    /* in the stack there will always be 3 less items because
       the first 3 were already passed in registers
       (recall that r0 had how many items were in the array) */
    sub r0, r0, #3

    b .Lcheck_loop_sum_array
    .Lloop_sum_array:
      ldr r6, [r5, r3, LSL #2]       /* r6 ← *(r5 + r3 * 4) load
                                        the array item r3 from the stack */
      add r4, r4, r6                 /* r4 ← r4 + r6
                                        accumulate in r4 */
      add r3, r3, #1                 /* r3 ← r3 + 1 
                                        move to the next item */
    .Lcheck_loop_sum_array:
      cmp r3, r0           /* r0 - r3 and update cpsr */
      blt .Lloop_sum_array   /* if r3 < r3  branch to loop_sum_array */

  .Lend_of_sum_array:
    mov r0, r4  /* r0 ← r4, to return the value of the sum */
    pop {r4, r5, r6, lr}

    bx lr
    

main:
    push {r4, r5, r6, r7, r8, lr}
    /* we will not use r8 but we need to keep the function 8-byte aligned */

    ldr r4, address_of_big_array

    /* Prepare call */

    mov r0, #256  /* Load in the first parameter the number of items 
                     r0 ← 256
                     */

    ldr r1, [r4]     /* load in the second parameter the first item of the array */
    ldr r2, [r4, #4] /* load in the third parameter the second item of the array */
    ldr r3, [r4, #8] /* load in the fourth parameter the third item of the array */

    /* before pushing anything in the stack keep its position */
    mov r7, sp

    /* We cannot use more registers, now we have to push them onto the stack
       (in reverse order) */
    mov r5, #255   /* r5 ← 255
                      This is the last item position
                      (note that the first would be in position 0) */


    b .Lcheck_pass_parameter_loop
    .Lpass_parameter_loop:

      ldr r6, [r4, r5, LSL #2]  /* r6 ← *(r4 + r5 * 4).
                                   loads the item in position r5 into r6. Note that
                                   we have to multiply by 4 because this is the size
                                   of each item in the array */
      push {r6}                 /* push the loaded value to the stack */
      sub r5, r5, #1            /* we are done with the current item,
                                   go to the previous index of the array */
    .Lcheck_pass_parameter_loop:
      cmp r5, #2                /* compute r5 - #2 and update cpsr */
      bne .Lpass_parameter_loop   /* if r5 != #2 branch to pass_parameter_loop */

    /* We are done, we have passed all the values of the array,
       now call the function */
    bl sum_array_value

    /* restore the stack position */
    mov sp, r7

    /* prepare the call to printf */
    mov r1, r0                  /* second parameter, the sum itself */
    ldr r0, address_of_message  /* first parameter, the message */
    bl printf

    pop {r4, r5, r6, r7, r8, lr}
    bx lr

address_of_big_array : .word big_array
address_of_message : .word message
