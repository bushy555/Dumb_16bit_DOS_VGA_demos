;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³..úúùùúú.úúùùúú..úúùùúú.úúùùúú..  SIG.COM  ..úúùùúú.úúùùúú..úúùùúú.úúùùúú..³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³  Written by:    Bushy.                                                    ³
;³  Date:          09-November-1995                                          ³
;³  Current Size:  121 bytes.                                                ³
;³  Written on:    386sx'16.                                                 ³
;³  Uses:          80386 instructions.                                       ³
;³  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ³
;³  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ³
;³                 TLINK /T CHAOS             LINK CHAOS;                    ³
;³                                            EXE2BIN CHAOS.EXE CHAOS.COM    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³ AX - GLOBAL. Random number / Various other.                               ³
;³ BX - GLOBAL. multiplication factor                                        ³
;³ CX - Y                                                                    ³
;³ DX - X                                                                    ³
;³ BP - used for display message.                                            ³
;³ SI - GLOBAL. varibale for multiplication                                  ³
;³ DI - GLOBAL. Final (X,Y) pixel position.                                  ³
;³                           * no other variables! *                         ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_width	equ	001Eh

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 	mov	ax, 13h
        int     10h                             ;VGA
	mov     ax, 1300h
        mov     bp, offset message              ;+ 07b3eh
	mov     cl, _length 
	mov     dx, 0C08h
	mov     bx, 008Fh
        int     10h                             ;display message
	push	0a000h
	pop	es
	mov	dl, 00040h
	mov	cl, dl
	mov	si, 06f0ch
PutPix: mov     bx, cx                          ;(X,Y) = (DX,CX)
	lea 	edi, [ebx+ebx*4]
	shl	edi, 6
	add	di, dx
	push	cx
	mov	cx, _width
IncPal: inc     byte ptr es:[di]
	inc	di
        loop    IncPal
	pop	cx
        mov     bx, si
        mov     ax, 4E6Dh                       ;Multiplication factor
        push	dx
        mul     bx
	pop	dx
        shl     ax, 1
        adc     ax, 0061h
        shr     ax, 1
        neg     ax
        shl     ax, 1
        and     ax, 7FFEh
        shr     ax, 1
        mov     si, ax
        cmp     al, 80h
        jb      @A0185
        inc     dx
        jmp     short @A0189
@A0185: dec     dx                              ;decrease X
@A0189: inc     cx                              ;increase Y
        in      al, 060h                        ;Keyboard check for <ESC>
        cmp     al, 1
        jne     short PutPix
@quit:  mov     ax, 3                           ;Quit
	int	10h
	ret

message	 db '          DAX$'
_length	 db 0dh

   code    ENDS
END     start
