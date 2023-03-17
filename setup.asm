    .286

extrn Value:Byte
EXTRN   kingKilled:Byte

extrn game:FAR
extrn uartInit:FAR
extrn chatting:FAR
extrn waitReceiveChar:FAR
extrn sendChar:FAR

public playerOneName

public GetUsername
public mainMenu

    .MODEL HUGE
    .STACK 64
	.DATA

getFirstNameMsg db "Please Enter your name: ", '$'
pressEnterMsg db "Press Enter key to continue...", '$'
chattingf1 db "To Start Chatting Press F1",'$'
gamef2 db "To Start the game Press F2",'$'
endprogram db "To End The Program Press ESC ",'$'
Chattest db "you entered chatting mode ",'$' ;testing remove
gametest db "you entered Game mode ",'$' ;testing remove
winnerMsg db "Winner winner chicken dinner!",'$' ;testing remove


; Note player name should not exceed 15 characters (+1 for $)
; Current player
maxNameSize         equ     15

playerOneSize       db     maxNameSize + 1, ? 
playerOneName       db     maxNameSize + 1 dup('$')
playerTwoSize       db     maxNameSize + 1, ? 
playerTwoName       db     maxNameSize + 1 dup('$')


enterKeyCode        equ     13
backSpaceKeyCode    equ     08

	.CODE

; ----------- Functions -----------
PrintMessage    PROC    FAR

    mov ah, 09
    int 21h
    ret

PrintMessage ENDP


GetUsername     PROC    FAR

repromptUser:

    mov cx, maxNameSize
    mov si, 0
clearName:
    mov playerOneName[si], '$'
    inc si
    loop clearName

; Clear screen
    mov ax, 3
    int 10h

    ; Print message
    mov dx, offset getFirstNameMsg
    call PrintMessage
    
    ; mov cursor for new row
    mov ah, 02
    mov dh, 5
    mov dl, 0
    MOV BX, 0
    int 10h

    ; Print continue msg
    mov dx, offset pressEnterMsg
    call PrintMessage

    ; mov cursor for new row
    mov ah, 02
    mov dh, 1
    mov dl, 4
    MOV BX, 0
    int 10h

    ; ; Get player one name
    ; mov ah,0AH
    ; mov dx,offset playerOneName
    ; int 21h

    mov cx, maxNameSize
    mov si, 0

    ; TODO wait for enter, backspace to delete

readChar:
    mov ah, 01
    int 21h

    cmp al, enterKeyCode
    je isRead

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
    mov dh, 1   ;y 
    dec dl      ;x
    int 10h
    jmp readChar


notBackspace:
    mov playerOneName[si], al
    inc si
    loop readChar

; If username is less than 15 (enter is pressed) -> break the loop
isRead:

    ; check for valid input (No digits or special characters, not exceed 15 characters "DONE while reading")

whileValidChar:
    cmp playerOneName[0], 'A'
    jb maxRepromptUser
    jmp contRepromptUser1
maxRepromptUser:
    jmp repromptUser
contRepromptUser1:

    cmp playerOneName[0], 'Z'
    jb valid

    cmp playerOneName[0], 'z'
    ja maxRepromptUser

    cmp playerOneName[0], 'a' ; We are sure that 'char' is not < 'Z'
    jb maxRepromptUser

valid:
    ; ; if we want to validate the whole name
    ; inc si
    ; cmp playerOneName[si], '$'
    ; jne whileValidChar

;     mov si, 0
;     ; send name
; sendName:

;     mov al, playerOneName[si]
;     call sendChar

;     cmp playerOneName[si], '$'
;     jne sendName

    ; recieve other's name

    ret

GetUsername     ENDP

mainMenu     PROC    FAR

    call uartInit

mainAgain:

    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 


    ; Clear screen
    mov ax, 3
    int 10h

    ;print main screen
    ; mov cursor to the middle  
    mov ah, 02
    mov dh, 3
    mov dl, 25
    MOV BX, 0
    int 10h

    ; Print message
    mov dx, offset chattingf1
    call PrintMessage

    ; mov cursor for new row  
    mov ah, 02
    mov dh, 6
    mov dl, 25
    MOV BX, 0
    int 10h

    ; Print to the start the game
    mov dx, offset gamef2
    call PrintMessage

    ; mov cursor for new row   
    mov ah, 02
    mov dh, 9
    mov dl, 25
    MOV BX, 0
    int 10h

    ; Print end program msg
    mov dx, offset endprogram
    call PrintMessage

    ;waiting for input
    Waiting_For_Input:
    mov ah,07
    int 21h


    cmp al,1bH
    JE max_Close_Program
    jmp cont_closeProgram
max_Close_Program:
    jmp Close_Program
cont_closeProgram:
    cmp al,3bH
    JE Start_Chatting
    cmp al,3cH
    JE Start_Game

     pusha
    ; testing
    mov dl, al
    sub dl, 30h
    mov ah, 2
    int 21h
    popa

    jNE  Waiting_For_Input 

Start_Game:

;     call sendChar

; recAgainGame:
;     ; wait for other user
;     call waitReceiveChar

;     cmp value, 3cH
;     jne recAgainGame



    call game

    ; Clear screen
    mov ax, 3
    int 10h

    cmp kingKilled, 1
    je playerOneWon
    cmp kingKilled, 2
    je playerTwoWon
    jmp mainA
playerOneWon:
    mov dx, offset playerOneName
    call PrintMessage
    mov dx, offset winnerMsg
    call PrintMessage

    mov dx, offset pressEnterMsg
    call PrintMessage

    ;waiting for input
    mov ah,07
    int 21h

playerTwoWon:
    mov dx, offset playerOneName
    call PrintMessage
    mov dx, offset winnerMsg
    call PrintMessage
    
    mov dx, offset pressEnterMsg
    call PrintMessage
    
    ;waiting for input
    mov ah,07
    int 21h

mainA:
    jmp mainAgain

Start_Chatting:
    
    call sendChar

recAgain:
    ; wait for other user
    call waitReceiveChar

    cmp value, 3bH
    jne recAgain

    call chatting
    jmp mainAgain

 Close_Program:
    mov al, 2
    jmp endProg

endProg:

    ret

mainMenu     ENDP
END

; todo: after enterring chatting we should wait for other player to enter too
