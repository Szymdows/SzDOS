org 0x7C00

    ; Load kernel from sector 2
    mov bx, 0x1000
    mov es, bx
    xor bx, bx
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    int 0x13

    jc $

    jmp 0x1000:0000

times 510-($-$$) db 0
dw 0xAA55
