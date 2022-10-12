
CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h

start:
	mov	ax, 0b800h
	mov	ds, ax
	mov	es, ax

looping:
	mov	dx, 4000
L0:

	call	sit
	call	sit
	call	sit
	call	sit
	call	sit
	mov	bx, dx

	mov	si, bx
L2:	add	bx, 160
	
	mov	di, bx
	mov	cx, 80

L3:	lodsw
	stosw
	loop	L3
	cmp	bx, 4160
	jne	L2

	sub	dx, 160
	cmp	dx, 0000
	jl	L0

	mov	ax, 0003
	int	10h

sit:	mov	cx, 0fffeh
sit2:	loop	sit2
	ret


CODE     ENDS
         END   START