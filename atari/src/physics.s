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

.include "entity.h.s"
.include "cpctelera.h.s"


.module entity_sys_physics



screen_width = 80
screen_height = 200

physics_sys_init::

ret

physics_sys_update::
    ld a, #cmp_ia+#cmp_input
    call E_M_for_all_matching
ret


;
;Entrada: IX puntero al inicio del array, A numero de entidades creadas en array


;
;Modifica: CD, A
physics_sys_for_one::
    ld a, #screen_width
    sub e_w(ix)
    ld  c, a

    ld a, e_x(ix)
    add e_vx(ix)
    cp  c
    jr nc, invalid_x

    ;mirando si la fisica es de player
    ld b, a
    ld a, e_t(ix)

    id_x:
        ld e_x(ix), a
        jr  endif_x
    invalid_x:
endif_x:

    ld a, #screen_height
    sub e_h(ix)
    ld  c, a

    ld a, e_y(ix)
    add e_vy(ix)
    cp  c
    jr nc, invalid_y

    id_y:
        ld e_y(ix), a
        jr  endif_y
    invalid_y:
        ld  a, e_vy(ix)
        neg
        ld  e_vy(ix), a
endif_y:


; comprobamos que haya alguna velocidad que no sea 0 antes de guardarlas
    ld a, e_vx(ix)
    or e_vy(ix)
    ret z
    ld a, e_vx(ix)
    ld e_vx_prev(ix), a
    ld a, e_vy(ix)
    ld e_vy_prev(ix), a


ret