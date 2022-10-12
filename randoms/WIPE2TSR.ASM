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

	push	0b800h
	pop	es
        mov     cx, 000b4h
	sub	bx, bx

@@loopy2:
        push    cx

middle_bit:
        mov     dx,3dah
@@vw1:  in      al,dx  
        and     al,08h 
        jnz     @@vw1  
@@vw2:  in      al,dx  
        and     al,08h 
        jz      @@vw2  
	sub 	ax, ax
@@loop20:    
	mov 	si, ax
        cmp     ax, bx
        jnl     @@exiting
	push	ax
        mov     cx, 00025
        mov     bp, cx
@@loopy3:
        dec     bp
        dec     bp

	call	@@1

  	sub	ax, ax
  	mov   	al,  es:[di]
	push	ax
        inc     bp

	call	@@1

	pop	ax
   	mov  	es:[di], al

        loop 	@@loopy3
	pop	ax
	inc 	ax
	inc 	ax
        jmp 	short @@loop20
@@exiting:
        inc     bx
        pop 	cx
        loop   	@@loopy2
@@finish:
	jmp	short	exit



@@1:
        mov     ax, bp
   	mov  	dx, 0a0h
   	mul  	dx
   	add  	ax, si
	mov  	di, ax
	ret



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