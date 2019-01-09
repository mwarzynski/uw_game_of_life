.global start
.global run
.global cleanup

.extern malloc
.extern free

.data
width:  .word 0
height: .word 0
cache:  .word 0

.text
@ start initializes simulation variables.
@ Arguments:
@   r0 - width
@   r1 - height
@   r2 - T (matrix that contains values)
start:
    ldr r3, =width
    str r0, [r3]    @ width  = r0
    ldr r3, =height
    str r1, [r3]    @ height = r1

    mul r3, r0, r1  @ r3 = r1 * r2 = width * height
    mov r0, r3
    bl malloc       @ malloc(width*height)
    cmp r0, #0
    bne start_err
    ldr r1, =cache
    str r0, [r1]    @ cache = allocated memory
    bx lr
start_err:
    mov r0, #5
    mov r7, #1
    swi 0      @ exit(5)

@ run performs single step of the game of life.
run:
    bx lr

@ cleanup frees allocated memory during 'start' procedure.
cleanup:
    bx lr

