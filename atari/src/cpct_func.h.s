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

;
;   CPCTELERA FUNCTIONS
;
.globl cpct_getScreenPtr_asm
.globl cpct_drawSolidBox_asm
.globl cpct_disableFirmware_asm
.globl cpct_waitVSYNC_asm
.globl _cpct_getRandom_mxor_u8
.globl cpct_isKeyPressed_asm
.globl cpct_scanKeyboard_f_asm
.globl cpct_isAnyKeyPressed_f_asm
.globl cpct_memset_asm

.globl cpct_zx7b_decrunch_s_asm