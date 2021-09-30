.include "cpct_func.h.s"
.include "entity.h.s"
.include "cpctelera.h.s"

input_init::
ret


input_update::
    ld d, a
    ld a, (t_input)
    call E_M_for_all_matching
ret


;MODIFICA: AF, BC, DE, HL
input_update_one::
    ld e_vx(ix), #0

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

ret