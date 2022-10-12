

;disassembled by bushy.  13-august-95

;not exactly perfect though. spent too long on it as it is. 


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
	mov	ax, 3
	int	10h
	xor	ax, ax
@0100:  INT     10h
@0102:  MOV     CH, 20h
@0104:  MOV     AH, 01h
@0106:  INT     10h
@0108:  ;call    @01BB
@010B:  push	0000h
@010C:  pop	fs
@010E:  push	0b800h
@0112:  pop	ds
@0113:  mov     bx, 07cch
@0116:  MOV     AX, 0026h
@0119:  mov     cx, fs:[046ch]
@011E:  XOR     CX, DI
@0120:  XOR     CX, AX
@0122:  MOV     DL, CL
@0124:  AND     DL, 7Dh
@0127:  INC     DX
@0128:  AND     CX, +0Fh
@012B:  INC     CX
@012C:  MOV     DI, BX
@012E:  MOV     BYTE PTR [DI], 0B1h
@0131:  MOV     [DI+01], DL
@0134:  SUB     DI, +50h
@0137:  LOOP    @012E
@0139:  DEC     BX
@013A:  DEC     BX
@013B:  DEC     AX
@013C:  JNZ     @0119
@013E:  MOV     DI, 0FFFEh
@0141:  mov     AX,  fs:[046Ch]
@0145:  INC     AX
@0146:  MOV     BYTE PTR [DI-02], 20h
@014A:  INC     DI
@014B:  INC     DI
@014C:  CMP     DI, 07D2h
@0150:  JNZ     @0154
@0152:  JMP     @0113
@0154:  MOV     WORD PTR [DI-02], 09C0h
@0159:  MOV     WORD PTR [DI], 09C1h
@015D:  CMP     BYTE PTR [DI+02], 0B1h
@0161:  JZ      @0196
@0163:  CMP     BYTE PTR cs:[0820h], 01h
@0168:  JZ      @01A0
@016A:  CMP     fs:[046Ch], AX
@016F:  JBE     @016A
@0171:  MOV     AH, 01
@0173:  INT     16h
@0175:  JZ      @0141
@0177:  XOR     AX, AX
@0179:  INT     16h
@017B:  CMP     AL, 1Bh
@017D:  JZ      @019A
@017F:  CMP     AL, 20h
@0181:  JNZ     @0141
@0183:  CMP     BYTE PTR cs:[0820h], 01
@0188:  JZ      @0141
@018A:  MOV     SI, DI
@018C:  ADD     SI, +50h
@018F:  MOV     BYTE PTR cs:[0820h], 01
@0194:  JMP     @0141
@0196:  XOR     AX, AX
@0198:  INT     16h
@019A:  MOV     AX, 0003h
@019D:  INT     10h
@019F:  int	19h
@01A0:  MOV     WORD PTR [SI], 0720h
@01A4:  ADD     SI, +50h
@01A7:  MOV     WORD PTR [SI], 0E00h
@01AB:  CMP     SI, 0780h
@01AF:  JB      @016A
@01B1:  MOV     BYTE PTR [SI], 20h
@01B4:  MOV     BYTE PTR cs:[0820h], 00
@01B9:  JMP     @016A
@01BB:  MOV     DX, 00C0h
@01BE:  MOV     CX, 0002h
@01C1:  MOV     BP, 01D6h
@01C4:  CALL    @01CD
@01C7:  XOR     DX, DX
@01C9:  DEC     CX
@01CA:  MOV     BP, 01F1h
@01CD:  MOV     AX, 1100h
@01D0:  MOV     BX, 0F00h
@01D3:  INT     10h
@01D5:  RET

@01D6  db	000h, 000h
@01D8  db	000h, 000h
@01DA  db	000h, 000h

@01DC  DB      060h
@01DD  DB      0F1h

@01DE db 07Fh, 07Fh 
@01E0 db 03Dh, 01Bh, 007h
@01E3 db 00Fh
@01E4 db 000h, 000h
@01E6 db 000h, 000h
@01E8 db 000h, 000h
@01EA db 03Ch, 0EAh
@01EC db 0BFh, 0FFh, 0EEh
@01EF db 0DCh, 080h, 000h, 000h
@01F3 db 000h, 000h
@01F5 db 000h, 018h
@01F7 db 03Ch, 066h
@01F9 db 0EBh, 0E7h
@01FB db 0EBh, 066h
@01FD db 03Ch, 018h
;@01FF db 000h, 000h

   code    ENDS
END     start

;09F5:01D0  BB 00 0F CD 10 C3 00 00-00 00 00 00 60 F1 7F 7F   ............`...
;09F5:01E0  3D 1B 07 0F 00 00 00 00-00 00 3C EA BF FF EE DC   =.........<.....
;09F5:01F0  80 00 00 00 00 00 18 3C-66 EB E7 EB 66 3C 18 00   .......<f...f<..

