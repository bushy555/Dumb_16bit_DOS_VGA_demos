;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?..頰桁頰.頰桁頰..頰桁頰.頰桁頰.. CHAOS.COM ..頰桁頰.頰桁頰..頰桁頰.頰桁頰..?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?  Written by:    Bushy.                                                    ?
;?  Date:          12-June-1995.                                             ?
;?  Originally:    Taken from an Apple ][e BASIC listing in 1988.            ?
;?  Original Size: Around 28200 bytes.                                       ?
;?  Current Size:  75 bytes. Impossible aim is 컴?> around 75 bytes.         ?
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
;? CX - GLOBAL. Increasing counter for Random Value.                         ?
;? DI - GLOBAL. Final (X,Y) pixel position.                                  ?
;?                           * no other variables! *                         ?
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
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = RND (-32768 to +32768).				(5)(14)
;                                                             "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@main: lea	eax, [eax+eax*2]
        add     ax, cx
; imul    ax, 03			;smallest random number generator!
;	add     ax, cx			; add some amount for the random number
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Determines which point (0,0), (320, 0) or (320, 200) to plot.	        
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (0,0)                        	;dont add anything.            (5)(19)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	cmp     ax, -10923              ; try -21845 for a freaky slide effect.
	jl      short @calc
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (320,0)							       (12)(31)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
     	cmp     ax, 10923               ; try 21845 for a freaky slide effect
 	jg      @next
 	inc     cx			;some amount to add to RAND number.
 	add	bp, 320;		;add 320 to  X.
 	jmp     short @calc
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
 ;  (160,200)							       (8)(39)
 ;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@next:  add	bp, 160			;add 160 to  X.
	add	bx, 200			;add 200 to  Y.
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;   Calculate the two formula's for the next pixel.                    (4)(43)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@calc: 	shr     bp, 1			;original formula: 
					;       S := ((S + X[R]) DIV 2);

 	shr     bx, 1	             	;original formula:
					;       T := ((T + Y[R]) DIV 2);
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. Slow... but small!. (BP ?> X) (BX ?> Y).           (19)(62)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
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
 	retn
code    ENDS
END     start
