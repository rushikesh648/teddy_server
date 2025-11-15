section .text
    global _start

_start:
    ; ==================================
    ; Syscall: mkdir() (Syscall #83)
    ; mkdir(pathname, mode)
    ; ==================================
    mov rax, 83         ; Syscall number for mkdir
    mov rdi, dir_path   ; Arg 1: Pointer to the directory path
    mov rsi, 0755o      ; Arg 2: Mode (permissions): 0755 (octal) gives rwx for owner, rx for others.
    mov rdx, 0          ; Arg 3: Unused for mkdir
    syscall             ; Execute mkdir()
    
    ; --- Check for Errors ---
    cmp rax, 0          ; Compare return value (RAX) with 0
    jl mkdir_failed     ; Jump if RAX is negative (less than 0)
    
    ; --- Success: Print Success Message ---
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, success_msg
    mov rdx, success_len
    syscall
    
    jmp exit_program

mkdir_failed:
    ; --- Failure: Print Error Message ---
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    ; Note: The error code itself is in RAX, but we are just reporting failure.

exit_program:
    ; Exit the program
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status: 0 (success)
    syscall
