;旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?..頰桁頰.頰桁頰..頰桁頰.頰桁頰..  WIPE.COM ..頰桁頰.頰桁頰..頰桁頰.頰桁頰..?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;?  Written by:    Bushy.                                                    ?
;?  Date:          05-March-1996,25-April-1996,04-Sep-1998.                  ?
;?  Originally:    Taken from an VZ ASM listing.                             ?
;?  Original Size: Around 5000 odd bytes.                                    ?
;?  Current Size:  29 bytes. Impossible aim is 컴?> around 30 bytes.         ?
;?  Written on:    386dx'40.                                                 ?
;?  Uses:          80386 instructions.                                       ?
;?  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ?
;?  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ?
;?                 TLINK /T CHAOS             LINK CHAOS;                    ?
;?                                            EXE2BIN CHAOS.EXE CHAOS.COM    ?
;쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
;? AX - GLOBAL. = general / holds character                                  ?
;? BX - GLOBAL. = number of characters to go through, ie 255.                ?
;? CX - GLOBAL. = size of video screen                                       ?
;? DS - GLOBAL. = txt segment                                                ?
;? ES - GLOBAL. = txt segment                                                ?
;? SI - GLOBAL. Source...                                                    ?
;? DI - GLOBAL. Final (X,Y) pixel position.                                  ?
;?                           * no other registers! *                         ?
;읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

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
