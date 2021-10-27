.include "entity.h.s"
.include "game.h.s"


screen_width = 80
screen_height = 200


; MODIFIES: A, C
ia_update_one_entity::
ld a, e_t(ix)
ld c, a
ld a, (t_enemy)
xor c
jr z, is_enemy

is_enemy:
    call ia_for_enemy
acabado:

ret



;; Comportamiento de las entidades de tipo enemigo
ia_for_enemy:
    ld a, e_be(ix)
    or #0
    jr nz, r_l
        call ia_mario_ghost
        ret
r_l:
    ;call ia_right_left
ret


ia_mario_ghost:

    ld a, #pos_player
    call E_M_get_from_idx
    ;; en iy tengo el player
    ld e, #3;; NO PONER A 0
    call check_distance
    call nc, stalker_mode

   
ret

check_distance::
;; RECORDEMOS QUE EN IY TENGO EL PLAYER
;COLISIONES CON EL EJE X
    ld a, e_w(iy)
    ld c, e
    ld b, a
    calc_area_w:
        add b

    dec e
    jr nz, calc_area_w

    ld b, a

; if (e_x(iy)+e_w(iy)-e_x(ix) < 0) No_col
    ld a, e_x(iy)
    add b
    sub e_x(ix)
    ret c


; if (e_x(ix)+e_w(ix)-e_x(iy) < 0) No_col

    ld a, e_x(ix)
    add b
    sub e_x(iy)
    ret c



;COLISIONES CON EL EJE Y


    ld a, e_h(iy)
    ld b, a
    calc_area_h:
        add b

    dec c
    jr nz, calc_area_h

    ld b, a


; if (e_x(iy)+e_w(iy)-e_x(ix) < 0) No_col
    ld a, e_y(iy)
    add b
    sub e_y(ix)
    ret c


; if (e_x(ix)+e_w(ix)-e_x(iy) < 0) No_col

    ld a, e_y(ix)
    add b
    sub e_y(iy)
    ret c
ret




stalker_mode::

    ld a, e_x(iy)
    sub e_x(ix)
    jr nc, obx_greater_or_equal

obx_lesser:

    ld e_vx(ix), #-1
    jr endifx


obx_greater_or_equal:
    jr z, arrived_x

    ld e_vx(ix), #1
    jr endifx

arrived_x:
    ld e_vx(ix), #0
endifx:    



    ld a, e_y(iy)
    sub e_y(ix)

    jr nc, oby_greater_or_equal

oby_lesser:

    ld e_vy(ix), #-2
    jr endify


oby_greater_or_equal:
    jr z, arrived_y

    ld e_vy(ix), #2
    jr endify

arrived_y:
    ld e_vy(ix), #0
endify: 

ret

ia_right_left:

    ld a, e_vx(ix)
    cp #-1
    jr z, cambia_x_positivo 

        cp #1
        jr z, cambia_x_negativo 


        cambia_x_negativo:
            ld e_vx(ix), #-1
            ret

    cambia_x_positivo:
    ld e_vx(ix), #1

ret


ia_up_down:
    ld a, e_vy(ix)
    cp #-2
    jr z, cambia_y_positivo 

        cp #2
        jr z, cambia_y_negativo 


        cambia_y_negativo:
            ld e_vy(ix), #-2
            ret

    cambia_y_positivo:
    ld e_vy(ix), #2

ret

ia_colides_tilemap::
    ld a, e_be(ix)
    cp  #1
    jr z, ia_r_l
        cp  #2
        jr z, ia_u_d
            ret
        ia_u_d:
        call ia_up_down
        ret
    ia_r_l:
        call ia_right_left
ret




ia_update::
    ld a, #cmp_ia
    call E_M_for_all_matching

ret