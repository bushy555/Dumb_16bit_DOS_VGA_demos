;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³..úúùùúú.úúùùúú..úúùùúú.úúùùúú.SQUIGGLE.COM..úúùùúú.úúùùúú..úúùùúú.úúùùúú..³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³  Written by:    Bushy.                                                    ³
;³  Date:          22-August-1995.                                           ³
;³  Originally:    3688 byte .COM file on first attempt.   Way to _BIG!_     ³
;³  Current Size:  Around 120 bytes. Impossible is around 100 bytes.         ³
;³  Written on:    386dx'40.                                                 ³
;³  Uses:          80386 instructions.                                       ³
;³  Version:       #08.                                                      ³
;³  Compiled with: TASM 4.1 / TLINK 7.0       MASM 5.* / LINK 3.64 / EXE2BIN ³
;³  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ³
;³                 TLINK /T CHAOS             LINK CHAOS;                    ³
;³                                            EXE2BIN CHAOS.EXE CHAOS.COM    ³
;³                                            (MASM gives a 77 byte file)    ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
; RANDOM NUM.  ax = RND (-32768 to +32768).				(5)(14)
;                                                             "GET A DOG UP YA"
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;PUTPIXEL routine. Fast... and small!. (BP Ä> X) (BX Ä> Y).           (19)(62)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;READ keyboard for <ESC>					    (7)(69)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        in      al, 060h
 	cmp     al, 01
 	pop     ax
        jne     @main
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@quit:					;			     (6)(75)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
 	mov    ax, 0003
        int    10h
        ret

;colour  db 0

array1	dw  slength  dup (?)
array2	dw  slength  dup (?)

code    ENDS
END     start
