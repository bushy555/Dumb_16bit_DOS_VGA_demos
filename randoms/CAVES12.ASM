
;���������������������������������������������������������������������������Ŀ
;�..������.������..������.������.. CAVES.COM ..������.������..������.������..�
;���������������������������������������������������������������������������Ĵ
;�  Written by:    Bushy.                                                    �
;�  Date:          21-August-1995.                                           �
;�  Current Size:  79 bytes. Impossible aim is ���> around 75 bytes.         �
;�  Written on:    386dx'40.                                                 �
;�  Uses:          80386 instructions.                                       �
;�  Version:       #12.                                                      �
;�  Compiled with: TASM 4.1 / TLINK 6.0      MASM 5.10 / LINK 3.64 / EXE2BIN �
;�  Compilation:   TASM /M9 CHAOS            MASM CHAOS;                     �
;�                 TLINK /T CHAOS            LINK CHAOS;                     �
;�                                           EXE2BIN CHAOS.EXE CHAOS.COM     �
;�                                           (MASM gives a ?? byte file)     �
;���������������������������������������������������������������������������Ĵ
;�                                                                           �
;�                                                                           �
;�                                                                           �
;�                                                                           �
;� DI - GLOBAL. Final (X,Y) pixel position.                                  �
;�                           * no other variables! *                         �
;���������������������������������������������������������������������������Ĵ
;�Values in the brackets below show the size of the following code in bytes  �
;�and the continuing size of Chaos.                                          �
;���������������������������������������������������������������������������Ĵ
;�                                                                           �
;�                                                                           �
;�����������������������������������������������������������������������������

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
;����������������������������������������������������������������������������
; RANDOM NUM.  ax = RND (-32768 to +32768).		
;                                                             "GET A DOG UP YA"
;����������������������������������������������������������������������������
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
;����������������������������������������������������������������������������
;PUTPIXEL routine. FAST and SMALL!. 	;(bx,dx) ��> (x,y)
;����������������������������������������������������������������������������
	lea	edi, [eax+eax*4]
	shl	edi, 6			;mov	di, 320*Y
	add	di, bx			;add	di, X
	stosb				;ax = colour
					;write it!
	sub     di, 2			
	stosb				;minus 2 and write again

;����������������������������������������������������������������������������
;READ keyboard for <ESC>	
;����������������������������������������������������������������������������
	in      al, 060h	
	cmp     al, 01
	jne     @main
;����������������������������������������������������������������������������
@quit:					;
;����������������������������������������������������������������������������
	mov    ax, 0003h		;Normal text mode
	int    10h
	retn

array   dw 320 dup (?)			;one array.

   code    ENDS
END     start

