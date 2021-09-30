ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;
                              2 ;   ENTITY MANAGER
                              3 ;
                              4 
                              5 ;   GLOBAL FUNCTIONS
                              6 .globl E_M_create
                              7 .globl E_M_getEntityArray
                              8 .globl E_M_init
                              9 .globl E_M_new
                             10 
                             11 
                             12 
                             13 ; ENTITY DEFINITION MACRO
                             14 .macro CommonDefine _x, _y, _w, _h, _vx, _c
                             15     .db _x ;    position x of entity
                             16     .db _y ;    position y of entity
                             17     .db _w ;    width of entity
                             18     .db _h ;    height y of entity
                             19     .db _vx ;    speed x of entity
                             20     .db _c ;    color of entity
                             21     .dw 0xCCCC; last video memory value to delate later
                             22 .endm
                             23 
                             24 .macro DefineDefaultEntity _x, _y, _w, _h, _vx, _c
                             25     .db 0xFF ;    type of entity default
                             26     CommonDefine _x, _y, _w, _h, _vx, _c
                             27 .endm
                             28 
                             29 .macro DefineEnemyEntity _name, _x, _y, _w, _h, _vx, _c
                             30 _name::
                             31     .db 0x01 ;    type of entity is enemy
                             32     CommonDefine _x, _y, _w, _h, _vx, _c
                             33 .endm
                             34 
                             35 .macro DefinePlayerEntity _name, _x, _y, _w, _h, _vx, _c
                             36 _name::
                             37     .db 0x02 ;    type of entity is enemy
                             38     CommonDefine _x, _y, _w, _h, _vx, _c
                             39 .endm
                             40 
                             41 
                     0000    42 e_t = 0
                     0001    43 e_x = 1
                     0002    44 e_y = 2
                     0003    45 e_w = 3
                     0004    46 e_h = 4
                     0005    47 e_vx = 5
                     0006    48 e_c = 6
                     0007    49 e_lastVP_l = 7
                     0008    50 e_lastVP_h = 8
                     0009    51 sizeof_e = 9
                             52 
                             53 .macro DefineEntityArray _name, _N
                             54 _name::
                             55     .rept _N
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56         DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
                             57     .endm
                             58 .endm
