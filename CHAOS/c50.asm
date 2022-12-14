;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?..頰桁頰.頰桁頰..頰桁頰.頰桁頰.. CHAOS.COM ..頰桁頰.頰桁頰..頰桁頰.頰桁頰..?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?  Written by:    Bushy.                                                    ?
;?  Date:          12-June-1995.  Last up-dated: 25-March-1996.              ?
;?  Originally:    Taken from an Apple ][e BASIC listing in 1988.            ?
;?  Original Size: Around 28200 bytes.                                       ?
;?  Current Size:  68 bytes. Impossible aim is 컴?> around 65 bytes.         ?
;?  Main aim:      75 bytes.                                                 ?
;?  Written on:    386sx'16/386dx'40.                                        ?
;?  Uses:          80386 instructions.                                       ?
;?  Version:       #46.                                                      ?
;?  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ?
;?  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ?
;?                 TLINK /T CHAOS             LINK CHAOS;                    ?
;?                                            EXE2BIN CHAOS.EXE CHAOS.COM    ?
;?                                            (MASM gives a 72 byte file)    ?
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
