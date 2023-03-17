    .286

extrn GetUsername:FAR
extrn mainMenu:FAR

    .MODEL HUGE
    .STACK 64
	.DATA

    
	.CODE



MAIN	PROC    FAR
    
    mov ax, @data
    mov ds, ax


    ;------------- Username -------------
    call GetUsername
    

    ;------------- Main Screen -------------
    call mainMenu


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