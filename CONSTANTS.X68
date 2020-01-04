; =============================================================================
; CONSTANTS
; =============================================================================

; --- TEXT RELATED CONSTANTS --------------------------------------------------
INTTITX     EQU     14                      ; TITLE X COORDINATE
INTTITY     EQU     7                       ; TITLE Y COORDINATE
INTTITC     EQU     $00DCAA7C               ; TITLE COLOR
INTPRSX     EQU     32                      ; PRESS FIRE X COORDINATE
INTPRSY     EQU     82                      ; PRESS FIRE Y COORDINATE
INTPRSC     EQU     $00FFFFFF               ; PRESS FIRE COLOR
TXBSIZE     EQU     18                      ; BIG SIZE LETTERS
TXMSIZE     EQU     16                      ; MEDIUM SIZE LETTERS
TXSSIZE     EQU     10                      ; SMALL SIZE LETTERS
GOVERX      EQU     18                      ; GAME OVER X COORDINATE
GOVERY      EQU     7                       ; GAME OVER Y COORDINATE
GOVERC      EQU     $0000FFFF               ; GAME OVER COLOR

; --- STATES GAME -------------------------------------------------------------
STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS FIRE STATE
STASPACE    EQU     1                       ; WAITS PRESS FIER TO MOVE THE BALL
STAPLAY     EQU     2                       ; NORMAL GAME STATE
STAGOVR     EQU     3                       ; GAME OVER STATE
STAWIN      EQU     4                       ; WIN STATE

; --- SCREENCTRL --------------------------------------------------------------
SCRCTRL     EQU     513                     ; COORDINATE X OF DATA SCREEN
SCRLWIDTH   EQU     5                       ; WIDTH OF THE DATA SCREEN
SCRRNKY     EQU     200                     ; POSITION X OF THE RNK SCREEN
LIVEWIDTH   EQU     64                      ; WIDTH OF THE LIVE BAR
LIVEHEIGHT  EQU     16                      ; HEIGHT OF THE LIFE BAR
LIVECOLOR   EQU     $006666FF               ; RED COLOR OF THE LIFE BAR
LIVEPOSX    EQU     SCRCTRL+20              ; LIFE BAR X COORDINATE
LIVEPOSY    EQU     30                      ; LIFE BAR Y COORDINATE
FILE        DC.B    'score.txt',0           ; SCORES' FILE

; -- PLAYER -------------------------------------------------------------------
PINWIDTH1    EQU     64                     ; PLAYER INITIAL WIDTH 
PINWIDTH2    EQU     54                     ; PLAYER LEVEL2 WIDTH
PINWIDTH3    EQU     44                     ; PLAYER LEVEL3 WIDTH
PHEIGHT      EQU     12                     ; PLAYER HEIGHT (PIXELS)
PCOLOR       EQU     $00ECD59D              ; PLAYER COLOR
PINLIVE      EQU     3                      ; PLAYER INTIAL LIVES 
PMOVE        EQU     8                      ; SPEED OF THE PLAYER
PPOSY        EQU     SCRHEIGH-PHEIGHT-4     ; POSICION DE LA PLATAFORMA Y)
PINPOSX1     EQU     SCRCTRL/2-PINWIDTH1/2  ; PLAYER LVL1 COORDINATE X
PINPOSX2     EQU     SCRCTRL/2-PINWIDTH2/2  ; PLAYER LVL2 COORDINATE X
PINPOSX3     EQU     SCRCTRL/2-PINWIDTH3/2  ; PLAYER LVL3 COORDINATE X
PSCORETX     EQU     62                     ; SCORE X COORDINATE
PSCORETY     EQU     6                      ; SCORE Y COORDINATE
PSCORECOL    EQU     $00FFFFFF

; --- BALL --------------------------------------------------------------------
BDIAMET     EQU     10                      ; DIAMETER OF THE BALL
BINPOSX     EQU     SCRCTRL/2-BDIAMET/2     ; BALL X INITIAL COORDINATE 
BINPOSY     EQU     PPOSY-2                 ; BALL Y INITIAL COORDINATE 
BINSPEED    EQU     -3                      ; INITIAL SPEED
BINCOLOR    EQU     $00FFFFFF               ; BALL COLOR

; --- BLOCKS ------------------------------------------------------------------
BLWIDTH     EQU     64                      ; BLOCKS WIDTH
BLHEIGHT    EQU     16                      ; BLOCKS HEIGHT
COLORS      DC.L    BLUE,ORANGE,PURPLE,YELLOW,GREEN,BLUE,ORANGE,PURPLE,YELLOW,GREEN,BLUE,ORANGE
; BLOCKS DIFFERENT COLORS
BLROW       EQU     12                      ; ROWS OF BLOCKS
BLCOL       EQU     8                       ; COLUMS OF BLOCKS

; --- COLORS ------------------------------------------------------------------
ORANGE      EQU     $004E8CF3
BLUE        EQU     $00F7E78E
PURPLE      EQU     $00FFACAC
YELLOW      EQU     $0038EEF8
GREEN       EQU     $0095FF8C
; --- RANKING TABLE -----------------------------------------------------------

RNKPOSR     EQU     17                      ; POSITION ROW
RNKPSCC     EQU     60                      ; COLUMN POSITION FOR SCORE
RNKPNAC     EQU     70                      ; COLUMN POSITION FOR NAME




*~Font name~Courier New~
*~Font size~16~
*~Tab type~0~
*~Tab size~4~
