IVT 	Segment at 0h
	ORG	9H * 4
KEYBD	dw	2 dup (0)
IVT	ENDS


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
front label	near
start: 	jmp	init

flag	db 0
oldkb	label	dword
oldkey	   dw	2 dup (0)
count	   db	0
res	=	((rear - front) /16) + 11h


MAIN	PROC	NEAR
	cmp	byte ptr cs:flag, 0ffh
	jne	mainrtn
	jmp	dword ptr cs:oldkb
mainrtn:
	mov	byte ptr cs:flag, 0ffh
	sti
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	ds
	push	es
	pushf
	push	cs
	pop	ds
	call	dword ptr cs:oldkb
	mov	ah, 01
	int	16h
	jz	exit


	mov	al, byte ptr cs:count
	inc	ax
	mov	byte ptr cs:count, al

	cmp	al, 14
	je	@WipeOut
exit:
	pop	es
	pop	ds
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	mov	byte ptr cs:flag,00
	iret


@WipeOut:
	mov	byte ptr cs:count, 000h
	mov     ax, 000b8h		;                    		(3)
        mov     ds, ax			;				(2)
	mov	es, ax			;				(2)
	mov	bl, 0ffh		;				(2)
@0:	sub	si, si			;				(2)
	sub	di, di			;				(2)
	mov	cx, 07d0h		;				(3)
@1:	lodsb				;				(1)
	cmp	al, 020h		;				(2)
	jz	@3			;				(2)
	inc	ax			;				(1)
	stosb				;				(1)
	dec	di			;				(1)
@3:	inc	di			;				(1)
	inc	di			;				(1)
	inc	si			;				(1)
	loop	@1			;				(2)
	dec	bx			;				(1)
	jg	@0			;				(2)
	jmp	short exit		;				(2)


rear	label	near
MAIN	ENDP



INIT	PROC	NEAR
	mov	ax, IVT
	mov	ds, ax
	ASSUME	ds:IVT
	mov	ax, word ptr ds:keybd
	mov	word ptr cs:oldkey, ax
	mov	ax, word ptr ds:keybd+2
	mov	word ptr cs:oldkey+2, ax
	cli
	mov	word ptr keybd,	offset	MAIN
	mov	word ptr keybd+2, cs
	mov	byte ptr cs:flag, 00
	sti
	mov	dx, res
	mov	ah, 31h
	int	21h
INIT	ENDP


   code    ENDS
END     start
