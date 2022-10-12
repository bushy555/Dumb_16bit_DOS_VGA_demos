
;bootsector version. works. good.


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 

@0100:  MOV     AX, 0A000h
@0103:  MOV     DS, AX
@0105:  MOV     AX, 0013h
@0108:  PUSH    AX
@0109:  INT     10h
@010B:  NOT     AX
@010D:  MOV     ES, AX
@010F:  in	al, 060h
	cmp	al, 1
	jne	@key
	mov	ax, 3
	int	10h
	int	19h
@key:	MOV     AH, 12h
@0111:  INT     16h
@0113:  TEST    AL, 04h
@0115:  XCHG    CX, AX
@0116:  POP     AX
@0117:  JZ      @011B
@0119:  INC     AL
@011B:  TEST    CL, 08h
@011E:  JZ      @0122
@0120:  DEC     AL
@0122:  PUSH    AX
@0123:  TEST    CL, 03h
@0126:  JZ      @0150
@0128:  MOV     AH, AL
@012A:  MOV     BX, ES
@012C:  TEST    CL, 02h
@012F:  JZ      @0134
@0131:  XOR     AH, 80h
@0134:  TEST    AH, 40h
@0137:  PUSHF
@0138:  JZ      @013C
@013A:  XCHG    BH, BL
@013C:  AND     AH, 0C0h
@013F:  JPO     @0145
@0141:  DEC     BL
@0143:  JNZ     @0149
@0145:  INC     BL
@0147:  JZ      @0141
@0149:  POPF
@014A:  JZ      @014E
@014C:  XCHG    BH, BL
@014E:  MOV     ES, BX
@0150:  MOV     CX, 013Fh
@0153:  shl	ax, 3
@0156:  ADD     AX, 00B4h
@0159:  DEC     AX
@015A:  AND     AX, 07FFh
@015D:  JCXZ    @010F
@015F:  PUSH    AX
@0160:  MOV     SI, AX
@0162:  AND     SI, +3Ch
@0165:  shr	si, 2
@0168:  ADD     SI, 0100h
@016C:  SHR     AX, 1
@016E:  btr	ax, 9
@0172:  PUSHF
@0173:  NEG     AH
@0175:  JNZ     @0179
@0177:  XCHG    AH, AL
@0179:  POPF
@017A:  JNB     @017E
@017C:  NOT     AX
@017E:  XCHG    BX, AX
@017F:  MOV     AX, ES
@0181:  CALL    @01F4
@0184:  PUSH    AX
@0185:  MOV     AX, ES
@0187:  XCHG    AL, AH
@0189:  XCHG    BL, BH
@018B:  CALL    @01F4
@018E:  POP     BX
@018F:  ADD     BX, AX
@0191:  XOR     DX, DX
@0193:  shr	bx, 6
@0196:  JNZ     @0199
@0198:  INC     BX
@0199:  MOV     AX, 0FFFh
@019C:  DIV     BX
@019E:  INC     AX
@019F:  XCHG    BX, AX
@01A0:  DEC     CX
@01A1:  MOV     DI, CX
@01A3:  XOR     DX, DX
@01A5:  MOV     AX, 0064h
@01A8:  SUB     AX, BX
@01AA:  JG      @01AD
@01AC:  XCHG    DX, AX
@01AD:  PUSH    CX
@01AE:  PUSH    AX
@01AF:  JLE     @01BC
@01B1:  XCHG    CX, AX
@01B2:  MOV     BYTE PTR [DI], 04h
@01B5:  ADD     DI, 0140h
@01B9:  LOOP    @01B2
@01BB:  XCHG    CX, AX
@01BC:  MOV     CX, BX
@01BE:  ADD     CX, CX
@01C0:  CMP     CX, 00C8h
@01C4:  JB      @01C9
@01C6:  MOV     CX, 00C7h
@01C9:  MOV     AX, CX
@01CB:  SUB     AX, DX
@01CD:  shl	ax, 3
@01D0:  PUSH    DX
@01D1:  XOR     DX, DX
@01D3:  DIV     BX
@01D5:  XCHG    BX, AX
@01D6:  MOV     DL, cs:[BX+SI]
@01D9:  MOV     [DI], DL
@01DB:  XCHG    BX, AX
@01DC:  ADD     DI, 0140h
@01E0:  POP     DX
@01E1:  LOOP    @01C9
@01E3:  POP     CX
@01E4:  JCXZ    @01EF
@01E6:  LAHF
@01E7:  MOV     [DI], AH
@01E9:  ADD     DI, 0140h
@01ED:  LOOP    @01E6
@01EF:  POP     CX
@01F0:  POP     AX
@01F1:  JMP     @0159
@01F4:  SUB     AL, BL
@01F6:  JNB     @01FA
@01F8:  NOT     AL
@01FA:  SHR     AL, 1
@01FC:  iMUL     AL
@01FE:  RET

   code    ENDS
END     start
