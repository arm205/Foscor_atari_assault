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

.include "cpct_func.h.s"
.include "entity.h.s"
.include "cpctelera.h.s"
.include "game.h.s"

hungry: .db 0

input_init::
ret

move_left:
    ld e_vx(ix), #-2
ret

move_right:
    ld e_vx(ix), #2
ret


move_up:
    ld e_vy(ix), #-8
ret

move_down:
    ld e_vy(ix), #8
ret

eat:
    ld e_be(ix), #1
ret




key_actions:
    .dw Key_A, move_left
    .dw Key_D, move_right
    .dw Key_W, move_up
    .dw Key_S, move_down
    .dw Key_Space, eat


    .dw Key_CursorLeft, move_left
    .dw Key_CursorRight, move_right
    .dw Key_CursorUp, move_up
    .dw Key_CursorDown, move_down

    .dw Joy0_Left, move_left
    .dw Joy0_Right, move_right
    .dw Joy0_Up, move_up
    .dw Joy0_Down, move_down
    .dw Joy0_Fire1, eat
    .dw 0


input_update::
    ld a, #cmp_input
    call E_M_for_all_matching
ret


input_update_one::

    ld e_vx(ix), #0
    ld e_vy(ix), #0
    ld e_be(ix), #0

    ld a, (still_eating)
    or #0
    jr nz, saltar_input

    call check_keyboard_input

    call check_acabo_en_tile
    saltar_input:
    ld a, (hungry)
    cp #1
    jr z, saciado
        ld a, e_be(ix)
        cp #1
        jr z, cambio_hungry
            ret
        cambio_hungry:
        ld (hungry), a
        ret


    saciado:
        ld a, e_be(ix)
        cp #1
        jr z, no_eat
            xor a
            ld (hungry), a
            ret


        no_eat:
        ld e_be(ix), #0

ret

check_acabo_en_tile:
;Mirando si hay imput
    ld a, e_vx(ix)
    or e_vy(ix)
    ret nz
    ;No lo hay
    ;Miramos si estamos a mitad de tile
    call estoy_en_8
    or #0
    ret z

        xor #1
        jr z, muevo_x
            muevo_y:

                ld a, e_vy_prev(ix)
                ld e_vy(ix), a
            ret



    muevo_x:

        ld a, e_vx_prev(ix)
        ld e_vx(ix), a

ret


estoy_en_8:

    ld a, e_x(ix)
    ld b, #4

contando_multiplos:

    sub b

    jr z, siguiente_eje

    jr c, moverse_mismo_tilex


    jr contando_multiplos

siguiente_eje:

    ld a, e_y(ix)
    ld b, #16

    contando_multiplos2:

    sub b

    jr z, esta_donde_toca

    jr c, moverse_mismo_tiley


    jr contando_multiplos2


ret

moverse_mismo_tilex:
    ld a, #1
ret


moverse_mismo_tiley:
    ld a, #2
ret

esta_donde_toca:
    ld a, #0
ret


check_keyboard_input:

    call cpct_scanKeyboard_f_asm

    ld iy, #key_actions-4

loop_keys:

    ld bc, #4
    add iy, bc

    ld l, 0(iy)
    ld h, 1(iy)

    ld a, l
    or h
    ret z

    call cpct_isKeyPressed_asm
    jr z, loop_keys

    ld hl, #loop_keys
    push hl
    ld h, 3(iy)
    ld l, 2(iy)
    jp (hl)

ret


wait_keyPressed::

    push hl
    call cpct_scanKeyboard_f_asm
    pop hl
    push hl
    call cpct_isKeyPressed_asm
    pop hl

    jr  nz, wait_keyPressed

    loop2:
    push hl
    call cpct_scanKeyboard_f_asm
    pop hl
    push hl
    call cpct_isKeyPressed_asm
    pop hl
    jr z, loop2
ret

check_keyPressed::

    push hl
    call cpct_scanKeyboard_f_asm
    pop hl
    push hl
    call cpct_isKeyPressed_asm
    pop hl

    jr  z, continuar

    call L_M_showMenuScreen

    continuar:
ret