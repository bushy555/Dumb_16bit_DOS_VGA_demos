;ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
;і..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..DRAGON.COM ..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і  Written by:    Bushy.                                                    і
;і  Date:          12-April-1997. Up-dated:                                  і
;і  Originally:    Taken from                                                і
;і  Original Size: 21920 bytes.                                              і
;і  Current Size:  80 bytes.Impossible aim is ДДД> around 75 bytes.          і
;і  Main aim:      75 bytes.                                                 і
;і  Written on:    486dx'100.                                                і
;і  Uses:          80386 instructions.                                       і
;і  Version:       #26.                                                      і
;і  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN і
;і  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    і
;і                 TLINK /T CHAOS             LINK CHAOS;                    і
;і                                            EXE2BIN CHAOS.EXE CHAOS.COM    і
;і                                            (MASM gives a 77 byte file)    і
;іDRAGON2  PAS         1,710 04-11-97  10:23a                                і
;іDRAGON2  EXE        21,920 04-11-97  10:23a                                і
;іDRAG5    PAS         2,165 04-12-97   1:18a                                і
;іDRAG5    EXE         3,584 04-12-97   1:30a                                і
;іD13      COM           192 04-12-97   1:43a                                і
;іD15      COM           151 04-12-97   2:05a                                і
;іD16      COM           110 04-12-97  12:03p                                і
;іD23      COM            83 04-12-97  12:54p                                і
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
start:  mov     al, 013h                ;may need to be AX, 013h sometimes.
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
; Setup for smaller code size for the 1st and 2nd 50%'s. (BX,BP)=(X,Y)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
        mov     cx, bx           ;setup for both 50%'s  NewX and NewY.
        add     cx, bp           ;  bit quicker and saves ~15 bytes.
        mov     dx, bx
        neg     dx
        add     dx, bp
        add     dx, 75

        test    ax, ax
        jg      @@_1
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;  First 50%
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
        add     cx, 80          ;newx:=((0.5*x)+(0.5*y)+80);
        sub     ax, cx          ;newy:=((0.5*-x)+(0.5*y)+75);
        jmp     @@_Calc
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;  Second 50%
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@@_1:   sub     cx, 80          ;newx:=((0.5*x)+(0.5*y)-80);
        add     dx, 50          ;newy:=((0.5*-x)+(0.5*y)+125);
        add     ax, cx
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;   Do the («*x)'s and («*y)'s on NewX and NewY.                       (4)(41)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@@_calc:shr     cx, 1
        shr     dx, 1
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;PUTPIXEL routine. Slow... but small!. (BP Д> X) (BX Д> Y).           (18)(59)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
        push    ax
        mov     bx, cx
        mov     bp, dx
        mov     ax, 320
        mul     dx
        add     ax, cx
        sub     ax, 120         ;Centre it!
        xchg    di, ax                                                 ; (1)
        mov     al, 23
        stosb
;        sub     di, 4
;        mov     al, 20
;        stosb
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
;READ keyboard for <ESC>					    (7)(68)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	in      al, 060h
 	cmp     al, 01
 	pop     ax
 	jne     @main
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
@quit:					;			     (6)(72)
;ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД
 	mov    ax, 0003
 	int    10h
 	retn

code    ENDS
END     start






TREE
DATA 4
0.42,0.42,-0.42,0.42,0,0.2,0.4
0.42,-0.42,0.42,0.42,0,0.2,0.4
0.1,0,0,0.1,0,0.2,0.15
0,0,0,0.5,0,0,0.05

