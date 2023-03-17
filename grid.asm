.286

extrn colpl1:Byte
extrn rowpl1:Byte
extrn colpl2:Byte
extrn rowpl2:Byte
extrn Cell_To_Be_Moved:Byte
extrn M_possible_moves_arr:Byte
extrn Q_possible_moves_arr:Byte

extrn Set_Old_place_color_and_place:FAR
extrn ROW_COL_TO_Number:FAR
extrn empty_m_possible_moves_arr:FAR
extrn empty_q_possible_moves_arr:FAR
extrn getCursorP1:FAR
extrn getCursorP2:FAR
extrn DrawSoldierW:FAR
extrn DrawElephantW:FAR
extrn DrawQueenW:FAR
extrn DrawKingW:FAR
extrn DrawTabyaW:FAR
extrn DrawHourseW:FAR
extrn DrawSolderB:FAR
extrn DrawElephantB:FAR
extrn DrawQueenB:FAR
extrn DrawKingB:FAR
extrn DrawTabyaB:FAR
extrn DrawHourseB:FAR
extrn DrawPiece:FAR
extrn drawSquare:FAR
extrn checkTime:FAR

public Grid
public sourceCellIndex
public destCellIndex  
public kingKilled  

public piecesInit
public movePiecesUp
public movePiecesDown
public movePiecesRight
public movePiecesLeft
public movePiecesUpRight
public movePiecesUpLeft
public movePiecesDownRight
public movePiecesDownLeft
public setPlayerOneSelection
public setPlayerTwoSelection

.MODEL HUGE
.STACK 256
.DATA

;include pieces.asm

kingKilled      db      ?

orangeCell     equ     50

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

noCellSelected      equ     -1

Grid                        db  64 dup(0) ;0 MEANS EMPTY

; for animation
selectedCellIndex           db  noCellSelected
selectedPiece               db  ?
var                         db  ?

; general for both players to use one function for both colors
sourceCellIndex             db  noCellSelected
destCellIndex               db  noCellSelected

sourceCellIndexP1             db  noCellSelected
destCellIndexP1               db  noCellSelected
sourceCellIndexP2             db  noCellSelected
destCellIndexP2               db  noCellSelected
sourceCellCol               dw  ?
sourceCellRow               dw  ?

;0-> if horizontal /// 1-> if vertical /// 2-> if diagonal
Movement_type_3               db  ?
;if horizontal : 1-> right 2-> left
;if vertical :   1-> above 2-> Below
;if diagonal :   1-> Below_right /// 2-> Below_left /// 3-> Above_left  /// 4-> Above_Right
Movement_Direction            db   ?  
;var bastore feh el value ely hathrkha
Movement_Distance           db    ?


; Status Bar
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

clearKillMsg db '                          ','$'

.Code

; redundant to avoid wrong DS when using offset with another file
PrintMessage    PROC    FAR

    mov ah, 09
    int 21h
    ret

PrintMessage ENDP

DrawComp  PROC    FAR ;CX ROW DX COL BX INDEX FOR ARR(GRID)

    CMP ax,White_Soldier
    JNE continue1
    call DrawSoldierW
    jmp finish_Draw

continue1:
    CMP ax,White_Rook
    JNE continue2
    call DrawTabyaW
    jmp finish_Draw

continue2:
    CMP ax,White_Horse
    JNE continue3
    call DrawHourseW
    jmp finish_Draw

continue3:    

    CMP ax,White_Elephant
     JNE continue4
    call DrawElephantW
    jmp finish_Draw

continue4:

    CMP ax,White_Queen
    JNE continue5
    call DrawQueenW
    jmp finish_Draw

continue5:

    CMP ax,White_King
    JNE continue6
    call DrawKingW
    jmp finish_Draw


continue6:

    CMP ax,Black_Pawm
    JNE continue7
    call DrawSolderB
    jmp finish_Draw

continue7:

    
    CMP ax,Black_Rook
    JNE continue8
    call DrawTabyaB
    jmp finish_Draw

continue8:

    CMP ax,Black_Knight
     JNE continue9
    call DrawHourseB
    jmp finish_Draw

continue9:

    CMP ax,Black_Bishop
     JNE continue10
    call DrawElephantB
    jmp finish_Draw

 continue10:   

    CMP ax,Black_Queen
     JNE continue11
    call DrawQueenB
    jmp finish_Draw

continue11:    

    CMP ax,Black_King
    JNE finish_Draw
    call DrawKingB


finish_Draw:

   ret

DrawComp ENDP


convertIndextoRowCol    PROC    FAR

    ; usage: ax -> index
    ; ret:  cx -> start position col
    ;       dx -> start position row

    MOV CX, 0 
    MOV DX, 0

lOOP1:
        CMP AX,7  ;AWEL ROW COMPARE
        JBE OUT1

        SUB AX,8
        INC CX
        CMP AX,8

        JAE LOOP1


    OUT1:
        MOV DX,AX ;EL RAKAM ELY DAKHELY FE AWEL ROW
    
    ; We need cx -> col, dx, row
    xchg cx, dx

    RET

convertIndextoRowCol    ENDP

mult100RowCol  	PROC    FAR

    push bx
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
    pop bx

    
    ret

mult100RowCol   ENDP

; TODO draw cell
; contains: draw sqaure then piece according to grid
; need to use index converter (cx, dx) to specify start
; need to cmp with orangeCell to specify cell color
; then use draw sqaure function
drawCell        PROC    FAR

    ; Need: index (bx)
    push bx

    ; draw sqaure
    ; get cx, dx, color
    mov ax, bx
    call convertIndextoRowCol
    push cx
    push dx
    call Set_Old_place_color_and_place
    pop dx
    pop cx
    push ax
    call mult100RowCol
    pop ax

    pusha
    call drawSquare
    popa

    pop bx
    ; draw its piece if any
    mov ah, 0
    mov al, Grid[bx]
    pusha
    call DrawComp
    popa

    ret

drawCell ENDP

saveCellColRow  PROC    FAR

    ; save ax, bx
    push ax
    push bx

    ; prepare selected index
    mov ah, 0
    mov al, selectedCellIndex
    call convertIndextoRowCol
    call mult100RowCol

    mov sourceCellCol, cx
    mov sourceCellRow, dx

    pop bx
    pop ax

    RET

saveCellColRow ENDP

; ---------------------------- Status Bar Proc
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

CheckifKilled_Display proc far

 ;Check if cell to kill contains White piece

    mov bh, 0
    mov bl, destCellIndex
    
    cmp Grid[bx],White_Soldier
    jne SkipMesgKilled1
    ;Display message for white solider
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesSoldierWhite
    int 21h
    jmp endKillDisplay
    
 SkipMesgKilled1:

    cmp Grid[bx],Black_Pawm
    jne SkipMesgKilled2
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesSoldierBlack
    int 21h
    jmp endKillDisplay

 SkipMesgKilled2:

    cmp Grid[bx],White_Rook
    jne SkipMesgKilled3
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesWhiteRook
    int 21h
    jmp endKillDisplay

 SkipMesgKilled3:

    cmp Grid[bx],Black_Rook
    jne SkipMesgKilled4
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesBlackRook
    int 21h
    jmp endKillDisplay

 SkipMesgKilled4:

    cmp Grid[bx],White_Elephant
    jne SkipMesgKilled5
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesWhiteBishop
    int 21h
    jmp endKillDisplay

 SkipMesgKilled5:

    cmp Grid[bx],Black_Bishop
    jne SkipMesgKilled6
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesBlackBishop
    int 21h
    jmp endKillDisplay

 SkipMesgKilled6:

    cmp Grid[bx],White_Horse
    jne SkipMesgKilled7
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesWhiteKnight
    int 21h
    jmp endKillDisplay

 SkipMesgKilled7:
    cmp Grid[bx],Black_Knight
    jne SkipMesgKilled8
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesBlackKnight
    int 21h
    jmp endKillDisplay

 SkipMesgKilled8:

    cmp Grid[bx],White_Queen
    jne SkipMesgKilled9
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesWhiteQueen
    int 21h
    jmp endKillDisplay

 SkipMesgKilled9:
    cmp Grid[bx],Black_Queen
    jne SkipMesgKilled10
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesBlackQueen
    int 21h
    jmp endKillDisplay


 SkipMesgKilled10:
    cmp Grid[bx],White_King
    jne SkipMesgKilled11
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesWhiteKing
    int 21h
    mov kingKilled, 2
    jmp endKillDisplay


 SkipMesgKilled11:
    cmp Grid[bx],Black_King
    jne SkipMesgKilled12
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset mesBlackKing
    int 21h
    mov kingKilled, 1
    jmp endKillDisplay

SkipMesgKilled12:
    mov kingKilled, 0

endKillDisplay:

    ret
CheckifKilled_Display   ENDP

piecesInit      PROC    FAR

    ; mov ax, @data
    ; mov ds, ax
    ; ---- INIT ----
;White
    mov grid[0],White_Rook
    mov grid[1],White_Horse
    mov grid[2],White_Elephant
    mov grid[3],White_Queen
    mov grid[4],White_King
    mov grid[5],White_Elephant
    mov grid[6],White_Horse
    mov grid[7],White_Rook

    mov grid[8],White_Soldier
    mov grid[9],White_Soldier
    mov grid[10],White_Soldier
    mov grid[11],White_Soldier
    mov grid[12],White_Soldier
    mov grid[13],White_Soldier
    mov grid[14],White_Soldier
    mov grid[15],White_Soldier

    ; add grid[0], orangeCell
    ; add grid[2], orangeCell
    ; add grid[4], orangeCell
    ; add grid[6], orangeCell
    ; add grid[9], orangeCell
    ; add grid[11], orangeCell
    ; add grid[13], orangeCell
    ; add grid[15], orangeCell
    
;Black
    mov grid[63],Black_Rook
    mov grid[62],Black_Knight
    mov grid[61],Black_Bishop
    mov grid[60],Black_Queen
    mov grid[59],Black_King
    mov grid[56],Black_Rook
    mov grid[57],Black_Knight
    mov grid[58],Black_Bishop

    mov grid[55],Black_Pawm
    mov grid[54],Black_Pawm
    mov grid[53],Black_Pawm
    mov grid[52],Black_Pawm
    mov grid[51],Black_Pawm
    mov grid[50],Black_Pawm
    mov grid[49],Black_Pawm
    mov grid[48],Black_Pawm

    ; add grid[63], orangeCell
    ; add grid[61], orangeCell
    ; add grid[59], orangeCell
    ; add grid[57], orangeCell
    ; add grid[54], orangeCell
    ; add grid[52], orangeCell
    ; add grid[50], orangeCell
    ; add grid[48], orangeCell

MOV BX, 0 ;Counter
BIGLOOP:

    MOV AX,BX  ;MAKAN ELY FEL MEMORY

    call convertIndextoRowCol

    call mult100RowCol

    ;DRAW COMPONENT
    mov ah, 0
    mov al, grid[bx]
    pusha
    call DrawComp
    popa

    xchg cx, dx

    INC BX
    CMP BX,64 
    JNE BIGLOOP

    call DrawStatusBar

    ret

piecesInit  ENDP

movePiecesUp    PROC    FAR

    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the grid

    pusha
    ; get selected cell (check if there is selection)
    cmp selectedCellIndex, noCellSelected
    je  dontMoveUp

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatUp:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateUp:
    push cx

    ; draw current cell and above 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw upper cell
    sub bx, 8
    pusha
    call drawCell
    popa
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellRow
shiftUp:
    sub dx, 25
    loop shiftUp
    pop cx
    push cx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, sourceCellCol
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    ; pusha
    ; MOV     CX, 0
    ; MOV     DX, 4240H
    ; mov     al, 0
    ; MOV     AH, 86H
    ; INT     15H
    ; popa

    cmp cx, 5
    jne animateUp
    sub selectedCellIndex, 8
    pop cx
    loop repeatUp

dontMoveUp:

    popa

    RET

movePiecesUp    ENDP

movePiecesDown    PROC    FAR

    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the grid

    pusha
    ; get selected cell (check if there is selection)
    cmp selectedCellIndex, noCellSelected
    je  dontMoveDown

    pusha
    call saveCellColRow
    popa

    ;mov cx, 4
repeatDown:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateDown:
    push cx

    ; draw current cell and above 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw lower cell
    add bx, 8
    pusha
    call drawCell
    popa
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellRow
shiftDown:
    add dx, 25
    loop shiftDown
    pop cx
    push cx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, sourceCellCol
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    ; pusha
    ; MOV     CX, 0
    ; MOV     DX, 4240H
    ; mov     al, 0
    ; MOV     AH, 86H
    ; INT     15H
    ; popa

    cmp cx, 5
    jne animateDown
    add selectedCellIndex, 8
    pop cx
    loop repeatDown

dontMoveDown:

    popa

    RET

movePiecesDown    ENDP

movePiecesRight    PROC    FAR

    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the grid

    pusha

    ; get selected cell (check if there is selection)
    cmp selectedCellIndex, noCellSelected
    je  dontMoveRight

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatRight:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateRight:
    push cx

    ; draw current cell and above 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw right cell
    add bx, 1
    pusha
    call drawCell
    popa
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellCol
shiftRight:
    add dx, 25
    loop shiftRight
    pop cx
    push cx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, sourceCellRow
    xchg cx, dx
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    ; pusha
    ; MOV     CX, 0
    ; MOV     DX, 4240H
    ; mov     al, 0
    ; MOV     AH, 86H
    ; INT     15H
    ; popa

    cmp cx, 5
    jne animateRight
    add selectedCellIndex, 1
    pop cx
    loop repeatRight

dontMoveRight:

    popa

    RET

movePiecesRight    ENDP

movePiecesLeft    PROC    FAR

    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the grid

    pusha

    ; get selected cell (check if there is selection)
    cmp selectedCellIndex, noCellSelected
    je  dontMoveLeft

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatLeft:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateLeft:
    push cx

    ; draw current cell and above 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw right cell
    sub bx, 1
    pusha
    call drawCell
    popa
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellCol
shiftLeft:
    sub dx, 50
    loop shiftLeft
    pop cx
    push cx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, sourceCellRow
    xchg cx, dx
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    ; pusha
    ; MOV     CX, 0
    ; MOV     DX, 4240H
    ; mov     al, 0
    ; MOV     AH, 86H
    ; INT     15H
    ; popa

    cmp cx, 3
    jne animateLeft
    sub selectedCellIndex, 1
    pop cx
    loop repeatLeft

dontMoveLeft:

    popa

    RET

movePiecesLeft    ENDP
; TODO diagonal up left

; TODO diagonal up right
movePiecesUpLeft    PROC    FAR

    pusha
    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the grid

    ; ; get selected cell (check if there is selection)
    ; cmp selectedCellIndex, noCellSelected
    ; je  dontMoveUpLeft

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatUpLeft:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateUpLeft:
    push cx

    ; draw current cell and above 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw left cell
    sub bx, 1
    pusha
    call drawCell
    popa
    add bx, 1
    ; 4. draw up cell
    sub bx, 8
    pusha
    call drawCell
    popa
    add bx, 8
    ; 4. draw up-left cell
    sub bx, 9
    pusha
    call drawCell
    popa
    add bx, 9
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellCol
shiftUpLeft:
    sub dx, 25
    loop shiftUpLeft
    pop cx
    push cx
    mov si, dx
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellRow
shiftUpLeft1:
    sub dx, 25
    loop shiftUpLeft1
    pop cx
    push cx
    mov di, dx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, si
    mov dx, di
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    cmp cx, 5
    jne animateUpLeft
    sub selectedCellIndex, 9
    pop cx
    loop repeatUpLeft

dontMoveUpLeft:
    popa

    RET

movePiecesUpLeft    ENDP

; TODO diagonal up right
movePiecesUpRight    PROC    FAR

    pusha
    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the gridmovePiecesUpRight

    ; ; get selected cell (check if there is selection)
    ; cmp selectedCellIndex, noCellSelected
    ; je  dontMoveUpRight

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatUpRight:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateUpRight:
    push cx

    ; draw current cell and above 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw right cell
    add bx, 1
    pusha
    call drawCell
    popa
    sub bx, 1
    ; 4. draw up cell
    sub bx, 8
    pusha
    call drawCell
    popa
    add bx, 8
    ; 4. draw up-right cell
    sub bx, 7
    pusha
    call drawCell
    popa
    add bx, 7
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellCol
shiftUpRight:
    add dx, 25
    loop shiftUpRight
    pop cx
    push cx
    mov si, dx
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellRow
shiftUpRight1:
    sub dx, 25
    loop shiftUpRight1
    pop cx
    push cx
    mov di, dx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, si
    mov dx, di
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    cmp cx, 5
    jne animateUpRight
    sub selectedCellIndex, 7
    pop cx
    loop repeatUpRight

dontMoveUpRight:

    popa

    RET

movePiecesUpRight    ENDP

; TODO diagonal down left
movePiecesDownLeft    PROC    FAR

    pusha
    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the gridmovePiecesUpRight

    ; ; get selected cell (check if there is selection)
    ; cmp selectedCellIndex, noCellSelected
    ; je  dontMoveDownLeft

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatDownLeft:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateDownLeft:
    push cx

    ; draw current cell and belw 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw left cell
    sub bx, 1
    pusha
    call drawCell
    popa
    add bx, 1
    ; 4. draw down cell
    add bx, 8
    pusha
    call drawCell
    popa
    sub bx, 8
    ; 4. draw down-left cell
    add bx, 7
    pusha
    call drawCell
    popa
    sub bx, 7
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellCol
shiftDownLeft:
    sub dx, 25
    loop shiftDownLeft
    pop cx
    push cx
    mov si, dx
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellRow
shiftDownLeft1:
    add dx, 25
    loop shiftDownLeft1
    pop cx
    push cx
    mov di, dx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, si
    mov dx, di
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    cmp cx, 5
    jne animateDownLeft
    add selectedCellIndex, 7
    pop cx
    loop repeatDownLeft

dontMoveDownLeft:

    popa

    RET

movePiecesDownLeft    ENDP

; TODO diagonal down right
movePiecesDownRight    PROC    FAR

    pusha
    ; usage
    ; cx: number of cells to move
    ; * Remove cell first -> call this function -> add it to the gridmovePiecesUpRight

    ; ; get selected cell (check if there is selection)
    ; cmp selectedCellIndex, noCellSelected
    ; je  dontMoveDownRight

    pusha
    call saveCellColRow
    popa

    ; mov cx, 4
repeatDownRight:
    push cx

    ; repeatDown 4 times (25 * 4 = 100)
    ; pushing and poping cx to keep track of the number of loops
    mov cx, 1
animateDownRight:
    push cx

    ; draw current cell and belw 
    ; draw piece with dx - 25
    
    ; 1. get selected index
    ; 2. prepare color, beginning row & col
    call saveCellColRow
    ; 3. draw start cell
    mov bh, 0
    mov bl, selectedCellIndex
    pusha
    call drawCell
    popa
    ; 4. draw right cell
    add bx, 1
    pusha
    call drawCell
    popa
    sub bx, 1
    ; 4. draw down cell
    add bx, 8
    pusha
    call drawCell
    popa
    sub bx, 8
    ; 4. draw down-right cell
    add bx, 9
    pusha
    call drawCell
    popa
    sub bx, 9
    
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellCol
shiftDownRight:
    add dx, 25
    loop shiftDownRight
    pop cx
    push cx
    mov si, dx
    ; 5. draw moving piece
    ; prepare dx
    pop cx
    push cx
    mov dx, sourceCellRow
shiftDownRight1:
    add dx, 25
    loop shiftDownRight1
    pop cx
    push cx
    mov di, dx

    ; prepare cx, piece number
    mov ah, 0
    mov al, selectedPiece
    mov cx, si
    mov dx, di
    pusha
    call DrawComp
    popa
    
    pop cx
    inc cx

    cmp cx, 5
    jne animateDownRight
    add selectedCellIndex, 9
    pop cx
    loop repeatDownRight

dontMoveDownRight:

    popa

    RET

movePiecesDownRight    ENDP

C_Movement     PROC    FAR

    mov ah,0
    mov al, sourceCellIndex
    call convertIndextoRowCol
    mov sourceCellCol, cx
    mov sourceCellRow, dx

    mov ah,0
    mov al, destCellIndex
    call convertIndextoRowCol
    
    cmp dx, sourceCellRow
    jne notHor
    
    ; to calc the difference
    mov bx, sourceCellCol

    cmp cx, sourceCellCol
    ja hor_right
    jmp hor_left

hor_right:
    ;mov ax, 1
    mov Movement_type_3 , 0 
    mov Movement_Direction ,1
    push cx
    sub cx, bx ;cx feha el value ely hathrk
    mov bx, cx  ;bx feha el value ely hathrk
    mov Movement_Distance , bl
    pop cx
    ret

hor_left:
    ;mov ax, 0
    mov Movement_type_3 , 0 
    mov Movement_Direction,2
    sub bx, cx
    mov Movement_Distance , bl
    ret

notHor:

    ;--------------Vertical
    mov ah,0
    mov al, sourceCellIndex
    call convertIndextoRowCol
    mov sourceCellCol, cx
    mov sourceCellRow, dx

    mov ah,0
    mov al, destCellIndex
    call convertIndextoRowCol ;cx dest col dx dest row
    
    ; if col != col -> not equal
    cmp cx, sourceCellCol
    jne notVertical
    
    ; to calc the difference
    mov bx, sourceCellRow

    cmp dx, sourceCellRow
    ja vertical_below
    jmp vertical_above

vertical_below:
    ;mov ax, 1
    mov Movement_type_3,1
    mov Movement_Direction,2
    push dx
    sub dx, bx
    mov bx, dx
    mov Movement_Distance , bl
    pop dx
    ret

vertical_above:
    ;mov ax, 0
    mov Movement_type_3,1
    mov Movement_Direction,1
    sub bx, dx
    mov Movement_Distance , bl

    ret

notVertical:



    ;-----------Diagonal
    mov ah,0
    mov al, sourceCellIndex
    call convertIndextoRowCol
    mov sourceCellCol, cx
    mov sourceCellRow, dx

    mov ah,0
    mov al, destCellIndex
    call convertIndextoRowCol
    
    ; to calc the difference
    ;mov bx, sourceCellRow

    cmp dx, sourceCellRow
    ja diagonal_below
    jmp diagonal_above

diagonal_below:

    cmp cx, sourceCellCol
    JA Below_Right
    Jmp Below_Left
    ;mov ax, 1
    ; push dx
    ; sub dx, bx
    ; mov bx, dx
    ; pop dx
    ; jmp

diagonal_above:

    cmp cx, sourceCellCol
    JA Above_Right
    Jmp Above_Left
    ;mov ax, 0
    ;sub bx, dx

Below_Right:
    mov Movement_Direction,1
    mov Movement_type_3,2
    sub cx,sourceCellCol

    mov Movement_Distance,cl
    ret
Below_Left:
    mov Movement_Direction,2
    mov Movement_type_3,2
    sub sourceCellCol,cx
    mov bx,sourceCellCol

    mov Movement_Distance,bl
    ret
Above_Left:
    mov Movement_Direction,3
    mov Movement_type_3,2
    sub sourceCellCol,cx
    mov bx,sourceCellCol

    mov Movement_Distance,bl
    ret
Above_Right:
    mov Movement_Direction,4
    mov Movement_type_3,2
    sub cx,sourceCellCol

    mov Movement_Distance,cl
    ret


notDiagonal: ;malhash lazma
   

    ret
C_Movement  ENDP 

Check_Movement  proc    far

   
    pusha

    ;fn bthot values fe el 3 variable  dolt
    ;0-> if horizontal /// 1-> if vertical /// 2-> if diagonal
    ;Movement_type_3               db  ?
    ;if horizontal : 1-> right 2-> left
    ;if vertical :   1-> above 2-> Below
    ;if diagonal :   1-> Below_right /// 2-> Below_left /// 3-> Above_left  /// 4-> Above_Right
    ;Movement_Direction            db   ?  
    ;var bastore feh el value ely hathrkha
    ;Movement_Distance         db   ? 

    call C_Movement
    popa

    ret
Check_Movement  endp    
;;;

gettingKilled   PROC    FAR
    
    pusha
    mov bh, 0
    mov bl, destCellIndex

    cmp grid[bx], 0
    je nothingGettingKilled

    ; if there is a piece -> display it is killed
    call CheckifKilled_Display
    jmp endGettingKilled

nothingGettingKilled:
    ;Display message
    ;move cursor
    mov ah,2
    mov dh,55
    mov dl,45
    mov bh,0
    int 10h

    mov ah, 9
    mov dx, offset clearKillMsg
    int 21h

endGettingKilled:
    popa
    ret

gettingKilled   ENDP

; TODO move soldier player
movePlayerOneSolider    PROC    FAR

    ;pusha

    ; check for piece time constrain (either continue or don't move)
    

    ; check for destination cell
    mov al, 0
    
    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa
    ; check for direction
    call Check_Movement

    ; pusha
    ; ; testing
    ; mov dl, Movement_Distance
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    ;extra
    cmp Movement_type_3, 0          ; horizontal (todo if not vertical check for upper left and right)
    je maxInvalidMoveBSol
    ;;
    cmp Movement_type_3, 1          ; vertical (todo if not vertical check for upper left and right)
    je verticalBSol
    cmp Movement_type_3, 2          ; diagonal (todo if not vertical check for upper left and right)
    je diagonalBSol
    jmp invalidMoveBSol

maxInvalidMoveBSol:
    jmp invalidMoveBSol

diagonalBSol:
    cmp Movement_Direction, 3       ; above left
    je solUpperLeftSol
    cmp Movement_Direction, 4       ; above right
    je solUpperRightSol
    jmp invalidMoveBSol

verticalBSol:
    pusha
    ; check if the destination is from the same color (let it in horse)
    ; will reduce running time
    mov bh, 0
    mov bl, destCellIndexP1
    mov al, grid[bx]
    cmp al, 0               ; there is a cell -> invalid
    popa
    jne maxInvalidMoveBSol
    ; check for 2 moves
    mov ch, 0
    mov cl, Movement_Distance
    jmp moveSolUp


solUpperRightSol:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndexP1
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesUpRight

    ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndexP1
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBSol


solUpperLeftSol:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndexP1
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    ; mov cx, 1
    call movePiecesUpLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndexP1
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBSol


moveSolUp:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesUp

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBSol

invalidMoveBSol:

    ; mov bh, 0
    ; mov bl, destCellIndex
    ; pusha
    ; call drawCell
    ; popa
    ; call empty_m_possible_moves_arr

    ;popa

    ret

movePlayerOneSolider    ENDP

; TODO move soldier player
movePlayerTwoSolider    PROC    FAR

   ; pusha

    ; check for piece time constrain (either continue or don't move)
    

    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa

    ; check for destination cell
    mov al, 0
    
    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa
    ; check for direction
    call Check_Movement

    ; pusha
    ; ; testing
    ; mov dl, Movement_Distance
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    ;extra
    cmp Movement_type_3, 0          ; horizontal (todo if not vertical check for upper left and right)
    je maxInvalidMoveWSol
    ;;
    cmp Movement_type_3, 1          ; vertical (todo if not vertical check for upper left and right)
    je verticalWSol
    cmp Movement_type_3, 2          ; diagonal (todo if not vertical check for upper left and right)
    je diagonalWSol
    jmp invalidMoveWSol

maxInvalidMoveWSol:
    jmp invalidMoveWSol


diagonalWSol:
    cmp Movement_Direction, 2       ; below left
    je solBelowLeftSol
    cmp Movement_Direction, 1       ; below right
    je solBelowRightSol
    jmp invalidMoveWSol

verticalWSol:
    pusha
    ; check if the destination is from the same color (let it in horse)
    ; will reduce running time
    mov bh, 0
    mov bl, destCellIndexP2
    mov al, grid[bx]
    cmp al, 0               ; there is a cell -> invalid
    popa
    jne maxInvalidMoveWSol
    ; check for 2 moves
    mov ch, 0
    mov cl, Movement_Distance
    jmp moveSolDown


solBelowRightSol:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndexP2
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesDownRight

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndexP2
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveWSol


solBelowLeftSol:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndexP2
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesDownLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndexP2
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveWSol


moveSolDown:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndexP2
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesDown

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndexP2
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveWSol

invalidMoveWSol:

    ; mov bh, 0
    ; mov bl, destCellIndex
    ; pusha
    ; call drawCell
    ; popa
    ; call empty_q_possible_moves_arr

    ;popa
    ret

movePlayerTwoSolider    ENDP

moveTabya       PROC    FAR

    cmp Movement_type_3, 1          ; vertical (todo if not vertical check for upper left and right)
    je verticalBTabya
    cmp Movement_type_3, 0          ; horizontal (todo if not vertical check for upper left and right)
    je horizontalBTabya
    jmp invalidMoveBTabya

horizontalBTabya:
    cmp Movement_Direction, 2       ; left
    je tabyaBLeft
    cmp Movement_Direction, 1       ; right
    je tabyaBRight
    jmp invalidMoveBTabya

verticalBTabya:
    cmp Movement_Direction, 2       ; below
    je tabyaBDown
    cmp Movement_Direction, 1       ; above
    je tabyaBUpmax ;max jump
    jmp skiptabyaup
    tabyaBUpmax:
    jmp tabyaBUp
    skiptabyaup:

    jmp invalidMoveBTabya


tabyaBRight:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesRight

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBTabya


tabyaBLeft:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    ; mov cx, 1
    call movePiecesLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBTabya


tabyaBDown:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesDown

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBTabya

tabyaBUp:
    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesUp

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al
    
    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBTabya

invalidMoveBTabya:

    RET

moveTabya   ENDP


movePlayerOneTabya    PROC  FAR

    ;pusha

    ; check for piece time constrain (either continue or don't move)



;     ; check if valid move from its possible move
;     mov bh, 0
;     mov bl, destCellIndex
;     cmp M_possible_moves_arr[bx], 0
;     je maxInvalidMoveBTabya           ; maxIjump
;     jmp contBTabya
; maxInvalidMoveBTabya:
;     jmp invalidMoveBTabya
; contBTabya:
    

    ; check for destination cell
    mov al, 0
    
    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa
    ; check for direction
    call Check_Movement

    ; pusha
    ; ; testing
    ; mov dl, Movement_Distance
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa
    ; pusha
    ; ; testing
    ; mov dl, Movement_type_3
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa
    ; pusha
    ; ; testing
    ; mov dl, Movement_Direction
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    ;extra
    cmp Movement_type_3, 2          ; diagonal (todo if not vertical check for upper left and right)
    je invalidMoveBTabya
    ;;

    call moveTabya

    ; mov bh, 0
    ; mov bl, destCellIndex
    ; pusha
    ; call drawCell
    ; popa
    ; call empty_m_possible_moves_arr

    ;popa

    ret

movePlayerOneTabya    ENDP

; horseAnimation  MACRO  horizontalMove
;     LOCAL moveHorseOneUp
;     LOCAL moveHorseTwoUp
    
;     cmp Movement_Distance, 2
;     je moveHorseOneUp
;     mov cx, 2
;     jmp moveHorseTwoUp
; moveHorseOneUp:
;     mov cx, 1
; moveHorseTwoUp:
;     call movePiecesUp
;     mov ch, 0
;     mov cl, Movement_Distance
;     ; mov cx, 1
;     call horizontalMove

; horseAnimation    ENDM

movehorseBAboveRight    PROC    FAR

        ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    cmp Movement_Distance, 2
    je moveHorseOneUp1
    mov cx, 2
    jmp moveHorseTwoUp1
moveHorseOneUp1:
    mov cx, 1
moveHorseTwoUp1:
    call movePiecesUp
    mov ch, 0
    mov cl, Movement_Distance
    ; mov cx, 1
    call movePiecesRight

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

movehorseBAboveRight    ENDP

movehorseBAboveLeft    PROC    FAR

    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    cmp Movement_Distance, 2
    je moveHorseOneUp2
    mov cx, 2
    jmp moveHorseTwoUp2
moveHorseOneUp2:
    mov cx, 1
moveHorseTwoUp2:
    call movePiecesUp
    mov ch, 0
    mov cl, Movement_Distance
    ; mov cx, 1
    call movePiecesLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

movehorseBAboveLeft    ENDP

movehorseBBelowRight    PROC    FAR

        ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    cmp Movement_Distance, 2
    je moveHorseOneUp3
    mov cx, 2
    jmp moveHorseTwoUp3
moveHorseOneUp3:
    mov cx, 1
moveHorseTwoUp3:
    call movePiecesDown
    mov ch, 0
    mov cl, Movement_Distance
    ; mov cx, 1
    call movePiecesRight

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

movehorseBBelowRight    ENDP

movehorseBBelowLeft    PROC    FAR

    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    cmp Movement_Distance, 2
    je moveHorseOneUp4
    mov cx, 2
    jmp moveHorseTwoUp4
moveHorseOneUp4:
    mov cx, 1
moveHorseTwoUp4:
    call movePiecesDown
    mov ch, 0
    mov cl, Movement_Distance
    ; mov cx, 1
    call movePiecesLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

movehorseBBelowLeft    ENDP

movePlayerOneHorse    PROC  FAR

    ; check for piece time constrain (either continue or don't move)



    ; check for destination cell
    mov al, 0
    
    ; check for direction
    call Check_Movement
    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa

    ;extra
    cmp Movement_type_3, 2          ; diagonal (todo if not vertical check for upper left and right)
    je diagonalBHorse


maxinvalidMoveBHorse:
    jmp invalidMoveBHorse    
    ;;
    cmp Movement_type_3, 1          ; vertical (todo if not vertical check for upper left and right)
    je maxinvalidMoveBHorse
    cmp Movement_type_3, 0          ; horizontal (todo if not vertical check for upper left and right)
    je maxinvalidMoveBHorse
    jmp maxinvalidMoveBHorse

diagonalBHorse:
    cmp Movement_Direction, 2       ; below left
    je maxhorseBBelowLeft           ;max jump
    jmp contBHorseCheck
maxhorseBBelowLeft:
    jmp horseBBelowLeft
contBHorseCheck:

    cmp Movement_Direction, 4       ; above right
    je horseBAboveRight

    cmp Movement_Direction, 1       ; below right
    je horseBBelowRight
    cmp Movement_Direction, 3       ; above left
    je horseBAboveLeft
    jmp invalidMoveBHorse

horseBAboveRight:
    ; movement
    call movehorseBAboveRight
    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBHorse


horseBAboveLeft:
    ; movement
    call movehorseBAboveLeft

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBHorse


horseBBelowRight:
    ; movement
    call movehorseBBelowRight

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBHorse

horseBBelowLeft:
    ; movement
    call movehorseBBelowLeft

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBHorse

invalidMoveBHorse:



    ret

movePlayerOneHorse    ENDP

moveElephantUpRight    PROC    FAR

    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesUpRight

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

moveElephantUpRight    ENDP

moveElephantUpLeft    PROC    FAR

    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesUpLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

moveElephantUpLeft    ENDP

moveElephantDownRight    PROC    FAR

    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesDownRight

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

moveElephantDownRight    ENDP

moveElephantDownLeft    PROC    FAR

    ; movement
    ; remove from grid
    mov bh, 0
    mov bl, sourceCellIndex
    mov selectedCellIndex, bl
    mov al, grid[bx]
    mov selectedPiece, al
    mov grid[bx], 0

    ; animate
    mov ch, 0
    mov cl, Movement_Distance
    call movePiecesDownLeft

    ; ; add to grid
    call gettingKilled
    mov bh, 0
    mov bl, destCellIndex
    mov al, selectedPiece
    mov grid[bx], al

    ret

moveElephantDownLeft    ENDP

movePlayerOneElephant    PROC  FAR

    ; check for piece time constrain (either continue or don't move)

    ; pusha
    ; ; testing
    ; mov dl, selectedPiece
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    ; check for destination cell
    mov al, 0
    
    ; check for direction
    call Check_Movement

    ;extra
    cmp Movement_type_3, 2          ; diagonal (todo if not vertical check for upper left and right)
    je diagonalBElephant
    ;;
    cmp Movement_type_3, 1          ; vertical (todo if not vertical check for upper left and right)
    je maxinvalidMoveBElephant
    cmp Movement_type_3, 0          ; horizontal (todo if not vertical check for upper left and right)
    je maxinvalidMoveBElephant
    jmp maxinvalidMoveBElephant
    
maxinvalidMoveBElephant:
    jmp invalidMoveBElephant

diagonalBElephant:
    cmp Movement_Direction, 2       ; below left
    je elephantBBelowLeft           ;max jump
;     jmp contBHorseCheck
; maxhorseBBelowLeft:
;     jmp elephantBBelowLeft
; contBHorseCheck:

    cmp Movement_Direction, 4       ; above right
    je elephantBAboveRight

    cmp Movement_Direction, 1       ; below right
    je elephantBBelowRight
    cmp Movement_Direction, 3       ; above left
    je elephantBAboveLeft
    jmp invalidMoveBElephant

elephantBAboveRight:
    ; movement

    call moveElephantUpRight
    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBElephant


elephantBAboveLeft:
    ; movement
    call moveElephantUpLeft

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBElephant


elephantBBelowRight:
    ; movement
    call moveElephantDownRight

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBElephant

elephantBBelowLeft:
    ; movement
    call moveElephantDownLeft

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBElephant

invalidMoveBElephant:

    ; mov bh, 0
    ; mov bl, destCellIndex
    ; pusha
    ; call drawCell
    ; popa
    ; call empty_m_possible_moves_arr

    ret

movePlayerOneElephant    ENDP

movePlayerOneQueen    PROC  FAR

    ; check for piece time constrain (either continue or don't move)
    

    ; check for destination cell
    mov al, 0
    
    ; check for direction
    call Check_Movement

    ;extra
    cmp Movement_type_3, 2          ; diagonal (todo if not vertical check for upper left and right)
    je diagonalBQueen
    ;;
    call moveTabya
    jmp invalidMoveBQueen

diagonalBQueen:
    cmp Movement_Direction, 2       ; below left
    je QueenBBelowLeft           

    cmp Movement_Direction, 4       ; above right
    je QueenBAboveRight

    cmp Movement_Direction, 1       ; below right
    je QueenBBelowRight
    cmp Movement_Direction, 3       ; above left
    je QueenBAboveLeft
    jmp invalidMoveBQueen

QueenBAboveRight:
    ; movement
    call moveElephantUpRight
    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBQueen


QueenBAboveLeft:
    ; movement
    call moveElephantUpLeft

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBQueen


QueenBBelowRight:
    ; movement
    call moveElephantDownRight

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBQueen

QueenBBelowLeft:
    ; movement
    call moveElephantDownLeft

    ; move it in timer grid
    ; clear playerOne possible moves
    jmp invalidMoveBQueen

invalidMoveBQueen:

    ret

movePlayerOneQueen    ENDP

movePlayerPiece       PROC    FAR
    ; Function specify the selectedPiece and call the right move function

    ; (EDIT: This will never happen) if source and destination cells = -1 -> don't move

    ; get selected piece
    mov bh, 0
    mov bl, sourceCellIndex
    mov al, grid[bx]
    mov selectedPiece, al

    ; pusha
    ; ; testing
    ; mov dl, al
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

;     call checkTime
;     cmp ax, 1
;     je moveTime

; dontMoveTime:
;     jmp finish_cmp

moveTime:

    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa
    ; pusha
    ; ; testing
    ; mov dl, bl
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa
    ; pusha
    ; ; testing
    ; mov dl, al
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    ; ; check if the destination is from the same color (let it in horse)
    ; ; will reduce running time
    ; mov bh, 0
    ; mov bl, destCellIndexP1
    ; mov al, grid[bx]
    ; cmp al, Black_Pawm ; if pawm or above -> invalid
    ; jae finish_cmp


    ; call the appropriate move function according to selectedPiece
    CMP selectedPiece, White_Soldier
    JNE continueCmp1
    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp Q_possible_moves_arr[bx], 0
    je maxfinish_cmp1           ; maxIjump
    jmp contPiece1
maxfinish_cmp1:
    jmp finish_cmp
contPiece1:

    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al
    call movePlayerTwoSolider

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_q_possible_moves_arr

    jmp finish_cmp

continueCmp1:
    CMP selectedPiece,White_Rook
    JNE continueCmp2


    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp Q_possible_moves_arr[bx], 0
    je maxfinish_cmp2           ; maxIjump
    jmp contPiece2
maxfinish_cmp2:
    jmp finish_cmp
contPiece2:

    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al

    ; pusha
    ; ; testing
    ; mov dl, al
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa
    call movePlayerOneTabya

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_q_possible_moves_arr

    jmp finish_cmp

continueCmp2:
    CMP selectedPiece,White_Horse
    JNE continueCmp3

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp Q_possible_moves_arr[bx], 0
    je maxfinish_cmp3           ; maxIjump
    jmp contPiece3
maxfinish_cmp3:
    jmp finish_cmp
contPiece3:

    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al
    call movePlayerOneHorse

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_q_possible_moves_arr

    jmp finish_cmp

continueCmp3:

    CMP selectedPiece,White_Elephant
    JNE continueCmp4

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp Q_possible_moves_arr[bx], 0
    je maxfinish_cmp4           ; maxIjump
    jmp contPiece4
maxfinish_cmp4:
    jmp finish_cmp
contPiece4:

    
    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al
    call movePlayerOneElephant

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_q_possible_moves_arr

    jmp finish_cmp

continueCmp4:

    CMP selectedPiece,White_Queen
    JNE continueCmp5

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp Q_possible_moves_arr[bx], 0
    je maxfinish_cmp5           ; maxIjump
    jmp contPiece5
maxfinish_cmp5:
    jmp finish_cmp
contPiece5:

    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al
    call movePlayerOneQueen

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_q_possible_moves_arr

    jmp finish_cmp

continueCmp5:

    CMP selectedPiece,White_King
    JNE continueCmp6

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp Q_possible_moves_arr[bx], 0
    je maxfinish_cmp6           ; maxIjump
    jmp contPiece6
maxfinish_cmp6:
    jmp finish_cmp
contPiece6:

    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al
    call movePlayerOneQueen

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_q_possible_moves_arr
    
    jmp finish_cmp
    

continueCmp6:


; ------------------- Black -------------------
    CMP selectedPiece,Black_Pawm
    JNE continueCmp7

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp M_possible_moves_arr[bx], 0
    je maxfinish_cmp7           ; maxIjump
    jmp contPiece7
maxfinish_cmp7:
    jmp finish_cmp
contPiece7:

    ; set sourceCell, destCell
    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerOneSolider

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_m_possible_moves_arr

    jmp finish_cmp

continueCmp7:

    CMP selectedPiece,Black_Rook
    JNE continueCmp8

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp M_possible_moves_arr[bx], 0
    je maxfinish_cmp8           ; maxIjump
    jmp contPiece8
maxfinish_cmp8:
    jmp finish_cmp
contPiece8:

    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerOneTabya

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_m_possible_moves_arr

    jmp finish_cmp

continueCmp8:

    CMP selectedPiece,Black_Knight
    JNE continueCmp9

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp M_possible_moves_arr[bx], 0
    je maxfinish_cmp9           ; maxIjump
    jmp contPiece9
maxfinish_cmp9:
    jmp finish_cmp
contPiece9:

    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerOneHorse

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_m_possible_moves_arr

    jmp finish_cmp

continueCmp9:

    CMP selectedPiece,Black_Bishop
    JNE continueCmp10

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp M_possible_moves_arr[bx], 0
    je maxfinish_cmp10           ; maxIjump
    jmp contPiece10
maxfinish_cmp10:
    jmp finish_cmp
contPiece10:

    ; pusha
    ; ; testing
    ; mov dl, selectedPiece
    ; add dl, 30h
    ; mov ah,2
    ; int 21h
    ; popa

    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerOneElephant

    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_m_possible_moves_arr

    jmp finish_cmp

 continueCmp10:   

    CMP selectedPiece,Black_Queen
    JNE continueCmp11

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp M_possible_moves_arr[bx], 0
    je finish_cmp

    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerOneQueen
    
    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_m_possible_moves_arr

    jmp finish_cmp

continueCmp11:

    CMP selectedPiece,Black_King
    JNE finish_cmp

    ; check if valid move from its possible move
    mov bh, 0
    mov bl, destCellIndex
    cmp M_possible_moves_arr[bx], 0
    je finish_cmp           ; maxIjump

    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerOneQueen
    mov bh, 0
    mov bl, destCellIndex
    pusha
    call drawCell
    popa
    call empty_m_possible_moves_arr

finish_cmp:

   ret

movePlayerPiece   ENDP

setPlayerOneSelection   PROC    FAR

    ; check for source selection: if    -1 -> set it with the current cursor index
    ;                             else  set destination with the current cursor index

;     cmp si, 1
;     jne playerTwo

; playerTwo:

    pusha
    call getCursorP1 ; stored in Cell_To_Be_Moved
    popa

    cmp sourceCellIndexP1, noCellSelected
    jne setDestP1
    mov bh, 0
    mov bl, Cell_To_Be_Moved
    cmp grid[bx], 0             ; if selected cell is empty in first selection -> clear
    je maxclearSelcP1           ; max jump
    jmp contClearSelcP1
maxclearSelcP1:
    jmp clearSelcP1
contClearSelcP1:
    mov sourceCellIndexP1, bl   ; cursor index
    jmp sourceP1IsSet

setDestP1:
    mov bl, Cell_To_Be_Moved
    mov destCellIndexP1, bl     ; cursor index

    ; check if the destination is from the same color (let it in horse)
    ; will reduce running time
    mov bh, 0
    mov bl, destCellIndexP1
    mov al, grid[bx]
    cmp al, Black_Pawm ; if pawm or above -> invalid
    jb movePlayerOne
    
    ; set the source with the last cell selected (source = destination)
    mov sourceCellIndexP1, bl
    mov destCellIndexP1, noCellSelected
    jmp sourceP1IsSet

movePlayerOne:
    mov al, sourceCellIndexP1
    mov sourceCellIndex, al
    mov al, destCellIndexP1
    mov destCellIndex, al
    call movePlayerPiece

    ; ; testing
    ; mov dl, Cell_To_Be_Moved
    ; add dl, 30h
    ; mov ah,2
    ; int 21h

clearSelcP1:
    ; Clear selection
    mov sourceCellIndexP1, noCellSelected
    mov destCellIndexP1, noCellSelected


sourceP1IsSet:

    ret

setPlayerOneSelection   ENDP

setPlayerTwoSelection   PROC    FAR

    ; check for source selection: if    -1 -> set it with the current cursor index
    ;                             else  set destination with the current cursor index

;     cmp si, 1
;     jne playerTwo

; playerTwo:

    ; pusha
    ; ; testing
    ; mov dl, '$'
    ; mov ah,2
    ; int 21h
    ; popa

    pusha
    call getCursorP2 ; stored in Cell_To_Be_Moved
    popa

    cmp sourceCellIndexP2, noCellSelected
    jne setDestP2
    mov bh, 0
    mov bl, Cell_To_Be_Moved
    cmp grid[bx], 0             ; if selected cell is empty in first selection -> clear
    je maxclearSelcP2           ; max jump
    jmp contClearSelcP2
maxclearSelcP2:
    jmp clearSelcP2
contClearSelcP2:
    mov sourceCellIndexP2, bl; cursor index
    jmp sourceP2IsSet

setDestP2:
    mov bl, Cell_To_Be_Moved
    mov destCellIndexP2, bl; cursor index

    ; ; check if the destination is from the same color (let it in horse)
    ; ; will reduce running time
    ; mov bh, 0
    ; mov bl, destCellIndexP2
    ; mov al, grid[bx]
    ; cmp al, Black_Pawm ; if pawm or above -> invalid
    ; jb movePlayerTwo
    
    ; ; set the source with the last cell selected (source = destination)
    ; mov sourceCellIndexP2, bl
    ; mov destCellIndexP2, noCellSelected
    ; jmp sourceP2IsSet

movePlayerTwo:
    mov al, sourceCellIndexP2
    mov sourceCellIndex, al
    mov al, destCellIndexP2
    mov destCellIndex, al
    call movePlayerPiece

    ; ; testing
    ; mov dl, Cell_To_Be_Moved
    ; add dl, 30h
    ; mov ah,2
    ; int 21h

clearSelcP2:
    ; Clear selection
    mov sourceCellIndexP2, noCellSelected
    mov destCellIndexP2, noCellSelected


sourceP2IsSet:

    ret

setPlayerTwoSelection   ENDP


; TODO clear possible moves
; TODO draw possible moves

END