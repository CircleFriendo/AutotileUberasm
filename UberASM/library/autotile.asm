

!map16_filter = $10   ; active on map16 pages 10-1F, 30-3F, etc.

;;; Scratch space usage:
;;; $00     current map16 page
;;; $01-02  replacement tile
;;; $03     screen number
;;; $04-05  ending Y for loops
;;; $06-07  Y backup
;;; $08-$0A alternate page address

!L_bit  = $01
!DL_bit = $40
!D_bit  = $08
!DR_bit = $80
!R_bit  = $02
!UR_bit = $20
!U_bit  = $04
!UL_bit = $10

macro shift_U()
    REP #$20 : TYA : SEC : SBC #$0010 : TAY : SEP #$20
endmacro

macro shift_D()
    REP #$20 : TYA : CLC : ADC #$0010 : TAY : SEP #$20
endmacro

macro shift_L()
    DEY
endmacro
   
macro shift_R()
	INY
endmacro

macro shift_UL()
    REP #$20 : TYA : SEC : SBC #$0011 : TAY : SEP #$20
endmacro

macro shift_UR()
    REP #$20 : TYA : SEC : SBC #$000F : TAY : SEP #$20
endmacro

macro shift_DL()
    REP #$20 : TYA : CLC : ADC #$000F : TAY : SEP #$20
endmacro

macro shift_DR()
    REP #$20 : TYA : CLC : ADC #$0011 : TAY : SEP #$20
endmacro

;;; alternate page macros add or subtract $10 to compensate for
;;; screen boundaries

macro shift_Lalt()
    REP #$20 : TYA : CLC : ADC #$000F : TAY : SEP #$20
endmacro
   
macro shift_Ralt()
	REP #$20 : TYA : SEC : SBC #$000F : TAY : SEP #$20
endmacro

macro shift_ULalt()
    DEY
endmacro

macro shift_URalt()
    REP #$20 : TYA : SEC : SBC #$001F : TAY : SEP #$20
endmacro

macro shift_DLalt()
    REP #$20 : TYA : CLC : ADC #$001F : TAY : SEP #$20
endmacro

macro shift_DRalt()
    INY
endmacro


;; Vert level alternate shift macros

macro shift_URValt()
    REP #$20 : TYA : CLC : ADC #$00F1 : TAY : SEP #$20
endmacro

macro shift_UValt()
    REP #$20 : TYA : CLC : ADC #$00F0 : TAY : SEP #$20
endmacro

macro shift_ULValt()
    REP #$20 : TYA : CLC : ADC #$00EF : TAY : SEP #$20
endmacro


macro shift_DRValt()
    REP #$20 : TYA : SEC : SBC #$00EF : TAY : SEP #$20
endmacro

macro shift_DValt()
    REP #$20 : TYA : SEC : SBC #$00F0 : TAY : SEP #$20
endmacro

macro shift_DLValt()
    REP #$20 : TYA : SEC : SBC #$00F1 : TAY : SEP #$20
endmacro

macro shift_URseam()
    REP #$20 : TYA : CLC : ADC #$00E1 : TAY : SEP #$20
endmacro

macro shift_Rseam()
    REP #$20 : TYA : CLC : ADC #$00F1 : TAY : SEP #$20
endmacro

macro shift_DRseam()
    REP #$20 : TYA : CLC : ADC #$0101 : TAY : SEP #$20
endmacro

macro shift_DLseam()
    REP #$20 : TYA : SEC : SBC #$00E1 : TAY : SEP #$20
endmacro

macro shift_Lseam()
    REP #$20 : TYA : SEC : SBC #$00F1 : TAY : SEP #$20
endmacro

macro shift_ULseam()
    REP #$20 : TYA : SEC : SBC #$0101 : TAY : SEP #$20
endmacro

macro shift_ULValtseam()
    DEY
endmacro

macro shift_URValtseam()
    REP #$20 : TYA : CLC : ADC #$01E1 : TAY : SEP #$20
endmacro

macro shift_DLValtseam()
    REP #$20 : TYA : SEC : SBC #$01E1 : TAY : SEP #$20
endmacro

macro shift_DRValtseam()
    INY
endmacro


; if the block to the left is from the correct map16 page,
; ORA in the bit that designated a block to the left    
macro checkL()
    LDY $06
    %shift_L()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!L_bit : STA $01
    ?+
endmacro

macro checkDL()
    LDY $06
    %shift_DL()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DL_bit : STA $01
    ?+ 
endmacro
 
macro checkD()
    LDY $06
    %shift_D()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!D_bit : STA $01
    ?+ 
endmacro

macro checkDR()
    LDY $06
    %shift_DR()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DR_bit : STA $01
    ?+ 
endmacro

macro checkR()
    LDY $06
    %shift_R()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!R_bit : STA $01
    ?+
endmacro

macro checkUR()
    LDY $06
    %shift_UR()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UR_bit : STA $01
    ?+
endmacro

macro checkU()
    LDY $06
    %shift_U()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!U_bit : STA $01
    ?+ 
endmacro

macro checkUL()
    LDY $06
    %shift_UL()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UL_bit : STA $01
    ?+
endmacro


    
macro checkLalt()
    LDY $06
    %shift_Lalt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!L_bit : STA $01
    ?+
endmacro

macro checkDLalt()
    LDY $06
    %shift_DLalt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DL_bit : STA $01
    ?+ 
endmacro

macro checkDRalt()
    LDY $06
    %shift_DRalt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DR_bit : STA $01
    ?+ 
endmacro

macro checkRalt()
    LDY $06
    %shift_Ralt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!R_bit : STA $01
    ?+
endmacro

macro checkURalt()
    LDY $06
    %shift_URalt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UR_bit : STA $01
    ?+
endmacro

macro checkULalt()
    LDY $06
    %shift_ULalt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UL_bit : STA $01
    ?+
endmacro

; vertical level check macros

macro checkURValt()
    LDY $06
    %shift_URValt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UR_bit : STA $01
    ?+
endmacro

macro checkUValt()
    LDY $06
    %shift_UValt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!U_bit : STA $01
    ?+
endmacro

macro checkULValt()
    LDY $06
    %shift_ULValt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UL_bit : STA $01
    ?+
endmacro

macro checkDRValt()
    LDY $06
    %shift_DRValt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DR_bit : STA $01
    ?+
endmacro

macro checkDValt()
    LDY $06
    %shift_DValt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!D_bit : STA $01
    ?+
endmacro

macro checkDLValt()
    LDY $06
    %shift_DLValt()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DL_bit : STA $01
    ?+
endmacro

; vertical level seam macros

macro checkDRseam()
    LDY $06
    %shift_DRseam()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DR_bit : STA $01
    ?+
endmacro

macro checkRseam()
    LDY $06
    %shift_Rseam()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!R_bit : STA $01
    ?+
endmacro

macro checkURseam()
    LDY $06
    %shift_URseam()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UR_bit : STA $01
    ?+
endmacro

macro checkDLseam()
    LDY $06
    %shift_DLseam()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DL_bit : STA $01
    ?+
endmacro

macro checkLseam()
    LDY $06
    %shift_Lseam()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!L_bit : STA $01
    ?+
endmacro

macro checkULseam()
    LDY $06
    %shift_ULseam()
    LDA [$6E],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UL_bit : STA $01
    ?+
endmacro

macro checkULValtseam()
    LDY $06
    %shift_ULValtseam()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UL_bit : STA $01
    ?+
endmacro

macro checkURValtseam()
    LDY $06
    %shift_URValtseam()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!UR_bit : STA $01
    ?+
endmacro

macro checkDLValtseam()
    LDY $06
    %shift_DLValtseam()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DL_bit : STA $01
    ?+
endmacro

macro checkDRValtseam()
    LDY $06
    %shift_DRValtseam()
    LDA [$08],y : CMP $00 : BNE ?+
        LDA $01 : ORA #!DR_bit : STA $01
    ?+
endmacro


; screen macros

macro move_next_screen()
    REP #$20
        LDA $6B
        CLC : ADC $13D7|!addr
        STA $6B
        STA $6E
    SEP #$20
endmacro

macro set_alternate_page_prev()
    REP #$20
        LDA $6B
        SEC : SBC $13D7|!addr
        STA $08
    SEP #$20
endmacro

macro set_alternate_page_next()
    REP #$20
        LDA $6B
        CLC : ADC $13D7|!addr
        STA $08
    SEP #$20
endmacro



run:
    
    REP #$20 : LDA #$C800 : STA $6B : STA $6E : SEP #$20
    
    LDA $70 : STA $0A  ;; set up [$08] for the table at $7FC800
    
    REP #$10
    
    LDA $5B : AND #$03 : BNE +
        JSR ProcessHorizontal
        BRA ++
    + JSR ProcessVertical
    
    ++ SEP #$30 
    RTL
    
ProcessHorizontal:
    
    JSR ProcessLayer  ; process layer 1
    
    LDA $0BF5|!addr : ASL : BCC +   ; Layer 2 active
    
        REP #$20    ; calculate layer 2 map16
            AND #$003E : TAX
            
            LDA.l Layer2Offset,x : STA $6B : STA $6E
        SEP #$20
        
        LDA $70 : STA $0A  ;; set up [$08] for the table at $7FC800
        
        ;REP #$10
        
        JSR ProcessLayer
    
    + RTS
    
    
Layer2Offset:
    dw $E300, $E400, $E330, $E400, $E3A0, $E3C0, $E480, $E380
    dw $E4E0, $E380, $E560, $E390, $E540, $E400, $E580, $E400
    dw $E5C0, $E3C0, $E660, $E3D0, $E6F0, $E400, $E800, $E3F0
    dw $E990, $E400, $ED40, $E400
    
ProcessLayer:   
    STZ $03
    
ProcessScreen:  
        
        ;process middle tiles
        LDY #$0011     ; skip first row
        REP #$20
            LDA $13D7|!addr : SEC : SBC #$0011 : STA $04
        SEP #$20
        -   TYA : AND #$0F : CMP #$0F : BNE +
                INY : INY ; skip right and left column
            +
            JSR ProcessTile
            INY : CPY $04 : BNE -     ; skip last row
        
        ;process top tiles
        LDY #$0001
        -   JSR ProcessTopTile            
            INY : CPY #$000F : BNE -
        
        ;process bottom tiles
        REP #$20 
            LDA $13D7|!addr : SEC : SBC #$000F : TAY
            LDA $13D7|!addr : DEC : STA $04
        SEP #$20
        -   JSR ProcessBottomTile            
            INY : CPY $04 : BNE -
        
        ;process left tiles
        LDY #$0010
        REP #$20
            LDA $13D7|!addr : SEC : SBC #$0010 : STA $04
        SEP #$20
        -   LDA $03 : BEQ +
                JSR ProcessLeftTile
                BRA ++
            +
                JSR ProcessLeftEdgeTile
            ++
            %shift_D()
            CPY $04 : BNE -
        
        ;process right tiles
        LDY #$001F
        REP #$20 : LDA $13D7|!addr : DEC : STA $04 : SEP #$20
        -   LDA $03 : INC : CMP $5D : BEQ +
                JSR ProcessRightTile
                BRA ++
            +
                JSR ProcessRightEdgeTile
            ++
            %shift_D()
            CPY $04 : BNE -
        
        JSR ProcessCornerTiles
            
        %move_next_screen()
        LDA $03 : INC : STA $03 : CMP $5D : BEQ + 
            JMP ProcessScreen
        +
        
    SEP #$30
         
    RTS
 
ProcessVertical:
    REP #$20 : LDA #$0200 : STA $13D7|!addr : SEP #$20
    
    JSR ProcessVLayer  ; process layer 1
    
    LDA $5B : AND #$02 : BEQ +   ; Layer 2 active
        
        REP #$20 : LDA #$E400 : STA $6B : STA $6E : SEP #$20
        LDA $70 : STA $0A  ;; set up [$08] for the table at $7FC800
        
        ;REP #$10
        
        JSR ProcessVLayer
    
    + RTS
 
ProcessVLayer:
    STZ $03
    
ProcessVScreen: 
    ;left half
        ;process middle tiles
        LDY #$0011     ; skip first row
        -   TYA : AND #$0F : CMP #$0F : BNE +
                INY : INY ; skip right and left column
            +
            JSR ProcessTile
            INY : CPY #$00EF : BNE -     ; skip last row
    
        ;process top tiles
        LDY #$0001
        -   LDA $03 : BEQ +
                JSR ProcessVTopTile
                BRA ++
            +
                JSR ProcessVTopEdgeTile
            ++               
            INY : CPY #$000F : BNE -
    
        ;process bottom tiles
        LDY #$00F1
        -   LDA $03 : INC : CMP $5D : BEQ +
                JSR ProcessVBottomTile
                BRA ++
            +
                JSR ProcessVBottomEdgeTile
            ++
            INY : CPY #$00FF : BNE -
        
         ;process left tiles
        LDY #$0010
        -   
            JSR ProcessVLeftTile
            %shift_D()
            CPY #$00F0 : BNE -
        
         ;process right seam tiles
        LDY #$001F
        -   
            JSR ProcessVRightSeamTile
            %shift_D()
            CPY #$00FF : BNE -
        
        
        
    ; right half
        ;process middle tiles
        LDY #$0111     ; skip first row
        -   TYA : AND #$0F : CMP #$0F : BNE +
                INY : INY ; skip right and left column
            +
            JSR ProcessTile
            INY : CPY #$01EF : BNE -     ; skip last row
    
        ;process top tiles
        LDY #$0101
        -   LDA $03 : BEQ +
                JSR ProcessVTopTile
                BRA ++
            +
                JSR ProcessVTopEdgeTile
            ++               
            INY : CPY #$010F : BNE -
        
        ;process bottom tiles
        LDY #$01F1
        -   LDA $03 : INC : CMP $5D : BEQ +
                JSR ProcessVBottomTile
                BRA ++
            +
                JSR ProcessVBottomEdgeTile
            ++
            INY : CPY #$01FF : BNE -
    
         ;process right tiles
        LDY #$011F
        -   
            JSR ProcessVRightTile
            %shift_D()
            CPY #$01FF : BNE -
    
         ;process left seam tiles
        LDY #$0110
        -   
            JSR ProcessVLeftSeamTile
            %shift_D()
            CPY #$01F0 : BNE -
    
        JSR ProcessVCornerTiles
    
        %move_next_screen()
        LDA $03 : INC : STA $03 : CMP $5D : BEQ + 
            JMP ProcessVScreen
        +
    
    - RTS
 
 
ProcessTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDR()
        %checkR()
        %checkUR()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    - RTS

ProcessTopTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDR()
        %checkR()
        ;%checkUR()  ; skip these--there's nothing above us
        ;%checkU()
        ;%checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS
    
ProcessBottomTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %checkL()
        ;%checkDL()
        ;%checkD()
        ;%checkDR()
        %checkR()
        %checkUR()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS
    
ProcessLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        %checkLalt()  ;
        %checkDLalt() ;
        %checkD()
        %checkDR()
        %checkR()
        %checkUR()
        %checkU()
        %checkULalt() ;
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessLeftEdgeTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        ;%set_alternate_page_left()
        
        ;%checkLalt()  ;
        ;%checkDLalt() ;
        %checkD()
        %checkDR()
        %checkR()
        %checkUR()
        %checkU()
        ;%checkULalt() ;
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDRalt()
        %checkRalt()
        %checkURalt()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessRightEdgeTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        ;%set_alternate_page_right()
        
        %checkL()
        %checkDL()
        %checkD()
        ;%checkDRalt()
        ;%checkRalt()
        ;%checkURalt()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessTopLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        %checkLalt()  ;
        %checkDLalt() ;
        %checkD()
        %checkDR()
        %checkR()
        ;%checkUR()
        ;%checkU()
        ;%checkULalt() ;
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessBottomLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        %checkLalt()  ;
        ;%checkDLalt() ;
        ;%checkD()
        ;%checkDR()
        %checkR()
        %checkUR()
        %checkU()
        %checkULalt() ;
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessTopRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDRalt()
        %checkRalt()
        ;%checkURalt()
        ;%checkU()
        ;%checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS
    
ProcessBottomRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        %checkL()
        ;%checkDL()
        ;%checkD()
        ;%checkDRalt()
        %checkRalt()
        %checkURalt()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS
 
ProcessCornerTiles:
    LDY #$0000
    JSR ProcessTopLeftTile
    
    LDY #$000F
    JSR ProcessTopRightTile
    
    REP #$20
        LDA $13D7|!addr : SEC : SBC #$0010 : TAY
    SEP #$20
    JSR ProcessBottomLeftTile
    
    REP #$20
        LDA $13D7|!addr : DEC : TAY
    SEP #$20
    JSR ProcessBottomRightTile
    
    - RTS

; Vertical edges work differently

ProcessVTopTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %set_alternate_page_prev()
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDR()
        %checkR()
        %checkURValt()
        %checkUValt()
        %checkULValt()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS

ProcessVBottomTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %set_alternate_page_next()
        
        %checkL()
        %checkDLValt()
        %checkDValt()
        %checkDRValt()
        %checkR()
        %checkUR()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS

ProcessVLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        ;%checkL()
        ;%checkDL()
        %checkD()
        %checkDR()
        %checkR()
        %checkUR()
        %checkU()
        ;%checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS   

ProcessVRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %checkL()
        %checkDL()
        %checkD()
        ;%checkDR()
        ;%checkR()
        ;%checkUR()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS   

ProcessVTopEdgeTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        ;%set_alternate_page_prev()
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDR()
        %checkR()
        ;%checkURValt()
        ;%checkUValt()
        ;%checkULValt()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS

ProcessVBottomEdgeTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        ;%set_alternate_page_next()
        
        %checkL()
        ;%checkDLValt()
        ;%checkDValt()
        ;%checkDRValt()
        %checkR()
        %checkUR()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS

ProcessVRightSeamTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %checkL()
        %checkDL()
        %checkD()
        %checkDRseam()
        %checkRseam()
        %checkURseam()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS   

ProcessVLeftSeamTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        
        %checkLseam()
        %checkDLseam()
        %checkD()
        %checkDR()
        %checkR()
        %checkUR()
        %checkU()
        %checkULseam()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
        
    - RTS   

ProcessVTopLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        ;%checkL()  
        ;%checkDL() 
        %checkD()
        %checkDR()
        %checkR()
        %checkURValt()
        %checkUValt()
        ;%checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVTopRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        %checkL()  
        %checkDL() 
        %checkD()
        ;%checkDR()
        ;%checkR()
        ;%checkURValt()
        %checkUValt()
        %checkULValt()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVBottomLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        ;%checkL()  
        ;%checkDL() 
        %checkDValt()
        %checkDRValt()
        %checkR()
        %checkUR()
        %checkU()
        ;%checkULValt()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVBottomRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        %checkL()  
        %checkDLValt() 
        %checkDValt()
        ;%checkDRValt()
        ;%checkR()
        ;%checkUR()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVTopLeftSeamTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        %checkLseam()  
        %checkDLseam() 
        %checkD()
        %checkDR()
        %checkR()
        %checkURValt()
        %checkUValt()
        %checkULValtseam()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVTopRightSeamTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_prev()
        
        %checkL()  
        %checkDL() 
        %checkD()
        %checkDRseam()
        %checkRseam()
        %checkURValtseam()
        %checkUValt()
        %checkULValt()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVBottomLeftSeamTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        %checkLseam()  
        %checkDLValtseam() 
        %checkDValt()
        %checkDRValt()
        %checkR()
        %checkUR()
        %checkU()
        %checkULseam()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS

ProcessVBottomRightSeamTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_next()
        
        %checkL()  
        %checkDLValt() 
        %checkDValt()
        %checkDRValtseam()
        %checkRseam()
        %checkURseam()
        %checkU()
        %checkUL()
        
        LDY $06
        LDX $01 : LDA.l Autotiles,x : STA [$6B],y
    
    - RTS



ProcessVCornerTiles:
    ; corners
    LDY #$0000
    JSR ProcessVTopLeftTile
    
    LDY #$010F
    JSR ProcessVTopRightTile
    
    LDY #$00F0
    JSR ProcessVBottomLeftTile
    
    LDY #$01FF
    JSR ProcessVBottomRightTile
    
    ; seams
    
    LDY #$0100
    JSR ProcessVTopLeftSeamTile
    
    LDY #$000F
    JSR ProcessVTopRightSeamTile
    
    LDY #$01F0
    JSR ProcessVBottomLeftSeamTile
    
    LDY #$00FF
    JSR ProcessVBottomRightSeamTile
    
    - RTS

Autotiles:
    
db $00,$03,$01,$02, $30,$36,$34,$35, $10,$16,$14,$15, $20,$26,$24,$25
db $00,$03,$01,$02, $30,$33,$34,$1A, $10,$16,$14,$15, $20,$2B,$24,$05 
db $00,$03,$01,$02, $30,$36,$31,$1B, $10,$16,$14,$15, $20,$26,$2A,$08 
db $00,$03,$01,$02, $30,$33,$31,$32, $10,$16,$14,$15, $20,$2B,$2A,$18 

db $00,$03,$01,$02, $30,$36,$34,$35, $10,$13,$14,$0A, $20,$3B,$24,$07 
db $00,$03,$01,$02, $30,$33,$34,$1A, $10,$13,$14,$0A, $20,$23,$24,$27 
db $00,$03,$01,$02, $30,$36,$31,$1B, $10,$13,$14,$0A, $20,$3B,$2A,$04 
db $00,$03,$01,$02, $30,$33,$31,$32, $10,$13,$14,$0A, $20,$23,$2A,$17 

db $00,$03,$01,$02, $30,$36,$34,$35, $10,$16,$11,$0B, $20,$26,$3A,$06 
db $00,$03,$01,$02, $30,$33,$34,$1A, $10,$16,$11,$0B, $20,$2B,$3A,$09 
db $00,$03,$01,$02, $30,$36,$31,$1B, $10,$16,$11,$0B, $20,$26,$21,$29 
db $00,$03,$01,$02, $30,$33,$31,$32, $10,$16,$11,$0B, $20,$2B,$21,$19 

db $00,$03,$01,$02, $30,$36,$34,$35, $10,$13,$11,$12, $20,$3B,$3A,$38 
db $00,$03,$01,$02, $30,$33,$34,$1A, $10,$13,$11,$12, $20,$23,$3A,$37 
db $00,$03,$01,$02, $30,$36,$31,$1B, $10,$13,$11,$12, $20,$3B,$21,$39 
db $00,$03,$01,$02, $30,$33,$31,$32, $10,$13,$11,$12, $20,$23,$21,$22 
