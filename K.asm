; File: K.asm
; Keto Assembly Program — Linux x86_64 example

section .data
    ; Change the message to reflect "Teddy Server"
    msg db "Teddy Server Initialized Successfully!", 10   ; message + newline
    len equ $ - msg

section .text
    global _start

_start:
    ; write(msg)
    mov rax, 1          ; syscall: write (1)
    mov rdi, 1          ; file descriptor: stdout (1)
    mov rsi, msg        ; address of string
    mov rdx, len        ; length of string
    syscall

    ; exit(0)
    mov rax, 60         ; syscall: exit (60)
    xor rdi, rdi        ; status: 0
    syscall
