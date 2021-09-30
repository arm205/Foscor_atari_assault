;;
;; RENDER.S -- Dibuja por pantalla.
;;

;; instrucciones utiles
.globl cpct_disableFirmware_asm
.globl cpct_drawSolidBox_asm
.globl cpct_getScreenPtr_asm

;; RENDER AN ENTITY
;;      INPUT: IX

_render_Entity::

    ld de, #0xC000
    ld b, 2(ix) ;;pos_y
    ld c, 1(ix) ;;pos_x
    call cpct_getScreenPtr_asm ;;entidad que comenzara a dibujarse en la pos (x,y)

    ex de, hl

    ld a, 7(ix) ;;color
    ld c, 3(ix) ;;ancho
    ld b, 4(ix) ;;alto
    call cpct_drawSolidBox_asm ;;dibuja un cuadrado con esas dimensiones.

    ret

_render_sys_update ::
ret