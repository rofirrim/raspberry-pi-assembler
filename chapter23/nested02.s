/* nested01.s */

.text

# void f(void) // non nested (nesting depth = 0)
# {
#    int x;
# 
#    void g() // nested (nesting depth = 1)
#    {
#       x = x + 1;
#    }
#    void h() // nested (nesting depth = 1)
#    {
#       void m() // nested (nesting depth = 2)
#       {
#          x = x + 2;
#          g();
#       }
# 
#       g();
#       m();
#       x = x + 3;
#    }
# 
#    x = 1;
#    h();
#    // here x will be 8
# }

f:
    push {r4, r10, fp, lr} /* keep registers */
    mov fp, sp             /* setup dynamic link */

    sub sp, sp, #8      /* make room for x (4 + 4 bytes) */
    /* x will be in address "fp - 4" */

    /* At this point our stack looks like this

     Data | Address | Notes
    ------+---------+---------------------------
          | fp - 8  | alignment (per AAPCS)
      x   | fp - 4  | 
      r4  | fp      |  
      r10 | fp + 8  | previous value of r10
      fp  | fp + 12 | previous value of fp
      lr  | fp + 16 |
   */

    mov r4, #1          /* r4 ← 1 */
    str r4, [fp, #-4]   /* x ← r4 */

    /* prepare the call to h */
    mov r10, fp /* setup the static link,
                   since we are calling an immediately nested function
                   it is just the current frame */
    bl h

    mov sp, fp             /* restore stack */
    pop {r4, r10, fp, lr}  /* restore registers */
    bx lr /* return */

/* ------ nested function ------------------ */
h :
    push {r4, r5, r10, fp, lr} /* keep registers */
    mov fp, sp /* setup dynamic link */

    sub sp, sp, #4 /* align stack */

    /* At this point our stack looks like this

      Data | Address | Notes
     ------+---------+---------------------------
           | fp - 4  | alignment (per AAPCS)
       r4  | fp      |  
       r5  | fp + 4  | 
       r10 | fp + 8  | frame pointer of 'f'
       fp  | fp + 12 | frame pointer of caller
       lr  | fp + 16 |
    */

    /* prepare call to g */
    /* g is a sibling so the static link will be the same
       as the current one */
    ldr r10, [fp, #8]
    bl g

    /* prepare call to m */
    /* m is an immediately nested function so the static
       link is the current frame */
    mov r10, fp
    bl m

    ldr r4, [fp, #8]  /* load frame pointer of 'f' */
    ldr r5, [r4, #-4]  /* r5 ← x */
    add r5, r5, #3     /* r5 ← r5 + 3 */
    str r5, [r4, #-4]  /* x ← r5 */

    mov sp, fp            /* restore stack */
    pop {r4, r5, r10, fp, lr} /* restore registers */
    bx lr


/* ------ nested function ------------------ */
m:
    push {r4, r5, r10, fp, lr} /* keep registers */
    mov fp, sp /* setup dynamic link */

    sub sp, sp, #4 /* align stack */
    /* At this point our stack looks like this

      Data | Address | Notes
     ------+---------+---------------------------
           | fp - 4  | alignment (per AAPCS)
       r4  | fp      |  
       r5  | fp + 4  |
       r10 | fp + 8  | frame pointer of 'h'
       fp  | fp + 12 | frame pointer of caller
       lr  | fp + 16 |
    */

    ldr r4, [fp, #8]  /* r4 ← frame pointer of 'h' */
    ldr r4, [r4, #8]  /* r4 ← frame pointer of 'f' */
    ldr r5, [r4, #-4] /* r5 ← x */
    add r5, r5, #2    /* r5 ← r5 + 2 */
    str r5, [r4, #-4] /* x ← r5 */

    /* setup call to g */
    ldr r10, [fp, #8]   /* r10 ← frame pointer of 'h' */
    ldr r10, [r10, #8]  /* r10 ← frame pointer of 'f' */
    bl g

    mov sp, fp                /* restore stack */
    pop {r4, r5, r10, fp, lr} /* restore registers */
    bx lr

/* ------ nested function ------------------ */
g:
    push {r4, r5, r10, fp, lr} /* keep registers */
    mov fp, sp /* setup dynamic link */

    sub sp, sp, #4 /* align stack */

    /* At this point our stack looks like this

      Data | Address | Notes
     ------+---------+---------------------------
           | fp - 4  | alignment (per AAPCS)
       r4  | fp      |  
       r5  | fp + 4  |  
       r10 | fp + 8  | frame pointer of 'f'
       fp  | fp + 12 | frame pointer of caller
       lr  | fp + 16 |
    */

    ldr r4, [fp, #8]  /* r4 ← frame pointer of 'f' */
    ldr r5, [r4, #-4] /* r5 ← x */
    add r5, r5, #1    /* r5 ← r5 + 1 */
    str r5, [r4, #-4] /* x ← r5 */

    mov sp, fp /* restore dynamic link */
    pop {r4, r5, r10, fp, lr} /* restore registers */
    bx lr

.globl main

main :
    push {r4, lr} /* keep registers */

    bl f          /* call f */

    mov r0, #0
    pop {r4, lr}
    bx lr
