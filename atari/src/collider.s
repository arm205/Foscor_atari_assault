.include "entity.h.s"
.include "cpctelera.h.s"

x_ban:: .db 0
y_ban:: .db 0


collider_update::
    ld d, a
    ld a, (cmp_collider)
    call E_M_for_all_pairs_matching

ret


;INPUT IY first entity, IX second entity
collider_one_pair::
    ld a, e_t(iy)
    and e_col(ix)
    ld b, a
    ld a, e_t(ix)
    and e_col(iy)
    and b
    jr z, no_colisionan
        call check_collision
        jr c, no_colisionan

            call collider_check_type_iy
            call collider_check_type_ix


no_colisionan:
ret


check_collision::

;COLISIONES CON EL EJE X
; if (e_x(iy)+e_w(iy)-e_x(ix) < 0) No_col
    ld a, e_x(iy)
    add e_w(iy)
    sub e_x(ix)
    ret c


; if (e_x(ix)+e_w(ix)-e_x(iy) < 0) No_col

    ld a, e_x(ix)
    add e_w(ix)
    sub e_x(iy)
    ret c


;COLISIONES CON EL EJE Y
; if (e_y(iy)+e_h(iy)-e_y(ix) < 0) No_col
    ld a, e_y(iy)
    add e_h(iy)
    sub e_y(ix)
    ret c


; if (e_y(ix)+e_h(ix)-e_y(iy) < 0) No_col

    ld a, e_y(ix)
    add e_h(ix)
    sub e_y(iy)
    ret c


ret



collider_check_type_iy::
    ld a, e_t(iy)
    ld b, a
    ld a, (t_player)
    xor b
    jr nz, no_player

        ld a, e_col(iy)
        and e_t(ix)
        jr z, pair_not_col

        ld a, e_t(ix)
        ld b, a
        ld a, (t_enemy)
        xor b
        jr nz, pl_caja
        pl_en:
            ;; Aqui tendriamos que matar al jugador
            ld a, #0x00 
            ld e_c(iy), a
            ret

        pl_caja:
        for_x:
            ld a, e_vx(iy)
            and #0
            jr z, cero_x

            ld a, (x_ban)
            and #0
            jr z, new_x_ban
                ld b, a
                ld a, e_vx(iy)
                xor b
                jr z, cero_x
                move_x:
                    ld a, #0
                    ld (x_ban), a
                    ret

            new_x_ban:
                ld a, e_vx(iy)
                ld (x_ban), a

            cero_x:
                ld a, #0
                ld e_vx(iy), a

        for_y:
            ld a, e_vy(iy)
            and #0
            jr z, cero_y

            ld a, (y_ban)
            and #0
            jr z, new_y_ban
                ld b, a
                ld a, e_vy(iy)
                xor b
                jr z, cero_y
                move_y:
                    ld a, #0
                    ld (y_ban), a
                    ret

            new_y_ban:
                ld a, e_vy(iy)
                ld (y_ban), a

            cero_y:
                ld a, #0
                ld e_vy(iy), a


no_player:    
    ld a, e_t(iy)
    ld b, a
    ld a, (t_enemy)
    xor b
    jr nz, no_enemy

no_enemy:   
    ld a, e_t(iy)
    ld b, a
    ld a, (t_caja)
    xor b
    jr nz, no_caja

no_caja:    
    ld a, e_t(iy)
    ld b, a
    ld a, (t_bala)
    xor b
    ret z


pair_not_col:

ret

collider_check_type_ix::

ret