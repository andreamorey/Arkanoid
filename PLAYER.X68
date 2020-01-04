; -----------------------------------------------------------------------------
;           PLAYER
; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER TO LEVEL 1
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #PINPOSX1,PPOSX
            MOVE.W  #PINWIDTH1,PWIDTH
            RTS
; -----------------------------------------------------------------------------
PLRLEV2
; INITIALIZES THE PLAYER TO LEVEL 2
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #PINPOSX2,PPOSX
            MOVE.W  #PINWIDTH2,PWIDTH
            RTS        
; -----------------------------------------------------------------------------
PLRLEV3
; INITIALIZES THE PLAYER TO LEVEL 3
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #PINPOSX3,PPOSX
            MOVE.W  #PINWIDTH3,PWIDTH
            RTS     
; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE POSITION, LIVES AND SCORE OF THE PLAYER
; INPUT     - NONE
; OUTPUT    - NONE
; MODIFIES  - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D1-D2,-(A7)
            MOVE.B  KBDVAL,D1  
            ROR.B   #1,D1                   ;IZQUIERDA
            BCC     .RIGHTKEY               ;CUANDO C = 0
            ;CUANDO PPOSX ES 0 NO TINENE QUE MOVERSE MAS A LA IZQ
            MOVE.W  PPOSX,D2
            CMP.W    #0,D2
            BLE     .RIGHTKEY
            SUB.W   #PMOVE,(PPOSX)
.RIGHTKEY
            LSR.B   #1,D1                   
            ROR.B   #1,D1                   
            BCC     .END
            ;CUANDO PPOSX ES IGUAL A SCRWIDTH+PWIDTH NO TIENE QUE MOVERSE A LA DERECHA
            MOVE.W  PPOSX,D2
            ADD.W   PWIDTH,D2 

            CMP.W    #SCRCTRL-SCRLWIDTH,D2
            BGE     .END
            ADD.W   #PMOVE,PPOSX
.END
            MOVEM.L (A7)+,D1-D2
            RTS

; -----------------------------------------------------------------------------
PPLOT
; PLOTS THE PLAYER ITS LIFE AND THE SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0-D5/A1,-(A7)
            ;PLOT THE PLATAFORM
            UTLSPEN #PCOLOR 
            UTLSFIL #PCOLOR
            MOVE.W  PPOSX,D1
            MOVE.W  #PPOSY,D2                    
            MOVE.W  PPOSX,D3
            MOVE.W  PWIDTH,D4 
            ADD.W   D4,D3
            MOVE.W  #PPOSY+PHEIGHT,D4
            MOVE.W  #87,D0
            TRAP    #15
            
            ;PLOT LIFE
            MOVE.W  PLIVES,D5
            BEQ     .END
            UTLSPEN #0 
            UTLSFIL #LIVECOLOR
            SUB.W   #1,D5             
            MOVE.B  #87,D0
            MOVE.W  #LIVEPOSX,D1
            MOVE.W  D1,D3
            ADD.W   #LIVEWIDTH,D3
            MOVE.W  #LIVEPOSY,D2
            MOVE.W  D2,D4
            ADD.W   #LIVEHEIGHT,D4
.LIFES           
            TRAP    #15
            MOVE.W  D3,D1
            ADD.W   #LIVEWIDTH,D3
            DBRA    D5,.LIFES
            
            ;PLOT SCORE
            UTLLOCT PSCORETX,PSCORETY  
            UTLSFIL #$00000000
            LEA     .TXTSCORE,A1             
            MOVE.W  PSCORE,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ;PLOT LEVEL
            UTLLOCT PSCORETX,PSCORETY+2  
            UTLSFIL #$00000000
            LEA     .TXTLEVEL,A1              
            MOVE.W  LEVEL,D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ;PLOT NAME
            UTLLOCT PSCORETX,PSCORETY+4  
            UTLSFIL #$00000000
            LEA     PNAME,A1 
            MOVE.B  #14,D0
            TRAP    #15

.END            
            MOVEM.L (A7)+,D0-D5/A1
            RTS
            
.TXTSCORE   DC.B    'SCORE: ',0
.TXTLEVEL   DC.B    'LEVEL: ',0
            DS.W    0

*~Font name~Courier New~
*~Font size~16~
*~Tab type~0~
*~Tab size~4~
