; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,STACUR  
            MOVE.W  #STAINTR,STANEXT  
            RTS
; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  STANEXT,D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,STACUR 
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  STACUR,D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAEMPTY,STASAVEI,STASAVEI 
.UPDTBL     DC.L    STAINTRU,STASPACEU,STAPLAYU,STAFINU,STAFINU
; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  STANEXT,D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0         
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAPLAYP,STAGOVRP,STAWINP
; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS
; -----------------------------------------------------------------------------
STASAVEI
; SAVES THE INFORMATION OF THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1/A0-A2,-(A7)
            
            LEA.L   RNKTABLE,A1
            MOVE.W  POSRNK,D1
            CMP.L   #$FFFFFFFF,(A1)         
            BEQ     .LOAD                   ; IF THE MATRIX IS EMPTY
            
            ; MOVES ALL THE ELEMENTS AT THE RIGHT 
            MOVE.L  A1,A0            
            MOVE.L  A1,A2
            ADDA.W  D1,A2
            SUBA.W   #10,A2
            ADDA.W  D1,A0                   
            DIVU    #10,D1
            SUBQ.W  #1,D1
.LOOP                   
            MOVE.W  #9,D0                   ; 10 COLUMNS
.MOVER
            MOVE.B  (A2)+,(A0)+             ; A2 = OLD POS, A0 = NEW POS 
            DBRA    D0,.MOVER
            SUBA.L  #20,A2
            SUBA.L  #20,A0
            DBRA    D1,.LOOP
.LOAD                                       ; SAVES THE NAME AT ROW = 1
            MOVE.W  PSCORE,(A1)
            ADDA.L  #2,A1
            MOVE.W  #7,D0                   ; NAME = 8 BYTES
            LEA.L   PNAME,A0                 
.NAME
            MOVE.B  (A0)+,(A1)+
            DBRA    D0,.NAME          
            MOVEM.L (A7)+,D0-D1/A0-A2
        

            JSR     UTLWRFILE               ;ESCRIBIMOS EN EL FICHERO
            RTS
; -----------------------------------------------------------------------------
STAPLAYI    ;DEL NIVEL1, COMIENZO

; PLAY STATE INITIALIZATION
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR PLRINIT
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A6,-(A7)
            MOVE.W  #BINPOSX,BPOSX1
            MOVE.W  #BINPOSY,BPOSY2
            MOVE.W  #BINPOSX+BDIAMET,BPOSX2
            MOVE.W  #BINPOSY-BDIAMET,BPOSY1
            
            MOVEM.L (A7)+,D0-D7/A0-A6
            RTS
; -----------------------------------------------------------------------------
STASPACEU
; WAITS FOR SPACE TO BE PRESSED, AND BEGIN THE GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #PINPOSX1,PPOSX
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAPLAY,STANEXT
.END        
            RTS
; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A6,-(A7)
            JSR     PLRUPD
            JSR     BUPD    
            JSR     BLUPD
            MOVEM.L (A7)+,D0-D7/A0-A6          
            RTS
; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A6,-(A7)
            JSR     BPLOT
            JSR     BLPLOT
            JSR     PPLOT
            JSR     UTLSREENP
            JSR     UTLREADRNK
            MOVEM.L (A7)+,D0-D7/A0-A6 
            RTS
; -----------------------------------------------------------------------------
STAINTRI   
; PARA QUE EL SCORE LA VIDA SE VUELVAN A REINICIAR

; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     DMMINIT
            JSR     UTLREADFILE
            JSR     UTLINTRI
            RTS

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            UTLSNDS .SOUND,#1
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STASPACE,STANEXT
            JSR     UTLINTRI
            UTLSIZC #INTPRSC,TXSSIZE
            UTLLOCT 18,25  
            JSR     UTLSVNAME
            UTLSNDST
            JSR     PLRINIT
            JSR     BLINIT
            JSR     BINIT
            MOVE.W  #PINLIVE,PLIVES
            CLR.W   PSCORE              
.END        
            RTS
.SOUND      DC.L    'start largo.wav',0

           
; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
           JSR      UTLINTRI
            MOVEM.L D0-D2/A1,-(A7)
            ;START
            UTLLOCT INTPRSX,INTPRSY
            UTLSIZC #INTPRSC,TXSSIZE
            LEA     .PRSSTR,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D2/A1
            RTS
.PRSSTR     DC.B    'PUSH FIRE TO START',0
            DS.W    0
           
; -----------------------------------------------------------------------------
STAFINU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;visualiza el fichero
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            UTLSNDST
            MOVE.W  #STAINTR,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D2,-(A7)
            ;GAME OVER TEXT
            UTLLOCT GOVERX,GOVERY            
            UTLSIZC #GOVERC,TXBSIZE
            UTLSFIL #$00000000
            LEA     .GOVSTR,A1              ;PONE EL TEXTO
            MOVE.B  #14,D0
            TRAP    #15

            MOVEM.L (A7)+,A1/D0-D2
            RTS
.GOVSTR     DC.B    'GAME OVER',0
            DS.W    0
            
; -----------------------------------------------------------------------------
STAWINP
; WIN STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            ;TITULO
            UTLLOCT INTTITX-1,INTTITY      
            UTLSIZC #GREEN,TXBSIZE
            LEA     .TITSTR,A1            
            MOVE.B  #14,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D2/A1
            RTS
.TITSTR     DC.B    'CONGRATULATIONS, YOU WON!',0
            DS.W    0









*~Font name~Courier New~
*~Font size~16~
*~Tab type~0~
*~Tab size~4~
