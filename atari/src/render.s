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
back_buffer = .+2 
    ld de, #0x8000
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x
    call getScreenPtr_32x16

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
    call getScreenPtr_32x16

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

getScreenPtr_32x16:
   ;; Before starting, some terminology to understand comments,
   ;;    Screen is composed of 25 Character Rows (R: Row)
   ;;    Each Character Row is composed of 8 pixel lines (L: Line)
   ;;    CPU Registers are named with a small r in-front (rA, rB, rH, rL, rHL...)
   ;;
   ;; 1st of all, split Y-coordinate (rB) into:
   ;;    rH = B % 8         ;; <<- Line [0-7] inside the character Row
   ;;    rL = int(B / 8)    ;; <<- Screen character Row [0-24]
   ;;
   ;; We can see Y-coordinate as including this two numbers (R: Row, L: Line) 
   ;; split into its first 5-bits and its last 3-bits:
   ;;    Y-coordinate == [R|R|R|R|R|L|L|L]
   ;;                bit7-/             \-bit0
   ;;

   ;; Extract line number (L) from Y-coordinate
   ;; And multiply it by 256. rHL = 256 * L
   ld    a, b     ;; [1] rA = Y-Coordinate
   and   #0x07    ;; [2] /
   ld    h, a     ;; [1] \ rH = Y % 8      ;; << rH contains Line number [0-7] inside character Row
                  ;;     Putting Line Number into rH is similar to putting it 
                  ;;     into rHL and then shifting it 8-bits left. Same as 256*rHL.
                  ;;     Therefore, this is like doing HL += 256*L

   ;; Now extract Screen Character Row (R) from Y-Coordinate
   ld    a, b     ;; [1] rA = Y-Coordinate
   and   #0xF8    ;; [2] /
   ld    l, a     ;; [1] \ rL = 8*int(Y/8) ;; << L contains Screen Character Row multiplied by 8
                                           ;;    as bits are shifted 3-bits to the left because
                                           ;;    the 3-least-significant-bits had the line number (L)

   ;; Now rHL = 256*L + 8*R  { rH = Y%8 = L ||| rL = 8*int(Y/8) = 8*R }
   ;; We need to calculate 2048*L + 80*R
   ;; This can be factored into 8*(256*L + 10*R)
   ;; So first, make rL contain 10*R and then we will have rHL = 256*L + 10*R
   ;; And then we will only need to multiply rHL by 8

   ;; rA' = rA / 4 = 2 * int(Y/8)
   rrca           ;; [1] / rA' = rA / 4 = 2*int(Y/8)
   rrca           ;; [1] \ 
   ;; rL' = rL + rA' = 10 * int(Y/8)
   add   a, l     ;; [1] / rL = rL + rA' = 8*int(Y/8) + 2*int(Y/8) = 10*int(Y/8)
   ld    l, a     ;; [1] \ 

   ;; Now rHL = 256*L + 10*R
   ;; Just multiply rHL' = 8*rHL = 8*(256*L + 10*R) = 2048*L + 80*R
   add   hl, hl   ;; [3] / rHL' = 8*rHL
   add   hl, hl   ;; [3] | rHL' = 2048*L + 80*R
   add   hl, hl   ;; [3] \ 

   ;; To complete the calculations, we only need to add the X-Coordinate
   ;; and the pointer to the start of the video buffer
   
   ;; Add up X coordinate
   ld     b, #0   ;; [2] / As rC = X-Coordinate, having rB=0 makes rBC = X-Coordinate
   add   hl, bc   ;; [3] \ rHL' = rHL + X

   ;; Add up screen start address we still keep in DE
   add   hl, de   ;; [3] rHL' = rHL + screen_start

   ;; HL now contains the pointer to the byte in the video buffer. Just return it
   ret            ;; [3] return rHL = Pointer to the video buffer at (X,Y) byte coordinates