;
; Lab2.asm
;
; Created: 10.02.2026 10:18:58
; Author : Михаил
;
; Replace with your application code
.include "m168def.inc"

.DSEG
array1: .BYTE 10 ;
array2: .BYTE 10 ;

.CSEG
.org $000 rjmp prepare

prepare:
    ldi ZL, low(array1) 
	ldi ZH, high(array1)
	ldi YL, low(array2)
	ldi YH, high(array2)
	ldi r16, 0
	ldi r17, 10
	ldi r18, 11 ; загрузили число для поиска

    rjmp start1

start1:
	st Z+, r16
	inc r16
	cpi r16, 10
	breq start2
	rjmp start1

start2:
	st Y+,r17
	inc r17
	cpi r17, 20
	breq prefind
	rjmp start2


prefind:
	ldi ZL, low(array1) 
	ldi ZH, high(array1)
	ldi YL, low(array2)
	ldi YH, high(array2)
	rjmp find_inZ

find_inZ:
	ld r19, Z+ 
	cp r18, r19 ;
	breq end
	;ld r19, Z+ 
	cpi r19, 10 ;
	breq find_inY
	rjmp find_inZ

find_inY:
	ld r19, Y+
	cp r18, r19 ;
	breq end
	rjmp find_inY

end:

