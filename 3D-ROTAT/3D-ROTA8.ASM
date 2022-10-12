;uses two screens. Slightly slower... but less flicker.



number_1        equ     15000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	push	02000h
	pop	es
	xor	di, di
        xor     eax, eax
	mov 	cx, 16000
	rep 	stosd

	push	0A000h
	pop	es

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

        xor     si, si
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
	push	eax

	mov	ax, 0a000h
	mov	es, ax
	mov	ax, 02000h
	mov	ds, ax
	mov	cx, 16000
        xor     si, si
        xor     di, di
	rep	movsd

	mov	ax, 02000h
	mov	es, ax
        xor     di, di
        xor     eax, eax
	mov 	cx, 16000
	rep 	stosd

        xor     si, si

	mov	ax, cs
	mov	ds, ax


	cmp	flag1, 0
	je	increase1
	cmp	flag1, 1
	je	decrease1
	jmp	@main31
increase1:
        inc     c1
        cmp     c1, 255
	jne	@main31	
	mov	flag1, 1
decrease1:
        dec     c1
        cmp     c1, 1
	jne	@main31
	mov	flag1, 0
@Main31:

	cmp	flag2, 0
	je	increase2
	cmp	flag2, 1
	je	decrease2
	jmp	@main32
increase2:
        inc     c2
        cmp     c2, 255
	jne	@main32	
	mov	flag2, 1
decrease2:
        dec     c2
        cmp     c2, 1
	jne	@main32
	mov	flag2, 0
@Main32:

	cmp	flag3, 0
	je	increase3
	cmp	flag3, 1
	je	decrease3
	jmp	@main33
increase3:
        inc     c3
        cmp     c3, 255
	jne	@main33	
	mov	flag3, 1
decrease3:
        dec     c3
        cmp     c3, 1
	jne	@main33
	mov	flag3, 0
@Main33:

	cmp	flag4, 0
	je	increase4
	cmp	flag4, 1
	je	decrease4
	jmp	@main34
increase4:
        inc     c4
        cmp     c4, 255
	jne	@main34	
	mov	flag4, 1
decrease4:
        dec     c4
        cmp     c4, 1
	jne	@main34
	mov	flag4, 0
@Main34:

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
;PUTPIXEL routine. (x,y) -> (bp, bx)
;------------------------------------
	push	eax

	mov	ax, 02000h
	mov	es, ax
        lea     edi, [ebx + ebx * 4]
	shl	edi, 6
	push	di
	add	di, bp
	mov     al, c1
	stosb

	pop	ax
	mov	dx, 320
	sub	dx, bp
	add	ax, dx
	mov	di, ax	
	mov     al, c4	
	stosb

	mov	dx, 199
	sub	dx, bx

        lea     edi, [edx + edx * 4]
	shl	edi, 6
	push	di
	add	di, bp
        mov     al, c3
        stosb

	pop	ax
	mov	dx, 320
	sub	dx, bp
	add	ax, dx
	mov	di, ax	
        mov     al, c2
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
	e	dw 160
	f	dw 199
	c1 	db 0
	c2 	db 64
	c3 	db 128
	c4 	db 192
	
	flag1	db 0
	flag2	db 0
	flag3	db 0
	flag4	db 0

   code    ENDS
END     start
