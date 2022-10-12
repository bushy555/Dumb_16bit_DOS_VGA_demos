;uses two screens. Slightly slower... but less flicker.
;358 bytes.

number_1        equ     7000
comseg segment
assume cs:comseg,ds:comseg
org 100h
.386
start:
	push    02000h
	pop     es
	xor     di, di
	xor     eax, eax
	mov     cx, 16000
	rep     stosd

	push    0A000h
	pop     es

	mov     ax, 013h
	int     10h

	xor     si, si
@main:
	inc     si
	cmp     si, number_1
	jl      @main2
@main1:
	mov     cx, e
	mov     dx, f

	cmp     cx, 0    ;(0,dec Y)
	jg      @a
	dec     dx
	inc     cx
@a:
	cmp     dx, 0    ;(inc X, 0)
	jg      @c;b
	cmp     cx, 318
	jg      @c
	inc     cx
	inc     cx
@b:
	cmp     cx, 319  ;(319, dec Y)
	jl      @c
	cmp     dx, 198
	jg      @c
	inc     cx
	inc     dx
@c:     dec     cx
	mov     e, cx
	mov     f, dx
@d:
	mov     cx, a
	mov     dx, b
	cmp     cx, 319  ;(319, inc Y)
	jl      @e
	dec     cx
	inc     dx
@e:
	cmp     dx, 199  ;(dec X, 199)
	jl      @f
	cmp     cx, 1
	jl      @g
	dec     cx
	dec     cx
@f:
	cmp     cx, 0    ;(0, dec Y)
	jg      @g
	cmp     dx, 1
	jl      @g
	dec     cx
	dec     dx
@g:     inc     cx
	mov     a, cx
	mov     b, dx
@h:     
	mov     cx, c
	mov     dx, d

	cmp     dx, 199  ;(dec X, 199)
	jl      @i
	dec     cx
	dec     dx
@i:
	cmp     cx, 0    ;(0, dec Y)
	jg      @j
	cmp     dx, 0
	jl      @k
	dec     dx
	dec     dx
@j:
	cmp     dx, 0    ;(inc X, 0)
	jg      @k
	cmp     cx, 319
	jg      @k
	dec     dx
	inc     cx
@k:
	inc     dx
	mov     c, cx
	mov     d, dx
		

@waydownhere:
	push    ax

	mov     ax, 0a000h
	mov     es, ax
	mov     ax, 02000h
	mov     ds, ax
	mov     cx, 16000
	xor     si, si
	xor     di, di
	rep     movsd

	mov     ax, 02000h
	mov     es, ax
	xor     di, di
	xor     eax, eax
	mov     cx, 16000
	rep     stosd

	xor     si, si

	mov     ax, cs
	mov     ds, ax

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop     ax
	je      @quit;main2

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea     eax, [eax + eax * 2]
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	add     bp, a
	add     bx, b
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
@calc:  
	shr     bp, 1
	shr     bx, 1                           
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
	push    ax                      ;ax = random number (global), so PUSH.

	mov     ax, 02000h
	mov     es, ax
	lea     edi, [ebx+ebx*4]
	shl     edi, 6
	push    di
	add     di, bp
	mov     al, 09                  ;  CYAN = 3.   BLUE = 9.
	stosb   

	pop     ax
	mov     dx, 319
	sub     dx, bp
	add     ax, dx
	mov     di, ax
	mov     al, 9                   ;  RED 
	stosb
	pop     ax
	jmp     @main
@quit:
	mov    ax, 0003h
	int    10h
	retn
even
	a       dw 0
	b       dw 0
	c       dw 319
	d       dw 0
	e       dw 160
	f       dw 199
	count   dw 0

comseg ends
end start
