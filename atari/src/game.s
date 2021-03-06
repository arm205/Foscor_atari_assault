;;Inside The Anthill - Videogame
;;
   ;; Copyright (C) 2021 Alba Ruiz, Javier Sibada and Miguel Teruel.
;;
   ;; This program is free software: you can redistribute it and/or modify
   ;; it under the terms of the GNU General Public License as published by
   ;; the Free Software Foundation, either version 3 of the License, or
   ;; (at your option) any later version.
;;
   ;; This program is distributed in the hope that it will be useful,
   ;; but WITHOUT ANY WARRANTY; without even the implied warranty of
   ;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   ;; GNU General Public License for more details.
;;
   ;; You should have received a copy of the GNU General Public License
   ;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "render.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"
.include "collider.h.s"
.include "animation.h.s"
.include "interrupt.h.s"


enemy:: .db t_enemy, cmp_collider | cmp_render | cmp_ia | cmp_animation, 4, 10, 4, 16, 0, 0, 0, 0, 0xFF, 0
.dw #_h2_array_0, 0x0, ghost_moving
.db animation_speed, 0x00, 0x10, t_player | t_caja

enemy2:: .db t_enemy, cmp_collider | cmp_render | cmp_ia | cmp_animation, 4, 42, 4, 16, 1, 0, 0, 0, 0xFF, 1
.dw #_h_array_0, 0x0, ant_moving
.db  animation_speed, 0x00, 0x10, t_player | t_caja

enemy3:: .db t_enemy, cmp_collider | cmp_render | cmp_ia | cmp_animation, 4, 42, 4, 16, 0, 2, 0, 0, 0xFF, 2
.dw #_h_array_0, 0x0, ant_moving
.db animation_speed, 0x00, 0x10, t_player | t_caja

player:: .db t_player, cmp_collider | cmp_render | cmp_input | cmp_animation, 40, 0, 4, 16, 0, 0, 0, 0, 0x0F, 0
.dw #_g_array_04, 0x0, player_moving_down
.db animation_speed, 0x00, 0x10, t_enemy | t_caja | t_salida


caja_azul:: .db t_caja, cmp_collider | cmp_render, 0, 0, 4, 16, 0, 0, 0, 0, 0xF0, 4
.dw #_spriteCaja_3, 0x0, 0x0
.db animation_speed, 0x00, 0x10, t_player

caja_roja:: .db t_caja, cmp_collider | cmp_render, 0, 0, 4, 16, 0, 0, 0, 0, 0xF0, 3
.dw #_spriteCaja_2, 0x0, 0x0
.db animation_speed, 0x00, 0x10, t_player

caja_amarilla:: .db t_caja, cmp_collider | cmp_render, 0, 0, 4, 16, 0, 0, 0, 0, 0xF0, 2
.dw #_spriteCaja_1, 0x0, 0x0
.db animation_speed, 0x00, 0x10, t_player

caja_verde:: .db t_caja, cmp_collider | cmp_render, 0, 0, 4, 16, 0, 0, 0, 0, 0xF0, 1
.dw #_spriteCaja_0, 0x0, 0x0
.db animation_speed, 0x00, 0x10, t_player


salida:: .db t_salida, cmp_collider, 12, 0, 8, 10, 0, 0, 0, 0, 0xF0, 0, 0xCC, 0xCC, 0x0, 0x0, 0x0, 0x0, animation_speed, 0x00, 0x10, t_player


nada:: .db t_nada,  cmp_collider | cmp_ia | cmp_input, 12, 0, 8, 10, 0, 0, 0, 0, 0xF0, 0, 0xCC, 0xCC, 0x0, 0x0, 0x0, 0x0, animation_speed, 0x00, 0x10, 0


mandibula:: .db salida, cmp_collider | cmp_render, 0, 0, 4, 16, 0, 0, 0, 0, 0xF0, 0
.dw #_mandibulas, 0x0, 0x0
.db animation_speed, 0x00, 0x10, t_player


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
    ;;Inicializar Animation System
    call    animation_init

    call L_M_showMenuScreen
    
ret

;;INPUT:HL: Puntero al tipo de entidad que se quiera crear

man_game_entity_creator::
    call E_M_create
ret
man_game_update::
     
    ld  a, #0x0
    ld  (_level_reseted), a
    
    ld hl, #Key_Esc
    call check_keyPressed

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
    ld  a, (_level_reseted)
    xor #0x0
    ret nz

    call E_M_getEntityArray
    call animation_update

    call E_M_getEntityArray
    call physics_sys_update

   ret



man_game_render::
    ;;cpctm_setBorder_asm HW_RED
    call E_M_getEntityArray
    
    call _render_sys_update 
    call E_M_checkDelete
ret
;
;man_game_end::
;call E_M_init
;cpctm_clearScreen_asm #0
;
;ld de, #0xC000
;ld c, #20
;ld b, #92
;call cpct_getScreenPtr_asm
;ld iy, #final_text
;call cpct_drawStringM0_asm
;
;;;jr .
;
;call L_M_resetCurrentLevel
;ret  
;
;man_game_win::
;call E_M_init
;cpctm_clearScreen_asm #0
;
;ld de, #0xC000
;ld c, #20
;ld b, #92
;call cpct_getScreenPtr_asm
;ld iy, #win_text
;call cpct_drawStringM0_asm
;
;jr .

