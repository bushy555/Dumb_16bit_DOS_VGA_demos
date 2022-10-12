;a
;b
;cx
;dx
;e
;f

number_1	equ	15000
code segment para public
assume cs:code, ds:code, es:code, ss:code
        .386        
        org     100h
start:
        mov     ax, 013h
        int     10h
        mov     ax, 0a000h
        mov     es, ax
	
	mov	cx, 319
	sub	dx, dx
@main:  
        inc     si
        cmp     si, number_1
        jl      @rand
        
        push    ax
        push    bx
        push    si

        mov     ax, a
        mov     bx, b
        mov     si, e
        mov     di, f

        cmp     dx, di
        jne     @a
        dec     cx
        dec     dx

@a:     cmp     ax, si
        jl     @b
        dec     dx
        dec     cx
        dec     cx
@b:
        inc     ax
        inc     ax
        inc     bx
        dec     cx
        inc     dx
        inc     dx
        dec     si
        dec     di

        mov     f, di
        mov     e, si
        mov     b, bx
        mov     a, ax

        pop     si
        pop     bx
        pop     ax

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
	sub	si, si


@Rand: lea	eax, [eax+eax*2]
        add     ax, si

        cmp     ax, -10432
        jg      @other1
        add     bp, a
        add     bx, b
        jmp     short @calc
@other1:
        cmp     ax, 10432
        jl      @other
        add     bp, cx
        add     bx, dx
        jmp     short @calc
@other: 
        add     bx, f
        add     bp, e

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
e dw 159
f dw 200

code ends
end start

