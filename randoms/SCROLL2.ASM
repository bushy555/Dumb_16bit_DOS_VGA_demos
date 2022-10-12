
CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h





start:
	mov	ax, 0b800h
	mov	ds, ax
	mov	es, ax

	xor	ax, ax
	mov	dx, ax
L0:


	call	setup
L3:	lodsw
	mov	ah, 00
	stosw
	loop	L3

	add	dx, 160
	cmp	dx, 4000
	jl	L0

	mov	al, 03
	int	10h
	int	20h

setup:
;	call	sit
;	call	sit
	call	sit
	call	sit
	mov	cx, 80
	mov	ax, dx
	mov	di, ax
	mov	si, ax
	ret

sit:	mov	cx, 0ff00h
sit2:	loop	sit2
	ret


CODE     ENDS
         END   START