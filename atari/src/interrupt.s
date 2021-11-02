.include "interrupt.h.s"
.include "cpctelera.h.s"
.globl cpct_akp_musicPlay_asm
man_ir1::
    ;cpctm_push af, bc, hl, de
    ;exx
    ;ex af, af'
    cpctm_push af, bc, hl, de
    
    setNumIR 1
    setNextManIR man_ir2

    cpctm_pop de, hl, bc, af
    ;exx
    ;ex af, af'
    ;cpctm_pop de, hl, bc, af
    ei
    reti

man_ir2::
    ;cpctm_push af, bc, hl, de
    ;exx
    ;ex af, af'
    cpctm_push af, bc, hl, de
    setNumIR 3
    setNextManIR man_ir3

    cpctm_pop de, hl, bc, af
    ;exx
    ;ex af, af'
    ;cpctm_pop de, hl, bc, af
    ei
    reti

man_ir3::
    ;cpctm_push af, bc, hl, de
    ;exx
    ;ex af, af'
    cpctm_push af, bc, hl, de
    setNumIR 4
    setNextManIR man_ir4

    cpctm_pop de, hl, bc, af
    ;exx
    ;ex af, af'
    ;cpctm_pop de, hl, bc, af
    ei
    reti

man_ir4::
    push ix
    push iy
    cpctm_push af, bc, hl, de
    exx
    ex af, af'
    cpctm_push af, bc, hl, de
    setNumIR 5
    setNextManIR man_ir5
    call cpct_akp_musicPlay_asm
    cpctm_pop de, hl, bc, af
    exx
    ex af, af'
    cpctm_pop de, hl, bc, af
    pop iy
    pop ix
    ei
    reti

man_ir5::
    ;cpctm_push af, bc, hl, de
    ;exx
    ;ex af, af'
    cpctm_push af, bc, hl, de
    setNumIR 6
    setNextManIR man_ir6

    cpctm_pop de, hl, bc, af
    ;exx
    ;ex af, af'
    ;cpctm_pop de, hl, bc, af
    ei
    reti

man_ir6::
    ;cpctm_push af, bc, hl, de
    ;exx
    ;ex af, af'
    cpctm_push af, bc, hl, de
    setNumIR 1
    setNextManIR man_ir1
;
    cpctm_pop de, hl, bc, af
    ;exx
    ;ex af, af'
    ;cpctm_pop de, hl, bc, af
    ei
    reti

man_ir_init::
    im 1
    call cpct_waitVSYNC_asm
    halt
    halt
    call cpct_waitVSYNC_asm
    di
    ld a, #0xC3
    ld (0x38), a
    ld hl, #man_ir1
    ld (0x39), hl
    ei
    reti