.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"



;                   _name, _x, _y, _w, _h, _vx, _vy, _c, _b, _dest_c

DefineEnemyEntity enemy, 20, 20, 4, 8, -1, 0, 0xFF, 1, 0

DefineEnemy2Entity enemy2, 20, 40, 4, 8, -1, 0, 0xFF, 2, 0

DefinePlayerEntity player, 20, 180, 2, 8, -1, 0, 0x0F, 0, 0

DefineCajaEntity caja, 40, 100, 2, 8, 0, 0, 0xF0, 0, 0

DefineBalaEntity bala, 30, 100, 1, 1, 0, 0, 0xF0, 0, 0

player_shot: .db 0;


man_game_init::
    call E_M_init

    call rendersys_init
    call physics_sys_init
    call input_init

    ld hl, #player
    call man_game_entity_creator
    ld hl, #enemy
    call man_game_entity_creator
    ld hl, #enemy2
    call man_game_entity_creator
    ld hl, #caja
    call man_game_entity_creator



ret

;;INPUT:HL: Puntero al tipo de entidad que se quiera crear

man_game_entity_creator::
    call E_M_create
ret

man_game_create_bala::
; comprobacion de si ya hay una creada
ld a, (player_shot)
and a
jr z, crear
ret
crear:
;;cargo en hl la bala
    ld hl, #bala
; me voy al valor de x y se lo copio +1
    ld de, #e_x
    add hl, de
    ld a, e_x(ix)
    add e_w(ix)
    ld (hl), a
; me voy al valor de y y se lo copio
    add hl, de
    ld a, e_y(ix)
    add #4
    ld (hl), a
; vuelvo a la posicion de inicio de la bala y la creo    

    ld hl, #bala
    call man_game_entity_creator
    ld a, (player_shot)
    add #1
ret





man_game_update::
 
   ;; Init system
    call E_M_getEntityArray
   call physics_sys_update
    call E_M_getEntityArray
   call input_update
    call E_M_getEntityArray
   call ia_update
   ret



man_game_render::
    call E_M_getEntityArray
    call rendersys_update
ret