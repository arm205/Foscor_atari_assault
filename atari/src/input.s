.include "cpct_func.h.s"
.include "entity.h.s"
.include "cpctelera.h.s"
.include "game.h.s"


bala_moved: .db 0
bala_counter: .db 1

input_init::
ret


input_update::
    ld d, a
    ld a, (cmp_input)
    call E_M_for_all_matching
ret


;MODIFICA: AF, BC, DE, HL
input_update_one::
    ld e_vx(ix), #0

    ld e_vy(ix), #0

    call cpct_scanKeyboard_f_asm

    ld hl, #Key_O
    call cpct_isKeyPressed_asm
    jr z, O_NotPressed
O_Pressed:
    ld e_vx(ix), #-1
O_NotPressed:
    ld hl, #Key_P
    call cpct_isKeyPressed_asm
    jr z, P_NotPressed
P_Pressed:
    ld e_vx(ix), #1
P_NotPressed:


;    ld e, e_t(ix)
;    ld a, (t_bala)
;    xor e
;    jr nz, no_bala
;
    ld hl, #Key_Space
    call cpct_isKeyPressed_asm
    jr z, Space_NotPressed
Space_Pressed:
    ld e_be(ix), #1
    ret
;    call input_move_bala
    
Space_NotPressed:
    ld e_be(ix), #0
;call counter_for_bala
;no_bala:

ret


;input_move_bala::
;    ld a, (bala_moved)
;    xor #0
;    jr nz, movida
;    ld e_vx(ix), #2
;movida:
;    inc a
;    ld (bala_moved), a
;
;
;ret


;counter_for_bala::
;ld a, (bala_moved)
;    xor #0
;    jr z, no_descontar
;
;        ld a, (bala_counter)
;        dec a
;        xor #0
;        jr nz, not_yet
;        move_back:
;            call move_bala_back
;    not_yet:
;        ld (bala_counter), a
;
;no_descontar:
;
;ret
;
;move_bala_back::
;    ld a, e_vx(ix)
;    dec a
;    dec a
;    ld e_vx(ix), a
;
;    ld a, #1
;    ld (bala_counter), a
;
;    ld a, #0
;    ld (bala_moved), a
;
;
;ret