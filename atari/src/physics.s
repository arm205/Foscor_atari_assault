.include "entity.h.s"
.include "cpctelera.h.s"


.module entity_sys_physics


screen_width = 80
screen_height = 200

physics_sys_init::


ret

physics_sys_update::
    ld d, a
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

    ld a, e_vx(ix)
    ld e_vx_prev(ix), a
    ld a, e_vy(ix)
    ld e_vy_prev(ix), a


ret