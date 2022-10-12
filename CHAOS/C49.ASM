;ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
;і..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ.. CHAOS.COM ..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і  Written by:    Bushy.                                                    і
;і  Date:          12-June-1995.  Last up-dated: 25-March-1996.              і
;і  Originally:    Taken from an Apple ][e BASIC listing in 1988.            і
;і  Original Size: Around 28200 bytes.                                       і
;і  Current Size:  68 bytes. Impossible aim is ДДД> around 65 bytes.         і
;і  Main aim:      75 bytes.                                                 і
;і  Written on:    386sx'16/386dx'40.                                        і
;і  Uses:          80386 instructions.                                       і
;і  Version:       #46.                                                      і
;і  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN і
;і  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    і
;і                 TLINK /T CHAOS             LINK CHAOS;                    і
;і                                            EXE2BIN CHAOS.EXE CHAOS.COM    і
;і                                            (MASM gives a 72 byte file)    і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і AX - GLOBAL. Random number / Various other.                               і
;і BX - GLOBAL. Y value of pixel.                                            і
;і BP - GLOBAL. X value of pixel.                                            і
;і DI - GLOBAL. Final (X,Y) pixel position.                                  і
;і                           * no other registers! *                         і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;іValues in the brackets below show the size of the following code in bytes  і
;іand the continuing size of Chaos.                                          і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і Aims: get rid of the PUSH AX/POP AX                   ;save 2 bytes       і
;і       get Mr Random number be random 1, 2, or 3.      ;save 3 bytes       і
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
        mov     cl, 160
        add     bp, cx
     	cmp     ax, 10923               ; try 21845 for a freaky slide effect
 	jg      @next
 	inc     ax			;some amount to add to Mr RND() number.
        add     bp, cx                  ;add 320 to  X.
 	jmp     short @calc
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (160,200)							       (8)(37)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@next:  add     bx, 200                 ;add 200 to  Y.
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
	imul	di, bx, 320
        mov     byte ptr es:[di+bp], 9
        mov     byte ptr es:[di+bp-4], 4
        push    ax                      ;ax = random number (global), so PUSH.
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;READ keyboard for <ESC>					    (7)(66)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	in      al, 060h
	dec	ax
 	pop     ax
 	jne     @main
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@quit:					;			     (6)(70)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	mov    al, 03
 	int    10h
 	retn
code    ENDS
END     start
