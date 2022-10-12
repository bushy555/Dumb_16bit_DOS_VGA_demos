;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³..úúùùúú.úúùùúú..úúùùúú.úúùùúú.. CHAOS.COM ..úúùùúú.úúùùúú..úúùùúú.úúùùúú..³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³  Written by:    Bushy.                                                    ³
;³  Date:          12-June-1995.  Last up-dated: 25-March-1996.              ³
;³  Originally:    Taken from an Apple ][e BASIC listing in 1988.            ³
;³  Original Size: Around 28200 bytes.                                       ³
;³  Current Size:  68 bytes. Impossible aim is ÄÄÄ> around 65 bytes.         ³
;³  Main aim:      75 bytes.                                                 ³
;³  Written on:    386sx'16/386dx'40.                                        ³
;³  Uses:          80386 instructions.                                       ³
;³  Version:       #46.                                                      ³
;³  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ³
;³  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ³
;³                 TLINK /T CHAOS             LINK CHAOS;                    ³
;³                                            EXE2BIN CHAOS.EXE CHAOS.COM    ³
;³                                            (MASM gives a 72 byte file)    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³ AX - GLOBAL. Random number / Various other.                               ³
;³ BX - GLOBAL. Y value of pixel.                                            ³
;³ BP - GLOBAL. X value of pixel.                                            ³
;³ DI - GLOBAL. Final (X,Y) pixel position.                                  ³
;³                           * no other registers! *                         ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³Values in the brackets below show the size of the following code in bytes  ³
;³and the continuing size of Chaos.                                          ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
 	org     100h
	.386
start:
	mov     al, 013h                
 	int     10h			
	les	bx, [bx]
@main:  in	al, 40h
	add	ax, di
	cmp     al, -64
	jl      @calc
        mov     cl, 160
        add     bp, cx
     	cmp     al, 64
 	jg      @next
        add     bp, cx                  ;add 320 to  X.
 	jmp     short @calc
@next:  add     bx, 200                 ;add 200 to  Y.
@calc: 	shr     bp, 1			;original formula: 					;       S := ((S + X[R]) DIV 2);
 	shr     bx, 1	             	;original formula:					;       T := ((T + Y[R]) DIV 2);

	imul	di, bx, 320
        mov     byte ptr es:[di+bp], 9
        mov     byte ptr es:[di+bp-3], 4
	jmp	@main


; 	in      al, 060h
;	dec	ax
; 	jne     @main
;@quit: 	mov    al, 03
; 	int    10h
; 	retn
code    ENDS
END     start
