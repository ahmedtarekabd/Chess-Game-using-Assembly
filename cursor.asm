.286

public Set_Old_place_color_and_place
public cursorInit
public cursor

.MODEL HUGE
.STACK 64
.DATA

BorderGrid db 64 dup(0) ;0 MEANS EMPTY
;4 variable bastore fehom el col we el row ely kol.....
;.....highlight etrasm feha 3shan a3rf acheck lma ahrk le high fo2 we taht
;el initial cond.
colpl1 db 0 ;not used
rowpl1 db 0 ;al
colpl2 db 0 ;not used
rowpl2 db 7 ;al
cellDimension   equ     100 ;board var
whiteColor      equ     0fh ;board var

High1 equ 10 
;add posible moves for player 1
High2 equ 11 
;add posible moves for player 2

.CODE


;fe kol fn el tahrokat
;              bl->High el la3rb ely 3ayz t8yro
;              bh->el la3eb el tany
;              el di fe el asl le pl1 bs byt3mlo xchg abl ma bykhosh fe pl2
;              el al feha row el player ely 3ayz ahrko

;b3rf el cx be el col we el dx be el row bta3y 3shan lma acall el fn....
;....taht we 3shan fe el loop a3r odd wala even



Set_Old_place_color_and_place proc far 
;NEEDED VARIABLES: cl->col el player ely hayt7rk / dl->row el player ely haythark
; el fn deh btshof el mkan el adem bta3y we btrg3ly mkano we el....
;...lon ely el mafrod alono 3la hasab el row we el col even wala odd
mov ch,0
mov dh,0


;b3rf ely ana fe anhy lon 3n tare2 el odd we el even bto3 el row we el col
mov ch,0
        mov ax,cx 
        mov bl,2
        div bl
        cmp ah,0
        JE Even_col
        cmp ah,1
        JE Odd_col

Even_col:
        mov ax,dx 
        mov bl,2
        div bl
        cmp ah,0
        JE Even_col_Even_row
        cmp ah,1
        JE Even_Col_Odd_Row


Odd_col:
        mov ax,dx 
        mov bl,2
        div bl
        cmp ah,0
        JE Odd_col_Even_row
        cmp ah,1
        JE Odd_col_odd_row

Odd_col_Even_row:
Even_Col_Odd_Row:
mov al,07h

jmp skip_al_mov

Odd_col_odd_row:
Even_col_Even_row:
mov al,06h
skip_al_mov:
ret
Set_Old_place_color_and_place endp


;-----------------------------------Draw Border Fn----------------------------------------
Draw_border proc far   ;cx-> col dx->row  al->color
pusha
push ax
;call starting_pixels
    mov ax,cx  ;bmultiply el cx by 100d 3shan ageb el starting col
    mov bx,100d
    push dx
    mul bx
    pop dx
    mov cx,ax

    mov ax,dx ;bmultiply el dx by 100d 3shan ageb el starting row
    mov bx,100d
    push dx
    mul bx
    pop dx
    mov dx,ax
;fn end
pop ax
    
     
;call Draw_Border
   
    mov bx,100d
    mov di,cx   ;bhot fe el di el value bta3t el cx+100d 3shan arsm l8aytha
    add di,bx
    mov si,dx  ;bhot fe el si el value bta3t el dx+100d 3shan arsm l8aytha
    add si,bx

    loop_2:
    ;mov al,02h ;el color mt3rf bara 3shan kol border yb2a lon
    mov ah,0ch ;draw pixel commd     
    
    back: int 10h
    inc cx
    cmp cx,di
    jnz back


    back2: int 10h
    inc dx
    cmp dx,si
    jnz back2

    sub di,bx 
    cmp bx,96d
    JE ADD_DI
    Cont:
    back3: int 10h
    dec cx
    cmp cx,di
    jnz back3
    

    sub si,bx
    cmp bx,96d
    JE ADD_SI
    Cont_2:
   
    back4: int 10h
    dec dx
    cmp dx,si
    jnz back4

    add dx,4d
    add cx,4d
 
    sub bx,4d
    add di,bx
    add si,bx
    
    
    cmp bx,92d ;3shan tlf mara wahda bs 3shan bsub be 4 fo2
    jNE loop_2 

    ;fn finish 
    jmp skip_add_di
 
    ADD_Di:
    add di,4d
   jmp cont


   ADD_SI:
    add si,4d
   jmp Cont_2          
            
   skip_add_di: 

popa
ret
Draw_border endp


;-------------------------------------Right Fn----------------------------------------

Right proc far
mov BorderGrid[di],0;3shan yshel el box el adem
cmp di,offset bordergrid +63 ;3shan lw mshy ymen lw fe akher mkan yrg3 lel awel
JE Max_right  ; 3shan yrsm el etnen 3shan ek tany bytms7
add di,1
mov BorderGrid[di],bl
;condition 3shan lw high2 kan fe nafs el mkan hytoverwrite 3aleh fa barsmo kol mara ehtyaty
mov BorderGrid[si],bh 
jmp Skip_1

Max_right:
mov di,0
mov BorderGrid[di],bl
;condition 3shan lw high2 kan fe nafs el mkan hytoverwrite 3aleh fa barsmo kol mara ehtyaty
mov BorderGrid[si],bh


Skip_1:


ret
Right endp

;-------------------------------------Down Fn----------------------------------------
Down proc far
mov bordergrid[di],0 ;bamsa7 el adem
cmp al,7 ;lw fe row 0 mhatg ynzel taht 
JE Max_Down ;3shan ysbat mkano byskip htet eno yincrement

add di,8
Max_Down:
;condition 3shan lw high2 kan fe nafs el mkan hytoverwrite 3aleh fa barsmo kol mara ehtyaty
mov BorderGrid[si],bh
mov bordergrid[di],bl
ret
Down endp

;-------------------------------------Up Fn----------------------------------------
Up proc far
mov bordergrid[di],0 ;bamsa7 el adem
cmp al,0 ;lw fe row 0 mhatg ynzel taht 
JE Max_Up ;3shan ysbat mkano byskip htet eno ydecrement


sub di,8

Max_Up:
;condition 3shan lw high2 kan fe nafs el mkan hytoverwrite 3aleh fa barsmo kol mara ehtyaty
mov BorderGrid[si],bh
mov bordergrid[di],bl

ret
Up endp

;-------------------------------------Left Fn----------------------------------------

Left proc far
mov BorderGrid[di],0;3shan yshel el box el adem
cmp di,offset bordergrid +0 ;3shan lw mshy ymen lw fe akher mkan yrg3 lel awel
JE Max_Left  ; 3shan yrsm el etnen 3shan ek tany bytms7
sub di,1
mov BorderGrid[di],bl
;condition 3shan lw high2 kan fe nafs el mkan hytoverwrite 3aleh fa barsmo kol mara ehtyaty
mov bordergrid[si],bh
jmp Skip_4

Max_Left:
mov di,63
mov BorderGrid[di],bl
;condition 3shan lw high2 kan fe nafs el mkan hytoverwrite 3aleh fa barsmo kol mara ehtyaty
mov bordergrid[si],bh
Skip_4:


ret
Left  endp

Draw_Highs  proc far

;call Check 
;batcheck 3la el array bta3y bashof fen.. 
;..el hagat ely mhtaga arsmha we mnha bywadeny 3la el draws ely taht
MOV BX,0 ;Counter 
BIGLOOP_high:  ;Cx col ;Dx row

    MOV AX,BX  ;MAKAN ELY FEL MEMORY
    MOV dX,0 ;row

    lOOP1_high: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1_high

        SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
        INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
        CMP AX,8

        JAE lOOP1_high


    OUT1_high:
        MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW       
        ;call Check_Draw   ;Check if there is a COMPONENT to draw 
        CMP BorderGrid[BX],High1   ;btshof hwa ely fe el grid dah 
        JE Draw_High1

        CMP BorderGrid[BX],High2
        JE Draw_High2
        finish_Draw_high:
;fn end
    
 
    INC BX
    CMP BX,64 
    JNE BIGLOOP_high

    JMP SKIP_DRAW ;3shan matkhoshesh fe el fn bta3et el drawing tany

;--------------------------Draw_Highlight for player 1----------------------------
Draw_High1:
;bastore el row we el col ely etrasem feh 3shan a3rf a3mel el check lma agy ahrko fo2 we taht
mov colpl1,cl  
mov rowpl1,dl

mov al,0ah ;pl1 color
call Draw_border
jmp finish_Draw_high

;--------------------------Draw_Highlight for player 2----------------------------

Draw_High2:
;bastore el row we el col ely etrasem feh 3shan a3rf a3mel el check lma agy ahrko fo2 we taht
mov rowpl2,dl
mov colpl2,cl
mov al,0eh ;pl2color

call Draw_border
JMP finish_Draw_high
    
    SKIP_DRAW:  

ret
Draw_Highs endp


;----------------------------------------Move_Player------------------------------
move_player_And_Delete_Old proc far
  cmp al,61h ;A left
    JE Max_Jmp_A_Left
   
    cmp al,77h ;W up
    JE Max_Jmp_W_Up

    cmp al,64h ;D right
    JE Max_Jmp_D_Right

    cmp al,73h ;S down
    JE Max_Jmp_S_Down

    cmp ah,48h ;arrowup
    JE Max_Jmp_Up

    cmp ah,50h ;arrow down
    Je Max_Jmp_down

    cmp ah,4Dh ;arrow Right
    Je Max_Jmp_Right

    cmp ah,4Bh ;arrow Left
    Je Max_Jmp_Left

    jmp skip_BorderGrid_Moving ;3sahn lw input 8alat


;-------MAX JMPS--------;
Max_Jmp_A_Left:
jmp A_Left
Max_Jmp_W_Up:
jmp W_Up
Max_Jmp_D_Right:
jmp D_Right
Max_Jmp_S_Down:
jmp S_Down
Max_Jmp_Up:
jmp arrow_up
Max_Jmp_down:
jmp arrow_down
Max_Jmp_Right:
jmp arrow_right
Max_Jmp_Left:
jmp arrow_Left


A_Left:
mov bh,High2 ;bymov fe el bh el player ely msh 3ayz ahrko (hna pl2)
mov bl,High1 ;bymov fe el bl player el 3ayz ahrko (hna pl1)
call Left

pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl1
mov dl,rowpl1
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa
jmp skip_BorderGrid_Moving

;;;;;;;;;;;;;;;;;;;;;;;;;
W_Up:
mov al,rowpl1
mov bh,High2
mov bl,High1
call Up

pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl1
mov dl,rowpl1
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa
jmp skip_BorderGrid_Moving



;;;;;;;;;;;;;;;;;;;;;;;;;
D_Right:
mov bh,High2
mov bl,High1
call Right
pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl1
mov dl,rowpl1
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa
jmp skip_BorderGrid_Moving




;;;;;;;;;;;;;;;;;;;;;;;;;
S_Down:
mov al,rowpl1
mov bh,High2
mov bl,High1
call Down
pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl1
mov dl,rowpl1
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa

jmp skip_BorderGrid_Moving

;-----------------------------------------Arrows-------------------------------------------
arrow_up:
mov al,rowpl2 ;bymov fe el al el row bta3 el player ely 3ayzo
xchg di,si ;byexchange 3shan gwa el fn el di bta3 pl1 fa by2lbhom
mov bh,High1 ;byhot fe el bh ely player el tany (hna pl1)  
mov bl,High2 ;byhot fe el bl ely player ely 3ayz ahrko (hna pl2)
call Up

pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl2
mov dl,rowpl2
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa

xchg di,si ;byrg3hom tany
jmp skip_BorderGrid_Moving

;;;;;;;;;;;;;;;;;;;;;;;;;
arrow_down:
mov al,rowpl2
xchg di,si
mov bh,High1
mov bl,High2
call Down

pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl2
mov dl,rowpl2
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa

xchg di,si
jmp skip_BorderGrid_Moving

;;;;;;;;;;;;;;;;;;;;;;;;;

arrow_right:
xchg di,si
mov bh,High1
mov bl,High2
call Right

pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl2
mov dl,rowpl2
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa

xchg di,si
jmp skip_BorderGrid_Moving

;;;;;;;;;;;;;;;;;;;;;;;;;
arrow_Left:
xchg di,si
mov bh,High1
mov bl,High2
call Left

pusha 
;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
mov cl,colpl2
mov dl,rowpl2
call Set_Old_place_color_and_place 
;to remove old border we draw above it border
call Draw_border
popa

xchg di,si
jmp skip_BorderGrid_Moving

skip_BorderGrid_Moving:

ret
move_player_And_Delete_Old endp




cursor  	PROC    FAR

    call move_player_And_Delete_Old
    call Draw_Highs ; call fn again

    ret
  
cursor  ENDP

cursorInit      PROC    FAR

    mov di, 0 ;di for player1
    mov si, 56 ;si for player2
    ;add si, 56
    mov BorderGrid[di], High1 ;starting point for high1
    mov BorderGrid[si], High2 ;starting point for high2

    call Draw_Highs

    ret

cursorInit  ENDP

END