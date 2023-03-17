.286

EXTRN   Grid:Byte


public colpl1
public rowpl1
public colpl2
public rowpl2
public Cell_To_Be_Moved
public M_possible_moves_arr
public Q_possible_moves_arr

public Set_Old_place_color_and_place
public ROW_COL_TO_Number
public empty_m_possible_moves_arr
public empty_q_possible_moves_arr
public getCursorP1
public getCursorP2
public highInit
public highlight

.MODEL HUGE
.STACK 64
.DATA

BorderGrid db 64 dup(0) ;0 MEANS EMPTY ;arr feh HIgh1,High2
;4 variable bastore fehom el col we el row ely kol.....
;.....highlight etrasm feha 3shan a3rf acheck lma ahrk le highlight fo2 we taht
;el initial cond.
colpl1 db 0 
rowpl1 db 0 ;al
colpl2 db 0 
rowpl2 db 7 ;al
currentpl db ? ;1 lw player1 ely fo2 we vice versa
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
M_possible_moves_arr db 64 dup(0)

;var lw be 1 yb2a draw_border_pieces hatrsm el kill_high blon el board 3shan yms7o lw be 0 yb2a zy ma hwa hy3mel highlight el kill
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

;Grid db 64 dup(0) ;0 MEANS EMPTY
selectedCell    db  8
;-----------------------Grid Vars End-----------------

.CODE

;b3rf el cx be el col we el dx be el row bta3y 3shan lma acall el fn....
;....taht we 3shan fe el loop a3r odd wala even





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
mov al, 07h
mov color_to_delete_with,al

jmp skip_al_mov

Odd_col_odd_row:
Even_col_Even_row:
mov al, 06h
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
    cmp di, 63 ;3shan lw mshy ymen lw fe akher mkan yrg3 lel awel
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
    cmp di, 0 ;3shan lw mshy ymen lw fe akher mkan yrg3 lel awel
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
            JBE OUT1

            SUB AX,8  ;aminus 8 l7d matb2a a2al mn 7 3shan a3rf ana fe row kam 
            INC dX    ;kol ma aminus 8 hazwed wahed fe el row ; el rakam el ba2y mn el minus dah el col
            CMP AX,8

            JAE LOOP1


        OUT1:
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


delete_all      proc    far

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

        call Al_to_color_to_delete_with
        call Draw_border
    
    inc cl
    ;3shan y2of lma ylf 3la el array kolo
    cmp dl,7
    JNE loop_array_M
    cmp cl,7
    jNE loop_array_M

    popa

    ret
delete_all  endp

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

fill_M_possible_moves_arr   proc    far   ;check

    ;dl->row cl->col
    pusha

    pusha
    call ROW_COL_TO_Number
    popa

    mov bx,0
    add bl,Cell_To_Be_Moved
    mov M_possible_moves_arr[bx],1

    popa

    ret

fill_M_possible_moves_arr endp

empty_m_possible_moves_arr      proc    far
    ;fn btsafr kol el array dah (Q_possible_moves_arr)
    ;fe haga msh mazbota fe el fn deh lma bcall it btbwaz el possible moves ely bttrsm

    pusha  
    mov bx,0
    mov cx,64 
    LOOP_m_Arr_0:
    mov M_possible_moves_arr [bx],0  
    inc bx
    dec cx
    JNZ LOOP_m_Arr_0

    popa
    ret


empty_m_possible_moves_arr  endp

Which_arr_to_fill       proc    far

    pusha

    cmp currentpl,1
    je Fill_Ply1
    jmp Fill_Ply2

    Fill_Ply1:
    call fill_Q_possible_moves_arr

    jmp skip_ply2

    Fill_Ply2:
    call fill_M_possible_moves_arr
  

    skip_ply2:

    popa
    ret
Which_arr_to_fill   endp    

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
    call Which_arr_to_fill
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

    JNE Skip_kill_max ;max jmp
    jmp Skipppp
    Skip_kill_max:
    jmp Skip_kill
    Skipppp:


    add kill_1,1
    mov drawed,0 ;3shan myrsmsh b3dha
    ;condition 3shan yshof hyms7 wala la 3la hasab el kill_off
    cmp Kill_off,1
    JNE Kill_on 

    pusha;;;;;;;;;;;;
    call Set_Old_place_color_and_place
    popa
    mov al,color_to_delete_with
    ;call Which_arr_to_fill
    call Draw_border
    jmp skip_kill_on

    Kill_on:
    mov al,color_Kill_Highpl1
    call Which_arr_to_fill
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
    ;call Which_arr_to_fill
    call Draw_border
    jmp skip_kill_on2

    Kill_on2:
    mov al,color_Kill_Highpl2
    call Which_arr_to_fill
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
    mov drawed,0
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
    mov drawed,3
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

    call Which_arr_to_fill
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
    call Which_arr_to_fill
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
    call Which_arr_to_fill
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
    call Which_arr_to_fill
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
    call Which_arr_to_fill
    call Draw_border

    ;Out_Gr3:
    Out_Gr4:
    skip_player22:


    ret
Possible_Moves_Soldier endp


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



Possible_Moves_Queen    proc    far
    ;dl->row ;cl-> col  
    call Possible_Moves_Elephant
    call Possible_Moves_ROOK

    ret
Possible_Moves_Queen  endp


Q_Redraw    proc    far
    pusha
    cmp Q_pressed_on_what,White_Soldier
    jne Skp1
    mov cl,Q_col
    mov dl,Q_row
    mov bp,1
    mov di,1
    mov al, color_Highpl1
    call Possible_Moves_Soldier

    Skp1:


    cmp Q_pressed_on_what,White_Rook
    Jne Skp2

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov dl,Q_row
    mov cl,Q_col
    mov al,color_Highpl1
    call Possible_Moves_ROOK

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    Skp2:

    cmp Q_pressed_on_what,White_Horse
    JNE SKP3

    mov dl,Q_row
    mov cl,Q_col
    mov al,color_Highpl1;color of high
    call Possible_Moves_Horse

    SKP3:

    cmp Q_pressed_on_what,White_Elephant
    JNE Skp4

   
    mov dl,Q_row
    mov cl,Q_col
    mov al,color_Highpl1;color of high
    call Possible_Moves_Elephant

    Skp4:

    cmp Q_pressed_on_what,White_King
    JNE SKP5

    mov dl,Q_row
    mov cl,Q_col
    mov al,color_Highpl1
    call possible_Moves_King

    SKP5:

    cmp Q_pressed_on_what,White_Queen
    JNE SKP6

    mov dl,Q_row
    mov cl,Q_col
    mov al,color_Highpl1
    call Possible_Moves_Queen
    SKP6:



    popa
    ret
Q_Redraw    endp

M_Redraw    proc    far
    pusha
    cmp M_pressed_on_what,Black_Pawm
    jne Skp11
    mov cl,M_col
    mov dl,M_row
    mov bp,6
    mov di,-1
    mov al, color_Highpl2
    call Possible_Moves_Soldier

    Skp11:


    cmp M_pressed_on_what,Black_Rook
    Jne Skp21

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov dl,M_row
    mov cl,M_col
    mov al,color_Highpl2
    call Possible_Moves_ROOK

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    Skp21:

    cmp M_pressed_on_what,Black_Knight
    JNE SKP31

    mov dl,M_row
    mov cl,M_col
    mov al,color_Highpl2;color of high
    call Possible_Moves_Horse

    SKP31:

    cmp M_pressed_on_what,Black_Bishop
    JNE Skp41

   
    mov dl,M_row
    mov cl,M_col
    mov al,color_Highpl2;color of high
    call Possible_Moves_Elephant

    Skp41:

    cmp M_pressed_on_what,Black_King
    JNE SKP51

    mov dl,M_row
    mov cl,M_col
    mov al,color_Highpl2;color of high
    call possible_Moves_King

    SKP51:

    cmp M_pressed_on_what,Black_Queen
    JNE SKP61

    mov dl,M_row
    mov cl,M_col
    mov al,color_Highpl2;color of high
    call Possible_Moves_Queen
    SKP61:



    popa
    ret
M_Redraw    endp



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
    call delete_all ;3shan ams7 kol el possible moves bta3 ay piece tanya kant marsoma
    call empty_q_possible_moves_arr
    mov currentpl,1
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
    call delete_all
    call empty_q_possible_moves_arr
    mov currentpl,1
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
    call delete_all
    call empty_q_possible_moves_arr
    mov currentpl,1
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
    call delete_all
    call empty_q_possible_moves_arr
    mov currentpl,1
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
    call delete_all
    call empty_q_possible_moves_arr
    mov currentpl,1
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
    call delete_all
    call empty_q_possible_moves_arr
    mov currentpl,1
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
    call delete_all ;we kman lw das 3la high el kill
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
    call Q_Redraw

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
    call delete_all
    call empty_m_possible_moves_arr
    mov currentpl,2
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
    call delete_all
    call empty_m_possible_moves_arr
    mov currentpl,2
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
    call delete_all
    call empty_m_possible_moves_arr
    mov currentpl,2
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
    call delete_all
    call empty_m_possible_moves_arr
    mov currentpl,2
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
    call delete_all
    call empty_m_possible_moves_arr
    mov currentpl,2
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
    call delete_all
    call empty_m_possible_moves_arr
    mov currentpl,2
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
    call delete_all
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
    call M_Redraw

    ret
check_m_Input endp

;--------------------------------------end fn el q,m-------------------------------

;-----------------------------------------Main-------------------------------------

; MAIN	PROC    FAR
    
;     mov ax, @data
;     mov ds, ax

;-----------------------------Intialize(starting positions)-----------------------------------
    ;mov di,offset BorderGrid + 0 ;di for player1
    ;mov si,offset BorderGrid + 56 ;si for player2


highInit	PROC    FAR
    ;starting positions
    mov di,0 
    mov si,56
    mov BorderGrid[di],High1 ;starting point for high1
    mov BorderGrid[si],High2 ;starting point for high2

;     ;---------------------------INIT START FOR GRID
;     mov grid[0],White_Rook
;     add grid[0], orangeCell
;     mov grid[1],White_Horse
;     mov grid[2],White_Elephant
;     add grid[2], orangeCell
;     mov grid[3],White_Queen
;     mov grid[4],White_King
;     add grid[4], orangeCell
;     mov grid[5],White_Elephant
;     mov grid[6],White_Horse
;     add grid[6], orangeCell
;     mov grid[7],White_Rook

;     mov grid[8],White_Soldier
;     mov grid[9],White_Soldier
;     add grid[9], orangeCell
;     mov grid[10],White_Soldier
;     mov grid[11],White_Soldier
;     add grid[11], orangeCell
;     mov grid[12],White_Soldier
;     mov grid[13],White_Soldier
;     add grid[13], orangeCell
;     mov grid[14],White_Soldier
;     mov grid[15],White_Soldier
;     add grid[15], orangeCell

    
; ;Black
;     mov grid[63],Black_Rook
;     add grid[63], orangeCell
;     mov grid[62],Black_Knight
;     mov grid[61],Black_Bishop
;     add grid[61], orangeCell
;     mov grid[60],Black_Queen
;     mov grid[59],Black_King
;     add grid[59], orangeCell
;     mov grid[56],Black_Rook
;     mov grid[57],Black_Knight
;     add grid[57], orangeCell
;     mov grid[58],Black_Bishop

;     mov grid[55],Black_Pawm
;     mov grid[54],Black_Pawm
;     add grid[54], orangeCell
;     mov grid[53],Black_Pawm
;     mov grid[52],Black_Pawm
;     add grid[52], orangeCell
;     mov grid[51],Black_Pawm
;     mov grid[50],Black_Pawm
;     add grid[50], orangeCell
;     mov grid[49],Black_Pawm
;     mov grid[48],Black_Pawm
;     add grid[48], orangeCell
;    mov grid[29],White_Elephant
    ; mov grid[28] ,White_Elephant
    ; mov grid [14] ,Black_Bishop
    ; mov grid[10],Black_King
    ; mov grid[0],White_Soldier
    ; ;-----------------------------end initial

    ; ;graphics mode
    ; mov ax, 4f02h
    ; mov bx, 107h  ;1024W x 1280H
    ; int 10h 

    ; pusha
    ; call drawGrid
    ; popa

    call Draw_Highs ;fn to Draw highlits  ;initialize

    ret

highInit  ENDP

;----------------------------------------Loop-------------------------------------
; loop_1:

getCursorP1     PROC    FAR

    mov cl, colpl2
    mov dl, rowpl2
    call ROW_COL_TO_Number

    ; ; testing
    ; mov dl, Cell_To_Be_Moved
    ; add dl, 30h
    ; mov ah,2
    ; int 21h

    ret

getCursorP1 ENDP

getCursorP2     PROC    FAR

    mov cl, colpl1
    mov dl, rowpl1
    call ROW_COL_TO_Number

    ; ; testing
    ; mov dl, Cell_To_Be_Moved
    ; add dl, 30h
    ; mov ah,2
    ; int 21h

    ret

getCursorP2 ENDP

highlight      PROC    FAR
    ; ;read char from user
    ; mov ah,0
    ; int 16h

    push ax
    call move_player_And_Delete_Old
    call Draw_Highs ; call fn again
    pop ax

    push ax
    call Check_q_Input  ;check if q is pressed
    pop ax
    push ax
    call check_m_Input  ;check if m is pressed
    pop ax

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



   
    ret

; jmp loop_1 ; loop Forever need to be changed example: waiting for an input to stop the game


; hlt

highlight  ENDP
; MAIN	ENDP
END




;todo:
;king done
;rook done
;elephant done
;queen done
;horse done
;3askry done

;hwar lma el pl highlight byb2a wa2ef fo2 el possible move bta3 piece
;lma ydos q awel mara yfdel yrsm b3d kol harka
;lma ydos q tany mara -> ?




;-----------------------------------importanttttttttttt todos
;check 3la fn fill_Q_possible_moves_arr we e3mlha lel m
;check 3la awel heta fe fn delete_all_q_possible_moves we e3mlha lel m

;e3ml hwar en byo3od yrsm dah
;zawed htet el fill arr