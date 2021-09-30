.include "entity.h.s"
.include "cpctelera.h.s"


.module entity_sys_physics


screen_width = 80
screen_height = 200

physics_sys_init::
ret

;
;Entrada: IX puntero al inicio del array, A numero de entidades creadas en array


;
;Modifica: CD, IX, DE
physics_sys_update::
_renloop:
    ld (_ent_counter), a
    ;; erase previous istance
recorre:
    ld a, #screen_width
    sub e_w(ix)
    ld  c, a

    ld a, e_x(ix)
    add e_vx(ix)
    cp  c
    jr nc, invalid_x

    id_x:
        ld e_x(ix), a
        jr  endif_x
    invalid_x:
        ld  a, e_vx(ix)
        neg
        ld  e_vx(ix), a
endif_x:

_ent_counter = .+1
    ld  a, #0
    dec a
    ret z

    ld (_ent_counter), a
    ld bc, #sizeof_e
    add ix, bc
    jr _renloop
