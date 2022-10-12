;uses two screens. Slightly slower... but less flicker.



number_1        equ     32500

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start:  mov     al, 013h
	int     10h

        push    08000h
        pop     es
@main:
	inc	si
	cmp	si, number_1
	jl	@main2
@main1:
        mov     cx, word ptr e
        mov     dx, word ptr f

        test    cx, cx
	jg	@a
        dec     dx
        inc     cx
@a:
        test    dx, dx
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
        mov     word ptr e, cx
        mov     word ptr f, dx
@d:
        mov     cx, word ptr a
        mov     dx, word ptr b
        cmp     cx, 319  ;(319, inc Y)
	jl	@e
        dec     cx
        inc     dx
@e:
        cmp     dx, 199  ;(dec X, 199)
	jl	@f
        dec     cx
        dec     cx
@f:
        test    cx, cx
	jg	@g
        test    dx, dx
        jle      @g
        dec     cx
        dec     dx
@g:     inc     cx
        mov     word ptr a, cx
        mov     word ptr b, dx
@h:	
        mov     cx, word ptr c
        mov     dx, word ptr d

        cmp     dx, 199  ;(dec X, 199)
	jl	@i
        dec     cx
        dec     dx
@i:
        test    cx, cx
	jg	@j
        dec     dx
        dec     dx
@j:
        test    dx, dx
	jg	@k
        cmp     cx, 319
	jg	@k
        dec     dx
        inc     cx
@k:
        inc     dx
        mov     word ptr c, cx
        mov     word ptr d, dx
		

@waydownhere:
        push    es
        pop     ds
        push    0a000h
        pop     es

        mov     cx, 0ffffh
        xor     si, si
        xor     di, di
        push    cx
        rep     movsw

        pop     cx
        push    ds
        pop     es
        push    ax
        xor     ax, ax
        rep     stosw

        push    cs
        pop     ds

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
        dec     ax
	pop 	ax
        je      @quit

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        imul    ax, 3
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2

        db      081h, 0c5h
a       db      000h, 000h
        db      081h, 0c3h
b       db      000h, 000h
        jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
c       equ     $ + 2
        add     bp, 319
        db      081h, 0c3h
d       db      000h, 000h
        jmp     short @calc
@3:
e       equ     $+2
        add     bp, 160
f       equ     $+2
        add     bx, 199
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:	
	shr    	bp, 1
	shr     bx, 1                   	
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
        imul    di, bx, 320
        mov     byte ptr es:[di+bp], 9
        mov     dx, 319
	sub	dx, bp
        add     di, dx
        mov     byte ptr es:[di], 4
	jmp     @main
@quit:
        mov    ax, 0003h
	int    10h
	retn

   code    ENDS
END     start
