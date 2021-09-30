;
;   ENTITY MANAGER
;

;   GLOBAL FUNCTIONS
.globl E_M_create
.globl E_M_getEntityArray
.globl E_M_init
.globl E_M_new
.globl E_M_for_all_matching



; ENTITY DEFINITION MACRO
.macro CommonDefine _x, _y, _w, _h, _vx, _c
    .db _x ;    position x of entity
    .db _y ;    position y of entity
    .db _w ;    width of entity
    .db _h ;    height y of entity
    .db _vx ;    speed x of entity
    .db _c ;    color of entity
    .dw 0xCCCC; last video memory value to delate later
.endm


.macro DefineDefaultEntity _x, _y, _w, _h, _vx, _c
    .db 0x00 ;    type of entity default
    CommonDefine _x, _y, _w, _h, _vx, _c
.endm

.macro DefineEnemyEntity _name, _x, _y, _w, _h, _vx, _c
_name::
    .db 0x03 ;    type of entity is enemy
    CommonDefine _x, _y, _w, _h, _vx, _c
.endm

.macro DefinePlayerEntity _name, _x, _y, _w, _h, _vx, _c
_name::
    .db 0x05 ;    type of entity is player
    CommonDefine _x, _y, _w, _h, _vx, _c
.endm


e_t = 0
e_x = 1
e_y = 2
e_w = 3
e_h = 4
e_vx = 5
e_c = 6
e_lastVP_l = 7
e_lastVP_h = 8
sizeof_e = 9

.macro DefineEntityArray _name, _N
_name::
    .rept _N
        DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
    .endm
.endm




;;; Usando los bits  para definir signatures luego
;; 00000001 para lo que sea para renderizar
t_render: .db 0x01
;; 00000010 para las entidades que usen IA
t_ia: .db 0x02
;; 00000100 para las entidades con input (player)
t_input: .db 0x04
