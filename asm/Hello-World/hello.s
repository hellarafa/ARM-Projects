@hello.s "Hello World!" in ARM.

  .global _start
_start:
  mov r7, #4 @system call
  mov r0, #1 @specify stdout
  ldr r1, =string
  mov r2, #14
  svc 0

  bal end @go to end.

end:
  mov R7, #1
  mov r0, #0
  svc 0

@----------------
  .data
string: .asciz  "Hello World!\n"
