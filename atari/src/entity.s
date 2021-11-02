;;Inside The Anthill - Videogame
;;
   ;; Copyright (C) 2021 Alba Ruiz, Javier Sibada and Miguel Teruel.
;;
   ;; This program is free software: you can redistribute it and/or modify
   ;; it under the terms of the GNU General Public License as published by
   ;; the Free Software Foundation, either version 3 of the License, or
   ;; (at your option) any later version.
;;
   ;; This program is distributed in the hope that it will be useful,
   ;; but WITHOUT ANY WARRANTY; without even the implied warranty of
   ;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   ;; GNU General Public License for more details.
;;
   ;; You should have received a copy of the GNU General Public License
   ;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

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

max_entities == 12

_num_entities:: .db 0
_last_elem_ptr:: .dw _entity_array
_last_start_entity_ptr:: .dw _entity_array
_entity_to_erase:: .dw #0x0
DefineEntityArray _entity_array, max_entities

; Input
; Desc: Pone a 0 el numero de entidades e inicializa el array de entidades
; Modifies: A, HL
E_M_init::
    xor a
    ld (_num_entities), a

    ld hl, #_entity_array
    ld (_last_elem_ptr), hl

    ld hl, #_entity_array
    ld (_last_start_entity_ptr), hl
ret


; Input
; Desc: Aumenta en 1 el num_entity, almacena en DE la direccion de Last_pointer y last_pointer lo mueve una entidad de distancia
; Modifies: HL, DE, BC
E_M_new::
;   Increment number of reserved entities
    ld hl, #_num_entities
    inc (hl)

;   Increment Array end pointer to point to the next
;   free element in thecpct_drawSolidBox_asm array
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

    ld (_last_start_entity_ptr), de

    ldir

ret

;;INPUT
;;  IX: Direccion de la entidad a eliminar
E_M_prepateToDelete::

    ld hl, #_spriteNegro
    ld e_spr(ix), l
    ld e_spr+1(ix), h
    
    ld de, #0x8000
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x
    call cpct_getScreenPtr_asm
    ex de, hl
    ld c, e_w(ix)
    ld b, e_h(ix)
    xor a
    call cpct_drawSolidBox_asm

    ld de, #0xC000
    ld b, e_y(ix) ;;pos_y
    ld c, e_x(ix) ;;pos_x
    call cpct_getScreenPtr_asm
    ex de, hl
    ld c, e_w(ix)
    ld b, e_h(ix)
    xor a
    call cpct_drawSolidBox_asm

    ld__hl_ix

    ld  (_entity_to_erase), hl

ret


E_M_deleteEntity::
    
    ;;MODIFICAR CANTIDAD DE ENTIDADES
    ld hl, #_num_entities
    dec (hl)

    ;;Mover la ultima entidad a la entidad a eliminar
    ld  bc, #sizeof_e
    ld  hl, (_last_start_entity_ptr)
    ld  de, (_entity_to_erase)
    ldir

    ;;Decrementar _last_start_entity_ptr si es necesario
    

    ld  bc, #sizeof_e
    ld  hl, (_last_start_entity_ptr)

    ld  a, h
    xor #_entity_array
    jr  z, continuar

    ld  a, l
    xor #_entity_array
    jr  z, continuar

    ld  a, l
    sub c
;calculos por si estoy restando a l un numero menor que c
    jr nc, no_se_pasa_c
        inc b

    no_se_pasa_c:
    ld  l, a
    ld  a, h
    sub b
    ld  h, a
    ld  (_last_start_entity_ptr), hl


    continuar:
    ;Decrementar _last_elem_ptr
    ld  bc, #sizeof_e
    ld  hl, (_last_elem_ptr)
    ld  a, l
    sub c
    ;calculos por si estoy restando a l un numero menor que c
    jr nc, no_se_pasa_c_2
        inc b

    no_se_pasa_c_2:
    ld  l, a
    ld  a, h
    sub b
    ld  h, a
    ld  (_last_elem_ptr), hl

    ;;Vaciar la ultima entidad
    ld  bc, #sizeof_e
    ld  de, (_last_elem_ptr)
    ld  a, #0x0
    call cpct_memset_asm
    
ret

E_M_checkDelete::

    ld  hl, (_entity_to_erase)

    ld  a, h
    or  #0x0
    jr  nz, eliminar

    ld  a, l
    or  #0x0
    jr  nz, eliminar

    ;;ES CERO
    ret

    ;;NO ES CERO
    eliminar:
    call E_M_deleteEntity
    ld  hl, #0x0
    ld  (_entity_to_erase), hl

ret

; Desc: Cargamos el numero de entidades que tengo en A y funtero al inicio del array en IX
; Modifies: IX, A
E_M_getEntityArray::
    ld ix, #_entity_array
    ld a, (_num_entities)
    ld d, a
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
    or #t_default
    jr z, invalid_entity

    ;; erase previous istance
; para mover todo lo que tenga a 1 el bit de ia
    ld a, e_cmp(ix)
    and d
    jr z, continua
    cumple:    
    pinta_cosas:
        ld a, #cmp_render
        xor d
        jr nz, ia
            render:
            push de
    ;; Llamo a que modifiquen la posicion todos los elementos que tengan el bit de render
            call _render_Entity
            pop de
        jr continua

        ia:
        ld a, #cmp_ia
        xor d
        jr nz, input
        con_ia:
            call ia_update_one_entity
            jr continua

        input:
            ld a, #cmp_input
            xor d
            jr nz, colisiona
                control:
                push de
;; Con esto modifico la velocidad del player dependiendo de la tecla pulsada
                call input_update_one
                pop de
                jr continua

        colisiona:
            ld a, #cmp_collider
            xor d
            jr nz, mover_cosas
                colision:
                push de
                
;; Llamo a que modifiquen la posicion todos los elementos que tengan el bit de colisionable
                call collider_tilemap
                pop de
                jr continua

        mover_cosas:
            ld a, #cmp_input+#cmp_ia
            xor d
            jr nz, animar_cosas
                fisica:
                push de
;; Llamo a que modifiquen la posicion todos los elementos que se muevan (ia o input)
                call physics_sys_for_one
                pop de
                jr continua

        animar_cosas:
            ld a, #cmp_animation
            xor d
            jr nz, continua
                animacion:
                push de
;; Llamo a que modifiquen la posicion todos los elementos que se muevan (ia o input)
                call animation_update_one
                pop de
                jr continua
            
    continua:

_ent_counter = .+1
    ld  a, #0
    dec a
    ret z



    ld (_ent_counter), a

    invalid_entity:

    ld a, (_ent_counter)
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
        ld a, #t_default
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
                ld a, #t_default
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
                    push de
                    call collider_one_pair
                    pop de
                    ld  a, (_level_reseted)
                    xor #0x0
                    ret nz

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


;;MODIFICA
;;  HL: Direccion del player
E_M_getPlayer::
    ld  hl, #player
ret

;;MODIFICA
;;  HL: Direccion del enemigo
E_M_getEnemy::
    ld  hl, #enemy
ret

;;MODIFICA
;;  HL: Direccion del enemigo 2
E_M_getEnemy2::
    ld  hl, #enemy2
ret

;;MODIFICA
;;  HL: Direccion del enemigo 3
E_M_getEnemy3::
    ld  hl, #enemy3
ret

;;MODIFICA
;;  HL: Direccion de la salida
E_M_getSalida::
    ld  hl, #salida
ret

;;MODIFICA
;;  HL: Direccion de la salida
E_M_getMandibula::
    ld  hl, #mandibula
ret


;;MODIFICA
;;  HL: Direccion de la salida
E_M_getCajaVerde::
    ld  hl, #caja_verde
ret

;;MODIFICA
;;  HL: Direccion de la salida
E_M_getCajaAmarilla::
    ld  hl, #caja_amarilla
ret

;;MODIFICA
;;  HL: Direccion de la salida
E_M_getCajaRoja::
    ld  hl, #caja_roja
ret

;;MODIFICA
;;  HL: Direccion de la salida
E_M_getCajaAzul::
    ld  hl, #caja_azul
ret


;;MODIFICA
;;  HL: Direccion de la salida
E_M_getNada::
    ld  hl, #nada
ret

E_M_destroyAllEntities::

    destroy_loop:
    ld  hl, (_last_start_entity_ptr)
    ld  (_entity_to_erase), hl

    call E_M_deleteEntity

    ld  a, (_num_entities)
    xor #0x00
    jr nz, destroy_loop
    
    ld  hl, #0x0
    ld  (_entity_to_erase), hl
ret