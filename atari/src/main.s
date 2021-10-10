.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "game.h.s"
.include "entity.h.s"
.include "render.h.s"


.area _DATA
.area _CODE



_main::
   call cpct_disableFirmware_asm
   call man_game_init

loop:
;   call esperar
   call man_game_update

   call cpct_waitVSYNC_asm
   call man_game_render
   jr    loop

