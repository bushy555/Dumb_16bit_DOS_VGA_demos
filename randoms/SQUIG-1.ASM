;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?..頰桁頰.頰桁頰..頰桁頰.頰桁頰.SQUIGGLE.COM..頰桁頰.頰桁頰..頰桁頰.頰桁頰..?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?  Written by:    Bushy.                                                    ?
;?  Date:          22-August-1995.                                           ?
;?  Originally:    3688 byte .COM file on first attempt.   Way to _BIG!_     ?
;?  Current Size:  Around 120 bytes. Impossible is around 100 bytes.         ?
;?  Written on:    386dx'40.                                                 ?
;?  Uses:          80386 instructions.                                       ?
;?  Version:       #08.                                                      ?
;?  Compiled with: TASM 4.1 / TLINK 7.0       MASM 5.* / LINK 3.64 / EXE2BIN ?
;?  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ?
;?                 TLINK /T CHAOS             LINK CHAOS;                    ?
;?                                            EXE2BIN CHAOS.EXE CHAOS.COM    ?
;?                                            (MASM gives a 77 byte file)    ?
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

Slength	equ	3000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
 	org     100h
	.386
start:
	mov     al, 013h                ;may need to be AX, 013h sometimes.
	int     10h			;				 (4)(4)

 	mov     ax, 0a000h		;could save a byte here, though using
 	mov     es, ax			;   BH/BX stuffs up... why? (DX=CS&DS)
					;				 (5)(9)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = RND (-32768 to +32768).				(5)(14)
;                                                             "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@main:  lea	eax, [eax + eax * 2]	;A quick RND().
	add	ax, cx

	cmp	ax, -16384
	jg	@next1
	inc	bp
	inc	bx
	jmp	short	@calc
@next1:	cmp	ax, 0
	jg	@next2
	inc	cx			;add some amount for Mr RND().
	inc	bp
	jmp	short	@next4		;do this and save 1 byte.
@next2:	cmp	ax, 16384
	jg	@next3
	dec	bp
	inc	bx
	jmp	short	@calc
@next3:	dec	bp
@next4:	dec	bx
@calc:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. Fast... and small!. (BP ?> X) (BX ?> Y).           (19)(62)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	push    ax                      ;ax = random number (global), so PUSH.
	push	cx

	lea	edi, [ebx+ebx*4]
	shl	edi, 6			;di=(320*Y)
	add	di, bp			;di=di+X
	
        mov     array1, di		;store DI

;	inc	colour
        mov     al, 4; colour           ;3=cyad 4=red 9=blue.
 	stosb				;plot the pixel.
	sub	di, 2
	stosb

	push	es
	push	cs			;set up ES for MOVSW
	pop	es

	mov	si, offset array1	;load from Array1 to Array2
	mov	di, offset array2	
	inc	di
	mov	cx, slength
	push	cx
	rep	movsw

	mov	si, offset array2	;Load from Array2 to Array1
	mov	di, offset array1
	inc	di
	pop	cx
	rep	movsw

 	pop	es			;Setup ES for screen again.

        mov     di, [array1 + slength]
	mov	al, 0			;4;colour	
	stosb
	sub	di, 2
	stosb
	
	pop	cx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>					    (7)(69)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        in      al, 060h
 	cmp     al, 01
 	pop     ax
        jne     @main
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@quit:					;			     (6)(75)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	mov    ax, 0003
        int    10h
        ret

;colour  db 0

array1	dw  slength  dup (?)
array2	dw  slength  dup (?)

code    ENDS
END     start
