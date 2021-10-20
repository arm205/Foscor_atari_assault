.include "cpctelera.h.s"

_current_level_counter::    .db #0x0
_current_level::            .dw #_level_1
_current_tilemap::          .dw #0x0
_current_level_size::       .dw 0

_puntero::                 .dw 0

L_M_init::

    ;;Contador de niveles
    ld  a, #0x01
    ld  (_current_level_counter), a

    ;;Cargar primer nivel
    call    L_M_loadLevel

ret

;;HL CURRENT LEVEL
;;NO USAR HL AQUI PARA OTRA COSA
L_M_loadLevel::
    
    ld  hl, (_current_level)
    ld  (_puntero), hl

    ;;-------------------------------------------------------
    ;;TILEMAP
        ld  e, (hl)
        inc hl
        ld  d, (hl)
        inc hl

        ld  (_current_tilemap), de

    ;;-------------------------------------------------------
    ;;PLAYER
        push hl
        call E_M_getPlayer
        ld__iy_hl
        pop hl
        
        ;;Set posicion del player
        ld  a, (hl)
        ld  e_x(iy), a
        inc hl
        ld  a, (hl)
        ld  e_y(iy), a
        inc hl

        ;;Crear player
        push hl
        ld__hl_iy
        call man_game_entity_creator
        pop hl
    
    ;;-------------------------------------------------------
    ;;ENEMIGOS
        push hl
        call E_M_getEnemy
        ld__iy_hl
        pop hl

        enemy_loop:

            ;;Set posicion del enemigo
            ld  a, (hl)
            ld  e_x(iy), a
            inc hl
            ld  a, (hl)
            ld  e_y(iy), a
            inc hl

            ;;Crear enemigo
            push hl
            ld__hl_iy
            call man_game_entity_creator
            pop hl

            ld  a, (hl)
            xor #0xFF
            jr nz, enemy_loop

            inc hl
            
    ;;-------------------------------------------------------
    ;;SALIDA
        push hl
        call E_M_getSalida
        ld__iy_hl
        pop hl

        ;;Set posicion de la salida
        ld  a, (hl)
        ld  e_x(iy), a
        inc hl
        ld  a, (hl)
        ld  e_y(iy), a
        inc hl

        ;;Crear salida
        push hl
        ld__hl_iy
        call man_game_entity_creator
        pop hl

    ;;-------------------------------------------------------
    ;;CAJAS
        push hl
        call E_M_getCaja
        ld__iy_hl
        pop hl

        caja_loop:

            ;;Set posicion de la caja
            ld  a, (hl)
            ld  e_x(iy), a
            inc hl
            ld  a, (hl)
            ld  e_y(iy), a
            inc hl

            ;;Crear caja
            push hl
            ld__hl_iy
            call man_game_entity_creator
            pop hl

            ld  a, (hl)
            xor #0xFF
            jr nz, caja_loop

            inc hl

    ;;-------------------------------------------------------
    ;;LEVEL SIZE
        ld  a, (hl)
        ld  (_current_level_size), a


ret

L_M_changeLevel::


ret


L_M_resetCurrentLevel::

cpctm_clearScreen_asm #0
call E_M_destroyAllEntities
call L_M_loadLevel

call _render_sys_drawTileMap

ret


L_M_levelPassed::

;;Mostrar pantalla de video superado

cpctm_clearScreen_asm #0
ld  hl, (_current_level)
ld  bc, (_current_level_size)
add hl, bc
ld  (_current_level), hl
call E_M_destroyAllEntities
call L_M_loadLevel


call _render_sys_drawTileMap

ret