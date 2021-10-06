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
                             11 .globl E_M_for_all_pairs_matching
                             12 
                             13 
                             14 ; ENTITY DEFINITION MACRO
                             15 .macro CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             16     .db _x ;    position x of entity
                             17     .db _y ;    position y of entity
                             18     .db _w ;    width of entity
                             19     .db _h ;    height y of entity
                             20     .db _vx ;    speed x of entity
                             21     .db _vy ;    speed x of entity
                             22     .db _c ;    color of entity
                             23     .db _b;     byte that we use for setting a special behavior to an entity (asi podemos tener dos cosas del mismo tipo que se comporten distinto)
                             24     .dw 0xCCCC; last video memory value to delate later
                             25 .endm
                             26 
                             27 
                             28 .macro DefineDefaultEntity _x, _y, _w, _h, _vx, _vy, _c, _b
                             29     .db 0x00 ;    type of entity default
                             30     .db 0x00 ;      components of entity default
                             31     CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             32     .db 0x00
                             33 .endm
                             34 
                             35 
                             36 .macro DefineEnemyEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
                             37 _name::
                             38     t_enemy:: .db 0x02 ;    type of entity is enemy
                             39     cmp_enemy:: .db 0x0B   ;components that enemy has
                             40     CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             41     enemy_col:: .db 0x00
                             42 .endm
                             43 
                             44 .macro DefineEnemy2Entity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
                             45 _name::
                             46     .db 0x02 ;    type of entity is enemy
                             47     .db 0x0B    ;components that enemy has
                             48     CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             49     .db 0x00
                             50 .endm
                             51 
                             52 
                             53 .macro DefinePlayerEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
                             54 _name::
                             55     t_player:: .db  0x01;    type of entity is player
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             56     cmp_player:: .db 0x0D   ;components that player has
                             57     CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             58     player_col:: .db 0x06
                             59 .endm
                             60 
                             61 
                             62 .macro DefineCajaEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
                             63 _name::
                             64     t_caja:: .db 0x04 ;    type of entity is breakable box
                             65     cmp_caja:: .db 0x09   ;components that box has
                             66     CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             67     caja_col:: .db 0x01
                             68 .endm
                             69 
                             70 
                     0000    71 e_t = 0
                     0001    72 e_cmp = 1
                     0002    73 e_x = 2
                     0003    74 e_y = 3
                     0004    75 e_w = 4
                     0005    76 e_h = 5
                     0006    77 e_vx = 6
                     0007    78 e_vy = 7
                     0008    79 e_c = 8
                     0009    80 e_be = 9
                     000A    81 e_lastVP_l = 10
                     000B    82 e_lastVP_h = 11
                     000C    83 e_col = 12
                     000D    84 sizeof_e = 13
                             85 
                             86 .macro DefineEntityArray _name, _N
                             87 _name::
                             88     .rept _N
                             89         DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
                             90     .endm
                             91 .endm
                             92 
                             93 
                             94 ;; Componentes de las entidades
                             95 
                             96 ;;; Usando los bits  para definir signatures luego
                             97 ;; 00000001 para lo que sea para renderizar
   4158 01                   98 cmp_render: .db 0x01
                             99 ;; 00000010 para las entidades que usen IA
   4159 02                  100 cmp_ia: .db 0x02
                            101 ;; 00000100 para las entidades con input (player)
   415A 04                  102 cmp_input: .db 0x04
                            103 ;;  entidades con colisiones
   415B 08                  104 cmp_collider: .db 0x08
                            105 
                            106 
                            107 ;; Tipos de las entidades
   415C 00                  108 t_default: .db 0x00
                            109 
   415D 80                  110 t_dead: .db 0x80
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                            111 
                            112 
                            113 
                            114 
                            115 
                            116 
