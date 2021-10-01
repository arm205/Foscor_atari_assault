.include "entity.h.s"


screen_width = 80
screen_height = 200


ia_update_one_entity::

    ld a, #screen_width
    sub e_w(ix)
    ld  c, a

    ld a, e_x(ix)
    add e_vx(ix)
    cp  c
    jr nc, cambia_vx
    jr acabado

    cambia_vx:
        ld  a, e_vx(ix)
        neg
        ld  e_vx(ix), a

acabado:

ret

ia_update::
    ld d, a
    ld a, (t_enemy)
    call E_M_for_all_matching
ret