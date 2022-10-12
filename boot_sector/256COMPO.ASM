
;dissasseblmeded thingy by Bushy. 13-august-1995.

;already works for boot sector. Isn't that good!


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 

@0100:  MOV     AX, 0013h
@0103:  INT     10h
@0105:  MOV     DX, 03D4h
@0108:  MOV     AL, 13h
@010A:  OUT     DX, AL
@010B:  INC     DX
@010C:  MOV     AL, 20h
@010E:  OUT     DX, AL
@010F:  DEC     DX
@0110:  MOV     AL, 11h
@0112:  OUT     DX, AL
@0113:  INC     DX
@0114:  IN      AL, DX
@0115:  AND     AL, 7Fh
@0117:  OUT     DX, AL
@0118:  DEC     DX
@0119:  MOV     AL, 01h
@011B:  OUT     DX, AL
@011C:  INC     DX
@011D:  MOV     AL, 3Fh
@011F:  OUT     DX, AL
@0120:  MOV     AX, 0A000h
@0123:  MOV     ES, AX
@0125:  MOV     DS, AX
@0127:  XOR     CX, CX
@0129:  MOV     AX, 070Fh
@012C:  MOV     DX, 0600h
@012F:  MOV     BX, 0003h
@0132:  XOR     DI, DI
@0134:  INC     CH
@0136:  REPZ
@0137:  STOSB
@0138:  ADD     DI, DX
@013A:  XCHG    AH, AL
@013C:  INC     CH
@013E:  REPZ
@013F:  STOSB
@0140:  XCHG    AH, AL
@0142:  DEC     BL
@0144:  JNZ     @0134
@0146:  MOV     DI, 001Fh
@0149:  MOV     DL, 18h
@014B:  MOV     CH, 08h
@014D:  MOV     CL, DL
@014F:  MOV     BYTE PTR [BX], 07h
@0152:  MOV     BYTE PTR [BX+DI], 0Fh
@0155:  INC     BH
@0157:  DEC     CL
@0159:  JNZ     @014F
@015B:  SUB     BX, 17E0h
@015F:  DEC     CH
@0161:  JNZ     @014D
@0163:  MOV     AX, 0FF01h
@0166:  MOV     BX, 04440h
@0169:  MOV     DX, 09608h
@016C:  PUSH    AX
@016D:  PUSH    DX
@016E:  MOV     DX, 03DAh
@0171:  IN      AL, DX
@0172:  TEST    AL, 08h
@0174:  JZ      @0171
@0176:  POP     DX
@0177:  MOV     AH, 01h
@0179:  INT     16h
@017B:  JZ      @01A0
@017D:  XOR     AH, AH
@017F:  INT     16h
@0181:  CMP     AH, 01h
@0184:  JZ      @01F9
@0186:  CMP     AH, 4Bh
@0189:  JNZ     @0193
@018B:  CMP     DL, 00h
@018E:  JBE     @01A0
@0190:  SUB     DL, 04h
@0193:  CMP     AH, 4Dh
@0196:  JNZ     @01A0
@0198:  CMP     DL, 0DEh
@019B:  JNB     @01A0
@019D:  ADD     DL, 04h
@01A0:  XOR     AX, AX
@01A2:  MOV     CL, 0A0h
@01A4:  MOV     DI, 9600h
@01A7:  REPZ
@01A8:  STOSW
@01A9:  MOV     AL, 04h
@01AB:  MOV     DI, DX
@01AD:  MOV     CL, 0Fh
@01AF:  REPZ
@01B0:  STOSW
@01B1:  POP     AX
@01B2:  MOV     BYTE PTR [BX], 00h
@01B5:  ADD     BL, AL
@01B7:  ADD     BH, AH
@01B9:  TEST    BH, 0FFh
@01BC:  JNZ     @01C0
@01BE:  NEG     AH
@01C0:  OR      BL, 00h
@01C3:  JNZ     @01C7
@01C5:  NEG     AL
@01C7:  OR      BYTE PTR [BX], 00h
@01CA:  JZ      @01F1
@01CC:  PUSH    AX
@01CD:  MOV     DI, BX
@01CF:  AND     DI, 0F8E0h
@01D3:  MOV     AH, 08h
@01D5:  MOV     CL, 20h
@01D7:  XOR     AL, AL
@01D9:  REPZ
@01DA:  STOSB
@01DB:  ADD     DI, 00E0h
@01DF:  DEC     AH
@01E1:  JNZ     @01D5
@01E3:  POP     AX
@01E4:  OR      BYTE PTR [BX+0FF00h], 00h
@01E9:  JNZ     @01EF
@01EB:  NEG     AH
@01ED:  NEG     AL
@01EF:  NEG     AL
@01F1:  MOV     BYTE PTR [BX], 0Fh
@01F4:  PUSH    AX
@01F5:  PUSH    DX
@01F6:  JMP     @016E
@01F9:  POP     AX
@01FA:  MOV     AX, 0003h
@01FD:  INT     10h
@01FF:  RET

   code    ENDS
END     start
