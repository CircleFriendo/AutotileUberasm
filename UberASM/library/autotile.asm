

!map16_filter = $10   ; active on map16 pages 10-1F, 30-3F, etc.

;;; Scratch space usage:
;;; $00     current map16 page
;;; $01-02  replacement tile
;;; $03     screen number
;;; 
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


; if the block to the left is from the correct map16 page,
; ORA in the bit that designated a block to the left    
macro checkL()
    LDY $06
    %shift_L()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!L_bit : STA $01
    +
endmacro

macro checkDL()
    LDY $06
    %shift_DL()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!DL_bit : STA $01
    + 
endmacro
 
macro checkD()
    LDY $06
    %shift_D()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!D_bit : STA $01
    + 
endmacro

macro checkDR()
    LDY $06
    %shift_DR()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!DR_bit : STA $01
    + 
endmacro

macro checkR()
    LDY $06
    %shift_R()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!R_bit : STA $01
    +
endmacro

macro checkUR()
    LDY $06
    %shift_UR()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!UR_bit : STA $01
    +
endmacro

macro checkU()
    LDY $06
    %shift_U()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!U_bit : STA $01
    + 
endmacro

macro checkUL()
    LDY $06
    %shift_UL()
    LDA [$6E],y : CMP $00 : BNE +
        LDA $01 : ORA #!UL_bit : STA $01
    +
endmacro


    
macro checkLalt()
    LDY $06
    %shift_Lalt()
    LDA [$08],y : CMP $00 : BNE +
        LDA $01 : ORA #!L_bit : STA $01
    +
endmacro

macro checkDLalt()
    LDY $06
    %shift_DLalt()
    LDA [$08],y : CMP $00 : BNE +
        LDA $01 : ORA #!DL_bit : STA $01
    + 
endmacro

macro checkDRalt()
    LDY $06
    %shift_DRalt()
    LDA [$08],y : CMP $00 : BNE +
        LDA $01 : ORA #!DR_bit : STA $01
    + 
endmacro

macro checkRalt()
    LDY $06
    %shift_Ralt()
    LDA [$08],y : CMP $00 : BNE +
        LDA $01 : ORA #!R_bit : STA $01
    +
endmacro

macro checkURalt()
    LDY $06
    %shift_URalt()
    LDA [$08],y : CMP $00 : BNE +
        LDA $01 : ORA #!UR_bit : STA $01
    +
endmacro

macro checkULalt()
    LDY $06
    %shift_ULalt()
    LDA [$08],y : CMP $00 : BNE +
        LDA $01 : ORA #!UL_bit : STA $01
    +
endmacro



macro move_screen_right()
    REP #$20
        LDA $6B
        CLC : ADC $13D7|!addr
        STA $6B
        STA $6E
    SEP #$20
endmacro

macro set_alternate_page_left()
    REP #$20
        LDA $6B
        SEC : SBC $13D7|!addr
        STA $08
    SEP #$20
endmacro

macro set_alternate_page_right()
    REP #$20
        LDA $6B
        CLC : ADC $13D7|!addr
        STA $08
    SEP #$20
endmacro



run:
    
    REP #$20
        LDA #$C800 : STA $6B : STA $6E
    SEP #$20
    
    LDA $70 : STA $0A  ;; set up [$08] for the table at $7FC800
    
    REP #$10
    
    
    STZ $03
    
    --  LDY #$0011     ; skip first row
        ;process middle tiles
        -   TYA : AND #$0F : CMP #$0F : BNE +
                INY : INY ; skip right and left column
            +
            JSR ProcessTile
            INY : CPY #$019F : BNE -     ; skip last row
        
        ;process top tiles
        LDY #$0001
        -   JSR ProcessTopTile            
            INY : CPY #$000F : BNE -
        
        ;process bottom tiles
        LDY #$01A0
        -   JSR ProcessBottomTile            
            INY : CPY #$01AF : BNE -
        
        ;process left tiles
        LDY #$0010
        -   JSR ProcessLeftTile
            %shift_D()
            CPY #$01A0 : BNE -
        
        ;process right tiles
        LDY #$001F
        -   JSR ProcessRightTile
            %shift_D()
            CPY #$01AF : BNE -
        
        JSR ProcessCornerTiles
            
        %move_screen_right()
        LDA $03 : INC : STA $03 : CMP $5D : BNE --
    
    SEP #$30
    RTL

     
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
        %set_alternate_page_left()
        
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

ProcessRightTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_right()
        
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

ProcessTopLeftTile:
    LDA [$6B],y : CMP #$00 : BNE -
    LDA [$6E],y : STA $00 : AND #!map16_filter : BEQ -
    
        STZ $01 : STZ $02  ; initialize replacement tile
        STY $06
        %set_alternate_page_left()
        
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
        %set_alternate_page_left()
        
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
        %set_alternate_page_right()
        
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
        %set_alternate_page_right()
        
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
    
    LDY #$01A0
    JSR ProcessBottomLeftTile
    
    LDY #$01AF
    JSR ProcessBottomRightTile
    
    RTS
   

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
