.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"
.include "collider.h.s"


enemy: .db t_enemy, cmp_collider | cmp_render | cmp_ia, 4, 10, 4, 16, 1, 0, 0, 0, 0xFF, 1
.dw #_h_array
.db 0xCC, 0xCC, t_player | t_caja

enemy2: .db t_enemy, cmp_collider | cmp_render | cmp_ia, 4, 42, 4, 16, 0, 0, 0, 0, 0xFF, 0
.dw #_h_array
.db 0xCC, 0xCC, t_player | t_caja

enemy3: .db t_enemy, cmp_collider | cmp_render | cmp_ia, 4, 42, 4, 16, 0, 2, 0, 0, 0xFF, 2
.dw #_h_array
.db 0xCC, 0xCC, t_player | t_caja

player: .db t_player, cmp_collider | cmp_render | cmp_input, 4, 160, 4, 16, -1, 0, 0, 0, 0x0F, 0
.dw #_g_array_0
.db 0xCC, 0xCC, t_enemy | t_caja | t_salida


caja: .db t_caja, cmp_collider | cmp_render, 32, 104, 4, 16, 0, 0, 0, 0, 0xF0, 0
.dw #_spriteCaja
.db 0xCC, 0xCC, 0xCC, t_player


salida: .db t_salida, cmp_collider, 12, 0, 8, 10, 0, 0, 0, 0, 0xF0, 0, 0xCC, 0xCC, 0xCC, 0xCC, t_player

salida:: .db t_salida, cmp_collider | cmp_render, 0, 0, 2, 8, 0, 0, 0xF0, 0, 0xCC, 0xCC, 0xCC, 0xCC, t_player


final_text: .asciz "GAME OVER"
win_text: .asciz "YOU WIN!!!"

_game_regresive_clock:: .db #0x0

man_game_init::
    ;;Inicializar Entity Manager
    call    E_M_init
    ;;Inicializar Level Manager
    call    L_M_init
    ;;Inicializar Render System
    call    _render_sys_init
    ;;Inicializar Physics System
    call    physics_sys_init
    ;;Inicializar Input System
    call    input_init
    
    
    ;;Render Tile Map
    call _render_sys_drawTileMap

ret

;;INPUT:HL: Puntero al tipo de entidad que se quiera crear

man_game_entity_creator::
    call E_M_create
ret
man_game_update::
     
    ;;cpctm_setBorder_asm HW_YELLOW
    call E_M_getEntityArray
    call input_update

    ;;cpctm_setBorder_asm HW_GREEN
    call E_M_getEntityArray
    call ia_update

    ;;cpctm_setBorder_asm HW_BLUE
    call E_M_getEntityArray
    call collider_update

    ;;cpctm_setBorder_asm HW_PINK
    call E_M_getEntityArray
    call physics_sys_update
   ret
man_game_render::
    ;;cpctm_setBorder_asm HW_RED
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

;;jr .

call L_M_resetCurrentLevel
ret  

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

