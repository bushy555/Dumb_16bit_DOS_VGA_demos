
number_1        equ     20000

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
@010C:  MOV     AL, 0;1;0feh;0a0h;0feh;0ah;01
@010E:  OUT     DX, AL
@010F:  INC     DX
@0110:  MOV     CX, 00Ffh
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
@0124:  XOR     BX, BX
@0126:  XOR     DX, DX
@0128:  MOV     BP, 0FFFFh
@012B:  MOV     SI, 0FEC0h
@012E:  OR      BX, BX
@0130:  JZ      @0138
@0132:  CMP     BX, 013Fh
@0136:  JB      @013A
@0138:  NEG     BP
@013A:  OR      DX, DX
@013C:  JZ      @0147
@013E:  CMP     DX, 0F8C0h
@0142:  JB      @0149
@0144:  JMP     @0100		;was	@01d4
@0147:  NEG     SI
@0149:  CMP     DX, 0D480h
@014D:  JNZ     @015E
@014F:  MOV     AX, BX
;@0151:  SUB     AX, count1		;;;;
@0155:  JB      @015E
@0157:  CMP     AX, 0014h
@015A:  JG      @015E
@015C:  NEG     SI
@015E:  PUSH    DX
@015F:  MOV     DX, 000C8h
@0162:  MOV     AX, 0FEFEh
@0165:  SUB     DI, DI
@0167:  MOV     CL, 0A0h
;@0169:  REPZ    STOSW
@016B:  SUB     AX, 0101h
@016E:  DEC     DX
@016F:  JNZ     @0167
@0171:  POP     DX			;to around about here. (shaded background)


dstart: 
	mov     a, 0
	mov     b, 0
	mov     c, 319
	mov     d, 0
	mov     e, 160
	mov     f, 199

	push    0a000h
	pop     es

;	mov     ax, 013h
;	int     10h

	mov     count, 0
@main:
	inc     count
	cmp     count, number_1
	jl      @main2  ;g      @main1
;       jmp     @main2
@main1:
	cmp     e, 0    ;(0,dec Y)
	jg      @a
	cmp     f, 1
	jl      @a
	dec     f
	inc     e
@a:
	cmp     f, 0    ;(inc X, 0)
	jg      @b
	cmp     e, 318
	jg      @b
	inc     e
	inc     e
@b:
	cmp     e, 319  ;(319, dec Y)
	jl      @c
	cmp     f, 198
	jg      @c
	inc     e
	inc     f
@c:
@d:
	cmp     a, 319  ;(319, inc Y)
	jl      @e
	cmp     b, 198
	jg      @e
	dec     a
	inc     b
@e:
	cmp     b, 199  ;(dec X, 199)
	jl      @f
	cmp     a, 1
	jl      @f
	dec     a
	dec     a
@f:
	cmp     a, 0    ;(0, dec Y)
	jg      @g
	cmp     b, 1
	jl      @g
	dec     a
	dec     b
@g:
@h:     
	cmp     d, 199  ;(dec X, 199)
	jl      @i
	cmp     c, 0
	jl      @i
	dec     c
	dec     d
@i:
	cmp     c, 0    ;(0, dec Y)
	jg      @j
	cmp     d, 0
	jl      @j
	dec     d
	dec     d
@j:
	cmp     d, 0    ;(inc X, 0)
	jg      @k
	cmp     c, 319
	jg      @k
	dec     d
	inc     c
@k:
	inc     a
	inc     d
	dec     e
	mov     count, 0
;	sub     di, di
;	push    ax
;	mov     ax, 0000
;	mov     cx, 8000h
;	rep     stosw
;	pop     ax
	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main2
increase:
	inc     count10
	cmp	count10, 254
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

	lea     eax, [eax + eax * 2]
	add     ax, si

;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	mov     cx, a
	mov     dx, b
	add     si, 3                   ; Add a bit for the random value.
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	mov     cx, c
	mov     dx, d
	jmp     short @calc
@3:
	mov     cx, e
	mov     dx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:  add     bp, cx                   ; S := ((S + X[R]) DIV 2);
	shr     bp, 1

	add     bx, dx                   ; T := ((T + Y[R]) DIV 2);     
	shr     bx, 1                           
;------------------------------------
;PUTPIXEL routine. (x,y) -> (bp, bx)
;------------------------------------
	push    ax                      ;ax = random number (global), so PUSH.

	mov     di, bx
	lea     edi, [edi + edi * 4]
	shl     edi, 6
	add     di, bp
	mov     al, count10
	stosb
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop     ax
	je      @quit
	jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn

distance equ    6

	a       dw 0
	b       dw 0
	c       dw 0
	d       dw 0
	e       dw 0
	f       dw 0
	count   dw 0
	count10 db 0        
flag1	db	0

   code    ENDS
END     start

number_1 	equ	2000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov	a, 0
	mov	b, 0
	mov	c, 319
	mov	d, 0
	mov	e, 160
	mov	f, 199

	push	0A000h
	pop	es

	mov     ax, 013h
	int     10h

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
	xor	di, di
	push	ax
;	mov	dx, 03dah
;fred:	in	al, dx
;	test	al, 8
;	jnz	fred
;fred2:
;	in	al, dx
;	test	al, 8
;	jz	fred2
	sub	ax, ax
;	mov 	ax, 0000
	mov 	cx, 8000h
	rep 	stosw
	pop	ax

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
;------------------------------------
	push 	eax			;ax = random number (global), so PUSH.

	mov	di, bx
	lea	edi, [edi+edi*4]
	shl	edi, 6
	push	di
	add	di, bp
	mov     al, 09			;  CYAN = 3.   BLUE = 9.
	stosb	

	pop	ax
	mov	dx, 319
	sub	dx, bp
	add	ax, dx
	mov	di, ax
	mov     al, 9			;  RED 
	stosb
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop 	eax
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
	
   code    ENDS
END     start
