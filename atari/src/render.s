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
;;.globl cpctm_setBorder_asm


;; RENDER AN ENTITY
;;      INPUT: IX
_render_Entity:: ;;importante: actualizar con la posibilidad de abrir sprites.

    ld de, #0xC000
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x

    call cpct_getScreenPtr_asm ;;entidad que comenzara a dibujarse en la pos (x,y)
    
    ld e, e_lastVP_l(ix)
    ld d, e_lastVP_h(ix)
    xor a
    ld c, e_w(ix)
    ld b, e_h(ix)
    push bc
    call cpct_drawSolidBox_asm
    
    ld de, #0xC000
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x
º
    call cpct_getScreenPtr_asm ;;entidad que comenzara a dibujarse en la pos (x,y)

    ld e_lastVP_l(ix), l
    ld e_lastVP_h(ix), h
    ld a, e_c(ix)
    ex de, hl
    pop bc
    call cpct_drawSolidBox_asm ;;dibuja un cuadrado con esas dimensiones.

    ret

;; RENDER INIT (llamado desde GAME)
_render_sys_init::
    ld c, #0
    call cpct_setVideoMode_asm
;;    ld hl, #_pal_main
;;    ld de, #16
;;    call cpctm_setBorder_asm
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
