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


run:	mov	i, 0
	mov	j, 0
	mov	w, 0
	mov	a, 0
	mov	b, 0
	mov	c, 0
	mov	d, 0
	mov	e, 0
	mov	f, 0
	mov	color, 0	
@main:	cmp	w, 1
	jne	@no_quit
	jmp	run
@quit:	mov	ax, 0003
	int	10h
	int	20h
@no_quit:
	cmp	i, 62
	jl	@no_i
	mov	i, 0
	inc	w
@no_i:	
	cmp	j, 62
	jl	@no_j
	mov	j, 0
	inc	i
@no_j:	inc	j
	mov	ax, i
	mov	k, ax
	mov	ax, j
	add	k, ax
	add	color,4
	cmp	color, 254
	jne	@no_col
	mov	color, 1
@no_col:
;	add	color, 16

	mov	bp, i
	mov	bx, k
	call	@set
	mov	bp, k
	mov	bx, i
	call	@set
		mov	a, 120
		mov	ax, i
		sub	a, ax
		mov	c, 120
		mov	ax, k
		sub	c, ax
	mov	bp, a
	mov	bx, c
	call	@set			;line	11
	mov	bp, c
	mov	bx, a
	call	@set			;line 	12
	mov	bp, k
	mov	bx, a
	call	@set			;line	13
	mov	bp, a
	mov	bx, k
	call	@set			;line	14
	mov	bp, i
	mov	bx, c
	call	@set			;line	15
	mov	bp, c
	mov	bx, i
	call	@set			;line	16
	mov	bp, i
	add	bp, 0120
	mov	b, bp
	mov	bx, k
	call	@set			;line	17
	mov	bp, k
	add	bp, 0120
	mov	d, bp
	mov	bx, i
	call	@set			;line	18
	mov	e, 240
	mov	ax, i
	sub	e, ax
	mov	bp, e
	mov	bx, c
	call	@set			;line	19
	mov	f, 240
	mov	ax, k
	sub	f, ax
	mov	bp, f
	mov	bx, a
	call	@set			;line	20
	mov	bp, d
	mov	bx, a
	call	@set			;line	21
	mov	bp, e
	mov	bx, k
	call	@set			;line	22
	mov	bp, b
	mov	bx, c
	call	@set			;line	23
	mov	bp, f
	mov	bx, i
	call	@set			;line	24

	jmp	@main
	
@SET:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;	mov	bp, x
;	mov	bx, y
 	mov     ax, 320			;ax := 320.  Width of screen.
 	mul     bx                      ;AX := 320 * Y
 	add     ax, bp                  ;AX := AX + X
 	mov     di, ax                  ;final destination offset.
 	mov     al, color           	;3=cyan 4=red 9=blue.
 	stosb				;plot the pixel.
	sub	di, 2
	stosb
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>					    (7)(69)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	in      al, 060h
 	cmp     al, 01
 	je     	@quit
	ret

w	dw 0
i	dw 0
J	dw 0
k	dw 0
a	dw 0
b	dw 0
c	dw 0
d	dw 0
e	dw 0
f	dw 0
color	db 0
code    ENDS
END     start
