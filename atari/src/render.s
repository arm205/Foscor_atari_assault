;;
;; RENDER.S -- Dibuja por pantalla.
;;
.include "render.h.s"
.include "entity.h.s"

;; instrucciones utiles
.globl cpct_disableFirmware_asm
.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_etm_drawTilemap4x8_ag_asm
.globl cpct_etm_setDrawTilemap4x8_ag_asm
.globl cpct_zx7b_decrunch_s_asm

decompress_buffer = 0x40
level_max_size = 0x1F4
decompress_buffer_end = decompress_buffer+level_max_size-1



;; RENDER AN ENTITY
;;      INPUT: IX

setCTCR:
    ld bc, #0xBC00
    out (c), d
    inc b
    out (c), e
ret
_render_Entity:: ;;importante: actualizar con la posibilidad de abrir sprites.
    
    ;;ld e_lastVP_l2(ix), #0x00
    ;;ld e_lastVP_h2(ix), #0xC0
    
    ld e, e_lastVP_l2(ix)
    ld d, e_lastVP_h2(ix)
    ;;ld de, #0xC000
    ;;ld b, e_y(ix) ;;pos_y
    ;;ld c, e_x(ix) ;;pos_x
    ;;call cpct_getScreenPtr_asm
    ;;ex de, hl
    xor a
    ld c, e_w(ix)
    ld b, e_h(ix)
    push bc
    call cpct_drawSolidBox_asm
    
back_buffer = .+2
    ld de, #0x8000
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x
    call cpct_getScreenPtr_asm

    ld a, e_lastVP_l(ix)
    ld e_lastVP_l2(ix), a
    ld a, e_lastVP_h(ix)
    ld e_lastVP_h2(ix), a

    ld e_lastVP_l(ix), l
    ld e_lastVP_h(ix), h

    ex de, hl
    pop bc
    ld l, e_spr(ix)
    ld h, e_spr+1(ix)
    call cpct_drawSprite_asm
    ret

;; RENDER INIT (llamado desde GAME)
_render_sys_init::
    ld c, #0
    call cpct_setVideoMode_asm
    ld hl, #_pal_main
    ld de, #16
    call cpct_setPalette_asm

    ;;SET THE TILEMAP
    ld c, #20
    ld b, #25
    ld de, #20
    ld hl, #_tiles_00
    call cpct_etm_setDrawTilemap4x8_ag_asm
ret

_render_sys_drawTileMap::
    ;;DRAW THE TILEMAP
    ;; en lugar de cargar directamente, aqui es donde se almacenara en la 0x40 nuestro nivel
    ld hl, (_current_tilemap)
    ld de, #decompress_buffer_end
    call cpct_zx7b_decrunch_s_asm
    ld hl, #0x8000
    ld de, #0x40
    call cpct_etm_drawTilemap4x8_ag_asm
    ld hl, #0xC000
    ld de, #0x40
    call cpct_etm_drawTilemap4x8_ag_asm
ret

;; RENDER ALL
_render_sys_update::
    call _render_ents_update


ret
;; RENDER ENTITIES
;;      INPUT: IX
;;      INPUT: A
_render_ents_update::
    ld d, a
    ld a, #cmp_render
    call E_M_for_all_matching
    call change_screen
ret
_render_sys_terminate::
ret

change_screen:
    f_change_screen = .+1
    jp change_screen_to_8000
    
change_screen_to_8000:
    ld de, #0x0C20
    call setCTCR
    ld a, #0xC0
    ld (back_buffer), a
    ld hl, #change_screen_to_C000
    ld (f_change_screen), hl
ret
change_screen_to_C000:
    
    ld de, #0x0C30
    call setCTCR
    ld a, #0x80
    ld (back_buffer), a
    ld hl, #change_screen_to_8000
    ld (f_change_screen), hl
ret
