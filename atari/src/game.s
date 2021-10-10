.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"
.include "collider.h.s"

DefineEnemyEntity enemy, 20, 0, 4, 32, -1, 0, 0xFF, 1, #_h_array_1
DefineEnemy2Entity enemy2, 20, 40, 4, 32, -1, 0, 0xFF, 1, #_h_array_1
DefinePlayerEntity player, 20, 170, 4, 32, -1, 0, 0x0F, 0, #_g_array_0
DefineCajaEntity caja, 50, 110, 2, 4, 0, 0, 0xF0, 0, 0
final_text: .asciz "GAME OVER"


man_game_init::
    call E_M_init
    call _render_sys_init
    call physics_sys_init
    call input_init

    ld hl, #enemy
    call man_game_entity_creator


    ld hl, #enemy2
    call man_game_entity_creator



    ld hl, #caja
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
 cpctm_setBorder HW_BLUE ;; Probando 
    call E_M_getEntityArray
    call input_update


 cpctm_setBorder HW_WHITE
    call E_M_getEntityArray
    call ia_update


 cpctm_setBorder HW_GREEN
    call E_M_getEntityArray
    call collider_update


 cpctm_setBorder HW_RED
    call E_M_getEntityArray
    call physics_sys_update
   ret
man_game_render::
    call E_M_getEntityArray
    call _render_ents_update
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