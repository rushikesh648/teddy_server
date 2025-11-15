section .data
    ; --- Network Constants ---
    AF_INET     equ 2       ; Address Family: IPv4
    SOCK_STREAM equ 1       ; Socket Type: TCP
    
    ; --- Server Address Structure (sockaddr_in) ---
    ; Port 8080 (0x1F90) in Network Byte Order is 0x901F
    server_addr:
        dw AF_INET          ; sa_family (2 bytes)
        dw 0x901F           ; sin_port (2 bytes - Port 8080)
        dd 0                ; sin_addr (4 bytes - 0.0.0.0)
        dq 0                ; Padding (8 bytes)
    addr_len equ 16         ; Size of sockaddr_in structure

    ; --- Messages ---
    listen_msg db "Teddy Server listening on 0.0.0.0:8080...", 0xa
    listen_len equ $ - listen_msg
    conn_msg db "Client connected to Teddy Server! FD: ", 0xa ; Will be printed after a number
    conn_len equ $ - conn_msg

section .bss
    ; Reserve space to store the ASCII representation of the client FD
    client_fd_ascii resb 10 

section .text
    global _start
    
; --- Syscall Registers for x86-64 Linux ---
; RAX: Syscall Number | RDI: Arg 1 | RSI: Arg 2 | RDX: Arg 3

_start:
    ; ==================================
    ; 1. socket() call
    ; ==================================
    mov rax, 41         ; Syscall: socket
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, 0
    syscall
    mov r12, rax        ; Save the server socket FD in R12
    
    ; --- Error checking (omitted for brevity) ---

    ; ==================================
    ; 2. bind() call
    ; ==================================
    mov rax, 49         ; Syscall: bind
    mov rdi, r12
    mov rsi, server_addr
    mov rdx, addr_len
    syscall
    
    ; --- Error checking ---

    ; ==================================
    ; 3. listen() call
    ; ==================================
    mov rax, 50         ; Syscall: listen
    mov rdi, r12
    mov rsi, 10         ; Backlog size
    syscall
    
    ; Output Status
    mov rax, 1          ; Syscall: write
    mov rdi, 1          ; stdout
    mov rsi, listen_msg
    mov rdx, listen_len
    syscall

    ; ==================================
    ; 4. accept() loop
    ; ==================================
accept_loop:
    mov rax, 43         ; Syscall: accept
    mov rdi, r12        ; Server Socket FD
    mov rsi, 0          ; Client address struct (NULL)
    mov rdx, 0          ; Client address length (NULL)
    syscall             ; Blocks until a client connects
    
    mov r13, rax        ; Store the new client FD in R13

    ; --- CALL subroutine to handle the connection ---
    mov rdi, r13        ; Set RDI = client_fd as the argument
    call handle_client  
    
    ; --- Close the client FD ---
    mov rax, 3          ; Syscall: close
    mov rdi, r13
    syscall

    jmp accept_loop     ; Loop back to wait for the next client

    ; --- Exit (Shouldn't be reached) ---
    mov rax, 60         ; syscall: exit
    xor rdi, rdi
    syscall

; --------------------------------------
; Subroutine: handle_client (Prints connection message)
; Input: RDI = client_fd
; --------------------------------------
handle_client:
    push rbp            ; Prologue (save base pointer)
    mov rbp, rsp        ; Set new base pointer
    push rdi            ; Save client_fd

    ; --- Print "Client connected..." message to stdout ---
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, conn_msg
    mov rdx, conn_len
    syscall

    ; --- Add actual data handling logic here (read/write on the socket) ---
    ; Example: Send a 'Hello' response back to the client FD (RDI)
    ; mov rax, 1          ; syscall: write
    ; mov rdi, [rbp-8]    ; retrieve client_fd from stack (if pushed earlier)
    ; mov rsi, hello_reply_msg
    ; mov rdx, hello_reply_len
    ; syscall
    
    pop rdi             ; Restore client_fd
    pop rbp             ; Epilogue (restore base pointer)
    ret                 ; Return to the accept_loop
