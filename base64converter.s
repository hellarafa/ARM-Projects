@@@===============LOAD FILE===============
@@@ Rafael Munoz

	.equ SWI_Open, 0x66 @open a file
	.equ SWI_Close,0x68 @close a file
	.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
	.equ SWI_PrStr, 0x69 @ Write a null-ending string 
	.equ SWI_PrInt,0x6b @ Write an Integer
	.equ SWI_RdInt,0x6c @ Read an Integer from a file
	.equ Stdout, 1 @ Set output target to be Standard out
	.equ SWI_Exit, 0x11	@EXIT
	.global	_start
	.text

_start:
	ldr	r0,=myFile
	mov	r1,#0
	swi	SWI_Open	@LOAD FILE 'input.txt'
	bcs	getFileError	@BRANCH TO ERROR IF FILE CANNOT OPEN
	ldr	r1,=fileHandle
	str	r0,[r1]
	
	ldr	r0,=outFile
	mov	r1,#1
	swi	SWI_Open	@LOAD FILE 'output.txt'
	bcs	getFileError	@BRANCH TO ERROR IF FILE CANNOT OPEN
	ldr	r1,=outFileHandle
	str	r0,[r1]
	
	ldr r0,=fileHandle
	ldr r0,[r0]
	ldr r1,=charArray
	mov r2,#1024
	swi 0x6a
	bcs emptyError
	mov r4,r1	@manipulate the address at r4
	mov r9,r0	@length of string from file in r9
	sub r9,r9,#1 @get rid of that stupid null at the end
	mov r8,#0	@Just saving the register for a pointer to the solArray index
	cmp r9,#3	@check if input in only one/two letters long. Check only once.
	blt decision
loop:
	cmp r9,#0
	beq done
	ldrb r2,[r4],#1	@load first letter
	mov  r2,r2,lsl #8 @mov it over 1 byte
	ldrb r3,[r4],#1 
	orr r2,r2,r3 @put second letter next to first
	mov  r2,r2,lsl #8
	ldrb r3,[r4],#1
	orr r2,r2,r3	@3 letters should now be in one register = 24bits
	mov r2,r2,ror #18 @single out first 6 bits by rotating 18
	and r3,r2,#0x3f @take those 6 bits out by anding the 6 bits
	bal print
continue:
	cmp r10,#4	@check if all three letters are done being converted.
	beq decision
	mov r2,r2,ror #26 @ get the next 6 bits to convert
	and r3,r2,#0x3f @single them out again
print:	
	ldr r1,=lookup	@load the base64 table
	add r1,r1,r3	@mov index pointer to the correct letter in the table
	ldrb r0,[r1]	@load base64 converted letter
bypass:
	swi 0x00
@=== Save Letter ===
	ldr r1,=solArray
	add r1,r1,r8
	strb r0,[r1]
@=== Increments ===
	add r8,r8,#1 @r8 is the solArray pointer
	cmp r6,#1
	moveq pc,r14
	cmp r6,#2
	moveq pc,r14
	add r10,r10,#1
	bal continue
	
decision:
	sub r9,r9,#3 @once r9 = 1 then you are done
	mov r10,#0
	cmp r9,#0 @if r9 is 0 then there are no more letters
	beq done
	cmp r9,#3 @if r9 is >= 3, then there are still more conversions to do
	bge loop
	cmp r9,#1 @theres a remainder of 1, go to padding ==
	beq padding2
	cmp r9,#2 @theres a remainder of 2, go to padding =
	beq padding1

padding2:
	mov r6,#2
	ldrb r2,[r4],#1	@load last letter
	mov r2,r2,ror #2 @single out first 6 bits by rotating 2
	and r3,r2,#0x3F
	bl print
	mov r2,r2,ror #26
	and r3,r2,#0x3f @take those 6 bits out by anding the 6 bits
	bl print
	mov r0,#0x3D 
	bl bypass	@print =	
	bl bypass	@print =
	bal done

padding1:
	mov r6,#1
	ldrb r2,[r4],#1	@load last two letters
	mov  r2,r2,lsl #8 @mov it over 1 byte
	ldrb r3,[r4],#1 
	orr r2,r2,r3 @put second to last letter next to prev.
	mov r2,r2,ror #10 @single out first 6 bits by rotating 10
	and r3,r2,#0x3f @take those 6 bits out by anding the 6 bits
	bl print
	mov r2,r2,ror #26
	and r3,r2,#0x3f @take those 6 bits out by anding the 6 bits
	bl print
	mov r2,r2,lsr #28
	mov r2,r2,lsl #2
	and r3,r2,#0x3f @take those 6 bits out by anding the 6 bits
	bl print
	mov r0,#0x3D
	bl bypass	@print =
	bal done

done:
	ldr r0,=myString
	swi	0x02 @print string

@=== code will write to file ===
	ldr r0,=outFileHandle
	ldr r0,[r0]
	ldr r1,=solArray
	swi SWI_PrStr

@=== close all files ===
	ldr	r0,	=outFileHandle
	ldr	r0,	[r0]
	swi SWI_Close	@CLOSE FILE

	ldr	r0,	=fileHandle
	ldr	r0,	[r0]
	swi SWI_Close	@CLOSE FILE
	bal	Exit
	
emptyError:	@ERROR MESSAGE IF FILE IS EMPTY
	mov r10,r0
	ldr r0, =emptyFileError
	swi	0x02
	ldr	r0,	=fileHandle
	ldr	r0,	[r0]
	swi SWI_Close	@CLOSE FILE
	bal Exit

getFileError:	@ERROR MESSAGE WHEN FILE CANNOT OPEN
	mov r10,r0
	ldr r0,=fileError
	swi	0x02
	ldr	r0,	=fileHandle
	ldr	r0,	[r0]
	swi SWI_Close	@CLOSE FILE
	bal Exit	@Exit	
	
Exit:
	swi	SWI_Exit

@@@@@===============END OF FILE===============
		.data
		.align
fileHandle:	.word	0
outFileHandle:	.word	0
charArray:	.skip	1024
solArray:	.skip	1024
NL:	.asciz	"\n "	@NEW LINE
outFile:	.asciz	"output.txt"
myFile:	.asciz	"input.txt"
lookup:	.asciz	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
emptyFileError:	.asciz	"File is empty. Try again with a different file. \n"
fileError:	.asciz	"Unable to open file. Check file name. \n"
myString:	.asciz	"...Base64 conversion complete. Please look at output.txt"
	.end