
.include "cpctelera.h.s"
.include "game.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_getScreenPtr_asm

_main::
   call cpct_disableFirmware_asm
   call game_init
loop:
   jr    loop