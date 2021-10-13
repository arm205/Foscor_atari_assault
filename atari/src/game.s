.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"
.include "collider.h.s"


enemy: .db t_enemy, cmp_collider | cmp_render | cmp_ia, 20, 10, 4, 16, -1, 0, 0xFF, 1
.dw #_h_array_1
.db 0xCC, 0xCC, t_player

enemy2: .db t_enemy, cmp_collider | cmp_render | cmp_ia, 0, 42, 4, 16, 0, 0, 0xFF, 0
.dw #_h_array_0
.db 0xCC, 0xCC, t_player

player: .db t_player, cmp_collider | cmp_render | cmp_input, 20, 160, 8, 32, -1, 0, 0x0F, 0
.dw #_g_array_0
.db 0xCC, 0xCC, t_enemy | t_caja | t_salida


caja: .db t_caja, cmp_collider | cmp_render, 50, 100, 2, 8, 0, 0, 0xF0, 0, 0, 0xCC, 0xCC, 0xCC, 0xCC, t_player


salida: .db t_salida, cmp_collider | cmp_render, 0, 0, 2, 8, 0, 0, 0xF0, 0, 0xCC, 0xCC, 0xCC, 0xCC, t_player



DefineEnemyEntity enemy, 20, 20, 4, 16, -1, 0, 0xFF, 1, #_h_array
DefineEnemy2Entity enemy2, 20, 40, 4, 16, -1, 0, 0xFF, 1, #_h_array
DefinePlayerEntity player, 20, 170, 4, 16, -1, 0, 0x0F, 0, #_g_array_0
DefineCajaEntity caja, 50, 110, 2, 4, 0, 0, 0xF0, 0, 0
final_text: .asciz "GAME OVER"
win_text: .asciz "YOU WIN!!!"


man_game_init::
    call E_M_init
    call _render_sys_init
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

    ld hl, #salida
    call man_game_entity_creator


    ld hl, #enemy2
    ld__ix_hl
    ld e_x(ix), #8
    call man_game_entity_creator



ret

;;INPUT:HL: Puntero al tipo de entidad que se quiera crear

man_game_entity_creator::
    call E_M_create
ret
man_game_update::
 
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
    call _render_sys_update 
    call E_M_checkDelete
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

man_game_win::
call E_M_init
cpctm_clearScreen_asm #0

ld de, #0xC000
ld c, #20
ld b, #92
call cpct_getScreenPtr_asm
ld iy, #win_text
call cpct_drawStringM0_asm

jr .

