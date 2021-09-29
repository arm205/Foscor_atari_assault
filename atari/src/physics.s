.include "entity_manager.h.s"
.include "cpctelera.h.s"


.module entity_sys_physics


screen_width = 80
screen_height = 200

physics_sys_init::
ret


physics_sys_update_one_entity::

    ld a, #0x01
    sub e_w(ix)
    ld  c, a

    ld a, e_x(ix)
    add e_vx(ix)
    cp  c
    jr c, invalid_x

    id_x:
        ld e_x(ix), a
        jr  endif_x
    invalid_x:
        call E_M_destroy_entity
endif_x:
ret

physics_sys_update::
    call E_M_for_all
ret