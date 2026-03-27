;
; lab7.asm
;
; Created: 07.03.2026 21:48:04
; Author : Михаил
;

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
	push r19

    lds r16, UDR0

	pop r19
	pop r17
    pop r16
    out SREG, r16
    pop r16

    reti               


EEPROM_write:

	sbic EECR,EEPE
	rjmp EEPROM_write

	ldi r18, 0
	uout EEARH, r18
	uout EEARL, r18

	uout EEDR,r19
	
	sbi EECR,EEMPE
	
	sbi EECR,EEPE
	ret

EEPROM_read:
	
	sbic EECR,EEPE
	rjmp EEPROM_read
	
	ldi r18, 0
	uout EEARH, r18
	uout EEARL, r18
	
	sbi EECR,EERE
	
	in r19,EEDR
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

	ldi r16, 0
  
	ldi r19,0
    sei


loop:
	rcall EEPROM_write
	rcall EEPROM_read
	inc r19
    rcall out_com      
    rjmp loop          

out_com:
    lds r17, UCSR0A
    sbrs r17, UDRE0
    rjmp out_com
    
    uout UDR0, r19
    ret
