;
; lab7.asm
;
; Created: 07.03.2026 21:48:04
; Author : Михаил
;
; надо передать строку abcdefghi\n
.include "m168def.inc"

.macro    uout        
    .if @0 < 0x60
        OUT @0,@1         
    .else
        STS @0,@1
    .endif
.endm

.dseg

string: .byte 10;

.cseg
.org 0x0000 rjmp init

.org 0x0024
    rjmp USART_Recieve

walk: 
	;ld r17, X+
	adiw X, 1
	ld r17, X
	cpse r16, r17
	rjmp walk
	ret

store:
	
	cpse r16, r17
	rcall walk
	st X, r16

	ret
	

USART_Recieve:
    push r16
    in r16, SREG
    push r16
	push r17
	push r19
	push r26
	push r27

    lds r16, UDR0
	
	ldi XL, low(string)
	ldi XH, high(string)
	ld r17, X
	rcall store

	pop r27
	pop r26
	pop r19
	pop r17
    pop r16
    out SREG, r16
    pop r16

    reti               

init_string:
	
	st X+, r16
	inc r16
	cpse r16, r17
	rjmp init_string
	ldi r16, '\n'
	st X+, r16
	ret
	

init:
    ldi r16, LOW(RAMEND)
    out SPL, r16
    ldi r16, HIGH(RAMEND)
    out SPH, r16

    ldi r16, 0
    uout UBRR0H, r16
    ldi r16, 103
    uout UBRR0L, r16
	
	
	ldi r16, 0
    ldi r16, (1<<RXEN0) | (1<<TXEN0) | (1 << RXCIE0) | (0 << TXCIE0) 
    uout UCSR0B, r16          

	ldi r16, 0
    ldi r16, (0<<UCSZ02) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UMSEL01) | (0<<UMSEL00)
    uout UCSR0C, r16

    sei

	ldi XL, low(string)
	ldi XH, high(string)
	ldi r16, 'a'
	ldi r17, 'j'

	rcall init_string
	ldi r17, '\n'

loop:
	ldi XL, low(string)
	ldi XH, high(string)
    rcall out_com      
    rjmp loop          

out_com:
    lds r19, UCSR0A
    sbrs r19, UDRE0
    rjmp out_com
    ld r16, X+
	
	uout UDR0, r16
	cpse r16, r17
	rjmp out_com
    ret
