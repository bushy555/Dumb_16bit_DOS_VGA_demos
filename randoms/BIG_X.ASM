;trying to get a 4 cornered picture or "Squared carpet"


;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?..頰桁頰.頰桁頰..頰桁頰.頰桁頰.. CHAOS.COM ..頰桁頰.頰桁頰..頰桁頰.頰桁頰..?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?  Written by:    Bushy.                                                    ?
;?  Date:          12-June-1995.  Up-dated: 29-August-95.                    ?
;?  Originally:    Taken from an Apple ][e BASIC listing in 1988.            ?
;?  Original Size: Around 28200 bytes.                                       ?
;?  Current Size:  73 bytes. Impossible aim is 컴?> around 75 bytes.         ?
;?  Main aim:      75 bytes.                                                 ?
;?  Written on:    386sx'16.                                                 ?
;?  Uses:          80386 instructions.                                       ?
;?  Version:       #43.                                                      ?
;?  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ?
;?  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ?
;?                 TLINK /T CHAOS             LINK CHAOS;                    ?
;?                                            EXE2BIN CHAOS.EXE CHAOS.COM    ?
;?                                            (MASM gives a 77 byte file)    ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;? AX - GLOBAL. Random number / Various other.                               ?
;? BX - GLOBAL. Y value of pixel.                                            ?
;? BP - GLOBAL. X value of pixel.                                            ?
;? DI - GLOBAL. Final (X,Y) pixel position.                                  ?
;?                           * no other registers! *                         ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;쿣alues in the brackets below show the size of the following code in bytes  ?
;쿪nd the continuing size of Chaos.                                          ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;? Aims: get rid of the PUSH AX/POP AX                   ;save 2 bytes       ?
;?       get Mr Random number be random 1, 2, or 3.      ;save 3 bytes       ?
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

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
	sub	ax, ax
	mov	ds, ax
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = RND (-32768 to +32768).				(3)(12)
;                                                             "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@main:  
	imul	ax, 3
;	lea	eax, [eax+eax *2]
;	add	ax, si
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Determines which point (0,0), (320, 0) or (320, 200) to plot.	        
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (0,0)                        	;dont add anything.            (5)(17)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	cmp     ax, -16384             ; try -21845 for a freaky slide effect.
	jl      short @calc
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (320,0)							       (12)(29)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
     	cmp     ax, 0              ; try 21845 for a freaky slide effect
 	jg      @next
	inc	si
inc	ax
 	add	bp, 320;		;add 320 to  X.
 	jmp     short @calc
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (320,200)							       (8)(37)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@next:	cmp     ax, 16384              ; try 21845 for a freaky slide effect
 	jg      @next_2
 	add	bp, 320;		;add 320 to  X.
	dec	ax
	add	bx, 200
 	jmp     short @calc
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (0,200)							       (8)(37)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@next_2:  add	bx, 200			;add 200 to  Y.
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;   Calculate the two formula's for the next pixel.                    (4)(41)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@calc: 	
;	add	bp, bp
;	add	bx, bx

	shr    bp, 1			;original formula: 
					;       S := ((S + X[R]) DIV 2);
 	shr     bx,1	             	;original formula:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. Slow... but small!. (BP ?> X) (BX ?> Y).           (19)(60)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	push    ax                      ;ax = random number (global), so PUSH.
 	mov     ax, 320			;ax := 320.  Width of screen.
 	mul     bx                      ;AX := 320 * Y
 	add     ax, bp                  ;AX := AX + X
 	mov     di, ax                  ;final destination offset.
 	mov     al, 9            	;3=cyan 4=red 9=blue.
 	stosb				;plot the pixel.
;	sub	di, 8
 ;	mov     al, 4            	;3=cyan 4=red 9=blue.
; 	stosb				;plot the pixel.
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>					    (7)(67)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	in      al, 060h
 	cmp     al, 01
 	pop     ax
 	jne     @main
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@quit:					;			     (6)(73)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 	mov    ax, 0003
 	int    10h
 	retn
code    ENDS
END     start