;
; LAB3.asm
;
; Created: 17.02.2026 22:38:27
; Author : Михаил
;

.include "m168def.inc"

.macro    uout        
   	.if	@0 < 0x60
      	OUT	@0,@1         
	.else
      	STS	@0,@1
   	.endif
   	.endm


.DSEG

.CSEG
.org 0x000 rjmp start

.org 0x020 jmp TIMER0_OVF



start:
	cli
	;r17 хранит счетчик
	ldi r17, 0
	;настраиваю стек
	ldi r16, LOW(RAMEND)
	uout SPL, r16
	ldi r16, HIGH(RAMEND)
	uout SPH, r16

	; настройка TCCR0A
	ldi r16, (0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00)
	uout TCCR0A, r16

	; настройка TCCR0B

	ldi r16, (0<<WGM02) | (1<<CS00) | (0<<CS01) | (0<<CS02)
	uout TCCR0B, r16

	ldi r16, 0
	uout OCR0A, r16
	uout OCR0B, r16

	;настройка маски прерывания
	ldi r16, (1<<TOIE0)
	uout TIMSK0, r16

	ldi r16, 0
	uout TCNT0, r16

	sei

main:
	inc r15
	rjmp main

TIMER0_OVF:
;сохраняй исполльзуемые регистры
	in r16, SREG
	push r16

	inc r17
	cpi r17, 255
	brne exit
	ldi r17, 0

exit:
	pop r16
	out SREG, r16
	
	reti
	



