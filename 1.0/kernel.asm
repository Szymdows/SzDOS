org 0x0000

    ; Set up segments
    mov ax, 0x1000
    mov ds, ax
    mov es, ax

    ; Print "SzDOS"
    mov ah, 0x0E
    mov al, 'S'
    int 0x10
    mov al, 'z'
    int 0x10
    mov al, 'D'
    int 0x10
    mov al, 'O'
    int 0x10
    mov al, 'S'
    int 0x10
    
    ; Newline
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10

print_prompt:
    ; Print "C:\"
    mov ah, 0x0E
    mov al, 'C'
    int 0x10
    mov al, ':'
    int 0x10
    mov al, '\'
    int 0x10
    
    ; Reset input buffer
    mov di, input_buffer
    mov cx, 0

input_loop:
    mov ah, 0x00
    int 0x16
    
    cmp al, 13
    je handle_enter
    
    cmp al, 8
    je handle_backspace
    
    cmp al, 32
    jb input_loop
    cmp al, 126
    ja input_loop
    
    cmp cx, 79
    jge input_loop
    
    stosb
    inc cx
    mov ah, 0x0E
    int 0x10
    
    jmp input_loop

handle_backspace:
    test cx, cx
    jz input_loop
    
    dec di
    dec cx
    
    mov ah, 0x0E
    mov al, 8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10
    
    jmp input_loop

handle_enter:
    ; Null terminate
    mov al, 0
    stosb
    
    ; Newline
    mov ah, 0x0E
    mov al, 13
    int 0x10
    mov al, 10
    int 0x10
    
    ; Check commands
    mov al, [input_buffer]
    cmp al, 'h'
    je cmd_help
    cmp al, 'c'
    je cmd_clear
    cmp al, 'd'
    je cmd_dir
    cmp al, 'v'
    je cmd_ver
    cmp al, 'a'
    je cmd_about
    
    ; Unknown command
    jmp print_prompt

cmd_help:
    mov si, help_text
    call print_string
    jmp print_prompt

cmd_clear:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    jmp print_prompt

cmd_dir:
    mov si, dir_text
    call print_string
    jmp print_prompt

cmd_ver:
    mov si, ver_text
    call print_string
    jmp print_prompt

cmd_about:
    mov si, about_text
    call print_string
    jmp print_prompt

print_string:
    mov ah, 0x0E
print_loop:
    lodsb
    test al, al
    jz print_done
    int 0x10
    jmp print_loop
print_done:
    ret

help_text db 'Commands: help, clear, dir, ver, about', 13, 10, 0
dir_text db ' Directory of C:\', 13, 10, 13, 10
         db 'bootloader.bin    512 bytes', 13, 10
         db 'kernel.bin       512 bytes', 13, 10
         db '         2 files', 13, 10, 0
ver_text db 'SzDOS Version 1.0', 13, 10, 0
about_text db 'SzDOS - Simple Operating System', 13, 10
           db 'Created in x86 Assembly', 13, 10, 0

input_buffer times 80 db 0
