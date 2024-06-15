; nasm -f bin ./boot.asm -o ./boot.bin
; qemu-system-x86_64 -hda ./boot.bin

; specify assembly origins
ORG 0x7c00                           ; where bootloader loads to. should start at 0 then JMP but will do this for now
BITS 16                             ; tell assembler that we're using 16-bit architecture

; interrupt table: https://www.ctyme.com/intr/int.htm
start:
    mov si, message                 ; move address of message into si
    call print                      ; call print subroutine
    jmp $

print:
    mov bx, 0
.loop:
    lodsb                           ; load char value from si into al
    cmp al, 0
    je .done                        ; we've hit 0. nothing else to print!
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh                     ; assembly refresher: ah is high portion of eax
    int 0x10                        ; set up interrupt. cf. table
    ret

message: db 'Hello World!', 0

times 510- ($ - $$) db 0            ; fill at least 510 bytes of data, pad with 0s
dw 0xAA55                           ; reminder: Intel machines are little-endian!
                                    ; write two bytes