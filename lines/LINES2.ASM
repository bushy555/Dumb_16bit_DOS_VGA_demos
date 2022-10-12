number_1 	equ	12000

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

	mov	count, 0
@main:
	inc	count
	cmp	count, number_1
	jl	@main2
@main1:
	cmp	e, 0	;(0,dec Y)
	jg	@a
	cmp	f, 1
	jl	@a
	dec	f
	inc	e
@a:
	cmp	f, 0	;(inc X, 0)
	jg	@b
	cmp	e, 318
	jg	@b
	inc	e
	inc	e
@b:
	cmp	e, 319	;(319, dec Y)
	jl	@c
	cmp	f, 198
	jg	@c
	inc	e
	inc	f
@c:
@d:
	cmp	a, 319	;(319, inc Y)
	jl	@e
	cmp	b, 198
	jg	@e
	dec	a
	inc	b
@e:
	cmp	b, 199	;(dec X, 199)
	jl	@f
	cmp	a, 1
	jl	@f
	dec	a
	dec	a
@f:
	cmp	a, 0	;(0, dec Y)
	jg	@g
	cmp	b, 1
	jl	@g
	dec	a
	dec	b
@g:
@h:	
	cmp	d, 199	;(dec X, 199)
	jl	@i
	cmp	c, 0
	jl	@i
	dec	c
	dec	d
@i:
	cmp	c, 0	;(0, dec Y)
	jg	@j
	cmp	d, 0
	jl	@j
	dec	d
	dec	d
@j:
	cmp	d, 0	;(inc X, 0)
	jg	@k
	cmp	c, 319
	jg	@k
	dec	d
	inc	c
@k:

@waydownhere:
	inc	a
	inc	d
	dec	e
	mov	count, 0

	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main2
increase:
	inc     count10
	cmp	count10, 255
	jne	@main2	
	mov	flag1, 1

decrease:
	dec	count10
	cmp	count10, 1
	jne	@main2
	mov	flag1, 0


@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea	eax, [eax + eax * 2]
	add     eax, esi
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	mov	cx, a
	mov	dx, b
	add     si, 3			; Add a bit for the random value.
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	mov	cx, c
	mov	dx, d
	jmp     short @calc
@3:
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
;cl = Y
;------------------------------------

pusha

mov	cx, bp
mov	ch, al
;mov	cl, ah

mov	ah, 5;50;10;00;0feh
mov	cl, 0200

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
	jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn


	a	dw 0
	b	dw 0
	c	dw 0
	d	dw 0
	e	dw 0
	f	dw 0
	count	dw 0

flag1	db	0
count10	db	0
	
   code    ENDS
END     start

