.include "entity.h.s"


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



animation_update::
    ld d, a
    ld a, #cmp_animation
    call E_M_for_all_matching
ret



; IX: Entidad
animation_update_one::

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

        call misma_direccion
        ret

    distinta_direccion:
    call check_new_direction

ret



;; HL: Sprite a cargar
cargar_sprite_pack:

    ld e_animptr(ix), l
    ld e_animptr+1(ix), h

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

    ld hl, #player_moving_right
    call cargar_sprite_pack

    ret

    izquierda:

    ld hl, #player_moving_left
    call cargar_sprite_pack

    ret


;; EJE Y
 mirar_eje_y:
 
    ld a, e_vy(ix)
    cp #0
    jp m, arriba


    abajo:

    ld hl, #player_moving_down
    call cargar_sprite_pack

    ret

    arriba:

    ld hl, #player_moving_up
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


jr continueAnimation