;;Inside The Anthill - Videogame
;;
   ;; Copyright (C) 2021 Alba Ruiz, Javier Sibada and Miguel Teruel.
;;
   ;; This program is free software: you can redistribute it and/or modify
   ;; it under the terms of the GNU General Public License as published by
   ;; the Free Software Foundation, either version 3 of the License, or
   ;; (at your option) any later version.
;;
   ;; This program is distributed in the hope that it will be useful,
   ;; but WITHOUT ANY WARRANTY; without even the implied warranty of
   ;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   ;; GNU General Public License for more details.
;;
   ;; You should have received a copy of the GNU General Public License
   ;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


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
   
   ld    a, (_level_reseted)
   xor   #0x0
   jr    nz, loop

   call cpct_waitVSYNC_asm
   call man_game_render
   jr    loop

