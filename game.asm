    .286

extrn Cell_To_Be_Moved:Byte
EXTRN   kingKilled:Byte

EXTRN drawGrid:FAR
EXTRN drawSquare:FAR
EXTRN piecesInit:FAR
extrn highInit:FAR
extrn highlight:FAR
extrn movePiecesUp:FAR
extrn movePiecesDown:FAR
extrn movePiecesRight:FAR
extrn movePiecesLeft:FAR
extrn movePiecesUpRight:FAR
extrn movePiecesUpLeft:FAR
extrn movePiecesDownRight:FAR
extrn movePiecesDownLeft:FAR
extrn setPlayerOneSelection:FAR
extrn setPlayerTwoSelection:FAR

extrn timerInit:FAR
extrn uartInit:FAR
extrn inlineChatting:FAR

extrn BigCheck_CallPosKing:FAR
extrn Checkmate:FAR

public scanCode
public game

    .MODEL HUGE
    .STACK 64
    .DATA


scanCode        db      ?

    .CODE

receiveChar     proc    FAR

    ;Check that Data Ready
    mov dx , 3FDH		; Line Status Register
    in al , dx
    AND al , 1
    JZ didntRec

    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx
    
    mov scanCode, al

jmp endRec

didntRec:
    mov ax, 0

endRec:
    ret

receiveChar     ENDP

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
        out dx , al

        pusha
        ; testing
        mov cl, al
        mov dl, cl
        add dl, 44h
        mov ah, 2
        int 21h
        popa

        ret
sendChar endp

init    PROC    FAR

    ; ; make this first (otherwise will exit graphics mode then enter again with empty screen)
    ; call LoadAllPieces

    ; initialize board
    call drawGrid
    
    ; initialize pieces
    call piecesInit

    ; highlight init
    call highInit

    call timerInit
    call uartInit

    ret

init ENDP

; MAIN    PROC    FAR
    
;     mov ax, @data
;     mov ds, ax

game    PROC    FAR

    call init

    ; TODO gameLoop
    ; read input
    ; read char from user

loop_1:

    pusha
    call BigCheck_CallPosKing
    popa
    pusha
    call Checkmate
    popa

    ; TODO reviece
    ; if valid input -> convert to WASD, Q
noInput:
    call receiveChar
    cmp ax, 0
    jne receivedChar
    ; get input without waiting
    mov ah,1
    int 16h
    jz noInput

    pusha
    ; consume buffer
    mov ah,0
    int 16h
    popa

    ; ; wait for input
    ; mov ah,0
    ; int 16h
    push ax
    mov al, ah
    mov scanCode, al
    call sendChar
    pop ax

    ; todo xchg ah, al

receivedChar:


    ; TODO if player one pressed on player's 2 input -> return to loop_1

    ; otherwise send, then continue

player2:

    ; F1
    cmp ah, 3bH
    JE Start_Chatting_Inline

    cmp ah, 62
    JE endGame

    ; pusha
    ; ; testing
    ; mov cl, ah
    ; mov dl, cl
    ; add dl, 30h
    ; mov ah, 2
    ; int 21h
    ; popa
    ; pusha
    ; ; testing
    ; mov cl, al
    ; mov dl, cl
    ; mov ah, 2
    ; int 21h
    ; popa

    push ax
    push bx
    call highlight
    pop bx
    pop ax
    

    push ax
    ; check for m
    cmp scanCode,50 ;sheck if input is M (pl2)(<^v>)
    JNE skip_M
    pusha
    call setPlayerOneSelection
    popa
    skip_M:
    pop ax

    cmp kingKilled, 1
    je endGame
    cmp kingKilled, 2
    je endGame

    push ax
    ; check for q
    cmp scanCode,16 ;sheck if input is q (pl1)(WASD)
    JNE skip_q
    ;mov si, 2           ; player2
    pusha
    call setPlayerTwoSelection
    popa
    skip_q:
    pop ax
    
jmp loop_1 ; loop Forever need to be changed example: waiting for an input to stop the game


Start_Chatting_Inline:
    pusha
    call inlineChatting
    popa
    jmp loop_1


endGame:
    ret

game    ENDP
; MAIN    ENDP 
END ;MAIN

; todo check diagonal white (test black also) 
