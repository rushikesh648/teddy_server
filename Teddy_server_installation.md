Install Dependencies 📦
```
bash
# Update package lists
sudo apt update

# Install the Netwide Assembler (NASM)
sudo apt install nasm -y

# Optional: Install a compiler (GCC) and linker (LD) if not present
sudo apt install build-essential -y
```
Clone the Keto Repository and Setup Directory 📂
```
bash
# Create a dedicated directory for your server project
mkdir teddy-server-install
cd teddy-server-install

# Clone the repository (as a reference/source)
git clone https://github.com/rushikesh648/Keto.git

# Create the Teddy Server source file
nano teddy_server.asm
```
Insert the Server Assembly Code 📝
Paste the Assembly network code (the structure for socket, bind, listen, etc.) into the teddy_server.asm file.
```
bash
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
    
    hello_msg db "Hello from Teddy Server! Connection closed.", 0xa
    hello_len equ $ - hello_msg

section .text
    global _start
    
; --- Syscall Registers for x86-64 Linux ---
; RAX: Syscall Number | RDI: Arg 1 | RSI: Arg 2 | RDX: Arg 3

_start:
    ; ==================================
    ; 1. socket() call (Syscall #41)
    ; ==================================
    mov rax, 41         
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, 0
    syscall
    mov r12, rax        ; Save the server socket FD in R12
    
    ; ==================================
    ; 2. bind() call (Syscall #49)
    ; ==================================
    mov rax, 49         
    mov rdi, r12
    mov rsi, server_addr
    mov rdx, addr_len
    syscall
    
    ; ==================================
    ; 3. listen() call (Syscall #50)
    ; ==================================
    mov rax, 50         
    mov rdi, r12
    mov rsi, 10         ; Backlog size
    syscall
    
    ; Output Status to console (Syscall #1)
    mov rax, 1          
    mov rdi, 1          ; stdout
    mov rsi, listen_msg
    mov rdx, listen_len
    syscall

    ; ==================================
    ; 4. accept() loop (Syscall #43)
    ; ==================================
accept_loop:
    mov rax, 43         
    mov rdi, r12        ; Server Socket FD
    mov rsi, 0          ; Client address struct (NULL)
    mov rdx, 0          ; Client address length (NULL)
    syscall             
    
    mov r13, rax        ; Store the new client FD in R13

    ; --- CALL subroutine to handle the connection ---
    mov rdi, r13        ; Set RDI = client_fd as the argument
    call handle_client  
    
    ; --- Close the client FD (Syscall #3) ---
    mov rax, 3          
    mov rdi, r13
    syscall

    jmp accept_loop     ; Loop back to wait for the next client

    ; --- Exit (Shouldn't be reached) ---
    mov rax, 60         
    xor rdi, rdi
    syscall

; --------------------------------------
; Subroutine: handle_client (Sends a basic TCP message)
; Input: RDI holds the client_fd
; --------------------------------------
handle_client:
    push rbp            ; Prologue
    mov rbp, rsp        
    
    ; Send the hello message to the client FD (RDI)
    mov rax, 1          ; syscall: write
    ; RDI (client_fd) is already set as Arg 1
    mov rsi, hello_msg  ; Arg 2: Address of message
    mov rdx, hello_len  ; Arg 3: Length of message
    syscall
    
    pop rbp             ; Epilogue
    ret                 ; Return to the accept_loop
```
Build the Teddy Server Executable
```
bash
# 1. Assemble the code: 
# Compiles the teddy_server.asm source into an object file (teddy_server.o)
nasm -f elf64 teddy_server.asm -o teddy_server.o

# 2. Link the object file: 
# Creates the final executable binary file (teddy_server)
ld teddy_server.o -o teddy_server
```
Run the Teddy Server 🚀
```
bash
# Execute the server binary
./teddy_server
```
