number_1        equ     3500
_width          equ     70
_2ndline        equ     22186
_3rdline        equ     22186

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	push    02000h
	pop     es
	xor     di, di
	sub     ax, ax
	mov     cx, 16000
	rep     stosd

	mov     ax, 0a000h
	mov     es, ax

	mov     ax, 013h
	int     10h
	sub	si, si
@main:
	inc     si
	cmp     si, number_1
	jl      @main2
@main1:
	mov     cx, e
	mov     dx, f
	cmp     cx, 0   ;(0,dec Y)
	jg      @a
	cmp     dx, 1
	jl      @a
	dec     dx
	inc     cx
@a:
	cmp     dx, 0   ;(inc X, 0)
	jg      @b
	cmp     cx, _width
	jg      @b
	inc     cx
	inc     cx
@b:
	cmp     cx, _width  ;(319, dec Y)
	jl      @c
	cmp     dx, _width
	jg      @c
	inc     cx
	inc     dx
@c:
@d:     dec     cx
	mov     e, cx
	mov     f, dx
	mov     cx, a
	mov     dx, b
	cmp     cx, _width  ;(319, inc Y)
	jl      @e
	cmp     dx, _width
	jg      @e
	dec     cx
	inc     dx
@e:
	cmp     dx, _width  ;(dec X, 199)
	jl      @f
	cmp     cx, 1
	jl      @f
	dec     cx
	dec     cx
@f:
	cmp     cx, 0   ;(0, dec Y)
	jg      @g
	cmp     dx, 1
	jl      @g
	dec     cx
	dec     dx
@g:
@h:     inc     cx
	mov     a, cx
	mov     b, dx
	mov     cx, c
	mov     dx, d
	cmp     dx, _width  ;(dec X, 199)
	jl      @i
	cmp     cx, 0
	jl      @i
	dec     cx
	dec     dx
@i:
	cmp     cx, 0   ;(0, dec Y)
	jg      @j
	cmp     dx, 0
	jl      @j
	dec     dx
	dec     dx
@j:
	cmp     dx, 0   ;(inc X, 0)
	jg      @k
	cmp     cx, _width
	jg      @k
	dec     dx
	inc     cx
@k:     inc     dx
	mov     c, cx
	mov     d, dx
		

@waydownhere:
	push    eax

	mov	ax, 0a000h
	mov	es, ax
	mov	ax, 02000h
	mov	ds, ax
	mov     cx, 16000
	sub     si, si
	sub     di, di
	rep     movsd

	mov	ax, 02000h
	mov	es, ax
	sub     di, di
	sub     eax, eax
	mov     cx, 16000
	rep     stosd

	mov	ax, cs
	mov	ds, ax

	sub	si, si
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop     eax
	je	@quit

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea     eax, [eax + eax * 2]
;	add     eax, esi
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
        add     bp, a
        add     bx, b
 ;       add     si, 3                   ; Add a bit for the random value.
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
        add     bp, c
        add     bx, d
	jmp     short @calc
@3:
        add     bp, e
        add     bx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:                     ; S := ((S + X[R]) DIV 2);
	shr     bp, 1
                           ; T := ((T + Y[R]) DIV 2);
	shr     bx, 1                           
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
	push    eax                     ;ax = random number (global), so PUSH.

	mov	ax, 02000h
	mov	es, ax
	lea     edi, [ebx+ebx*4]
	shl     edi, 6
	add     di, bp
	mov     al, 09                  ;  CYAN = 3.   BLUE = 9.
	stosb   

	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _2ndline         ;(32000 - _width - _width)
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _3rdline         ;(32000 - _width - _width)
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb

	mov     ax, _width
	sub     ax, bx

	mov     cx, _width
	sub     cx, bp

	lea     edi, [eax+eax*4]
	shl     edi, 6
	add     di, cx
	mov     al, 04          ;  CYAN = 3.   BLUE = 9.
	stosb   

	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _2ndline
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _3rdline
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	pop	eax
	jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn

	a       dw 0
	b       dw 0
	c       dw _width
	d       dw 0
	e       dw _width
	f       dw _width
	count   dw 0
	
   code    ENDS
END     start


