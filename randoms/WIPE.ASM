;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³..úúùùúú.úúùùúú..úúùùúú.úúùùúú..  WIPE.COM ..úúùùúú.úúùùúú..úúùùúú.úúùùúú..³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³  Written by:    Bushy.                                                    ³
;³  Date:          05-March-1996,25-April-1996,04-Sep-1998.                  ³
;³  Originally:    Taken from an VZ ASM listing.                             ³
;³  Original Size: Around 5000 odd bytes.                                    ³
;³  Current Size:  29 bytes. Impossible aim is ÄÄÄ> around 30 bytes.         ³
;³  Written on:    386dx'40.                                                 ³
;³  Uses:          80386 instructions.                                       ³
;³  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ³
;³  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ³
;³                 TLINK /T CHAOS             LINK CHAOS;                    ³
;³                                            EXE2BIN CHAOS.EXE CHAOS.COM    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³ AX - GLOBAL. = general / holds character                                  ³
;³ BX - GLOBAL. = number of characters to go through, ie 255.                ³
;³ CX - GLOBAL. = size of video screen                                       ³
;³ DS - GLOBAL. = txt segment                                                ³
;³ ES - GLOBAL. = txt segment                                                ³
;³ SI - GLOBAL. Source...                                                    ³
;³ DI - GLOBAL. Final (X,Y) pixel position.                                  ³
;³                           * no other registers! *                         ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	.386
	ORG     100h
start:					;assumes BX= 00000h
	mov     ah, 0b8h		;assumes AL= 000h		(2)
        mov     ds, ax			;				(2)
	mov	es, ax			;				(2)
@0:	xor	si, si			;				(2)
	xor	di, di			;				(2)
	mov	cx, 07d0h		;				(3)
@1:     lodsw                           ;                               (1)
        cmp     al, 020h                ;                               (2)
	jz	@3			;				(2)
	inc	ax			;				(1)
	stosb				;				(1)
        dec     di                      ;                               (1)
@3:     scasw                           ;                               (1)
	loop	@1			;				(2)
        inc     bl                      ;                               (2)
	jne	@0			;				(2)
	ret				;                               (1)

code    ENDS
END     start
