
CODE     SEGMENT    PARA
	ASSUME   CS:CODE, DS:code, ES:nothing, SS:NOTHING
	org	100h

start:	push	cs
	pop	es
	mov	ax, 0b800h
	mov	ds, ax
	xor	si, si
	mov	di, offset scrn
	mov	cx, 2000
	rep	movsw

	mov	dx, 0080
	mov	bx, 0000
	
	push	ds
	pop	es
	push	cs
	pop	ds
	
@main:
	dec	dx
	inc 	bx
	inc 	bx

load:	mov	si, offset scrn
	mov	di, bx
	mov	cx, 2000
	rep	movsw

	cmp	 dx, 0000
	jne 	 @main

exit:	ret




scrn	db	4000 dup (?)


CODE     ENDS
         END   START