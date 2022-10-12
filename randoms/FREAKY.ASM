code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov     di, offset array
	mov     cx, 320
	xor     ax, ax
	rep     stosw

	push	0a000h
	pop	es

	mov  al, 0013h
	int  10h
@main:

@try_again:
	mov     bx, [rand]
	lea	ebx, [ebx + ebx * 2]		;(imul ax, 03)
	add     bx, si
;	mov     [rand], bx
	mov     rand, bx
	cmp     bx, 0
	jl      @try_again
	cmp    	bx, 321
	jg      @try_again

;	mov     bx, ax
        mov     ax, [array + bx]          ;inc word ptr array+bx
	inc     ax
	mov     array + bx, ax


	inc     si
;	mov     dx, ax
	push    ax

	mov     dx, 320         ;dx = Y, bx = X
	inc     si
	mul     ax
	add     ax, bx
	mov     di, ax
	pop     ax
;	mov     ax, dx
	stosb

	sub     di, 2
	stosb

	in      al, 060h
	cmp     al, 01
	jne     @main
@quit:
	mov    ax, 0003h
	int    10h
	retn

rand    dw      1
;b       db      0
;c       db      0
array   dw 320 dup (?)

   code    ENDS
END     start
