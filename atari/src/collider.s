.include "entity.h.s"
.include "cpctelera.h.s"
.include "collider.h.s"
.include "game.h.s"
.include "ia.h.s"



collider_update::
    ld d, a
    push de
    push ix

    ld a, #cmp_collider
    call E_M_for_all_matching

    pop ix
    pop de

    ld  a, (_level_reseted)
    xor #0x0
    ret nz


    ld a, #cmp_collider
    call E_M_for_all_pairs_matching
    

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

    ; comprobación diagonal


    ld a, e_vx(ix)
    or #0
    ret z

    ld a, e_vy(ix)
    or #0
    ret z

    ; HAY DIAGONAL!!!!!!!!!

    ld a, e_vx_prev(ix)
    or #0
    jr nz, no_x
        ld e_vx(ix), a
        ret
    
    no_x:
    ld a, e_vy_prev(ix)
    or #0
    jr nz, no_y
        ld e_vy(ix), a

   
    no_y:
        xor a
        ld e_vx(ix), a



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
    ld de, #0x40
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
    ld de, #0x40
    add hl, de


ret



our_position_foot:

;tx=x/4
;ty=y/8
;tw=tilemap-width (20)
;p= tilemap + ty*w + tx



    ld a, e_y(ix)
    add e_h(ix)

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
    srl a
    srl a

    add_hl_a
    ld de, #0x40
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
            ld a, e_t(ix)
            xor #t_enemy
                jr nz, no_en_3
                ld a, #1
                call ia_colides_tilemap

            no_en_3:  
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

            call our_position_foot
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
                ld a, e_t(ix)
                xor #t_enemy
                    jr nz, no_en_4
                    ld a, #4
                    call ia_colides_tilemap

                no_en_4:  
                ret

    no_abajo:

    ;; IZQUIERDA 
    cp #8
    jr nz, nada   
        ;; ESTOY A MITAD DE TILE??
        call check_half_tile
        or #0
        ret z

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





check_half_tile:
    ld a, e_x(ix)
    ld b, #4

contando_multiplos:

    sub b

    jr z, multiplo

    jr c, moverse_mismo_tile


    jr contando_multiplos

multiplo:
    ld a, #1
ret

moverse_mismo_tile:
    ld a, #0
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

    ld a, e_t(iy)
    xor #t_player
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
        jr nz, colisionar_caja
        ;tiene el behavior asi que la rompe
        ;;ld a, #0
        ;;ld e_c(ix), a
        ;;ld e_cmp(ix), a
        ;;ld e_be(iy), a


        call check_caja_stage
        ;; returns in A = 0 if box is destroyed
        and a
        ret z

        call colision_con_caja
        
        ret

    colisionar_caja:
; No tiene el behavior asi que colisiona

        call colision_con_caja
        ret


        pl_salida:

            call L_M_levelPassed
        ret



no_player:  
;   DEJO ESTO POR SI EN UN FUTURO TENEMOS OTRAS ENTIDADES QUE COLISIONEN  
    ld a, e_t(iy)
    xor #t_enemy
    jr nz, no_enemy

        ld a, e_col(iy)
        and e_t(ix)
        ret z

        ld a, e_t(ix)
        xor #t_caja
        jr nz, no_en_caja

        call colision_con_caja
        

    no_en_caja:
no_enemy:   
pair_not_col:

ret



; Input: IX: caja

check_caja_stage:
    ld a, e_be(ix)
    dec a
    jr z, eliminar_caja

    cp #1
    jr nz, no_caja_amarilla

    ;CAJA 1 TOQUE: VERDE
        ld e_be(ix), a
        ld hl, #_spriteCaja_0
        ld e_spr(ix), l
        ld e_spr+1(ix), h


    no_caja_amarilla:

    cp #2
    jr nz, no_caja_roja

    ;CAJA 2 TOQUE: AMARILLA
        ld e_be(ix), a
        ld hl, #_spriteCaja_1
        ld e_spr(ix), l
        ld e_spr+1(ix), h



    no_caja_roja:

    cp #3
    jr nz, no_caja_azul

    ;CAJA 2 TOQUE: ROJA
        ld e_be(ix), a
        ld hl, #_spriteCaja_2
        ld e_spr(ix), l
        ld e_spr+1(ix), h


    no_caja_azul:
    ld a, #1
    ret
    

eliminar_caja:
    call E_M_prepateToDelete
    xor a

ret


colision_con_caja::
    ; Compruebo si colisiona en x con que lado
    ld a, e_x(iy)
    xor e_x(ix)
    jr nz, no_x_igual
        ;;ambas entidades estan en la misma posicion x
        ld a, e_y(iy)
        cp e_y(ix)
        jp m, yp_menor_yc
        yp_mayor_yc:
            ld a, e_vy(iy)
            cp #0
            jp m, ban_y_menor
                ret
            ban_y_menor:
            xor a
            ld e_vy(iy), a
            ret

        yp_menor_yc:
            ld a, e_vy(iy)
            cp #0
            jp m, not_ban_y_mayor
                xor a
                ld e_vy(iy), a
                ret
            not_ban_y_mayor:
            ret


    no_x_igual:
    ; Compruebo si colisiona en y con que lado

        ld a, e_y(iy)
        xor e_y(ix)
        jr nz, no_y_igual
            ;;ambas entidades estan en la misma posicion x
            ld a, e_x(iy)
            cp e_x(ix)
            jp m, xp_menor_xc
            xp_mayor_xc:
                ld a, e_vx(iy)
                cp #0
                jp m, ban_x_menor
                    ret
                ban_x_menor:
                xor a
                ld e_vx(iy), a
                ret

            xp_menor_xc:
                ld a, e_vx(iy)
                cp #0
                jp m, not_ban_x_mayor
                    xor a
                    ld e_vx(iy), a
                    ret
                not_ban_x_mayor:
                ret


    no_y_igual:


ret
