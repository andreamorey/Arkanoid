;-----------------------------------------------------------
;           BLOCKS
;-----------------------------------------------------------
  
BLINIT
            MOVEM.L D0/A0,-(A7)
            LEA.L   BLMATRIX,A0
            MOVE.W #BLROW-1,D0             
.LOOP                   
            MOVE.B  #%11111111,(A0)+
            DBRA    D0,.LOOP
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%00000000,(A0)+
*            MOVE.B  #%10000000,(A0)+
            CLR.W   BLCOUNTER
            JSR     BLCOUNTBL
            MOVE.W  #1,LEVEL
            MOVEM.L (A7)+,D0/A0
            RTS
BLLEV2           
            MOVEM.L D0/A0,-(A7)
            LEA.L   BLMATRIX,A0
            MOVE.W  #BLROW-1,D0             
.LOOP       
            MOVE.B  #%01011010,(A0)+
            DBRA    D0,.LOOP
            CLR.W   BLCOUNTER
            JSR     BLCOUNTBL
            MOVEM.L (A7)+,D0/A0
            RTS
            
BLLEV3              
            MOVEM.L A0,-(A7)
            LEA.L   BLMATRIX,A0         
            MOVE.B  #%11110101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%11100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%10100101,(A0)+
            MOVE.B  #%11110101,(A0)+
            CLR.W   BLCOUNTER
            JSR     BLCOUNTBL
            MOVEM.L (A7)+,A0
            RTS


; -----------------------------------------------------------------------------
BLUPD
; UPDATES THE LEVELS OF THE GAME
; INPUT     - NONE
; OUTPUT    - NONE
; MODIFIES  - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D1,-(A7)
            MOVE.W  BLCOUNTER,D0
            CMP     #0,D0                   ;SI NO HAY BLOQUES SALTA
            BNE     .END
.NEXTLEVEL  
            ADD.W   #1,LEVEL
            UTLSNDS .SOUND,#1
            MOVE.W  LEVEL,D1
            CMP     #4,D1
            BEQ     .WON
            CMP     #3,D1              
            BEQ     .NIVEL3
            MOVE.W  #STASPACE,(STANEXT)
            JSR     BLLEV2
            JSR     PLRLEV2
            JSR     BNXTLEV
            JMP     .END
.NIVEL3
            CMP.W   #3,D1
            BNE     .WON
            MOVE.W  #STASPACE,STANEXT
            JSR     BLLEV3 
            JSR     PLRLEV3
            JSR     BNXTLEV
            JMP     .END
.WON        
            MOVE.W  #STAWIN,STANEXT 
.END 
            MOVEM.L (A7)+,D0-D1
            RTS    
.SOUND      DC.L    'level up.wav',0      
; -----------------------------------------------------------------------------
BLPLOT
; PLOTS THE BLOCKS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A1,-(A7)
            UTLSPEN #$00000000
            CLR.W   D2                      ; Y ARRIBA
            MOVE.W  #BLHEIGHT,D4            ; Y ABAJO
            LEA     COLORS,A0
            
            MOVE.W  #BLROW-1,D7  
            MOVE.L  #0,A1  
.FILAS      
            UTLSFIL (A0)+ 
            MOVE.W  #BLWIDTH,D3             ; X DERECHA
            CLR.W   D1                      ; X IZQUIERDA
            MOVE.W  #BLCOL-1,D5
            MOVE.B  BLMATRIX(A1),D6
.COLUM                                    
            ROL.B   #1,D6
            BCC     .VACIO                  
            MOVE.B  #87,D0                  ; DIBUJAMOS EL CUADRADO
            TRAP    #15
.VACIO
            MOVE.W  D3,D1
            ADD.W   #BLWIDTH, D3
            DBRA    D5,.COLUM
            ADDA.W  #1,A1
            MOVE.W  D4,D2
            ADD.W   #BLHEIGHT,D4
            DBRA    D7,.FILAS
            MOVEM.L (A7)+,D0-D7/A0-A1
            RTS
; -----------------------------------------------------------------------------
BLCOUNTBL
; COUNTS THE NUMBER OF BLOCKS OF THE MATRIX
; INPUT    - NONE (BLMATRIX)
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A2,-(A7)
            MOVE.W  #BLROW-1,D1    
            CLR.L   D3
            MOVE.L  #0,A1                   ; RECORRE LAS FILAS (8 BYTES)
.FILAS                                          
            MOVE.W  #BLCOL-1,D2               
            MOVE.B  BLMATRIX(A1),D0
.COLUM                       
            ROL.B   #1,D0         
            BCC     .VACIO
            ADD.W   #1,D3
.VACIO
            DBRA    D2,.COLUM   
            ADDA.L  #1,A1
            DBRA    D1,.FILAS
            MOVE.W  D3,BLCOUNTER
            MOVEM.L (A7)+,D0-D7/A2
            RTS




*~Font name~Courier New~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
