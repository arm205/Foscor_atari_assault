.include "cpctelera.h.s"
.include "assets/screens/screenmenu_z.h.s"

_current_level::            .dw #_level_1
_current_tilemap::          .dw #0x0

_next_level_ptr::           .dw 0

_level_reseted::            .db 0

_puntero::                  .dw 0

_num_level::                .db 0

;;MODIFICAR CADA VEZ QUE SE AGREGA UN NIVEL
_num_total_levels::         .db 5


L_M_init::

    ;;Cargar primer nivel
    call    L_M_loadLevel

    ld  a, (_num_total_levels)
    ld (_num_level), a

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
        call E_M_create
        pop hl
    
    ;;-------------------------------------------------------
    ;;ENEMIGOS
        push hl
        call E_M_getEnemy
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar1

        call L_M_loadMultiplesEntities
    
    continuar1:

        inc hl
        
    ;;-------------------------------------------------------
    ;;ENEMIGOS 2
        push hl
        call E_M_getEnemy2
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar2

        call L_M_loadMultiplesEntities
    
    continuar2:

        inc hl
        
    ;;-------------------------------------------------------
    ;;ENEMIGOS 3
        push hl
        call E_M_getEnemy3
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar3

        call L_M_loadMultiplesEntities

    continuar3:
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
    ;;CAJAS VERDES
        push hl
        call E_M_getCajaVerde
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar4

        call L_M_loadMultiplesEntities
    
    continuar4:

        inc hl

    ;;-------------------------------------------------------
    ;;CAJAS AMARILLAS
        push hl
        call E_M_getCajaAmarilla
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar5

        call L_M_loadMultiplesEntities
    
    continuar5:

        inc hl

    ;;-------------------------------------------------------
    ;;CAJAS ROJAS
        push hl
        call E_M_getCajaRoja
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar6

        call L_M_loadMultiplesEntities
    
    continuar6:

        inc hl

    ;;-------------------------------------------------------
    ;;CAJAS AZULES
        push hl
        call E_M_getCajaAzul
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar7

        call L_M_loadMultiplesEntities
    
    continuar7:

        inc hl

    ;;-------------------------------------------------------
    ;;ADD NADA ENTITIES TO BALANCE SPEED
        push hl
        call E_M_getNada
        ld__iy_hl
        pop hl

        ld  a, (hl)
        xor #0xFF
        jr z, continuar8
        call L_M_loadMultiplesEntities
    
    continuar8:

        inc hl


    ;;-------------------------------------------------------
    ;;LEVEL SIZE
        ld__de_hl
        ld  (_next_level_ptr), de

ret

L_M_loadMultiplesEntities::

        load_entities_loop:

            ;;Set posicion
            ld  a, (hl)
            ld  e_x(iy), a
            inc hl
            ld  a, (hl)
            ld  e_y(iy), a
            inc hl

            ;;Crear entidad
            push hl
            ld__hl_iy
            call man_game_entity_creator
            pop hl

            ld  a, (hl)
            xor #0xFF
            jr nz, load_entities_loop

ret


L_M_resetCurrentLevel::

ld  a, #0x01
ld  (_level_reseted), a

cpctm_clearScreen_asm #0
call E_M_destroyAllEntities
call L_M_loadLevel

call _render_sys_drawTileMap


ret


L_M_levelPassed::

ld  a, (_num_level)
dec a
ld  (_num_level), a
jr  nz, salta

call L_M_showWinScreen
ret

salta:

ld  a, #0x01
ld  (_level_reseted), a

cpctm_clearScreen_asm #0

ld  hl, (_next_level_ptr)
ld  (_current_level), hl

call E_M_destroyAllEntities
call L_M_loadLevel


call _render_sys_drawTileMap


ret

L_M_loadFirstLevel::

ld  a, (_num_total_levels)
ld (_num_level), a

ld hl, #_level_1
ld (_current_level), hl


call L_M_resetCurrentLevel


ret

L_M_showMenuScreen::

    cpctm_clearScreen_asm #0

    call change_screen_to_C000
    
    ;;DIBUJAR LA PANTALLA DE INICIO
    ld  hl, #_screenmenu_z_end
    ld  de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm

    ld hl, #Key_Space
    call wait_keyPressed

   call L_M_loadFirstLevel

ret

L_M_showWinScreen::

    cpctm_clearScreen_asm #0

    call change_screen_to_C000

    ;;DIBUJAR LA PANTALLA DE VICTORIA
    ld  hl, #_screenend_z_end
    ld  de, #0xFFFF
    call cpct_zx7b_decrunch_s_asm


    ld hl, #Key_Space
    call wait_keyPressed

   call L_M_showMenuScreen

ret