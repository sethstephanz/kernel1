; nasm -f bin ./boot.asm -o ./boot.bin
; qemu-system-x86_64 -hda ./boot.bin

; specify assembly origins
ORG 0
BITS 16                             ; tell assembler that we're using 16-bit architecture
_start:
    jmp short start
    nop                             ; required for BIOS parameter block

times 33 db 0                       ; create 33 bytes to avoid real BIOS from corrupting/"correcting" code
; interrupt table: https://www.ctyme.com/intr/int.htm
start:
    jmp 0x7c0:step2

step2:
    ; don't trust BIOS to set things up correctly. set it up outselves
    cli                             ; clear interrupts
    mov ax, 0x7c0                   ; have to move this to ax first before transferring to data segment
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti                             ; enable interrupts

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