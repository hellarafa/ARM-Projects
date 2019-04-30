  .text
  .global _start

_start:
  ldr r0, =string
  mov r1, #0
  mov r2, #0
  mov r7, #11 @system call to execv
  svc #1

  .data
string: .asciz  "/bin/busybox sh"
