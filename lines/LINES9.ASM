x_max	equ 255
y_max 	equ 180;100

ax_num	equ 01005
bx_num	equ 02005
number_1 	equ    1200;5;1000

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
@010C:  MOV     AL, 1
@010E:  OUT     DX, AL
@010F:  INC     DX
@0110:  MOV     CX, 0feh
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

	mov	a, 0
	mov	b, 199
	mov	c, 160
	mov	d, 99
	mov	e, 0
	mov	f, 199

	push	0A000h
	pop	es
	mov	e, 0
	mov	f, 0
	mov	count, 0
@main:
	inc	count
	cmp	count, number_1
	jl	@main2
@main1:
@0:	inc	e
	cmp	e, x_max
	jg	@1
	mov	flag2, 0
	jmp 	put
	jmp	@0
@1:	inc	f
	cmp	f, y_max
	jg	@2
	mov	flag2, 1
	jmp 	put
	jmp	@1
@2:	dec	e
	cmp	e, 0
	jl	@3
	mov	flag2, 2
	jmp 	put
	jmp	@2
@3:	dec	f
	cmp	f, 0
	jl	@4
	mov	flag2, 3
	jmp	put
	jmp	@3
@4:	jmp	@0

	inc	a
	inc	d
	dec	e
;	inc	count10
	mov	count, 0

put:	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main2
increase:
	inc     count10
	cmp	count10, 253
	jne	@main2	
	mov	flag1, 1

decrease:
	dec	count10
	cmp	count10, 1
	jne	@main2
	mov	flag1, 0


@main2:
;	inc	a
;	inc	d
;	dec	e

	mov	cx, e
	mov	dx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:	add    	bp, cx                   ; S := ((S + X[R]) DIV 2);
	shr    	bp, 1

	add    	bx, dx                   ; T := ((T + Y[R]) DIV 2);	
	shr     bx, 1                   	
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;CH = colour
;cl = maximum overall height as in Y
;ah-->  ? ... 3d?
;al = X??
;bl = (X) -\			;al = (X) \
;bh = (Y) -/point (X1,Y1)	;bl = (Y) /point (X2,Y2)
;DL = ?
;DH = ?
;BP = ?
;------------------------------------

pusha
;mov	cx, bp
mov	ch, count10

mov	bx, dx;bx_num
mov	al, dl;ax_num
mov	ah, cl
mov	cl, 0100;200

;mov	al, 0feh;20h;00;0fffeh;000;320
mov	bl, 160
mov	bh, 99
;mov	al, 00
;mov	ah, 00;199
;mov	dx, 00

@019E: 	SUB	AL,BL
	MOV	SI ,0001h
	JNB	@01A9
	NEG	AL
	NEG	SI
@01A9: 	SUB	AH,BH
	MOV	DI ,0100h
	JNB	@01B4
	NEG	AH
	NEG	DI
@01B4: 	movzx	bp, ah
@01B7:  XOR     AH, AH
@01B9:  CMP     AX, BP
@01BB:  JNB     @01C0
@01BD:  XCHG    BP, AX
@01BE:  XCHG    SI, DI
@01C0:  XOR     DX, DX
@01C2:  XCHG    AH, CH
@01C4:  OR      CL, CL
@01C6:  JNZ     @01CA
@01C8:  MOV     CL, AL
@01CA:  pusha
@01CB:  MOV     CL, BH
@01CD:  imul	si, cx, 0140h
@01D1:  xor	bh, bh
@01D3:  mov	es:[bx + si], ah
@01D6:  popa
@01D7:  SUB     DX, BP
@01D9:  JNB     @01E1
@01DB:  ADD     DL, AL
@01DD:  ADC     DH, CH
@01DF:  ADD     BX, DI
@01E1:  ADD     BX, SI
@01E3:  LOOPNZ  @01CA


;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	popa; 	eax
	je      @quit
	cmp	flag2, 0
	je	@0
	cmp	flag2, 1
	je	@1
	cmp	flag2, 2
	je	@2
	cmp	flag2, 3
	je	@3


@quit:
	mov    ax, 0003h
	int    10h
	int	20h
;	retn


	a	dw 0
	b	dw 0
	c	dw 0
	d	dw 0
	e	dw 0
	f	dw 0
	count	dw 0

flag1	db	0
flag2	db	0
count10	db	0
	
   code    ENDS
END     start

