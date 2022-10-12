;uses two screens. Slightly slower... but less flicker.
number_1        equ     32000
Colour	equ	2
Colour2	equ	9

;	1 = D. Blue	5 = Purple	9  = Blue	13 = purple
;	2 = Green 	6 = Brown/org?	10 = L.Green	14 = yellow
;	3 = Cyan	7 = White	11 = L.blue	15 = white
;	4 = Red		8 = Grey	12 = red	16 = black

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	push	02000h
	pop	es
        xor     di, di
        xor     eax, eax
	mov 	cx, 16000
	rep 	stosd

	push	0A000h
	pop	es

	mov     ax, 013h
	int     10h

@main:	inc	si
	cmp	si, number_1
	jl	@main2
@main1:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(E,F)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        cmp     e, 1    ;(0,dec Y)
	jg	@a
        cmp     f, 1
	jl	@a
        dec     f
        inc     e
@a:
        cmp     f, 1    ;(inc X, 0)
	jg	@b
        cmp     e, 318
	jg	@b
        inc     e
        inc     e
@b:
        cmp     e, 318  ;(319, dec Y)
	jl	@c
        cmp     f, 198
	jg	@c
        inc     e
        inc     f
@c:	
        dec     e
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(A,B)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@d:	
        cmp     a, 318  ;(319, inc Y)
	jl	@e
        cmp     b, 198
	jg	@e
        dec     a
        inc     b
@e:
        cmp     b, 198  ;(dec X, 199)
	jl	@f
        cmp     a, 1
	jl	@f
        dec     a
        dec     a
@f:
        cmp     a, 1    ;(0, dec Y)
	jg	@g
        cmp     b, 1
	jl	@g
        dec     a
        dec     b
@g:	
        inc     a
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(C,D)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@h:	
        cmp     d, 198  ;(dec X, 199)
	jl	@i
        cmp     c, 1
	jl	@i
        dec     c
        dec     d
@i:
        cmp     c, 1    ;(0, dec Y)
	jg	@j
        cmp     d, 1
	jl	@j
        dec     d
        dec     d
@j:
        cmp     d, 1    ;(inc X, 0)
	jg	@k
        cmp     c, 318
	jg	@k
        dec     d
        inc     c
@k:	
        inc     d
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(G,H)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

        cmp     h, 198  ;(dec X, 199)
	jl	@l			
        cmp     g, 1
	jl	@l				
        inc     h
        dec     g
@l:
        cmp     h, 0    ;(0, inc X)
	jg	@m
        cmp     g, 0
	jl	@m
        inc     h
        inc     g
@m:
        cmp     g, 319  ;(319, inc Y)
	jl	@n
        cmp     h, 0
	jl	@n
        inc     h
        inc     h
@n:	
        dec     h

@waydownhere:

	push	eax
	
	mov	ax, 0a000h
	mov	es, ax
	mov	ax, 02000h
	mov	ds, ax
	mov	cx, 16000
        xor     si, si
        xor     di, di
	rep	movsd
        xor     si, si

	mov	ax, ds
	mov	es, ax
        xor     di, di
        xor     eax, eax
	mov 	cx, 16000
	rep 	stosd

	mov	ax, cs
	mov	ds, ax
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop 	eax
	je      @quit

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea	eax, [eax + eax * 2]
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -16384
	jg      @2
	add	bp, a
	add	bx, b
	jmp     short @calc
@2:
	cmp     ax, 0
	jg      @3
	add	bp, c
	add	bx, d
	jmp     short @calc
@3:	
	cmp	ax, 16384
	jg	@4
	add	bp, e
	add	bx, f
	jmp	short @calc
@4:
	add	bp, g
	add	bx, h
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------

@calc:	shr	bp, 1				; S := ((S + X[R]) DIV 2);
	shr	bx, 1				; T := ((T + Y[R]) DIV 2);	

;------------------------------------
;PUTPIXEL routine. (x,y) -> (bp, bx)
;------------------------------------
	push 	eax			;ax = random number (global), so PUSH.

	mov	ax, 02000h
	mov	es, ax
	lea	edi, [ebx+ebx*4]
	shl	edi, 6
	push	di
	add	di, bp
	mov     al, colour
	stosb	
	pop	di
	mov	dx, 319
        sub     dx, bp
	add	di, dx
	mov     al, colour2 
	stosb
	pop	eax
        jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn

even
	a	dw 0
	b	dw 0
	c	dw 319
	d	dw 0
	e	dw 319
	f	dw 199
	g	dw 0
	h	dw 199
	count	dw 0

   code    ENDS
END     start

