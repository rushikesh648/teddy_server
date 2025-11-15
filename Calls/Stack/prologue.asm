push rbp        ; Save the old base pointer
mov rbp, rsp    ; Set the new base pointer to the current stack pointer
; Push any other non-volatile registers (like RBX, R12-R15) you intend to modify
