.Model Small
.Stack 64
.Data

chickenWidth EQU 100        
chickenHeight EQU 100

elephBFilename DB '/p/eB.bmp', 0
elephWFilename DB '/p/eW.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0
elephatntFilename DB '/p/eB.bmp', 0


chickenFilehandle DW ?

chickenData DB chickenWidth*chickenHeight dup(0)

start       dw  ?

.Code

OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, chickenFilename
    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code

    MOV [chickenFilehandle], AX

    RET

OpenFile ENDP

moveFilePointer PROC

    ; mov bp, ax
    mov AH, 42h
	mov AL, 00
		
    mov BX, [chickenFilehandle]
	
    ; mov CX, dx                    ;high order word of number of bytes to move
	; ;DX = low order word of number of bytes to move
    ; sub bp, chickenWidth*chickenHeight
    ; mov dx, bp
    
    int 21h
    ret

moveFilePointer ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [chickenFilehandle]
    ;MOV CX,chickenWidth*chickenHeight ; number of bytes to read
    LEA DX, chickenData
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [chickenFilehandle]

	INT 21h
	RET
CloseFile ENDP


MAIN PROC FAR
    MOV AX , @DATA
    MOV DS , AX
    
    MOV AH, 0
    MOV AL, 13h
    INT 10h
	
    CALL OpenFile

    mov cx, 16
    CALL ReadData

    MOV CX, word ptr chickenData[8]
    ; MOV CX, 0
    MOV DX, word ptr chickenData[10]
    ; MOV DX, 0416h
    CALL moveFilePointer
    
    MOV CX, chickenWidth*chickenHeight ; number of bytes to read
    CALL ReadData
	
    LEA BX , chickenData[chickenWidth*chickenHeight] ; BL contains index at the current drawn pixel
	
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
    CMP CX,chickenWidth
JNE drawLoop 
	
    MOV CX , 0
    INC DX
    CMP DX , chickenHeight
JNE drawLoop

	
    ; Press any key to exit
    MOV AH , 0
    INT 16h
    
    call CloseFile
    
    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    ; return control to operating system
    MOV AH , 4ch
    INT 21H
    
MAIN ENDP






END MAIN