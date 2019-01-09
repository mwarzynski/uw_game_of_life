.global start
.global run
.global cleanup

start:
    bx lr

run:
    mov r0, #1337
    bx lr

cleanup:
    bx lr

