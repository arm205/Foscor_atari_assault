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

    ld hl, #Key_Q
    call cpct_isKeyPressed_asm
    jr z, Q_NotPressed
Q_Pressed:
    ld e_vy(ix), #-4
Q_NotPressed:
    ld hl, #Key_A
    call cpct_isKeyPressed_asm
    jr z, A_NotPressed
A_Pressed:
    ld e_vy(ix), #4
A_NotPressed:

ret