;ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
;і..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ.VGA-SCROLL-UP.ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і  Written by:    Bushy.                                                    і
;і  Date:          06-May-1996.                                              і
;і  Originally:    As first seen on Apple ][e grafix program back in '86.    і
;і  Original Size: Around 150 bytes with Chaos (70bytes)                     і
;і  Current Size:                                                            і
;і  Main aim:      75 bytes.                                                 і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
 	org     100h
	.386
start:
	mov     al, 013h                ;may need to be AX, 013h sometimes.
 	int     10h			;				 (4)(4)

 	mov     ax, 0a000h		;could save a byte here, though using
	mov     es, ax			;   BH/BX & DH/DX stuffs up... Why? 
					;   DX=CS at startup. Why?	 (5)(9)
					;Push/pop also puts junk on screen.
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
; RANDOM NUM.  ax = RND (-32768 to +32768).				(3)(12)
;                                                             "GET A DOG UP YA"
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@main:  imul    ax, 03			;smallest random number generator!
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
; Determines which point (0,0), (320, 0) or (320, 200) to plot.	        
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (0,0)                        	;dont add anything.            (5)(17)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
	cmp     ax, -10923              ; try -21845 for a freaky slide effect.
	jl      short @calc
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (320,0)							       (12)(29)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
     	cmp     ax, 10923               ; try 21845 for a freaky slide effect
 	jg      @next
 	inc     ax			;some amount to add to Mr RND() number.
 	add	bp, 320;		;add 320 to  X.
 	jmp     short @calc
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (160,200)							       (8)(37)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@next:  add	bp, 160			;add 160 to  X.
	add	bx, 200			;add 200 to  Y.
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;   Calculate the two formula's for the next pixel.                    (4)(41)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@calc: 	shr     bp, 1			;original formula: 
					;       S := ((S + X[R]) DIV 2);

 	shr     bx, 1	             	;original formula:
					;       T := ((T + Y[R]) DIV 2);
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;PUTPIXEL routine. Slow... but small!. (BP Д> X) (BX Д> Y).           (16)(57)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	push    ax                      ;ax = random number (global), so PUSH.
	imul	di, bx, 320
	add	di, bp
 	mov     al, 10;9            	;3=cyan 4=red 9=blue.
 	stosb				;plot the pixel.
 	sub     di, 4                   ;this is for the 3D effect. Is it 3D?
 	mov     al, 4                   ;red
; 	stosb				;plot the pixel.
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;READ keyboard for <ESC>					    (7)(66)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	in      al, 060h
 	cmp     al, 01
 	pop     ax
 	jne     @main
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@quit:					;			     (6)(70)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@@1:
	xor	si, si
	xor	di, di
	push	02000h
	pop	es
	push	0A000h
	pop	ds
	mov	cx, 16000
	rep	movsd


	mov	ax, 0A000h
	mov	ds, ax
	mov	es, ax

looping:
	mov	bp, 64000
L0:
sit:	
        mov     dx,3dah		;wait retrace
@@vw1:  in      al,dx  
        and     al,08h 
        jnz     @@vw1  
@@vw2:  in      al,dx  
        and     al,08h 
        jz      @@vw2  

	push	02000h		;copy from virtual to MEM
	pop	ds
	push	0A000h
	pop	es
	xor	si, si
	xor	di, di
	mov	cx, 16000
	rep	movsd

	mov	bx, bp
	mov	si, bx
L2:	add	bx, 320
	mov	di, bx
	mov	cx, 80
	push	0a000h		;From MEM to virtual
	pop	ds
	push	02000h
	pop	es
L3:	lodsd
	stosd
	dec	cx
	jne	L3
	cmp	bx, 64320;4160
	jne	L2

	sub	bp, 320;640;160
	cmp	bp, 0000
	jne	L0

	mov	ax, 0003
	int	10h

	ret


	code    ENDS
END     start

