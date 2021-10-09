;
;   ENTITY MANAGER
;

;   GLOBAL FUNCTIONS
.globl E_M_create
.globl E_M_getEntityArray
.globl E_M_init
.globl E_M_new
.globl E_M_for_all_matching
.globl E_M_for_all_pairs_matching
.globl E_M_deleteEntity
.globl E_M_get_from_idx


; ENTITY DEFINITION MACRO
.macro CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
    .db _x ;    position x of entity
    .db _y ;    position y of entity
    .db _w ;    width of entity
    .db _h ;    height y of entity
    .db _vx ;    speed x of entity
    .db _vy ;    speed x of entity
    .db _c ;    color of entity
    .db _b;     byte that we use for setting a special behavior to an entity (asi podemos tener dos cosas del mismo tipo que se comporten distinto)
    .dw 0xCCCC; last video memory value to delate later
.endm


.macro DefineDefaultEntity _x, _y, _w, _h, _vx, _vy, _c, _b
    .db 0x00 ;    type of entity default
    .db 0x00 ;      components of entity default
    CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
    .db 0x00
.endm


e_t = 0
e_cmp = 1
e_x = 2
e_y = 3
e_w = 4
e_h = 5
e_vx = 6
e_vy = 7
e_c = 8
e_be = 9
e_lastVP_l = 10
e_lastVP_h = 11
e_col = 12
sizeof_e = 13

.macro DefineEntityArray _name, _N
_name::
    .rept _N
        DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
    .endm
.endm


;; Componentes de las entidades

;;; Usando los bits  para definir signatures luego
;; 00000001 para lo que sea para renderizar
cmp_render = 0x01
;; 00000010 para las entidades que usen IA
cmp_ia = 0x02
;; 00000100 para las entidades con input (player)
cmp_input = 0x04
;;  entidades con colisiones
cmp_collider = 0x08


;; Tipos de las entidades
t_default = 0x00

t_player = 0x01

t_enemy = 0x02

t_caja = 0x04

t_salida = 0x08

t_dead = 0x80






