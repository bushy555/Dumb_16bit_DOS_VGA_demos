;uses two screens. Slightly slower... but less flicker.
number_1 	equ	15000
Colour	equ	10
Colour2	equ	2

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
	sub	di, di
	sub	ax, ax
	mov 	cx, 07d00h
	rep 	stosw

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

        push    eax
        push    bx
        mov     ax, 1
        mov     bx, 99

        mov     cx, e
	mov	dx, f

        cmp     cx, ax   ;(0,dec Y)
	jg	@a
        cmp     dx, ax
	jl	@a
        dec     dx
        inc     cx
@a:
        cmp     dx, ax   ;(inc X, 0)
	jg	@b
        cmp     cx, bx
	jg	@b
        inc     cx
        inc     cx
@b:
        cmp     cx, bx   ;(319, dec Y)
	jl	@c
        cmp     dx, bx
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
        cmp     cx, bx   ;(319, inc Y)
	jl	@e
        cmp     dx, bx
	jg	@e
        dec     cx
        inc     dx
@e:
        cmp     dx, bx   ;(dec X, 199)
	jl	@f
        cmp     cx, ax
	jl	@f
        dec     cx
        dec     cx
@f:
        cmp     cx, ax   ;(0, dec Y)
	jg	@g
        cmp     dx, ax
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
        cmp     dx, bx   ;(dec X, 199)
	jl	@i
        cmp     cx, ax
	jl	@i
        dec     cx
        dec     dx
@i:
        cmp     cx, ax   ;(0, dec Y)
	jg	@j
        cmp     dx, ax
	jl	@j
        dec     dx
        dec     dx
@j:
        cmp     dx, ax   ;(inc X, 0)
	jg	@k
        cmp     cx, bx
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

        cmp     dx, bx   ;(dec X, 199)
	jl	@l			
        cmp     cx, ax
	jl	@l				
        inc     dx
        dec     cx
@l:
        dec     ax
        cmp     dx, ax   ;(0, inc X)
	jg	@m
        cmp     cx, ax
	jl	@m
        inc     dx
        inc     cx
@m:
        cmp     cx, bx   ;(319, inc Y)
	jl	@n
        cmp     dx, ax
	jl	@n
        inc     dx
        inc     dx
@n:	
	dec	dx
	mov	g, cx
	mov	h, dx

@waydownhere:
	mov	ax, 0a000h
	mov	es, ax
	mov	ax, 02000h
	mov	ds, ax
	mov	cx, 16000
	sub	si, si
	sub	di, di
	repz	movsd
	sub	si, si

	mov	ax, 02000h
	mov	es, ax
	sub	di, di
	sub	eax, eax
	mov 	cx, 16000
	rep 	stosd
        pop     bx

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
	mov	di, -16384
	cmp     ax, di
	jg      @2
	add	bp, a
	add	bx, b
	jmp     short @calc
@2:
	sub	di, di
	cmp     ax, di
	jg      @3
	add	bp, c
	add	bx, d
	jmp     short @calc
@3:	
	mov	di, 16384
	cmp	ax, di
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
	add	di, bp
	mov     al, colour;09			;  CYAN = 3.   BLUE = 9.
	stosb	
	add	di, 99
	stosb
	add	di, 99
	stosb
	add	di, 31802	;(32000 - 99 - 99)
	stosb
	add	di, 99
	stosb
	add	di, 99
	stosb

	mov	ax, 99
	sub	ax, bx
	push	cx

	mov	cx, 99
	sub	cx, bp

	lea	edi, [eax+eax*4]
	shl	edi, 6
	add	di, cx
	mov     al, colour2;04		;  CYAN = 3.   BLUE = 9.
	stosb	
	pop	cx

	add	di, 99
	stosb
	add	di, 99
	stosb
	add	di, 31802
	stosb
	add	di, 99
	stosb
	add	di, 99
	stosb
	pop 	eax

        jmp     @main


@quit:
	mov    ax, 0003h
	int    10h
	retn

even
	a	dw 0
	b	dw 0
	c	dw 99 
	d	dw 0
	e	dw 99 
	f	dw 99 
	g	dw 0
	h	dw 99 

   code    ENDS
END     start

