.286
extrn playerOneName:Byte

public VALUE
public uartInit
public sendChar
public receiveChar
public waitReceiveChar
public chatting
public inlineChatting

    .MODEL HUGE
    .STACK 128
    .DATA

value db ?, "$"
messsageUser1 DB 'user1', 0AH, 0DH, "$"
messsageUser2 DB 'user2', 0AH, 0DH, "$"

user2X   DB  41
user2Y   DB  1

enterKeyCode        equ     13
backSpaceKeyCode    equ     08

; cursorOffset    equ     88
cursorOffset    db     ?


    .CODE

printHeader proc FAR
; mov ah, 9

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

sendChar        proc FAR

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

receiveChar proc FAR

    ;Check that Data Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx
    AND al , 1
    JNZ didntRecMax
    jmp didntRec
    didntRecMax:

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
    add dl, cursorOffset   ;x
    int 10h

    inc user2X
    cmp user2X, 79
    jb notLast
    mov user2X, 41
    ; add user2X, cursorOffset
    inc user2Y
notLast:


    cmp VALUE, enterKeyCode
    Jne notEnterRec

    ; move cursor
    mov ah,2
    mov dh, user2Y ;y
    inc dh
    mov dl, 41 ;x 
    add dl, cursorOffset   ;x
    int 10h

    mov user2Y, dh ;y
    mov user2X, 41 ;y

tryScroll:
    cmp user2Y, 24 ;y
    jb noScroll


    dec user2y

    ; scroll up
    mov ah, 6
    mov al, 1
    mov bh, 0
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80
    int 10h

    call printHeader
    ; move cursor
    mov ah,2
    mov dh,24 ;y
    mov dl,28h ;x 
    int 10h
    mov ah,2
    mov dl,'|'
    int 21h

    ; ; move cursor
    ; mov ah,2
    mov user2Y, 23 ;y
    mov user2X, 41 ;x 
    ; add dl, cursorOffset   ;x
    ; int 10h

noScroll:

    ; ; get cursor position
    ; mov ah, 3h
    ; mov bh, 0h
    ; int 10h

    ; pusha
    ; ; move cursor
    ; mov ah,2
    ; mov dh,1 ;y
    ; mov dl,2 ;x 
    ; int 10h
    ; ; testing
    ; mov dl, VALUE
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    ; ; move cursor
    ; mov ah,2 
    ; int 10h

    jmp retCursor


notEnterRec:
    ; ; print char
    ; mov ah, 09 
    ; mov dx, offset value
    ; int 21h

    mov ah,2
    mov dl, VALUE
    int 21h

retCursor:
    ; move cursor
    pop dx
    mov ah,2
    int 10h
    jmp endRec

didntRec:
    ; mov VALUE, ' '

endRec:
    ret

receiveChar endp

waitReceiveChar proc FAR

didntRecWait:
    ;Check that Data Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx
    AND al , 1
    JZ didntRecWait

    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx 
    mov VALUE , al

endRecWait:
    ret

waitReceiveChar endp

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
        

        ; call uartInit

        ;Change to Text MODE
        MOV AH,0
        MOV AL,03h
        INT 10h

        mov cursorOffset, 0

        ; ; move cursor
        ; mov ah,2
        ; mov dh,1 ;y
        ; mov dl,1 ;x 
        ; int 10h
        ; pusha
        ; ; testing
        ; mov dl, cursorOffset
        ; add dl, 30h
        ; mov ah, 2
        ; int 21h
        ; popa

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

        call printHeader

        ; get key pressed
getInput:

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
        add dl, cursorOffset ;x
        inc dh     ;y
        int 10h


skip:

        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h
        push dx

        call printHeader
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

        cmp al, 1bH ;escape
        JE exitChatting
        
        ;display character
        mov ah, 2
        mov dl, al
        int 21h

        ; consume buffer
        mov ah,0
        int 16h

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
        push ax
        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h

        ; move cursor
        mov ah,2
        inc dh ;y
        mov dl, 0 ;x 
        int 10h

        ; pusha
        ; ; move cursor
        ; mov ah,2
        ; mov dh,1 ;y
        ; mov dl,1 ;x 
        ; int 10h
        ; ; testing
        ; mov dl, al
        ; add dl, 30h
        ; mov ah,2
        ; int 21h
        ; popa
        pop ax
         
notEnter:

        call sendChar


jmp getInput

        ; send
        ; repeat

exitChatting:
;     mov ah, 4ch
;     int 21h 


    ; consume buffer
    mov ah,0
    int 16h
    

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

    ret

; Main endp
chatting ENDP




inlineChatting proc FAR
        

        ; call uartInit

        mov cursorOffset, 88

        ; ; move cursor
        ; mov ah,2
        ; mov dh,1 ;y
        ; mov dl,159 ;x 
        ; int 10h
        ; pusha
        ; ; testing
        ; mov dl, cl
        ; add dl, 30h
        ; mov ah, 2
        ; int 21h
        ; popa

        mov cx, 24
spiltInline:
        push cx
        ; move cursor
        mov ah, 2
        mov dh, cl ;y
        mov dl, 28h ;x 
        add dl, cursorOffset ;x
        int 10h

        mov ah, 2
        mov dl, '|'
        int 21h
        pop cx
        loop spiltInline

        call printHeader

        ; get key pressed
getInputInline:

        ; ; move cursor
        ; mov ah,2
        ; mov dh,1 ;y
        ; mov dl,1 ;x 
        ; int 10h
        ; pusha
        ; ; testing
        ; mov dl, '$'
        ; ; add dl, 30h
        ; mov ah, 2
        ; int 21h
        ; popa

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

        push cx
        mov cl, cursorOffset
        add cl, 28h        
        cmp dl, cl
        pop cx 
        jne skipInline
        ; move cursor
        mov ah, 2
        mov dl, cursorOffset ;x 
        inc dh     ;y
        int 10h


skipInline:

        ; get cursor position
        mov ah,3h
        mov bh,0h
        int 10h
        push dx

        call printHeader
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

        cmp al, 1bH ;escape
        JE exitInline

        ; consume buffer
        mov ah,0
        int 16h

        ;display character
        mov ah, 2
        mov dl, al
        int 21h
        
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

        ; at the edge
        cmp dl, cursorOffset
        je notBackspaceInline

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
        mov dl, cursorOffset ;x 
        int 10h

notEnterInline:

        call sendChar


jmp getInputInline

        ; send
        ; repeat

exitInline:

    ; consume buffer
    mov ah,0
    int 16h

    ret

inlineChatting ENDP
END