distance equ	6
number	equ	5000
colour	equ	9
colour2	equ	9


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov     ax, 013h
	int     10h

	mov     ax, 0A000h
	mov     es,ax

	mov	count, 0

@main:
	inc	count
	cmp	count, number
	jg	@main1
	jmp	@main2
@main1:
	cmp	e, 199;320
	jl	@ad


	mov	a, 199;0
	mov	b, 0;99
	mov	c, 0;199
	mov	d, 99;0
	mov	e, 99
	mov	f, 199

	mov	count, 0

@ad:	mov	cx, a
	mov	dx, b
	cmp	cx, 199;320
	jl	@c
	dec	cx
	inc	dx
@c:
	cmp	dx, 199;200
	jl	@ac
	dec	cx
	dec	cx
@ac:	mov	a, cx
	mov	b, dx
	mov	cx, c
	mov	dx, d
	cmp	cx, 0
	jg	@ab
	dec 	dx
	dec	dx
@ab:
	cmp	dx, 199;200
	jl	@b
	dec	dx
	dec	cx
@b:	mov	c, cx
	mov	d, dx
	mov	cx, e
	mov	dx, f
	cmp	cx, 10 ;1
	jg	@a
	dec	dx
	inc	cx
@a:
	cmp	dx, 0			;	inc	a
	jg	@aa			;	inc	d
	inc	cx			;	dec	e
	inc	cx
@aa:	mov	e, cx
	mov	f, dx

	inc	a
	inc	d
	dec	e
	mov	count, 0

	push	ax
	push	0a000h
	pop	es
	push	02000h
	pop	ds
	mov	cx, 07d00h
	sub	si, si
	sub	di, di
	rep	movsw

	push    ds
        pop     es
	sub	di, di
	sub	ax, ax
	mov 	cx, 07d00h
	rep 	stosw
	pop	ax

	push	cs
	pop	ds

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea	eax, [eax+eax*2]
	add	ax, si
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	mov	cx, a
	mov	dx, b
	add     si, 3			; Add a bit for the random value.
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	mov	cx, c
	mov	dx, d
	sub     si, 3			; Add a bit for the random value.
	jmp     short @calc
@3:
	mov	cx, e
	mov	dx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:	add    	bp, cx                   ; S := ((S + X[R]) DIV 2);
	shr    	bp, 1

	add    	bx, dx                   ; T := ((T + Y[R]) DIV 2);	
	shr     bx, 1                   	
;------------------------------------
;PUTPIXEL routine. (x,y) -> (bp, bx)
;------------------------------------
	push 	ax			;ax = random number (global), so PUSH.
push	02000h
pop	es
	lea	edi, [ebx+ebx*4]
	shl	di, 6
	push	di
	add	di, bp
	mov	al, colour
	stosb
	pop	di
	mov	dx, 199;319
	sub	dx, bp
	add	di, dx
	mov     al, colour2			;  RED 
	stosb
push	cs
pop	ds
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop 	ax
	je      @quit
	jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn

even
	a	dw 0
	b	dw 0
	c	dw 199
	d	dw 0
	e	dw 99
	f	dw 199
	count	dw 0

   code    ENDS
END     start
