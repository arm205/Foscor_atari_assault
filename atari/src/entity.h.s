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


.macro DefineEnemyEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
_name::
    t_enemy:: .db 0x02 ;    type of entity is enemy
    cmp_enemy:: .db 0x0B   ;components that enemy has
    CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
    enemy_col:: .db 0x00
.endm

.macro DefineEnemy2Entity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
_name::
    .db 0x02 ;    type of entity is enemy
    .db 0x0B    ;components that enemy has
    CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
    .db 0x00
.endm


.macro DefinePlayerEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
_name::
    t_player:: .db  0x01;    type of entity is player
    cmp_player:: .db 0x0D   ;components that player has
    CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
    player_col:: .db 0x06
.endm


.macro DefineCajaEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
_name::
    t_caja:: .db 0x04 ;    type of entity is breakable box
    cmp_caja:: .db 0x09   ;components that box has
    CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
    caja_col:: .db 0x01
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
cmp_render: .db 0x01
;; 00000010 para las entidades que usen IA
cmp_ia: .db 0x02
;; 00000100 para las entidades con input (player)
cmp_input: .db 0x04
;;  entidades con colisiones
cmp_collider: .db 0x08


;; Tipos de las entidades
t_default: .db 0x00

t_dead: .db 0x80






