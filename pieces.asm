.286

public DrawSoldierW
public DrawElephantW
public DrawQueenW
public DrawKingW
public DrawTabyaW
public DrawHourseW
public DrawSolderB
public DrawElephantB
public DrawQueenB
public DrawKingB
public DrawTabyaB
public DrawHourseB
public DrawPiece

.Model HUGE
.Stack 64
.Data

picWidth       EQU 100
picHeight      EQU 100

elephWhite_Filename DB '/p/eW.bmp', 0
HourseWhite_Filename DB '/p/hW.bmp', 0
KingWhite_Filename DB '/p/kW.bmp', 0
queenWhite_Filename DB '/p/qW.bmp', 0
soldierWhite_Filename DB '/p/sW.bmp', 0
tabyaWhite_Filename DB '/p/tW.bmp', 0

elephBlack_Filename DB '/p/eB.bmp', 0
HourseBlack_Filename DB '/p/hB.bmp', 0
KingBlack_Filename DB '/p/kB.bmp', 0
queenBlack_Filename DB '/p/qB.bmp', 0
soldierBlack_Filename DB '/p/sB.bmp', 0
tabyaBlack_Filename DB '/p/tB.bmp', 0

PiecesWhiteFilehandle DW ?

pieceData DB picWidth*picHeight dup(0)

; pieceData DB picWidth*picHeight dup(0)
; pieceData DB picWidth*picHeight dup(0)
; pieceData DB picWidth*picHeight dup(0)
; pieceData DB picWidth*picHeight dup(0)
; pieceData DB picWidth*picHeight dup(0)
; pieceData DB picWidth*picHeight dup(0)

;start       dw  ?

.Code

OpenFileW PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only

    ;LEA DX, chickenFilename

    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code

    MOV [PiecesWhiteFilehandle], AX

    RET

OpenFileW ENDP

moveFilePointerW PROC

    mov AH, 42h
	mov AL, 00
		
    mov BX, [PiecesWhiteFilehandle]
	
    ; mov CX, dx                    ;high order word of number of bytes to move
	;DX = low order word of number of bytes to move

    
    int 21h
    ret

moveFilePointerW ENDP

ReadDataW PROC

    MOV AH,3Fh
    MOV BX, [PiecesWhiteFilehandle]
    ;MOV CX,chickenWidth*chickenpicHeight ; number of bytes to read
    ;LEA DX, chickenData
    INT 21h
    RET
ReadDataW ENDP 


CloseFileW PROC
    
	MOV AH, 3Eh
	MOV BX, [PiecesWhiteFilehandle]

	INT 21h
	RET
    
CloseFileW ENDP


; LoadBlackPieces PROC FAR
    
;     MOV AH, 0
;     MOV AL, 13h
;     INT 10h

LoadPiece  PROC FAR

    ;LEA DX, elephWhite_Filename
    CALL OpenFileW

    mov cx, 16
    LEA DX, pieceData
    CALL ReadDataW

    MOV CX, word ptr pieceData[8]
    MOV DX, word ptr pieceData[10]
    CALL moveFilePointerW
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, pieceData
    CALL ReadDataW
    call CloseFileW

    ret

LoadPiece ENDP


; LoadHourseWhite  PROC FAR

;     LEA DX, HourseWhite_Filename
;     CALL OpenFileW

;     mov cx, 16
;     LEA DX, pieceData
;     CALL ReadDataW

;     MOV CX, word ptr pieceData[8]
;     MOV DX, word ptr pieceData[10]
;     CALL moveFilePointerW
    
;     MOV CX, picWidth*picHeight ; number of bytes to read

;     LEA DX, pieceData
;     CALL ReadDataW
;     call CloseFileW

;     ret

; LoadHourseWhite ENDP    


; LoadKingWhite  PROC FAR

;     LEA DX, KingWhite_Filename
;     CALL OpenFileW

;     mov cx, 16
;     LEA DX, pieceData
;     CALL ReadDataW

;     MOV CX, word ptr pieceData[8]
;     MOV DX, word ptr pieceData[10]
;     CALL moveFilePointerW
    
;     MOV CX, picWidth*picHeight ; number of bytes to read

;     LEA DX, pieceData
;     CALL ReadDataW
;     call CloseFileW

;     ret

; LoadKingWhite ENDP


; LoadQueenWhite  PROC FAR

;     LEA DX, queenWhite_Filename
;     CALL OpenFileW

;     mov cx, 16
;     LEA DX, pieceData
;     CALL ReadDataW

;     MOV CX, word ptr pieceData[8]
;     MOV DX, word ptr pieceData[10]
;     CALL moveFilePointerW
    
;     MOV CX, picWidth*picHeight ; number of bytes to read

;     LEA DX, pieceData
;     CALL ReadDataW
;     call CloseFileW

;     ret

; LoadqueenWhite ENDP    


; LoadsolderWhite  PROC FAR

;     LEA DX, soldierWhite_Filename
;     CALL OpenFileW

;     mov cx, 16
;     LEA DX, pieceData
;     CALL ReadDataW
 
;     MOV CX, word ptr pieceData[8]
;     MOV DX, word ptr pieceData[10]
;     CALL moveFilePointerW
    
;     MOV CX, picWidth*picHeight ; number of bytes to read

;     LEA DX, pieceData
;     CALL ReadDataW
;     call CloseFileW

;     ret

; LoadsolderWhite ENDP 


; LoadtabyaWhite  PROC FAR

;     LEA DX, tabyaWhite_Filename
;     CALL OpenFileW

;     mov cx, 16
;     LEA DX, pieceData
;     CALL ReadDataW
 
;     MOV CX, word ptr pieceData[8]
;     MOV DX, word ptr pieceData[10]
;     CALL moveFilePointerW
    
;     MOV CX, picWidth*picHeight ; number of bytes to read

;     LEA DX, pieceData
;     CALL ReadDataW
;     call CloseFileW

;     ret

; LoadtabyaWhite ENDP




    ; ; Graphics mode    
    ; mov ax, 4f02h
    ; mov bx, 0107h
    ; int 10h

;     ret
    
; LoadBlackPieces ENDP


DrawPiece PROC FAR


    ; MOV CX,0
    ; MOV DX,0
    push cx         ;save old value

    mov si, cx
    add si, picWidth

    mov di, dx
    add di, picWidth

    MOV AH,0ch
	
    ; Drawing loop
    drawLoop:
        MOV AL,[BX]
        cmp al, 0ch
        je dontDraw
        INT 10h 
    dontDraw:
        INC CX
        dec BX
        CMP CX, si

    JNE drawLoop 
        
        ;MOV CX , 0
        pop cx
        push cx
        INC DX
        CMP DX , di
        
    JNE drawLoop

    pop cx

    ret

DrawPiece ENDP



DrawElephantW PROC FAR

    pusha
    ; load piece
    LEA DX, elephWhite_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawElephantW ENDP



DrawHourseW PROC FAR

    pusha
    ; load piece
    LEA DX, HourseWhite_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel	
    call DrawPiece

    ret

DrawHourseW ENDP



DrawKingW PROC FAR

    pusha
    ; load piece
    LEA DX, KingWhite_Filename
    call LoadPiece
    popa
    
    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawKingW ENDP



DrawQueenW PROC FAR

    pusha
    ; load piece
    LEA DX, queenWhite_Filename
    call LoadPiece
    popa
    
    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawQueenW ENDP



DrawSoldierW PROC FAR

    pusha
    ; load piece
    LEA DX, soldierWhite_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawSoldierW ENDP



DrawTabyaW PROC FAR

    pusha
    ; load piece
    LEA DX, tabyaWhite_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawTabyaW ENDP


; -------- Black --------
DrawElephantB PROC FAR

    pusha
    ; load piece
    LEA DX, elephBlack_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawElephantB ENDP



DrawHourseB PROC FAR

    pusha
    ; load piece
    LEA DX, HourseBlack_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawHourseB ENDP



DrawKingB PROC FAR

    pusha
    ; load piece
    LEA DX, KingBlack_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawKingB ENDP



DrawQueenB PROC FAR

    pusha
    ; load piece
    LEA DX, queenBlack_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawQueenB ENDP



DrawSolderB PROC FAR

    pusha
    ; load piece
    LEA DX, soldierBlack_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawSolderB ENDP



DrawTabyaB PROC FAR

    pusha
    ; load piece
    LEA DX, tabyaBlack_Filename
    call LoadPiece
    popa

    LEA BX , pieceData[picWidth*picHeight] ; BL contains index at the current drawn pixel
    call DrawPiece

    ret

DrawTabyaB ENDP
END
; MAIN	PROC    FAR
    
;     mov ax, @data
;     mov ds, ax


; MAIN	ENDP
; END	MAIN

; ;msh 3aref dol lehom lazma wala la?
        
;         call CloseFileW
        
;         ;Change to Text MODE
;         MOV AH,0          
;         MOV AL,03h
;         INT 10h 

;         ;return control to operating system
;         MOV AH , 4ch
;         INT 21H





