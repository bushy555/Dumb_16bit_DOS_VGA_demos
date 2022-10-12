;uses two screens. Slightly slower... but less flicker.
number_1 	equ	15000
;Colour  equ     2
;Colour2 equ     9

;	1 = D. Blue	5 = Purple	9  = Blue	13 = purple
;	2 = Green 	6 = Brown/org?	10 = L.Green	14 = yellow
;	3 = Cyan	7 = White	11 = L.blue	15 = white
;	4 = Red		8 = Grey	12 = red	16 = black

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
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

	mov	cx, e
	mov	dx, f

        cmp     cx, 1    ;(0,dec Y)
	jg	@a
        cmp     dx, 1
	jl	@a
        dec     dx
        inc     cx
@a:
        cmp     dx, 1    ;(inc X, 0)
	jg	@b
        cmp     cx, 318
	jg	@b
        inc     cx
        inc     cx
@b:
        cmp     cx, 318  ;(319, dec Y)
	jl	@c
        cmp     dx, 198
	jg	@c
        inc     cx
        inc     dx
@c:	
	dec	cx
	mov	e, cx
	mov	f, dx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(A,B)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@d:	
	mov	cx, a
	mov	dx, b
        cmp     cx, 318  ;(319, inc Y)
	jl	@e
        cmp     dx, 198
	jg	@e
        dec     cx
        inc     dx
@e:
        cmp     dx, 198  ;(dec X, 199)
	jl	@f
        cmp     cx, 1
	jl	@f
        dec     cx
        dec     cx
@f:
        cmp     cx, 1    ;(0, dec Y)
	jg	@g
        cmp     dx, 1
	jl	@g
        dec     cx
        dec     dx
@g:	
	inc	cx
	mov	a, cx
	mov	b, dx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(C,D)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@h:	
	mov	cx, c
	mov	dx, d
        cmp     dx, 198  ;(dec X, 199)
	jl	@i
        cmp     cx, 1
	jl	@i
        dec     cx
        dec     dx
@i:
        cmp     cx, 1    ;(0, dec Y)
	jg	@j
        cmp     dx, 1
	jl	@j
        dec     dx
        dec     dx
@j:
        cmp     dx, 1    ;(inc X, 0)
	jg	@k
        cmp     cx, 318
	jg	@k
        dec     dx
        inc     cx
@k:	
	inc	dx
	mov	c, cx
	mov	d, dx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	(G,H)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	mov	cx, g
	mov	dx, h

        cmp     dx, 198  ;(dec X, 199)
	jl	@l			
        cmp     cx, 1
	jl	@l				
        inc     dx
        dec     cx
@l:
        cmp     dx, 0    ;(0, inc X)
	jg	@m
        cmp     cx, 0
	jl	@m
        inc     dx
        inc     cx
@m:
        cmp     cx, 319  ;(319, inc Y)
	jl	@n
        cmp     dx, 0
	jl	@n
        inc     dx
        inc     dx
@n:	
	dec	dx
	mov	g, cx
	mov	h, dx

@waydownhere:


	push	cs
	pop	ds
	inc	colour
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

	lea	edi, [ebx+ebx*4]
	shl	edi, 6
	push	di
	add	di, bp
	mov     al, colour
	stosb	
	pop	di
	mov	dx, 319
	sub	dx, bp
	add	di, dx
	mov     al, colour
	stosb

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop 	eax
	je      @quit
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
	colour	db 0
   code    ENDS
END     start
