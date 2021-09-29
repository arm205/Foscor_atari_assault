;
;   RENDER SYSTEM
;
.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity_manager.h.s"

screen_start = 0xC000


rendersys_init::
    ;ld  c, #0
    ;call cpct_setVideoMode_asm
    ;ld  hl, #_pal_main
    ;ld  de, #16
    ;call cpct_setPalette_asm
    ;cpctm_setBorder_asm HW_WHITE
ret



rendersys_update::
    call render_entities
ret



render_entities::
_renloop:

    ld (_ent_counter), a
    ;; erase previous istance

    ld e, e_lastVP_l(ix)
    ld d, e_lastVP_h(ix)
    xor a
    ld c, e_w(ix)
    ld b, e_h(ix)
    call cpct_drawSolidBox_asm

    ;; calculate new VP
    ld de, #screen_start
    ld c, e_x(ix)
    ld b, e_y(ix)
    call cpct_getScreenPtr_asm

    ; store VP as last
    ld e_lastVP_l(ix), l
    ld e_lastVP_h(ix), h


    ex  de, hl
    ld a, e_c(ix)  ;; Color
    ld c, e_w(ix) ;; width
    ld b, e_h(ix) ;; height
    call cpct_drawSolidBox_asm


_ent_counter = .+1
    ld  a, #0
    dec a
    ret z

    ld (_ent_counter), a
    ld bc, #sizeof_e
    add ix, bc
    jr _renloop
