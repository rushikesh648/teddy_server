; Pop any non-volatile registers you pushed
mov rsp, rbp    ; Restore the stack pointer
pop rbp         ; Restore the old base pointer
ret
