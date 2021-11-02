.module Interrupt_Manager
num_int: .db 6

.macro setNextManIR direccion
    ld hl, #direccion
    ld (0x39), hl
.endm

.macro setNumIR number
    ld a, #number
    ld (num_int), a
.endm

.globl cpct_waitVSYNC_asm
.globl man_ir_init
.irp _num, 1,2,3,4,5,6
    .globl man_ir'_num
.endm

