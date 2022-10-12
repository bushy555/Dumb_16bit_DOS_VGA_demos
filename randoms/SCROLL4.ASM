
CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h





start:
	mov	ax, 0b800h
	mov	ds, ax
	mov	es, ax

	call	knockup	
	mov	cx, 24
looping:
	mov	dx, 4000
L0:

	call	setup

	sub	dx, 160
	cmp	dx, 0000
	jnl	L0

	loop	looping
	mov	al, 03
	int	10h
	mov	ah, 4ch
	int	21h
	int	20h

Knockup:
	push	dx
	mov	dx, 0000

	push	cx
	mov	cx, 80
	mov	ax, dx

	mov	si, ax
	mov	di, ax
@L3:	lodsw
	mov	ah, 00
	stosw
	loop	@L3
	pop 	cx
	pop	dx
	ret

setup:
	push 	cx
	call	sit
	mov	cx, 80
	mov	ax, dx

	mov	si, ax
	add	ax, 160
	mov	di, ax
L3:	lodsw
	stosw
	loop	L3
	pop 	cx
	ret

sit:	mov	cx, 0900h
sit2:	loop	sit2
	ret


CODE     ENDS
         END   START