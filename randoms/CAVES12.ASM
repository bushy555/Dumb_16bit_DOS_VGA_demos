
;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?..頰桁頰.頰桁頰..頰桁頰.頰桁頰.. CAVES.COM ..頰桁頰.頰桁頰..頰桁頰.頰桁頰..?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?  Written by:    Bushy.                                                    ?
;?  Date:          21-August-1995.                                           ?
;?  Current Size:  79 bytes. Impossible aim is 컴?> around 75 bytes.         ?
;?  Written on:    386dx'40.                                                 ?
;?  Uses:          80386 instructions.                                       ?
;?  Version:       #12.                                                      ?
;?  Compiled with: TASM 4.1 / TLINK 6.0      MASM 5.10 / LINK 3.64 / EXE2BIN ?
;?  Compilation:   TASM /M9 CHAOS            MASM CHAOS;                     ?
;?                 TLINK /T CHAOS            LINK CHAOS;                     ?
;?                                           EXE2BIN CHAOS.EXE CHAOS.COM     ?
;?                                           (MASM gives a ?? byte file)     ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?                                                                           ?
;?                                                                           ?
;?                                                                           ?
;?                                                                           ?
;? DI - GLOBAL. Final (X,Y) pixel position.                                  ?
;?                           * no other variables! *                         ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;쿣alues in the brackets below show the size of the following code in bytes  ?
;쿪nd the continuing size of Chaos.                                          ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?                                                                           ?
;?                                                                           ?
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

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
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = RND (-32768 to +32768).		
;                                                             "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
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
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. FAST and SMALL!. 	;(bx,dx) 컴> (x,y)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea	edi, [eax+eax*4]
	shl	edi, 6			;mov	di, 320*Y
	add	di, bx			;add	di, X
	stosb				;ax = colour
					;write it!
	sub     di, 2			
	stosb				;minus 2 and write again

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>	
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h	
	cmp     al, 01
	jne     @main
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@quit:					;
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	mov    ax, 0003h		;Normal text mode
	int    10h
	retn

array   dw 320 dup (?)			;one array.

   code    ENDS
END     start

