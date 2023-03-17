.Model HUGE
.Stack 64
.Data

picWidth       EQU 100        
picHeight      EQU 100

elephBlack_Filename DB '/p/eB.bmp', 0
HourseBlack_Filename DB '/p/hB.bmp', 0
KingBlack_Filename DB '/p/kB.bmp', 0
queenBlack_Filename DB '/p/qB.bmp', 0
solderBlack_Filename DB '/p/sB.bmp', 0
tabyaBlack_Filename DB '/p/tB.bmp', 0

PiecesFilehandle DW ?

elephB_Data DB picWidth*picHeight dup(0)
HourseB_Data DB picWidth*picHeight dup(0)
KingB_Data DB picWidth*picHeight dup(0)
queenB_Data DB picWidth*picHeight dup(0)
solderB_Data DB picWidth*picHeight dup(0)
tabyaB_Data DB picWidth*picHeight dup(0)

;start       dw  ?

.Code

OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only

    ;LEA DX, chickenFilename

    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code

    MOV [PiecesFilehandle], AX

    RET

OpenFile ENDP

moveFilePointer PROC

    ; mov bp, ax
    mov AH, 42h
	mov AL, 00
		
    mov BX, [PiecesFilehandle]
	
    ; mov CX, dx                    ;high order word of number of bytes to move
	; ;DX = low order word of number of bytes to move
    ; sub bp, chickenWidth*chickenpicHeight
    ; mov dx, bp
    
    int 21h
    ret

moveFilePointer ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [PiecesFilehandle]
    ;MOV CX,chickenWidth*chickenpicHeight ; number of bytes to read
    ;LEA DX, chickenData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [PiecesFilehandle]

	INT 21h
	RET
CloseFile ENDP


LoadAllPieces PROC FAR
    
    MOV AH, 0
    MOV AL, 13h
    INT 10h


    LEA DX, elephBlack_Filename
    CALL OpenFile

    mov cx, 16
    LEA DX, elephB_Data
    CALL ReadData

    MOV CX, word ptr elephB_Data[8]
    MOV DX, word ptr elephB_Data[10]
    CALL moveFilePointer
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, elephB_Data
    CALL ReadData
    call CloseFile



    LEA DX, HourseBlack_Filename
    CALL OpenFile

    mov cx, 16
    LEA DX, HourseB_Data
    CALL ReadData

    MOV CX, word ptr HourseB_Data[8]
    MOV DX, word ptr HourseB_Data[10]
    CALL moveFilePointer
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, HourseB_Data
    CALL ReadData
    call CloseFile


    
    LEA DX, KingBlack_Filename
    CALL OpenFile

    mov cx, 16
    LEA DX, KingB_Data
    CALL ReadData

    MOV CX, word ptr KingB_Data[8]
    MOV DX, word ptr KingB_Data[10]
    CALL moveFilePointer
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, KingB_Data
    CALL ReadData
    call CloseFile



    LEA DX, queenBlack_Filename
    CALL OpenFile

    mov cx, 16
    LEA DX, queenB_Data
    CALL ReadData

    MOV CX, word ptr queenB_Data[8]
    MOV DX, word ptr queenB_Data[10]
    CALL moveFilePointer
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, queenB_Data
    CALL ReadData
    call CloseFile



    LEA DX, solderBlack_Filename
    CALL OpenFile

    mov cx, 16
    LEA DX, solderB_Data
    CALL ReadData

    MOV CX, word ptr solderB_Data[8]
    MOV DX, word ptr solderB_Data[10]
    CALL moveFilePointer
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, solderB_Data
    CALL ReadData
    call CloseFile



    LEA DX, tabyaBlack_Filename
    CALL OpenFile

    mov cx, 16
    LEA DX, tabyaB_Data
    CALL ReadData
 
    MOV CX, word ptr tabyaB_Data[8]
    MOV DX, word ptr tabyaB_Data[10]
    CALL moveFilePointer
    
    MOV CX, picWidth*picHeight ; number of bytes to read

    LEA DX, tabyaB_Data
    CALL ReadData
    call CloseFile


    ret

    
LoadAllPieces ENDP


DrawPiece PROC FAR

    MOV CX,0
    MOV DX,0
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
        CMP CX, picWidth

    JNE drawLoop 
        
        MOV CX , 0
        INC DX
        CMP DX , picHeight
        
    JNE drawLoop

    ret

DrawPiece ENDP

DrawElephantB PROC FAR


    LEA BX , elephB_Data[picWidth*picHeight] ; BL contains index at the current drawn pixel
	
    call DrawPiece

    ret

DrawElephantB ENDP



DrawHourseB PROC FAR


    LEA BX , HourseB_Data[picWidth*picHeight] ; BL contains index at the current drawn pixel
	
    call DrawPiece

    ret

DrawHourseB ENDP



DrawKingB PROC FAR


    LEA BX , KingB_Data[picWidth*picHeight] ; BL contains index at the current drawn pixel
	
    call DrawPiece

    ret

DrawKingB ENDP



DrawQueenB PROC FAR


    LEA BX , queenB_Data[picWidth*picHeight] ; BL contains index at the current drawn pixel
	
    call DrawPiece

    ret

DrawQueenB ENDP



DrawSolderB PROC FAR


    LEA BX , solderB_Data[picWidth*picHeight] ; BL contains index at the current drawn pixel
	
    call DrawPiece

    ret

DrawSolderB ENDP



DrawTabyaB PROC FAR


    LEA BX , tabyaB_Data[picWidth*picHeight] ; BL contains index at the current drawn pixel
	
    call DrawPiece

    ret

DrawTabyaB ENDP



MAIN	PROC    FAR
    
    mov ax, @data
    mov ds, ax


MAIN	ENDP
END	MAIN

; ;msh 3aref dol lehom lazma wala la?
        
;         call CloseFile
        
;         ;Change to Text MODE
;         MOV AH,0          
;         MOV AL,03h
;         INT 10h 

;         ;return control to operating system
;         MOV AH , 4ch
;         INT 21H





