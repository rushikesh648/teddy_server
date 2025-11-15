section .text
    global _start
    
; --- Registers for x86-64 Linux Syscalls ---
; RAX: Syscall Number
; RDI: Arg 1
; RSI: Arg 2
; RDX: Arg 3

_start:
    ; ==================================
    ; 1. socket() call
    ; fd = socket(AF_INET, SOCK_STREAM, 0)
    ; RAX=41, RDI=2 (AF_INET), RSI=1 (SOCK_STREAM), RDX=0
    ; Result (file descriptor) stored in RAX
    ; ==================================
    mov rax, 41
    mov rdi, 2          ; AF_INET (IPv4)
    mov rsi, 1          ; SOCK_STREAM (TCP)
    mov rdx, 0          ; Protocol (default)
    syscall             ; Execute socket()
    mov r12, rax        ; Save the socket FD in R12 (non-volatile register)
    
    ; Add error checking here: if R12 < 0, handle error

    ; ==================================
    ; 2. bind() call
    ; bind(fd, &server_addr, addr_len)
    ; RAX=49, RDI=fd, RSI=&server_addr, RDX=addr_len
    ; ==================================
    mov rax, 49
    mov rdi, r12        ; Socket FD
    mov rsi, server_addr ; Address of the sockaddr_in structure
    mov rdx, addr_len   ; Size of the structure (16)
    syscall
    
    ; Add error checking here
    
    ; ==================================
    ; 3. listen() call
    ; listen(fd, backlog_size)
    ; RAX=50, RDI=fd, RSI=10 (backlog size)
    ; ==================================
    mov rax, 50
    mov rdi, r12        ; Socket FD
    mov rsi, 10         ; Backlog queue size
    mov rdx, 0          ; (unused)
    syscall
    
    ; Print listening message (using write syscall 1)
    mov rax, 1
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, msg_len
    syscall
    
    ; ==================================
    ; 4. accept() call (The core server loop starts here)
    ; new_fd = accept(fd, NULL, NULL)
    ; RAX=43, RDI=fd, RSI=NULL, RDX=NULL
    ; ==================================
accept_loop:
    mov rax, 43
    mov rdi, r12        ; Server Socket FD
    mov rsi, 0          ; Address to store client address (NULL for simplicity)
    mov rdx, 0          ; Address to store client address length (NULL for simplicity)
    syscall             ; Execute accept()
    
    mov r13, rax        ; Save the new client FD in R13

    ; Now you would insert your custom code here to CALL a subroutine 
    ; named "handle_client" using R13 (the client FD) as an argument.
    
    ; *** CALL instruction to handle a new connection ***
    ; RDI is used for the first argument, so move R13 (client_fd) into it.
    mov rdi, r13
    call handle_client  ; Jump to the routine that reads/writes data
    
    ; ==================================
    ; 5. close() call (after client handling)
    ; close(new_fd)
    ; RAX=3, RDI=new_fd
    ; ==================================
    mov rax, 3
    mov rdi, r13        ; Client Socket FD
    syscall
    
    jmp accept_loop     ; Loop back to wait for the next connection
    
    ; --- Subroutine Example (must be implemented) ---
handle_client:
    ; RDI holds the client_fd from the caller
    
    ; Example: Send a simple message back to the client FD (RDI)
    ; Write syscall (RAX=1) to client_fd (RDI)
    ; mov rax, 1
    ; syscall
    
    ret                 ; Return to the main loop
