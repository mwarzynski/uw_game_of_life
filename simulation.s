.global start
.global run

start:
    bx lr

run:
    mov r0, #1337
    bx lr

