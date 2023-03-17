    .286

extrn   sourceCellIndex:Byte
extrn   destCellIndex:Byte

public  timerInit
public  checkTime

    .MODEL HUGE
    .STACK 64
	.DATA

waitMsg     db  "Please wait$"
okayMsg     db  "Ok$"

; 128 byte!
timerGrid   dw  64 dup(0)

; solBlack1       dw  0
; solBlack2       dw  0
; solBlack3       dw  0

	.CODE

PrintMessage    PROC    FAR

    mov ah, 09
    int 21h
    ret

PrintMessage ENDP

convertTimeToSec        PROC    FAR

    ; ax -> time in sec
    ; cl: min, dh: sec
    mov dl, dh
    mov dh, 0

    mov al, cl
    mov bl, 60
    mul bl
    add ax, dx

    ret

convertTimeToSec    ENDP

timerInit       PROC    FAR

    ; get current time CL: min, DH: sec
    MOV AH,2CH
    INT 21h
    call convertTimeToSec

    ; to make the piece available to move in the first 3 seconds of game
    ; otherwise players will not be able to play the first 3 seconds
    sub ax, 3

    mov bx, 0
init:
    
    mov timerGrid[bx], ax

    add bx, 2
    cmp bx, 128
    jb init

    ; mov solBlack1, ax
    ; mov solBlack2[3], ax
    ; mov solBlack3, ax

    ret

timerInit   ENDP

checkTime       PROC    FAR

    ; bx index (should * by 2)
    mov bh, 0
    mov bl , sourceCellIndex
    mov al, bl
    mov bl, 2
    mul bl
    mov bx, ax
    push bx
    
    ; get current time CL: min, DH: sec
    MOV AH,2CH
    INT 21h
    call convertTimeToSec
    ; get the difference between current time and the time of last movement
    pop bx
    push ax
    sub ax, timerGrid[bx]
    cmp ax, 4
    jae validToMove
    jmp invalidToMove
validToMove:
    mov bh, 0
    mov bl, destCellIndex
    mov al, bl
    mov bl, 2
    mul bl
    mov bx, ax
    pop ax
    mov timerGrid[bx], ax
    mov ax, 1
    ; mov dx, offset okayMsg
    ; call PrintMessage
    jmp endCheckTime

invalidToMove:
    pop ax
    mov ax, 0
    ; mov dx, offset waitMsg
    ; call PrintMessage

endCheckTime:

    ; pusha
    ; ; testing
    ; mov dl, al
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa    

    ret

checkTime       ENDP

; MAIN	PROC    FAR
    
;     mov ax, @data
;     mov ds, ax

;     ;Change to Text MODE
;     MOV AH, 0
;     MOV AL, 03h
;     INT 10h

;     ; Clear screen
;     mov ax, 3
;     int 10h

;     ; init
;     call timerInit

; testLoop:

;     ;get user input
;     mov ah,0
;     int 16h
;     sub ax, 30h

;     mov bx, ax
;     call checkTime

;     cmp ax, 1
;     je move
;     jmp dontMove
; move:
;     mov dx, offset okayMsg
;     call PrintMessage
;     jmp testLoop

; dontMove:
;     mov dx, offset waitMsg
;     call PrintMessage
;     jmp testLoop

; endMain:

;     ;waiting for input
;     mov ah,07
;     int 21h

;     ;------------- Exit -------------
;     ;Change to Text MODE
;     MOV AH,0          
;     MOV AL,03h
;     INT 10h 

;     ; return control to operating system
;     MOV AH , 4ch
;     INT 21H

; MAIN	ENDP
END

; store last time of each piece
; when calling move function we should compare current time with last time
; if the difference is 0 or more -> piece can move (then update the last time of this piece to the current time)
; else don't move





; ;MUST BE called after any piece moved (that is white)

;         pusha
;     ; get current time CL: min, DH: sec  
;     MOV AH,2CH
;     INT 21h
;     call convertTimeToSec ;ax feha el curr time
      
;     mov bx,White_Destination_Index ;Var feh el destination index bta3 akher q
;     mov Time_grid_arr[bx],ax

;     popa


; ;MUST BE called before movement of any piece(that is white)
; ;again:
;     ;pusha
;     ;get row /col of player ely bydos q
;     mov dl,rowpl1
;     mov cl,colpl1
;     call ROW_COL_TO_Number

;     mov bx,Cell_To_Be_Moved
;     mov dx,Time_grid_arr[bx]

;     ; get current time CL: min, DH: sec
;     MOV AH,2CH
;     INT 21h
;     call convertTimeToSec
;     sub ax, dx ;subb el time el adem
;     cmp ax, 3
;     jae moreThan3
    
;     ;nothing

;     ;jmp Skip

; moreThan3:  ;Allow Movement

;     ;end of fn
;     ;popa





;     ; get current time CL: min, DH: sec
;     MOV AH,2CH
;     INT 21h
;     call convertTimeToSec
;     mov solBlack1, ax

; again:
;     ; get current time CL: min, DH: sec
;     MOV AH,2CH
;     INT 21h
;     call convertTimeToSec
;     sub ax, solBlack1
;     cmp ax, 5
;     jae moreThan5
;     mov dx, offset waitMsg
;     call PrintMessage
;     ; pusha
;     ; MOV     CX, 0fh
;     ; MOV     DX, 4240H ; delay 1 sec
;     ; mov     al, 0
;     ; MOV     AH, 86H
;     ; INT     15H
;     ; popa
;     jmp again

; moreThan5:
;     mov dx, offset okayMsg
;     call PrintMessage

;     ; TOP:
;     ; MOV AH,2CH
;     ; INT 21h
;     ; MOV BH,DH  ; DH has current second
;     ; GETSEC:      ; Loops until the current second is not equal to the last, in BH
;     ; MOV AH,2CH
;     ; INT 21h
;     ; CMP BH,DH  ; Here is the comparison to exit the loop and print 'A'
;     ; JNE PRINTA
;     ; JMP GETSEC
;     ; PRINTA:
;     ; mov ax, dx
;     ; aam
;     ; add ax, 3030h
;     ; MOV DL,al
;     ; MOV AH,02
;     ; INT 21h
;     ; ;JMP TOP
