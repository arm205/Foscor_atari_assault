;
;   ENTITY MANAGER
;

;   GLOBAL FUNCTIONS
.globl E_M_create
.globl E_M_getEntityArray
.globl E_M_destroy_entity
.globl E_M_for_all



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
    .db 0xFF ;    type of entity default
    CommonDefine _x, _y, _w, _h, _vx, _c
.endm

.macro DefineStarEntity _name, _x, _y, _w, _h, _vx, _c
_name::
    .db 0x01 ;    type of entity is star
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