;TRY:
;        lea     eax, [eax+eax*2]
;        add     ax, bx.

;Sort of looks coolish. (More like that it is pre-calculated stuff)



number_1        equ 21000

code segment para public
assume cs:code, ds:code, es:code, ss:code
        .386        
        org     100h
start:
        mov     al, 013h
        int     10h
        mov     ax, 0a000h
        mov     es, ax

	sub	cx, cx
        mov     dx, 319

@main:  
        push    cs
        pop     ds

        inc     si
        cmp     si, number_1
        jl      @rand

	cmp	flag, 1
	je	decrease
increase:
	inc     cx
	dec	dx
	cmp	cx, 319
	jne	@main2	
	mov	flag, 1

decrease:
	dec	cx
	inc	dx
	cmp	cx, 0
	jne	@main2
	mov	flag, 0

@main2:
	push	02000h
	pop	ds
	push	0a000h
	pop	es

	push	ax
	push	cx
	mov	cx, 07d00h
	push	cx
	sub	di, di
	sub	si, si
	rep	movsw
	
	push	ds
	pop	es

	pop	cx
	sub	ax, ax
	sub	di, di
        rep     stosw
	pop	cx
        pop     ax
        push	cs
	pop	ds
	sub	si, si
	

@rand:
        lea     eax, [eax+eax*2]
       add     ax, si

        cmp     ax, -10432
        jg      @1
        add     bp, cx
        add     bx, b
        jmp     short @calc
@1:     cmp     ax, 10432
        jl      @2
;	inc     si
        add     bp, dx
        add     bx, d
        jmp     short @calc
@2: 
        add     bx, f
        add     bp, e

@calc:  shr     bp, 1
        shr     bx, 1

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. Slow... but small!. (BP �> X) (BX �> Y).           (19)(62)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	push	02000h
	pop	es
        push    ax


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


b dw 199
d dw 199
e dw 159
f dw 0
count dw 0
flag	db	0

code ends
end start

