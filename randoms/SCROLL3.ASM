
CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h





start:
	mov	ax, 0b800h
	mov	ds, ax
	mov	es, ax
	
	mov	dx, 4000
L0:


	call	setup

	sub	dx, 160
	jg	L0

	mov	al, 03
	int	10h
	int	20h

setup:
	call	sit
	call	sit
	mov	cx, 80
	mov	ax, dx
	mov	di, ax
	mov	si, ax
L3:	lodsw
	mov	ah, 00
	stosw
	loop	L3
	ret

sit:	mov	cx, 0ff00h
sit2:	loop	sit2
	ret


CODE     ENDS
         END   START