

;********* File: ADLIB.COM *************
;
    code     SEGMENT
             ASSUME CS:code,  DS:code
             ORG 100h
             .386
  
    strt:
start   equ     $ - 0100h

	CLD	
	JMP	J00545
J00104: CALL	J0010A
        ADD     AH, 03h
J0010A: LODSB	
J0010B: PUSH	AX 
	PUSH	CX 
        XCHG    AL, AH
        MOV     DX , 0388h
        OUT     DX, AL
        MOV     CX , 0007h
	CALL	J00128
        MOV     DX , 0389h
        MOV     AL, AH
        OUT     DX, AL
        MOV     CX , 001Eh
	CALL	J00128
	POP	CX 
	POP	AX 
	RETN	
J00128: IN      AL, DX
	LOOP	J00128
	RETN	
J0012C: MOV     AH, [BX+06B8h]
        MOV     CX , 0004h
J00133: CALL	J00104
        ADD     AH, 1Dh
	LOOP	J00133
        ADD     AH, 40h
	CALL	J00104
        MOV     AH, BL
        ADD     AH, 0C0h
	JMP	J0010A
J00148: PUSH	BX 
        XCHG    AH, BL
        ADD     AH, 0A0h
	CALL	J0010B
        MOV     AL, BL
        ADD     AH, 10h
	POP	BX 
	JMP	J0010B
J00159: MOV     AX , 0120h
	CALL	J0010B
        MOV     AX , 0800h
	CALL	J0010B
        MOV     AH , 0BDh
	CALL	J0010B
        MOV     BP , 0009h
        XOR     BX, BX
        MOV     DI , 0712h
J00172: MOV     SI, [DI]
        ADD     DI, +02h
	CALL	J0012C
        XOR     AX, AX
        CALL    J00148
	INC	BX 
	DEC	BP 
	JNZ	J00172
	RETN	
J00184: SUB     WORD PTR [start + 0571Ch], +01h
	JNB	J001DE
        MOV     WORD PTR [start + 0571Ch], 0008h
        MOV     CX , 0008h
        MOV     DI , 0759h
        XOR     BX, BX
J00199: SUB     BYTE PTR [BX+571Eh], 01h
	JNS	J001D8
        MOV     SI, [DI]
        XOR     AX, AX
	CALL	J00148
J001A7: LODSB	
        OR      AL, AL
	JZ	J001DF
	JNS	J001B5
        SUB     AL, 81h
        MOV     [BX+5727h], AL
	LODSB	
J001B5: MOV     DL, AL
        AND     AX, 000Fh
        MOV     BP, AX
        ADD     BP, BP
        MOV     AX, DS:[BP+06C1h]
        SHR     DL, 02h
        AND     DL, 0FCh
        ADD     AH, DL
	CALL	J00148
        MOV     AL, [BX+5727h]
        MOV     [BX+571Eh], AL
        MOV     [DI], SI
J001D8: ADD     DI, +04h
	INC	BX 
	LOOP	J00199
J001DE: RETN	
J001DF: MOV     SI, [DI+02h]
	JMP	J001A7
J001E4: ADD     AX, [BX]
        MOV     [BX], AX
J001E8: ADD     AX, 4000h
J001EB: MOV     BX, AX
        MOV     CX, BX
        AND     CX, 03FFh
	NEG	CX
        ADD     CX, 03FFh
        SHR     BX, 0Ah
        MOV     AH, [BX+065Fh]
        XOR     AL, AL
	IMUL	CX
	PUSH	AX 
	PUSH	DX 
        MOV     AH, [BX+0660h]
        XOR     AL, AL
	NEG	CX
        ADD     CX, 03FFh
	IMUL	CX
	POP	BX 
	POP	CX 
        ADD     AX, CX
        ADC     DX, BX
        shrd    ax, dx, 0bh
        ret

J0021f: mov     eax, 041fbf0e7h
        mul     dword ptr [start + 0573ah]
        add     eax, 000017b99h
        mov     dword ptr [start + 0573ah], eax
        shr     eax, 0fh
        and     ax, 01fffh
        sub     ax, 01000h
        add     bx, 00002h
        mov     [bx], ax
        retn

J00244: mov     eax, dword ptr fs:[020h]
        mov     dword ptr [start + 05736h], eax
        mov     ax, cs
        shl     eax, 010h
        MOV     AX , 0275h
        MOV     DX , 4268h
	JMP	SHORT J00261
J0025B:
        MOV     eAX, dword ptr [start + 5736h]
        XOR     DX, DX
J00261: CLI	
        MOV     dword ptr fs:[0020h], eAX
        MOV     AL , 36h
        OUT     43h, AL
        MOV     AL, DL
        OUT     40h, AL
        MOV     AL, DH
        OUT     40h, AL
	STI	
	RETN	
J00275: push    ax
        mov     al, 020h
        out     20h, al
        inc     word ptr cs:[05734h]
        pop     ax
        iret

J00281: MOV     DX , 03C8h
        XOR     AL, AL
        OUT     DX, AL
	INC	DX 
        MOV     CX , 0008h
J0028B: XOR     BH, BH
        MOV     BL, [SI]
        SHR     BL, 02h
	CALL	J002A1
        MOV     BL, [SI]
        SHL     BX, 02h
	CALL	J002A1
	INC	SI 
	LOOP	J0028B
	RETN	
J002A1: AND     BX, +1Eh
        MOV     AX, [BX+06D9h]
        OUT     DX, AL
        MOV     AL, AH
        OUT     DX, AL
        MOV     AL, [BX+06DBh]
        OUT     DX, AL
	RETN	
J002B2:
        XOR     eDX, eDX
        MOV     SI , 1B60h
        MOV     BX , 0004h
        MOV     CX , 00C8h
        MOV     DI , 0FFFCh
J002C1: MOV     BP , 0005h
J002C4:
        MOV     eAX, [SI]
        ADD     DI, BX
        MOV     [SI], eDX
        ADD     SI, BX
        MOV     ES:[DI], eAX
        MOV     eAX, [SI]
        ADD     DI, BX
        MOV     [SI], eDX
        ADD     SI, BX
        MOV     ES:[DI], eAX
	DEC	BP 
	JNZ	J002C4
        ADD     SI, BX
	DEC	CX 
	JNZ	J002C1
	RETN	

;@02E8:  RET

@02E9:  MOV     AL,[SI+0FFFh]
@02ED:  OR      [DI],AL
@02EF:  RET
@02F0:  MOV     AX,[SI+177Fh]
@02F4:  OR      [DI],AX
@02F6:  OR      [DI+2Ch],AX
@02F9:  CMP     BP,206Ch
@02FD:  JL      @0315
@02FF:  MOV     AX,[SI+14FFh]
@0303:  OR      [DI-2Ch],AX
@0306:  OR      [DI+58h],AX
@0309:  MOV     AX,[SI+127Fh]
@030D:  OR      [DI-58h],AX
@0310:  OR      [DI+0084h],AX
@0314:  RET
@0315:  OR      [DI-2Ch],AX
@0318:  OR      [DI+58h],AX
@031B:  MOV     AX,[SI+14FFh]
@031F:  OR      [DI-58h],AX
@0322:  OR      [DI+0084h],AX
@0326:  RET

J00327: SUB     BX, +41h
	JB	J00386
        SHL     BX, 03h
        MOV     DI, word ptr [start + 05730h]
        MOV     CX , 0008h
J00336: PUSH	CX 
	PUSH	SI 
        MOV     CX , 0008h
J0033B: CMP     BYTE PTR [BX+3F20h], 00h
	JZ	J0036F
        MOV     [DI+4920h], SI
        MOV     [DI+4922h], BP
	PUSH	SI 
        ADD     SI, word ptr [start + 05718h]
        SAR     SI, 06h
        AND     SI, +3Fh
        MOV     AL, [SI+065Fh]
	CBW	
	POP	SI 
        SHL     AX, 02h
        MOV     [DI+4924h], AX
        MOV     WORD PTR [DI+4926h], 02F0h
        ADD     DI, +08h
        AND     DI, 07FFh
J0036F: INC	BX 
        ADD     SI, 0080h
	LOOP	J0033B
	POP	SI 
        ADD     BX, 0138h
        ADD     BP, 0080h
	POP	CX 
	LOOP	J00336
        MOV     word ptr [start + 05730h], DI
J00386: RETN	
J00387: PUSH	AX 
	CALL	J001EB
        MOV     [DI+04h], AX
	NEG	AX
        MOV     [DI+02h], AX
	POP	AX 
	CALL	J001E8
        MOV     [DI], AX
        MOV     [DI+06h], AX
	RETN	
J0039D: PUSH	BX 
        MOV     AX, DI
	IMUL	WORD PTR [SI]
        MOV     CX, AX
        MOV     BX, DX
        MOV     AX, BP
	IMUL	WORD PTR [SI+02h]
        ADD     CX, AX
        ADC     BX, DX
        shrd    cx, bx, 0eh
        pop     bx
        add     si, 4
        retn
J003B8: MOV     DX , 03DAh
J003BB: IN      AL, DX
        TEST    AL, 08h
	JNZ	J003BB
J003C0: IN      AL, DX
        TEST    AL, 08h
	JZ	J003C0
        MOV     SI, word ptr [start + 0710h]
	PUSH	SI 
	CALL	J00281
	POP	SI 
        ADD     SI, +09h
        CMP     SI, 0707h
	JBE	J003DA
        MOV     SI , 06ECh
J003DA: MOV     word ptr [start + 0710h], SI
        MOV     AL , 02h
        MOV     AH, [SI+08h]
        MOV     DX , 03C4h
        OUT     DX, AX
	CALL	J002B2
        XOR     CX, CX
        MOV     WORD PTR [start + 05732h], 0000h
        XCHG    CX, word ptr [start + 05734h]
	JCXZ	J00404
J003F8: PUSH	CX 
        ADD     WORD PTR [start + 05732h], +5Ah
	CALL	J004A7
	POP	CX 
	LOOP	J003F8
J00404: MOV     CX , 01BCh
        MOV     BX , 4920h
@040A:  PUSH    CX
	PUSH	BX 
        MOV     BP, [BX+02h]
        MOV     DI, [BX+04h]
        CMP     WORD PTR [BX+06h], 02F0h
	JNZ	J00443
        MOV     CX, [BX]
        MOV     SI, word ptr [start + 0571Ah]
        ADD     SI, CX
        SAR     SI, 07h
        AND     SI, +3Fh
        MOV     AL, [SI+065Fh]
	CBW	
        SHL     AX, 02h
        ADD     BP, AX
        SUB     CX, word ptr [start + 05732h]
        MOV     [BX], CX
        CMP     CX, 0F0C4h
	JL	J0049C
        CMP     CX, 0F3Ch
	JG	J0049C
J00443: MOV     SI , 5700h
	CALL	J0039D
	PUSH	CX 
	CALL	J0039D
	POP	DI 
        MOV     BP, [BX]
        MOV     SI , 5708h
	PUSH	CX 
	CALL	J0039D
	PUSH	CX 
	CALL	J0039D
	POP	BP 
	POP	DI 
        ADD     BP, word ptr [start + 05710h]
        CMP     BP, 0400h
	JL	J0049C
        MOV     AX , 0100h
	IMUL	DI
	IDIV	BP
        ADD     AX, 0064h
        MOV     DI, AX
        MOV     AX , 0133h
	IMUL	CX
	IDIV	BP
        ADD     AX, 00A0h
        MOV     SI, AX
        MOV     AX, [BX+06h]
        CMP     SI, 013Fh
	JA	J0049C
        CMP     DI, 00C7h
	JA	J0049C
        ADD     DI, DI
        MOV     DI, [DI+0AFFh]
        ADD     SI, SI
        ADD     DI, [SI+0D7Fh]
        CALL    ax                      ; J000FF
J0049C: POP	BX 
	POP	CX 
        ADD     BX, +08h
	DEC	CX 
        jne     @040A
        ret
J004A7: ADD     WORD PTR [start + 05718h], +46h
        ADD     WORD PTR [start + 0571Ah], 00B1h
        ADD     dWORD PTR [start + 0657h], 00000BB8h
        MOV     BX , 5716h
        MOV     AX , 004Dh
	CALL	J001E4
        SAR     AX, 05h
        MOV     word ptr [start + 05712h], AX
        MOV     BX , 065Dh
        MOV     AX , 0172h
	CALL	J001E4
        SAR     AX, 03h
        ADD     AX, 22B8h
        MOV     word ptr [start + 05710h], AX
        MOV     BX , 5714h
        MOV     AX, word ptr [start + 05712h]
	CALL	J001E4
        IMUL    WORD PTR [start + 00659h]
        shrd    ax, dx, 8
        mov     di, 05700h
	CALL	J00387
        MOV     BX , 065Bh
        MOV     AX , 00C8h
	CALL	J001E4
        SAR     AX, 1
        MOV     DI , 5708h
	CALL	J00387
        SUB     WORD PTR [start + 0655h], +5Ah
	JNB	J00542
        MOV     WORD PTR [start + 00655h], 03FFh
        MOV     SI, word ptr [start + 0653h]
        MOV     BL, [SI]
        AND     BX, 00FFh
	JZ	J0053B
	INC	SI 
        MOV     word ptr [start + 00653h], SI
        CMP     BL, 20h
	JGE	J00530
        SHL     BX, 09h
        MOV     word ptr [start + 00655h], BX
	JMP	SHORT J00542
J00530: MOV     BP , 0000h
        MOV     SI , 1004h
	CALL	J00327
	JMP	SHORT J00542
J0053B: MOV     SI , 0833h
        MOV     word ptr [start + 00653h], SI
J00542: JMP	J00184
J00545: PUSH	CS 
	PUSH	CS 
	POP	DS 
	POP	ES 
        MOV     CX , 2627h
        MOV     DI , 0AFFh
        XOR     AX, AX
	REPZ    STOSW	
        MOV     DX , 0A000h
        MOV     ES, DX
	PUSH	SP 
	POP	DX 
        CMP     DX, SP
	JZ	J00561
J0055E: JMP	J00642

J00561: MOV     BX , 0AFFh
        .386p
        sgdt    [BX]
        CMP     BYTE PTR [BX+05h], 00h
	JS	J0055E
        MOV     FS, AX
        MOV     AX , 1A00h
        INT     10h                              ; Video Function Call
        CMP     AL, 1Ah
        jne     J00642
        cmp     bl, 7
        jb      J00642
        mov     ax, 013h
        int     10h                              ; Video Function Call
        mov     cx, 0001ah
        MOV     BX , 0010h
        MOV     AX , 0E41h
J0058F: INT     10h                              ; Video Function Call
	INC	AL
	LOOP	J0058F
        MOV     CX , 0500h
        MOV     BX , 3F20h
        XOR     DI, DI
J0059D: MOV     AX, ES:[DI]
        MOV     [BX+DI], AX
        ADD     DI, +02h
	LOOP	J0059D
        MOV     AX , 000Dh
        INT     10h                              ; Video Function Call
        MOV     SI , 0FFFEh
        MOV     DI , 1B34h
        MOV     BL , 80h
        XOR     BP, BP
	JMP	SHORT J005E1
J005B8: MOV     [SI+0AFFh], DI
        MOV     [SI+0FFFh], BL
        MOV     [SI+177Fh], CX
        SHR     CL, 1
        RCR     CH, 1
        MOV     [SI+14FFh], DX
        SHR     DL, 1
        RCR     DH, 1
        MOV     [SI+127Fh], AX
        SHR     AL, 1
        RCR     AH, 1
        MOV     [SI+0D7Fh], BP
        ROR     BL, 1
	JNB	J005EA
	INC	BP 
J005E1: MOV     CX , 00FEh
        MOV     DX , 007Ch
        MOV     AX , 0038h
J005EA: ADD     DI, +2Ch
        ADD     SI, +02h
        CMP     SI, 0280h
	JLE	J005B8
        MOV     DX , 03DAh
        IN      AL, DX
        MOV     DL , 0C0h
        XOR     AX, AX
        MOV     CX , 0010h
J00601: OUT     DX, AL
        OUT     DX, AL
	INC	AL
	LOOP	J00601
        MOV     AL , 20h
        OUT     DX, AL
        MOV     CX , 01BCh
        MOV     BX , 491Eh
J00610: PUSH	CX 
	CALL	J0021F
	CALL	J0021F
	CALL	J0021F
        SAR     AX, 02h
        MOV     [BX], AX
        ADD     BX, +02h
        MOV     WORD PTR [BX], 02E9h
	POP	CX 
	LOOP	J00610
	CALL	J00159
	CALL	J00244
J0062F: CALL	J003B8
        MOV     AH , 01h
        INT     16h
	JZ	J0062F
        MOV     AH , 00h
        INT     16h
	CALL	J0025B
	CALL	J00159
J00642: MOV     AX , 0003h
        INT     10h                              ; Video Function Call
        MOV     AH , 09h
        MOV     DX , 0927h
        INT     21h                              ; DOS Function Call
        MOV     AX , 4C00h
        INT     21h                              ; DOS Function Call

db 033h,008h,001h,000h,000h,000h,040h,000h,0E0h,0B1h,080h,03Eh,000h
db 00Ch,018h,024h,030h,03Bh,046h,050h,059h,062h,069h,070h,075h,079h,07Ch,07Eh,07Fh
db 07Eh,07Ch,079h,075h,070h,069h,062h,059h,050h,046h,03Bh,030h,024h,018h,00Ch,000h
db 0F4h,0E8h,0DCh,0D0h,0C5h,0BAh,0B0h,0A7h,09Eh,097h,090h,08Bh,087h,084h,082h,081h
db 082h,084h,087h,08Bh,090h,097h,09Eh,0A7h,0B0h,0BAh,0C5h,0D0h,0DCh,0E8h,0F4h,000h
db 003h,006h,009h,00Ch,00Fh,012h,015h,018h,01Bh,01Eh,021h,024h,027h,02Ah,02Dh,030h
db 033h,036h,039h,03Bh,03Eh,041h,043h,046h,020h,021h,022h,028h,029h,02Ah,030h,031h
db 032h,06Bh,021h,081h,021h,098h,021h,0B0h,021h,0CAh,021h,0E5h,021h,002h,022h,020h
db 022h,041h,022h,063h,022h,087h,022h,064h,023h,000h,000h,000h,000h,000h,00Fh,023h
db 000h,010h,01Eh,030h,000h,020h,02Dh,037h,000h,03Ch,03Dh,03Eh,004h,034h,024h,034h
db 014h,034h,024h,034h,001h,003h,023h,013h,023h,044h,044h,044h,044h,008h,002h,012h
db 044h,044h,033h,033h,044h,044h,004h,001h,044h,033h,044h,022h,044h,033h,044h,002h
db 0ECh,006h,04Eh,007h,02Dh,007h,043h,007h,038h,007h,038h,007h,022h,007h,022h,007h
db 043h,007h,041h,0C2h,006h,000h,023h,0F2h,0F0h,0F0h,001h,000h,004h,091h,040h,087h
db 080h,0F3h,06Fh,023h,003h,001h,001h,002h,0E1h,021h,011h,080h,011h,013h,022h,022h
db 000h,000h,00Ch,061h,021h,01Bh,000h,062h,084h,056h,055h,000h,000h,00Eh,091h,040h
db 087h,088h,0F3h,06Fh,023h,003h,001h,001h,002h,079h,007h,07Ah,007h,08Bh,007h,08Ch
db 007h,09Dh,007h,0B0h,007h,0C1h,007h,0C1h,007h,0D9h,007h,0D9h,007h,0F2h,007h,0F2h
db 007h,006h,008h,006h,008h,01Ah,008h,01Ah,008h,081h,057h,050h,050h,055h,057h,050h
db 055h,057h,050h,055h,057h,050h,055h,057h,050h,055h,000h,081h,050h,055h,057h,050h
db 055h,057h,050h,055h,057h,050h,055h,057h,050h,055h,057h,050h,000h,0C0h,050h,084h
db 030h,020h,030h,020h,02Ah,01Ah,02Ah,01Ah,030h,020h,030h,020h,02Ah,01Ah,02Ah,01Ah
db 030h,020h,030h,020h,02Ah,01Ah,02Ah,01Ah,025h,015h,025h,015h,028h,018h,02Ah,01Ah
db 000h,0A0h,050h,040h,0C0h,040h,088h,040h,040h,03Ah,042h,090h,045h,088h,040h,042h
db 040h,047h,090h,04Ah,088h,045h,098h,040h,000h,0A0h,050h,030h,0C0h,047h,088h,047h
db 043h,042h,045h,047h,045h,048h,047h,047h,050h,052h,084h,050h,04Ah,088h,050h,098h
db 045h,000h,0C0h,020h,0A0h,010h,010h,090h,010h,02Ah,025h,088h,028h,02Ah,090h,010h
db 02Ah,025h,088h,028h,02Ah,000h,0C0h,020h,0A0h,020h,020h,090h,020h,01Ah,015h,088h
db 018h,01Ah,090h,020h,01Ah,015h,088h,018h,01Ah,000h,0C0h,00Ch,0FEh,050h,090h,00Ch
db 081h,04Ah,050h,084h,052h,055h,086h,04Ah,081h,050h,04Ah,086h,050h,082h,055h,098h
db 045h,000h,0FCh,01Eh,019h

        DB      "     BUSHY HERE... ROCKING THE COMMUNITY ONCE" ;00835
	DB	" AGAIN...                                    "	;00862
	DB	"                                             "	;0088F
	DB	"                                             "	;008BC
	DB	"                                             "	;008E9
	DB	"                                             "	;00916
	DB	"                                             "	;00943
	DB	"                                             "	;00970
	DB	"                                             "	;0099D
	DB	"                                             "	;009CA
	DB	"                                             "	;009F7
	DB	"                                             "	;00A24
	DB	"                                             "	;00A51
	DB	"                                             "	;00A7E
	DB	"                                             "	;00AAB
	DB	"                               "	;00AD8
        DB      0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, "$", 0FCh, 00h

    code     ENDS
             END  strt
   
