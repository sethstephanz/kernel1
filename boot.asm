// specify assembly origins
ORG 0x7c00          // where bootloader loads to. should start at 0 then JMP but will do this for now
BITS 16             // tell assembler that we're using 16-bit architecture

// interrupt table: https://www.ctyme.com/intr/int.htm
start:
    // basic BIOS routine
    mov ah, 0eh     // assembly refresher: ah = high part of eax
    mov al, 'A'
    int 0x10        // set up interrupt