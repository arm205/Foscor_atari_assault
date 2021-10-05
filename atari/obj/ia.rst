ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 .include "entity.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                             55     t_player:: .db  0x01;    type of entity is player
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
                             71 ;.macro DefineBalaEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b, _dest_c
                             72 ;_name::
                             73 ;    t_bala:: .db 0x08 ;    type of entity is bullet
                             74 ;    cmp_bala:: .db 0x0D   ;components that bullet has
                             75 ;    CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b, _dest_c
                             76 ;    bala_col:: .db 0x00
                             77 ;.endm
                             78 ;
                             79 
                     0000    80 e_t = 0
                     0001    81 e_cmp = 1
                     0002    82 e_x = 2
                     0003    83 e_y = 3
                     0004    84 e_w = 4
                     0005    85 e_h = 5
                     0006    86 e_vx = 6
                     0007    87 e_vy = 7
                     0008    88 e_c = 8
                     0009    89 e_be = 9
                     000A    90 e_lastVP_l = 10
                     000B    91 e_lastVP_h = 11
                     000C    92 e_col = 12
                     000D    93 sizeof_e = 13
                             94 
                             95 .macro DefineEntityArray _name, _N
                             96 _name::
                             97     .rept _N
                             98         DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
                             99     .endm
                            100 .endm
                            101 
                            102 
                            103 ;; Componentes de las entidades
                            104 
                            105 ;;; Usando los bits  para definir signatures luego
                            106 ;; 00000001 para lo que sea para renderizar
   4359 01                  107 cmp_render: .db 0x01
                            108 ;; 00000010 para las entidades que usen IA
   435A 02                  109 cmp_ia: .db 0x02
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                            110 ;; 00000100 para las entidades con input (player)
   435B 04                  111 cmp_input: .db 0x04
                            112 ;;  entidades con colisiones
   435C 08                  113 cmp_collider: .db 0x08
                            114 
                            115 
                            116 ;; Tipos de las entidades
   435D 00                  117 t_default: .db 0x00
                            118 
   435E 80                  119 t_dead: .db 0x80
                            120 
                            121 
                            122 
                            123 
                            124 
                            125 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
Hexadecimal [16-Bits]



                              2 
                              3 
                     0050     4 screen_width = 80
                     00C8     5 screen_height = 200
                              6 
                              7 
                              8 ; MODIFIES: A, C
   435F                       9 ia_update_one_entity::
   435F DD 7E 00      [19]   10 ld a, e_t(ix)
   4362 4F            [ 4]   11 ld c, a
   4363 3A AF 42      [13]   12 ld a, (t_enemy)
   4366 A9            [ 4]   13 xor c
   4367 28 00         [12]   14 jr z, is_enemy
                             15 ;not_enemy:
                             16 ;    ld a, (t_bala)
                             17 ;    xor c
                             18 ;    jr z, is_bala
                             19 ;
                             20 ;is_bala:
                             21 ;    call ia_auto_destroy
                             22 ;    jr acabado
                             23 ;
                             24 
   4369                      25 is_enemy:
   4369 CD 6D 43      [17]   26     call ia_for_enemy
   436C                      27 acabado:
                             28 
   436C C9            [10]   29 ret
                             30 
                             31 
                             32 
                             33 ;; Comportamiento de las entidades de tipo enemigo
   436D                      34 ia_for_enemy:
   436D 3E 50         [ 7]   35     ld a, #screen_width
   436F DD 96 04      [19]   36     sub e_w(ix)
   4372 4F            [ 4]   37     ld  c, a
                             38 
   4373 DD 7E 02      [19]   39     ld a, e_x(ix)
   4376 DD 86 06      [19]   40     add e_vx(ix)
   4379 B9            [ 4]   41     cp  c
   437A 30 02         [12]   42     jr nc, cambia_vx
   437C 18 08         [12]   43     jr no_cambia
                             44 
   437E                      45     cambia_vx:
   437E DD 7E 06      [19]   46         ld  a, e_vx(ix)
   4381 ED 44         [ 8]   47         neg
   4383 DD 77 06      [19]   48         ld  e_vx(ix), a
   4386                      49     no_cambia:
   4386 C9            [10]   50 ret
                             51 
                             52 
                             53 
                             54 
                             55 
                             56 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



                             57 
   4387                      58 ia_update::
   4387 57            [ 4]   59     ld d, a
   4388 3A 5A 43      [13]   60     ld a, (cmp_ia)
   438B CD E8 41      [17]   61     call E_M_for_all_matching
                             62 
   438E C9            [10]   63 ret
