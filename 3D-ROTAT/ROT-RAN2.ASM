;actually uses a proper RANGED random seed generator. Way below it is.


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

	mov     bx, 2
	call    RandomG
	mov     random1, dx
	mov     bx, 2
	call    RandomG
	mov     random2, dx
	mov     bx, 2
	call    RandomG
	mov     random3, dx
	mov     bx, 2
	call    RandomG
	mov     random4, dx
	mov     bx, 4
	call    RandomG
	cmp     dx, 1
	je      @@_0
	cmp     dx, 2
	je      @@_1
	cmp     dx, 3
	je      @@_2
	cmp     dx, 4
	je      @@_3
@@_0:   mov     cx, a
	mov     dx, b
	add     cx, random1
	add     dx, random2
	jmp     @@_cd
@@_1:   mov     cx, a
	mov     dx, b
	add     cx, random1
	sub     dx, random3
	jmp     @@_cd
@@_2:   mov     cx, a
	mov     dx, b
	sub     cx, random1
	add     dx, random4
	jmp     @@_cd
@@_3:   mov     cx, a
	mov     dx, b
	sub     cx, random2
	sub     dx, random3
@@_cd:  mov     a, cx
	mov     b, dx
      
	mov     bx, 2
	call    RandomG
	mov     random1, dx
	mov     bx, 2
	call    RandomG
	mov     random2, dx
	mov     bx, 2
	call    RandomG
	mov     random3, dx
	mov     bx, 2
	call    RandomG
	mov     random4, dx
	mov     bx, 4
	call    RandomG
	cmp     dx, 1
	je      @@_4
	cmp     dx, 2
	je      @@_5
	cmp     dx, 3
	je      @@_6
	cmp     dx, 4
	je      @@_7 
@@_4:   mov     cx, c
	mov     dx, d
	add     cx, random2
	sub     dx, random3
	jmp     @@_ef
@@_5:   mov     cx, c
	mov     dx, d
	sub     cx, random2
	add     dx, random4
	jmp     @@_ef
@@_6:   mov     cx, c
	mov     dx, d
	sub     cx, random2
	sub     dx, random1
	jmp     @@_ef
@@_7:   mov     cx, c
	mov     dx, d
	add     cx, random3
	add     dx, random4
@@_ef:  mov     c, cx
	mov     d, dx


	mov     bx, 2
	call    RandomG
	mov     random1, dx
	mov     bx, 2
	call    RandomG
	mov     random2, dx
	mov     bx, 2
	call    RandomG
	mov     random3, dx
	mov     bx, 2
	call    RandomG
	mov     random4, dx
	mov     bx, 4
	call    RandomG
	cmp     dx, 1
	je      @@_8
	cmp     dx, 2
	je      @@_9
	cmp     dx, 3
	je      @@_10
	cmp     dx, 4
	je      @@_11

@@_8:   mov     cx, e
	mov     dx, f
	add     cx, random3
	sub     dx, random4
	jmp     @@___
@@_9:   mov     cx, e
	mov     dx, f
	sub     cx, random3
	sub     dx, random1
	jmp     @@___
@@_10:  mov     cx, e
	mov     dx, f
	add     cx, random3
	add     dx, random2
	jmp     @@___
@@_11:  mov     cx, e
	mov     dx, f
	sub     cx, random4
	add     dx, random1
@@___:  mov     e, cx
	mov     f, dx


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
	mov     eax, random0
	lea     eax, [eax + eax * 2]
	mov     random0, eax
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
;        stosb
	pop     ax
	jmp     @main
@quit:
	mov    ax, 0003h
	int    10h
	retn

RANDOMG proc
	;in:    bx= range 0 - bx
	;out:   dx= random number 0 - bx

	
	mov     ax, ds:[rndseed]
	mov     cx, 09377
	mul     cx
	add     ax, 09439
	mov     ds:[rndseed], ax
	and     ax, 07fffh
	mov     dx, 0
	div     bx
	ret
RANDOMG Endp


even
	a       dw 80
	b       dw 80
	c       dw 140
	d       dw 80
	e       dw 110
	f       dw 140
	count   dw 0
	random0 dd 3
	random1 dw 0
	random2 dw 0
	random3 dw 0
	random4 dw 0
	rndseed dw 01972
	
comseg ends
end start
