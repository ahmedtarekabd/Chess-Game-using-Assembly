    .286
    
    .MODEL HUGE
    .STACK 64
	.DATA

    
	.CODE



MAIN	PROC    FAR
    
    mov ax, @data
    mov ds, ax


    mov si, 30

    lOOP1: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOP1

    ;------------- Exit -------------
    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    ; return control to operating system
    MOV AH , 4ch
    INT 21H

MAIN	ENDP
END	MAIN