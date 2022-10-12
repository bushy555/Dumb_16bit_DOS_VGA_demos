;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³..úúùùúú.úúùùúú..úúùùúú.úúùùúú.GAMEBOOT.COM..úúùùúú.úúùùúú..úúùùúú.úúùùúú..³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³  Written by:    Bushy.                                                    ³
;³  Current Size:  73 bytes. Impossible aim is ÄÄÄ> around 75 bytes.         ³
;³  Written on:    386sx'16.                                                 ³
;³  Uses:          80386 instructions.                                       ³
;³  Compiled with: TASM 3.2 / TLINK 5.1       MASM 5.* / LINK 3.64 / EXE2BIN ³
;³  Compilation:   TASM /M9 CHAOS             MASM CHAOS;                    ³
;³                 TLINK /T CHAOS             LINK CHAOS;                    ³
;³                                            EXE2BIN CHAOS.EXE CHAOS.COM    ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;³ AX - GLOBAL. Random number / Various other.                               ³
;³ BX - GLOBAL. Y value of pixel.                                            ³
;³ BP - GLOBAL. X value of pixel.                                            ³
;³ DI - GLOBAL. Final (X,Y) pixel position.                                  ³
;³                           * no other registers! *                         ³
;ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_width	equ	001Eh
_length	equ	0017h

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 

message label byte

        PUSH    SP
        DEC     AX
        DEC     CX
        PUSH    BX
        POP     DI
        DEC     CX
        PUSH    BX
        POP     DI
        INC     DX
        PUSH    BP
        PUSH    BX
        DEC     AX
        POP     CX
        DAA
        PUSH    BX
        POP     DI
	INC	SP                                 
	DEC	CX                                 
        PUSH	BX                                 
	DEC	BX 
        AND     al, 090h

        pop     bx
        inc     bx
        pop     bp
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        pop     bx
	pop	sp

	
	push	0A000h
	pop	es
	mov	ax, 0013h
	INT     10h
	MOV     DX, 03C8h		;from here down, is the background.
	MOV     AL, 01
	OUT     DX, AL
	INC     DX
	MOV     CX, 00FEh
@0113:  SUB     AL, AL
        OUT     DX, AL
        OUT     DX, AL
        MOV     AL, CL
        shr     al, 02
        out     dx, al
        LOOP    @0113
        MOV     AL, 3Fh
        OUT     DX, AL
        OUT     DX, AL
        OUT     DX, AL
        XOR     BX, BX
        XOR     DX, DX
        MOV     BP, 0FFFFh
        MOV     SI, 0FEC0h
@012E:  OR      BX, BX
        JZ      @0138
        CMP     BX, 013Fh
        JB      @013A
@0138:  NEG     BP
@013A:  OR      DX, DX
        JZ      @0147
        CMP     DX, 0F8C0h
        JB      @0149
        JMP     start
@0147:  NEG     SI
@0149:  CMP     DX, 0D480h
        JNZ     @015E
        MOV     AX, BX
        SUB     AX, count1		;;;;
        JB      @015E
        CMP     AX, 0014h
        JG      @015E
        NEG     SI
@015E:  PUSH    DX
        MOV     DX, 000C8h
        MOV     AX, 0FEFEh
        SUB     DI, DI
@0167:  push 	cx
	MOV     CL, 0A0h
        REPZ    STOSW
	pop	cx
        SUB     AX, 0101h
        DEC     DX
        JNZ     @0167
        POP     DX			;to around about here. (shaded background)
        MOV     DI, DX
        ADD     DI, BX
        MOV     BYTE PTR es:[DI], 0FFh
        ADD     BX, BP
        ADD     DX, SI
        MOV     DI, count1			;;;;;;
        ADD     DI, cx;count2			;;;;;;
        JNS     @018A
        SUB     DI, DI
@018A:  CMP     DI, 0012Ch
        JB      @0193
        MOV     DI, 0012Ch
@0193:  MOV     count1, DI                      ;;;;;;;
        ADD     DI, 0D480h
        MOV     AX, 003FFh
@019E:  push	cx
	MOV     CL, 014h
        REPZ    STOSB
	pop	cx
        ADD     DI, 0012Ch
        DEC     AH
        JNZ     @019E
	push	cx
        NOT     CX
@01AC:  NOP
        LOOP    @01AC                   ;some timing device?
	pop	cx
        MOV     AH, 01
        INT     16h
        JNZ     @01B8
        JMP     @012E
@01B8:  xor	ax, ax		;SUB     AH, AH
        INT     16h
	cmp	ah, 1
	je	@Sig
        CMP     AH, 04Bh
        JNZ     @01C6
        MOV     AX, 0FFFEh
        JMP     @01CE
@01C6:  CMP     AH, 04Dh
        JNZ     @012e   ;key    ;@01D4
        MOV     AX, 0002
@01CE:  MOV     cx, AX				;;;;
        JMP     @012E

@Sig:	push	es
	push	cs
	pop	es
	mov     ax, 1300h
        mov     bp, offset message + 07b3eh
	mov     cl, _length 
	mov     dx, 0C08h
	mov     bx, 008Fh
        int     10h                             ;display message
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
        cmp     al, 39h
        jne     short PutPix
@quit:  mov     ax, 3                           ;Quit
	int	10h
	int	19h

count1	label
	db	096h, 000h
count2	label
	db	000h, 000h	

   code    ENDS
END     start


