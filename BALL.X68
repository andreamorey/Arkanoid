; =============================================================================
; BALL
; =============================================================================

; -----------------------------------------------------------------------------
BINIT
;INITIALIZE THE BALL
; INPUT    - NONE 
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #BINPOSX,BPOSX1
            MOVE.W  #BINPOSY,BPOSY2
            MOVE.W  #BINPOSX+BDIAMET,BPOSX2
            MOVE.W  #BINPOSY-BDIAMET,BPOSY1
            MOVE.W  #BINSPEED,BSPEEDX
            MOVE.W  #BINSPEED,BSPEEDY
            RTS
; -----------------------------------------------------------------------------
BNXTLEV
;INITIALIZE THE BALL TO THE NEXT LEVEL
; INPUT    - NONE 
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0,-(A7)
            MOVE.W  #BINPOSX,BPOSX1
            MOVE.W  #BINPOSY,BPOSY1
            MOVE.W  #BINPOSX+BDIAMET,BPOSX2
            MOVE.W  #BINPOSY+BDIAMET,BPOSY2
            MOVE.W  BSPEEDY,D0
            BMI     .NEGY
            ADD.W   #1,BSPEEDY
            JMP     .X
.NEGY        
            SUB.W   #1,BSPEEDY
.X          
            MOVE.W  BSPEEDX,D0
            BMI     .NEGX 
            ADD.W   #1,BSPEEDX
            JMP     .END
.NEGX       
            SUB.W   #1,BSPEEDX 
.END        
            MOVEM.L (A7)+,D0
            RTS
      
;-----------------------------------------------------------------------------
BUPD
; UPDATES THE BALL MOTION
; INPUT    - NONE 
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D7/A0-A1,-(A7)
            ;COMPRUEBA COLISIONES CON LAS 4 PAREDES
            ;Y SI PASA LA DE ABAJO LE ELIMINA UNA VIDA, O ENVIA LA PANTALLA GAME OVER
            MOVE.W  BPOSX1,D0
            MOVE.W  BPOSY1,D1
            MOVE.W  BPOSX2,D2
            MOVE.W  BPOSY2,D3
            JSR     UTLCHCOLW               ;COMPRUEBA COLISIÓN CON PAREDES               
            JSR     UTLCHCOLP               ;COMPRUEBA COLISIÓN CON PLATAFORMA
            CLR.L   D4
            MOVE.W  BPOSX2,D5
            MOVE.W  BPOSY2,D6
            JSR     UTLCOLBL
            
            CMP     #0,D4
            BNE     .END
            MOVE.W  BPOSX2,D0
            MOVE.W  BPOSY1,D1
            MOVE.W  BPOSX1,D5
            MOVE.W  BPOSY2,D6
            JSR     UTLCOLBL
            CMP     #0,D4
            BNE     .END
            MOVE.W  BPOSX1,D0
            MOVE.W  BPOSY2,D1
            MOVE.W  BPOSX2,D5
            MOVE.W  BPOSY1,D6
            JSR     UTLCOLBL
            CMP     #0,D4
            BNE     .END
            MOVE.W  BPOSX2,D0
            MOVE.W  BPOSY2,D1
            MOVE.W  BPOSX1,D5
            MOVE.W  BPOSY1,D6
            JSR     UTLCOLBL   
.END            
            MOVE.W  BSPEEDX,D0              ;POSICIÓN = POSICIÓN + VELOCIDAD
            ADD.W   D0,BPOSX1
            ADD.W   D0,BPOSX2
            
            MOVE.W  BSPEEDY,D1
            ADD.W   D1,BPOSY1
            ADD.W   D1,BPOSY2
            MOVEM.L (A7)+,D0-D7/A0-A1
            RTS
;-----------------------------------------------------------------------------
BPLOT
; PLOTES THE BALL 
; INPUT    - NONE 
; OUTPUT   - NONE 
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L  D0-D4,-(A7)
            UTLSPEN #BINCOLOR
            UTLSFIL #BINCOLOR
            MOVE.W  BPOSX1,D1
            MOVE.W  BPOSY1,D2
            MOVE.W  BPOSX2,D3
            MOVE.W  BPOSY2,D4
            MOVE.B  #88,D0
            TRAP    #15
            MOVEM.L  (A7)+,D0-D4
            RTS

*~Font name~Courier New~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
