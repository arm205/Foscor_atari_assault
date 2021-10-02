;
; Entity_manager
;
.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"

max_entities == 20

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



;
;Input: A type that we are looking for, D num entity
E_M_for_all_matching::
    ld c, a
    ld a, d
    ld d, c

    ;intercambio A y D

_renloop:
    ld (_ent_counter), a

    ld a, e_t(ix)
    ld c, a
    ld a, e
    ld e, c
    ld a, (t_invalid)
    and e
    jr nz, invalid_entity

    ;; erase previous istance
; para mover todo lo que tenga a 1 el bit de ia
    ld a, e_t(ix)
    xor d
    jr z, cumple
    jr continua
    cumple:    
        ld a, (t_enemy)
        xor d
        jr z, con_ia
        jr no_ia
        con_ia:
            call ia_update_one_entity
            call physics_sys_for_one
            jr continua

        no_ia:
            ld a, (t_player)
            xor d
            jr z, control
            jr continua
                control:
                push de
;; Con esto modifico la velocidad del player dependiendo de la tecla pulsada
                call input_update_one
;; Lo de antes solo cambia la velocidad, esto es para añadirsela a la posicion
                call physics_sys_for_one
                pop de
                jr continua
            
    continua:

_ent_counter = .+1
    ld  a, #0
    dec a
    ret z



    ld (_ent_counter), a

    invalid_entity:
    ld bc, #sizeof_e
    add ix, bc
    jr _renloop
