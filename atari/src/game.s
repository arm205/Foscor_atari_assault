.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "man_game.h.s"
.include "entity_manager.h.s"
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


esperar::

   ld e, #0xFF
   espera:
      halt
      dec e
   jr nz, espera   

ret