number_1	equ	7000


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	.386
	locals
	org     100h
start:
	mov     ax, 0b800h
        mov     es, ax
	sub	bp, bp	
        mov     cx, 000b4h

@@loopy2:
        push    cx
        call 	middle_bit;
        inc 	bp
        pop 	cx
        loop   	@@loopy2
@@finish:
	jmp	@rot


middle_bit:
        mov     dx,3dah
@@vw1:  in      al,dx  
        and     al,08h 
        jnz     @@vw1  
@@vw2:  in      al,dx  
        and     al,08h 
        jz      @@vw2  
	xor 	ax, ax
@@loop20:    
	mov 	si, ax
        cmp     ax, bp
        jnl     @@exiting
@@here:
	push	ax
	sub	cx, cx
        mov     cl, 25
        mov     bx, cx
@@loopy3:
	dec	bx
	dec	bx
	mov	ax, bx

	call	@@1

  	sub	ax, ax
  	mov   	al,  es:[di]
	push	ax
        inc 	bx
   	mov  	ax, bx

	call	@@1

	pop	ax
   	mov  	es:[di], al

        loop 	@@loopy3
	pop	ax
	inc 	ax
	inc 	ax
        jmp 	@@loop20
@@exiting:
	ret

@@1:
   	mov  	dx, 0a0h
   	mul  	dx
   	add  	ax, si
	mov  	di, ax
	ret


@rot:	push	02000h
	pop	es
	xor	di, di
	sub	ax, ax
	mov 	cx, 07d00h
	rep 	stosw


	push	0a000h
	pop	es

	mov     ax, 013h
	int     10h

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
	xor	si, si
	xor	di, di
	rep	movsw

	push    ds
        pop     es
	xor	di, di
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

	lea	eax, [eax + eax * 2]
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
	mov	count1, 028h
	mov	count2, 00
	jmp 	@@1
@@0:	sub	count1, 1
	sbb	count2, 0
@@1:	call	retrace
	mov	count3, 1
	mov	count4, 0
	jmp	@@3
@@2:	add	count3, 1
	adc	count4, 0
@@3:	mov	al, count3
	mov	dx, 03c8h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	cmp	count4, 0
	jnz	@@2
	cmp	count3, 010h
	jnz	@@2
	cmp	count2, 0
	jnz	@@0
	cmp	count1, 1
	jnz	@@0

	mov	ax, 3
	int	10h
	int	20h

retrace:
@L1:	mov	dx, 03dah
	in	al, dx
	and	al, 08
	or	al, al
	jnz	@L1
@L2:	mov	dx, 03dah
	in	al, dx
	and	al, 08
	cmp	al, 08
	jnz	@L2
	ret

	a	dw 0
	b	dw 0
	c	dw 319
	d	dw 0
	e	dw 160
	f	dw 199
	count	dw 0
	

count1	db	0
count2	db	0
count3	db	0
count4	db	0


CODE     ENDS
         END   START