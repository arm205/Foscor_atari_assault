
.include "cpctelera.h.s"

.area _DATA
.area _CODE

.globl cpct_disableFirmware_asm
.globl cpct_getScreenPtr_asm

_main::
   call cpct_disableFirmware_asm
loop:
   jr    loop