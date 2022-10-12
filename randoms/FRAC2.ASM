number_1 = 15000
colour	= 10

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

@main:	
	inc	count
	cmp	count, number_1
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
@k:     inc     dx
        mov     c, cx
        mov     d, dx
		


@waydownhere:
        mov     count, 0

	push	ax
        push    0A000h
        pop     es
        push    02000h
        pop     ds
	mov	cx, 07d00h
	sub	si, si
	sub	di, di
	repz	movsw
	sub	si, si

	push    ds
        pop     es
	sub	di, di
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
	lea     eax, [eax + eax * 2]
	add     eax, esi
;putpixel
 	push    ax                      ;ax = random number (global), so PUSH.
	mov	di, bx
	lea	edi, [edi+edi*4]
	shl	edi, 6
	add	di, bp
	mov     al, colour		;  CYAN = 3.   BLUE = 9.
	stosb	

	pop	ax


;-----------------------
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (0,0)                        	;dont add anything.            (5)(19)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	cmp     ax, -10923              ; -21845 for a freaky slide effect.
	jg      short @2_
	mov	cx, a
	mov	dx, b
	jmp	short @calc1 
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (320,0)							       (12)(31)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@2_:   	cmp     ax, 10923               ; 21845 for a freaky slide effect
 	jg      @next1
	mov	cx, c
	mov	dx, d
 	inc     si			;some amount to add to RAND number.
; 	add	bp, 320;		;add 320 to  X.
 	jmp     short @calc1
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (160,200)							       (8)(39)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@next1:
	mov	cx, e;	add	bp, 160			;add 160 to  X.
	mov	dx, f;	add	bx, 200			;add 200 to  Y.
@calc1: add	bp, cx
	shr     bp, 1	
	add	bx, dx
 	shr     bx, 1	  
       lea     eax, [eax + eax * 2]
	add     eax, esi

	cmp     ax, -10923
	jg	@next0

	mov	dx, f;	
	mov	cx, a	
	jmp     short @calc2
@next0: cmp     ax, 10923
 	jg      @next2
 	inc     si	
	mov	cx, c
	mov	dx, f
	jmp     short @calc2
@next2: mov	cx, e
	mov	dx, b 
@calc2: add	bp, cx	
	shr     bp, 1
	add	bx, dx
	shr     bx, 1
	push 	eax
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