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

screen_start = 0xC000

;; RENDER AN ENTITY
;;      INPUT: IX

_setScreenPTR:
    ld de, #screen_start
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x
    call cpct_getScreenPtr_asm ;;entidad que comenzara a dibujarse en la pos (x,y)
    ret
_render_Entity:: ;;importante: actualizar con la posibilidad de abrir sprites.

    call _setScreenPTR
    ld e, e_lastVP_l(ix)
    ld d, e_lastVP_h(ix)
    xor a
    ld c, e_w(ix)
    ld b, e_h(ix)
    push bc
    call cpct_drawSolidBox_asm
    
    call _setScreenPTR
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

    ;;SET THE TILEMAP
    ld c, #0x10
    ld b, #0x10
    ld de, #25
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
    ld (_ent_counter), a ;;Save entity COUNTER
    _update_loop:
        call _render_Entity
        _ent_counter = .+1
        ld a, #0
        dec a
        ret z

        ld (_ent_counter), a
        ld bc, #sizeof_e
        add ix, bc
    jr _update_loop

_render_sys_terminate::
ret
