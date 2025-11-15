; Assuming this is part of the handle_client subroutine:
; RDI holds the client_fd

    ; --- 1. Copy Command ('TED1') ---
    mov rsi, COMMAND_TED1       ; Source address (4 bytes)
    mov rdi, PACKET_BUFFER      ; Destination address
    mov rcx, 4                  ; Count (4 bytes)
    rep movsb                   ; Copy 4 bytes (EAX is now at PACKET_BUFFER + 4)

    ; --- 2. Copy Length (25) ---
    mov rsi, PAYLOAD_LEN        ; Source address (4 bytes)
    mov rdi, PACKET_BUFFER + 4  ; Destination address
    mov rcx, 4                  ; Count
    rep movsb                   ; Copy 4 bytes

    ; --- 3. Copy Payload Data ---
    mov rsi, PAYLOAD_DATA       ; Source address (25 bytes)
    mov rdi, PACKET_BUFFER + 8  ; Destination address
    mov rcx, 25                 ; Count
    rep movsb                   ; Copy 25 bytes
