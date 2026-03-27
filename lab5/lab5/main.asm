;
; lab5.asm
;
; Created: 22.02.2026 15:03:08
; Author : Михаил
;


.include "m168def.inc"

.DSEG
quotient:   .byte 1
remainder:  .byte 1

.CSEG
.org 0x0000 rjmp    start

start:

    ldi     r16, LOW(RAMEND)
    out     SPL, r16
    ldi     r16, HIGH(RAMEND)
    out     SPH, r16
    
    
    ldi     r16, 50         ; делимое
    ldi     r17, 10          ; делитель
    
    
    rcall   divide
    
    sts     quotient, r18
    sts     remainder, r19
    
loop:
    rjmp    loop

divide:
    ldi     r18, 0             
    mov     r19, r16        
    
divide_loop:
    cp      r19, r17        ; сравниваю остаток с делителем
    brlo    divide_end      ; если остаток < делителя => exit
    
    sub     r19, r17        ; остаток = остаток - делитель
    inc     r18             ; частное =+ 1
    rjmp    divide_loop
    
divide_end:
    ret