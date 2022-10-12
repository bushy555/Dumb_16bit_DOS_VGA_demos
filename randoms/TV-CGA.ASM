code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
start: 
	  XOR     AH, AH
	  MOV     AL, 05h
	  INT     10h

here:	  MOV     AH, 0Fh
	  INT     10h
	  PUSH    AX
	  MOV     CX, 0005h
	  MOV     AX, 017Fh
	  SUB     AX, 1000h
	  MOV     SI, AX
@0116:    PUSH    CX
	  PUSH    SI
	  POP     DS
	  PUSH    DS
	  XOR     SI, SI
	  MOV     AX, 0B800h
	  MOV     ES, AX
	  XOR     DI, DI
	  MOV     CX, 4000h
	  REPZ
	  MOVSB
	  POP     AX
	  ADD     AX, 0040h
	  MOV     SI, AX
	  POP     CX
	in	al, 060h
	cmp	al, 1
	je	quit
	dec	cx
	jnz	@0116
	jmp	here
quit:	mov	ax, 3
	int	10h
	int     20h

    code    ENDS
   END   start

