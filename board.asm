Public drawGrid
Public drawSquare

    ;.286
    .MODEL HUGE
    
    .STACK 64
	.DATA
    ;include setup.asm

cellDimension   equ     100
whiteColor      equ     0fh


	.CODE

drawSquare    PROC    FAR

    ; Usage: specify the starting x and y (cx, dx) before calling
    ;        al -> color

    mov si, cx
    add si, cellDimension

    mov bp, dx
    add bp, cellDimension

    ;mov al, 0fh        ;Pixel color
    mov ah, 0ch      ;Draw Pixel Command
rowSquare: 
colSquare: 
    int 10h
    inc cx
    cmp cx, si
    jnz colSquare
    
    sub cx, cellDimension
    inc dx
    cmp dx, bp
    jnz rowSquare

    mov cx, si

    ret

drawSquare    ENDP


drawRow     PROC    FAR

    ; Usage: 
    ; al -> color
    ; di -> number of squares (4 - di)
    ; cx -> start col
    ; dx -> start row

row:
    ;mov al, whiteColor
    call drawSquare
    add cx, cellDimension
    SUB dx, cellDimension
    inc di
    ; draw 4 times
    cmp di, 4
    jnz row
    
    ret

drawRow    ENDP


drawGridOneColor    PROC    FAR

    ; * Draws 200 * 200 pixels grid
    ; ! Alot of registers is used in this proc

    ; Usage
    ; Better make pusha before proc and popa after
    ; cx -> start drawing
    
    ; TODO: specify the start positions

    ;mov cx, 0       ; Column
    mov dx, 0       ; Row
    mov di, 0       ; Num of squares
    mov bl, 0       ; Num of rows
    ;mov bh, 0       ; Parity

full:
    call drawRow
    add dx, cellDimension
    
    cmp bh, 0
    jnz shiftedSquares
    ; Four shifted sqaures
    mov cx, cellDimension
    mov di, 0
    inc bh      ; Switch to four sqaures next loop
    jmp normalSquares

shiftedSquares:
    ; Four shifted sqaures
    mov cx, 0
    mov di, 0
    dec bh      ; Switch to three sqaures next loop

normalSquares:
    inc bl
    cmp bl, 8
    jnz full

    ret

drawGridOneColor    ENDP

drawGrid    PROC    FAR

    ; Graphics mode    
    mov ax, 4f02h
    mov bx, 0107h
    int 10h

    mov cx, cellDimension       ; Column
    mov al, 07h
    mov bh, 1
    call drawGridOneColor

    mov cx, 0       ; Column
    mov al, 06h
    mov bh, 0
    call drawGridOneColor

    ret

drawGrid    ENDP

END

; MAIN	PROC    FAR
    
;     mov ax, @data
;     mov ds, ax

;     ; Graphics mode    
;     mov ax, 4f02h
;     mov bx, 0107h
;     int 10h

;     call drawGrid


;     ; Press any key to exit
;     MOV AH , 0
;     INT 16h
    
    
;     ;Change to Text MODE
;     MOV AH,0          
;     MOV AL,03h
;     INT 10h 

;     ; return control to operating system
;     MOV AH , 4ch
;     INT 21H

; MAIN	ENDP
; END	MAIN