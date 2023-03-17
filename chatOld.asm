.286
extrn playerOneName:Byte

public VALUE
public uartInit
public sendChar
public receiveChar
public chatting
public inlineChatting

    .MODEL HUGE
    .STACK 100h
    .DATA

value db ?, "$"
messsageUser1 DB 'user1', 0AH, 0DH, "$"
messsageUser2 DB 'user2', 0AH, 0DH, "$"

user2X   DB  41
user2Y   DB  1

enterKeyCode        equ     13
backSpaceKeyCode    equ     08

cursorOffset    equ     88


    .CODE

printHeader proc FAR
; mov ah, 9

        ; move cursor
        mov ah,2
        mov dh,0 ;y
        mov dl,40 ;x 
        int 10h
        mov ah,9
        mov dx, offset messsageUser2
        int 21h

        ; move cursor
        mov ah,2
        mov dh,0 ;y
        mov dl,0 ;x 
        int 10h
        mov ah, 9
        mov dx, offset playerOneName
        int 21h
        ; move cursor
        mov ah,2
        mov dh,1 ;y
        mov dl,0 ;x 
        int 10h
        ret

printHeader endp

inlineprintHeader proc FAR

        ; move cursor
        mov ah,2
        mov dh,0 ;y
        mov dl,40 ;x 
        add dl, cursorOffset ;x 
        int 10h
        mov ah,9
        mov dx, offset messsageUser2
        int 21h

        ; move cursor
        mov ah,2
        mov dh,0 ;y
        mov dl,0 ;x 
        add dl, cursorOffset ;x 
        int 10h
        mov ah, 9
        mov dx, offset playerOneName
        int 21h
        ; move cursor
        mov ah,2
        mov dh,1 ;y
        mov dl,0 ;x 
        add dl, cursorOffset ;x 
        int 10h
        ret

inlineprintHeader endp

sendChar        proc

        ; usage
        ; al -> char to send

        push ax
        ;Check that Transmitter Holding Register is Empty
        mov dx , 3FDH		; Line Status Register
AGAIN:  
        In al , dx 			;Read Line Status
        AND al , 00100000b
        JZ AGAIN

        ;If empty put the VALUE in Transmit data register
        mov dx , 3F8H		; Transmit data register
        pop ax
        ;mov al, "A"
        out dx , al

        ret
sendChar endp

receiveChar proc

    ;Check that Data Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx
    AND al , 1
    JZ didntRec

    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    mov VALUE , al


    ; get cursor position
    mov ah,3h
    mov bh,0h
    int 10h
    push dx

    ; move cursor
    mov ah,2
    mov dh, user2Y ;y
    mov dl, user2X ;x 
    int 10h

    inc user2X
    cmp user2X, 79
    jne notLast
    mov user2X, 41
    inc user2Y
notLast:

    ; pusha
    ; ; testing
    ; mov dl, VALUE
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    cmp VALUE, enterKeyCode
    Jne notEnterRec
    ; get cursor position
    mov ah, 3h
    mov bh, 0h
    int 10h

    ; move cursor
    mov ah, 2
    inc dh      ;y
    mov dl, 41   ;x 
    int 10h
    jmp retCursor


notEnterRec:
    ; print char
    mov ah, 09 
    mov dx, offset value
    int 21h

retCursor:
    ; move cursor
    pop dx
    mov ah,2
    int 10h
    jmp endRec

didntRec:
    mov VALUE, ' '

endRec:
    ret

receiveChar endp

; Main proc FAR
;     mov ax, @data
;     mov ds, ax

uartInit    PROC    FAR

    ; initinalize COM
    ;Set Divisor Latch Access Bit
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it
    ;Set LSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f8h
    mov al,0ch			
    out dx,al

    ;Set MSB byte of the Baud Rate Divisor Latch register.
    mov dx,3f9h
    mov al,00h
    out dx,al

    ;Set port configuration
    mov dx,3fbh
    mov al,00011011b
    out dx,al

    ret

uartInit    ENDP



chatting proc FAR
        

        call uartInit

        ;Change to Text MODE
        MOV AH,0
        MOV AL,03h
        INT 10h

        mov cx, 24
spilt:
        push cx
        ; move cursor
        mov ah,2
        mov dh,cl ;y
        mov dl,28h ;x 
        int 10h

        mov ah,2
        mov dl,'|'
        int 21h
        pop cx
        loop spilt

        call inlineprintHeader

        ; get key pressed
getInput:

        ;recieve
        ; ;Check that Data is Ready
        ; mov dx , 3FDH ; Line Status Register
        ; CHK: in al , dx
        ; test al , 1
        ; JZ CHK ;Not Ready
        ; ;If Ready read the VALUE in Receive data register
        ; mov dx , 03F8H
        ; in al , dx
        ; mov VALUE , al

        ; check for overflow
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h

        cmp dl, 28h
        jne skip
        ; move cursor
        mov ah, 2
        mov dl, 0 ;x 
        inc dh     ;y
        int 10h


skip:

        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h
        push dx

        call inlineprintHeader
        ; move cursor
        mov ah,2
        mov dh,24 ;y
        mov dl,28h ;x 
        int 10h
        mov ah,2
        mov dl,'|'
        int 21h

        ; move cursor
        pop dx
        mov ah,2
        int 10h

        ; ; wait for input
        ; mov ah,1
        ; int 21h

noInput:
        call receiveChar
        ; get input without waiting
        mov ah,1
        int 16h
        jz noInput

        ;display character
        mov ah, 2
        mov dl, al
        int 21h

        ; consume buffer
        mov ah,0
        int 16h

        cmp al, 1bH ;escape
        JE exit
        
        cmp al, backSpaceKeyCode
        jne notBackspace
        ; Add space
        mov ah, 2
        mov dl, ' '
        int 21h
        
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h
        ; move cursor
        mov ah,2
        ;mov dh, 1   ;y 
        dec dl      ;x
        int 10h

notBackspace:
        cmp al, enterKeyCode
        Jne notEnter
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h

        ; move cursor
        mov ah,2
        inc dh ;y
        mov dl, 0 ;x 
        int 10h

notEnter:

        call sendChar


jmp getInput

        ; send
        ; repeat

exit:
;     mov ah, 4ch
;     int 21h 


        ; ; wait for key to exit
        ; mov ah,0
        ; int 16h

    ; Clear screen
    mov ax, 3
    int 10h

        ; ;clear screen
        ; mov ax,0600h
        ; mov bh,07
        ; mov cx,0
        ; mov dx,184FH
        ; int 10h

        ; ;return control to operating system
        ; MOV AH , 4ch
        ; INT 21H


; Main endp
chatting ENDP




inlineChatting proc FAR
        

        call uartInit

        mov cx, 24
spiltInline:
        push cx
        ; move cursor
        mov ah, 2
        mov dh, cl ;y
        mov dl, 28h ;x 
        add dl, cursorOffset ;x
        int 10h

        mov ah,2
        mov dl,'|'
        int 21h
        pop cx
        loop spiltInline

        call inlineprintHeader

        ; get key pressed
getInputInline:

        ;recieve
        ; ;Check that Data is Ready
        ; mov dx , 3FDH ; Line Status Register
        ; CHK: in al , dx
        ; test al , 1
        ; JZ CHK ;Not Ready
        ; ;If Ready read the VALUE in Receive data register
        ; mov dx , 03F8H
        ; in al , dx
        ; mov VALUE , al

        ; check for overflow
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h

        cmp dl, 28h
        jne skipInline
        ; move cursor
        mov ah, 2
        mov dl, 0 ;x 
        inc dh     ;y
        int 10h


skipInline:

        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h
        push dx

        call inlineprintHeader
        ; move cursor
        mov ah,2
        mov dh,24 ;y
        mov dl,28h ;x
        add dl, cursorOffset ;x 
        int 10h
        mov ah,2
        mov dl,'|'
        int 21h

        ; move cursor
        pop dx
        mov ah,2
        int 10h

        ; ; wait for input
        ; mov ah,1
        ; int 21h

noInputInline:
        call receiveChar
        ; get input without waiting
        mov ah,1
        int 16h
        jz noInputInline

        ;display character
        mov ah, 2
        mov dl, al
        int 21h

        ; consume buffer
        mov ah,0
        int 16h

        cmp al, 1bH ;escape
        JE exitInline
        
        cmp al, backSpaceKeyCode
        jne notBackspaceInline
        ; Add space
        mov ah, 2
        mov dl, ' '
        int 21h
        
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h
        ; move cursor
        mov ah,2
        ;mov dh, 1   ;y 
        dec dl      ;x
        int 10h

notBackspaceInline:
        cmp al, enterKeyCode
        Jne notEnterInline
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h

        ; move cursor
        mov ah,2
        inc dh ;y
        mov dl, 0 ;x 
        int 10h

notEnterInline:

        call sendChar


jmp getInputInline

        ; send
        ; repeat

exitInline:


inlineChatting ENDP
END