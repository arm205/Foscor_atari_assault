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
                             10 .globl E_M_for_all_matching
                             11 
                             12 
                             13 
                             14 ; ENTITY DEFINITION MACRO
                             15 .macro CommonDefine _x, _y, _w, _h, _vx, _c
                             16     .db _x ;    position x of entity
                             17     .db _y ;    position y of entity
                             18     .db _w ;    width of entity
                             19     .db _h ;    height y of entity
                             20     .db _vx ;    speed x of entity
                             21     .db _c ;    color of entity
                             22     .dw 0xCCCC; last video memory value to delate later
                             23 .endm
                             24 
                             25 
                             26 .macro DefineDefaultEntity _x, _y, _w, _h, _vx, _c
                             27     .db 0x00 ;    type of entity default
                             28     CommonDefine _x, _y, _w, _h, _vx, _c
                             29 .endm
                             30 
                             31 .macro DefineEnemyEntity _name, _x, _y, _w, _h, _vx, _c
                             32 _name::
                             33     .db 0x03 ;    type of entity is enemy
                             34     CommonDefine _x, _y, _w, _h, _vx, _c
                             35 .endm
                             36 
                             37 .macro DefinePlayerEntity _name, _x, _y, _w, _h, _vx, _c
                             38 _name::
                             39     .db 0x05 ;    type of entity is player
                             40     CommonDefine _x, _y, _w, _h, _vx, _c
                             41 .endm
                             42 
                             43 
                     0000    44 e_t = 0
                     0001    45 e_x = 1
                     0002    46 e_y = 2
                     0003    47 e_w = 3
                     0004    48 e_h = 4
                     0005    49 e_vx = 5
                     0006    50 e_c = 6
                     0007    51 e_lastVP_l = 7
                     0008    52 e_lastVP_h = 8
                     0009    53 sizeof_e = 9
                             54 
                             55 .macro DefineEntityArray _name, _N
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56 _name::
                             57     .rept _N
                             58         DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
                             59     .endm
                             60 .endm
                             61 
                             62 
                             63 
                             64 
                             65 ;;; Usando los bits  para definir signatures luego
                             66 ;; 00000001 para lo que sea para renderizar
   4000 01                   67 t_render: .db 0x01
                             68 ;; 00000010 para las entidades que usen IA
   4001 02                   69 t_ia: .db 0x02
                             70 ;; 00000100 para las entidades con input (player)
   4002 04                   71 t_input: .db 0x04
