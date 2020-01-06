; =============================================================================
; UTILITY MACROS
; =============================================================================

UTLSPEN     MACRO
; WRAPPER FOR SET PEN TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #80,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM
; -----------------------------------------------------------------------------
UTLSFIL     MACRO
; WRAPPER FOR SET FIL TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.B  #81,D0
            MOVE.L  \1,D1
            TRAP    #15
            ENDM
            
; -----------------------------------------------------------------------------
UTLLOCT     MACRO
; WRAPPER TO TEXT POSITIONNING FROM TRAP 15
; INPUT    - \1 X, \2 Y
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.W  #\1<<8|\2, D1
            MOVE.B  #11,D0
            TRAP    #15
            ENDM
; -----------------------------------------------------------------------------
UTLSIZC     MACRO
; WRAPPER FOR SET SIZE AND COLOR TRAP 15 TASK.
; INPUT    - \1 COLOR IN FORMAT $00BBGGRR \2 SIZE (8, 9, 10, 12, 14, 16, 18))
; OUTPUT   - NONE
; MODIFIES - D0,D1
; -----------------------------------------------------------------------------
            MOVE.L  \1,D1
            MOVE.L  #\2<<16|1,D2
            MOVE.B  #21,D0
            TRAP    #15
            ENDM
; -----------------------------------------------------------------------------
UTLSNDS     MACRO
; WRAPPER FOR PLAYING WAV FILE TRAP 15 TASK
; INPUT    - \1 ADDRESS TO STRING WITH NAME OF THE FILE, \2 NUM SOUNDS, 
; OUTPUT   - D0.W=0 IF SOUND NOT PLAYED, NON ZERO IF PLAYED
; MODIFIES - D0,A1
; -----------------------------------------------------------------------------
            LEA     \1, A1             ;PLAY EXPLOSION SOUND
            MOVE.W  \2,D1
            MOVE.B  #71,D0
            TRAP    #15
            MOVE.B  #72,D0
            TRAP    #15
            ENDM
; -----------------------------------------------------------------------------
UTLSNDST     MACRO
; WRAPPER FOR STOPPING WAV FILE TRAP 15 TASK
; INPUT    - NONE 
; OUTPUT   - D0.W=0 IF SOUND NOT PLAYED, NON ZERO IF PLAYED
; MODIFIES - D0,A1
; -----------------------------------------------------------------------------
            MOVE.L  #3,D2
            MOVE.B  #76,D0
            TRAP    #15
            ENDM
; -----------------------------------------------------------------------------            
UTLSVNAME  
; WRAPPER FOR SAVING THE NAME OF THE PLAYER
; MAX CARACTERS: 20
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1,-(A7)
            CLR.B   PNAME
            LEA.L   .INSTRUCT,A1            
            MOVE.B  #14,D0
            TRAP    #15
            LEA.L   PNAME,A1                ; SAVES IN PNAME
            MOVE.B  #2,D0
            TRAP    #15
            MOVEM.L (A7)+,D0/A1
            RTS
.INSTRUCT   DC.B    'ENTER YOUR NAME (MAX. 6 LETTERS): ',0
            DC.W    0
         
; -----------------------------------------------------------------------------
; =============================================================================
; UTILITY SUBROUTINES
; =============================================================================
; -----------------------------------------------------------------------------
UTLINTRI
; PLOTS THE TITLE OF THE GAME
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            ;TITULO
            UTLLOCT INTTITX,INTTITY      
            UTLSIZC #INTTITC,TXBSIZE
            LEA     .TITSTR,A1            
            MOVE.B  #14,D0
            TRAP    #15
            MOVEM.L (A7)+,D0-D2/A1
            RTS
.TITSTR     DC.B    'Breaking Blocks',0
            DC.W    0
; -----------------------------------------------------------------------------
UTLCHCOLW
; CHECKS COLLISION WITH WALL
; INPUT    - D0.W BPOSX1
;            D1.W BPOSY1
;            D2.W BPOSX2
;            D3.W BPOSY2
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A0,-(A7)
            LEA.L   .COLLIS,A0
            CMP.W   (A0)+,D1                ; UP
            BGT     .LEFT
            NEG.W   BSPEEDY
            CLR.W   BPOSY1
            MOVE.W  #BDIAMET,BPOSY2
            JMP     .END 
.LEFT        
            CMP.W   (A0)+,D0
            BGT     .RIGHT
            NEG.W   BSPEEDX
            CLR.W   BPOSX1
            MOVE.W  #BDIAMET,BPOSX2
            JMP     .END
.RIGHT      
            CMP.W   (A0)+,D2
            BLT     .DOWN
            NEG.W   BSPEEDX
            MOVE.W  #SCRCTRL,BPOSX2
            MOVE.W  #SCRCTRL-BDIAMET,BPOSX1
            JMP     .END
.DOWN       
            CMP.W   (A0)+,D3         
            BGT     .MINLIVE                  
            JMP     .END  
.MINLIVE                                    ; MINUS ONE LIVE
            UTLSNDS .SOUNDL,#1              
            MOVE.W  #SCRHEIGH,BPOSY2
            MOVE.W  #SCRHEIGH-BDIAMET,BPOSY1 
            SUB.W   #1,PLIVES                
            BNE     .RESET               
            UTLSNDST
            UTLSNDS .SOUNDG,#1
            MOVE.W  #STAGOVR,(STANEXT)      ; IF PLAYER LOST ALL THE LIVES
            JMP     .END
.RESET                                      
            MOVE.W  #STASPACE,(STANEXT) 
           
.END        
            MOVEM.L (A7)+,D0-D3/A0
            RTS
.COLLIS     DC.W    0,0,SCRCTRL,SCRHEIGH
.SOUNDG     DC.L    'game over.wav',0
.SOUNDL     DC.L    'lose life.wav',0
; -----------------------------------------------------------------------------
UTLCHCOLP
; CHECKS COLLISION WITH PLATAFORM
; INPUT    - D0.W BPOSX1
;            D1.W BPOSY1
;            D2.W PPOSX2
;            D3.W PPOSY2
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5,-(A7)
            MOVE.W  #PPOSY,D4
            CMP.W   D4,D3
            BLT     .END                    ;SI ESTÁ MÁS A ARRIBA DE LA PLATAFORMA NO HAY COLISIÓN
            MOVE.W  PPOSX,D4
            CMP.W   D4,D2
            BLT     .END                    ;SI ESTÁ MÁS A LA IZQUIERDA DE LA PLATAFORMA NO HAY COLISIÓN
            ADD.W   PWIDTH,D4
            CMP.W    D4,D0
            BGT     .END                    ;SI ESTÁ MÁS A LA DERECHA NO HAY COLISIÓN
            ;AQUÍ HAY COLISIÓN, TENEMOS QUE DETECTAR CUAL
            MOVE.W  #PPOSY,D4
            CMP.W   D4,D1
            BGT     .LADOS
            NEG.W   BSPEEDY                 ;COLISIÓN CON LA PARTE DE ARRIBA
            MOVE.W  D4,BPOSY2
            SUB.W   #BDIAMET,D4
            MOVE.W  D4,BPOSY1       
.PLRXMIDDLE 
            MOVE.W  PWIDTH,D4
            LSR.W   #1,D4
            MOVE.W  PPOSX,D5 
            ADD.W   D4,D5                   ;D5 = CENTRO PLATAFORMA
            CMP.W   D2,D5                   ;CENTRO - POS PEL
            BMI     .PLRXRIGHT
            MOVE.W  BSPEEDX,D4
            BMI     .END
                                         
            NEG.W   D4
            MOVE.W  D4,BSPEEDX
            JMP     .END
            
.PLRXRIGHT             
            MOVE.W  BSPEEDX,D4
            BPL     .END              ;SI ES POSITIVO SOLO NEGAMOS Y
            NEG.W   D4
            MOVE.W  D4,BSPEEDX
            JMP     .END

.LADOS      
            NEG.W   BSPEEDX                 ;COLISIÓN CON LOS LADOS
.END        
            MOVEM.L (A7)+,D0-D5 
            RTS
; -----------------------------------------------------------------------------
UTLCOLBL   
; CHECKS COLLISION WITH BLOCKS
; INPUT    - 
; OUTPUT   
; MODIFIES - NONE
; -----------------------------------------------------------------------------
*            MOVEM.L D0-D3/D5-D7/A0,-(A7)            
            LSR.W   #4,D1           ;POSY/BLHEIGHT. D1 -> FILA
            MOVE.W  #BLROW-1,D2
            CMP.W   D1,D2           ;SI ESTÁ POR DEBAJO DE LA ÚLTIMA FILA SALTA DIRECTO A END
            BLT     .ENDNOCOLISION                    
            LEA.L   BLMATRIX,A0
            ADDA.L  D1,A0           ;CARGAMOS EN A0 LA DIRECCIÓN DEL BYTE DE LA FILA
                                        
            LSR.W   #6,D0           ;D0 -> COLUMNA 
            MOVE.W  #BLCOL-1,D3                           
            SUB.W   D0,D3           ;D3 -> COLUMNA (DESDE DRCHA) DONDE ESTÁ LA BOLA
            MOVE.W  D3,D7
            BPL     .TEST  
            CLR.L   D3              ;POR SI SALE NEGATIVO LA REAJUSTAMOS
.TEST
            BTST.B  D3,(A0)         ;MIRAMOS EL BIT DONDE ESTA 
            BEQ     .ENDNOCOLISION  ; SALTA SI EN ESA POSICION YA HABIA UN 0

.IZQ        
            LSR.W   #6,D5           ;D5 -> COLUMNA
            MOVE.W  #BLCOL-1,D2
            SUB.W   D5,D2           ;D2 -> COLUMNA (DESDE DERECHA) DONDE ESTA EL PUNTO CONTRARIO (SI 1 ENTONCES 2)
            CMP     D3,D2                  
            BLE     .CHOQUEDOBLE
            NEG.W   BSPEEDX
            
            JMP     .ENDCOLISION    ;  (|)______|  COLISION DELADO IZQUIERDO COLISIONANDO POR LA IZQ DEL NLOQUE 
            
.CHOQUEDOBLE                        ;SI ESTA EN MEDIO DEL BLOQUE  |___()___| COLISION EN MEDIO
                                    ;COMPARAMOS SI LE HA DADO A DOS A LA VEZ |______(|)______|
            CMP     D3,D2
            BEQ     .ENMEDIO
            
            ADDI.W  #BDIAMET/2,D0
            LSR.W   #6,D0
            MOVE.W  #BLCOL-1,D5     ;D1 -> COLUMNA DONDE SE ENCUENTRA EL PUNTO MEDIO DE LA BOLA                         
            
            SUB.W   D0,D5
            BPL     .TEST2  
            CLR.L   D5              ;POR SI SALE NEGATIVO LA REAJUSTAMOS
.TEST2
            
            BTST.B  D5,(A0)         ;MIRAMOS EL BIT DONDE ESTA 
            BEQ     .ENMEDIO
            CMP     D5,D7
            BEQ     .CHOQUEDOBLEIZQ
            NEG.W   BSPEEDY
            JMP     .ENDCOLISION
.CHOQUEDOBLEIZQ
            NEG.W   BSPEEDX
            JMP     .ENDCOLISION

            
.ENMEDIO            
            ;COMPARAMOS SI LA PARTE CONTRARIA ESTA DENTO DEL BLOQUE O FUERA
            CMP     D3,D2
            BLT     .DERECHA
            NEG.W   BSPEEDY
            JMP     .ENDCOLISION
.DERECHA
            NEG.W   BSPEEDX
            JMP     .ENDCOLISION
            

.ENDCOLISION
            MOVE.W  #1,D4
            BCLR    D3,(A0)      
            ADD.W   #100,PSCORE
            SUB.W   #1,BLCOUNTER
            MOVE.W  BLCOUNTER,D0
            CMP     #0,D0
            BEQ     .ENDNOCOLISION
            UTLSNDST
            UTLSNDS  .SOUND,#1
            
.ENDNOCOLISION
*            MOVEM.L (A7)+,D0-D7/A0
            RTS
.SOUND      DC.L    'blocks.wav',0

; -----------------------------------------------------------------------------
UTLSREENP   
; PLOTS THE SEPARATION BETWEEN THE GAME AND THE SCREENCTRL AND THE RNKTABLE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D5/A1,-(A7)    
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00FFFFFF
            MOVE.B  #87,D0
            MOVE.W  #SCRCTRL,D1
            MOVE.W  #SCRCTRL+SCRLWIDTH,D3
            CLR.L   D2
            MOVE.W  #SCRHEIGH,D4
            TRAP    #15
            MOVE.B  #87,D0
            MOVE.W  #SCRCTRL,D1
            MOVE.W  #SCRWIDTH,D3
            MOVE.W  #SCRRNKY,D2
            MOVE.W  #SCRRNKY+5,D4
            TRAP    #15
            MOVEM.L (A7)+,D0-D5/A1
            RTS   
.TXTSCORE   DC.B    'SCORE: ',0
            DC.W    0
; -----------------------------------------------------------------------------
UTLREADFILE  
; READS THE FILE OF SCORE AND SAVES THE INFO IN RNKTABLE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            MOVE.W  #50,D0                  ; CLOSES ALL THE FILES
            TRAP    #15
            LEA.L   RNKTABLE,A1
            LEA     FILE,A1
            MOVE.B  #51,D0
            TRAP    #15                     ; OPENS A FILE D1 = FILE ID
            LEA.L   RNKTABLE,A1
            MOVE.L  #100,D2                 ; BYTES TO READ: 100
            MOVE.B  #53,D0
            TRAP    #15 
            CMP.L   #$FFFFFFFF,(A1)         ; IF THE RNKTABLE IS EMPTY
            BNE     .HAYALGO
            MOVE.L  #0,D2    
.HAYALGO
            MOVE.W  D2,POSRNK
            MOVE.B  #56,D0
            TRAP    #15                     ; CLOSE THE FILE
            MOVEM.L (A7)+,D0-D2/A1
            RTS
; -----------------------------------------------------------------------------
UTLREADRNK  
; READS THE RNKTABLE AND PLOTS THE SCORES WITH THE NAMES OF THE PLAYERS
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D3/A1,-(A7)
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00000000    
            UTLLOCT RNKPSCC,RNKPOSR-2  
            LEA     .TEXT,A1            
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.W  POSRNK,D3               
            DIVU.W  #10,D3
            SUBQ.W  #1,D3                   ; D3 = NUMBER OF ELEMENTS IN RNK
            CMP     #0,D3                   
            BLT     .END                    ; IF RNKTABLE IS EMPTY DON'T SHOW
            MOVE.W  #RNKPOSR,D2             
            LEA.L   RNKTABLE,A1 
.LOOP
            MOVE.W  #RNKPSCC<<8,D1          ; PLACE THE SCORE
            ADD.W   D2,D1
            MOVE.B  #11,D0
            TRAP    #15
            
            MOVE.B  #3,D0                    ; PLOTS THE SCORE
            MOVE.W  (A1),D1                
            TRAP    #15       
              
            ADDA.L  #2,A1 
            MOVE.W  #RNKPNAC<<8,D1          ; PLACE THE NAME
            ADD.W   D2,D1
            MOVE.B  #11,D0
            TRAP    #15    
            ADDQ.W  #1,D2                   ; NEXT ROW  
            
            MOVE.B  #1,D0                   
            MOVE.W  #8,D1                   ; PLOTS 8 BYTES = LETTERS
            TRAP    #15     
            
            ADDA.L  #8,A1
            DBRA    D3,.LOOP
.END
            MOVEM.L (A7)+,D0-D3/A1
            RTS
.TEXT       DC.B    'RANKING TABLE:',0
            DC.W    0
; -----------------------------------------------------------------------------
UTLWRRNK 
; ADDS THE PLAYER AT THE TOP OF THE TABLE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
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
            RTS
; -----------------------------------------------------------------------------
UTLWRFILE 
; SAVES THE RNKTABLE IN THE FILE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - score.txt 
; -----------------------------------------------------------------------------
            MOVEM.L D0-D2/A1,-(A7)
            MOVE.B  #50,D0                  ; CLOSES ALL THE FILES
            TRAP    #15
            LEA.L   FILE,A1                 ; OPEN FILE
            MOVE.B  #51,D0                  
            TRAP    #15                     ; D1 = FILE ID
            
            CLR.L   D2
            LEA.L   RNKTABLE,A1             
            MOVE.W  POSRNK,D2  
            ADD.W   #10,D2                  
            MOVE.B  #54,D0                  ; WRITES THE PLAYER IN THE FILE 
            TRAP    #15
           
            MOVE.B  #56,D0                  ; CLOSE THE FILE
            TRAP    #15
            MOVEM.L (A7)+,D0-D2/A1
            RTS




*~Font name~Courier New~
*~Font size~18~
*~Tab type~0~
*~Tab size~4~
