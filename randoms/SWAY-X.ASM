;	1 = D. Blue	5 = Purple	9  = Blue	13 = purple
;	2 = Green 	6 = Brown/org?	10 = L.Green	14 = yellow
;	3 = Cyan	7 = White	11 = L.blue	15 = white
;	4 = Red		8 = Grey	12 = red	16 = black


Colour	equ	23
Colour2	equ	29

number_1	equ	15000

code segment para public
assume cs:code, ds:code, es:code, ss:code
        .386        
        org     100h
start:
        mov     al, 013h
        int     10h
        mov     ax, 0a000h
        mov     es, ax

	sub	cx, cx
        mov     dx, 319

@main:  
        inc     di
        cmp     di, number_1
        jl      @rand

	cmp	flag, 1
	je	decrease
increase:
	inc     a
	inc	g
	dec	c
	dec	e
	cmp	a, 319
	jne	@main2	
	mov	flag, 1

decrease:
	dec	a
	dec	g
	inc	c
	inc	e
	
	
	cmp	a, 0
	jne	@main2
	mov	flag, 0

@main2:
	push	02000h
	pop	ds
	push	0a000h
	pop	es

	push	di
	push	ax
	push	cx
	mov	cx, 07d00h
	push	cx
	sub	di, di
	sub	si, si
	rep	movsw
	
	push	ds
	pop	es

	pop	cx
	sub	ax, ax
	sub	di, di
        rep     stosw
	pop	cx
        pop     ax
	pop	di
        push	cs
	pop	ds
	sub	di, di;	mov     count, 0
	

@rand:  
	lea	eax, [eax+eax*2]
	add	ax, si



;----
	cmp     ax, -16384	;-10923
	jg      @2
	add	bp, a	;=cx
	add	bx, b
	jmp     short @calc
@2:
	cmp     ax, 0		;10923
	jg      @3
	inc	si
	add	bp, c	;=dx
	add	bx, d
	jmp     short @calc
@3:	
	cmp	ax, 16384
	jg	@4
	dec	si
	add	bp, e
	add	bx, f
	jmp	short @calc
@4:
	add	bp, g
	add	bx, h
;----


@calc:  shr     bp, 1
        shr     bx, 1

	push	02000h
	pop	es
        push    ax
	push	di

	lea	edi, [ebx+ebx*4]
	shl	di, 6
	add	di, bp
	mov	al, colour
	stosb

    	mov    	al, colour2
     	sub    	di, 8
      	stosb

	push	cs
	pop	ds
	pop	di

        in      al, 060h
        cmp     al, 1
        pop     ax
        jne     @main

        mov     ax, 0003
        int     10h
        retn

even
	a	dw	0
	b 	dw 	0
	c	dw	319
	d 	dw 	0
	e 	dw 	319
	f 	dw 	199
	g	dw	0
	h	dw	199
	flag	db	0, 0
	count 	dw 	?



code ends
end start





