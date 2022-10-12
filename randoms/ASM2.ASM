
code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov	a, 0
	mov	b, 0
	mov	c, 199;319
	mov	d, 0
	mov	e, 99;160
	mov	f, 199

	mov     ax, 013h
	int     10h

	mov     ax, 0A000h
	mov     es,ax

	mov	count, 0

@main:
	inc	count
	cmp	count, 1000
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

@ad:
	cmp	b, 199;200
	jl	@ac
	dec	a
	dec	a
@ac:
	cmp	c, 0
	jg	@ab
	dec 	d
	dec	d
@ab:
	cmp	f, 0			;	inc	a
	jg	@aa			;	inc	d
	inc	e			;	dec	e
	inc	e
@aa:
	cmp	e, 10 ;1
	jg	@a
	dec	f
	inc	e
@a:
	cmp	d, 199;200
	jl	@b
	dec	d
	dec	c
@b:
	cmp	a, 199;320
	jl	@c
	dec	a
	inc	b
@c:
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
	add	eax, esi
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
	inc	esi
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
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
	push 	ax			;ax = random number (global), so PUSH.
push	02000h
pop	es
	mov	ax, 320
	mul	bx			;AX := MUL Y*320
	push	ax
	add	ax, bp			;AX := AX + X 
	mov	di, ax			;final destination.

	mov     al, 09			;  CYAN = 3.   BLUE = 9.
	stosb
;	mov	ax, 320
;	mul	bx
	pop	ax
	mov	dx, 199;319
	sub	dx, bp
	add	ax, dx
	mov	di, ax	
	mov     al, 9			;  RED 
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

distance equ	6

	a	dw 0
	b	dw 0
	c	dw 0
	d	dw 0
	e	dw 0
	f	dw 0
	count	dw 0
	
   code    ENDS
END     start
