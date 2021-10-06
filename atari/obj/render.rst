ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;
                              2 ;; RENDER.S -- Dibuja por pantalla.
                              3 ;;
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 2.
Hexadecimal [16-Bits]



                              4 .include "render.h.s"
                              1 .globl _render_Entity
                              2 .globl _render_sys_update 
                              3 .globl _render_sys_init
                              4 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 3.
Hexadecimal [16-Bits]



                              5 .include "entity.h.s"
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
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 4.
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
   443D 01                   98 cmp_render: .db 0x01
                             99 ;; 00000010 para las entidades que usen IA
   443E 02                  100 cmp_ia: .db 0x02
                            101 ;; 00000100 para las entidades con input (player)
   443F 04                  102 cmp_input: .db 0x04
                            103 ;;  entidades con colisiones
   4440 08                  104 cmp_collider: .db 0x08
                            105 
                            106 
                            107 ;; Tipos de las entidades
   4441 00                  108 t_default: .db 0x00
                            109 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 5.
Hexadecimal [16-Bits]



   4442 80                  110 t_dead: .db 0x80
                            111 
                            112 
                            113 
                            114 
                            115 
                            116 
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 6.
Hexadecimal [16-Bits]



                              6 ;; instrucciones utiles
                              7 .globl cpct_disableFirmware_asm
                              8 .globl cpct_drawSolidBox_asm
                              9 .globl cpct_getScreenPtr_asm
                             10 .globl cpct_setVideoMode_asm
                             11 ;;.globl cpctm_setBorder_asm
                             12 
                             13 
                             14 ;; RENDER AN ENTITY
                             15 ;;      INPUT: IX
   4443                      16 _render_Entity:: ;;importante: actualizar con la posibilidad de abrir sprites.
                             17 
   4443 11 00 C0      [10]   18     ld de, #0xC000
   4446 DD 46 03      [19]   19     ld b, e_y(ix) ;;pos_y
   4449 DD 4E 02      [19]   20     ld c, e_x(ix) ;;pos_x
                             21 
   444C CD 92 46      [17]   22     call cpct_getScreenPtr_asm ;;entidad que comenzara a dibujarse en la pos (x,y)
                             23     
   444F DD 5E 0A      [19]   24     ld e, e_lastVP_l(ix)
   4452 DD 56 0B      [19]   25     ld d, e_lastVP_h(ix)
   4455 AF            [ 4]   26     xor a
   4456 DD 4E 04      [19]   27     ld c, e_w(ix)
   4459 DD 46 05      [19]   28     ld b, e_h(ix)
   445C C5            [11]   29     push bc
   445D CD EE 45      [17]   30     call cpct_drawSolidBox_asm
                             31     
   4460 11 00 C0      [10]   32     ld de, #0xC000
   4463 DD 46 03      [19]   33     ld b, e_y(ix) ;;pos_y
   4466 DD 4E 02      [19]   34     ld c, e_x(ix) ;;pos_x
   4469                      35 º
   4469 CD 92 46      [17]   36     call cpct_getScreenPtr_asm ;;entidad que comenzara a dibujarse en la pos (x,y)
                             37 
   446C DD 75 0A      [19]   38     ld e_lastVP_l(ix), l
   446F DD 74 0B      [19]   39     ld e_lastVP_h(ix), h
   4472 DD 7E 08      [19]   40     ld a, e_c(ix)
   4475 EB            [ 4]   41     ex de, hl
   4476 C1            [10]   42     pop bc
   4477 CD EE 45      [17]   43     call cpct_drawSolidBox_asm ;;dibuja un cuadrado con esas dimensiones.
                             44 
   447A C9            [10]   45     ret
                             46 
                             47 ;; RENDER INIT (llamado desde GAME)
   447B                      48 _render_sys_init::
   447B 0E 00         [ 7]   49     ld c, #0
   447D CD A4 45      [17]   50     call cpct_setVideoMode_asm
                             51 ;;    ld hl, #_pal_main
                             52 ;;    ld de, #16
                             53 ;;    call cpctm_setBorder_asm
   4480 C9            [10]   54 ret
                             55 
                             56 ;; RENDER ALL
   4481                      57 _render_sys_update::
   4481 CD 85 44      [17]   58     call _render_ents_update
   4484 C9            [10]   59 ret
                             60 ;; RENDER ENTITIES
ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 7.
Hexadecimal [16-Bits]



                             61 ;;      INPUT: IX
                             62 ;;      INPUT: A
   4485                      63 _render_ents_update::
   4485 32 8C 44      [13]   64     ld (_ent_counter), a ;;Save entity COUNTER
   4488                      65     _update_loop:
   4488 CD 43 44      [17]   66         call _render_Entity
                     004F    67         _ent_counter = .+1
   448B 3E 00         [ 7]   68         ld a, #0
   448D 3D            [ 4]   69         dec a
   448E C8            [11]   70         ret z
                             71 
   448F 32 8C 44      [13]   72         ld (_ent_counter), a
   4492 01 0D 00      [10]   73         ld bc, #sizeof_e
   4495 DD 09         [15]   74         add ix, bc
   4497 18 EF         [12]   75     jr _update_loop
                             76 
   4499                      77 _render_sys_terminate::
   4499 C9            [10]   78 ret
