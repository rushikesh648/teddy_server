section .data
    msg db "Hello from the main program!", 0Ah ; 0Ah is newline
    
section .text
    global _start

_start:
    ; 1. Call the subroutine
    call print_message    ; Pushes the address of the next instruction (mov rax, 60) onto the stack

    ; 2. Exit the program
    mov rax, 60           ; syscall: exit
    xor rdi, rdi          ; status: 0
    syscall

; --- Subroutine Definition ---
print_message:
    ; Use syscall to print the message
    mov rax, 1            ; syscall: write
    mov rdi, 1            ; file descriptor: stdout (1)
    mov rsi, msg          ; address of the string
    mov rdx, 29           ; length of the string (adjust as needed)
    syscall

    ret                   ; Pops the return address from the stack and jumps back to _start
