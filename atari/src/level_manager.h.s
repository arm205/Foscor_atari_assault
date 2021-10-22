.globl L_M_init
.globl L_M_loadLevel
.globl L_M_resetCurrentLevel
.globl L_M_levelPassed
.globl L_M_loadMultiplesEntities


;
;IMPORTANTE: CONSIDERACIONES A LA HORA DE PONER COSAS EN EL MAPA
; - TODOS LAS ENTIDADES TIENEN QUE ESTAR EN UN RANGO DE 0-80 EN X, 0-200 EN Y
; - TANTO ENEMIGOS COMO PLAYER COMO CAJAS TIENEN QUE ESTAR EN X MULTIPLO DE 4
; - TANTO ENEMIGOS COMO PLAYER COMO CAJAS TIENEN QUE ESTAR EN Y MULTIPLO DE 8
; TODO ESTO ES PARA ASEGURAR LAS CORRECTAS COLISIONES YA QUE CADA ENTIDAD EMPIEZA COMO EN UN TILE ASIGNADO
;


_level_1::
    .dw     #_level_01                  ;;TileMap
    .db     38,0                       ;;Posicion Player
;    .db     42,42                       ;;Pos enemigo
    .db     78,136                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     1,1                       ;;Pos enemigo2
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     40,150                     ;;Salida
    .db     20,32                      ;;Pos caja
    .db     16,32                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas
    .db     19                          ;;Tamanyo nivel

_level_2::
    .dw     #_level_02                  ;;TileMap
    .db     38,0                       ;;Posicion Player
;    .db     42,42                       ;;Pos enemigo
    .db     78,136                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     1,1                       ;;Pos enemigo2
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     40,150                     ;;Salida
    .db     20,32                      ;;Pos caja
    .db     16,32                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas
    .db     19                          ;;Tamanyo nivel

_level_3::
    .dw     #_level_03                  ;;TileMap
    .db     117,5                       ;;Posicion Player
    .db     42,42                       ;;Pos enemigo
    ;;.db     60,42                     ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     117,150                     ;;Salida
    .db     50,100                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas
    .db     13                          ;;Tamanyo nivel