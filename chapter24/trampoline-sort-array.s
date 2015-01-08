/* trampoline-sort-arrays.s */

.data

/* declare an array of 10 integers called my_array */
.align 4
my_array: .word 82, 70, 93, 77, 91, 30, 42, 6, 92, 64

/* format strings for printf */
/* format string that prints an integer plus a space */
.align 4
integer_printf: .asciz "%d "
/* format string that simply prints a newline */
.align 4
newline_printf: .asciz "\n"
.align 4
comparison_message: .asciz "Num comparisons: %d\n"

.text

print_array:
    /* r0 will be the address of the integer array */
    /* r1 will be the number of items in the array */
    push {r4, r5, r6, lr}  /* keep r4, r5, r6 and lr in the stack */

    mov r4, r0             /* r4 ← r0. keep the address of the array */
    mov r5, r1             /* r5 ← r1. keep the number of items */
    mov r6, #0             /* r6 ← 0.  current item to print */

    b .Lprint_array_check_loop /* go to the condition check of the loop */

    .Lprint_array_loop:
      /* prepare the call to printf */
      ldr r0, addr_of_integer_printf  /* r0 ← &integer_printf */
      ldr r1, [r4, +r6, LSL #2]       /* r1 ← *(r4 + r6 * 4) */
      bl printf                       /* call printf */

      add r6, r6, #1                  /* r6 ← r6 + 1 */
    .Lprint_array_check_loop: 
      cmp r6, r5               /* perform r6 - r5 and update cpsr */
      bne .Lprint_array_loop   /* if cpsr states that r6 is not equal to r5
                                  branch to the body of the loop */

    /* prepare call to printf */
    ldr r0, addr_of_newline_printf /* r0 ← &newline_printf */
    bl printf
    
    pop {r4, r5, r6, lr}   /* restore r4, r5, r6 and lr from the stack */
    bx lr                  /* return */

addr_of_integer_printf: .word integer_printf
addr_of_newline_printf: .word newline_printf

.globl main
main:
    push {r4, r5, r6, fp, lr} /* keep callee saved registers */
    mov fp, sp                /* setup dynamic link */

    sub sp, sp, #4            /* counter will be in fp - 4 */
    /* note that now the stack is 8-byte aligned */

    /* set counter to zero */
    mov r4, #0        /* r4 ← 0 */
    str r4, [fp, #-4] /* counter ← r4 */

    /* Make room for the trampoline */
    sub sp, sp, #32 /* sp ← sp - 32 */
    /* note that 32 is a multiple of 8, so the stack
       is still 8-byte aligned */

    /* copy the trampoline into the stack */
    mov r4, #32                        /* r4 ← 32 */
    ldr r5, .Laddr_trampoline_template /* r4 ← &trampoline_template */
    mov r6, sp                         /* r6 ← sp */
    b .Lcopy_trampoline_loop_check     /* branch to copy_trampoline_loop_check */

    .Lcopy_trampoline_loop:
        ldr r7, [r5]     /* r7 ← *r5 */
        str r7, [r6]     /* *r6 ← r7 */
        add r5, r5, #4   /* r5 ← r5 + 4 */
        add r6, r6, #4   /* r6 ← r6 + 4 */
        sub r4, r4, #4   /* r4 ← r4 - 4 */
    .Lcopy_trampoline_loop_check:
        cmp r4, #0                  /* compute r4 - 0 and update cpsr */
        bgt .Lcopy_trampoline_loop  /* if cpsr means that r4 > 0
                                       then branch to copy_trampoline_loop */

    /* setup the trampoline */
    ldr r4, addr_of_integer_comparison_count
                       /* r4 ← &integer_comparison_count */
    str r4, [fp, #-36] /* *(fp + 36) ← r4 */
                       /* set the function_called in the trampoline
                          to be &integer_comparison_count */
    str fp, [fp, #-32]  /* *(fp + 32) ← fp */
                        /* set the lexical_scope in the trampoline
                           to be fp */

    /* prepare call to __clear_cache */
    mov r0, sp       /* r0 ← sp */
    add r1, sp, #32  /* r1 ← sp + 32 */
    bl __clear_cache /* call __clear_cache */

    /* prepare call to print_array */
    ldr r0, addr_of_my_array /* r0 ← &my_array */
    mov r1, #10              /* r1 ← 10
                                our array is of length 10 */
    bl print_array           /* call print_array */

    /* prepare call to qsort */
    /*
    void qsort(void *base,
         size_t nmemb,
         size_t size,
         int (*compar)(const void *, const void *));
    */
    ldr r0, addr_of_my_array /* r0 ← &my_array
                                base */
    mov r1, #10              /* r1 ← 10
                                nmemb = number of members
                                our array is 10 elements long */
    mov r2, #4               /* r2 ← 4
                                size of each member is 4 bytes */
    sub r3, fp, #28          /* r3 ← fp + 28 */
    bl qsort                 /* call qsort */

    /* prepare call to printf */
    ldr r1, [fp, #-4]                    /* r1 ← counter
                                            num comparisons */
    ldr r0, addr_of_comparison_message   /* r0 ← &comparison_message */
    bl printf                            /* call printf */

    /* now print again the array to see if elements were sorted */
    /* prepare call to print_array */
    ldr r0, addr_of_my_array  /* r0 ← &my_array */
    mov r1, #10               /* r1 ← 10
                                 our array is of length 10 */
    bl print_array            /* call print_array */

    mov r0, #0                /* r0 ← 0 set errorcode to 0 prior returning from main */

    mov sp, fp
    pop {r4, r5, r6, fp, lr}      /* restore callee-saved registers */
    bx lr                     /* return */

addr_of_my_array: .word my_array
addr_of_comparison_message : .word comparison_message

    /* nested function integer comparison */
    addr_of_integer_comparison_count : .word integer_comparison_count
    integer_comparison_count:
        /* r0 will be the address to the first integer */
        /* r1 will be the address to the second integer */
        push {r4, r5, r10, fp, lr} /* keep callee-saved registers */
        mov fp, sp                 /* setup dynamic link */

        ldr r0, [r0]    /* r0 ← *r0
                           load the integer pointed by r0 in r0 */
        ldr r1, [r1]    /* r1 ← *r1
                           load the integer pointed by r1 in r1 */
     
        cmp r0, r1      /* compute r0 - r1 and update cpsr */
        moveq r0, #0    /* if cpsr means that r0 == r1 then r0 ←  0 */
        movlt r0, #-1   /* if cpsr means that r0 <  r1 then r0 ← -1 */
        movgt r0, #1    /* if cpsr means that r0 >  r1 then r0 ←  1 */

        ldr r4, [fp, #8]  /* r4 ← *(fp + 8)
                             get static link in the stack */
        ldr r5, [r4, #-4] /* r5 ← *(r4 - 4)
                             get value of counter */
        add r5, r5, #1    /* r5 ← r5 + 1 */
        str r5, [r4, #-4] /* *(r4 - 4) ← r5
                             update counter */

        mov sp, fp        /* restore stack */
        pop {r4, r5, r10, fp, lr} /* restore callee-saved registers */
        bx lr           /* return */

.Laddr_trampoline_template : .word .Ltrampoline_template
.Ltrampoline_template:
    .Lfunction_called: .word 0x0
    .Llexical_scope: .word 0x0
    push {r4, r5, r10, lr}           /* keep callee-saved registers */
    ldr r4, .Lfunction_called        /* r4 ← function called */
    ldr r10, .Llexical_scope         /* r10 ← lexical scope */
    blx r4                           /* indirect call to r4 */
    pop {r4, r5, r10, lr}            /* restore callee-saved registers */
    bx lr                            /* return */


