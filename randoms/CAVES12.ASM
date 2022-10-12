
;ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
;і..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ.. CAVES.COM ..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і  Written by:    Bushy.                                                    і
;і  Date:          21-August-1995.                                           і
;і  Current Size:  79 bytes. Impossible aim is ДДД> around 75 bytes.         і
;і  Written on:    386dx'40.                                                 і
;і  Uses:          80386 instructions.                                       і
;і  Version:       #12.                                                      і
;і  Compiled with: TASM 4.1 / TLINK 6.0      MASM 5.10 / LINK 3.64 / EXE2BIN і
;і  Compilation:   TASM /M9 CHAOS            MASM CHAOS;                     і
;і                 TLINK /T CHAOS            LINK CHAOS;                     і
;і                                           EXE2BIN CHAOS.EXE CHAOS.COM     і
;і                                           (MASM gives a ?? byte file)     і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і                                                                           і
;і                                                                           і
;і                                                                           і
;і                                                                           і
;і DI - GLOBAL. Final (X,Y) pixel position.                                  і
;і                           * no other variables! *                         і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;іValues in the brackets below show the size of the following code in bytes  і
;іand the continuing size of Chaos.                                          і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і                                                                           і
;і                                                                           і
;АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 	mov     di, offset array		;Zero out array at bottom.
	mov     cx, 320
	xor     ax, ax
	rep     stosw

	push	0a000h				;ES = 0A000h, which is VGA
	pop	es

	mov  al, 0013h				;VGA mode
	int  10h
@main:
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
; RANDOM NUM.  ax = RND (-32768 to +32768).		
;                                                             "GET A DOG UP YA"
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
	mov     bx, cx				;cx = RANDOM number
	lea	ebx, [ebx + ebx * 2]		;(equivalent to imul ax, 03)
	add     bx, si				;add some amount
	mov     cx, bx
	cmp     bx, 0				;is it in range?
	jl      @main				;need a AND BX, ???? 
	cmp    	bx, 321
	jg      @main

	inc     si				;twice coz stosb
	inc	si

        mov     ax, [array + bx]		;increase the array by one
	inc     ax
	mov     array + bx, ax
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;PUTPIXEL routine. FAST and SMALL!. 	;(bx,dx) ДД> (x,y)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
	lea	edi, [eax+eax*4]
	shl	edi, 6			;mov	di, 320*Y
	add	di, bx			;add	di, X
	stosb				;ax = colour
					;write it!
	sub     di, 2			
	stosb				;minus 2 and write again

;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;READ keyboard for <ESC>	
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
	in      al, 060h	
	cmp     al, 01
	jne     @main
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@quit:					;
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
	mov    ax, 0003h		;Normal text mode
	int    10h
	retn

array   dw 320 dup (?)			;one array.

   code    ENDS
END     start

