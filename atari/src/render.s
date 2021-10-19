;;
;; RENDER.S -- Dibuja por pantalla.
;;
.include "render.h.s"
.include "entity.h.s"
.include "assets/tiles/tilemap_02.h.s"

;; instrucciones utiles
.globl cpct_disableFirmware_asm
.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm
.globl cpct_setVideoMode_asm
.globl cpct_etm_drawTilemap4x8_ag_asm
.globl cpct_etm_setDrawTilemap4x8_ag_asm


;; RENDER AN ENTITY
;;      INPUT: IX

setCTCR:
    ld bc, #0xBC00
    out (c), d
    inc b
    out (c), e
ret
_render_Entity:: ;;importante: actualizar con la posibilidad de abrir sprites.
    ld e, e_lastVP_l2(ix)
    ld d, e_lastVP_h2(ix)
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

    ld a, e_c(ix)
    ex de, hl
    pop bc
    ld l, e_spr(ix)
    ld h, e_spr+1(ix)
    call cpct_drawSprite_asm ;;dibuja un cuadrado con esas dimensiones.

    ret

;; RENDER INIT (llamado desde GAME)
_render_sys_init::
    ld c, #0
    call cpct_setVideoMode_asm
    ld hl, #_pal_main
    ld de, #16
    call cpct_setPalette_asm

    ;;CAMBIO DE RESOLUCION
    ;;  R1 = 32 (Ancho que mostramos)
    ;;;;ld de, #0x0120
    ;;call setCTCR
    ;;;;  R2 = 42 (inicio del HSYNC)
    ;;ld de, #0x022A
    ;;call setCTCR
    ;;;;  R6 = 16 (Alto en caracteres)
    ;;ld de, #0x0610
    ;;call setCTCR
    ;;;;  R7 = 26 (inicio del VSYNC)
    ;;ld de, #0x071A
    ;;call setCTCR

    ;;SET THE TILEMAP
    ld c, #_tilemap_W
    ld b, #_tilemap_H
    ld de, #_tilemap_W
    ld hl, #_tiles_00
    call cpct_etm_setDrawTilemap4x8_ag_asm

    ;;DRAW THE TILEMAP
    ld hl, #0xC000
    ld de, #_tilemap
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
    ;;ld de, #0x0C32
    ;;DE: 
    ;;  REGISTRO Y VALOR
    ;;call setCTCR

    ld a, #0xC0
    ld (back_buffer), a
    ld hl, #change_screen_to_C000
    ld (f_change_screen), hl
ret

change_screen_to_C000:
    ;;ld de, #0x0C30
    ;;DE: 
    ;;  REGISTRO Y VALOR
    ;;call setCTCR

    ld a, #0x80
    ld (back_buffer), a
    ld hl, #change_screen_to_8000
    ld (f_change_screen), hl
ret