.include "entity.h.s"


still_eating:: .db 0
vengo_de_comer:: .db 0


player_moving_up::
.dw  _g_array_00
.dw  _g_array_01
.dw 0x0
.dw player_moving_up


player_moving_down::
.dw  _g_array_04
.dw  _g_array_05
.dw 0x0
.dw player_moving_down


player_moving_right::
.dw  _g_array_08
.dw  _g_array_09
.dw 0x0
.dw player_moving_right


player_moving_left::
.dw  _g_array_12
.dw  _g_array_13
.dw 0x0
.dw player_moving_left


player_eating_up::
.dw  _g_array_02
.dw  _g_array_03
.dw  _g_array_02
.dw 0x0
.dw player_eating_up


player_eating_down::
.dw  _g_array_06
.dw  _g_array_07
.dw  _g_array_06
.dw 0x0
.dw player_eating_down


player_eating_right::
.dw  _g_array_10
.dw  _g_array_11
.dw  _g_array_10
.dw 0x0
.dw player_eating_right


player_eating_left::
.dw  _g_array_14
.dw  _g_array_15
.dw  _g_array_14
.dw 0x0
.dw player_eating_left


animation_init::
    xor a
    ld (still_eating), a
    ld (vengo_de_comer), a
ret

animation_update::
    ld d, a
    ld a, #cmp_animation
    call E_M_for_all_matching
ret



; IX: Entidad
animation_update_one::
; Compruebo si la entidad es player
    ld a, e_t(ix)
    xor #t_player
    jr nz, no_player
    ;; Esto es player


; miramos si el player sigue en la animacion de comer cajas
    ld a, (still_eating)
    or #0
    jr nz, sigue_comiendo

    ld a, e_be(ix)
    or #0
    jr nz, empezar_comer

        jr no_player

    empezar_comer:
    call check_new_direction_eating
    ret



    sigue_comiendo:
    call misma_direccion
    ret
;
    no_player:
;
    ld a, e_vx(ix)
    or #0
    jr nz, no_parado

    ld a, e_vy(ix)
    or #0
    jr nz, no_parado
;; Player parado
    ret

    no_parado:
;Comprobamos si tiene la misma direccion que en la iteracion anterior

    ld a, e_vx(ix)
    xor e_vx_prev(ix)
    jr nz, distinta_direccion

    ld a, e_vy(ix)
    xor e_vy_prev(ix)
    jr nz, distinta_direccion

    ld a, (vengo_de_comer)
    or #0
    jr nz, distinta_direccion

    misma_dir:
        call misma_direccion
        ret

    distinta_direccion:
    xor a
    ld (vengo_de_comer), a
    call check_new_direction

ret



;; HL: Sprite a cargar
cargar_sprite_pack:

    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl


    ld e_animptr(ix), l
    ld e_animptr+1(ix), h

    ld e_spr(ix), c
    ld e_spr+1(ix), b

    ld a, #0x1
    ld e_animcont(ix), a
ret




check_new_direction:

;;  DE MOMENTO ESTA PARA EL PLAYER SOLO     
;;
;; EJE X

    ld a, e_vx(ix)
    cp #0
    jr z, mirar_eje_y
    jp m, izquierda


    derecha:

;    ld a, e_be(ix)
;    or #0
;    jr z, solo_derecha
;
;    call check_new_direction_eating
;    ret
;
;
;    solo_derecha:
    ld hl, #player_moving_right
    call cargar_sprite_pack

    ret

    izquierda:
;    ld a, e_be(ix)
;    or #0
;    jr z, solo_izquieda
;
;    call check_new_direction_eating
;    ret
;
;
;    solo_izquieda:
    ld hl, #player_moving_left
    call cargar_sprite_pack

    ret


;; EJE Y
 mirar_eje_y:
 
    ld a, e_vy(ix)
    cp #0
    jr z, todo_cero
    jp m, arriba


    abajo:
;    ld a, e_be(ix)
;    or #0
;    jr z, solo_abajo
;
;    call check_new_direction_eating
;    ret
;
;
;    solo_abajo:

    ld hl, #player_moving_down
    call cargar_sprite_pack

    ret

    arriba:
;    ld a, e_be(ix)
;    or #0
;    jr z, solo_arriba
;
;    call check_new_direction_eating
;    ret
;
;
;    solo_arriba:
;
    ld hl, #player_moving_up
    call cargar_sprite_pack
    ret

    todo_cero:

;    call check_new_direction_eating

ret

check_new_direction_eating:
;; EJE X
    ld a, #1
    ld (vengo_de_comer), a

    ld a, e_vx_prev(ix)
    cp #0
    jr z, mirar_eje_y_eat
    jp m, izquierda_eat


    derecha_eat:


    ld hl, #player_eating_right
    ld a, #1
    ld (still_eating), a
    call cargar_sprite_pack
    ret


    izquierda_eat:
    ld hl, #player_eating_left
    ld a, #1
    ld (still_eating), a
    call cargar_sprite_pack
    ret



;; EJE Y
 mirar_eje_y_eat:
 
    ld a, e_vy_prev(ix)
    cp #0
    jp m, arriba_eat


    abajo_eat:

    ld hl, #player_eating_down
    ld a, #1
    ld (still_eating), a
    call cargar_sprite_pack
    ret

    arriba_eat:
    ld hl, #player_eating_up
    ld a, #1
    ld (still_eating), a
    call cargar_sprite_pack
    ret



misma_direccion::

    ld a, e_animcont(ix)
    dec a
    jr z, llegado_a_cero
        ld e_animcont(ix), a
        ret

    llegado_a_cero:


    ld l, e_animptr(ix)
    ld h, e_animptr+1(ix)

    continueAnimation:
    ld c, (hl)
    inc hl
    ld b, (hl)
    inc hl

    ld a, C
    or b
    jr z, resetAnimation

    ld e_animptr(ix), l
    ld e_animptr+1(ix), h

    ld e_spr(ix), c
    ld e_spr+1(ix), b

    ld a, #animation_speed
    ld e_animcont(ix), a

ret


resetAnimation:
    ld a, (hl)
    inc hl
    ld h, (hl)
    ld l, a
    ld a, (still_eating)
    or #0
    jr z, continuar_normal

    call check_new_direction

    continuar_normal:
    xor a
    ld (still_eating), a


jr continueAnimation