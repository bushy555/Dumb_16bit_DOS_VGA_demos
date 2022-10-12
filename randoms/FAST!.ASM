;ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
;і..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ.. CHAOS.COM ..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і  Written by:    Bushy.                                                    і
;і  Date:          12-June-1995.                                             і
;і  Originally:    Taken from an Apple ][e BASIC listing in 1988.            і
;і  Original Size: Around 28200 bytes.                                       і
;і  Current Size:  75 bytes. Impossible aim is ДДД> around 75 bytes.         і
;і  Written on:    386sx'16.                                                 і
;і  Uses:          80386 instructions.                                       і
;і  Version:       #43.                                                      і
;і  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN і
;і  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    і
;і                 TLINK /T CHAOS             LINK CHAOS;                    і
;і                                            EXE2BIN CHAOS.EXE CHAOS.COM    і
;і                                            (MASM gives a 77 byte file)    і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і AX - GLOBAL. Random number / Various other.                               і
;і BX - GLOBAL. Y value of pixel.                                            і
;і BP - GLOBAL. X value of pixel.                                            і
;і CX - GLOBAL. Increasing counter for Random Value.                         і
;і DI - GLOBAL. Final (X,Y) pixel position.                                  і
;і                           * no other variables! *                         і
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
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
; RANDOM NUM.  ax = RND (-32768 to +32768).				(5)(14)
;                                                             "GET A DOG UP YA"
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@main: lea	eax, [eax+eax*2]
        add     ax, cx
; imul    ax, 03			;smallest random number generator!
;	add     ax, cx			; add some amount for the random number
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
; Determines which point (0,0), (320, 0) or (320, 200) to plot.	        
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (0,0)                        	;dont add anything.            (5)(19)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
	cmp     ax, -10923              ; try -21845 for a freaky slide effect.
	jl      short @calc
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (320,0)							       (12)(31)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
     	cmp     ax, 10923               ; try 21845 for a freaky slide effect
 	jg      @next
 	inc     cx			;some amount to add to RAND number.
 	add	bp, 320;		;add 320 to  X.
 	jmp     short @calc
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 ;  (160,200)							       (8)(39)
 ;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@next:  add	bp, 160			;add 160 to  X.
	add	bx, 200			;add 200 to  Y.
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;   Calculate the two formula's for the next pixel.                    (4)(43)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@calc: 	shr     bp, 1			;original formula: 
					;       S := ((S + X[R]) DIV 2);

 	shr     bx, 1	             	;original formula:
					;       T := ((T + Y[R]) DIV 2);
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;PUTPIXEL routine. Slow... but small!. (BP Д> X) (BX Д> Y).           (19)(62)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	push    ax                      ;ax = random number (global), so PUSH.
;mov	di, bx
	lea	edi, [ebx + ebx * 4]
	shl	di, 6
	add	di, bp
	mov     al, 9            	;3=cyan 4=red 9=blue.
	stosb

 	sub     di, 4                   ;this is for the 3D effect. Is it 3D?
	mov     al, 4                   ;red
	stosb				;plot the pixel.
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;READ keyboard for <ESC>					    (7)(69)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	in      al, 060h
 	cmp     al, 01
 	pop     ax
 	jne     @main
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@quit:					;			     (6)(75)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	mov    ax, 0003
 	int    10h
 	retn
code    ENDS
END     start
