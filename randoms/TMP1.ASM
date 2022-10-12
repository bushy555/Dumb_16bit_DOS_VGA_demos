number_1	equ	20000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov	a, 0
	mov	b, 0
	mov	c, 319
	mov	d, 0
	mov	e, 160
	mov	f, 199

	push	0a000h
	pop	es

	mov     ax, 013h
	int     10h

	mov	count, 0
@main:
	inc	count
	cmp	count, number_1
	jl	@main2	;g	@main1
;	jmp	@main2
@main1:
	cmp	e, 0	;(0,dec Y)
	jg	@a
	cmp	f, 1
	jl	@a
	dec	f
	inc	e
@a:
	cmp	f, 0	;(inc X, 0)
	jg	@b
	cmp	e, 318
	jg	@b
	inc	e
	inc	e
@b:
	cmp	e, 319	;(319, dec Y)
	jl	@c
	cmp	f, 198
	jg	@c
	inc	e
	inc	f
@c:
@d:
	cmp	a, 319	;(319, inc Y)
	jl	@e
	cmp	b, 198
	jg	@e
	dec	a
	inc	b
@e:
	cmp	b, 199	;(dec X, 199)
	jl	@f
	cmp	a, 1
	jl	@f
	dec	a
	dec	a
@f:
	cmp	a, 0	;(0, dec Y)
	jg	@g
	cmp	b, 1
	jl	@g
	dec	a
	dec	b
@g:
@h:	
	cmp	d, 199	;(dec X, 199)
	jl	@i
	cmp	c, 0
	jl	@i
	dec	c
	dec	d
@i:
	cmp	c, 0	;(0, dec Y)
	jg	@j
	cmp	d, 0
	jl	@j
	dec	d
	dec	d
@j:
	cmp	d, 0	;(inc X, 0)
	jg	@k
	cmp	c, 319
	jg	@k
	dec	d
	inc	c
@k:
		


				;	inc	a
				;	inc	d
				;	dec	e

;jmp	@waydownhere
;	cmp	e, 199;320
;	jl	@ad
;
;	mov	a, 199;0
;	mov	b, 0;99
;	mov	c, 0;199
;	mov	d, 99;0
;	mov	e, 99
;	mov	f, 199
;
;	mov	count, 0
;
;@ad:
;	cmp	b, 199;200
;	jl	@ac
;	dec	a
;	dec	a
;@ac:
;	cmp	c, 0
;	jg	@ab
;	dec 	d
;	dec	d
;@ab:
;	cmp	f, 0			;	inc	a
;	jg	@aa			;	inc	d
;	inc	e			;	dec	e
;	inc	e
;@aa:
;	cmp	e, 10 ;1
;	jg	@a
;	dec	f
;	inc	e
;@a:
;	cmp	d, 199;200
;	jl	@b
;	dec	d
;	dec	c
;@b:
;	cmp	a, 199;320
;	jl	@c
;	dec	a
;	inc	b
;@c:

;@waydownhere:
	inc	a
	inc	d
	dec	e
	mov	count, 0
	sub	di, di
	push	ax
	mov 	ax, 0000
	mov 	cx, 8000h
	rep 	stosw
	pop	ax

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	lea	eax, [eax + eax * 2]
	add	ax, si

;	mov     dx, 08405h
;	mul     dx
;	add     ax, si
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
;	sub     si, 3			; Add a bit for the random value.
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

	mov	di, bx
	lea	edi, [edi + edi * 4]
	shl	edi, 6
	push	di
	add	di, bp
	mov     al, 9
	stosb
	pop	ax
	mov	dx, 320
	sub	dx, bp
	add	ax, dx
	mov	di, ax	
	mov     al, 4	
	stosb

	mov	dx, 199
	sub	dx, bx

	mov	di, dx
	lea	edi, [edi + edi * 4]
	shl	edi, 6
	push	di
	add	di, bp
	mov     al, 4
	stosb

	pop	ax
	mov	dx, 320
	sub	dx, bp
	add	ax, dx
	mov	di, ax	
	mov     al, 9
	stosb

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