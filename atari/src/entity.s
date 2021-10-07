;
; Entity_manager
;
.include "cpctelera.h.s"
.include "cpct_func.h.s"
.include "entity.h.s"
.include "physics.h.s"
.include "input.h.s"
.include "ia.h.s"
.include "render.h.s"
.include "collider.h.s"

max_entities == 6

_num_entities:: .db 0
_last_elem_ptr:: .dw _entity_array
DefineEntityArray _entity_array, max_entities

; Input
; Desc: Pone a 0 el numero de entidades e inicializa el array de entidades
; Modifies: A, HL
E_M_init::
    xor a
    ld (_num_entities), a

    ld hl, #_entity_array
    ld (_last_elem_ptr), hl
ret


; Input
; Desc: Aumenta en 1 el num_entity, almacena en DE la direccion de Last_pointer y last_pointer lo mueve una entidad de distancia
; Modifies: HL, DE, BC
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

; Input: HL; pointer to entity initializer bytes, DE; Puntero a la direccion en la que se almacenara nueva entidad
; Desc: Almacenamos la direccion de nueva entidad en IX y cargamos la uneva entidad con los valores almacenados en HL
; Modifies: IX, HL, BC, DE
E_M_create::
    push hl
    
    call E_M_new

    ld__ixh_d
    ld__ixl_e


    pop hl
    ldir

ret




; Desc: Cargamos el numero de entidades que tengo en A y funtero al inicio del array en IX
; Modifies: IX, A
E_M_getEntityArray::
    ld ix, #_entity_array
    ld a, (_num_entities)
ret


;Input: A, index of entity starting with 0, 
;
;
E_M_get_from_idx::
    ld iy, #_entity_array
buscando_idx:
    dec a
    ret z

    ld bc, #sizeof_e
    add iy, bc
    jr buscando_idx






;
;Input: A; type that we are looking for, D; num entity
;Desc: Buscamos todas las entidades validas cuyo tipo tenga el componente del signature(D en la amyoria del codigo) y se devuelve al sistema que lo ha llamado
;Modifies: IX, BC, DE, A
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
    ld a, (t_default)
    and e
    jr nz, invalid_entity

    ;; erase previous istance
; para mover todo lo que tenga a 1 el bit de ia
    ld a, e_cmp(ix)
    and d
    jr nz, cumple
    jr continua
    cumple:    
        ld a, (cmp_ia)
        xor d
        jr z, con_ia
        jr no_ia
        con_ia:
            call ia_update_one_entity
            jr continua

        no_ia:
            ld a, (cmp_input)
            xor d
            jr z, control
            jr mover_cosas
                control:
                push de
;; Con esto modifico la velocidad del player dependiendo de la tecla pulsada
                call input_update_one
                pop de
                jr continua
        mover_cosas:
            ld a, (cmp_render)
            xor d
            jr z, render
            jr continua
                render:
                push de
;; Llamo a que modifiquen la posicion todos los elementos que tengan el bit de render
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


;;INPUT
;;  A: Bit de signo (Si algo es colisionable)
;;  D: Numero de entidades

E_M_for_all_pairs_matching::
    ;Intercambio A y D;
    ld c, a
    ld a, d
    ld d, c

    _renloop_pairs:
        ;;SE CARGA A CANTIDAD DE ENTIDADES
        ld (_ent_counter2), a

        ;;VERIFICAR SI LA ENTIDAD EN IX ES DEFAULT
        ld e, e_t(ix)
        ld a, (t_default)
        and e                           

        ;;CASO: ENTIDAD IX ES INVALIDA
        jr nz, invalid_entity_pairs

        ;;CASO: ENTIDAD IX ES VALIDA
        ;;VERIFICAR SI IX TIENE EL COMPONENTE PASADO
        ld a, e_cmp(ix)
        and d
        ld__iy_ix                                                              ;;Cargar en IY lo que hay en IX

        ;;CASO: ENTIDAD IX TIENE EL COMPONENTE
        jr nz, cumple_pairs

        ;;CASO: LA ENTIDAD IX NO TIENE EL COMPONENTE, BUSCA EN LA SIGUIENTE         
        jr continua_pairs


        cumple_pairs:
           ; Significa que este elemento cumple que es colisionable
           ; A partir de aqui se busca el siguiente elemento colisionable para luego ver el tipo de colision entre la parejas
            ld bc, #sizeof_e
            add ix, bc
            ld a, (_ent_counter2)
            dec a
            second_loop_pairs:
                ld (_ent_counter_2), a  ;;Resto de entidades a comprobar

                ;;VERIFICAR SI EL TIPO DE LA ENTIDAD IX ES DEFAULT
                ld e, e_t(ix)
                ld a, (t_default)
                and e

                ;;CASO: LA ENTIDAD EN IX ES INVALIDA
                jr nz, invalid_entity_2_pairs

                ;;CASO: LA ENTIDAD EN IX ES VALIDA
                ;;VERIFICAR SI IX TIENE EL COMPONENTE PASADO
                ld a, e_cmp(ix)
                and d

                ;;CASO: LA SEGUNDA ENTIDAD TAMBIEN TIENE EL COMPONENTE
                jr nz, cumple2_pairs

                ;;CASO: LA SEGUNDA ENTIDAD NO TIENE EL COMPONENTE, BUSCA EN LA SIGUIENTE
                jr continua2_pairs

                cumple2_pairs:  
                    call collider_one_pair

                continua2_pairs:
                    _ent_counter_2 = .+1
                    ld  a, #0
                    dec a
                    jr z, continua_pairs
                    ld (_ent_counter_2), a

                invalid_entity_2_pairs:
                    ld bc, #sizeof_e
                    add ix, bc
                    jr second_loop_pairs
                   
        continua_pairs:
            ld__ix_iy
            _ent_counter2 = .+1
            ld  a, #0
            dec a
        ret z

        ld (_ent_counter2), a
        
        invalid_entity_pairs:
            ld bc, #sizeof_e
            add ix, bc
            jr _renloop_pairs

