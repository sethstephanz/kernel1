; specify assembly origins
ORG 0x7c00                          ; where bootloader loads to. should start at 0 then JMP but will do this for now
BITS 16                             ; tell assembler that we're using 16-bit architecture

; interrupt table: https://www.ctyme.com/intr/int.htm
start:
    ; basic BIOS routine
    mov ah, 0eh                     ; assembly refresher: ah is high portion of eax
    mov al, 'A'
    mov bx, 0
    int 0x10                        ; set up interrupt cf. table

    jmp $

times 510- ($ - $$) db 0            ; fill at least 510 bytes of data, pad with 0s
dw 0xAA55                           ; reminder: Intel machines are little-endian!