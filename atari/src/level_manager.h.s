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
; SI VA MUY RAPIDO AÑADE ENTIDADES NADA
;


_level_1::
    .dw     #_level_01_pack_end                  ;;TileMap
    .db     38,0                       ;;Posicion Player
;    .db     42,42                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos
    .db     #0xFF                       ;;FIN enemigos2

    .db     #0xFF                       ;;FIN enemigos3
    .db     36,180                     ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules

    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    
    .db     #0xFF                       ;;FIN Nada
    ;;.db     22                          ;;Tamanyo nivel

_level_2::
    .dw     #_level_02_pack_end                 ;;TileMap
    .db     38,0                       ;;Posicion Player
    .db     #0xFF                       ;;FIN enemigos
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     36,180                     ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules
    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    
    .db     #0xFF                       ;;FIN Nada
    ;;.db     22                          ;;Tamanyo nivel

_level_3::
    .dw     #_level_03_pack_end                  ;;TileMap
    .db     38,0                        ;;Posicion Player
    .db     #0xFF                       ;;FIN enemigos
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     36,180                      ;;Salida
    .db     40,56                       ;;Pos caja
    .db     #0xFF                       ;;FIN cajas verdes
    .db     36,104                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     40,152                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules
    .db     38,0                       ;;Posicion Nada
    .db     38,0                       ;;Posicion Nada
    .db     #0xFF                       ;;FIN Nada


_level_4::
    .dw     #_level_04_pack_end                  ;;TileMap
    .db     38,0                       ;;Posicion Player
    .db     #0xFF                       ;;FIN enemigos
    .db     38, 28
    .db     #0xFF                       ;;FIN enemigos2
    .db     44, 100
    .db     #0xFF                       ;;FIN enemigos3
    .db     36,180                     ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules
    .db     38,0                       ;;Posicion Nada
    .db     #0xFF                       ;;FIN Nada


_level_5::
    .dw     #_level_05_pack_end                  ;;TileMap
    .db     38,0                       ;;Posicion Player
    .db     #0xFF                       ;;FIN enemigos
    .db     16,16                       ;;Pos enemigo
    .db    36,160                      ;;SPos enemigo
    .db     #0xFF                       ;;FIN enemigos2

    .db     52,112                      ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos3
    .db     60,180                      ;;Salida
    .db     57,80                      ;;SPos caja
    .db    28,160                      ;;SPos caja
    .db    40,160                      ;;SPos caja
    .db     #0xFF                       ;;FIN cajas verdes
     .db    47,144                      ;;SPos caja
    .db     #0xFF                       ;;FIN cajas amarillas

    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules
    .db     38,0                       ;;Posicion Nada
    .db     #0xFF                       ;;FIN Nada


_level_6::
    .dw     #_level_06_pack_end                  ;;TileMap
    .db     38,0                       ;;Posicion Player
    .db     #0xFF                       ;;FIN enemigos
    .db     56,48                       ;;Pos enemigo
    .db     48,124                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos2
    .db     12,16                       ;;Pos enemigo
    .db     48,124                      ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos3
    .db     60,180                      ;;Salida
    .db     52,16                       ;;Pos caja
    .db     #0xFF                       ;;FIN cajas verdes
    .db     48,104                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     12,152                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules
    .db     38,0                       ;;Posicion Nada
    .db     #0xFF                       ;;FIN Nada
    ;;.db     22                          ;;Tamanyo nivel


_level_7::
    .dw     #_level_07_pack_end                  ;;TileMap
    .db     58,0                       ;;Posicion Player
    .db     #0xFF                       ;;FIN enemigos
    .db     16,56                      ;;Pos enemigo2
    .db     50,80                       ;;Pos enemigo2
    .db     13,128                      ;;Pos enemigo2
    .db     #0xFF                       ;;FIN enemigos2
    .db     68,144                      ;;Pos enemigo2
    .db     #0xFF                       ;;FIN enemigos3
    .db     16,180                     ;;Salida
    .db     20,128                      ;;Pos caja
    .db     8,128                       ;;Pos caja
    .db     #0xFF                       ;;FIN cajas verdes
    .db     32,80                       ;;Pos caja
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     #0xFF                       ;;FIN cajas azules
    .db     38,0                       ;;Posicion Nada
    .db     #0xFF                       ;;FIN Nada

_level_8::
    .dw     #_level_08_pack_end         ;;TileMap
    .db     16,0                      ;;Posicion Player
    .db     32,42                     ;;Pos enemigo
    .db     #0xFF                     ;;FIN enemigos
    .db     12,80                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     64,180                      ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     64,168                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas azules
    .db     #0xFF                       ;;FIN Nada

_level_9::
    .dw     #_level_09_pack_end         ;;TileMap
    .db     16,0                      ;;Posicion Player
    .db     32,42                     ;;Pos enemigo
    .db     #0xFF                     ;;FIN enemigos
    .db     12,80                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     64,180                      ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     64,168                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas azules
    .db     #0xFF                       ;;FIN Nada

_level_10::
    .dw     #_level_10_pack_end         ;;TileMap
    .db     16,0                      ;;Posicion Player
    .db     32,42                     ;;Pos enemigo
    .db     #0xFF                     ;;FIN enemigos
    .db     12,80                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     64,180                      ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     64,168                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas azules
    .db     #0xFF                       ;;FIN Nada

    _level_11::
    .dw     #_level_11_pack_end         ;;TileMap
    .db     16,0                      ;;Posicion Player
    .db     32,42                     ;;Pos enemigo
    .db     #0xFF                     ;;FIN enemigos
    .db     12,80                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     64,180                      ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     64,168                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas azules
    .db     #0xFF                       ;;FIN Nada

    _level_12::
    .dw     #_level_12_pack_end         ;;TileMap
    .db     16,0                      ;;Posicion Player
    .db     32,42                     ;;Pos enemigo
    .db     #0xFF                     ;;FIN enemigos
    .db     12,80                       ;;Pos enemigo
    .db     #0xFF                       ;;FIN enemigos2
    .db     #0xFF                       ;;FIN enemigos3
    .db     64,180                      ;;Salida
    .db     #0xFF                       ;;FIN cajas verdes
    .db     #0xFF                       ;;FIN cajas amarillas
    .db     #0xFF                       ;;FIN cajas rojas
    .db     64,168                      ;;Pos caja
    .db     #0xFF                       ;;FIN cajas azules
    .db     #0xFF                       ;;FIN Nada

