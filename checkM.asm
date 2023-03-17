    .286

extrn grid:Byte
extrn Cell_To_Be_Moved:Byte

extrn convertIndextoRowCol:FAR
extrn ROW_COL_TO_Number:FAR

public BigCheck_CallPosKing
public Checkmate

    .MODEL HUGE
    .STACK 64
	.DATA

; Check and checkmate
CurrentPosBlackKing db ?
CurrentPosWhiteKing db ? 

CheckBlack_King     db ?
CheckWhite_King     db ?

checkmessageblackk  db 'Watch out! The Black king is attacked!','$'
checkmessageWhiteK  db 'Watch out! The White king is attacked!','$'
clearCheckMsg       db '                                      ','$'

checkmate_messageblack db 'Checkmate The Black king is Trapped!','$'
checkmate_messageWhite db 'Checkmate The White king is Trapped!','$'

; Piece numbers
White_Soldier equ 1
White_Rook equ 2
White_Horse equ 3
White_Elephant equ 4
White_Queen equ 5
White_King equ 6

Black_Pawm equ 11
Black_Rook equ 22
Black_Knight equ 33
Black_Bishop equ 44
Black_Queen equ 55
Black_King equ 66

.CODE

GetCurrentposKing   proc    far

    pusha

    ;Get Current position of King
    MOV BX,0 ;Counter
    mov cx,0 ;34an atk2d eni la2it el white wi black king
    BIGLOOP_posKing:
    

        cmp Grid[bx],White_King
        je  KingWhiteFound

        cmp Grid[bx],Black_King
        je KingBlackFound
        
        
        jmp out99


    KingWhiteFound:
    mov CurrentPosWhiteKing,bl ; dh el index
    inc cx
    jmp estna

    KingBlackFound:
    mov CurrentPosBlackKing,bl ; dh el index
    inc cx
    jmp estna

    estna:
    cmp cx,2
    je finishw
    
    out99:

        INC BX
        CMP BX,64 

    JNE BIGLOOP_posKing

    finishw: 


    popa


    ret
GetCurrentposKing endp


CheckWhiteKnight proc far

 ;bet check fe black knight wala la we bytb3etlaha el index beta3 el king

 ;Bydkholaha el index beta3 el king fe el bx betraga3 el col we wl row

   mov CheckBlack_King,0
   ;call GetCurrentposKing
   mov bl,CurrentPosBlackKing 
   mov bh,0
 
    BIGLOOPRight11:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Right11: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Right11

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Right11


        OUT13Right11:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  



    mov dh,0
    mov ch,0
    

    pusha
    add cl,1
    add dl,2
    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid111
    cmp cl,7
    JA Out_Grid111
    cmp dl,0
    JB Out_Grid111
    cmp cl,0
    JB Out_Grid111


    pusha
    call ROW_COL_TO_Number
    popa
    
    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck

    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88


    skip_horse_king_chck:

    Out_Grid111:
    popa

    pusha
    add cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid22
    cmp cl,7
    JA Out_Grid22
    cmp dl,0
    JB Out_Grid22
    cmp cl,0
    JB Out_Grid22


    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck1

    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88

    skip_horse_king_chck1:

    Out_Grid22:
    popa

   
    pusha
    sub cl,1
    add dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid33
    cmp cl,7
    JA Out_Grid33
    cmp dl,0
    JB Out_Grid33
    cmp cl,0
    JB Out_Grid33

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck2

    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88

    skip_horse_king_chck2:

    Out_Grid33:
    popa

   
    pusha
    sub cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid44
    cmp cl,7
    JA Out_Grid44
    cmp dl,0
    JB Out_Grid44
    cmp cl,0
    JB Out_Grid44

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck3
    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88
    skip_horse_king_chck3:

    Out_Grid44:
    popa

    
    pusha
    sub cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid55
    cmp cl,7
    JA Out_Grid55
    cmp dl,0
    JB Out_Grid55
    cmp cl,0
    JB Out_Grid55

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck4
    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88
    skip_horse_king_chck4:
    Out_Grid55:
    popa

    
    pusha
    sub cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid66
    cmp cl,7
    JA Out_Grid66
    cmp dl,0
    JB Out_Grid66
    cmp cl,0
    JB Out_Grid66

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck5
    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88
    skip_horse_king_chck5:
   
    Out_Grid66:
    popa

    
    pusha
    add cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid77
    cmp cl,7
    JA Out_Grid77
    cmp dl,0
    JB Out_Grid77
    cmp cl,0
    JB Out_Grid77

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck6
    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88
    skip_horse_king_chck6:

    Out_Grid77:
    popa
 

    pusha
    add cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid88
    cmp cl,7
    JA Out_Grid88
    cmp dl,0
    JB Out_Grid88
    cmp cl,0
    JB Out_Grid88

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, White_Horse ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck7
    ;hathot fe el var bta3k 1
    mov CheckBlack_King,1
    jmp Out_Grid88
    skip_horse_king_chck7:

    Out_Grid88:


    popa

    ret


CheckWhiteKnight endp

CheckBlackKnight proc far

 ;bet check fe black knight wala la we bytb3etlaha el index beta3 el king

 

 ;Bydkholaha el index beta3 el king fe el bx betraga3 el col we wl row

   mov CheckWhite_King,0
   ;call GetCurrentposKing
   mov bl,CurrentPosWhiteKing 
   mov bh,0
 
    BIGLOOPRight22:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Right1122: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Right1122

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Right1122


        OUT13Right1122:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  



    mov dh,0
    mov ch,0
    

    pusha
    add cl,1
    add dl,2
    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid1112
    cmp cl,7
    JA Out_Grid1112
    cmp dl,0
    JB Out_Grid1112
    cmp cl,0
    JB Out_Grid1112


    pusha
    call ROW_COL_TO_Number
    popa
    
    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck00

    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888


    skip_horse_king_chck00:

    Out_Grid1112:
    popa

    pusha
    add cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid222
    cmp cl,7
    JA Out_Grid222
    cmp dl,0
    JB Out_Grid222
    cmp cl,0
    JB Out_Grid222


    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck11

    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888

    skip_horse_king_chck11:

    Out_Grid222:
    popa

   
    pusha
    sub cl,1
    add dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid333
    cmp cl,7
    JA Out_Grid333
    cmp dl,0
    JB Out_Grid333
    cmp cl,0
    JB Out_Grid333

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck22

    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888

    skip_horse_king_chck22:

    Out_Grid333:
    popa

   
    pusha
    sub cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid444
    cmp cl,7
    JA Out_Grid444
    cmp dl,0
    JB Out_Grid444
    cmp cl,0
    JB Out_Grid444

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck33
    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888
    skip_horse_king_chck33:

    Out_Grid444:
    popa

    
    pusha
    sub cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid555
    cmp cl,7
    JA Out_Grid555
    cmp dl,0
    JB Out_Grid555
    cmp cl,0
    JB Out_Grid555

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck44
    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888
    skip_horse_king_chck44:
    Out_Grid555:
    popa

    
    pusha
    sub cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid666
    cmp cl,7
    JA Out_Grid666
    cmp dl,0
    JB Out_Grid666
    cmp cl,0
    JB Out_Grid666

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck55
    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888
    skip_horse_king_chck55:
   
    Out_Grid666:
    popa

    
    pusha
    add cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid777
    cmp cl,7
    JA Out_Grid777
    cmp dl,0
    JB Out_Grid777
    cmp cl,0
    JB Out_Grid777

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck66
    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888
    skip_horse_king_chck66:

    Out_Grid777:
    popa
 

    pusha
    add cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid888
    cmp cl,7
    JA Out_Grid888
    cmp dl,0
    JB Out_Grid888
    cmp cl,0
    JB Out_Grid888

    pusha
    call ROW_COL_TO_Number
    popa

    mov bl,Cell_To_Be_Moved
    mov bh,0
    mov al, Grid[bx]
    cmp al, Black_Knight ;index el hosan ely 3aks lon el king
    jne skip_horse_king_chck77
    ;hathot fe el var bta3k 1
    mov CheckWhite_King,1
    jmp Out_Grid888
    skip_horse_king_chck77:

    Out_Grid888:


    popa

    ret


CheckBlackKnight endp


CheckHorizontal_BlackKing   proc    far

    ;cx=1->Check found 
    ;cx=0->Check not found

    mov CheckBlack_King,0

    ;Get Current position of Black King
    ;call GetCurrentposKing

    mov cx,0
    mov bl,CurrentPosBlackKing ;jojo hayl3ab hena
    mov bh,0

        ;3ayez a3raf ha compare yemeno kam mara
        ;hageb col ely hoa feh

     
     BIGLOOPRight1:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Right1: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Right1

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Right1


        OUT13Right1:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  

       
    
        JMP Startmovright1 ;3shan matkhoshesh fe el fn bta3et el drawing tany




     Startmovright1:
     ;Delwa2ty el cx feha ana fe anhy col
     mov di,cx ;3lshan a7afez 3ala no of col
     mov si,0  ;for checking
     mov al,7
     mov ah,0
     sub ax,cx ;al-> feha hamshy kam mara yemen le7ad akher el grid

     cmp ax,si
     jz movleft1

     

     mov bl,CurrentPosBlackKing
     mov bh,0
     mov dx,bx

     add dx,ax ; dx-> el index ely ha2af 3ando

   

     add bx,1

    

     movright1:

     cmp Grid[bx],White_Rook
     je foundRight1

     cmp Grid[bx],White_Queen
     je foundRight1

     cmp Grid[bx],0
     jnz movleft1

       
     jmp outRightB1
     
     foundRight1:
     mov cx, 1  ;Flag to display el message of check


     jmp outHorizontzl1
     

     outRightB1:
     
     add bx,1
     cmp dx,bx

     jb movleft1
     jae movright1


     movleft1:

     mov si,7
     cmp ax,si
     jz outHorizontzl1 ;3lshan border condition 

     ;hena el ax feha hamshy kam mara shemal 3ltool

     mov cx,0

     mov bh, 0
     mov bl,CurrentPosBlackKing

     mov dx,bx ;feha index el king

     ; ax-> yerga3 feha ana fe anhy col we da el 3adad ely hamshy feh men el shemal
     ;3ayez a7aded el index ely ha2af 3ando shemal

     sub dx,di ;dx-> el index ely ha2af 3ando shemal 

     sub bx,1
     movleftNoInit1:

    

     cmp Grid[bx],White_Rook
     je foundLeft1

     cmp Grid[bx],White_Queen
     je foundLeft1

     cmp Grid[bx],0
     jnz outHorizontzl1

     jmp outLeftB1
     
     foundLeft1:
     mov cx,1
    
     jmp outHorizontzl1


     outLeftB1: 
     
     sub bx,1
     cmp dx,bx

     jle movleftNoInit1
     jg outHorizontzl1
     

     outHorizontzl1:

     mov CheckBlack_King,cl

    ;      pusha
    ;  ; testing
    ;  mov cl,CheckBlack_King
    ;  mov dl, cl
    ;  add dl, 30h
    ;  mov ah, 2
    ;  int 21h
    ;  popa

    ret 
CheckHorizontal_BlackKing endp

CheckHorizontal_WhiteKing   proc    far

    ;cx=1->Check found 
    ;cx=0->Check not found
    mov CheckWhite_King,0

    ;Get Current position of Black King
    ;call GetCurrentposKing

    mov cx,0
    mov bl,CurrentPosWhiteKing
    mov bh,0

        ;3ayez a3raf ha compare yemeno kam mara
        ;hageb col ely hoa feh

     
     BIGLOOPRight2:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Right2: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Right2

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Right2


        OUT13Right2:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  

       
    
        JMP Startmovright2 ;3shan matkhoshesh fe el fn bta3et el drawing tany




     Startmovright2:
     ;Delwa2ty el cx feha ana fe anhy col
     mov di,cx ;3lshan a7afez 3ala no of col
     mov si,0  ;for checking
     mov al,7
     mov ah,0
     sub ax,cx ;al-> feha hamshy kam mara yemen le7ad akher el grid

     cmp ax,si
     jz movleft2

     

     mov bl,CurrentPosWhiteKing
     mov bh,0
     mov dx,bx

     add dx,ax ; dx-> el index ely ha2af 3ando

   

     add bx,1

    

     movright2:

     cmp Grid[bx],Black_Rook
     je foundRight2

     cmp Grid[bx],Black_Queen
     je foundRight2

     cmp Grid[bx],0
     jnz movleft2

       
     jmp outRightB2
     
     foundRight2:
     mov cx, 1  ;Flag to display el message of check


     jmp outHorizEnd2
     

     outRightB2:
     
     add bx,1
     cmp dx,bx

     jb movleft2
     jae movright2


     movleft2:

     mov si,7
     cmp ax,si
     jz outHorizEnd2 ;3lshan border condition 

     ;hena el ax feha hamshy kam mara shemal 3ltool

     mov cx,0

     mov bh, 0
     mov bl,CurrentPosWhiteKing

     mov dx,bx ;feha index el king

     ; ax-> yerga3 feha ana fe anhy col we da el 3adad ely hamshy feh men el shemal
     ;3ayez a7aded el index ely ha2af 3ando shemal

     sub dx,di ;dx-> el index ely ha2af 3ando shemal 

     sub bx,1
     movleftNoInit2:

    

     cmp Grid[bx],Black_Rook
     je foundLeft2

     cmp Grid[bx],Black_Queen
     je foundLeft2

     cmp Grid[bx],0
     jnz outHorizEnd2


     jmp outLeftB2
     
     foundLeft2:
     mov cx,1
    
     jmp outHorizEnd2


     outLeftB2: 
     
     sub bx,1
     cmp dx,bx

     jle movleftNoInit2
     jg outHorizEnd2
     

     outHorizEnd2:

     mov CheckWhite_King,cl

    ;    pusha
    ;  ; testing
    ;  mov dl, cl
    ;  add dl, 30h
    ;  mov ah, 2
    ;  int 21h
    ;  popa


    ret
CheckHorizontal_WhiteKing endp


CheckVertical_BlackKing   proc    far

    ;cx=1->Check found 
    ;cx=0->Check not found

    mov CheckBlack_King,0
    ;Get Current position of Black King
    ;call GetCurrentposKing

    mov cx,0
    mov bl,CurrentPosBlackKing
    jmp out12
    ; sub bl,8
    
    movup:

     cmp Grid[bx],White_Rook
     je found

     cmp Grid[bx],White_Queen
     je found 

     cmp Grid[bx],0
     jnz movdown


     jmp out12
     
     found:
     mov cx, 1  ;Flag to display el message of check

    jmp outdown
     

    out12:
     sub bl,8
     
     cmp bl,0
     jl movdown
     jge movup


    movdown:

    mov cx,0
    mov bh, 0
    mov bl,CurrentPosBlackKing
    jmp out2

    movdownNoInit:

     cmp Grid[bx],White_Rook
     je found2

     cmp Grid[bx],White_Queen
     je found2

     cmp Grid[bx],0
     jnz outdown

     jmp out2
     
    found2:
    mov cx,1
    
    jmp outdown


    out2: 
     
     add bl,8
     cmp bl,63
     ja outdown
     jbe movdownNoInit
     

    outdown:

    mov CheckBlack_King,cl


    ret
CheckVertical_BlackKing endp

CheckVertical_WhiteKing   proc    far

    ;cx=1->Check found
    ;cx=0->Check not found
    
    mov CheckWhite_King,0
    
    ;Get Current position of White King
    ;call GetCurrentposKing

    mov cx,0
    mov bl,CurrentPosWhiteKing
    jmp out12White
    ; sub bl,8
    
    movupWhite:

     cmp Grid[bx],Black_Rook
     je foundWhite

     cmp Grid[bx],Black_Queen
     je foundWhite

     cmp Grid[bx],0
     jnz movdownWhite

    

     jmp out12White
     
     foundWhite:
     mov cx, 1  ;Flag to display el message of check

    jmp outdownWhite
     

    out12White:
     sub bl,8
     
     cmp bl,0
     jl movdownWhite
     jge movupWhite


    movdownWhite:

    mov cx,0
    mov bh, 0
    mov bl,CurrentPosWhiteKing
    jmp out2White

    movdownNoInit1:

     cmp Grid[bx],Black_Rook
     je found2White

     cmp Grid[bx],Black_Queen
     je found2White


     cmp Grid[bx],0
     jnz outdownWhite

     jmp out2White
     
    found2White:
    mov cx,1
    
    jmp outdownWhite


    out2White: 
     
     add bl,8
     cmp bl,63
     ja outdownWhite
     jbe movdownNoInit1
     

    outdownWhite:

    mov CheckWhite_King,cl


    ; pusha
    ; ; testing
    ; mov dl, cl
    ; add dl, 30h
    ; mov ah, 2
    ; int 21h
    ; popa

    ret
CheckVertical_WhiteKing endp


checkKingorsoldier_Black    proc    far

    ;dl->row ;cl-> col 

    ;nafs htet el horse ely fel awel   todoooooo

   mov CheckBlack_King,0
   ;call GetCurrentposKing
   mov bl,CurrentPosBlackKing 
   mov bh,0
 
    BIGLOOPRight1133:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Right1133: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Right1133

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Right1133


        OUT13Right1133:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  



    mov ch,0
    mov dh,0

    pusha    ;3shan arsm el 3 ely fo2
    sub dl,1
    sub cl,1


    cmp dl,7    ;fo2 shmal  3askry
    JA OutGrid1
    cmp cl,7
    JA OutGrid1
    cmp dl,0
    JB OutGrid1
    cmp cl,0
    JB OutGrid1
    
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck
        mov CheckBlack_King,1
 skip_white_king_chck:
    cmp al ,White_Soldier
    jne skip_white_soldier_chck
        mov CheckBlack_King,1
skip_white_soldier_chck:  
    ;;; 

    
    OutGrid1:

    add cl,1


    cmp dl,7
    JA OutGrid2
    cmp cl,7
    JA OutGrid2
    cmp dl,0
    JB OutGrid2
    cmp cl,0
    JB OutGrid2
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck1
        mov CheckBlack_King,1
skip_white_king_chck1:
     
    ;;; 
    OutGrid2:

    add cl,1

    cmp dl,7    ;fo2 ymen   3askry
    JA OutGrid3
    cmp cl,7
    JA OutGrid3
    cmp dl,0
    JB OutGrid3
    cmp cl,0
    JB OutGrid3

    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck2
        mov CheckBlack_King,1
skip_white_king_chck2:
    cmp al ,White_Soldier
    jne skip_white_soldier_chck1
        mov CheckBlack_King,1
skip_white_soldier_chck1:  
    ;;; 

    OutGrid3:


    popa
    
    ; ;;;;;;;;;;;;;;;;;;;
    pusha    ;3shan arsm el 3 ely taht
    dec cl
    inc dl


    cmp dl,7     ;taht shmal
    JA OutGrid4
    cmp cl,7
    JA OutGrid4
    cmp dl,0
    JB OutGrid4
    cmp cl,0
    JB OutGrid4

    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck3
        mov CheckBlack_King,1
skip_white_king_chck3:
     
    ;;; 

    OutGrid4:

    inc cl

    cmp dl,7
    JA OutGrid5
    cmp cl,7
    JA OutGrid5
    cmp dl,0
    JB OutGrid5
    cmp cl,0
    JB OutGrid5
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck4
        mov CheckBlack_King,1
skip_white_king_chck4:
     
    ;;; 
    OutGrid5:

    inc cl


    cmp dl,7        ;taht ymen
    JA OutGrid6
    cmp cl,7
    JA OutGrid6
    cmp dl,0
    JB OutGrid6
    cmp cl,0
    JB OutGrid6
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck5
        mov CheckBlack_King,1
skip_white_king_chck5:
     
    ;;; 
    OutGrid6:


 
    popa


    dec cl      ;3shan arsm shmalo


    cmp dl,7
    JA OutGrid7
    cmp cl,7
    JA OutGrid7
    cmp dl,0
    JB OutGrid7
    cmp cl,0
    JB OutGrid7
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck6
        mov CheckBlack_King,1
 skip_white_king_chck6:
     
    ;;; 
    OutGrid7:


    add cl,2 ;3shan arsm ymeno badd 2 3shan already mna2so mara we ana barsm shmal

    

    cmp dl,7
    JA OutGrid8
    cmp cl,7
    JA OutGrid8
    cmp dl,0
    JB OutGrid8
    cmp cl,0
    JB OutGrid8
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,White_King
    jne skip_white_king_chck7
        mov CheckBlack_King,1
 skip_white_king_chck7:
     
    ;;; 
    OutGrid8:

    ;    pusha
    ;  ; testing
    ;  mov cl,CheckBlack_King
    ;  mov dl, cl
    ;  add dl, 30h
    ;  mov ah, 2
    ;  int 21h
    ; ;  popa
    

    ret


checkKingorsoldier_Black    endp

checkKingorsoldier_White    proc    far

    ;dl->row ;cl-> col 

    ;nafs htet el horse ely fel awel   todoooooo

   mov Checkwhite_King,0
   ;call GetCurrentposKing
   mov bl,CurrentPosWhiteKing 
   mov bh,0
 
    BIGLOOPRight11331:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Right11331: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Right11331

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Right11331


        OUT13Right11331:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  


    mov ch,0
    mov dh,0

    pusha    ;3shan arsm el 3 ely fo2
    sub dl,1
    sub cl,1


    cmp dl,7    ;fo2 shmal  3askry
    JA OutGrid11
    cmp cl,7
    JA OutGrid11
    cmp dl,0
    JB OutGrid11
    cmp cl,0
    JB OutGrid11
    
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck
        mov Checkwhite_King,1
skip_black_king_chck:
     
    ;;; 

    
    OutGrid11:

    add cl,1



    cmp dl,7
    JA OutGrid21
    cmp cl,7
    JA OutGrid21
    cmp dl,0
    JB OutGrid21
    cmp cl,0
    JB OutGrid21
    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck1
        mov Checkwhite_King,1
skip_black_king_chck1:
     
    ;;; 
    OutGrid21:

    add cl,1



    cmp dl,7    ;fo2 ymen   3askry
    JA OutGrid31
    cmp cl,7
    JA OutGrid31
    cmp dl,0
    JB OutGrid31
    cmp cl,0
    JB OutGrid31

    ;block
    pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck2
        mov Checkwhite_King,1
skip_black_king_chck2:
    
    ;;; 

    OutGrid31:

    



    popa
    
    ; ;;;;;;;;;;;;;;;;;;;
    pusha    ;3shan arsm el 3 ely taht
    dec cl
    inc dl


    cmp dl,7     ;taht shmal
    JA OutGrid41
    cmp cl,7
    JA OutGrid41
    cmp dl,0
    JB OutGrid41
    cmp cl,0
    JB OutGrid41

    ;block
      pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck3
        mov Checkwhite_King,1
skip_black_king_chck3:
    cmp al ,Black_Pawm
    jne skip_black_soldier_chck
        mov Checkwhite_King,1
skip_black_soldier_chck:  
     
    ;;; 

    OutGrid41:

    inc cl

    cmp dl,7
    JA OutGrid51
    cmp cl,7
    JA OutGrid51
    cmp dl,0
    JB OutGrid51
    cmp cl,0
    JB OutGrid51
    ;block
      pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck4
        mov Checkwhite_King,1
skip_black_king_chck4: 
     
    ;;; 
    OutGrid51:

    inc cl


    cmp dl,7        ;taht ymen
    JA OutGrid61
    cmp cl,7
    JA OutGrid61
    cmp dl,0
    JB OutGrid61
    cmp cl,0
    JB OutGrid61
    ;block
       pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck5
        mov Checkwhite_King,1
skip_black_king_chck5:
    cmp al ,Black_Pawm
    jne skip_black_soldier_chck1
        mov Checkwhite_King,1
skip_black_soldier_chck1:  
     
    ;;; 
    OutGrid61:


 
    popa


    dec cl      ;3shan arsm shmalo


    cmp dl,7
    JA OutGrid71
    cmp cl,7
    JA OutGrid71
    cmp dl,0
    JB OutGrid71
    cmp cl,0
    JB OutGrid71
    ;block
      pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck6
        mov Checkwhite_King,1
skip_black_king_chck6: 
     
    ;;; 
    OutGrid71:


    add cl,2 ;3shan arsm ymeno badd 2 3shan already mna2so mara we ana barsm shmal

    

    cmp dl,7
    JA OutGrid81
    cmp cl,7
    JA OutGrid81
    cmp dl,0
    JB OutGrid81
    cmp cl,0
    JB OutGrid81
    ;block
      pusha
    call ROW_COL_TO_Number
    popa
    mov bh,0
    mov bl,Cell_To_Be_Moved
    mov al,Grid[bx]
    cmp al ,Black_King
    jne skip_black_king_chck7
        mov Checkwhite_King,1
skip_black_king_chck7: 
     
    ;;; 
    OutGrid81:


    ret


checkKingorsoldier_White    endp


CheckDiagonal_Black   proc    far

    pusha

    mov CheckBlack_King,0

    check_upLeftBlack:

     ;init el check
     ;call GetCurrentposKing

     mov ah,0
     mov al,CurrentPosBlackKing

    
    ;call convertIndextoRowCol
    ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

    lOOPa1ff: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1ff

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1ff


    OUT1ff:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx
    ;;;end fn



        cmp cx,7
        JA check_upRight
        cmp dl,7
        JA check_upRight

    check_uppp_loop:
        dec cl
        dec dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],White_Elephant
        je foundupleft

        cmp Grid[bx],White_Queen
        je foundupleft

        cmp Grid[bx],0
        je check_uppp_loop

        jmp check_upRight
     

     foundupleft:
     jmp foundDiagonal

     ;  OutDiagonalLeft:
     ;  jmp OutDiagonal

     ;------------------------------------------------------------------------------------------------
     
     check_upRight:
    
      ;init el check
     ;call GetCurrentposKing

     mov ah,0
     mov al,CurrentPosBlackKing

    
    ;call convertIndextoRowCol
    ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

    lOOPa1aa: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1aa

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1aa


    OUT1aa:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
        xchg cx, dx
    ;;;end fn



        cmp cx,7
        JA check_Downleft
        cmp dl,7
        JA check_Downleft

    check_uprightbb_loop:
        inc cl
        dec dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],White_Elephant
        je foundDiagonalRihgt

        cmp Grid[bx],White_Queen
        je foundDiagonalRihgt

        cmp Grid[bx],0
        je check_uprightbb_loop
   
     jmp check_Downleft

     foundDiagonalRihgt:
     jmp foundDiagonal

    ;  OutDiagonalupright:
    ;  jmp OutDiagonal

     ;-------------------------------------------------------------------------------------------------------

     check_Downleft:

     mov ah,0
     mov al,CurrentPosBlackKing

    
    ;call convertIndextoRowCol
    ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

    lOOPa1b: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1b

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1b


    OUT1b:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx
    ;;;end fn



        cmp cx,7
        JA check_DownRight
        cmp dl,7
        JA check_DownRight

    check_Downleft_loopb:
        dec cl
        inc dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],White_Elephant
        je foundDiagonal

        cmp Grid[bx],White_Queen
        je foundDiagonal

        cmp Grid[bx],0
        je check_Downleft_loopb


     ;---------------------------------------------------------------------------------------------------------

     check_DownRight:
      ;init el check
     ;call GetCurrentposKing

     mov ah,0
     mov al,CurrentPosBlackKing

    
    ;call convertIndextoRowCol
    ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

    lOOPa1: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1


    OUT1:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx
    ;;;end fn



        cmp cx,7
        JA skppp
        cmp dl,7
        JA skppp

    check_DownRight_loop:
        inc cl
        inc dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],White_Elephant
        je foundDiagonal

        cmp Grid[bx],White_Queen
        je foundDiagonal

        cmp Grid[bx],0
        je check_DownRight_loop

        jmp skppp



     foundDiagonal:
     mov CheckBlack_King,1


    skppp:

     OutDiagonalDownRightBlack:


     popa

     ret

CheckDiagonal_Black endp

CheckDiagonal_White   proc    far

    pusha

    mov CheckWhite_King,0


     check_upLeftWhite:
     ;init el check
     ;call GetCurrentposKing
     mov ah,0
     mov al,CurrentPosWhiteKing

     ;call convertIndextoRowCol


     ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

lOOPa1wuu: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1wuu

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1wuu


    OUT1wuu:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx

    ;;endfn

        cmp cx,7
        JA check_upRightWhite
        cmp dl,7
        JA check_upRightWhite

    check_upleft_loop1:
        dec cl
        dec dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],Black_Bishop
        je foundupleftWhite

        cmp Grid[bx],Black_Queen
        je foundupleftWhite

        cmp Grid[bx],0
        je check_upleft_loop1

        jmp check_upRightWhite
     

     

     foundupleftWhite:
     jmp founddiagonalwhite

     ;----------------------------------------------------------------------------------------

     check_upRightWhite:
     ;init el check
     ;call GetCurrentposKing
     mov ah,0
     mov al,CurrentPosWhiteKing

     ;call convertIndextoRowCol


     ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

lOOPa1wrr: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1wrr

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1wrr


    OUT1wrr:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx

    ;;endfn

        cmp cx,7
        JA check_Downleft_white
        cmp dl,7
        JA check_Downleft_white

    check_upRight_loop1:
        inc cl
        dec dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],Black_Bishop
        je foundupRightWhite

        cmp Grid[bx],Black_Queen
        je foundupRightWhite

        cmp Grid[bx],0
        je check_upRight_loop1

        jmp check_Downleft_white
     

     foundupRightWhite:
     jmp founddiagonalwhite

     

     ;------------------------------------------------------------------------------------------

     check_Downleft_white:
      ;init el check
     ;call GetCurrentposKing
     mov ah,0
     mov al,CurrentPosWhiteKing

     ;call convertIndextoRowCol


     ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

lOOPa1w1: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1w1

        SUB AX,8
        INC CX
        CMP AX,8

        JAE lOOPa1w1


    OUT1w1:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx

    ;;endfn

        cmp cx,7
        JA check_DownRightWhite
        cmp dl,7
        JA check_DownRightWhite

    check_Downleft_loop1:
        dec cl
        inc dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],Black_Bishop
        je founddiagonalwhite

        cmp Grid[bx],Black_Queen
        je founddiagonalwhite

        cmp Grid[bx],0
        je check_Downleft_loop1



     ;-----------------------------------------------------------------------------------

     check_DownRightWhite:
      ;init el check
     ;call GetCurrentposKing
     mov ah,0
     mov al,CurrentPosWhiteKing

     ;call convertIndextoRowCol


     ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX,0 
    MOV DX,0

lOOPa1w: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1w

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOPa1w


    OUT1w:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW

    ; We need cx -> col, dx, row
    xchg cx, dx

    ;;endfn

        cmp cx,7
        JA skppp1
        cmp dl,7
        JA skppp1

    check_DownRight_loop1:
        inc cl
        inc dl

        pusha
        call ROW_COL_TO_Number
        popa

        mov bh,0
        mov bl,Cell_To_Be_Moved


        cmp Grid[bx],Black_Bishop
        je founddiagonalwhite

        cmp Grid[bx],Black_Queen
        je founddiagonalwhite

        cmp Grid[bx],0
        je check_DownRight_loop1

        jmp skppp1



     founddiagonalwhite:
     mov CheckWhite_King,1


    skppp1:


     OutDiagonalDownRightwhite:


     popa

     ret

CheckDiagonal_White endp


;Final Check fns
Check_Black_CheckStatus proc far

    pusha
    ;3ayzen ne call kol checks el black king

    pusha
    call CheckVertical_BlackKing
    popa
    cmp CheckBlack_King,1
    je CheckBlackMes

    pusha
    call CheckHorizontal_BlackKing
    popa
    cmp CheckBlack_King,1
    je CheckBlackMes

    pusha
    call CheckDiagonal_Black
    popa
    cmp CheckBlack_King,1
    je CheckBlackMes

    pusha
    call CheckWhiteKnight
    popa
    cmp CheckBlack_King,1
    je CheckBlackMes

    pusha
    call checkKingorsoldier_Black
    popa
    cmp CheckBlack_King,1
    je CheckBlackMes

    jmp outtchecking

    CheckBlackMes:
    ;Display mes on status bar

    ;move cursor
    mov ah,2
    mov dh,59
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset checkmessageblackk
    int 21h
    jmp endCheckStatusB

    ; todo clear msg
    outtchecking:
    ;Display mes on status bar
    ;move cursor
    mov ah,2
    mov dh,59
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset clearCheckMsg
    int 21h

endCheckStatusB:


    popa
    ret


Check_Black_CheckStatus endp

Check_White_CheckStatus proc far

    pusha
    ;3ayzen ne call kol checks el black king
    pusha
    call CheckVertical_WhiteKing
    popa
    cmp Checkwhite_King,1
    je CheckWhitekMes

    pusha
    call CheckHorizontal_WhiteKing
    popa
    cmp Checkwhite_King,1
    je CheckWhitekMes

    pusha
    call CheckDiagonal_White
    popa
    cmp Checkwhite_King,1
    je CheckWhitekMes

    pusha
    call CheckBlackKnight
    popa
    cmp Checkwhite_King,1
    je CheckWhitekMes

    pusha
    call checkKingorsoldier_White
    popa
    cmp Checkwhite_King,1
    je CheckWhitekMes

    jmp outtchecking1

    CheckWhitekMes:
    ;Display mes on status bar

    ;move cursor
    mov ah,2
    mov dh,61
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset checkmessageWhiteK
    int 21h
    jmp endCheckStatusW

    outtchecking1:
    ;Display mes on status bar
    ;move cursor
    mov ah,2
    mov dh,61
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset clearCheckMsg
    int 21h

endCheckStatusW:
    popa
    ret


Check_White_CheckStatus endp

Checkmate_Black_CheckStatus proc far

    pusha
    ;3ayzen ne call kol checks el black king

    call CheckVertical_BlackKing
    cmp CheckBlack_King,1
    je this_place_checked

    call CheckHorizontal_BlackKing
    cmp CheckBlack_King,1
    je this_place_checked

    call CheckDiagonal_Black
    cmp CheckBlack_King,1
    je this_place_checked

    call CheckWhiteKnight
    cmp CheckBlack_King,1
    je this_place_checked

    call checkKingorsoldier_Black
    cmp CheckBlack_King,1
    je this_place_checked

    this_place_checked:


    popa
    ret


Checkmate_Black_CheckStatus endp


Checkmate_White_CheckStatus proc far

    pusha
    ;3ayzen ne call kol checks el black king

    call CheckVertical_WhiteKing
    cmp Checkwhite_King,1
    je this_place_checked1

    call CheckHorizontal_WhiteKing
    cmp Checkwhite_King,1
    je this_place_checked1

    call CheckDiagonal_White
    cmp Checkwhite_King,1
    je this_place_checked1

    call CheckBlackKnight
    cmp Checkwhite_King,1
    je this_place_checked1

    call checkKingorsoldier_White
    cmp Checkwhite_King,1
    je this_place_checked1

    this_place_checked1:

    popa
    ret


Checkmate_White_CheckStatus endp

clear_checkmate_black   proc    far

 ;mov CheckmateBlack_King,1
    mov ah,2
    mov dh,62
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset clearCheckMsg
    int 21h
    
    ret

clear_checkmate_black   endp


Checkmate_balck proc    far

   ;call GetCurrentposKing
   cmp CheckBlack_King,0
   jne contttt
   call clear_checkmate_black
   ret
   contttt:

   mov CheckBlack_King,0
   mov bl,CurrentPosBlackKing 
   mov bh,0
 
    BIGLOOPRightb:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Rightb: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Rightb

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Rightb


        OUT13Rightb:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  




    mov ch,0
    mov dh,0

    pusha    ;3shan arsm el 3 ely fo2
    sub dl,1
    sub cl,1


    cmp dl,7    ;fo2 shmal  
    JA OutGrid1b
    cmp cl,7
    JA OutGrid1b
    cmp dl,0
    JB OutGrid1b
    cmp cl,0
    JB OutGrid1b
    
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[bx],Black_King
    popa
    cmp CheckBlack_King,1
    je contt
    popa
    call clear_checkmate_black
    ret
    contt: 
    OutGrid1b:

    add cl,1


    cmp dl,7
    JA OutGrid2b
    cmp cl,7
    JA OutGrid2b
    cmp dl,0
    JB OutGrid2b
    cmp cl,0
    JB OutGrid2b
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[bx],Black_King
    popa
    cmp CheckBlack_King,1
    je contt1
    popa
    call clear_checkmate_black
    ret
    contt1:
    OutGrid2b:

    add cl,1

    cmp dl,7    ;fo2 ymen   3askry
    JA OutGrid3b
    cmp cl,7
    JA OutGrid3b
    cmp dl,0
    JB OutGrid3b
    cmp cl,0
    JB OutGrid3b

    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[BX],Black_King
    popa
    cmp CheckBlack_King,1
    je contt2
    popa
    call clear_checkmate_black
    ret
    contt2:
    OutGrid3b:

   popa
    
    ; ;;;;;;;;;;;;;;;;;;;
    pusha    ;3shan arsm el 3 ely taht
    dec cl
    inc dl


    cmp dl,7     ;taht shmal
    JA OutGrid4b
    cmp cl,7
    JA OutGrid4b
    cmp dl,0
    JB OutGrid4b
    cmp cl,0
    JB OutGrid4b

    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[bx],Black_King
    popa
    cmp CheckBlack_King,1
    je contt3
    popa
    call clear_checkmate_black
    ret
    contt3:
    OutGrid4b:

    inc cl

    cmp dl,7
    JA OutGrid5b
    cmp cl,7
    JA OutGrid5b
    cmp dl,0
    JB OutGrid5b
    cmp cl,0
    JB OutGrid5b
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[bx],Black_King
    popa
    cmp CheckBlack_King,1
    je contt4
    popa
    call clear_checkmate_black
    ret
    contt4:
    OutGrid5b:

    inc cl


    cmp dl,7        ;taht ymen
    JA OutGrid6b
    cmp cl,7
    JA OutGrid6b
    cmp dl,0
    JB OutGrid6b
    cmp cl,0
    JB OutGrid6b
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[bx],Black_King
    popa
    cmp CheckBlack_King,1
    je contt5
    popa
    call clear_checkmate_black
    ret
    contt5:
    OutGrid6b:
 
    popa

    dec cl      ;3shan arsm shmalo


    cmp dl,7
    JA OutGrid7b
    cmp cl,7
    JA OutGrid7b
    cmp dl,0
    JB OutGrid7b
    cmp cl,0
    JB OutGrid7b
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[bx],Black_King
    popa
    cmp CheckBlack_King,1
    je contt6
    call clear_checkmate_black
    ret
    contt6:
    ;;; 
    OutGrid7b:


    add cl,2 ;3shan arsm ymeno badd 2 3shan already mna2so mara we ana barsm shmal

    

    cmp dl,7
    JA OutGrid8b
    cmp cl,7
    JA OutGrid8b
    cmp dl,0
    JB OutGrid8b
    cmp cl,0
    JB OutGrid8b
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosBlackKing
    mov grid[bx],0
    call Checkmate_Black_CheckStatus
    mov grid[BX],Black_King
    popa
    cmp CheckBlack_King,1
    je contt7
    call clear_checkmate_black
    ret
    contt7:
    OutGrid8b:
     
    ;mov CheckmateBlack_King,1
    mov ah,2
    mov dh,62
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset checkmate_messageblack
    int 21h
    
    ret



Checkmate_balck endp

clear_checkmate_white   proc    far


    mov ah,2
    mov dh,63
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset clearCheckMsg
    int 21h

    ret

clear_checkmate_white   endp


Checkmate_white proc    far
    

   cmp CheckWhite_King,0
   jne conttttw
   call clear_checkmate_white
   ret
   conttttw:
  
   mov CheckWhite_King,0
   mov bl,CurrentPosWhiteKing 
   mov bh,0
 
    BIGLOOPRightw:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0   ;row

        lOOP1Rightw: 

            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13Rightw

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE lOOP1Rightw


        OUT13Rightw:

            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW  



    mov ch,0
    mov dh,0

    pusha    ;3shan arsm el 3 ely fo2
    sub dl,1
    sub cl,1


    cmp dl,7    ;fo2 shmal  
    JA OutGrid1w
    cmp cl,7
    JA OutGrid1w
    cmp dl,0
    JB OutGrid1w
    cmp cl,0
    JB OutGrid1w
    
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je conttw
    popa
    call clear_checkmate_white
    ret
    conttw: 
    OutGrid1w:

    add cl,1


    cmp dl,7
    JA OutGrid2w
    cmp cl,7
    JA OutGrid2w
    cmp dl,0
    JB OutGrid2w
    cmp cl,0
    JB OutGrid2w
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt1w
    popa
    call clear_checkmate_white
    ret
    contt1w:
    OutGrid2w:

    add cl,1

    cmp dl,7    ;fo2 ymen   
    JA OutGrid3w
    cmp cl,7
    JA OutGrid3w
    cmp dl,0
    JB OutGrid3w
    cmp cl,0
    JB OutGrid3w

    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt2w
    popa
    call clear_checkmate_white
    ret
    contt2w:
    OutGrid3w:

    popa
    
    ; ;;;;;;;;;;;;;;;;;;;
    pusha    ;3shan arsm el 3 ely taht
    dec cl
    inc dl


    cmp dl,7     ;taht shmal
    JA OutGrid4w
    cmp cl,7
    JA OutGrid4w
    cmp dl,0
    JB OutGrid4w
    cmp cl,0
    JB OutGrid4w

    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt3w
    popa
    call clear_checkmate_white
    ret
    contt3w:
    OutGrid4w:

    inc cl

    cmp dl,7
    JA OutGrid5w
    cmp cl,7
    JA OutGrid5w
    cmp dl,0
    JB OutGrid5w
    cmp cl,0
    JB OutGrid5w
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[BX],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt4w
    popa
    call clear_checkmate_white
    ret
    contt4w:
    OutGrid5w:

    inc cl


    cmp dl,7        ;taht ymen
    JA OutGrid6w
    cmp cl,7
    JA OutGrid6w
    cmp dl,0
    JB OutGrid6w
    cmp cl,0
    JB OutGrid6w
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt5w
    popa
    call clear_checkmate_white
    ret
    contt5w:
    OutGrid6w:
 
    popa

    dec cl      ;3shan arsm shmalo


    cmp dl,7
    JA OutGrid7w
    cmp cl,7
    JA OutGrid7w
    cmp dl,0
    JB OutGrid7w
    cmp cl,0
    JB OutGrid7w
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt6w
    call clear_checkmate_white
    ret
    contt6w:
    ;;; 
    OutGrid7w:


    add cl,2 ;3shan arsm ymeno badd 2 3shan already mna2so mara we ana barsm shmal

    

    cmp dl,7
    JA OutGrid8w
    cmp cl,7
    JA OutGrid8w
    cmp dl,0
    JB OutGrid8w
    cmp cl,0
    JB OutGrid8w
    ;block
    pusha
    mov bh,0
    mov bl,CurrentPosWhiteKing
    mov grid[bx],0
    call Checkmate_White_CheckStatus
    mov grid[bx],White_King
    popa
    cmp CheckWhite_King,1
    je contt7w
    call clear_checkmate_white
    ret
    contt7w:
    OutGrid8w:
     
    ;mov CheckmateBlack_King,1
    mov ah,2
    mov dh,63
    mov dl,33
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset checkmate_messageWhite
    int 21h
    
    ret

 
Checkmate_white endp


Checkmate   proc    far

    pusha

    call GetCurrentposKing

    pusha
    call Checkmate_balck
    popa
    pusha
    call Checkmate_white
    popa

    popa

    ret
Checkmate   endp

BigCheck_CallPosKing proc far

    pusha
    call GetCurrentposKing

    call Check_Black_CheckStatus
    call Check_White_CheckStatus
    popa

    ; pusha
    ; call Checkmate
    ; popa

 ret

BigCheck_CallPosKing endp

END