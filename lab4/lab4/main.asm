;
; lab4.asm
;
; Created: 19.02.2026 11:25:05
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

start:
	cli
	ldi r16, (1<<DDD6)
	out DDRD, r16

	; настройка TCCR0A
	ldi r16, (0<<COM0A1) | (1<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00)
	uout TCCR0A, r16

	; настройка TCCR0B

	ldi r16, (0<<WGM02) | (1<<CS00) | (0<<CS01) | (0<<CS02)
	uout TCCR0B, r16

	ldi r16, 0
	
	uout OCR0B, r16
	ldi r16, 127
	uout OCR0A, r16
	
	ldi r16, 0
	uout TCNT0, r16

	;sei

main:
	rjmp main



