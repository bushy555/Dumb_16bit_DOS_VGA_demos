;uses two screens. Slightly slower... but less flicker.



number_1 	equ	5000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	push	02000h
	pop	es
	xor	di, di
	sub	ax, ax
	mov 	cx, 07d00h
	rep 	stosw

	push	0A000h
	pop	es

	mov     ax, 013h
	int     10h

	sub	si, si
@main:
	inc	si
	cmp	si, number_1
	jl	@main2
@main1:
        mov     cx, e
        mov     dx, f

        cmp     cx, 0    ;(0,dec Y)
	jg	@a
        cmp     dx, 1
	jl	@a
        dec     dx
        inc     cx
@a:
        cmp     dx, 0    ;(inc X, 0)
	jg	@b
        cmp     cx, 318
	jg	@b
        inc     cx
        inc     cx
@b:
        cmp     cx, 319  ;(319, dec Y)
	jl	@c
        cmp     dx, 198
	jg	@c
        inc     cx
        inc     dx
@c:     dec     cx
        mov     e, cx
        mov     f, dx
@d:
        mov     cx, a
        mov     dx, b
        cmp     cx, 319  ;(319, inc Y)
	jl	@e
        cmp     dx, 198
	jg	@e
        dec     cx
        inc     dx
@e:
        cmp     dx, 199  ;(dec X, 199)
	jl	@f
        cmp     cx, 1
	jl	@f
        dec     cx
        dec     cx
@f:
        cmp     cx, 0    ;(0, dec Y)
	jg	@g
        cmp     dx, 1
	jl	@g
        dec     cx
        dec     dx
@g:     inc     cx
        mov     a, cx
        mov     b, dx
@h:	
        mov     cx, c
        mov     dx, d

        cmp     dx, 199  ;(dec X, 199)
	jl	@i
        cmp     cx, 0
	jl	@i
        dec     cx
        dec     dx
@i:
        cmp     cx, 0    ;(0, dec Y)
	jg	@j
        cmp     dx, 0
	jl	@j
        dec     dx
        dec     dx
@j:
        cmp     dx, 0    ;(inc X, 0)
	jg	@k
        cmp     cx, 319
	jg	@k
        dec     dx
        inc     cx
@k:
        inc     dx
        mov     c, cx
        mov     d, dx
		

@waydownhere:
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

	sub	si, si

	push	cs
	pop	ds
@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea	eax, [eax + eax * 2]
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	add	bp, a
	add	bx, b
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	add	bp, c
	add	bx, d
	jmp     short @calc
@3:
	add	bp, e
	add	bx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:	
	shr    	bp, 1                   ; S := ((S + X[R]) DIV 2);
	shr     bx, 1                    ; T := ((T + Y[R]) DIV 2);	
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
push	eax
	push	02000h
	pop	es
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

	lea	edi, [ebx + ebx * 4]
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
	e	dw 160
	f	dw 199
	count	dw 0


   code    ENDS
END     start
