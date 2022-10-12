number_1        equ     5000
code segment para public
assume cs:code, ds:code, es:code, ss:code
        .386        
        org     100h
start:
        mov     ax, 013h
        int     10h
        mov     ax, 0a000h
        mov     es, ax

@begin: 
        sub     di, di
        mov     a, di
        mov     b, di
        mov     d, di
        mov     c, 319
        mov     e, 200
        mov     f, 159
        sub     si, si
@main:  
        inc     si
        cmp     si, number_1
        jl      @rand

push	ax
push	bx
push	cx
push	dx
push	si
push	di

mov	ax, a
mov	bx, b
mov	cx, c
mov	dx, d
mov	si, e
mov	di, f



        cmp     ax, 319
        jg      @a
        inc     bx
@a:
        cmp     bx, 199 
        jl      @b
        dec     bx        
@b:
@c:
        cmp     dx, 199
        jg      @d
        dec     cx
@d:     cmp     si, 5
        jg      @e
        inc     si
        inc     di
@e:     cmp     di, 5
        jl      @f
        inc     si
@f:     cmp     di, 199
        jl      @g
        dec     di
@g:     cmp     si, 199
        jl      @h
        dec     si
@h:     cmp     di, 5
        jg      @i
        inc     di
        inc     di
        dec     si
@i:     cmp     cx, 5
        jg      @j
        cmp     dx, 5
        jg      @j
        dec     si
        inc     di
        inc     di
        inc     cx
        dec     ax
        dec     bx
@j:     cmp     di, 319
        jl      @j2
        dec     di
@j2:    cmp     di, 170
        jl      @k
        dec     ax
@k:     cmp     ax, 161
        jne     @l                        
        cmp     bx, 197
        jl     @l
	mov	flag1, 1
@l:        



        inc     ax
        dec     si
        dec     di 

mov	f, di
mov	e, si
mov	d, dx
mov	c, cx
mov	b, bx
mov	a, ax

pop	di
pop	si
pop	dx
pop	cx
pop	bx
pop	ax

	cmp	flag1, 1
	je	@begin

@main2: 
	push	0a000h
	pop	es
	push	02000h
	pop	ds
	push    ax
push	cx
        mov     cx, 07d00h
	push	cx
	sub	di, di
	sub	si, si
	rep	movsw
	push	ds
	pop	es
	pop	cx
	sub     ax,ax       
        sub     di,di
        rep     stosw
	pop	cx
        pop     ax
	push	cs
	pop	ds
        sub     si, si


@rand:
	 lea	eax, [eax+eax*2]
         add     ax, cx

        cmp     ax, -10432
        jg      @1
        add     bp, a
        add     bx, b
        jmp     short @calc
@1:
        cmp     ax, 10432
        jl      @2
;        inc     si        
        add     bp, c
        add     bx, d
        jmp     short @calc
@2: 
        add     bx, e
        add     bp, f

@calc:  shr     bp, 1
        shr     bx, 1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. Slow... but small!. (BP �> X) (BX �> Y).           (19)(62)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	push    ax                      ;ax = random number (global), so PUSH.
	lea	edi, [ebx + ebx * 4]
	shl	di, 6
	add	di, bp
	mov     al, 9            	;3=cyan 4=red 9=blue.
	stosb

        mov    al, 4
        sub    di, 17
        stosb

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>					    (7)(69)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        in      al, 060h
        cmp     al, 1
        pop     ax
        jne     @main

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@quit:					;			     (6)(75)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        mov     ax, 0003
        int     10h
        retn

a dw 0
b dw 0
c dw 0
d dw 0
e dw 0
f dw 0
flag1	db 0

code ends
end start

