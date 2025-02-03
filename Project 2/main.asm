code segment
    mov ax, 0h  
    mov bx, 0h
    mov cx, 0h
    mov dx, 0h
    mov si, 0h
    jmp start

start:
	mov ah,01h				; reads a character to al
	int 21h	                ; check input type
    cmp al, 20h    ; if blank
    je blank
    cmp al, 2Bh    ; if '+'
    je addition
    cmp al, 2Ah    ; if '*'
    je multiplication
    cmp al, 2Fh    ; if '/'
    je division
    cmp al, 5Eh    ; if '^'
    je bitXor
    cmp al, 26h    ; if '&'
    je bitAnd
    cmp al, 7Ch    ; if '|'
    je bitOr
    cmp al, 0Dh    ; if enter
    je dummy
; input is a number
    mov si, 01h
    cmp al, 40h    ;if less then 40h then the number is between 0-9
    jb number
    cmp al, 40h    ;if higher then the number is between A-from
    ja letter_number
    jmp calculate

blank:
    cmp si, 0h
    je start     ;continue reading input
    push bx
    mov bx, 0h
    jmp start

addition:
    mov si, 0h
    pop bx        ;pop into bx
    pop ax        ;pop into ax
    add ax, bx
    push ax       ;ax onto stack
    mov bx, 0h
    jmp start     ; performed operation continue reading input

multiplication:
    mov si, 0h
    pop bx
    pop ax
    mul bx        ;al*bx->ax
    push ax
    mov bx, 0h
    jmp start     ; performed operation continue reading input

division:
    mov si, 0h
    mov dx, 0
    pop bx
    pop ax
    div bx
    push ax
    mov bx, 0h
    jmp start     ; performed operation continue reading input

dummy:
    jmp output

bitXor:
    mov si, 0h
    pop bx
    pop ax
    xor ax, bx
    push ax
    mov bx, 0h
    jmp start     ; performed operation continue reading input

bitAnd:
    mov si, 0h
    pop bx
    pop ax
    and ax, bx
    push ax
    mov bx, 0h
    jmp start     ; performed operation continue reading input

bitOr:
    mov si, 0h
    pop bx
    pop ax
    or ax, bx
    push ax
    mov bx, 0h
    jmp start      ; performed operation continue reading input

number:
    sub al, '0'     ; find difference with '0' which is decimal value
    jmp calculate 

letter_number:
    sub al, 'A'  
    add al, 10d     ; find difference with 'A' and add 10 
    jmp calculate

calculate:
    mov cx, 0h
    mov cl, al      ; copy the input to cl
    mov ax, 10h
    mul bx
    add cx, ax
    mov bx, cx
    jmp start

output:
    mov ah, 02h
    mov dl, 10d
    int 21h         ;print new line
    mov dl, 13d
    int 21h         
    pop ax
    mov bx, 10h
    mov cx, 0h      ;to calculate leading zeros
    mov dx, 0h
    div bx
    push dx         ;push the remainder to the stack
    inc cx
         
    cmp ax, 0h    ;if quotient is 0 then end
    je threezero

    mov dx, 0h
    div bx
    push dx         ;same process for 4 times because we can have 16 bits
    inc cx
    cmp ax, 0h 
    je twozero

    mov dx, 0h
    div bx
    push dx         
    inc cx
    cmp ax, 0h      
    je onezero

    push ax         
    inc cx        ;push the last digit
    jmp last

threezero:
    mov dx, 0h
    inc cx
    push dx
    mov dx, 0h
    inc cx
    push dx
    mov dx, 0h
    inc cx
    push dx
    jmp last

twozero:
    mov dx, 0h
    inc cx
    push dx
    mov dx, 0h
    inc cx
    push dx
    jmp last

onezero:
    mov dx, 0h
    inc cx
    push dx
    jmp last

last:
    mov ah, 02h       ;print
    pop dx
    cmp dl, 9h
    jg letter_output    ;greater than 9 than a letter will be printed
    add dl, '0'
    jmp continue

letter_output:
    sub dl, 10d
    add dl, 'A'
    jmp continue

continue:
    int 21h      ;print
    dec cx       ;if cx is not 0 continue the process
    jnz last
    int 20h      ;quit
    
code ends