; =============================================================================
; TITLE    : BREAKING BLOCKS
; AUTHOR   : ANDREA MOREY SANCHEZ Y AISHA GANDAROVA
; CREATION : 
; =============================================================================

            ORG     $1000
            
; --- CODE INCLUDES -----------------------------------------------------------
          
            INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
            INCLUDE "SYSTEM.X68"            ; SYSTEM CODE
            INCLUDE "CONSTANTS.X68"         ; USER CONSTANTS
            INCLUDE "UTIL.X68"              ; UTILITY MACRO AND SUBROUTINES
            INCLUDE "PLAYER.X68"            ; PLAYER MANAGEMENT
            INCLUDE "STATES.X68"            ; GAME STATES MANAGEMENT
            INCLUDE "BALL.X68"              ; BALL MANAGEMENT
            INCLUDE "BLOCKS.X68"            ; BLOQUES

; --- INITIALIZE --------------------------------------------------------------
            
START       JSR     SYSINIT
            ; TO DO: CALL GAME INITIALIZATION CODE HERE
            JSR     STAINIT                           
            
; --- UPDATE ------------------------------------------------------------------
            
.LOOP       TRAP    #KBDTRAP                ; READ KEYBOARD                 
                                            ; UPDATE DEPENDING ON THE STATE
            ; TO DO: CALL GAME UPDATE CODE HERE
            JSR     STAUPD

; --- WAIT SYNCH --------------------------------------------------------------

.WINT       TST.B   (SCRINTCT)              ; WAIT FOR INTERRUPT
            BEQ     .WINT
            
            CLR.B   (SCRINTCT)

; --- PLOT --------------------------------------------------------------------
            
            ; TO DO: CALL GAME PLOT CODE HERE
            JSR     STAPLOT

            TRAP    #SCRTRAP                ; SHOW GRAPHICS
            BRA     .LOOP
            SIMHALT

; --- VARIABLES ---------------------------------------------------------------

            INCLUDE "SYSVAR.X68"
            INCLUDE "VAR.X68"
            END    START


*~Font name~Courier New~
*~Font size~16~
*~Tab type~0~
*~Tab size~4~
