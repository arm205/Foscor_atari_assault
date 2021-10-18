.globl L_M_init
.globl L_M_changeLevel
.globl L_M_loadLevel
.globl L_M_resetCurrentLevel


_level_1::
    .dw     #_tilemap                   ;;TileMap
    .db     20,160                      ;;Posicion Player
    .db     42,42                       ;;Pos enemigo
    .db     60,42                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     0,0                         ;;Salida
    .db     50,100                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas

