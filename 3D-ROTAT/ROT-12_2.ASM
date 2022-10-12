number_1        equ     500    ;3500 is good
_width          equ     70
_2ndline        equ     22186
_3rdline        equ     22186

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov     ax, 0a000h
	mov     es, ax

	mov     ax, 013h
	int     10h

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

	even
@main:
	inc     si
	cmp     si, number_1
	jl      @main2
@main1:
	mov     cx, e
	mov     dx, f
	cmp     cx, 0   ;(0,dec Y)
	jg      @a
	cmp     dx, 1
	jl      @a
	dec     dx
	inc     cx
@a:
	cmp     dx, 0   ;(inc X, 0)
	jg      @b
	cmp     cx, _width
	jg      @b
	inc     cx
	inc     cx
@b:
	cmp     cx, _width  ;(319, dec Y)
	jl      @c
	cmp     dx, _width
	jg      @c
	inc     cx
	inc     dx
@c:
@d:     dec     cx
	mov     e, cx
	mov     f, dx
	mov     cx, a
	mov     dx, b
	cmp     cx, _width  ;(319, inc Y)
	jl      @e
	cmp     dx, _width
	jg      @e
	dec     cx
	inc     dx
@e:
	cmp     dx, _width  ;(dec X, 199)
	jl      @f
	cmp     cx, 1
	jl      @f
	dec     cx
	dec     cx
@f:
	cmp     cx, 0   ;(0, dec Y)
	jg      @g
	cmp     dx, 1
	jl      @g
	dec     cx
	dec     dx
@g:
@h:     inc     cx
	mov     a, cx
	mov     b, dx
	mov     cx, c
	mov     dx, d
	cmp     dx, _width  ;(dec X, 199)
	jl      @i
	cmp     cx, 0
	jl      @i
	dec     cx
	dec     dx
@i:
	cmp     cx, 0   ;(0, dec Y)
	jg      @j
	cmp     dx, 0
	jl      @j
	dec     dx
	dec     dx
@j:
	cmp     dx, 0   ;(inc X, 0)
	jg      @k
	cmp     cx, _width
	jg      @k
	dec     dx
	inc     cx
@k:     inc     dx
	mov     c, cx
	mov     d, dx
		

@waydownhere:

	cmp	flag1, 0
	je	increase
	cmp	flag1, 1
	je	decrease
	jmp	@main3
increase:
        inc     colour
        cmp     colour, 255
	jne	@main3	
	mov	flag1, 1

decrease:
        dec     colour
        cmp     colour, 1
	jne	@main3
	mov	flag1, 0

@Main3: xor     si, si
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	push	ax
	in      al, 060h
	cmp     al, 01
	pop     ax
	je	@Quit

	even
@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea     eax, [eax + eax * 2]
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
        add     bp, a
        add     bx, b
	jmp     short @calc
	even
@2:
	cmp     ax, 10923
	jg      @3
        add     bp, c
        add     bx, d
	jmp     short @calc
	even
@3:
        add     bp, e
        add     bx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
	even
@calc:                     ; S := ((S + X[R]) DIV 2);
	shr     bp, 1
                           ; T := ((T + Y[R]) DIV 2);
	shr     bx, 1                           
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
	push    eax                     ;ax = random number (global), so PUSH.

	lea     edi, [ebx+ebx*4]
	shl     edi, 6
	add     di, bp
	mov     al, colour;09                  ;  CYAN = 3.   BLUE = 9.
	stosb   

	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _2ndline         ;(32000 - _width - _width)
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _3rdline         ;(32000 - _width - _width)
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb

	mov     ax, _width
	sub     ax, bx

	mov     cx, _width
	sub     cx, bp

	lea     edi, [eax+eax*4]
	shl     edi, 6
	add     di, cx
	mov     al, colour;04          ;  CYAN = 3.   BLUE = 9.
	stosb   

	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _2ndline
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _3rdline
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb
	add     di, _width
	stosb

	pop     eax
	jmp     @main

@quit:
	mov    ax, 0003h
	int    10h
	retn

	a       dw 0
	b       dw 0
	c       dw _width
	d       dw 0
	e       dw _width
	f       dw _width
        colour  db 0
        flag1   db 0
        
   code    ENDS
END     start
