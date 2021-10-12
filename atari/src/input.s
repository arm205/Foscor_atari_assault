.include "cpct_func.h.s"
.include "entity.h.s"
.include "cpctelera.h.s"
.include "game.h.s"


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
    .dw Key_O, move_left
    .dw Key_P, move_right
    .dw Key_Q, move_up
    .dw Key_A, move_down
    .dw Key_Space, eat
    .dw 0


input_update::
    ld d, a
    ld a, #cmp_input
    call E_M_for_all_matching
ret

input_update_one::
    ld e_vx(ix), #0
    ld e_vy(ix), #0
    ld e_be(ix), #0

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
    ld h, 2(iy)
    ld l, 3(iy)
    jp (hl)

ret
