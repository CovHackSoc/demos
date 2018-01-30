; .text is where the main code is ran from
[section .text]

global _start

; Where the program starts rom
_start:
; I choose to use r12 because it wasn't used elsewhere
	mov r12, 10 ; store 10 in it.
main:
	call write ; call the write subroutine
	dec r12 ; subtract one from r12
	cmp r12, 0 ; compare and set flags
	jge main ; jump back is r12 is less than or equal to 0
	call exit ; terminate the program

write:
; AMD64 uses these for making syscalls
	mov rdx, 14 ; move 14 into the register rdx
	mov rsi, sample_text ; copy the address of sample_text into rsi
	mov rdi, 1 ; 1 is the file descriptor for stdout
	mov rax, 1 ; Syscall number, this is write()
	syscall ; make a syscall
	ret ; return from subroutine

; exit from the program
exit:
	mov rax, 60 ; syscall number for exit
	syscall ; terminate the program
	ret

; The .data section is used to store data in the binary
[section .data]
sample_text: db "Hello World!",0xa
