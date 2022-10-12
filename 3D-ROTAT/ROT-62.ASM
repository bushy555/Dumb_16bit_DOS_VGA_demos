number_1 	equ	15000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	push	02000h
	pop	es
	xor	di, di
	sub	eax, eax
	mov 	cx, 16000
	rep 	stosd

	mov	ax, 0a000h
	mov	es, ax

	mov     ax, 013h
	int     10h

					;from here down, is the background.
@0109:  MOV     DX, 03C8h
@010C:  MOV     AL, 01
@010E:  OUT     DX, AL
@010F:  INC     DX
@0110:  MOV     CX, 00FEh
@0113:  SUB     AL, AL
@0115:  OUT     DX, AL
@0116:  OUT     DX, AL
@0117:  MOV     AL, CL
@0119:  shr	al, 02
@011A:  out	dx, al
@011D:  LOOP    @0113
@011F:  MOV     AL, 3Fh
@0121:  OUT     DX, AL
@0122:  OUT     DX, AL
@0123:  OUT     DX, AL


	sub	si, si
@main:
	inc	si
	cmp	si, number_1
	jl	@main2
@main1:
	mov	cx, e
	mov	dx, f
	cmp	cx, 0	;(0,dec Y)
	jg	@a
	cmp	dx, 1
	jl	@a
	dec	dx
	inc	cx
@a:
	cmp	dx, 0	;(inc X, 0)
	jg	@b
	cmp	cx, 99
	jg	@b
	inc	cx
	inc	cx
@b:
	cmp	cx, 99	;(319, dec Y)
	jl	@c
	cmp	dx, 99
	jg	@c
	inc	cx
	inc	dx
@c:	
	dec	cx
	mov	e, cx
	mov	f, dx
	mov	cx, a
	mov	dx, b
@d:
	cmp	cx, 99	;(319, inc Y)
	jl	@e
	cmp	dx, 99
	jg	@e
	dec	cx
	inc	dx
@e:
	cmp	dx, 99	;(dec X, 199)
	jl	@f
	cmp	cx, 1
	jl	@f
	dec	cx
	dec	cx
@f:
	cmp	cx, 0	;(0, dec Y)
	jg	@g
	cmp	dx, 1
	jl	@g
	dec	cx
	dec	dx
@g:
	inc	cx
	mov	a, cx
	mov	b, dx
@h:	mov	cx, c
	mov	dx, d
	cmp	dx, 99	;(dec X, 199)
	jl	@i
	cmp	cx, 0
	jl	@i
	dec	cx
	dec	dx
@i:
	cmp	cx, 0	;(0, dec Y)
	jg	@j
	cmp	dx, 0
	jl	@j
	dec	dx
	dec	dx
@j:
	cmp	dx, 0	;(inc X, 0)
	jg	@k
	cmp	cx, 99
	jg	@k
	dec	dx
	inc	cx
@k:	inc	dx
	mov	c, cx
	mov	d, dx

@waydownhere:
	push	ax

	mov	ax, 0a000h
	mov	es, ax
	mov	ax, 02000h
	mov	ds, ax
	mov	cx, 016000
	sub	si, si
	sub	di, di
	rep	movsd
	sub	si, si

	mov	ax, cs
	mov	ds, ax

	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main3
increase:
	inc     colour
	cmp	colour, 255
	jne	@main3	
	mov	flag1, 1

decrease:
	dec	colour
	cmp	colour, 1
	jne	@main3
	mov	flag1, 0

@main3:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop 	ax
	je      @quit

	even
@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea	eax, [eax + eax * 2]
;	add     eax, esi
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	add	bp, a
	add	bx, b
;	add     si, 3			; Add a bit for the random value.
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
	even
@calc:	
	shr    	bp, 1

	shr     bx, 1                   	
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
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

	mov	cx, 99
	sub	cx, bp

	lea	edi, [eax+eax*4]
	shl	edi, 6
	add	di, cx
	mov     al, colour;04		;  CYAN = 3.   BLUE = 9.
	stosb	

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

	pop	eax
	jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn

	flag1	db 0	
	colour	db 0
   	even
	a	dw 0
	b	dw 0
	c	dw 99
	d	dw 0
	e	dw 99
	f	dw 99
code    ENDS
END     start


