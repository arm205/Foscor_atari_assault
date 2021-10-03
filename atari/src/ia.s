.include "entity.h.s"


screen_width = 80
screen_height = 200


; MODIFIES: A, C
ia_update_one_entity::
ld a, e_t(ix)
ld c, a
ld a, (t_enemy)
xor c
jr z, is_enemy
not_enemy:
    ld a, (t_bala)
    xor c
    jr z, is_bala

is_bala:
    call ia_auto_destroy
    jr acabado


is_enemy:
    call ia_for_enemy
acabado:

ret



;; Comportamiento de las entidades de tipo enemigo
ia_for_enemy:
    ld a, #screen_width
    sub e_w(ix)
    ld  c, a

    ld a, e_x(ix)
    add e_vx(ix)
    cp  c
    jr nc, cambia_vx
    jr no_cambia

    cambia_vx:
        ld  a, e_vx(ix)
        neg
        ld  e_vx(ix), a
    no_cambia:
ret


ia_auto_destroy::
    ld a, e_count(ix)
    dec a
    jr nz, no_destruir

     ;   call man_game_destroy_entity

no_destruir: 
   ld e_count(ix), a
ret





ia_update::
    ld d, a
    ld a, (cmp_ia)
    call E_M_for_all_matching

ret