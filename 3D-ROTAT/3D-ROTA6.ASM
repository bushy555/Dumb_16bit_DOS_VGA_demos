; Uses double buffering... two (split) screens...

;and this version also uses Lookup tables instead of (320*Y)+X



number_1        equ     15000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	sub	bx, bx
	sub	bp, bp

        mov     cx, 200				;set up Mr Lookup Table
@@@1:   mov     word ptr Ytable[bp], bx
        add     bx, 320
        inc     bp
        inc     bp
	loop	@@@1		



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
;	push	ax

;	push	0a000h
;	pop	es
;	push	02000h
;	pop	ds
;	mov	cx, 07d00h
;	sub	si, si
;	sub	di, di
;	rep	movsw

;	push    ds
;        pop     es
;	sub	di, di
;	sub	ax, ax
;	mov 	cx, 07d00h
;	rep 	stosw
;	pop	ax

	sub	si, si

	push	cs
	pop	ds


	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main2
increase:
	inc     colour
	cmp	colour, 255
	jne	@main2	
	mov	flag1, 1

decrease:
	dec	colour
	cmp	colour,  1
	jne	@main2
	mov	flag1, 0

@main2:
;????????????????????????????????????????????????????????????????????????????
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;????????????????????????????????????????????????????????????????????????????
	lea	eax, [eax + eax * 2]
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	add	bp, a
	add	bx, b
	add	bx, b
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	add	bp, c
	add	bx, d
	add	bx, d
	jmp     short @calc
@3:
	add	bp, e
	add	bx, f
	add	bx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:	
	shr    	bp, 1
	shr     bx, 1                   	
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
	push 	eax			;ax = random number (global), so PUSH.

;	push	02000h
;	pop	es

        mov     di, word ptr Ytable[bx]
;	lea	edi, [ebx+ebx*4]
;	shl	edi, 6
	push	di
	add	di, bp
	mov     al, colour;010			;  CYAN = 3.   BLUE = 9.
	stosb	

	pop	ax
	mov	dx, 319
	sub	dx, bp
	add	ax, dx
	mov	di, ax
	mov     al, colour;,3			;  RED 
	stosb
;????????????????????????????????????????????????????????????????????????????
;READ keyboard for <ESC>
;????????????????????????????????????????????????????????????????????????????
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
	colour	db 0
	flag1  	db 0

Ytable   dw 400 dup (?)
	
   code    ENDS
END     start



