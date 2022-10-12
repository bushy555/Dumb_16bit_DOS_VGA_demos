
CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h





start:
	mov	ax, 0b800h
	mov	ds, ax
	mov	es, ax

;	mov	cx, 24
looping:
	mov	dx, 4000
L0:

	call	setup

	sub	dx, 160
	cmp	dx, 0000
	jnl	L0

;	loop	looping
	mov	ax, 0003
	int	10h
	int	20h


setup:
	push 	cx
	call	sit
	call	sit
	call	sit
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
	pop 	cx
	ret

sit:	mov	cx, 09000h
sit2:	loop	sit2
	ret


CODE     ENDS
         END   START