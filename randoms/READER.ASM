;ЪДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДї
;і..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..READER.COM ..ъъщщъъ.ъъщщъъ..ъъщщъъ.ъъщщъъ..і
;ГДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДґ
;і  Pulled apart by: Bushy.                                                  і
;і  Date:          24-July-1995.                                             і
;і  Current Size:  1593 bytes.                                               і
;і  Uses:          8086 instructions.                                        і
;АДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДЩ

CODE    SEGMENT
	ASSUME  CS:CODE,DS:CODE,ES:CODE,SS:CODE
	ORG     0100h
Start:
	JMP     @0184
@0103   DB       13,'   ', 13, 10, 10,'$', 26
	DB      'Not enough memory$'
@011E   DB      'Requires Ega/Vga$'
@012F   DB      'File not found$'
@013E   DB      186,  3
@0140   DW      176
@0142   DW      0
@0144   DW      0
@0146   DW      0
@0148   DW      0
@014A   DW      0
@014C   DW      0
@014E   DW      0
@0150   DB      255
@0151   DB        7
@0152   DW        0
@0154   DW        0
@0156   DB        0
@0157   DW        0
@0159   DW        3
@015B   DW        0
@015D   DW        0
@015F   DB        1,  1,'HPIQGO9', 13, 12,'NJ', 13,  3,'g',  3,127,  3,170,  3
	DB      228,  3,249,  3,')',  4,'<',  4,149,  3,160,  3,149,  3,160, 3

@0184:	CLD
	MOV     BX, 02000h
	MOV     AH, 04Ah
	INT     21h
	MOV     DX, 010Ch              ;
	JB      @01CF
	MOV     SP, 0FFFEh
	MOV     AX, CS
	ADD     AX, 01000h
	MOV     [@0142], AX            ;
	MOV     AX, 00040h
	MOV     ES, AX
	MOV     AX, 00500h
	INT     10h
	MOV     AX, 01A00h
	INT     10h
	CMP     AL, 01Ah
	JNZ     @01B9
	CMP     BL, 007h
	JZ      @01D9
	CMP     BL, 008h
	JZ      @01D9
@01B9:  MOV     AH, 012h
	MOV     BL, 010h
	INT     10h
	MOV     DX, 0011Eh             ;
	CMP     BL, 010h
	JZ      @01CF
        TEST    BYTE PTR ES:[0087h], 008h       ;
        JZ      @01D9
@01CF:  PUSH    DX
        POP     DX
        CALL    @0716
        MOV     AL, 001h
        JMP     @0363
@01D9:  MOV     BL, ES:[0049h]          ;
        CMP     BL, 007h
        JZ      @0207
        MOV     WORD PTR [@013E], 003DAh       ;
        MOV     WORD PTR [@0140], 0B800h       ;
        CMP     BL, 002h
        JZ      @0207
        OR      BL, BL
        JZ      @0207
        MOV     BYTE PTR [@0151], 017h ;
        CMP     BL, 003h
        JBE     @0207
        MOV     AX, 00003h
        INT     10h
@0207:  MOV     AX, ES:[004Ah]          ;
        MOV     [@0144], AX            ;
        SHL     AX, 01h
        MOV     [@0146], AX            ;
        PUSH    AX
        MOV     BH, 002h
        MOV     AX, 01130h
        INT     10h
        SHL     CX, 01h
        MOV     [@0154], CX            ;
        INC     DL
        XOR     DH, DH
        MOV     [@0152], DX            ;
        POP     AX
        MUL     DL
        MOV     [@0148], AX            ;
        MOV     SI, 00081h
@0232:  LODSB
        CMP     AL, 00Dh
        JZ      @0278
        CMP     AL, 02Fh
        JNZ     @0232
        MOV     BYTE PTR [SI-01], 000h
        LODSB
        CMP     AL, 00Dh
        JZ      @0278
        AND     AL, 05Fh
        CMP     AL, 057h
        JNZ     @024F
        MOV     BYTE PTR [@0150], 07Fh ;
@024F:  CMP     AL, 053h
        JNZ     @0267
        CALL    @06ED
        XOR     BH, BH
        MOV     AX, [@0154]            ;
        CMP     BX, AX
        JBE     @0261
        MOV     BX, AX
@0261:  MOV     [@0159], BX            ;
        JMP     @0232
@0267:  CMP     AL, 043h
        JNZ     @0232
        CALL    @06ED
        OR      BL, BL
        JZ      @0232
        MOV     [@0151], BL            ;
        JMP     @0232
@0278:  MOV     SI, 00081h
@027B:  LODSB
        CMP     AL, 020h
        JA      @0284
        OR      AL, AL
        JNZ     @027B
@0284:  MOV     DX, SI
        DEC     DX
@0287:  LODSB
        CMP     AL, 020h
        JNB     @0287
        MOV     BYTE PTR [SI-01], 000h
        MOV     AX, 03D00h
        INT     21h
        MOV     DX, 0012Fh             ;
        JNB     @029D
        JMP     @01CF
@029D:  MOV     [@015B], AX             ;
        CALL    @06A5
        MOV     ES, [@0140]             ;
        MOV     CX, [@0148]             ;
        SHR     CX, 01h
        XOR     DI, DI
        MOV     AH, [@0151]             ;
        MOV     AL, 020h
        REPZ
        STOSW
        MOV     BL, [@0151]             ;
        CALL    @0704
        MOV     DX, [@0152]             ;
        XCHG    DH, DL
        SHR     DH, 01h
        CALL    @070F
        PUSH    SI
        POP     SI
        XOR     BP, BP
        CALL    @060A
        MOV     [@014C], DI             ;
@02D4:  MOV     AH, 001h
        INT     16h
        JZ      @0308
        XOR     AH, AH
        INT     16h
        SUB     AL, 030h
        JB      @02ED
        CMP     AL, 009h
        JA      @02ED
        XOR     AH, AH
        CALL    @0399
        JMP     @0308
@02ED:  PUSH    DI
        PUSH    ES
        PUSH    CS
        POP     ES
        MOV     AL, AH
        MOV     DI, 00160h
        MOV     CX, 0000Ch
        REPNZ
        SCASB
        POP     ES
        POP     DI
        JNZ     @02D4
        SHL     CX, 01h
        MOV     BX, 00182h
        SUB     BX, CX
        CALL    [BX]
@0308:  CALL    @04DA
        JMP     @02D4


@030D:  MOV     BX, [@015B]             ;
        MOV     AH, 03Eh
        INT     21h
        MOV     BX, [@0146]             ;
        MOV     SI, [@014A]             ;
        MOV     AX, [@0154]             ;
        SHR     AX, 01h
        CMP     [@0157], AX             ;
        JB      @032A
        ADD     SI, BX
@032A:  XOR     DI, DI
        MOV     CX, [@0148]             ;
        SUB     CX, BX
        SHR     CX, 01h
        MOV     AH, [@0151]             ;
        XOR     AL, AL
        PUSH    DS
        MOV     DS, [@0140]             ;
        REPZ
        MOVSW
        MOV     CX, BX
        SHR     CX, 01h
        REPZ
        STOSW
        POP     DS
        XOR     BX, BX
        XOR     CX, CX
        CALL    @05C8
        XOR     BL, BL
        CALL    @0704
        MOV     DX, [@0152]             ;
        XCHG    DH, DL
        DEC     DH
        DEC     DH
        CALL    @070F
        XOR     AL, AL
@0363:  MOV     AH, 04Ch
        INT     21h
        CMP     BYTE PTR [@0156], 001h    ;
        JZ      @038E
        CALL    @04B4
        JBE     @037E
        INC     BX
        CALL    @04C1
        MOV     BYTE PTR [@0156], 001h    ;
        JMP     @038E
@037E:  RET
        CMP     BYTE PTR [@0156], 000h    ;
        JZ      @038E
        CALL    @0471
        MOV     BYTE PTR [@0156], 000h    ;
@038E:  CMP     WORD PTR [@0159], 000h   ;
        JNZ     @037E
        MOV     AX, [@0159]             ;
        INC     AX
@0399:  CMP     AX, [@0154]             ;
        JBE     @03A6
        RET
        MOV     AX, [@0159]             ;
        DEC     AX
        JS      @03A9
@03A6:  MOV     [@0159], AX             ;
@03A9:  RET
        CMP     BYTE PTR [@0156], 001h    ;
        JZ      @03CC
        CALL    @04B4
        JBE     @03E3
        INC     BX
        CALL    @04C1
        CALL    @04B4
        JA      @03C4
        CALL    @044B
        JZ      @03C7
@03C4:  CALL    @04C1
@03C7:  CALL    @0458
        JMP     @03E3
@03CC:  CALL    @04B4
        JNB     @03D6
        CALL    @044B
        JZ      @03E3
@03D6:  MOV     SI, [@014E]             ;
        CALL    @04C1
        CALL    @0458
        CALL    @0465
@03E3:  RET
        CMP     BYTE PTR [@0156], 001h    ;
        JZ      @03EF
        CALL    @0482
        RET
@03EF:  CALL    @0471
        CALL    @0482
        CALL    @0465
        RET
        MOV     WORD PTR [@0157], 00000h  ;
        CMP     BYTE PTR [@0156], 001h    ;
        JZ      @040C
        CALL    @04B4
        JA      @0414
        RET
@040C:  OR      BP, BP
        JZ      @0428
        MOV     SI, [@014E]             ;
@0414:  MOV     BX, BP
        SHR     BX, 01h
        CALL    @04C1
        CALL    @0458
@041E:  CMP     BYTE PTR [@0156], 001h    ;
        JNZ     @0428
        CALL    @0465
@0428:  RET
        MOV     BX, 0FFFFh
        CMP     BYTE PTR [@0156], 001h    ;
        JNZ     @0437
        MOV     SI, [@014E]             ;
@0437:  CALL    @0485
        JMP     @041E
@043C:  MOV     AH, 001h
        INT     16h
        JZ      @043C
        CMP     AL, 020h
        JNZ     @044A
        XOR     AH, AH
        INT     16h
@044A:  RET
@044B:  MOV     WORD PTR [@0157], 00000h  ;
        MOV     BX, BP
        SHR     BX, 01h
        OR      BX, BX
        RET
@0458:  CALL    @04B4
        INC     BX
        MOV     BYTE PTR [@015F], 001h    ;
        CALL    @04CA
        RET
@0465:  CALL    @04B4
        INC     BX
        CALL    @04C1
        MOV     [@014E], SI               ;
        RET
@0471:  CALL    @04B4
        INC     BX
        MOV     SI, [@014E]               ;
        MOV     BYTE PTR [@015F], 000h    ;
        CALL    @04CA
        RET
@0482:  CALL    @04B4
@0485:  PUSH    BX
        MOV     BYTE PTR [@015F], 000h    ;
        CALL    @04CA
        MOV     CX, BX
        CALL    @04B4
        POP     AX
        JBE     @04AA
        INC     BX
        CALL    @04C1
        CALL    @0458
        CALL    @0687
        JNB     @04B3
        MOV     AX, [@0154]             ;
        DEC     AX
        MOV     [@0157], AX             ;
        RET
@04AA:  MOV     BX, AX
        SUB     BX, CX
        JZ      @04B3
        CALL    @04C1
@04B3:  RET
@04B4:  MOV     BX, [@0152]             ;
        SHL     BX, 01h
        CMP     BP, BX
        PUSHF
        SHR     BX, 01h
        POPF
        RET
@04C1:  DEC     BP
        DEC     BP
        CALL    @05A2
        DEC     BX
        JNZ     @04C1
        RET
@04CA:  MOV     DI, [@014A]             ;
@04CE:  CALL    @0687
        JB      @04D9
        CALL    @060A
        DEC     BX
        JNZ     @04CE
@04D9:  RET
@04DA:  MOV     AX, [@0154]             ;
        MOV     BX, [@0157]             ;
        CMP     BYTE PTR [@0156], 001h    ;
        JZ      @051E
        ADD     BX, [@0159]             ;
        CMP     BX, AX
        JB      @0512
        CALL    @0687
        JNB     @04FA
        MOV     BX, AX
        DEC     BX
        JMP     @0512
@04FA:  SUB     BX, AX
        MOV     AX, [@0146]             ;
        ADD     [@014A], AX             ;
        CALL    @057D
        MOV     BYTE PTR [@015F], 001h    ;
        CALL    @060A
        MOV     [@014C], DI             ;
@0512:  MOV     [@0157], BX             ;
        MOV     CX, [@014A]             ;
        CALL    @05C8
        RET
@051E:  SUB     BX, [@0159]             ;
        JNB     @0512
        ADD     BX, AX
        OR      BP, BP
        JNZ     @052E
        XOR     BX, BX
        JMP     @0512
@052E:  CALL    @0548
        MOV     SI, [@014E]             ;
        DEC     BP
        DEC     BP
        CALL    @05A2
        MOV     DI, [@014A]             ;
        MOV     BYTE PTR [@015F], 001h    ;
        CALL    @0621
        JMP     @0512
@0548:  MOV     AX, [@0146]             ;
        MOV     DI, [@014A]             ;
        OR      DI, DI
        JNZ     @0574
        PUSH    SI
        PUSH    DS
        XOR     SI, SI
        MOV     DI, 07800h
        MOV     CX, [@0148]             ;
        SUB     DI, CX
        MOV     [@014A], DI             ;
        SHR     CX, 01h
        MOV     DS, [@0140]             ;
        REPZ
        MOVSW
        POP     DS
        POP     SI
        ADD     DI, AX
        MOV     [@014C], DI             ;
@0574:  SUB     [@014C], AX             ;
        SUB     [@014A], AX             ;
        RET
@057D:  MOV     DI, [@014C]             ;
        CMP     DI, 07800h
        JB      @05A1
        PUSH    SI
        PUSH    DS
        MOV     SI, [@014A]             ;
        XOR     DI, DI
        MOV     [@014A], DI             ;
        MOV     CX, [@0148]             ;
        SHR     CX, 01h
        MOV     DS, [@0140]             ;
        REPZ
        MOVSW
        POP     DS
        POP     SI
@05A1:  RET
@05A2:  CALL    @05BD
        SUB     SI, AX
        CMP     SI, 0071Bh
        JNB     @05B8
        PUSH    SI
        PUSH    BX
        CALL    @06BD
        POP     BX
        POP     SI
        ADD     SI, 07800h
@05B8:  MOV     [@014E], SI             ;
        RET
@05BD:  PUSH    DS
        MOV     DS, [@0142]             ;
        MOV     AX, DS:[BP+000h]
        POP     DS
        RET
@05C8:  MOV     DX, CS:[0013Eh]             ;
        CLI
@05CE:  IN      AL, DX
        TEST    AL, 008h
        JZ      @05CE
@05D3:  IN      AL, DX
        RCR     AL, 01h
        JB      @05D3
        SUB     DX, 006h
        MOV     AL, 008h
        OUT     DX, AL
        INC     DX
        SHR     BX, 01h
        MOV     AL, BL
        OUT     DX, AL
        DEC     DX
        MOV     BX, 00D0Ch
        CALL    @05F8
        DEC     DX
        MOV     BX, 00F0Eh
        MOV     CX, [@014C]             ;
        CALL    @05F8
        STI
        RET
@05F8:  SHR     CX, 01h
        MOV     AL, BL
        OUT     DX, AL
        INC     DX
        MOV     AL, CH
        OUT     DX, AL
        DEC     DX
        MOV     AL, BH
        OUT     DX, AL
        INC     DX
        MOV     AL, CL
        OUT     DX, AL
        RET

@060A:  XOR     DX, DX
        CALL    @0621
        PUSH    DS
        MOV     DS, [@0142]             ;
        MOV     DS:[BP+000h], DX
        POP     DS
        INC     BP
        INC     BP
        JNZ     @0620
        JMP     @030D


@0620:  RET
@0621:  MOV     CX, [@0144]             ;
        MOV     [@014E], SI             ;
@0629:  CMP     SI, [@015D]             ;
        JB      @0642
        CMP     WORD PTR [@015D], 0F71Bh  ;
        JB      @067B
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    DI
        CALL    @0699
        POP     DI
        POP     DX
        POP     CX
        POP     BX
@0642:  MOV     AH, [@0151]             ;
        LODSB
        INC     DX
        AND     AL, [@0150]             ;
        CMP     AL, 00Dh
        JZ      @067B
        CMP     AL, 009h
        JZ      @066A
        CMP     AL, 00Ah
        JZ      @0629
        CMP     BYTE PTR [@015F], 001h    ;
        JNZ     @0660
        STOSW
@0660:  LOOP    @0629
        CMP     BYTE PTR [SI], 00Dh
        JNZ     @0669
        INC     SI
        INC     DX
@0669:  RET
@066A:  PUSH    CX
        DEC     CX
        AND     CX, 007h
        INC     CX
        PUSH    CX
        CALL    @067B
        POP     AX
        POP     CX
        SUB     CX, AX
        JNZ     @0629
        RET
@067B:  MOV     AL, 020h
        CMP     BYTE PTR [@015F], 001h    ;
        JNZ     @0686
        REPZ
        STOSW
@0686:  RET
@0687:  CMP     SI, [@015D]             ;
        JB      @0697
        CMP     WORD PTR [@015D], 0F71Bh  ;
        JNB     @0697
        STC
        RET
@0697:  CLC
        RET
@0699:  XOR     CX, CX
        MOV     DX, 07800h
        SUB     [@014E], DX             ;
        CALL    @06B3
@06A5:  MOV     SI, 07F1Bh
        MOV     DI, 0071Bh
        CALL    @06CC
        MOV     CX, 0FFFFh
        NEG     DX
@06B3:  MOV     BX, [@015B]             ;
        MOV     AX, 04201h
        INT     21h
        RET
@06BD:  MOV     CX, 0FFFFh
        MOV     DX, 01000h
        CALL    @06B3
        MOV     SI, 0071Bh
        MOV     DI, 07F1Bh
@06CC:  PUSH    ES
        PUSH    CS
        POP     ES
        MOV     DX, SI
        MOV     CX, 03C00h
        REPZ
        MOVSW
        MOV     BX, [@015B]             ;
        MOV     CX, 07800h
        MOV     AH, 03Fh
        INT     21h
        MOV     SI, DX
        MOV     DX, AX
        ADD     AX, 07F1Bh
        MOV     [@015D], AX             ;
        POP     ES
        RET
@06ED:  XOR     BL, BL
@06EF:  LODSB
        SUB     AL, 030h
        JB      @0702
        CMP     AL, 009h
        JA      @0702
        XCHG    AL, BL
        MOV     CL, 00Ah
        MUL     CL
        ADD     BL, AL
        JMP     @06EF
@0702:  DEC     SI
        RET
@0704:  XOR     BH, BH
        MOV     CL, 004h
        SHR     BL, CL
        MOV     AH, 00Bh
        INT     10h
        RET
@070F:  XOR     BH, BH
        MOV     AH, 002h
        INT     10h
        RET
@0716:  MOV     AH, 009h
        INT     21h
        RET
        
   CODE   ENDS
END Start
