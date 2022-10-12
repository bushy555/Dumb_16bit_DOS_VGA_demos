
CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, ES:code, ss:code

org 100h



start:
	include		dos5head.inc
	mov	ax, 013h
	int	10h
	mov	ax, 0a000h
	mov	es, ax
	
	xor	bx, bx
cruise:
	cmp	bx, 0fffeh
	jne	@h1
	xor	bx, bx
@h1:
	mov	bh, bl
	mov	cx, 0fa00h
	xor	di, di
	mov	ax, bx
	call	retrace
	call	retrace
	call	retrace
	repz	stosw

	inc	bx

	jmp	cruise

retrace:
	push	ax
	push	dx
	mov	dx, 003dah
@@vw1:	in	al, dx
	test	al, 08h
	jz	@@vw1
@@vw2:	in	al, dx
	test	al, 08h
	jnz	@@vw2
	pop	dx
	pop	ax
	ret

CODE     ENDS
         END   START