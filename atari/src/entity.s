;
; Entity_manager
;
.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity_manager.h.s"
.include "physics.h.s"

max_entities == 40

_num_entities:: .db 0
_last_elem_ptr:: .dw _entity_array
DefineEntityArray _entity_array, max_entities

E_M_init::
    xor a
    ld (_num_entities), a

    ld hl, #_entity_array
    ld (_last_elem_ptr), hl
ret


E_M_new::
;   Increment number of reserved entities
    ld hl, #_num_entities
    inc (hl)

;   Increment Array end pointer to point to the next
;   free element in the array
    ld hl, (_last_elem_ptr)
    ld d, h
    ld e, l
    ld bc, #sizeof_e
    add hl, bc
    ld (_last_elem_ptr), hl

ret

; INPUT
;   HL; pointer to entity initializer bytes
E_M_create::
    push hl
    
    call E_M_new

    ld__ixh_d
    ld__ixl_e


    pop hl
    ldir

ret

E_M_getEntityArray::
    ld ix, #_entity_array
    ld a, (_num_entities)
ret


;; INPUT: IX Memory pointer to star that has to die

E_M_destroy_entity::
;; AQUI TENGO QUE HACER QUE LAS ULTIMAS ENTIDADES
;; VAYAN OCUPANDO LAS POSICIONES DE LAS ESTRELLAS YA MUERTAS
    ld a, #0x80 ;; death type of star
    ld e_t(ix), a

ret

E_M_for_all::
    ld b, a
comprueba:
    ld c, e_t(ix)
    dec c
    jr z, viva
    jr sigue

viva:
    call physics_sys_update_one_entity

sigue:
    dec b
    ret z

    ld de, #sizeof_e
    add ix, de
    jr comprueba