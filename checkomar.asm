.286
.MODEL SMALL
.STACK 64
.DATA

;-------------------------------------------------------

CurrentPosBlackKing db ?
CurrentPosWhiteKing db ? 


CheckBlack_King db ?
CheckWhite_King db ?


checkmessageblackk db 'Watch out! The Black king is attacked!','$'
checkmessageWhiteK db 'Watch out! The White king is attacked!','$'


;--------------------------------------------------------

mesStatus db 'Status Bar','$'

;Added for statusbar
mesSoldierWhite db 'White Pawm is Killed ','$'
mesSoldierBlack db 'Black Pawm is Killed ','$'

mesWhiteRook db 'White Rook is Killed ','$'
mesBlackRook db 'Black Rook is Killed ','$'

mesWhiteKnight db 'White Knight is Killed ','$'
mesBlackKnight db 'Black Knight is Killed ','$'

mesWhiteBishop db 'White Bishop is Killed ','$'
mesBlackBishop db 'Black Bishop is Killed ','$'

mesWhiteQueen db 'White Queen is Killed ','$'
mesBlackQueen db 'Black Queen is Killed ','$'

mesWhiteKing db 'White King is Killed ','$'
mesBlackKing db 'Black King is Killed ','$'








BorderGrid db 64 dup(0) ;0 MEANS EMPTY ;arr feh HIgh1,High2
;4 variable bastore fehom el col we el row ely kol.....
;.....highlight etrasm feha 3shan a3rf acheck lma ahrk le high fo2 we taht
;el initial cond.
colpl1 db 0 
rowpl1 db 0 ;al
colpl2 db 0 
rowpl2 db 7 ;al
;currentpl db ? ;1 lw player1 ely fo2 we vice versa
color_Highpl1 db 01h ;color of possible moves for pl1
Color_Highpl2 db 02h ;color of possible moves for pl2
color_Kill_Highpl1 db 04h ;color of killing for pl1
color_Kill_Highpl2 db 05h ;color of killing for pl2
;0 means it didn't draw because a piece (same color) was there and 1 vice versa 
;2 means highlighted kill (piece diff color) / 3 bahotha 3shan bs a3rf en mafhash zero
Drawed db 3  
;Q_Pressed db ?;var store how many time Q is pressed 1 or 2
;M_Pressed db ?;var store how many time M is pressed 1 or 2
kill_1  db 0 ;var by2oly feh had haweto wala la
kill_2  db 0 ;var by2oly feh had haweto wala la
;var bastore feh fe fn draw_border_pieces 3shan ba push we papop fa mady3sh el value
;value -> ely mawgoda gwa el array fe el boxes mn 0 ->63
Pieces_value db ?  
Q_pressed_on_what db 0 ;variable bastore feh lma dost q kont wa2ef 3la eh
M_pressed_on_what db 0
;variable bastore fehom el col we el row lel piece ely dost 3aleha q
Q_row db ?
Q_col db ?
M_row db ?
M_col db ?
;array bastore feha el possible move bta3 el piece ely mdas 3aleha q
Q_possible_moves_arr db 64 dup(0) ;0->no possible move 1->possible move
M_Poss_Moves_arr db 64 dup(0)

;var lw be 1 yb2a draw_border_pieces hatrsm el kill_high blon el board 3shan yms7o lw be 0 yb2a zy ma hwa hy3mel high el kill
Kill_off db ?

color_to_delete_with db ? ;var bastore feh el lon ely hams7 beh


;used in knowing which cell is q pressed on it ;var fe fn ROW_COL_TO_Number bastore feh ana fe anhy box
Cell_To_Be_Moved db ?


cellDimension   equ     100 ;board var
whiteColor      equ     0fh ;board var

High1 equ 10 
;add posible moves for player 1
High2 equ 11 
;add posible moves for player 2



;-------------------------Grid Vars---------------
orangeCell     equ     0    ;changeddd

; Piece numbers 
White_Soldier equ 1
White_Rook equ 2
White_Horse equ 3
White_Elephant equ 4
White_Queen equ 5
White_King equ 6
;above 10 means black pieces and vice versa
Black_Pawm equ 11
Black_Rook equ 22
Black_Knight equ 33
Black_Bishop equ 44
Black_Queen equ 55
Black_King equ 66

noCellSelected      equ     -1

Grid db 64 dup(0) ;0 MEANS EMPTY
selectedCell    db  8
;-----------------------Grid Vars End-----------------

.CODE

;b3rf el cx be el col we el dx be el row bta3y 3shan lma acall el fn....
;....taht we 3shan fe el loop a3r odd wala even

;--------------------------------------Grid Fn----------------------------
piecesInit      PROC    FAR
    ; ---- INIT ----
;White
    mov grid[0],White_Rook
    add grid[0], orangeCell
    mov grid[1],White_Horse
    mov grid[2],White_Elephant
    add grid[2], orangeCell
    mov grid[3],White_Queen
    mov grid[4],White_King
    add grid[4], orangeCell
    mov grid[5],White_Elephant
    mov grid[6],White_Horse
    add grid[6], orangeCell
    mov grid[7],White_Rook

    mov grid[8],White_Soldier
    mov grid[9],White_Soldier
    add grid[9], orangeCell
    mov grid[10],White_Soldier
    mov grid[11],White_Soldier
    add grid[11], orangeCell
    mov grid[12],White_Soldier
    mov grid[13],White_Soldier
    add grid[13], orangeCell
    mov grid[14],White_Soldier
    mov grid[15],White_Soldier
    add grid[15], orangeCell

    
;Black
    mov grid[63],Black_Rook
    add grid[63], orangeCell
    mov grid[62],Black_Knight
    mov grid[61],Black_Bishop
    add grid[61], orangeCell
    mov grid[60],Black_Queen
    mov grid[59],Black_King
    add grid[59], orangeCell
    mov grid[56],Black_Rook
    mov grid[57],Black_Knight
    add grid[57], orangeCell
    mov grid[58],Black_Bishop

    mov grid[55],Black_Pawm
    mov grid[54],Black_Pawm
    add grid[54], orangeCell
    mov grid[53],Black_Pawm
    mov grid[52],Black_Pawm
    add grid[52], orangeCell
    mov grid[51],Black_Pawm
    mov grid[50],Black_Pawm
    add grid[50], orangeCell
    mov grid[49],Black_Pawm
    mov grid[48],Black_Pawm
    add grid[48], orangeCell


MOV BX, 0 ;Counter
BIGLOOP_1:

    MOV AX,BX  ;MAKAN ELY FEL MEMORY
    MOV CX,0 
    MOV DX,0 

    lOOP1_1: 
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1_1

        SUB AX,8
        INC CX
        CMP AX,8

        JAE lOOP1_1


    OUT1_1:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW


    JMP OUT2_1


    OUT2_1: 
    
    ; We need cx -> col, dx, row
    push bx
    mov ax,dx  ;bmultiply el cx by 100d 3shan ageb el starting col
    mov bx,100d
    push cx
    mul bx
    pop cx
    mov dx,ax


    mov ax,cx ;bmultiply el dx by 100d 3shan ageb el starting row
    mov bx,100d
    push cx
    mul bx
    pop cx
    mov cx,ax
    pop bx

    ;DRAW COMPONENT
    pusha
    ;call DrawComp    ;uncomment to draw pieces
    popa


    INC BX
    CMP BX,64 
    JNE BIGLOOP_1

    ret

piecesInit  ENDP
;-----------------------------------Grid Fn----------------------



Set_Old_place_color_and_place proc far 
;NEEDED VARIABLES: cl->col el player ely hayt7rk / dl->row el player ely haythark
; el fn deh btshof el mkan el adem bta3y we btrg3ly mkano we el....
;...lon ely el mafrod alono 3la hasab el row we el col even wala odd fe al,color_to_delete_with

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
mov al,00h
mov color_to_delete_with,al

jmp skip_al_mov

Odd_col_odd_row:
Even_col_Even_row:
mov al,08h
mov color_to_delete_with,al

skip_al_mov:
ret
Set_Old_place_color_and_place endp


;-----------------------------------Draw Border Fn----------------------------------------
Draw_border proc far   ;cx-> col dx->row  al->color ;lazem el cx we el dx kolha msh cl,dl
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
   add Si,4d
   jmp cont_2        
            
   skip_add_di: 

popa
ret
Draw_border endp

;------------------------------------Movement Input Fns-------------------------------
;fe kol fn el tahrokat
;              bl->High el la3rb ely 3ayz t8yro
;              bh->el la3eb el tany
;              el di fe el asl le pl1 bs byt3mlo xchg abl ma bykhosh fe pl2
;              el al feha row el player ely 3ayz ahrko
;-------------------------------------Right Fn----------------------------------------

Right proc far
    ;mov bh,High pl ely msh 3ayz ahrko
    ;mov bl,High pl ely 3ayz ahrko

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
    ;mov al,row el pl ely 3ayz ahrko
    ;mov bh,High el pl ely msh 3ayz ahrko
    ;mov bl,High el pl ely 3ayz ahrko

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
    ;mov al,row el pl ely 3ayz thrko
    ;mov bh,High el pl el tany
    ;mov bl,High el pl el awlany

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
    ;bymov fe el bh el player ely msh 3ayz ahrko
    ;bymov fe el bl player el 3ayz ahrko

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

    pusha
    ;call Check 
    ;batcheck 3la el array bta3y bashof fen.. 
    ;..el hagat ely mhtaga arsmha we mnha bywadeny 3la el draws ely taht
    MOV BX,0 ;Counter 
    BIGLOOP:  ;Cx col ;Dx row

        MOV AX,BX  ;MAKAN ELY FEL MEMORY
        MOV dX,0 ;row

        lOOP1: 
            CMP AX,7  ;AWEL ROW COMPARE
            JBE OUT13

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE LOOP1


        OUT13:
            MOV CX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW       
            ;call Check_Draw   ;Check if there is a COMPONENT to draw 
            CMP BorderGrid[BX],High1   ;btshof hwa ely fe el grid dah 
            JE Draw_High1

            CMP BorderGrid[BX],High2
            JE Draw_High2
            finish_Draw:
    ;fn end
        
    
        INC BX
        CMP BX,64 
        JNE BIGLOOP

        JMP SKIP_DRAW ;3shan matkhoshesh fe el fn bta3et el drawing tany

    ;--------------------------Draw_Highlight for player 1----------------------------
    Draw_High1:
    ;bastore el row we el col ely etrasem feh 3shan a3rf a3mel el check lma agy ahrko fo2 we taht
    mov colpl1,cl  
    mov rowpl1,dl

    mov al,03h ;pl1 color
    call Draw_border
    jmp finish_Draw

    ;--------------------------Draw_Highlight for player 2----------------------------

    Draw_High2:
    ;bastore el row we el col ely etrasem feh 3shan a3rf a3mel el check lma agy ahrko fo2 we taht
    mov rowpl2,dl
    mov colpl2,cl
    mov al,0eh ;pl2color

    call Draw_border
    JMP finish_Draw
        
    SKIP_DRAW: 
    popa 

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
    call Left ;8yrt el value ely gwa el array

    ;----------ely bymsa7 el eadem
    pusha 
    ;btrg3y el values ely mhtagha 3shan a3rf adraw el border 3la el adeem
    mov cl,colpl1
    mov dl,rowpl1
    call Set_Old_place_color_and_place ;el fn btrg3ly fe el al color fa msh mhatg ahto
    ;to remove old border we draw above it border
    call Draw_border
    popa
    ;-------------
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


;-------------------------------------------Fns Board-------------------------------

drawSquare    PROC    FAR

    ; Usage: specify the starting x and y (cx, dx) before calling
    ;        al -> color

    mov si, cx
    add si, cellDimension

    mov bp, dx
    add bp, cellDimension

    ;mov al, 0fh        ;Pixel color
    mov ah, 0ch      ;Draw Pixel Command
rowSquare: 
colSquare: 
    int 10h
    inc cx
    cmp cx, si
    jnz colSquare
    
    sub cx, cellDimension
    inc dx
    cmp dx, bp
    jnz rowSquare

    mov cx, si

    ret

drawSquare    ENDP


drawRow     PROC    FAR

    ; Usage: 
    ; al -> color
    ; di -> number of squares (4 - di)
    ; cx -> start col
    ; dx -> start row

row:
    ;mov al, whiteColor
    call drawSquare
    add cx, cellDimension
    SUB dx, cellDimension
    inc di
    ; draw 4 times
    cmp di, 4
    jnz row
    
    ret

drawRow    ENDP


drawGridOneColor    PROC    FAR

    ; * Draws 200 * 200 pixels grid
    ; ! Alot of registers is used in this proc

    ; Usage
    ; Better make pusha before proc and popa after
    ; cx -> start drawing
    
    ; TODO: specify the start positions

    ;mov cx, 0       ; Column
    mov dx, 0       ; Row
    mov di, 0       ; Num of squares
    mov bl, 0       ; Num of rows
    ;mov bh, 0       ; Parity

full:
    call drawRow
    add dx, cellDimension
    
    cmp bh, 0
    jnz shiftedSquares
    ; Four shifted sqaures
    mov cx, cellDimension
    mov di, 0
    inc bh      ; Switch to four sqaures next loop
    jmp normalSquares

shiftedSquares:
    ; Four shifted sqaures
    mov cx, 0
    mov di, 0
    dec bh      ; Switch to three sqaures next loop

normalSquares:
    inc bl
    cmp bl, 8
    jnz full

    ret

drawGridOneColor    ENDP

drawGrid    PROC    FAR   

    ; Graphics mode    
    mov ax, 4f02h
    mov bx, 0107h
    int 10h

    mov cx, cellDimension       ; Column
    mov al, 00h  ;First Board Color
    mov bh, 1
    call drawGridOneColor

    mov cx, 0       ; Column
    mov al, 08h     ;Sec. Board Color
    mov bh, 0
    call drawGridOneColor

    ret

drawGrid    ENDP



;-------------------------------------------End Fns Board--------------------------

;--------------------------------------------fn el q,m---------------------------
Al_to_color_to_delete_with  proc    far
    pusha;;;;;;;;;;;;
    call Set_Old_place_color_and_place
    popa
    mov al,color_to_delete_with
    ret
Al_to_color_to_delete_with endp 

ROW_COL_TO_Number   proc far

    ;dl->row el player ely byl3b ;cl->col el player ely byl3b 
    ;btrg3 fe el cell to be moved and ah el value ely gwa el morb3 dah fe array el grid

    mov dh,0
    ;mov dl,rowpl1  
    mov ch,0
    ;mov cl,colpl1
    MOV aX , 0 ;counter

    LOOP_Row:
    cmp dl,0
    JNE INC_8
    jmp skip_INC_8

    INC_8: ;add 8 le kol row
    add al,8d
    dec dl
    jmp LOOP_Row
    skip_INC_8:
    add al,cl ;add col  
    ;al feha mn 0->63 anhy box
    mov ah,0
    mov Cell_To_Be_Moved,al ;bastore el al(anhy box 0->63)  

    mov bx,offset grid
    add bx,ax
    mov ah,[bx] ;bhot fe el ax el value ely mawgoda fe el morb3 dah(ex:white pawn) 
    
    ret
ROW_COL_TO_Number endp

fill_Q_possible_moves_arr   proc    far   ;check

    ;dl->row cl->col
    pusha

    pusha
    call ROW_COL_TO_Number
    popa

    mov bx,0
    add bl,Cell_To_Be_Moved
    mov Q_possible_moves_arr[bx],1

    popa

    ret

fill_Q_possible_moves_arr endp

empty_q_possible_moves_arr      proc    far
    ;fn btsafr kol el array dah (Q_possible_moves_arr)
    ;fe haga msh mazbota fe el fn deh lma bcall it btbwaz el possible moves ely bttrsm

    pusha  
    mov bx,0
    mov cx,64 
    LOOP_Q_Arr_0:
    mov Q_possible_moves_arr [bx],0  
    inc bx
    dec cx
    JNZ LOOP_Q_Arr_0

    popa
    ret


empty_q_possible_moves_arr  endp

Draw_border_Pieces   proc   far   ;cx-> col dx->row  al->color  kill_1 -> 0 Kill_2 -> 0
    ;hya hya draw border bs bttcheck lw feh piece fe el mkan abl ma trsm lw feh mabtrsmsh
    ;bttcheck lw el el piece ely fe weshy deh lw lon 3aksy bt8yr lon el highlight we bt3ml 3aleha high mokhtlef
    ;lazem abl ma tcall tset el Kill_off -> 0 3shan ylwen el kill 3ady ->1 3shan yms7

    pusha
    call  ROW_COL_TO_Number ;ah feha el rakm ely mawgod fe el arry mn 0 -> 63
    mov Pieces_value,ah
    cmp ah,0 
    JNE There_is_a_Piece

    popa

    call Draw_border ;cx-> col dx->row  al->color
    mov drawed,1
    jmp Skip_kill

    There_is_a_Piece:
    ;;;;;;;
    popa

    cmp al,color_Highpl1 ;white pieces
    JE player_1

    cmp al,color_Highpl2 ;black pieces
    JE player_2

    player_1:
    cmp Pieces_value,10
    JA player_1_Kill
    jmp Same_Color_Piece
    player_1_Kill:


    cmp kill_1,0  ;3shan lw already 3amel 3la wahed highlight
    JNE Skip_kill
    add kill_1,1
    mov drawed,0 ;3shan myrsmsh b3dha
    ;condition 3shan yshof hyms7 wala la 3la hasab el kill_off
    cmp Kill_off,1
    JNE Kill_on 

    pusha;;;;;;;;;;;;
    call Set_Old_place_color_and_place
    popa
    mov al,color_to_delete_with
    call Draw_border
    jmp skip_kill_on

    Kill_on:
    mov al,color_Kill_Highpl1
    call Draw_border
    skip_kill_on:
    ;;
    ;mov drawed,2
    jmp Skip_kill

    player_2:
    cmp Pieces_value,10
    JB player_2_Kill
    jmp Same_Color_Piece
    player_2_Kill:


    cmp kill_2,0  ;3shan lw already 3amel 3la wahed highlight   
    JNE Skip_kill
    add kill_2,1
    mov drawed,0 ;3shan myrsmsh b3dha


   ;condition 3shan yshof hyms7 wala la 3la hasab el kill_off
    cmp Kill_off,1
    JNE Kill_on2 

    pusha;;;;;;;;;;;;
    call Set_Old_place_color_and_place
    popa
    mov al,color_to_delete_with
    call Draw_border
    jmp skip_kill_on2

    Kill_on2:
    mov al,color_Kill_Highpl2
    call Draw_border
    skip_kill_on2:
    ;;

    ;mov drawed,2
    jmp Skip_kill

    Same_Color_Piece:
    ;;;;;;;;;;;;
    mov drawed,0   


    Skip_kill:

    ret
Draw_border_Pieces endp

Draw_border_soldier proc far   ;cx-> col dx->row  al->color
    ;3shan el soldier bykill bel ganb fa el fn bta3t pieces feha el kill

    pusha
    call  ROW_COL_TO_Number 
    cmp ah,0 
    JNE SKIP_There_is_a_Piece
    

    popa
    call Draw_border ;cx-> col dx->row  al->color
    ; mov drawed,1
    jmp Skip_pop

    SKIP_There_is_a_Piece:
    ; mov drawed,0
    popa


    Skip_pop:


ret
Draw_border_soldier endp

Possible_Moves_Soldier proc far
    ;dl->row el player ely byl3b ;cl->col el player ely byl3b 
    ;lw player 1 di -> 1 , bp -> 1  ;di el harka le odam wala wara
    ;lw player 2 di -> -1, bp -> 6  ;condition ymove marten dah 3la anhy row
    ;mov al,color_highpl1 or color_Highpl2

    pusha
    ;mov al,rowpl1 ;dx feha row 
    mov dh,0
    ;mov bl,colpl1 ;cx feha col
    mov ch,0

    cmp dx,bp
    JE JMPEN_FIRST_ROW
    mov si,1

    LOOP_SOL_WHITE_HIGH:
    ;inc dx  ;;;;;;;;;;;;
    add dx,di

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr1
    cmp cl,7
    JA Out_Gr1
    cmp dl,0
    JB Out_Gr1
    cmp cl,0
    JB Out_Gr1                

    call Draw_border_soldier
    Out_Gr1:
    cmp Drawed,0 ;condition lw marsmsh wahda 3shan fe piece myrsmsh b3dha
    JE SKIP_Q2 ;3shan el 3askry lw awel cell matrsmtsh tany cell bardo el mafrod mattrsmsh

    dec si
    cmp si,0
    JE SKIP_Q2
    jmp LOOP_SOL_WHITE_HIGH

    JMPEN_FIRST_ROW:
    mov si,2
    jmp LOOP_SOL_WHITE_HIGH
    SKIP_Q2:

    popa ;bapush we apop 3shan arg3 values el row we el col

    ;--------------------part el kill bta3 el soldier
    cmp al,color_Highpl1
    JE player_11
    jmp player_22

    player_11:
    inc dl  
    dec cl

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr2
    cmp cl,7
    JA Out_Gr2
    cmp dl,0
    JB Out_Gr2
    cmp cl,0
    JB Out_Gr2   

    pusha
    call ROW_COL_TO_Number ;babos 3la taht shmal
    mov Pieces_value,ah
    popa
    cmp Pieces_value,10
    JA KILL_Player_11
    jmp check_2_player_11

    KILL_Player_11:
    mov al,color_Kill_Highpl1
    call Draw_border    

    check_2_player_11: ;babos 3la taht ymen
    Out_Gr2:
    add cl,2

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr3
    cmp cl,7
    JA Out_Gr3
    cmp dl,0
    JB Out_Gr3
    cmp cl,0
    JB Out_Gr3 

    jmp SSKIP
    Out_Gr3: ;max jmp
    jmp skip_player22 
    SSKIP:

    pusha
    call ROW_COL_TO_Number
    mov Pieces_value,ah
    popa
    cmp Pieces_value,10
    JA KILL_Player_111
    jmp skip_player22
    KILL_Player_111:
    mov al,color_Kill_Highpl1
    call Draw_border


    jmp skip_player22

    player_22:
    dec dl 
    dec cl

    cmp dl,7   ;3shan mykonsh el mkan bara el grid
    JA Out_Gr5
    cmp cl,7
    JA Out_Gr5
    cmp dl,0
    JB Out_Gr5
    cmp cl,0
    JB Out_Gr5

    pusha
    call ROW_COL_TO_Number ;babos 3la fo2 shmal
    mov Pieces_value,ah
    popa
    cmp Pieces_value,0  ;check enha msh fadya 3shan fe pl2 bashof lw below 10 fa momken tb2a b0
    JE check_2_player_22
    cmp Pieces_value,10
    JB KILL_Player_22
    jmp check_2_player_22

    KILL_Player_22:
    mov al,color_Kill_Highpl2
    call Draw_border

    Out_Gr5:
    check_2_player_22: ;babos 3la fo2 ymen
    add cl,2

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr4
    cmp cl,7
    JA Out_Gr4
    cmp dl,0
    JB Out_Gr4
    cmp cl,0
    JB Out_Gr4 

    pusha
    call ROW_COL_TO_Number
    mov Pieces_value,ah
    popa
    cmp Pieces_value,0  ;check enha msh fadya 3shan fe pl2 bashof lw below 10 fa momken tb2a b0
    JE skip_player22
    cmp Pieces_value,10
    JB KILL_Player_222
    jmp skip_player22
    KILL_Player_222:
    mov al,color_Kill_Highpl2
    call Draw_border

    ;Out_Gr3:
    Out_Gr4:
    skip_player22:


    ret
Possible_Moves_Soldier endp

delete_Possible_Moves_Soldier     proc        far
    ;dl->row el player ely byl3b ;cl->col el player ely byl3b 

    ;lw player 1 di -> 1 , bp -> 1  ;di el harka le odam wala wara
    ;lw player 2 di -> -1, bp -> 6  ;condition ymove marten dah 3la anhy row
    ;delete_which_soldier ->0 lw white ->1 lw black

    pusha ;3shan ma8yrsh haga lma arg3


    pusha
    ;mov al,rowpl1 ;dx feha row 
    mov dh,0
    ;mov bl,colpl1 ;cx feha col
    mov ch,0

    cmp dx,bp
    JE JMPEN_FIRST_ROW_d
    mov si,1

    LOOP_SOL_WHITE_HIGH_d:
    ;inc dx  ;;;;;;;;;;;;
    add dx,di

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr1_d
    cmp cl,7
    JA Out_Gr1_d
    cmp dl,0
    JB Out_Gr1_d
    cmp cl,0
    JB Out_Gr1_d  

    call Al_to_color_to_delete_with               

    call Draw_border ;;
    Out_Gr1_d:
    

    dec si
    cmp si,0
    JE SKIP_Q2_d
    jmp LOOP_SOL_WHITE_HIGH_d

    JMPEN_FIRST_ROW_d:
    mov si,2
    jmp LOOP_SOL_WHITE_HIGH_d
    SKIP_Q2_d:

    popa ;bapush we apop 3shan arg3 values el row we el col

    ;--------------------part delete el kill bta3 el soldier
    ;pusha

    mov dh,0 ;3shan draw border btst3mel el dx we el cx kolhom
    mov ch,0

    cmp di,1
    JE player_11_d
    jmp player_22_d

 

    player_11_d:
    inc dl  
    dec cl

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr2_d
    cmp cl,7
    JA Out_Gr2_d
    cmp dl,0
    JB Out_Gr2_d
    cmp cl,0
    JB Out_Gr2_d   

    call Al_to_color_to_delete_with    

    ;check_2_player_11_d: ;babos 3la taht ymen
    Out_Gr2_d:
    add cl,2

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr3_d
    cmp cl,7
    JA Out_Gr3_d
    cmp dl,0
    JB Out_Gr3_d
    cmp cl,0
    JB Out_Gr3_d 

    call Al_to_color_to_delete_with    

    Out_Gr3_d:


    jmp skip_player22_d

    player_22_d:
    dec dl 
    dec cl

    cmp dl,7   ;3shan mykonsh el mkan bara el grid
    JA Out_Gr5_d
    cmp cl,7
    JA Out_Gr5_d
    cmp dl,0
    JB Out_Gr5_d
    cmp cl,0
    JB Out_Gr5_d

    call Al_to_color_to_delete_with    

    Out_Gr5_d:

    add cl,2

    cmp dl,7  ;3shan mykonsh el mkan bara el grid
    JA Out_Gr4_d
    cmp cl,7
    JA Out_Gr4_d
    cmp dl,0
    JB Out_Gr4_d
    cmp cl,0
    JB Out_Gr4_d 

    call Al_to_color_to_delete_with    


    Out_Gr4_d:
    skip_player22_d:

    popa


    ret
delete_Possible_Moves_Soldier endp

Possible_Moves_ROOK proc far
    ;dl->rowpl, cl -> col el ply  ;mov al,color_highpl1 or color_Highpl2
    
    mov dh,0 ;dx feha row
    mov ch,0 ;cx feha col
    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    pusha

    pusha
    LOOP_ROOK_1: ;byrsm le taht
    add dx,1

    cmp dl,7
    JA Out_Gri1
    cmp cl,7
    JA Out_Gri1
    cmp dl,0
    JB Out_Gri1
    cmp cl,0
    JB Out_Gri1

    cmp drawed,0   ;bashof lw w2ft 3shan fe piece fe el tare2 nafs lony
    JE SKip_Draw_ROOk_High
    mov Kill_off,0
    call Draw_border_Pieces
    SKip_Draw_ROOk_High:


    Jmp LOOP_ROOK_1
    Out_Gri1:
    popa

    mov drawed,3
    mov kill_1,0
    mov kill_2,0
    ;;;;;;;;;;;;;;;;;;

    pusha
    LOOP_ROOK_2:
    sub dx,1   ;byrsm le fo2

    cmp dl,7
    JA Out_Gri2
    cmp cl,7
    JA Out_Gri2
    cmp dl,0
    JB Out_Gri2
    cmp cl,0
    JB Out_Gri2

    cmp drawed,0
    JE SKip_Draw_ROOk_High2
    mov Kill_off,0
    call Draw_border_Pieces
    SKip_Draw_ROOk_High2:


    Jmp LOOP_ROOK_2
    Out_Gri2:
    popa

    mov drawed,3
    mov kill_1,0
    mov kill_2,0    

    pusha
    LOOP_ROOK_3:
    add cx,1   ;byrsm lel ymen

    cmp dl,7
    JA Out_Gri3
    cmp cl,7
    JA Out_Gri3
    cmp dl,0
    JB Out_Gri3
    cmp cl,0
    JB Out_Gri3

    cmp drawed,0
    JE SKip_Draw_ROOk_High3
    mov Kill_off,0
    call Draw_border_Pieces
    SKip_Draw_ROOk_High3:


    Jmp LOOP_ROOK_3
    Out_Gri3:
    popa

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    pusha
    LOOP_ROOK_4:  ;byrsm lel shmal
    sub cx,1

    cmp dl,7
    JA Out_Gri4
    cmp cl,7
    JA Out_Gri4
    cmp dl,0
    JB Out_Gri4
    cmp cl,0
    JB Out_Gri4

    cmp drawed,0
    JE SKip_Draw_ROOk_High4 
    mov Kill_off,0   
    call Draw_border_Pieces
    SKip_Draw_ROOk_High4:


    Jmp LOOP_ROOK_4
    Out_Gri4:
    popa


    popa
    ret
Possible_Moves_ROOK  endp 

delete_Possible_Moves_ROOK  PROC    FAR
    ;dl->rowpl, cl -> col el ply  ;
    
    mov dh,0 ;dx feha row
    mov ch,0 ;cx feha col
    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    pusha

    pusha
    LOOP_ROOK_1_d: ;byrsm le taht
    add dx,1

    cmp dl,7
    JA Out_Gri1_d
    cmp cl,7
    JA Out_Gri1_d
    cmp dl,0
    JB Out_Gri1_d
    cmp cl,0
    JB Out_Gri1_d

    cmp drawed,0   ;bashof lw w2ft 3shan fe piece fe el tare2 nafs lony
    JE SKip_Draw_ROOk_High_d

    call Al_to_color_to_delete_with    
    mov Kill_off,1
    call Draw_border_Pieces
    SKip_Draw_ROOk_High_d:


    Jmp LOOP_ROOK_1_d
    Out_Gri1_d:
    popa

    mov drawed,3
    mov kill_1,0
    mov kill_2,0
    ;;;;;;;;;;;;;;;;;;

    pusha
    LOOP_ROOK_2_d:
    sub dx,1   ;byrsm le fo2

    cmp dl,7
    JA Out_Gri2_d
    cmp cl,7
    JA Out_Gri2_d
    cmp dl,0
    JB Out_Gri2_d
    cmp cl,0
    JB Out_Gri2_d

    cmp drawed,0
    JE SKip_Draw_ROOk_High2_d

    call Al_to_color_to_delete_with    
    mov Kill_off,1
    call Draw_border_Pieces
    SKip_Draw_ROOk_High2_d:


    Jmp LOOP_ROOK_2_d
    Out_Gri2_d:
    popa

    mov drawed,3
    mov kill_1,0
    mov kill_2,0    

    pusha
    LOOP_ROOK_3_d:
    add cx,1   ;byrsm lel ymen

    cmp dl,7
    JA Out_Gri3_d
    cmp cl,7
    JA Out_Gri3_d
    cmp dl,0
    JB Out_Gri3_d
    cmp cl,0
    JB Out_Gri3_d

    cmp drawed,0
    JE SKip_Draw_ROOk_High3_d

    call Al_to_color_to_delete_with    
    mov Kill_off,1
    call Draw_border_Pieces
    SKip_Draw_ROOk_High3_d:


    Jmp LOOP_ROOK_3_d
    Out_Gri3_d:
    popa

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    pusha
    LOOP_ROOK_4_d:  ;byrsm lel shmal
    sub cx,1

    cmp dl,7
    JA Out_Gri4_d
    cmp cl,7
    JA Out_Gri4_d
    cmp dl,0
    JB Out_Gri4_d
    cmp cl,0
    JB Out_Gri4_d

    cmp drawed,0
    JE SKip_Draw_ROOk_High4_d

    call Al_to_color_to_delete_with    
    mov Kill_off,1
    call Draw_border_Pieces
    SKip_Draw_ROOk_High4_d:


    Jmp LOOP_ROOK_4_d
    Out_Gri4_d:
    popa


    popa

    RET
delete_Possible_Moves_ROOK ENDP

Possible_Moves_Horse proc far
;cl -> col el pl
;dl -> row el pl
;mov al,color_highpl1 or color_Highpl2

    mov dh,0
    mov ch,0
    mov kill_1,0 ;3shan zy el king khatwato kolha momken tb2a high kill 3shan hwa msh bykmel zy el tabya
    mov kill_2,0


    pusha
    add cl,1
    add dl,2
    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid1
    cmp cl,7
    JA Out_Grid1
    cmp dl,0
    JB Out_Grid1
    cmp cl,0
    JB Out_Grid1
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid1:
    popa


    mov kill_1,0  
    mov kill_2,0
    pusha
    add cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid2
    cmp cl,7
    JA Out_Grid2
    cmp dl,0
    JB Out_Grid2
    cmp cl,0
    JB Out_Grid2
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid2:
    popa

    mov kill_1,0  
    mov kill_2,0
    pusha
    sub cl,1
    add dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid3
    cmp cl,7
    JA Out_Grid3
    cmp dl,0
    JB Out_Grid3
    cmp cl,0
    JB Out_Grid3
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid3:
    popa

    mov kill_1,0  
    mov kill_2,0

    pusha
    sub cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid4
    cmp cl,7
    JA Out_Grid4
    cmp dl,0
    JB Out_Grid4
    cmp cl,0
    JB Out_Grid4
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid4:
    popa

    mov kill_1,0  
    mov kill_2,0
    pusha
    sub cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid5
    cmp cl,7
    JA Out_Grid5
    cmp dl,0
    JB Out_Grid5
    cmp cl,0
    JB Out_Grid5
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid5:
    popa

    mov kill_1,0  
    mov kill_2,0
    pusha
    sub cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid6
    cmp cl,7
    JA Out_Grid6
    cmp dl,0
    JB Out_Grid6
    cmp cl,0
    JB Out_Grid6
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid6:
    popa

    mov kill_1,0  
    mov kill_2,0   
    pusha
    add cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid7
    cmp cl,7
    JA Out_Grid7
    cmp dl,0
    JB Out_Grid7
    cmp cl,0
    JB Out_Grid7
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid7:
    popa

    mov kill_1,0  
    mov kill_2,0    
    pusha
    add cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid8
    cmp cl,7
    JA Out_Grid8
    cmp dl,0
    JB Out_Grid8
    cmp cl,0
    JB Out_Grid8
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid8:
    popa

    ret
Possible_Moves_Horse endp

delete_Possible_Moves_Horse proc    far
    ;cl -> col 
    ;dl -> row 



    mov dh,0
    mov ch,0
    mov kill_1,0 ;3shan zy el king khatwato kolha momken tb2a high kill 3shan hwa msh bykmel zy el tabya
    mov kill_2,0


    pusha
    add cl,1
    add dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid1_d
    cmp cl,7
    JA Out_Grid1_d
    cmp dl,0
    JB Out_Grid1_d
    cmp cl,0
    JB Out_Grid1_d
    mov Kill_off,1
    call Al_to_color_to_delete_with    
    call Draw_border_Pieces
    Out_Grid1_d:
    popa


    mov kill_1,0  
    mov kill_2,0
    pusha
    add cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid2_d
    cmp cl,7
    JA Out_Grid2_d
    cmp dl,0
    JB Out_Grid2_d
    cmp cl,0
    JB Out_Grid2_d
    mov Kill_off,1
    call Al_to_color_to_delete_with    
    call Draw_border_Pieces
    Out_Grid2_d:
    popa

    mov kill_1,0  
    mov kill_2,0
    pusha
    sub cl,1
    add dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid3_d
    cmp cl,7
    JA Out_Grid3_d
    cmp dl,0
    JB Out_Grid3_d
    cmp cl,0
    JB Out_Grid3_d
    mov Kill_off,1
    call Al_to_color_to_delete_with    
    call Draw_border_Pieces
    Out_Grid3_d:
    popa

    mov kill_1,0  
    mov kill_2,0

    pusha
    sub cl,2
    add dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid4_d
    cmp cl,7
    JA Out_Grid4_d
    cmp dl,0
    JB Out_Grid4_d
    cmp cl,0
    JB Out_Grid4_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid4_d:
    popa

    mov kill_1,0  
    mov kill_2,0
    pusha
    sub cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid5_d
    cmp cl,7
    JA Out_Grid5_d
    cmp dl,0
    JB Out_Grid5_d
    cmp cl,0
    JB Out_Grid5_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid5_d:
    popa

    mov kill_1,0  
    mov kill_2,0
    pusha
    sub cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid6_d
    cmp cl,7
    JA Out_Grid6_d
    cmp dl,0
    JB Out_Grid6_d
    cmp cl,0
    JB Out_Grid6_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid6_d:
    popa

    mov kill_1,0  
    mov kill_2,0   
    pusha
    add cl,1
    sub dl,2

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid7_d
    cmp cl,7
    JA Out_Grid7_d
    cmp dl,0
    JB Out_Grid7_d
    cmp cl,0
    JB Out_Grid7_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid7_d:
    popa

    mov kill_1,0  
    mov kill_2,0    
    pusha
    add cl,2
    sub dl,1

    ;batcheck el awel eno msh bara el grid
    cmp dl,7
    JA Out_Grid8_d
    cmp cl,7
    JA Out_Grid8_d
    cmp dl,0
    JB Out_Grid8_d
    cmp cl,0
    JB Out_Grid8_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid8_d:
    popa

    ret


delete_Possible_Moves_Horse endp

Possible_Moves_Elephant proc  far
    ;dl->row ;cl-> col ;al -> color 
    pusha
    mov dh,0
    mov ch,0
    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    pusha
    LOOP_Elephant_1:
    add dx,1
    add cx,1

    cmp dl,7
    JA Out_Grid9
    cmp cl,7
    JA Out_Grid9
    cmp dl,0
    JB Out_Grid9
    cmp cl,0
    JB Out_Grid9

    CMP Drawed,0  ;3shan mykmlsh lw la2a piece nafs lono
    je Out_Grid9
    mov Kill_off,0
    call Draw_border_Pieces


    Jmp LOOP_Elephant_1
    Out_Grid9:
    popa


    pusha

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    LOOP_Elephant_2:
    add dx,1
    sub cx,1

    cmp dl,7
    JA Out_Grid10
    cmp cl,7
    JA Out_Grid10
    cmp dl,0
    JB Out_Grid10
    cmp cl,0
    JB Out_Grid10

    CMP Drawed,0
    je Out_Grid10
    mov Kill_off,0
    call Draw_border_Pieces


    Jmp LOOP_Elephant_2
    Out_Grid10:
    popa


    pusha

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    LOOP_Elephant_3:
    sub dx,1
    sub cx,1

    cmp dl,7
    JA Out_Grid11
    cmp cl,7
    JA Out_Grid11
    cmp dl,0
    JB Out_Grid11
    cmp cl,0
    JB Out_Grid11

    CMP Drawed,0
    je Out_Grid11
    mov Kill_off,0
    call Draw_border_Pieces


    Jmp LOOP_Elephant_3
    Out_Grid11:
    popa



    pusha

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    LOOP_Elephant_4:
    sub dx,1
    add cx,1

    cmp dl,7
    JA Out_Grid12
    cmp cl,7
    JA Out_Grid12
    cmp dl,0
    JB Out_Grid12
    cmp cl,0
    JB Out_Grid12

    CMP Drawed,0
    je Out_Grid12
    mov Kill_off,0
    call Draw_border_Pieces


    Jmp LOOP_Elephant_4
    Out_Grid12:
    popa


    popa

    ret
Possible_Moves_Elephant endp

delete_Possible_Moves_Elephant  proc    far
    ;dl->row ;cl-> col 
    pusha
    mov dh,0
    mov ch,0
    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    pusha
    LOOP_Elephant_1_d:
    add dx,1
    add cx,1

    cmp dl,7
    JA Out_Grid9_d
    cmp cl,7
    JA Out_Grid9_d
    cmp dl,0
    JB Out_Grid9_d
    cmp cl,0
    JB Out_Grid9_d

    CMP Drawed,0  ;3shan mykmlsh lw la2a piece nafs lono
    je Out_Grid9_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces


    Jmp LOOP_Elephant_1_d
    Out_Grid9_d:
    popa


    pusha

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    LOOP_Elephant_2_d:
    add dx,1
    sub cx,1

    cmp dl,7
    JA Out_Grid10_d
    cmp cl,7
    JA Out_Grid10_d
    cmp dl,0
    JB Out_Grid10_d
    cmp cl,0
    JB Out_Grid10_d

    CMP Drawed,0
    je Out_Grid10_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces


    Jmp LOOP_Elephant_2_d
    Out_Grid10_d:
    popa


    pusha

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    LOOP_Elephant_3_d:
    sub dx,1
    sub cx,1

    cmp dl,7
    JA Out_Grid11_d
    cmp cl,7
    JA Out_Grid11_d
    cmp dl,0
    JB Out_Grid11_d
    cmp cl,0
    JB Out_Grid11_d

    CMP Drawed,0
    je Out_Grid11_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces


    Jmp LOOP_Elephant_3_d
    Out_Grid11_d:
    popa

    pusha

    mov drawed,3
    mov kill_1,0
    mov kill_2,0

    LOOP_Elephant_4_d:
    sub dx,1
    add cx,1

    cmp dl,7
    JA Out_Grid12_d
    cmp cl,7
    JA Out_Grid12_d
    cmp dl,0
    JB Out_Grid12_d
    cmp cl,0
    JB Out_Grid12_d

    CMP Drawed,0
    je Out_Grid12_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces


    Jmp LOOP_Elephant_4_d
    Out_Grid12_d:
    popa

    popa

    ret

delete_Possible_Moves_Elephant  endp

possible_Moves_King      proc    far
    ;dl->row ;cl-> col ;al -> color 
    mov ch,0
    mov dh,0
    mov kill_1,0  ;3shan el king momken yhigh kaza mara wara b3d 3ady
    mov kill_2,0

    pusha    ;3shan arsm el 3 ely fo2
    sub dl,1
    sub cl,1

    mov ah,3;counter
    loop_King:

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid13
    cmp cl,7
    JA Out_Grid13
    cmp dl,0
    JB Out_Grid13
    cmp cl,0
    JB Out_Grid13
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid13:

    add cl,1
    dec ah ;yloop 3 marat
    cmp ah,0
    JNE loop_King
    popa
    
; ;;;;;;;;;;;;;;;;;;;
    pusha    ;3shan arsm el 3 ely taht
    dec cl
    inc dl

    mov ah,3;counter
    loop_King_2:

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid14
    cmp cl,7
    JA Out_Grid14
    cmp dl,0
    JB Out_Grid14
    cmp cl,0
    JB Out_Grid14
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid14:

    inc cl
    dec ah ;yloop 3 marat
    cmp ah,0
    JNE loop_King_2
    popa


    dec cl      ;3shan arsm shmalo

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid15
    cmp cl,7
    JA Out_Grid15
    cmp dl,0
    JB Out_Grid15
    cmp cl,0
    JB Out_Grid15
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid15:


    add cl,2 ;3shan arsm ymeno badd 2 3shan already mna2so mara we ana barsm shmal

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid16
    cmp cl,7
    JA Out_Grid16
    cmp dl,0
    JB Out_Grid16
    cmp cl,0
    JB Out_Grid16
    mov Kill_off,0
    call Draw_border_Pieces
    Out_Grid16:
    

    ret
possible_Moves_King endp

delete_Possible_Moves_King      proc    far
    ;dl->row ;cl-> col 
    mov ch,0
    mov dh,0
    mov kill_1,0  ;3shan el king momken yhigh kaza mara wara b3d 3ady
    mov kill_2,0

    pusha    ;3shan arsm el 3 ely fo2
    sub dl,1
    sub cl,1

    mov ah,3;counter
    loop_King_d:

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid13_d
    cmp cl,7
    JA Out_Grid13_d
    cmp dl,0
    JB Out_Grid13_d
    cmp cl,0
    JB Out_Grid13_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid13_d:

    add cl,1
    dec ah ;yloop 3 marat
    cmp ah,0
    JNE loop_King_d
    popa
    
    ; ;;;;;;;;;;;;;;;;;;;
    pusha    ;3shan arsm el 3 ely taht
    dec cl
    inc dl

    mov ah,3;counter
    loop_King_2_d:

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid14_d
    cmp cl,7
    JA Out_Grid14_d
    cmp dl,0
    JB Out_Grid14_d
    cmp cl,0
    JB Out_Grid14_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid14_d:

    inc cl
    dec ah ;yloop 3 marat
    cmp ah,0
    JNE loop_King_2_d
    popa


    dec cl      ;3shan arsm shmalo

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid15_d
    cmp cl,7
    JA Out_Grid15_d
    cmp dl,0
    JB Out_Grid15_d
    cmp cl,0
    JB Out_Grid15_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid15_d:


    add cl,2 ;3shan arsm ymeno badd 2 3shan already mna2so mara we ana barsm shmal

    mov kill_1,0
    mov kill_2,0

    cmp dl,7
    JA Out_Grid16_d
    cmp cl,7
    JA Out_Grid16_d
    cmp dl,0
    JB Out_Grid16_d
    cmp cl,0
    JB Out_Grid16_d
    mov Kill_off,1
    call Al_to_color_to_delete_with
    call Draw_border_Pieces
    Out_Grid16_d:
    
    ret


delete_Possible_Moves_King  endp

Possible_Moves_Queen    proc    far
    ;dl->row ;cl-> col  
    call Possible_Moves_Elephant
    call Possible_Moves_ROOK

    ret
Possible_Moves_Queen  endp

delete_Possible_Moves_Queen     proc    far
    ;dl->row ;cl-> col 
    call delete_Possible_Moves_Elephant
    call delete_Possible_Moves_ROOK
    ret
delete_Possible_Moves_Queen endp


delete_all_q_possible_moves     proc    far
    ;el fn deh btms7 ay white piece kan marsomlha el possible moves bta3etha
    pusha

    mov dl,0 ;starting point
    mov cl,0
    mov Q_pressed_on_what,0 ;msh lazem i guess

    ;3shan asfar array el possible moves el awel /zawed el hta deh 3nd el M
    call empty_q_possible_moves_arr   ;fe haga 8alt fe el fn
 

    loop_array: ;hylf 3la kol box


        ;lma el cl twsl lel akher hysfrha we ynzel row
        cmp cl,8  ;8 3shan ykhsoh bel 7
        jNE skip_Max_COL
        mov cl,0
        inc dl
        skip_Max_COL:

        pusha
        call  ROW_COL_TO_Number  ;pieces_value-> el rakm ely gwa el array ely gwa el box (0->63)
        mov Pieces_value,ah
        popa  
        ;soldier
        cmp Pieces_value,White_Soldier
        JNE SkipDeltposiblmoveswhitesold

        mov bp,1
        mov di,1
        call delete_Possible_Moves_Soldier  
        
        SkipDeltposiblmoveswhitesold:
        ;rook
        cmp Pieces_value,White_Rook
        JNE SkipDeltepossiblemovesWhRook

        call delete_Possible_Moves_ROOK
        SkipDeltepossiblemovesWhRook:
        ;horse
        cmp Pieces_value,White_Horse
        JNE SkipDeltepossiblemovesWhHorse

        call delete_Possible_Moves_Horse
        SkipDeltepossiblemovesWhHorse:
        ;Elephant
        cmp Pieces_value,White_Elephant
        JNE SkipDeltepossiblemovesWElephant

        call delete_Possible_Moves_Elephant
        SkipDeltepossiblemovesWElephant:
        ;King
        cmp Pieces_value,White_King
        JNE SkipDeltepossiblemovesWhKing

        call delete_Possible_Moves_King
        SkipDeltepossiblemovesWhKing:
        ;queen
        cmp Pieces_value,White_Queen
        JNE SkipDeltpossiblemovesWhQueen

        call delete_Possible_Moves_Queen
        SkipDeltpossiblemovesWhQueen:
    
    inc cl
    ;3shan y2of lma ylf 3la el array kolo
    cmp dl,7
    JNE loop_array
    cmp cl,7
    jNE loop_array

    popa


    ret
delete_all_q_possible_moves endp

delete_all_m_possible_moves     proc    far

    ;el fn deh btms7 ay black piece kan marsomlha el possible moves bta3etha
    pusha

    mov dl,0 ;starting point
    mov cl,0
    mov M_pressed_on_what,0 ;msh lazem i guess

    loop_array_M: ;hylf 3la kol box

        ;lma el cl twsl lel akher hysfrha we ynzel row
        cmp cl,8  ;8 3shan ykhsoh bel 7
        jNE skip_Max_COL_M
        mov cl,0
        inc dl
        skip_Max_COL_M:

        pusha
        call  ROW_COL_TO_Number  ;pieces_value-> el rakm ely gwa el array ely gwa el box (0->63)
        mov Pieces_value,ah
        popa  
        ;soldier
        cmp Pieces_value,Black_Pawm
        JNE SkipDeltepossiblemovesBsoldier

        mov bp,-1
        mov di,6
        call delete_Possible_Moves_Soldier  
        
        SkipDeltepossiblemovesBsoldier:
        ;rook
        cmp Pieces_value,Black_Rook
        JNE SkipDeltepossiblemovesBRook

        call delete_Possible_Moves_ROOK
        SkipDeltepossiblemovesBRook:
        ;horse
        cmp Pieces_value,Black_Knight
        JNE SkipDeltepossiblemovesBHorse

        call delete_Possible_Moves_Horse
        SkipDeltepossiblemovesBHorse:
        ;Elephant
        cmp Pieces_value,Black_Bishop
        JNE SkipDeltepossiblemovesBElephant

        call delete_Possible_Moves_Elephant
        SkipDeltepossiblemovesBElephant:
        ;King
        cmp Pieces_value,Black_King
        JNE SkipDeltepossiblemovesBKing

        call delete_Possible_Moves_King
        SkipDeltepossiblemovesBKing:
        ;queen
        cmp Pieces_value,Black_Queen
        JNE SkipDeltepossiblemovesBQueen

        call delete_Possible_Moves_Queen
        SkipDeltepossiblemovesBQueen:
    
    inc cl
    ;3shan y2of lma ylf 3la el array kolo
    cmp dl,7
    JNE loop_array_M
    cmp cl,7
    jNE loop_array_M

    popa

    ret

delete_all_m_possible_moves endp

Q_Possible_Moves    proc    far  
    ;when q is pressed it checks what pieces is on it and acts accordingly

    pusha
    ;vars btt3rf abl el fn maktoba fe el fn definition (ROW_COL_To_Number)
    mov dl,rowpl1;row  
    mov cl,colpl1;col
    call  ROW_COL_TO_Number  ;btrg3ly fe el ah ely value ely gwa el morb3
    ;;;;;;;;;;;;;;;;;;;;;
 
    cmp ah,White_Soldier ;lw el tl3 white soldier
    JE White_Soldier_Q
    jmp SKIP_White_Solider

    White_Soldier_Q:
    ;vars btt3rf abl el fn maktoba fe el fn definition (Possible_Moves_Soldier)
    call delete_all_q_possible_moves ;3shan ams7 kol el possible moves bta3 ay piece tanya kant marsoma
    mov bp,1
    mov di,1
    mov al,color_Highpl1
    mov dl,rowpl1
    mov cl,colpl1
    mov Q_row,dl ;bastore el el col we el row lma dost q
    mov Q_col,cl
    call Possible_Moves_Soldier
    mov Q_pressed_on_what,White_Soldier

    SKIP_White_Solider:
    
    cmp ah,White_Rook
    JE White_ROOK_Q
    jmp SKIP_White_ROOK

    White_ROOK_Q:    ;FIX -> ROOK moshkelto el high mabytl3sh fo2 el player el tany
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    call delete_all_q_possible_moves
    mov dl,rowpl1
    mov cl,colpl1
    mov al,color_Highpl1
    mov Q_row,dl ;bastore el el col we el row lma dost q
    mov Q_col,cl
    call Possible_Moves_ROOK
    mov Q_pressed_on_what,White_Rook

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    SKIP_White_ROOK:

    cmp ah,White_Horse
    JE WHITE_HORSE_Q
    JMP SKip_White_Horse

    WHITE_HORSE_Q:
    call delete_all_q_possible_moves
    mov dl,rowpl1
    mov cl,colpl1
    mov al,color_Highpl1;color of high
    mov Q_row,dl ;bastore el el col we el row lma dost q
    mov Q_col,cl
    call Possible_Moves_Horse
    mov Q_pressed_on_what,White_Horse

    SKip_White_Horse:

    cmp ah,White_Elephant
    JE White_Elephant_Q
    jmp SKip_White_Elephant

    White_Elephant_Q:
    call delete_all_q_possible_moves
    mov dl,rowpl1
    mov cl,colpl1
    mov al,color_Highpl1;color of high
    mov Q_row,dl ;bastore el el col we el row lma dost q
    mov Q_col,cl
    call Possible_Moves_Elephant
    mov Q_pressed_on_what,White_Elephant

    SKip_White_Elephant:

    cmp ah,White_King
    JE WHite_King_Q
    jmp SKip_White_King

    WHite_King_Q:
    call delete_all_q_possible_moves
    mov dl,rowpl1
    mov cl,colpl1
    mov al,color_Highpl1
    mov Q_row,dl ;bastore el el col we el row lma dost q
    mov Q_col,cl
    call possible_Moves_King
    mov Q_pressed_on_what,White_King

    SKip_White_King:

    cmp ah,White_Queen
    JE White_Queen_Q
    jmp Skip_White_Queen

    White_Queen_Q:
    call delete_all_q_possible_moves
    mov dl,rowpl1
    mov cl,colpl1
    mov al,color_Highpl1
    mov Q_row,dl ;bastore el el col we el row lma dost q
    mov Q_col,cl
    call Possible_Moves_Queen
    mov Q_pressed_on_what,White_Queen

    Skip_White_Queen:

    cmp ah,0
    JE NOTHING_IS_THERE
    jmp SKIP_NOTHING
    NOTHING_IS_THERE:  ;fadel htet lw das 3la possible move fa y8yr mkano fe el array
    call delete_all_q_possible_moves ;we kman lw das 3la high el kill
    mov Q_pressed_on_what,0
    SKIP_NOTHING:


     
    popa

    ret
Q_Possible_Moves endp

Check_q_Input   PROC    FAR
    
    cmp al,71h ;sheck if input is q (pl1)(WASD)
    JNE skip_q  
    call Q_Possible_Moves
    skip_q:

    RET
Check_q_Input ENDP

M_Possible_Moves    proc    far
    ;when q is pressed it checks what pieces is on it and acts accordingly
    
    pusha
    ;vars btt3rf abl el fn maktoba fe el fn definition (ROW_COL_To_Number)
    mov dl,rowpl2  
    mov cl,colpl2
    call  ROW_COL_TO_Number ;btrg3 el ah feha el value bta3 el morb3 ely el player wa2ef 3aleh 
    ;;;;;;;;;;;;;;;;;;;;;
 

    cmp ah,Black_Pawm ;lw el tl3 white soldier
    JE Black_Soldier_M
    jmp SKIP_Black_Solider

    Black_Soldier_M:
    ;vars btt3rf abl el fn maktoba fe el fn definition (Possible_Moves_Soldier)
    call delete_all_m_possible_moves
    mov bp, 6
    mov di,-1
    mov dl,rowpl2
    mov cl,colpl2
    mov al,Color_Highpl2
    mov M_col,cl
    mov M_row,dl
    call Possible_Moves_Soldier
    mov M_pressed_on_what,Black_Pawm

    SKIP_Black_Solider:

    cmp ah,Black_Rook
    JE Black_ROOK_M
    jmp SKIP_Black_ROOK

    Black_ROOK_M:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    call delete_all_m_possible_moves
    mov dl,rowpl2
    mov cl,colpl2
    mov al,Color_Highpl2
    mov M_col,cl
    mov M_row,dl
    call Possible_Moves_ROOK
    mov M_pressed_on_what,Black_Rook

    SKIP_Black_ROOK:

    cmp ah,Black_Knight  
    JE Balck_HORSE_M
    JMP SKip_Black_Horse

    Balck_HORSE_M:
    call delete_all_m_possible_moves
    mov dl,rowpl2
    mov cl,colpl2
    mov al,color_Highpl2;color of high
    mov M_col,cl
    mov M_row,dl
    call Possible_Moves_Horse
    mov M_pressed_on_what,Black_Knight

    SKip_Black_Horse:

    cmp ah,Black_Bishop
    JE Black_Elephant_M
    jmp SKip_Black_Elephant

    Black_Elephant_M:
    call delete_all_m_possible_moves
    mov dl,rowpl2
    mov cl,colpl2
    mov al,color_Highpl2;color of high
    mov M_col,cl
    mov M_row,dl
    call Possible_Moves_Elephant
    mov M_pressed_on_what,Black_Bishop

    SKip_Black_Elephant:

    cmp ah,Black_King
    JE Black_King_M
    jmp SKip_Black_King

    Black_King_M:
    call delete_all_m_possible_moves
    mov dl,rowpl2
    mov cl,colpl2
    mov al,color_Highpl2
    mov M_col,cl
    mov M_row,dl
    call possible_Moves_King
    mov M_pressed_on_what,Black_King

    SKip_Black_King:


    cmp ah,Black_Queen
    JE Black_Queen_M
    jmp Skip_Black_Queen

    Black_Queen_M:
    call delete_all_m_possible_moves
    mov dl,rowpl2
    mov cl,colpl2
    mov al,color_Highpl2
    mov M_col,cl
    mov M_row,dl
    call Possible_Moves_Queen
    mov M_pressed_on_what,Black_Queen

    Skip_Black_Queen:


    cmp ah,0
    JE NOTHING_IS_THERE_m
    jmp SKIP_NOTHING_m
    NOTHING_IS_THERE_m:  ;fadel htet lw das 3la possible move fa y8yr mkano fe el array
    call delete_all_m_possible_moves
    mov M_pressed_on_what,0
    SKIP_NOTHING_m:


    popa

    ret
M_Possible_Moves endp

check_m_Input   proc    far

    cmp al,6Dh ;sheck if input is M (pl2)(<^v>)
    JNE skip_M
    call M_Possible_Moves
    skip_M:


    ret
check_m_Input endp

;--------------------------------------end fn el q,m-------------------------------



;-------------------------------------himadooba-------------------------------------
convertIndextoRowCol    PROC    FAR

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

    RET

convertIndextoRowCol    ENDP





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
    sub bl,8
    
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
    sub bl,8
    
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

    ;Get Current position of King
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosBlackKing

    jmp subUpLeftB

     check_upLeft:

     cmp Grid[bx],White_Elephant
     je  foundupleft

     cmp Grid[bx],White_Queen
     je  foundupleft

     cmp Grid[bx],0
     jnz check_upRight

     mov ah,0
     mov al,bl

     call convertIndextoRowCol
    
     push dx
     call ROW_COL_TO_Number
     pop dx

     mov bh,0
     mov bl,Cell_To_Be_Moved

subUpLeftB:
     sub bl,9

     cmp dx,0
     jle check_upRight
   

     cmp cx,0
     jle check_upRight
    

     jmp check_upLeft

     

     foundupleft:
     jmp foundDiagonal

    ;  OutDiagonalLeft:
    ;  jmp OutDiagonal

     ;------------------------------------------------------------------------------------------------
     
     check_upRight:
    
     ;init el check
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosBlackKing

     jmp subUpRightB

     check_upRight_noinit:

     cmp Grid[bx],White_Elephant
     je foundDiagonalRihgt

     cmp Grid[bx],White_Queen
     je foundDiagonalRihgt

     cmp Grid[bx],0
     jnz check_Downleft

     mov ah,0
     mov al,bl

     call convertIndextoRowCol


     push dx
     call ROW_COL_TO_Number
     pop dx

     mov bh,0
     mov bl,Cell_To_Be_Moved

subUpRightB:
     sub bl,7
    
      cmp dx,0
     jle check_Downleft
    

     cmp cx,7
     jge check_Downleft
   
     jmp check_upRight_noinit

     foundDiagonalRihgt:
     jmp foundDiagonal

    ;  OutDiagonalupright:
    ;  jmp OutDiagonal

     ;-------------------------------------------------------------------------------------------------------

     check_Downleft:

      ;init el check
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosBlackKing

     jmp addDownLeftB

     check_DownLeft_noinit:
     cmp Grid[bx],White_Elephant
     je foundDiagonalDownLeftBlack

     cmp Grid[bx],White_Queen
     je foundDiagonalDownLeftBlack

     cmp Grid[bx],0
     jnz check_DownRight

     mov ah,0
     mov al,bl

     call convertIndextoRowCol

     push dx
     call ROW_COL_TO_Number
     pop dx 

     mov bh,0
     mov bl,Cell_To_Be_Moved

addDownLeftB:
     add bl,7     

     cmp cx,0
     jle  check_DownRight
   
     cmp dx,7
     jge  check_DownRight
    

     jmp check_DownLeft_noinit

     foundDiagonalDownLeftBlack:
     jmp foundDiagonal


     ;---------------------------------------------------------------------------------------------------------

     check_DownRight:

      ;init el check
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosBlackKing
    jmp addDownRightB

     check_DownRight_noinit:
     

     cmp Grid[bx],White_Elephant
     je foundDiagonalDownRightBlack

     cmp Grid[bx],White_Queen
     je foundDiagonalDownRightBlack

     cmp Grid[bx],0
     jnz OutDiagonalDownRightBlack



     mov ah,0
     mov al,bl

     call convertIndextoRowCol

     push dx
     call ROW_COL_TO_Number
     pop dx 

     mov bh,0
     mov bl,Cell_To_Be_Moved

addDownRightB:
     add bl,9
    
     cmp cx,7
     jge  OutDiagonalDownRightBlack
     

     cmp dx,7
     jge  OutDiagonalDownRightBlack
     

     jmp check_DownRight_noinit

     foundDiagonalDownRightBlack:
     jmp foundDiagonal

     

     foundDiagonal:
     mov CheckBlack_King,1


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
     mov bh,0
     mov bl,CurrentPosWhiteKing
     jmp subUpLeftW

     check_upLeftWhite_noinit:

     cmp Grid[bx],Black_Bishop
     je  foundupleftWhite

     cmp Grid[bx],Black_Queen
     je  foundupleftWhite

     cmp Grid[bx],0
     jnz check_upRightWhite

     mov ah,0
     mov al,bl

     call convertIndextoRowCol
    
     push dx
     call ROW_COL_TO_Number
     pop dx

     mov bh,0
     mov bl,Cell_To_Be_Moved

subUpLeftW:
     sub bl,9

     cmp dx,0
     jle  check_upRightWhite
   

     cmp cx,0
     jle  check_upRightWhite
    

     jmp check_upLeftWhite_noinit

     

     foundupleftWhite:
     jmp founddiagonalwhite

     ;----------------------------------------------------------------------------------------

     check_upRightWhite:
     ;init el check
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosWhiteKing
     jmp subUpRightW
    
     check_upRightWhite_noinit:

     cmp Grid[bx],Black_Bishop
     je  foundupRightWhite

     cmp Grid[bx],Black_Queen
     je  foundupRightWhite

     cmp Grid[bx],0
     jnz check_Downleft_white

     mov ah,0
     mov al,bl

     call convertIndextoRowCol
    
     push dx
     call ROW_COL_TO_Number
     pop dx

     mov bh,0
     mov bl,Cell_To_Be_Moved

subUpRightW:
     sub bl,7

     cmp dx,0
     jle   check_Downleft_white
   

     cmp cx,7
     jge   check_Downleft_white
    

     jmp check_upRightWhite_noinit

     

     foundupRightWhite:
     jmp founddiagonalwhite

     

     ;------------------------------------------------------------------------------------------

     check_Downleft_white:
     ;init el check
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosWhiteKing
     jmp addDownLeftW
  
     check_Downleft_white_noinit:

     cmp Grid[bx],Black_Bishop
     je foundDiagonalDownLeftWhite

     cmp Grid[bx],Black_Queen
     je foundDiagonalDownLeftWhite

     cmp Grid[bx],0
     jnz check_DownRightWhite

     mov ah,0
     mov al,bl

     call convertIndextoRowCol

     push dx
     call ROW_COL_TO_Number
     pop dx 

     mov bh,0
     mov bl,Cell_To_Be_Moved

addDownLeftW:
     add bl,7

     cmp cx,0
     jle  check_DownRightWhite
   
     cmp dx,7
     jge  check_DownRightWhite
    

     jmp check_Downleft_white_noinit

     foundDiagonalDownLeftWhite:
     jmp founddiagonalwhite

     ;-----------------------------------------------------------------------------------

     check_DownRightWhite:

     ;init el check
     ;call GetCurrentposKing
     mov bh,0
     mov bl,CurrentPosWhiteKing
     jmp addDownRightW

     check_DownRightWhite_Noinit:

     cmp Grid[bx],Black_Bishop
     je foundDiagonalDownRightwhite

     cmp Grid[bx],Black_Queen
     je foundDiagonalDownRightwhite

     cmp Grid[bx],0
     jnz OutDiagonalDownRightwhite



     mov ah,0
     mov al,bl

     call convertIndextoRowCol

     push dx
     call ROW_COL_TO_Number
     pop dx 

     mov bh,0
     mov bl,Cell_To_Be_Moved

addDownRightW:
     add bl,9

     cmp cx,7
     jge  OutDiagonalDownRightwhite
     

     cmp dx,7
     jge  OutDiagonalDownRightwhite
     

     jmp check_DownRightWhite_Noinit

     foundDiagonalDownRightwhite:
     jmp founddiagonalwhite


     founddiagonalwhite:
     mov CheckWhite_King,1

     OutDiagonalDownRightwhite:


     popa

     ret

CheckDiagonal_White endp


;Final Check fns
Check_Black_CheckStatus proc far

    pusha
    ;3ayzen ne call kol checks el black king

    call CheckVertical_BlackKing
    cmp CheckBlack_King,1
    je CheckBlackMes

    call CheckHorizontal_BlackKing
    cmp CheckBlack_King,1
    je CheckBlackMes

    call CheckDiagonal_Black
    cmp CheckBlack_King,1
    je CheckBlackMes

    call CheckWhiteKnight
    cmp CheckBlack_King,1
    je CheckBlackMes

    call checkKingorsoldier_Black
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


    outtchecking:


    popa
    ret


Check_Black_CheckStatus endp

Check_White_CheckStatus proc far

    pusha
    ;3ayzen ne call kol checks el black king

    call CheckVertical_WhiteKing
    cmp Checkwhite_King,1
    je CheckWhitekMes

    call CheckHorizontal_WhiteKing
    cmp Checkwhite_King,1
    je CheckWhitekMes

    call CheckDiagonal_White
    cmp Checkwhite_King,1
    je CheckWhitekMes

    call CheckBlackKnight
    cmp Checkwhite_King,1
    je CheckWhitekMes

    call checkKingorsoldier_White
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


    outtchecking1:


    popa
    ret


Check_White_CheckStatus endp

BigCheck_CallPosKing proc far

    call GetCurrentposKing

    call Check_Black_CheckStatus
    call Check_White_CheckStatus

 ret

BigCheck_CallPosKing endp




;----------------------------Status Bar----------------------------------------;

DrawStatusBar proc far

    ;darw box for status bar

    mov cx,0 ;Column
    mov dx,850 ;Row
    mov al,6h ;Pixel color
    mov ah,0ch ;Draw Pixel Command

    back22: int 10h
    inc cx
    cmp cx,800
    jnz back22

    mov cx,0 ;Column
    mov dx,852 ;Row
    mov al,6h ;Pixel color
    mov ah,0ch ;Draw Pixel Command

    back23: int 10h
    inc cx
    cmp cx,800
    jnz back23

 ;move cursor
    mov ah,2
    mov dh,52
    mov dl,3
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesStatus
    int 21h


    ret
DrawStatusBar ENDP






;-----------------------------------------Main-------------------------------------

MAIN	PROC    FAR
    
    mov ax, @data
    mov ds, ax

;-----------------------------Intialize(starting positions)-----------------------------------
    ;starting positions
    mov di,0 
    mov si,56
    mov BorderGrid[di],High1 ;starting point for high1
    mov BorderGrid[si],High2 ;starting point for high2

    ;---------------------------INIT START FOR GRID

    mov grid[43],Black_King
    ;mov grid[43],Black_Pawm

    mov grid[29],White_Queen
    
    ;mov grid[60],Black_Pawm
    ;mov grid[53],White_Soldier

    ; mov grid[4],White_King
    ; mov grid[38],Black_Knight
    ; mov grid[60],Black_Queen

    ; ;-----------------------------end initial

    ;graphics mode
    mov ax, 4f02h
    mov bx, 107h  ;1024W x 1280H
    int 10h 

    pusha
    call drawGrid
    popa

    call Draw_Highs ;fn to Draw highlits  ;initialize

    Call DrawStatusBar

;----------------------------------------Loop-------------------------------------
loop_1:

    ; Check
    ;pusha
    ;call CheckVertical_CheckKing
    ;popa

    ; pusha
    ; call CheckHorizontal_BlackKing
    ; popa


    pusha
    call BigCheck_CallPosKing
    popa 

    ; pusha
    ; call Check_White_CheckStatus
    ; popa


    ;read char from user
    mov ah,0
    int 16h
    


    call move_player_And_Delete_Old
    call Draw_Highs ; call fn again



    call Check_q_Input  ;check if q is pressed

    ;----------------FN btredraw-------
    ; pusha

    ; cmp Q_pressed_on_what,White_Soldier
    ; JE White_Soldier_Q_pressed
    ; jmp SKIP_White_Solider_pressed

    ; White_Soldier_Q_pressed:
    ; ;vars btt3rf abl el fn maktoba fe el fn definition (Possible_Moves_Soldier)
    ; mov bp,1
    ; mov di,1
    ; mov al,color_Highpl1
    ; mov dl,Q_row
    ; mov cl,Q_col
    ; call Possible_Moves_Soldier
    ; SKIP_White_Solider_pressed:








    ; popa
    ;---------------end FN-------

    ;---------------FN btstore kol el possible moves fe array
    



    ;----------------Fn end



    call check_m_Input  ;check if m is pressed



   


jmp loop_1 ; loop Forever need to be changed example: waiting for an input to stop the game


; hlt

MAIN	ENDP
END	MAIN 




;todo:
;king done
;rook done
;elephant done
;queen done
;horse done
;3askry done

;hwar lma el pl cursor byb2a wa2ef fo2 el possible move bta3 piece
;lma ydos q awel mara yfdel yrsm b3d kol harka
;lma ydos q tany mara -> ?




;-----------------------------------importanttttttttttt todos
;check 3la fn fill_Q_possible_moves_arr we e3mlha lel m
;check 3la awel heta fe fn delete_all_q_possible_moves we e3mlha lel m

;e3ml hwar en byo3od yrsm dah
;zawed htet el fill arr