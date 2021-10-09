.include "entity.h.s"
.include "cpctelera.h.s"
.include "collider.h.s"
.include "game.h.s"



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
    or b
    jr z, no_colisionan

        call check_collision
        jr c, no_colisionan
            ;cpctm_setBorder_asm HW_WHITE

            ;call collider_check_type_iy
             	;ex__hl_ix
 	            ;ex__hl_iy
                ;ex__hl_ix
            call collider_check_type_ix

             	;ex__hl_ix
 	            ;ex__hl_iy
                ;ex__hl_ix




no_colisionan:
;cpctm_setBorder_asm HW_BLUE
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
; if (e_x(iy)+e_w(iy)-e_x(ix) < 0) No_col
    ld a, e_y(iy)
    add e_h(iy)
    sub e_y(ix)
    ret c


; if (e_x(ix)+e_w(ix)-e_x(iy) < 0) No_col

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
        ret z

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
        ; Compruebo si tiene el behavior de romper caja

        ld a, e_be(iy)
        xor #1
        jr nz, for_x
        ;tiene el behavior asi que la rompe
        ld a, #0
        ld e_c(ix), a
        ld e_be(iy), a
        ret


; No tiene el behavior asi que colisiona
        for_x:
            ld a, e_vx(iy)
            or #0
            jr z, cero_x

            ld a, (x_ban)
            and a
            jr z, new_x_ban
                ld b, a
                ld a, e_vx(iy)
                xor b
                jr z, cero_x
                move_x:
                
                    ld a, #0
                    ld (x_ban), a
                    jr for_y
                    

            new_x_ban:
                ld a, e_vx(iy)
                ld (x_ban), a



            cero_x:
                ld a, #0
                ld e_vx(iy), a
        for_y:

            ld a, e_vy(iy)
            or #0
            jr z, cero_y

            ld a, (y_ban)
            and a
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
                ret


no_player:  
;   DEJO ESTO POR SI EN UN FUTURO TENEMOS OTRAS ENTIDADES QUE COLISIONEN  
;    ld a, e_t(iy)
;    ld b, a
;    ld a, (t_enemy)
;    xor b
;    jr nz, no_enemy

;no_enemy:   
pair_not_col:

ret


collider_check_type_ix::

    ;;VERIFICAR SI IX ES EL JUGADOR     
    ld b, e_t(ix)
    ld a, (t_player)
    xor b

    ;;CASO: IX NO ES EL JUGADOR
    jr nz, no_player_2

        ;;VERIFICAR SI HAY COLISION CON IY
        ld a, e_col(ix)
        and e_t(iy)
        ret z
        
        ;;VERIFIFICAR SI IX COLISIONA CON UN ENEMIGO O UNA CAJA
        ld b, e_t(iy)
        ld a, (t_enemy)
        xor b

        ;;CASO: IX COLISIONA CON UNA CAJA
        jr nz, pl_caja_2

        ;;CASO: IX COLISIONA CON UN ENEMIGO
        pl_en_2:
            ;;Aqui tendriamos que matar al jugador
            ld a, #0x00 
            ld e_c(ix), a
            call man_game_end
            ret



        pl_caja_2:
            ;;VERIFICAR SI LA CAJA TIENE EL BEHAVIOUR
            ld a, e_be(ix)
            xor #1

            ;;CASO: LA CAJA NO ES ROMPIBLE
            jr nz, for_x_2

            ;;CASO: LA CAJA ES ROMPIBLE
            ;;ld a, #0
            ;;ld e_c(iy), a
            ;;ld e_cmp(iy), a
            ;;ld e_be(ix), a

            ;;DESTRUIR LA CAJA
            call E_M_deleteEntity
        ret


; No tiene el behavior asi que colisiona
        for_x_2:
            ld a, e_vx(ix)
            or #0
            jr z, cero_x_2

            ld a, (x_ban_2)
            and a
            jr z, new_x_ban_2
                ld b, a
                ld a, e_vx(ix)
                xor b
                jr z, cero_x_2
                move_x_2:
                
                    ld a, #0
                    ld (x_ban_2), a
                    jr for_y_2
                    

            new_x_ban_2:
                ld a, e_vx(ix)
                ld (x_ban_2), a



            cero_x_2:
                ld a, #0
                ld e_vx(ix), a
        for_y_2:

            ld a, e_vy(ix)
            or #0
            jr z, cero_y_2

            ld a, (y_ban_2)
            and a
            jr z, new_y_ban_2
                ld b, a
                ld a, e_vy(ix)
                xor b
                jr z, cero_y_2
                move_y_2:
                    ld a, #0
                    ld (y_ban_2), a
                    ret

            new_y_ban_2:
                ld a, e_vy(ix)
                ld (y_ban_2), a

            cero_y_2:
                ld a, #0
                ld e_vy(ix), a
                ret


no_player_2:  
;   DEJO ESTO POR SI EN UN FUTURO TENEMOS OTRAS ENTIDADES QUE COLISIONEN  
;    ld a, e_t(iy)
;    ld b, a
;    ld a, (t_enemy)
;    xor b
;    jr nz, no_enemy

;no_enemy:   
pair_not_col_2:

ret




