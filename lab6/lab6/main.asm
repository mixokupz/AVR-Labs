;
; lab6.asm
;
; Created: 2.03.2026 10:18:58
; Author : Михаил
;
; Replace with your application code

.include "m168def.inc"

.macro    uout        
    .if @0 < 0x60
        OUT @0,@1         
    .else
        STS @0,@1
    .endif
.endm


.cseg
.org 0x0000 rjmp init

.org 0x0024
    rjmp USART_Recieve


USART_Recieve:
    push r16
    in r16, SREG
    push r16
	push r17

    lds r16, UDR0

	pop r17
    pop r16
    out SREG, r16
    pop r16

    reti               


init:
    ldi r16, LOW(RAMEND)
    out SPL, r16
    ldi r16, HIGH(RAMEND)
    out SPH, r16


    ldi r16, 0
    uout UBRR0H, r16
    ldi r16, 103
    uout UBRR0L, r16


    ldi r16, (1<<RXEN0) | (1<<TXEN0) | (1 << RXCIE0) | (0 << TXCIE0)
    uout UCSR0B, r16          


    ldi r16, (0<<UCSZ02) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UMSEL01) | (0<<UMSEL00)
    uout UCSR0C, r16
	
    sei


loop:
    rcall out_com      
    rjmp loop          

out_com:
    lds r17, UCSR0A
    sbrs r17, UDRE0
    rjmp out_com
    ldi r16, 1
    uout UDR0, r16
    ret
