.globl L_M_init
.globl L_M_changeLevel
.globl L_M_loadLevel
.globl L_M_resetCurrentLevel
.globl L_M_levelPassed


_level_1::
    .dw     #_level_01                   ;;TileMap
    .db     20,160                      ;;Posicion Player
    .db     42,42                       ;;Pos enemigo
    .db     60,42                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     10,10                        ;;Salida
    .db     50,100                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas
    .db     15                          ;;Tamanyo nivel

_level_2::
    .dw     #_level_02                   ;;TileMap
    .db     20,160                      ;;Posicion Player
    .db     42,42                       ;;Pos enemigo
    ;;.db     60,42                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     10,10                        ;;Salida
    .db     50,100                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas
    .db     13                          ;;Tamanyo nivel
