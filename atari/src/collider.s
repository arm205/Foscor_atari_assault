.include "entity.h.s"
.include "cpctelera.h.s"
.include "collider.h.s"
.include "game.h.s"
.include "ia.h.s"
.include "assets/tiles/tilemap_02.h.s"



collider_update::
    ld d, a
    push de
    push ix
    ld a, #cmp_collider
    call E_M_for_all_pairs_matching
    pop ix
    pop de
    ld a, #cmp_collider
    call E_M_for_all_matching


ret



; INPUT: puntero a entidad con componente colision

collider_tilemap::

;nos quedamos solo con el player y enemigos
    ld a, e_t(ix)
    and #0x03
    ret z

;; calcular direccion a la que va la entidad en cada eje
;; EJE X
    ld a, e_vx(ix)
    cp #0
    jr z, ya_x
    jp m, no_right
    ;se mueve a la derecha
        call our_position_start
        ld a, #2
        call check_tile
        jr ya_x

    no_right:
    ;se mueve a la izquierda
        call our_position_start
        ld a, #8
        call check_tile

    ya_x:


;; EJE Y
    ld a, e_vy(ix)
    cp #0
    jr z, ya_y
    jp m, no_down
    ;se mueve hacia abajo
        call our_position_start
        ld a, #4
        call check_tile
        jr ya_y

    no_down:
    ;se mueve hacia arriba
        call our_position_start
        ld a, #1
        call check_tile

    ya_y:





ret


our_position_start:

;tx=x/4
;ty=y/8
;tw=tilemap-width (20)
;p= tilemap + ty*w + tx



    ld a, e_y(ix)

    ;A=ty(y/8)
    srl a
    srl a
    srl a



;HL=A = ty
    ld h, #0
    ld l, a


    ld b, a

;HL=20*ty    

    add hl, hl ;2*ty
    add hl, hl ;4*ty
    ld__de_hl
    add hl, hl ;8*ty
    add hl, hl ;16*ty
    add hl, de


    ld a, e_x(ix)
    srl a
    srl a

    add_hl_a
    ld de, #_tilemap
    add hl, de


ret


our_position_end:

;tx=x/4
;ty=y/8
;tw=tilemap-width (20)
;p= tilemap + ty*w + tx



    ld a, e_y(ix)

    ;A=ty(y/8)
    srl a
    srl a
    srl a



;HL=A = ty
    ld h, #0
    ld l, a



;HL=20*ty    

    add hl, hl ;2*ty
    add hl, hl ;4*ty
    ld__de_hl
    add hl, hl ;8*ty
    add hl, hl ;16*ty
    add hl, de


    ld a, e_x(ix)
    add e_w(ix)
    dec a
    srl a
    srl a

    add_hl_a
    ld de, #_tilemap
    add hl, de


ret

;INPUT: A, relative direction of tile to the entity, 1-top 2-right 4-down 8-left
check_tile:


;; ARRIBA
    cp #1
    jr nz, no_arriba
        ld a, #20
        sub_hl_a
        call check_type_tile
        ld b, a
     
        call our_position_end
        ld a, #20
        sub_hl_a
        call check_type_tile
        or b
        ret z

            ;; Collision detected
            ld e_vy(ix), #0
            ret



    no_arriba:

    ;; DERECHA
        cp #2
        jr nz, no_derecha
            inc hl
            call check_type_tile
            ld b, a

            ld a, #20
            add_hl_a
            call check_type_tile
            or b
            ret z
                ;; Collision detected
                ld e_vx(ix), #0
                ld a, e_t(ix)
                xor #t_enemy
                    jr nz, no_en
                    ld a, #2
                    call ia_colides_tilemap

                no_en:    
                ret
    no_derecha:
    ;; ABAJO    
        cp #4
        jr nz, no_abajo

;           para sumarle la altura del personaje

            ld a, #40
            add_hl_a
            call check_type_tile
            ld b, a
            call our_position_end
            ld a, #40
            add_hl_a
            call check_type_tile
            or b
            ret z
                ;; Collision detected
                ld e_vy(ix), #0
                ret

    no_abajo:

    ;; IZQUIERDA 
    cp #8
    jr nz, nada   
        dec hl
        call check_type_tile
        ld b, a
        ld a, #20
        add_hl_a
        call check_type_tile
        or b
        ret z
            ;; Collision detected
            ld e_vx(ix), #0
            ld a, e_t(ix)
            xor #t_enemy
                jr nz, no_en_2
                ld a, #8
                call ia_colides_tilemap

            no_en_2:  
            ret
    nada:
    ret


;Input: HL, pointer to de type to check to collide
check_type_tile:

    ld a, (hl)
    or #0x0
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

            call collider_check_type_iy
             	;ex__hl_ix
 	            ;ex__hl_iy
                ;ex__hl_ix
            ;call collider_check_type_ix

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

    ld a, #t_player
    xor e_t(iy)
    jr nz, no_player

        ld a, e_col(iy)
        and e_t(ix)
        ret z

        ld a, #t_enemy
        xor e_t(ix)
        jr nz, pl_otro
        pl_en:
            ;; Aqui tendriamos que matar al jugador
            ld a, #0x00 
            ld e_c(ix), a
            ;;call man_game_end
            call L_M_resetCurrentLevel
            ret

        pl_otro:
        ;Compruebo si es caja 

        ld a, #t_caja
        xor e_t(ix)
        jr nz, pl_salida
        ; Compruebo si tiene el behavior de romper caja
        ld a, e_be(iy)
        xor #1
        jr nz, for_x
        ;tiene el behavior asi que la rompe
        ;;ld a, #0
        ;;ld e_c(ix), a
        ;;ld e_cmp(ix), a
        ;;ld e_be(iy), a

        call E_M_prepateToDelete
        
        ret

; No tiene el behavior asi que colisiona

        call colision_con_caja
        ret


        pl_salida:

            call man_game_win
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


colision_con_caja::

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




;collider_check_type_ix::
;
;    ;;VERIFICAR SI IX ES EL JUGADOR     
;    ld b, e_t(ix)
;    ld a, (t_player)
;    xor b
;
;    ;;CASO: IX NO ES EL JUGADOR
;    jr nz, no_player_2
;
;        ;;VERIFICAR SI HAY COLISION CON IY
;        ld a, e_col(ix)
;        and e_t(iy)
;        ret z
;        
;        ;;VERIFIFICAR SI IX COLISIONA CON UN ENEMIGO O UNA CAJA
;        ld b, e_t(iy)
;        ld a, (t_enemy)
;        xor b
;
;        ;;CASO: IX COLISIONA CON UNA CAJA
;        jr nz, pl_caja_2
;
;        ;;CASO: IX COLISIONA CON UN ENEMIGO
;        pl_en_2:
;            ;;Aqui tendriamos que matar al jugador
;            ld a, #0x00 
;            ld e_c(ix), a
;            call man_game_end
;            ret
;
;
;
;        pl_caja_2:
;            ;;VERIFICAR SI LA CAJA TIENE EL BEHAVIOUR
;            ld a, e_be(ix)
;            xor #1
;
;            ;;CASO: LA CAJA NO ES ROMPIBLE
;            jr nz, for_x_2
;
;            ;;CASO: LA CAJA ES ROMPIBLE
;            ld a, #0
;            ld e_c(iy), a
;            ld e_cmp(iy), a
;            ld e_be(ix), a
;        ret
;
;
;; No tiene el behavior asi que colisiona
;        for_x_2:
;            ld a, e_vx(ix)
;            or #0
;            jr z, cero_x_2
;
;            ld a, (x_ban_2)
;            and a
;            jr z, new_x_ban_2
;                ld b, a
;                ld a, e_vx(ix)
;                xor b
;                jr z, cero_x_2
;                move_x_2:
;                
;                    ld a, #0
;                    ld (x_ban_2), a
;                    jr for_y_2
;                    
;
;            new_x_ban_2:
;                ld a, e_vx(ix)
;                ld (x_ban_2), a
;
;
;
;            cero_x_2:
;                ld a, #0
;                ld e_vx(ix), a
;        for_y_2:
;
;            ld a, e_vy(ix)
;            or #0
;            jr z, cero_y_2
;
;            ld a, (y_ban_2)
;            and a
;            jr z, new_y_ban_2
;                ld b, a
;                ld a, e_vy(ix)
;                xor b
;                jr z, cero_y_2
;                move_y_2:
;                    ld a, #0
;                    ld (y_ban_2), a
;                    ret
;
;            new_y_ban_2:
;                ld a, e_vy(ix)
;                ld (y_ban_2), a
;
;            cero_y_2:
;                ld a, #0
;                ld e_vy(ix), a
;                ret
;
;
;no_player_2:  
;;   DEJO ESTO POR SI EN UN FUTURO TENEMOS OTRAS ENTIDADES QUE COLISIONEN  
;;    ld a, e_t(iy)
;;    ld b, a
;;    ld a, (t_enemy)
;;    xor b
;;    jr nz, no_enemy
;
;;no_enemy:   
;pair_not_col_2:
;
;ret
;
;
;
;
;