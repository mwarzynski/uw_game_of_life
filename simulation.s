.global start
.global run
.global stop

.extern malloc
.extern free

.data
width:  .word 0
height: .word 0
board:  .word 0
cache:  .word 0

.text
@ start initializes simulation variables.
@ Arguments:
@   r0 - width
@   r1 - height
@   r2 - T (matrix that contains values)
start:
    push {lr}
    @ Store arguments in global variables.
    ldr r3, =width
    str r0, [r3]    @ width  = r0
    ldr r3, =height
    str r1, [r3]    @ height = r1
    ldr r3, =board
    str r2, [r3]    @ board  = r3

    @ Allocate memory for cache.
    mul r3, r0, r1  @ r3 = r1 * r2 = width * height
    mov r0, r3
    bl malloc       @ malloc(width*height)
    cmp r0, #0
    beq start_err
    ldr r1, =cache
    str r0, [r1]    @ cache = allocated memory
    pop {pc}
start_err:
    mov r0, #5
    mov r7, #1
    swi 0      @ exit(5)

@ run performs single step of the game of life.
run:
    push {lr}
    bl run_cells       @ compute new values for each cell (save them to cache)
    bl run_flush_cache @ flush stored values in cache to main board
    pop {pc}

@ run_cells iterates over cells to compute their new value
run_cells:
    push {lr}

    mov r9,  #0 @ x variable (width)
    mov r10, #0 @ y variable (height)

run_cells_loop_y:
    mov r9, #0  @ x = 0
run_cells_loop_x:
    @ Compute value for single cell at (x,y).
    push {r8, r9}
    mov r0, r9
    mov r1, r10
    bl run_cell
    pop {r8, r9}

    @ x += 1
    add r9, r9, #1
    @ if (x < width) { goto run_cells_loop_x }
    ldr r1, =width
    ldr r0, [r1]
    cmp r9, r0
    blt run_cells_loop_x

    @ y += 1
    add r10, r10, #1
    @ if (y < height) { goto run_cells_loop_y }
    ldr r1, =height
    ldr r0, [r1]
    cmp r10, r0
    blt run_cells_loop_y
    @ No more cells to compute.
    pop {pc}

@ run_cell computes new cell value.
@ Arguments:
@   r0 - x coordinate of the cell
@   r1 - y coordinate of the cell
run_cell:
    push {lr}

    @ Get number of living cells around current cell.
    push {r0, r1}
    bl run_cell_neighbour_sum
    mov r2, r0      @ r2 = number of living cells around
    pop {r0, r1}

    @ Get liveness of current cell from the board.
    push {r0, r1, r2}
    bl run_cell_value
    mov r3, r0      @ r3 = if current cell is living
    pop {r0, r1, r2}

    @ Determine new liveness of the cell after computation.
    cmp r3, #0
    bne run_cell_living
run_cell_dead:
    mov r6, #'0'
    cmp r2, #3
    bne run_cell_save
    mov r6, #'1'
    b run_cell_save
run_cell_living:
    mov r6, #'1'
    cmp r2, #1
    bgt run_cell_living2
    mov r6, #'0'
    b run_cell_save
run_cell_living2: @ case where sum of alive neighbours >= 2
    cmp r2, #4
    blt run_cell_save
    mov r6, #'0'

run_cell_save:
    @ Store computed value (r6) at cache.
    ldr r2, =width
    ldr r2, [r2]
    mul r3, r2, r1 @ r3 = width * y
    add r3, r3, r0 @ r3 = width * y + x
    ldr r1, =cache
    ldr r1, [r1]
    add r1, r1, r3 @ r1 = cache + r3
    strb r6, [r1]  @ cache[r3] = r6 // cache[width*y + x] = r6

    pop {pc}

@ run_cell_neighbour_sum computes number of living cells around given point
@ Arguments:
@   r0 - x coordinate of the cell
@   r1 - y coordinate of the cell
run_cell_neighbour_sum:
    push {lr}
    mov r6, #0 @ alive cells counter

    mov r9, r0
    mov r10, r1

    @ up left
    mov r0, r9
    sub r0, r0, #1
    mov r1, r10
    add r1, r1, #1
    bl run_cell_value
    add r6, r6, r0

    @ up
    mov r0, r9
    mov r1, r10
    add r1, r1, #1
    bl run_cell_value
    add r6, r6, r0

    @ up right
    mov r0, r9
    add r0, r0, #1
    mov r1, r10
    add r1, r1, #1
    bl run_cell_value
    add r6, r6, r0

    @ left
    mov r0, r9
    sub r0, r0, #1
    mov r1, r10
    bl run_cell_value
    add r6, r6, r0

    @ right
    mov r0, r9
    add r0, r0, #1
    mov r1, r10
    bl run_cell_value
    add r6, r6, r0

    @ down left
    mov r0, r9
    sub r0, r0, #1
    mov r1, r10
    sub r1, r1, #1
    bl run_cell_value
    add r6, r6, r0

    @ down
    mov r0, r9
    mov r1, r10
    sub r1, r1, #1
    bl run_cell_value
    add r6, r6, r0

    @ down right
    mov r0, r9
    add r0, r0, #1
    mov r1, r10
    sub r1, r1, #1
    bl run_cell_value
    add r6, r6, r0

    mov r0, r6
    pop {pc}

@ run_cell_value determines if cell at provided coordinates is alive.
@ Arguments:
@   r0 - x coordinate of the cell
@   r1 - y coordinate of the cell
run_cell_value:
    @ Default return value is 0.
    @ 0 is returned even if arguments point to nonexisting cell.
    mov r5, #0

    @ Validate if provided values are correct.
    @ if !(0 <= x && x < width) { goto run_cell_value_end }
    ldr r2, =width
    ldr r2, [r2]
    cmp r0, #0
    blt run_cell_value_end
    cmp r0, r2
    bge run_cell_value_end
    @ if !(0 <= y && y < height) { goto run_cell_value_end }
    ldr r3, =height
    ldr r3, [r3]
    cmp r1, #0
    blt run_cell_value_end
    cmp r1, r3
    bge run_cell_value_end

    ldr r2, =width
    ldr r2, [r2]
    mul r3, r1, r2 @ r3 = r1 * r2 = y * width
    add r3, r3, r0 @ r3 = r3 + x  = y * width + x
    ldr r2, =board
    ldr r2, [r2]   @ r2 = board
    add r2, r2, r3 @ r2 = board + y*width + x
    ldrb r4, [r2]  @ r4 = cell's value at (x,y)

    mov r5, #0
    cmp r4, #'0'   @ if (r4 == 0) { return 0 }
    beq run_cell_value_end
    mov r5, #1     @ else         { return 1 }
run_cell_value_end:
    mov r0, r5
    bx lr

@ run_flush_cache flushes cache to the board
run_flush_cache:
    ldr r0, =width
    ldr r0, [r0]
    ldr r1, =height
    ldr r1, [r1]
    mul r1, r0, r1

    @ r1 determines how many values we should copy
    mov r0, #0 @ r0 is the counter of copied values
    ldr r2, =board
    ldr r2, [r2]
    ldr r3, =cache
    ldr r3, [r3]
run_flush_cache_loop:
    mov r4, r0
    add r4, r4, r3 @ from cache
    ldrb r5, [r4]
    mov r4, r0
    add r4, r4, r2 @ to board
    strb r5, [r4]
    @ r0 += 1
    add r0, r0, #1
    cmp r0, r1
    blt run_flush_cache_loop

    bx lr

@ stop frees allocated memory during 'start' procedure.
stop:
    push {lr}
    ldr r1, =cache
    ldr r0, [r1]
    bl free
    pop {pc}

