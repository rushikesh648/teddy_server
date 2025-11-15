section .text
    global _start

_start:
    ; Set up arguments for the add_numbers subroutine
    mov rdi, 10           ; Arg 1: RDI = 10
    mov rsi, 5            ; Arg 2: RSI = 5
    
    call add_numbers      ; RDI and RSI are passed to the subroutine
                          ; On return, RAX will hold the result (15)

    ; ... (Program continues, perhaps printing the result in RAX)
    
    mov rax, 60           ; Exit
    xor rdi, rdi
    syscall

; --- Subroutine Definition ---
; Input: RDI (num1), RSI (num2)
; Output: RAX (result)
add_numbers:
    mov rax, rdi          ; Move num1 (10) into RAX
    add rax, rsi          ; Add num2 (5). RAX is now 15
    ret                   ; Return to the caller
