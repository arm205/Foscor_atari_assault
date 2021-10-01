.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"





DefineEnemyEntity enemy, 20, 20 , 4, 8, -1, 0, 0xFF

DefinePlayerEntity player, 20, 180 , 2, 8, -1, 0, 0x0F

DefineCajaEntity caja, 40, 100 , 2, 8, 0, 0, 0xF0


man_game_init::
    call E_M_init

    call rendersys_init
    call physics_sys_init
    call input_init

    ld hl, #player
    call man_game_entity_creator
    ld hl, #enemy
    call man_game_entity_creator
    ld hl, #caja
    call man_game_entity_creator



ret

;;INPUT:HL: Puntero al tipo de entidad que se quiera crear

man_game_entity_creator::
    call E_M_create
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