text equ 0b800h

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	.8086

	ORG     100h

start:
	mov     ax, text
        mov     es, ax
;	xor	ax,ax
        mov     z, bx
        mov     cx, 000b4h

@@loopy2:
        push    cx
        call 	middle_bit;

        mov  	ch, 20
@@loopy4:
        loop 	@@loopy4
        inc 	z
        pop 	cx
        loop   	@@loopy2
@@finish:
	int	20h


middle_bit:
	cmp     z, 160
	jl      @@here1
	mov	al, 134
	jmp 	@@loop20
@@here1:
	cmp  	z, 134
	jl   	@@here2
	mov	al, 110
	jmp 	@@loop20
@@here2:
	cmp  	z, 110
	jl   	@@here3
	mov	al, 84
	jmp 	@@loop20
@@here3:
	cmp  	z, 84
	jl  	@@here4
	mov	al, 60
	jmp 	@@loop20
@@here4:
	cmp  	z, 60
	jl   	@@here5
	mov	al, 34
	jmp 	@@loop20
@@here5:
	cmp  	z, 34
	jl   	@@here6
	mov	al, 10
	jmp 	@@loop20
@@here6:
	xor 	ax, ax

@@loop20:    
	mov 	a, ax
        cmp     ax, z
        jnl     @@exiting
@@here:
	push	ax
	xor	cx, cx
        mov     cl, 25
        mov     b, cx
@@loopy3:
  	mov   	ax, b
	dec	ax
	dec	ax
	mov	b, ax

	call	@@1

  	xor	ax, ax
  	mov   	al,  es:[di]
	push	ax
        inc 	b
   	mov  	ax, b

	call	@@1

	pop	ax
   	mov  	es:[di], al
        loop 	@@loopy3
	pop	ax
	inc 	ax
	inc 	ax
        jmp 	@@loop20
@@exiting:

	ret

@@1:
   	mov  	bx, 0a0h
   	mul  	bx
   	add  	ax, a
	mov  	di, ax
	ret

a	dw	0
b	dw	0
z	dw	0


code    ENDS

END     start
