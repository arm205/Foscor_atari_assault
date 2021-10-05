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
                             44 
                             45 
                             46 .macro DefinePlayerEntity _name, _x, _y, _w, _h, _vx, _vy, _c, _b
                             47 _name::
                             48     t_player:: .db  0x01;    type of entity is player
                             49     cmp_player:: .db 0x0D   ;components that player has
                             50     CommonDefine _x, _y, _w, _h, _vx, _vy, _c, _b
                             51     player_col:: .db 0x06
                             52 .endm
                             53 
                             54 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                     0000    55 e_t = 0
                     0001    56 e_cmp = 1
                     0002    57 e_x = 2
                     0003    58 e_y = 3
                     0004    59 e_w = 4
                     0005    60 e_h = 5
                     0006    61 e_vx = 6
                     0007    62 e_vy = 7
                     0008    63 e_c = 8
                     0009    64 e_be = 9
                     000A    65 e_lastVP_l = 10
                     000B    66 e_lastVP_h = 11
                     000C    67 e_col = 12
                     000D    68 sizeof_e = 13
                             69 
                             70 .macro DefineEntityArray _name, _N
                             71 _name::
                             72     .rept _N
                             73         DefineDefaultEntity 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD, 0xDE, 0xAD
                             74     .endm
                             75 .endm
                             76 
                             77 
                             78 ;; Componentes de las entidades
                             79 
                             80 ;;; Usando los bits  para definir signatures luego
                             81 ;; 00000001 para lo que sea para renderizar
   432D 01                   82 cmp_render: .db 0x01
                             83 ;; 00000010 para las entidades que usen IA
   432E 02                   84 cmp_ia: .db 0x02
                             85 ;; 00000100 para las entidades con input (player)
   432F 04                   86 cmp_input: .db 0x04
                             87 ;;  entidades con colisiones
   4330 08                   88 cmp_collider: .db 0x08
                             89 
                             90 
                             91 ;; Tipos de las entidades
   4331 00                   92 t_default: .db 0x00
                             93 
   4332 80                   94 t_dead: .db 0x80
                             95 
                             96 
                             97 
                             98 
                             99 
                            100 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              2 
                              3 
                     0050     4 screen_width = 80
                     00C8     5 screen_height = 200
                              6 
                              7 
                              8 ; MODIFIES: A, C
   4333                       9 ia_update_one_entity::
   4333 DD 7E 00      [19]   10 ld a, e_t(ix)
   4336 4F            [ 4]   11 ld c, a
   4337 3A A9 42      [13]   12 ld a, (t_enemy)
   433A A9            [ 4]   13 xor c
   433B 28 00         [12]   14 jr z, is_enemy
                             15 
   433D                      16 is_enemy:
   433D CD 41 43      [17]   17     call ia_for_enemy
   4340                      18 acabado:
                             19 
   4340 C9            [10]   20 ret
                             21 
                             22 
                             23 
                             24 ;; Comportamiento de las entidades de tipo enemigo
   4341                      25 ia_for_enemy:
   4341 3E 50         [ 7]   26     ld a, #screen_width
   4343 DD 96 04      [19]   27     sub e_w(ix)
   4346 4F            [ 4]   28     ld  c, a
                             29 
   4347 DD 7E 02      [19]   30     ld a, e_x(ix)
   434A DD 86 06      [19]   31     add e_vx(ix)
   434D B9            [ 4]   32     cp  c
   434E 30 02         [12]   33     jr nc, cambia_vx
   4350 18 08         [12]   34     jr no_cambia
                             35 
   4352                      36     cambia_vx:
   4352 DD 7E 06      [19]   37         ld  a, e_vx(ix)
   4355 ED 44         [ 8]   38         neg
   4357 DD 77 06      [19]   39         ld  e_vx(ix), a
   435A                      40     no_cambia:
   435A C9            [10]   41 ret
                             42 
                             43 
                             44 
                             45 
                             46 
                             47 
                             48 
   435B                      49 ia_update::
   435B 57            [ 4]   50     ld d, a
   435C 3A 2E 43      [13]   51     ld a, (cmp_ia)
   435F CD E8 41      [17]   52     call E_M_for_all_matching
                             53 
   4362 C9            [10]   54 ret
