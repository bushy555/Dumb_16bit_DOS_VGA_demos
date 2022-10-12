@PART1: MOV     AX, CS
	MOV	DS, AX
	MOV	AX, 0A3E8h
	MOV	ES, AX
	CALL	FFDE			;;;;;;;
	MOV	DX, 03D4h
	MOV	AX, 0013h
	OUT	DX, AX
        MOV     WORD PTR cs:Count1, 3E80h
        MOV     WORD PTR cs:Count2, 0190h
	CLI
	MOV	CX, 00C8h
@0125:  MOV     cs:Count5, CX
	CALL	@018F
	CALL	@01E2
	MOV	CX, 0000
	LOOP	@0125
	CALL	@018F
        STI
        RET
@Part2:
@013A:  MOV     AX, CS
        MOV     DS, AX
        MOV     AX, 0A3E8h
	MOV	ES, AX
@0143:	CALL	FFDE				;;;;;;;
        MOV     WORD PTR cs:Count1, 7D00h
        MOV     WORD PTR cs:Count3, 018Eh
	CALL	@018F
	CLI
	MOV	CX, 00C7h
@015B:  MOV     word ptr cs:Count4, CX
	CALL	@017E
	CALL	@01B8
	MOV	CX, 0000
	LOOP	@015B
        MOV     WORD PTR cs:Count1, 3E80h
	CALL	@018F
	MOV	DX, 03D4h
	MOV	AX, 2813h
	OUT	DX, AX
	STI
	RET
@Part3:
@017E:  MOV     DX, 03DAh
@0181:	IN	AL, DX
	TEST	AL, 01h
	JNZ	@0181
	MOV	DX, 03DAh
@0189:	IN	AL, DX
	TEST	AL, 08h
	JZ	@0189
	RET
@PART4:
@018F:  MOV     DX, 03DAh
@0192:	IN	AL, DX
	TEST	AL, 01
	JNZ	@0192
	MOV	DX, 03D4h
	MOV	AX, 0000h
	MOV	BX, AX
	MOV	AL, 0Ch
	OUT	DX, AX
	INC	AL
	MOV	AH, BL
	OUT	DX, AX
	MOV	DX, 03DAh
@01AA:	IN	AL, DX
	TEST	AL, 08h
	JZ	@01AA
	SUB	BX, +50h
        MOV     word ptr cs:Count1, BX
	RET
@PART5:
@01B8:  MOV     CX, 0000h
	MOV	BX, CX
	MOV	DX, 03D4h
	MOV	AX, 2813h
	OUT	DX, AX
	MOV	DX, 03DAh
@01C7:	IN	AL, DX
	TEST	AL, 01h
	JNZ	@01C7
@01CC:	IN	AL, DX
	TEST	AL, 01
	JZ	@01CC
	LOOP	@01C7
	MOV	DX, 03D4h
	MOV	AX, 0013h
	OUT	DX, AX
	DEC	BX
	DEC	BX
        MOV     word ptr cs:Count3, BX
	RET
@PART6:
@01E2:  MOV     CX, 0000h
	MOV	BX, CX
	MOV	DX, 03D4h
	MOV	AX, 0013h
	OUT	DX, AX
	MOV	DX, 03DAh
@01F1:	IN	AL, DX
	TEST	AL, 01h
	JNZ	@01F1
@01F6:	IN	AL, DX
	TEST	AL, 01
	JZ	@01F6
	LOOP	@01F1
	MOV	DX, 03D4h
	MOV	AX, 2813h
	OUT	DX, AX
	DEC	BX
	DEC	BX
        MOV     word ptr cs:Count2, BX
	RET

Count1  dw      0
Count2  dw      0
Count3  dw      0
Count4  dw      0
Count5  dw      0





