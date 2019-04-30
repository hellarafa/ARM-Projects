@functions.s "A small program to learn how to do syscalls."

  .global _start
_start:

@--------syscall open-----------
@ This opens a file.
@-------------------------------
  ldr r0, =filename
  mov r1, #0101 @ O_WRONLY | O_CREAT
  ldr r2, =0666 @ permissions
  mov r7, #5 @ 5 is system call number for open
  svc #0

  cmp r0, #0
  blt exit
  mov r5, r0 @r0 contains fd (file descriptor, an integer)

@--------syscall stdout---------
@ This prints out to stdout
@-------------------------------
  mov r7, #4 @system call - write
  mov r0, #1 @specify stdout
  ldr r1, =string
  mov r2, #14 @size in bytes of the string
  svc #0 @print syscall

@--------syscall write to file---------
@ This prints out to stdout
@ but from stack
@-------------------------------
  sub sp, #8 @ stack is full descending, this is how we leave some space
  mov r1, #'4'
  strb r1, [sp]
  mov r1, #'2'
  strb r1, [sp, #1]
  mov r1, #'\n'
  strb r1, [sp, #2]
  mov r0, r5 @specify write to file
  mov r1, sp
  mov r2, #3
  mov r7, #4 @ 4 is write
  svc #0

@--------syscall close----------
@ This prints out to close file
@-------------------------------
  mov r7, #6 @ 6 is close
  svc #0

  bal exit @go to the exit.

exit:
@--------syscall exit---------
@ This exits the program
@-------------------------------
  mov r7, #1
  mov r0, #0
  svc 0

  .data
  .align
string: .asciz  "Hello\n"
filename: .asciz  "out.txt"
