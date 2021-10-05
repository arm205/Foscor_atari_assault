.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"
.include "collider.h.s"



;                   _name, _x, _y, _w, _h, _vx, _vy, _c, _b, _dest_c

DefineEnemyEntity enemy, 20, 20, 4, 8, -1, 0, 0xFF, 1

DefineEnemy2Entity enemy2, 20, 40, 4, 8, -1, 0, 0xFF, 2

DefinePlayerEntity player, 20, 180, 2, 8, -1, 0, 0x0F, 0

DefineCajaEntity caja, 40, 100, 2, 8, 0, 0, 0xF0, 0

;DefineBalaEntity bala, 20, 180, 2, 8, 0, 0, 0xF0, 0, 2
final_text: .asciz "GAME OVER"


man_game_init::
    call E_M_init

    call rendersys_init
    call physics_sys_init
    call input_init

    ld hl, #enemy
    call man_game_entity_creator
    ld hl, #enemy2
    call man_game_entity_creator
    ld hl, #caja
;    call man_game_entity_creator
;    ld hl, #bala
    call man_game_entity_creator
    ld hl, #player
    call man_game_entity_creator



ret

;;INPUT:HL: Puntero al tipo de entidad que se quiera crear

man_game_entity_creator::
    call E_M_create
ret






man_game_update::
 
   ;; Init system
    call E_M_getEntityArray
   call input_update
    call E_M_getEntityArray
   call ia_update
   call E_M_getEntityArray
   call collider_update
    call E_M_getEntityArray
   call physics_sys_update
   ret



man_game_render::
    call E_M_getEntityArray
    call rendersys_update
ret

man_game_end::
call E_M_init
cpctm_clearScreen_asm #0

ld de, #0xC000
ld c, #20
ld b, #92
call cpct_getScreenPtr_asm
ld iy, #final_text
call cpct_drawStringM0_asm

jr .

