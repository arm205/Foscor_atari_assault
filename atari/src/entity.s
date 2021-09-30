;
; Entity_manager
;
.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
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

