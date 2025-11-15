; Assuming R13 holds the client_fd

    ; ==================================
    ; Syscall: write() (Syscall #1)
    ; write(fd, buffer, count)
    ; ==================================
    mov rax, 1              ; Syscall: write
    mov rdi, r13            ; Arg 1: Client Socket FD
    mov rsi, PACKET_BUFFER  ; Arg 2: Address of the constructed packet
    mov rdx, PACKET_SIZE    ; Arg 3: Total size of the packet (33 bytes)
    syscall
    
    ; The client must now read 33 bytes and interpret the first 8 bytes
    ; according to the 'Teddy Protocol' rules.
