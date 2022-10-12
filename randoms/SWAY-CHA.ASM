number_1	equ	5000

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
        inc     di
        cmp     di, number_1
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

	push	di
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
	pop	di
        push	cs
	pop	ds
	sub	di, di;	mov     count, 0
	

@rand:  
	lea	eax, [eax+eax*2]
	add	ax, si

        cmp     ax, -10923
        jg      @other1
        add     bp, cx
        add     bx, b
        jmp     short @calc
@other1:
        cmp     ax, 10923
        jl      @other
	inc     si
        add     bp, dx
        add     bx, d
        jmp     short @calc
@other: 
        add     bx, f
        add     bp, e

@calc:  shr     bp, 1
        shr     bx, 1

	push	02000h
	pop	es
        push    ax
	push	di

	lea	edi, [ebx+ebx*4]
	shl	di, 6
	add	di, bp
	mov	al, 9
	stosb

;    	mov    	al, 4
;     	sub    	di, 8
;      	stosb
	push	cs
	pop	ds
	pop	di

        in      al, 060h
        cmp     al, 1
        pop     ax
        jne     @main

        mov     ax, 0003
        int     10h
        retn

even
	b 	dw 	199
	d 	dw 	199
	e 	dw 	159
	f 	dw 	0
	count 	dw 	?
	flag	db	0

code ends
end start
