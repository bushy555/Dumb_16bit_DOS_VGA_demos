code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
 	org     100h
	.386
start:

@0100:  push	0A000h
@0101:  pop	es
@0105:  mov	ax, 0013h
@0107:  INT     10h
					;from here down, is the background.
@0109:  MOV     DX, 03C8h
@010C:  MOV     AL, 01
@010E:  OUT     DX, AL
@010F:  INC     DX
@0110:  MOV     CX, 00FEh
@0113:  SUB     AL, AL
@0115:  OUT     DX, AL
@0116:  OUT     DX, AL
@0117:  MOV     AL, CL
@0119:  shr	al, 02
@011A:  out	dx, al
@011D:  LOOP    @0113
@011F:  MOV     AL, 3Fh
@0121:  OUT     DX, AL
@0122:  OUT     DX, AL
@0123:  OUT     DX, AL
run:
	xor	bx, bx
	xor	bp, bp
@main2:
	inc	bp
;	cmp	bp, 319
;	jne	@cont
;	sub	bp, bp
@cont:


	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main3
increase:
	inc     colour
	cmp	colour, 255
	jne	@main3	
	mov	flag1, 1

decrease:
	dec	colour
	cmp	colour, 1
	jne	@main3
	mov	flag1, 0

@main3:

    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2


@no_200:
	mov	ax, bp
	
	mov	si, 199;200
	xor	bx, bx
@SET:
	inc	bx
	lea	edi, [ebx+ebx*4]
	shl	edi, 6
	add	di, bp
	mov	al, colour
	mov	es:[di], al
	add	di, 64
	mov	es:[di], al
	add	di, 64
	mov	es:[di], al
	add	di, 64
	mov	es:[di], al
	add	di, 64
	mov	es:[di], al
	dec	si
	cmp	si, 0
	jne	@set

;	mov	ax, 320
;	mul	bx
 ;	add     ax, bp                  ;AX := AX + X
 ;	mov     di, ax                  ;final destination offset.
 ;	mov     al, colour           	;3=cyan 4=red 9=blue.
 ;	stosb				;plot the pixel.
;	sub	di, 2
;	stosb

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>					    (7)(69)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	in      al, 060h
 	cmp     al, 01
 	jne     @main2

@quit:	mov	ax, 0003
	int	10h
	ret

colour	db	0
flag1	db	0

code    ENDS
END     start

