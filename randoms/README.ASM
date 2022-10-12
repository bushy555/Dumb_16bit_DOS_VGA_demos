
code    SEGMENT PARA PUBLIC 'code'
        ASSUME cs:code, ds:code, es:code, ss:code
        org     100h
.386
start: 


@0100:  MOV     SP, 13CBh
@0103:  PUSH    DS
@0104:  SUB     AX, AX
@0106:  PUSH    AX
@0107:  MOV     [@0171], SP
@010B:  MOV     AH, 30h
@010D:  INT     21h
@010F:  CMP     AL, 02
@0111:  JNB     @0119
@0113:  MOV     DX, 0EF8h
@0116:  JMP     @0304
@0119:  CALL    @0BC3
@011C:  CALL    @0BE3
@011F:  CALL    @0C05
@0122:  CALL    @0B8E
@0125:  JMP     @01EE

@0128 db 070h
@0129 db 000h
@012A db 030h
@012b db 000h
@012C db 030h
@012d db 007h
@012E db 000h
@012f dw 000h, 0           ;;
@0131 dw 000h, 0           ;;
@0133 db 000h
@0134 db 000h
@0135 db 000h
@0136 db 000h,  000h
@0138 db 000h,  000h
@013A db 000h,  000h
@013C db 000h,  000h
@013E db 000h,  000h
@0140 db 000h,  000h
@0142 db 000h,  000h
@0144 db 000h,  000h
@0146 db 000h,  000h
@0148 db 000h,  000h
@014A db 000h,  000h
@014C db 000h,  000h
@014E db 000h,  000h
@0150 db 000h,  000h
@0152 db 000h,  000h
@0154 db 000h,  000h
@0156 db 000h,  000h
@0158 db 000h,  000h
@015A db 000h,  000h
@015C db 000h,  000h
@015E db 000h,  000h
@0160 db 000h,  000h
@0162 db 000h,  000h
@0164 db 000h,  000h
@0166 db 000h
@0167 dw 000h, 000
@0169 db 000h
@016A db 000h
@016B db 000h
@016C db 000h
@016D db 000h
@016E db 000h
@016F dw  000h, 000
@0171 dw 000h, 000
@0173 db 0FBh
@0174 db 00Dh,  000h,  000h
@0177 db 000h,  000h
@0179 db 000h,  000h
@017B db 002h
@017C db 001h           ;;;
@017D db 002h
@017E db 000h           ;;;;
@017F db 000h,  000h
@0181 db 000h,  000h
@0183 db 000h,  000h
@0185 db 000h,  000h
@0187 db 010h,  000h
@0189 db 000h,  000h
@018B db 001h,  000h
@018D db 001h,  02Ah
@018F db 046h
@0190 db 04Ch
@0191 db 041h
@0192 db 047h
@0193 db 02Ah
@0194 db 008h
@0195 db 000h,  020h
@0197 db 020h,  020h
@0199 db 020h,  020h
@019B db 020h,  020h
@019D db 020h,  020h
@019F db 020h,  020h
@01A1 db 020h,  020h
@01A3 db 020h,  020h
@01A5 db 020h,  020h
@01A7 db 020h,  020h
@01A9 db 020h,  020h
@01AB db 020h,  020h
@01AD db 020h,  020h
@01AF db 020h,  020h
@01B1 db 020h,  020h
@01B3 db 020h,  020h
@01B5 db 020h,  020h
@01B7 db 020h,  020h
@01B9 db 020h,  020h
@01BB db 020h,  020h
@01BD db 020h,  020h
@01BF db 020h,  020h
@01C1 db 020h,  020h
@01C3 db 020h,  020h
@01C5 db 020h,  020h
@01C7 db 020h,  020h
@01C9 db 020h,  020h
@01CB db 020h,  020h
@01CD db 020h,  020h
@01CF db 020h,  020h
@01D1 db 020h,  020h
@01D3 db 020h,  020h
@01D5 db 020h,  020h
@01D7 db 020h,  020h
@01D9 db 020h,  020h
@01DB db 020h,  020h
@01DD db 020h,  020h
@01DF db 020h,  020h
@01E1 db 020h,  020h
@01E3 db 020h,  020h
@01E5 db 020h,  025h
@01E7 db 00Fh
@01E8 db 034h,  00Fh
@01EA db 043h
@01EB db 00Fh
@01EC db 052h
@01ED db 00Fh




@01EE:  PUSH    ES
@01EF:  MOV     AH, 08
@01F1:  SUB     BX, BX
@01F3:  INT     10h
@01F5:  MOV     [@012D], AH
@01F9:  MOV     AH, 0Fh
@01FB:  INT     10h
@01FD:  MOV     [@012B], BH
@0201:  MOV     [@0129], BH
@0205:  MOV     AX, 0040h
@0208:  MOV     ES, AX
@020A:  MOV     CX, byte ptr es:[004Ah]
@020F:  MOV     [@0167], CX
@0213:  MOV     [@016F], CX
@0217:  INC     WORD PTR [@016F]
@021B:  MOV     DX, byte ptr es:[0063h]
@0220:  ADD     DX, +06h
@0223:  MOV     [@016B], DX
@0227:  MOV     WORD PTR [@0169], 0B800h
@022D:  CMP     BYTE PTR es:[0049h], 07h
@0233:  JNZ     @0245
@0235:  MOV     WORD PTR [@0169], 0B000h
@023B:  OR      BYTE PTR [@0194], 20h
@0240:  MOV     BYTE PTR [@018D], 00
@0245:  PUSH    BP
@0246:  SUB     DL, DL
@0248:  SUB     BH, BH
@024A:  MOV     AX, 1130h
@024D:  INT     10h
@024F:  OR      DL, DL
@0251:  JZ      @0258
@0253:  MOV     BYTE PTR [@018D], 00
@0258:  POP     BP
@0259:  MOV     CX, 4445h
@025C:  MOV     DX, 5351h
@025F:  MOV     AX, 2B01h
@0262:  INT     21h
@0264:  CMP     AL, 0FFh
@0266:  JZ      @0276
@0268:  MOV     ES, [@0169]
@026C:  SUB     DI, DI
@026E:  MOV     AH, 0FEh
@0270:  INT     10h
@0272:  MOV     [@0169], ES
@0276:  POP     ES
@0277:  MOV     AX, [@0167]
@027A:  ADD     AX, AX
@027C:  MOV     CX, 0018h
@027F:  MUL     CX
@0281:  MOV     [@016D], AX
@0284:  CALL    @0ADD
@0287:  CALL    @0B5D
@028A:  JMP     @030D
@028D:  MOV     SP, [@0171]
@0291:  MOV     BX, [@0185]
@0295:  MOV     AH, 3Eh
@0297:  INT     21h
@0299:  MOV     AH, 4Fh
@029B:  INT     21h
@029D:  OR      AL, AL
@029F:  JNZ     @02D1
@02A1:  MOV     SI, [@0173]
@02A5:  CALL    @0C36
@02A8:  CALL    @0ACE
@02AB:  SUB     AX, AX
@02AD:  MOV     [@012F], AX
@02B0:  MOV     BYTE PTR [@017B], 02h
@02B5:  MOV     BYTE PTR [@017C], 01h
@02BA:  MOV     [@017E], AL
@02BD:  JMP     @0284
@02BF:  MOV     SP, [@0171]
@02C3:  MOV     AL, [@012D]
@02C6:  MOV     [@012A], AL
@02C9:  CALL    @0ACE
@02CC:  MOV     DX, 0000
@02CF:  JMP     @02F8
@02D1:  MOV     SP, [@0171]
@02D5:  MOV     DI, 11CBh
@02D8:  MOV     CX, [@0167]
@02DC:  MOV     AL, 20h
@02DE:  REPZ
@02DF:  STOSB
@02E0:  MOV     DX, 1901h
@02E3:  MOV     CX, [@0167]
@02E7:  MOV     SI, 11CBh
@02EA:  MOV     BH, [@012D]
@02EE:  MOV     [@012A], BH
@02F2:  CALL    @0923
@02F5:  MOV     DX, 1700h
@02F8:  CALL    @0B85
@02FB:  MOV     ES, [@0183]
@02FF:  MOV     AH, 49h
@0301:  INT     21h
@0303:  RETF
@0304:  MOV     SP, [@0171]
@0308:  MOV     AH, 09h
@030A:  INT     21h
@030C:  RETF
@030D:  CALL    @0753
@0310:  MOV     AL, [@012A]
@0313:  MOV     [@017D], AL
@0316:  JNZ     @031B
@0318:  JMP     @03FA
@031B:  DEC     BYTE PTR [@017B]
@031F:  CMP     BYTE PTR [@018B], 00
@0324:  JZ      @032F
@0326:  INC     BYTE PTR [@017B]
@032A:  MOV     BYTE PTR [@017C], 01
@032F:  MOV     AX, [@012F]
@0332:  TEST    BYTE PTR [@0194], 01
@0337:  JZ      @0341
@0339:  AND     BYTE PTR [@0194], 0FEh
@033E:  JMP     @03FA
@0341:  CALL    @07E9
@0344:  MOV     AH, 01
@0346:  INT     16h
@0348:  JZ      @0355
@034A:  MOV     BYTE PTR [@0E48], 01
@034F:  NOP
@0350:  CMP     AH, 4Bh
@0353:  JNZ     @0373
@0355:  MOV     CX, [@0179]
@0359:  ADD     [@017C], CL
@035D:  MOV     DH, [@017B]
@0361:  CMP     DH, 19h
@0364:  JNZ     @031B
@0366:  CMP     BYTE PTR [@018B], 00
@036B:  JZ      @031B
@036D:  MOV     BYTE PTR [@0E48], 00
@0372:  NOP
@0373:  MOV     AH, 01
@0375:  INT     16h
@0377:  JZ      @0386
@0379:  MOV     AH, 00
@037B:  INT     16h
@037D:  TEST    BYTE PTR [@0194], 40h
@0382:  JNZ     @0373
@0384:  JMP     @038A
@0386:  MOV     AH, 00
@0388:  INT     16h
@038A:  MOV     SI, 019Eh
@038D:  CALL    @0B75
@0390:  CMP     AL, 00
@0392:  JNZ     @03A2
@0394:  XCHG    AL, AH
@0396:  MOV     DI, 0F96h
@0399:  MOV     BP, 0FEAh
@039C:  MOV     CL, 15h
@039E:  NOP
@039F:  NOP
@03A0:  JMP     @03B2
@03A2:  CMP     AL, 61h
@03A4:  JL      @03A8
@03A6:  SUB     AL, 20h
@03A8:  MOV     DI, 0F7Ah
@03AB:  MOV     BP, 0FB2h
@03AE:  MOV     CL, 1Ch
@03B0:  NOP
@03B1:  NOP
@03B2:  MOV     SI, DI
@03B4:  SUB     CH, CH
@03B6:  PUSH    DS
@03B7:  POP     ES
@03B8:  REPNZ
@03B9:  SCASB
@03BA:  JNZ     @03C6
@03BC:  DEC     DI
@03BD:  SUB     DI, SI
@03BF:  SHL     DI, 1
@03C1:  MOV     BX, ds:[BP+DI]
@03C4:  JMP     BX
@03C6:  MOV     AH, 02
@03C8:  MOV     DL, 07
@03CA:  INT     21h
@03CC:  JMP     @0373
@03CE:  CALL    @0661
@03D1:  CMP     BYTE PTR [@0E47], 00
@03D6:  JZ      @03E1
@03D8:  CALL    @0ADD
@03DB:  MOV     BYTE PTR [@0E47], 00
@03E0:  NOP
@03E1:  CALL    @0B5D
@03E4:  CALL    @0603
@03E7:  JZ      @03FA
@03E9:  MOV     AX, [@012F]
@03EC:  MOV     [@0131], AX
@03EF:  MOV     BYTE PTR [@017B], 02
@03F4:  CALL    @0A9E
@03F7:  JMP     @031B
@03FA:  MOV     SI, 0EA8h
@03FD:  CALL    @0B75
@0400:  JMP     @0373
@0403:  MOV     SI, 0E92h
@0406:  CALL    @0B75
@0409:  JMP     @0373
@040C:  TEST    BYTE PTR [@0194], 20h
@0411:  JNZ     @03CE
@0413:  XOR     BYTE PTR [@012E], 01
@0418:  XOR     BYTE PTR [@018D], 01
@041D:  JMP     @03CE
@041F:  XOR     BYTE PTR [@0194], 40h
@0424:  JMP     @03CE
@0426:  XOR     BYTE PTR [@012E], 04
@042B:  JMP     @03CE
@042D:  TEST    BYTE PTR [@0194], 04
@0432:  JNZ     @043C
@0434:  CMP     WORD PTR [@017F], 00DCh
@043A:  JB      @043F
@043C:  JMP     @0373
@043F:  ADD     WORD PTR [@017F], +14h
@0444:  MOV     BYTE PTR [@0E47], 01
@0449:  NOP
@044A:  JMP     @03CE
@044C:  MOV     WORD PTR [@017F], 0000
@0452:  JMP     @03CE
@0455:  TEST    BYTE PTR [@0194], 04
@045A:  JNZ     @0463
@045C:  CMP     WORD PTR [@017F], +00
@0461:  JNZ     @0466
@0463:  JMP     @0373
@0466:  SUB     WORD PTR [@017F], +14h
@046B:  MOV     BYTE PTR [@0E47], 01
@0470:  NOP
@0471:  JMP     @03CE
@0474:  XOR     BYTE PTR [@0194], 04
@0479:  MOV     WORD PTR [@017F], 0000
@047F:  JMP     @050E
@0482:  AND     BYTE PTR [@0194], 0F7h
@0487:  JMP     @051F
@048A:  OR      BYTE PTR [@0194], 08h
@048F:  JMP     @051F
@0492:  XOR     BYTE PTR [@0194], 10h
@0497:  MOV     BYTE PTR [@0E29], 20h
@049C:  TEST    BYTE PTR [@0194], 10
@04A1:  JZ      @04A8
@04A3:  MOV     BYTE PTR [@0E29], 50h
@04A8:  JMP     @03CE
@04AB:  MOV     WORD PTR [@012F], 0000
@04B1:  CMP     WORD PTR [@0135], +01
@04B6:  JA      @04C6
@04B8:  CMP     BYTE PTR [@0E48], 00
@04BD:  JZ      @04D8
@04BF:  CMP     WORD PTR [@017F], +00
@04C4:  JNZ     @04C6
@04C6:  MOV     WORD PTR [@0135], 0001
@04CC:  MOV     WORD PTR [@017F], 0000
@04D2:  CALL    @0AE0
@04D5:  JMP     @03E4
@04D8:  JMP     @0403
@04DB:  CALL    @0753
@04DE:  JNZ     @04DB
@04E0:  CALL    @0603
@04E3:  JNZ     @04E8
@04E5:  JMP     @03FA
@04E8:  MOV     AX, [@0133]
@04EB:  MOV     [@012F], AX
@04EE:  AND     BYTE PTR [@0194], 0FEh
@04F3:  MOV     DI, 0135h
@04F6:  PUSH    DS
@04F7:  POP     ES
@04F8:  SUB     AX, AX
@04FA:  MOV     CX, 0017h
@04FD:  REPZ
@04FE:  STOSW
@04FF:  MOV     WORD PTR [@017F], 0000
@0505:  MOV     BYTE PTR [@0E47], 01
@050A:  NOP
@050B:  JMP     @03CE
@050E:  CMP     WORD PTR [@017F], +00
@0513:  JZ      @0518
@0515:  CALL    @0AE0
@0518:  CMP     BYTE PTR [@017E], 01
@051D:  JZ      @04AB
@051F:  CALL    @055A
@0522:  SUB     CX, CX
@0524:  SUB     DX, DX
@0526:  MOV     AX, 4200h
@0529:  INT     21h
@052B:  CALL    @057F
@052E:  CALL    @0A9E
@0531:  MOV     BYTE PTR [@017B], 02
@0536:  MOV     BYTE PTR [@017C], 01
@053B:  MOV     WORD PTR [@0135], 0000
@0541:  MOV     BYTE PTR [@017E], 00
@0546:  JMP     @030D
@0549:  XOR     BYTE PTR [@012E], 02
@054E:  MOV     BYTE PTR [@0E47], 01
@0553:  NOP
@0554:  CALL    @0AE0
@0557:  JMP     @03CE
@055A:  PUSH    AX
@055B:  PUSH    CX
@055C:  PUSH    DX
@055D:  TEST    BYTE PTR [@012E], 04
@0562:  JZ      @0577
@0564:  MOV     BX, [@0185]
@0568:  OR      BX, BX
@056A:  JNZ     @0577
@056C:  MOV     DX, 0DFBh
@056F:  MOV     AX, 3D00h
@0572:  INT     21h
@0574:  MOV     [@0185], AX
@0577:  MOV     BX, [@0185]
@057B:  POP     DX
@057C:  POP     CX
@057D:  POP     AX
@057E:  RET
@057F:  PUSH    AX
@0580:  PUSH    BX
@0581:  MOV     BX, [@0185]
@0585:  TEST    BYTE PTR [@012E], 04
@058A:  JZ      @059B
@058C:  OR      BX, BX
@058E:  JZ      @059B
@0590:  MOV     AX, 3E00h
@0593:  INT     21h
@0595:  MOV     WORD PTR [@0185], 0000
@059B:  POP     BX
@059C:  POP     AX
@059D:  RET
@059E:  MOV     AL, [@012A]
@05A1:  INC     AL
@05A3:  AND     AL, 0Fh
@05A5:  AND     BYTE PTR [@012A], 70h
@05AA:  OR      [@012A], AL
@05AE:  JMP     @05CA
@05B0:  NOP
@05B1:  MOV     AL, [@012A]
@05B4:  ADD     AL, 10h
@05B6:  AND     AL, 70h
@05B8:  AND     BYTE PTR [@012A], 0Fh
@05BD:  OR      [@012A], AL
@05C1:  AND     BYTE PTR [@012C], 0Fh
@05C6:  OR      [@012C], AL
@05CA:  MOV     AX, [@0135]
@05CD:  MOV     [@012F], AX
@05D0:  MOV     AL, [@012A]
@05D3:  MOV     [@017D], AL
@05D6:  CALL    @0AED
@05D9:  CALL    @0B5D
@05DC:  JMP     @03E4
@05DF:  MOV     AL, [@0128]
@05E2:  INC     AL
@05E4:  AND     AL, 0Fh
@05E6:  AND     BYTE PTR [@0128], 70h
@05EB:  OR      [@0128], AL
@05EF:  JMP     @05CA
@05F1:  MOV     AL, [@0128]
@05F4:  ADD     AL, 10h
@05F6:  AND     AL, 70h
@05F8:  AND     BYTE PTR [@0128], 0Fh
@05FD:  OR      [@0128], AL
@0601:  JMP     @05CA
@0603:  PUSH    SI
@0604:  MOV     SI, [@0133]
@0608:  CMP     SI, [@012F]
@060C:  JNZ     @0618
@060E:  PUSH    DS
@060f:  MOV     DS, cs:[@0183]
@0614:  CMP     BYTE PTR [SI], 1Ah
@0617:  POP     DS
@0618:  POP     SI
@0619:  RET
@061A:  CALL    @0603
@061D:  JNZ     @0622
@061F:  JMP     @03FA
@0622:  MOV     DI, 0135h
@0625:  MOV     SI, 0137h
@0628:  PUSH    ES
@0629:  PUSH    DS
@062A:  POP     ES
@062B:  MOV     CX, 0030h
@062E:  REPZ
@062F:  MOVSB
@0630:  POP     ES
@0631:  CALL    @0AA8
@0634:  MOV     BYTE PTR [@017B], 18h
@0639:  MOV     BYTE PTR [@017C], 01h
@063E:  MOV     AX, [@012F]
@0641:  MOV     [@0131], AX
@0644:  JMP     @032F
@0647:  CMP     WORD PTR [@0135], +00
@064C:  JNZ     @065B
@064E:  CMP     BYTE PTR [@0E48], 00
@0653:  JZ      @0658
@0655:  JMP     @03CE
@0658:  JMP     @0403
@065B:  CALL    @0661
@065E:  JMP     @03CE
@0661:  MOV     CX, 0017h
@0664:  CALL    @06D2
@0667:  CALL    @0739
@066A:  LOOP    @0664
@066C:  MOV     BYTE PTR [@017C], 01
@0671:  RET
@0672:  CMP     WORD PTR [@0135], +00
@0677:  JZ      @0683
@0679:  MOV     DI, [@0131]
@067D:  CMP     DI, [@0135]
@0681:  JNB     @06A4
@0683:  CMP     BYTE PTR [@017E], 01
@0688:  JA      @068D
@068A:  JMP     @0403
@068D:  SUB     BYTE PTR [@017E], 02
@0692:  CALL    @0753
@0695:  MOV     AX, [@0133]
@0698:  MOV     [@0135], AX
@069B:  MOV     [@012F], AX
@069E:  CALL    @06D2
@06A1:  CALL    @0739
@06A4:  CALL    @0AB1
@06A7:  MOV     AX, [@012F]
@06AA:  MOV     [@0131], AX
@06AD:  MOV     AX, [@0135]
@06B0:  MOV     [@012F], AX
@06B3:  CALL    @06D2
@06B6:  CALL    @0739
@06B9:  MOV     BYTE PTR [@017B], 02
@06BE:  MOV     BYTE PTR [@017C], 01
@06C3:  CALL    @07E9
@06C6:  MOV     AX, [@0131]
@06C9:  MOV     [@012F], AX
@06CC:  CALL    @06D2
@06CF:  JMP     @0373
@06D2:  PUSH    CX
@06D3:  PUSH    DI
@06D4:  PUSH    DX
@06D5:  MOV     DI, [@012F]
@06D9:  OR      DI, DI
@06DB:  JNZ     @06FA
@06DD:  CMP     BYTE PTR [@017E], 01
@06E2:  JBE     @0735
@06E4:  SUB     BYTE PTR [@017E], 02
@06E9:  CALL    @0753
@06EC:  MOV     DI, [@0133]
@06F0:  MOV     [@012F], DI
@06F4:  CALL    @06D2
@06F7:  JMP     @0735
@06F9:  NOP
@06FA:  DEC     DI
@06FB:  DEC     DI
@06FC:  MOV     [@012F], DI
@0700:  MOV     CX, DI
@0702:  MOV     ES, [@0183]
@0706:  STD
@0707:  MOV     AL, 0A
@0709:  REPNZ
@070A:  SCASB
@070B:  CLD
@070C:  MOV     DX, [@012F]
@0710:  MOV     [@012F], CX
@0714:  JCXZ    @0735
@0716:  INC     CX
@0717:  SUB     DX, CX
@0719:  INC     CX
@071A:  MOV     [@012F], CX
@071E:  TEST    BYTE PTR [@0194], 04
@0723:  JZ      @0735
@0725:  MOV     CX, [@0167]
@0729:  SUB     DX, CX
@072B:  JZ      @0735
@072D:  JS      @0735
@072F:  ADD     [@012F], CX
@0733:  JMP     @0725
@0735:  POP     DX
@0736:  POP     DI
@0737:  POP     CX
@0738:  RET
@0739:  PUSH    ES
@073A:  PUSH    CX
@073B:  PUSH    DS
@073C:  POP     ES
@073D:  MOV     SI, 0164h
@0740:  MOV     DI, 0166h
@0743:  MOV     CX, 0030h
@0746:  STD
@0747:  REPZ
@0748:  MOVSB
@0749:  CLD
@074A:  MOV     AX, [@012F]
@074D:  MOV     [@0135], AX
@0750:  POP     CX
@0751:  POP     ES
@0752:  RET
@0753:  PUSH    DS
@0754:  MOV     AX, CS
@0756:  MOV     ES, AX
@0758:  MOV     SI, 0E64h
@075B:  CALL    @0B50
@075E:  SUB     CX, CX
@0760:  MOV     CL, [@017E]
@0764:  MOV     AX, [@0189]
@0767:  MUL     CX
@0769:  MOV     CX, DX
@076B:  MOV     DX, AX
@076D:  CALL    @055A
@0770:  MOV     AX, 4200h
@0773:  INT     21h
@0775:  PUSH    DS
@0776:  MOV     BX, [@0185]
@077A:  MOV     CX, [@0189]
@077E:  MOV     DS, [@0183]
@0782:  SUB     DX, DX
@0784:  MOV     AH, 3Fh
@0786:  INT     21h
@0788:  POP     DS
@0789:  CALL    @057F
@078C:  OR      BYTE PTR [@0194], 01
@0791:  OR      AX, AX
@0793:  JZ      @07D5
@0795:  AND     BYTE PTR [@0194], 0FEh
@079A:  PUSH    ES
@079B:  PUSH    DS
@079C:  MOV     ES, [@0183]
@07A0:  MOV     DS, [@0183]
@07A4:  MOV     CX, AX
@07A6:  SUB     SI, SI
@07A8:  SUB     DI, DI
@07AA:  LODSB
@07AB:  TEST    BYTE PTR cs:[@0194], 08
@07B1:  JNZ     @07B5
@07B3:  AND     AL, 7Fh
@07B5:  CMP     AL, 0Dh
@07B7:  JNZ     @07C0
@07B9:  CMP     BYTE PTR [SI], 0Ah
@07BC:  JZ      @07C1
@07BE:  MOV     AL, 0Ah
@07C0:  STOSB
@07C1:  LOOP    @07AA
@07C3:  POP     DS
@07C4:  MOV     [@0133], DI
@07C8:  MOV     AL, 1Ah
@07CA:  STOSB
@07CB:  SUB     AX, AX
@07CD:  MOV     [@012F], AX
@07D0:  INC     BYTE PTR [@017E]
@07D4:  POP     ES
@07D5:  PUSHF
@07D6:  MOV     SI, 0E54h
@07D9:  TEST    BYTE PTR [@0194], 80h
@07DE:  JZ      @07E3
@07E0:  MOV     SI, 0E5Ch
@07E3:  CALL    @0B50
@07E6:  POPF
@07E7:  POP     DS
@07E8:  RET
@07E9:  CMP     BYTE PTR [@017B], 02
@07EE:  JB      @0802
@07F0:  MOV     AX, [@012F]
@07F3:  SUB     BX, BX
@07F5:  MOV     BL, [@017B]
@07F9:  SUB     BL, 02
@07FC:  ADD     BL, BL
@07FE:  MOV     [BX+0135], AX
@0802:  CALL    @0875
@0805:  MOV     CX, [@0179]
@0809:  SUB     CL, [@018B]
@080D:  SUB     CL, [@018C]
@0811:  MOV     [@0179], CX
@0815:  MOV     SI, 11CBh
@0818:  CMP     BYTE PTR [@017B], 02
@081D:  JNB     @0824
@081F:  MOV     BYTE PTR [@017B], 02
@0824:  MOV     DH, [@017B]
@0828:  MOV     DL, [@017C]
@082C:  ADD     SI, [@017F]
@0830:  SUB     CX, [@017F]
@0834:  MOV     BH, [@017D]
@0838:  CALL    @0923
@083B:  TEST    BYTE PTR [@0194], 10h
@0840:  JZ      @086A
@0842:  MOV     AH, 01
@0844:  INT     16h
@0846:  JNZ     @086A
@0848:  MOV     CX, [@0179]
@084C:  MOV     SI, 11CBh
@084F:  MOV     BX, CX
@0851:  MOV     WORD PTR [BX+SI], 0A0Dh
@0855:  MOV     AL, [@018B]
@0858:  SUB     AH, AH
@085A:  ADD     CX, AX
@085C:  ADD     CX, AX
@085E:  JZ      @086A
@0860:  MOV     DX, 11CBh
@0863:  MOV     AH, 40h
@0865:  MOV     BX, 0004
@0868:  INT     21h
@086A:  INC     BYTE PTR [@017B]
@086E:  MOV     AL, [@012A]
@0871:  MOV     [@017D], AL
@0874:  RET
@0875:  PUSH    ES
@0876:  PUSH    CX
@0877:  PUSH    SI
@0878:  PUSH    DI
@0879:  TEST    BYTE PTR [@0194], 01
@087E:  JZ      @0894
@0880:  MOV     AX, [@0133]
@0883:  MOV     [@012F], AX
@0886:  CALL    @0753
@0889:  JNZ     @088E
@088B:  JMP     @091E
@088E:  MOV     DI, [@0179]
@0892:  JMP     @0896
@0894:  SUB     DI, DI
@0896:  MOV     WORD PTR [@018B], 0000
@089C:  MOV     ES, [@0183]
@08A0:  MOV     SI, [@012F]
@08A4:  MOV     AL, es:[SI]
@08A7:  CMP     AL, 1A
@08A9:  JNZ     @08B6
@08AB:  MOV     [@0179], DI
@08AF:  OR      BYTE PTR [@0194], 01
@08B4:  JMP     @0879
@08B6:  CMP     AL, 09h
@08B8:  JNZ     @08D2
@08BA:  MOV     CX, DI
@08BC:  ADD     CX, +08h
@08BF:  AND     CX, -08h
@08C2:  SUB     CX, DI
@08C4:  MOV     BYTE PTR [DI+11CB], 20h
@08C9:  INC     DI
@08CA:  LOOP    @08C4
@08CC:  INC     WORD PTR [@012F]
@08D0:  JMP     @08A0
@08D2:  MOV     [DI+11CB], AL
@08D6:  INC     DI
@08D7:  INC     WORD PTR [@012F]
@08DB:  CMP     AL, 0Dh
@08DD:  JNZ     @08E5
@08DF:  INC     BYTE PTR [@018C]
@08E3:  JMP     @08EF
@08E5:  CMP     AL, 0Ah
@08E7:  JNZ     @08EF
@08E9:  INC     BYTE PTR [@018B]
@08ED:  JMP     @0910
@08EF:  CMP     DI, 00FFh
@08F3:  JNB     @0910
@08F5:  TEST    BYTE PTR [@0194], 04
@08FA:  JZ      @0902
@08FC:  CMP     DI, [@016F]
@0900:  JA      @0904
@0902:  JMP     @08A0
@0904:  INC     BYTE PTR [@018B]
@0908:  DEC     WORD PTR [@012F]
@090C:  DEC     WORD PTR [@012F]
@0910:  MOV     [@0179], DI
@0914:  CMP     BYTE PTR [11CB], 0Fh
@0919:  JNZ     @091E
@091B:  JMP     @0894
@091E:  POP     DI
@091F:  POP     SI
@0920:  POP     CX
@0921:  POP     ES
@0922:  RET
@0923:  PUSH    AX
@0924:  PUSH    BX
@0925:  MOV     BP, SP
@0927:  PUSH    CX
@0928:  PUSH    DX
@0929:  PUSH    DI
@092A:  PUSH    ES
@092B:  PUSH    SI
@092C:  SUB     AX, AX
@092E:  XCHG    AL, DH
@0930:  MOV     DI, DX
@0932:  DEC     DI
@0933:  DEC     AX
@0934:  OR      CX, CX
@0936:  JLE     @099E
@0938:  MOV     DX, [@0167]
@093C:  CMP     CX, DX
@093E:  JBE     @0942
@0940:  MOV     CX, DX
@0942:  MUL     WORD PTR [@0167]
@0946:  ADD     DI, AX
@0948:  SHL     DI, 1
@094A:  MOV     DX, [@016B]
@094E:  MOV     ES, [@0169]
@0952:  LODSB
@0953:  MOV     BH, [BP+01]
@0956:  CMP     AL, 20h
@0958:  JNB     @097C
@095A:  CMP     AL, 00
@095C:  JNZ     @0968
@095E:  CMP     BH, [@012A]
@0962:  JNZ     @097C
@0964:  INC     DI
@0965:  INC     DI
@0966:  JMP     @099C
@0968:  TEST    BYTE PTR [@0194], 08h
@096D:  JNZ     @097C
@096F:  CMP     DI, [@016D]
@0973:  JNB     @097C
@0975:  MOV     AL, 0A8h
@0977:  NOP
@0978:  MOV     BH, [@012C]
@097C:  MOV     BL, AL
@097E:  CMP     BYTE PTR [@018D], 01
@0983:  JZ      @098B
@0985:  MOV     AH, BH
@0987:  STOSW
@0988:  JMP     @099C
@098A:  NOP
@098B:  MOV     AH, BH
@098D:  CLI
@098E:  IN      AL, DX
@098F:  RCR     AL, 1
@0991:  JB      @098E
@0993:  IN      AL, DX
@0994:  RCR     AL, 1
@0996:  JNB     @0993
@0998:  MOV     AL, BL
@099A:  STOSW
@099B:  STI
@099C:  LOOP    @0952
@099E:  POP     SI
@099F:  POP     ES
@09A0:  POP     DI
@09A1:  POP     DX
@09A2:  POP     CX
@09A3:  POP     BX
@09A4:  POP     AX
@09A5:  RET
@09A6:  CMP     BYTE PTR [11A9h], 24h;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@09AB:  NOP
@09AC:  JNZ     @09BE
@09AE:  PUSH    DI
@09AF:  PUSH    SI
@09B0:  PUSH    DS
@09B1:  POP     ES
@09B2:  JMP     @09FF
@09B4:  OR      BYTE PTR [@0195], 01
@09B9:  MOV     AX, 0E74h
@09BC:  JMP     @09C6
@09BE:  AND     BYTE PTR [@0195], FEh
@09C3:  MOV     AX, 0E6Ch
@09C6:  PUSH    DI
@09C7:  PUSH    SI
@09C8:  PUSH    DS
@09C9:  POP     ES
@09CA:  MOV     SI, AX
@09CC:  CALL    @0B50
@09CF:  MOV     BYTE PTR [11A9h], 24h;;;;;;;;;;;;;;;;;;;;;;;;;;;
@09D4:  MOV     DX, 11A9h
@09D7:  MOV     BX, [@012A]
@09DB:  XCHG    BH, BL
@09DD:  MOV     AH, 0Ah
@09DF:  INT     21h
@09E1:  TEST    BYTE PTR [@0195], 01
@09E6:  JZ      @09FF
@09E8:  MOV     CX, 0024h
@09EB:  NOP
@09EC:  MOV     SI, 11ABh
@09EF:  LODSB
@09F0:  CMP     AL, 61h
@09F2:  JB      @09FD
@09F4:  CMP     AL, 7Ah
@09F6:  JA      @09FD
@09F8:  SUB     AL, 20h
@09FA:  MOV     [SI-01], AL
@09FD:  LOOP    @09EF
@09FF:  MOV     SI, 0E5Ch
@0A02:  CALL    @0B50
@0A05:  OR      BYTE PTR [@0194], 80h
@0A0A:  OR      CL, [11AAh]
@0A0E:  JZ      @0A76
@0A10:  MOV     AX, [@0135]
@0A13:  MOV     [@012F], AX
@0A16:  CALL    @0875
@0A19:  CALL    @0875
@0A1C:  TEST    BYTE PTR [@0194], 01
@0A21:  JNZ     @0A76
@0A23:  MOV     AX, [@012F]
@0A26:  MOV     DX, [@0179]
@0A2A:  MOV     AL, [11AAh]
@0A2D:  CBW
@0A2E:  SUB     DX, AX
@0A30:  JLE     @0A19
@0A32:  CLD
@0A33:  SUB     CH, CH
@0A35:  MOV     BX, 11CBh
@0A38:  TEST    BYTE PTR [@0195], 01
@0A3D:  JZ      @0A54
@0A3F:  MOV     CX, [@0179]
@0A43:  MOV     SI, BX
@0A45:  LODSB
@0A46:  CMP     AL, 61h
@0A48:  JB      @0A52
@0A4A:  CMP     AL, 7A h
@0A4C:  JA      @0A52
@0A4E:  SUB     BYTE PTR [SI-01], 20h
@0A52:  LOOP    @0A45
@0A54:  MOV     SI, BX
@0A56:  MOV     DI, 11ABh
@0A59:  MOV     CL, [11AAh]
@0A5D:  REPZ
@0A5E:  CMPSB
@0A5F:  JZ      @0A68
@0A61:  INC     BX
@0A62:  DEC     DL
@0A64:  JNZ     @0A54
@0A66:  JMP     @0A19
@0A68:  CALL    @0B4D
@0A6B:  MOV     AL, [@012C]
@0A6E:  MOV     [@017D], AL
@0A71:  CALL    @06D2
@0A74:  JMP     @0A94
@0A76:  MOV     AX, [@0135]
@0A79:  MOV     [@012F], AX
@0A7C:  CALL    @0B4D
@0A7F:  MOV     SI, 0E7C
@0A82:  CALL    @0B75
@0A85:  AND     BYTE PTR [@0128], 7Fh
@0A8A:  AND     BYTE PTR [@0194], FEh
@0A8F:  MOV     BYTE PTR [@017C], 01h
@0A94:  AND     BYTE PTR [@0194], 7Fh
@0A99:  POP     SI
@0A9A:  POP     DI
@0A9B:  JMP     @03E4
@0A9E:  PUSH    AX
@0A9F:  PUSH    BX
@0AA0:  PUSH    CX
@0AA1:  PUSH    DX
@0AA2:  MOV     AX, 0600h
@0AA5:  JMP     @0AB8
@0AA7:  NOP
@0AA8:  PUSH    AX
@0AA9:  PUSH    BX
@0AAA:  PUSH    CX
@0AAB:  PUSH    DX
@0AAC:  MOV     AX, 0601h
@0AAF:  JMP     @0AB8
@0AB1:  PUSH    AX
@0AB2:  PUSH    BX
@0AB3:  PUSH    CX
@0AB4:  PUSH    DX
@0AB5:  MOV     AX, 0701h
@0AB8:  MOV     BX, [@0129]
@0ABC:  MOV     CX, 0100h
@0ABF:  MOV     DX, [@0167]
@0AC3:  DEC     DL
@0AC5:  MOV     DH, 17h
@0AC7:  INT     10h
@0AC9:  POP     DX
@0ACA:  POP     CX
@0ACB:  POP     BX
@0ACC:  POP     AX
@0ACD:  RET
@0ACE:  MOV     AX, 0600h
@0AD1:  MOV     BX, [@0129]
@0AD5:  SUB     CX, CX
@0AD7:  MOV     DX, 184F h
@0ADA:  INT     10h
@0ADC:  RET
@0ADD:  CALL    @0ACE
@0AE0:  TEST    BYTE PTR [@012E], 02
@0AE5:  JNZ     @0B0A
@0AE7:  CALL    @0CA3
@0AEA:  CALL    @0D0B
@0AED:  MOV     BYTE PTR [@0DF9], 04
@0AF2:  NOP
@0AF3:  MOV     BYTE PTR [@0DFA], 20h
@0AF8:  NOP
@0AF9:  MOV     DX, 0101h
@0AFC:  MOV     SI, 0DDAh
@0AFF:  MOV     CX, 0050h
@0B02:  MOV     BH, [@0128]
@0B06:  CALL    @0923
@0B09:  RET
@0B0A:  MOV     DX, 0008
@0B0D:  SUB     DI, DI
@0B0F:  PUSH    ES
@0B10:  MOV     ES, [@0169]
@0B14:  MOV     AH, [@0128]
@0B18:  MOV     AL, 0C2h
@0B1A:  MOV     CX, 0007
@0B1D:  STOSW
@0B1E:  LOOP    @0B1D
@0B20:  MOV     CL, 14h
@0B22:  MOV     AX, [@017F]
@0B25:  SHL     AX, 1
@0B27:  ADD     AX, DI
@0B29:  ADD     AX, 0009h
@0B2C:  DIV     CL
@0B2E:  SUB     AH, AH
@0B30:  AAM
@0B32:  XCHG    AH, AL
@0B34:  OR      AX, 3030h
@0B37:  PUSH    AX
@0B38:  MOV     AH, [@0128]
@0B3C:  STOSW
@0B3D:  POP     AX
@0B3E:  XCHG    AH, AL
@0B40:  MOV     AH, [@0128]
@0B44:  STOSW
@0B45:  MOV     AL, 30h
@0B47:  STOSW
@0B48:  DEC     DX
@0B49:  JNZ     @0B14
@0B4B:  POP     ES
@0B4C:  RET
@0B4D:  MOV     SI, 0E54h
@0B50:  MOV     DI, 0196h
@0B53:  MOV     CX, 0008h
@0B56:  NOP
@0B57:  REPZ
@0B58:  MOVSB
@0B59:  CALL    @0B5D
@0B5C:  RET
@0B5D:  MOV     DX, 1901h
@0B60:  MOV     CX, 0050h
@0B63:  MOV     BH, [@0128]
@0B67:  MOV     SI, 0196h
@0B6A:  CALL    @0923
@0B6D:  MOV     DX, 1808h
@0B70:  NOP
@0B71:  CALL    @0B85
@0B74:  RET
@0B75:  MOV     DX, 190Bh
@0B78:  NOP
@0B79:  MOV     CX, 0016h
@0B7C:  NOP
@0B7D:  MOV     BH, [@0128]
@0B81:  CALL    @0923
@0B84:  RET
@0B85:  MOV     AH, 02
@0B87:  MOV     BX, [@012A]
@0B8B:  INT     10h
@0B8D:  RET
@0B8E:  MOV     BX, 013Dh
@0B91:  NOP
@0B92:  MOV     AH, 4Ah
@0B94:  INT     21h
@0B96:  MOV     BX, 0FFFFh
@0B99:  MOV     AH, 48h
@0B9B:  INT     21h
@0B9D:  JB      @0B99
@0B9F:  MOV     [@0183], AX
@0BA2:  MOV     CX, 0020h
@0BA5:  MOV     AX, BX
@0BA7:  CMP     AX, 0FFFh
@0BAA:  JBE     @0BAF
@0BAC:  MOV     AX, 0FFFh
@0BAF:  SUB     AX, CX
@0BB1:  CMP     AX, CX
@0BB3:  JB      @0BBD
@0BB5:  MUL     WORD PTR [@0187]
@0BB9:  MOV     [@0189], AX
@0BBC:  RET
@0BBD:  MOV     DX, 0EE2h
@0BC0:  JMP     @0304
@0BC3:  MOV     SI, 0E54h
@0BC6:  MOV     CX, 0008h
@0BC9:  NOP
@0BCA:  MOV     DI, 0000h
@0BCD:  NOP
@0BCE:  CALL    @0BDC
@0BD1:  MOV     SI, 0EBEh
@0BD4:  MOV     CX, 0024h
@0BD7:  NOP
@0BD8:  MOV     DI, 002Ch
@0BDB:  NOP
@0BDC:  LEA     DI, [DI+0196h]
@0BE0:  REPZ
@0BE1:  MOVSB
@0BE2:  RET
@0BE3:  XOR     AX, AX
@0BE5:  XOR     CX, CX
@0BE7:  MOV     AL, [@0080]
@0BEA:  OR      CX, AX
@0BEC:  JZ      @0C04
@0BEE:  MOV     DI, 0DFBh
@0BF1:  MOV     SI, 0081h
@0BF4:  LODSB
@0BF5:  CMP     AL, 20h
@0BF7:  JZ      @0BFE
@0BF9:  CMP     AL, 0Dh
@0BFB:  JZ      @0C00
@0BFD:  STOSB
@0BFE:  LOOP    @0BF4
@0C00:  ES:
@0C01:  MOV     BYTE PTR [DI], 00
@0C04:  RET
@0C05:  MOV     DX, 1179h
@0C08:  MOV     AH, 1Ah
@0C0A:  INT     21h
@0C0C:  MOV     DX, 0DFBh
@0C0F:  SUB     CX, CX
@0C11:  MOV     AH, 4Eh
@0C13:  INT     21h
@0C15:  JB      @0C48
@0C17:  OR      AL, AL
@0C19:  JNZ     @0C48
@0C1B:  MOV     SI, 0E46h
@0C1E:  MOV     CX, 004Ch
@0C21:  STD
@0C22:  LODSB
@0C23:  CMP     AL, 5Ch
@0C25:  JZ      @0C32
@0C27:  CMP     AL, 2Fh
@0C29:  JZ      @0C32
@0C2B:  CMP     AL, 3Ah
@0C2D:  JZ      @0C32
@0C2F:  LOOP    @0C22
@0C31:  DEC     SI
@0C32:  MOV     [@0173], SI
@0C36:  MOV     DI, SI
@0C38:  MOV     SI, 1197h
@0C3B:  ADD     DI, +02
@0C3E:  CLD
@0C3F:  MOV     CX, 000Dh
@0C42:  LODSB
@0C43:  STOSB
@0C44:  CMP     AL, 00
@0C46:  LOOPNZ  @0C42
@0C48:  MOV     AL, 20h
@0C4A:  REPZ
@0C4B:  STOSB
@0C4C:  MOV     DX, 0DFBh
@0C4F:  MOV     AX, 3D00h
@0C52:  INT     21h
@0C54:  MOV     [@0185], AX
@0C57:  JB      @0C7A
@0C59:  MOV     BX, AX
@0C5B:  MOV     AX, 5700h
@0C5E:  INT     21h
@0C60:  JB      @0C6A
@0C62:  MOV     [@0175], DX
@0C66:  MOV     [@0177], CX
@0C6A:  CALL    @055A
@0C6D:  SUB     CX, CX
@0C6F:  SUB     DX, DX
@0C71:  MOV     AX, 4200h
@0C74:  INT     21h
@0C76:  CALL    @057F
@0C79:  RET
@0C7A:  MOV     [@0F22], AX
@0C7D:  CMP     AL, 02
@0C7F:  JL      @0C95
@0C81:  CMP     AL, 05
@0C83:  JA      @0C95
@0C85:  SUB     BX, BX
@0C87:  MOV     BL, AL
@0C89:  SUB     BX, +02
@0C8C:  ADD     BX, BX
@0C8E:  MOV     DX, [BX+01E6]
@0C92:  JMP     @0304
@0C95:  AAM
@0C97:  XCHG    AL, AH
@0C99:  OR      [@0F22], AX
@0C9D:  MOV     DX, 0F0Eh
@0CA0:  JMP     @0304
@0CA3:  PUSH    CX
@0CA4:  PUSH    DX
@0CA5:  PUSH    DI
@0CA6:  PUSH    ES
@0CA7:  PUSH    SI
@0CA8:  MOV     DX, DS
@0CAA:  MOV     ES, DX
@0CAC:  MOV     DX, [@0175]
@0CB0:  MOV     DI, 0DEAh
@0CB3:  MOV     SI, 1170h
@0CB6:  MOV     BL, [116Fh]
@0CBA:  MOV     CX, 0003
@0CBD:  PUSH    CX
@0CBE:  MOV     AX, [SI]
@0CC0:  AND     AX, DX
@0CC2:  MOV     CL, [SI+02]
@0CC5:  SHR     AX, CL
@0CC7:  CMP     CL, 09
@0CCA:  JNZ     @0CCE
@0CCC:  ADD     AL, 50
@0CCE:  CALL    @0CFF
@0CD1:  ADD     SI, +03
@0CD4:  POP     CX
@0CD5:  LOOP    @0CBD
@0CD7:  MOV     BYTE PTR [DI-01], 20
@0CDB:  MOV     DX, [@0177]
@0CDF:  MOV     AX, DX
@0CE1:  AND     AX, 0F800h
@0CE4:  MOV     CL, 0Bh
@0CE6:  MOV     BL, 3Ah
@0CE8:  CALL    @0CFD
@0CEB:  MOV     AX, DX
@0CED:  AND     AX, 07E0h
@0CF0:  MOV     CL, 05
@0CF2:  MOV     BL, 20h
@0CF4:  CALL    @0CFD
@0CF7:  POP     SI
@0CF8:  POP     ES
@0CF9:  POP     DI
@0CFA:  POP     DX
@0CFB:  POP     CX
@0CFC:  RET
@0CFD:  SHR     AX, CL
@0CFF:  AAM
@0D01:  OR      AX, 3030h
@0D04:  XCHG    AH, AL
@0D06:  STOSW
@0D07:  MOV     AL, BL
@0D09:  STOSB
@0D0A:  RET
@0D0B:  PUSH    AX
@0D0C:  PUSH    CX
@0D0D:  MOV     WORD PTR [@0DE5], 2020h
@0D13:  MOV     WORD PTR [@0DE7], 2020h
@0D19:  MOV     AX, [@017F]
@0D1C:  OR      AX, AX
@0D1E:  JZ      @0D3B
@0D20:  INC     AX
@0D21:  MOV     CL, 0Ah
@0D23:  DIV     CL
@0D25:  SUB     AH, AH
@0D27:  AAM
@0D29:  OR      AX, 3030h
@0D2C:  XCHG    AH, AL
@0D2E:  MOV     [@0DE6], AX
@0D31:  MOV     BYTE PTR [@0DE8], 30h
@0D36:  MOV     BYTE PTR [@0DE5], 2Bh
@0D3B:  POP     CX
@0D3C:  POP     AX
@0D3D:  RET
@0D3E:  PUSH    BX
@0D3F:  PUSH    ES
@0D40:  MOV     DX, 0E49h
@0D43:  MOV     AX, 3D02h
@0D46:  INT     21h
@0D48:  JB      @0D80
@0D4A:  MOV     BX, AX
@0D4C:  MOV     AH, 3Fh
@0D4E:  MOV     CX, 0165h
@0D51:  MOV     DX, 1014h
@0D54:  INT     21h
@0D56:  JB      @0D7C
@0D58:  PUSH    AX
@0D59:  MOV     AX, 4200h
@0D5C:  SUB     CX, CX
@0D5E:  SUB     DX, DX
@0D60:  INT     21h
@0D62:  MOV     AX, CS
@0D64:  MOV     ES, AX
@0D66:  MOV     SI, 0128h
@0D69:  MOV     DI, SI
@0D6B:  ADD     DI, 0F14h
@0D6F:  MOV     CX, 0007h
@0D72:  REPZ
@0D73:  MOVSB
@0D74:  POP     CX
@0D75:  MOV     DX, 1014h
@0D78:  MOV     AH, 40h
@0D7A:  INT     21h
@0D7C:  MOV     AH, 3Eh
@0D7E:  INT     21h
@0D80:  POP     ES
@0D81:  POP     BX
@0D82:  JMP     @02D1
@0D85:  PUSH    ES
@0D86:  CALL    @0A9E
@0D89:  MOV     SI, 1014h
@0D8C:  MOV     ES, [@0169]
@0D90:  SUB     DI, DI
@0D92:  SUB     BX, BX
@0D94:  MOV     CX, 0100h
@0D97:  SUB     AX, AX
@0D99:  MOV     AL, CH
@0D9B:  MUL     WORD PTR [@0167]
@0D9F:  MOV     BL, CL
@0DA1:  ADD     AX, BX
@0DA3:  ADD     AX, AX
@0DA5:  MOV     DI, AX
@0DA7:  LODSB
@0DA8:  CMP     AL, 0FFh
@0DAA:  JZ      @0DC8
@0DAC:  CMP     AL, 0Dh
@0DAE:  JZ      @0DBA
@0DB0:  CMP     AL, 09h
@0DB2:  JZ      @@0DC0
@0DB4:  STOSB
@0DB5:  INC     DI
@0DB6:  INC     CL
@0DB8:  JMP     @0DA7
@0DBA:  INC     CH
@0DBC:  MOV     CL, 08h
@0DBE:  JMP     @0D97
@0DC0:  ADD     CL, 08h
@0DC3:  AND     CL, 0F8h
@0DC6:  JMP     @0D97
@0DC8:  MOV     DX, 1808h
@0DCB:  NOP
@0DCC:  CALL    @0B85
@0DCF:  CALL    @0661
@0DD2:  POP     ES
@0DD3:  XOR     AH, AH
@0DD5:  INT     16h
@0DD7:  JMP     @03E4

09F7:0DD0  8F F8 07 32 E4 CD 16 E9-0A F6 20 20 20 20 20 20   ...2......      
09F7:0DE0  20 20 20 20 20 2B 73 73-73 20 6D 6D 2F 64 64 2F        +sss mm/dd/
09F7:0DF0  79 79 20 68 68 3A 6D 6D-20 40 00 52 45 41 44 4D   yy hh:mm @.READM
09F7:0E00  45 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00   E...............
09F7:0E10  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00   ................
09F7:0E20  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00   ................
09F7:0E30  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00   ................
09F7:0E40  00 00 00 00 00 00 00 00-00 52 45 41 44 4D 45 2E   .........README.
09F7:0E50  43 4F 4D 00 43 6F 6D 6D-61 6E 64 10 53 63 61 6E   COM.Command.Scan
09F7:0E60  6E 69 6E 67 52 65 61 64-69 6E 67 20 53 63 61 6E   ningReading Scan
09F7:0E70  20 20 20 10 46 69 6E 64-20 20 20 10 2A 2A 2A 20      .Find   .*** 
09F7:0E80  54 65 78 74 20 6E 6F 74-20 66 6F 75 6E 64 20 2A   Text not found *
09F7:0E90  2A 2A 20 20 20 2A 2A 2A-20 54 6F 70 20 6F 66 20   **   *** Top of 
09F7:0EA0  66 69 6C 65 20 2A 2A 2A-20 20 20 2A 2A 2A 20 45   file ***   *** E
09F7:0EB0  6E 64 20 6F 66 20 66 69-6C 65 20 2A 2A 2A 4B 65   nd of file ***Ke
09F7:0EC0  79 73 3A 18 19 1B 1A 20-50 67 55 70 20 50 67 44   ys:.... PgUp PgD
09F7:0ED0  6E 20 45 53 43 3D 45 78-69 74 20 46 31 3D 48 65   n ESC=Exit F1=He
09F7:0EE0  6C 70 0D 0A 4E 6F 74 20-65 6E 6F 75 67 68 20 6D   lp..Not enough m
09F7:0EF0  65 6D 6F 72 79 0D 0A 24-0D 0A 57 72 6F 6E 67 20   emory..$..Wrong 
09F7:0F00  44 4F 53 20 76 65 72 73-69 6F 6E 0D 0A 24 20 20   DOS version..$  
09F7:0F10  4F 70 65 6E 20 66 61 69-6C 65 64 2C 20 63 6F 64   Open failed,  cod
09F7:0F20  65 3D 00 00 24 46 69 6C-65 20 6E 6F 74 20 66 6F   e=..$File not fo
09F7:0F30  75 6E 64 24 50 61 74 68-20 6E 6F 74 20 66 6F 75   und$Path not fou
09F7:0F40  6E 64 24 54 6F 6F 20 6D-61 6E 79 20 66 69 6C 65   nd$Too many file
09F7:0F50  73 24 41 63 63 65 73 73-20 64 65 6E 69 65 64 24   s$Access denied$
09F7:0F60  45 72 72 6F 72 20 77 68-69 6C 65 20 63 6C 6F 6E   Error while clon
09F7:0F70  69 6E 67 24 2A 57 48 41-54 2A 0D 20 1B 51 44 55   ing$*WHAT*. .QDU
09F7:0F80  3F 48 2F 52 4C 54 50 4E-56 58 42 57 37 38 2B 2D   ?H/RLTPNVXBW78+-
09F7:0F90  4B 46 5C 43 4D 53 4D 4B-49 51 47 48 3D 50 3B 44   KF\CMSMKIQGH=P;D
09F7:0FA0  4F 77 73 84 76 3F 40 2E-41 42 13 2A 57 48 45 52   Ows.v?@.AB.*WHER
09F7:0FB0  45 2A E4 03 E4 03 8D 02-8D 02 E4 03 47 06 85 0D   E*..........G...
09F7:0FC0  85 0D BE 09 49 05 55 04-0E 05 92 04 A6 09 1A 06   ....I.U.........
09F7:0FD0  BF 02 DB 04 74 04 82 04-8A 04 E4 03 47 06 1F 04   ....t.......G...
09F7:0FE0  B4 09 B4 09 BE 09 0C 04-3E 0D 2D 04 55 04 47 06   ........>.-.U.G.
09F7:0FF0  E4 03 0E 05 72 06 A6 09-1A 06 85 0D D1 02 E0 04   ....r...........
09F7:1000  AB 04 4C 04 0E 05 DB 04-B1 05 9E 05 3E 0D F1 05   ..L.........>...
09F7:1010  DF 05 49 05 0D 0D 52 45-41 44 4D 45 2E 43 4F 4D   ..I...README.COM
09F7:1020  20 32 2E 30 33 20 68 65-6C 70 20 73 63 72 65 65    2.03 help scree
09F7:1030  6E 0D 43 6F 70 79 72 69-67 68 74 20 28 63 29 20   n.Copyright (c) 
09F7:1040  31 39 38 36 2C 20 31 39-38 39 20 42 6F 72 6C 61   1986,  1989 Borla
09F7:1050  6E 64 20 49 6E 74 65 72-6E 61 74 69 6F 6E 61 6C   nd International
09F7:1060  0D 0D 0D 20 20 46 20 20-20 46 69 6E 64 20 74 65   ...  F   Find te
09F7:1070  78 74 0D 20 20 43 20 20-20 43 61 73 65 2D 73 65   xt.  C   Case-se
09F7:1080  6E 73 69 74 69 76 65 20-66 69 6E 64 0D 20 20 4E   nsitive find.  N
09F7:1090  20 20 20 46 69 6E 64 20-6E 65 78 74 0D 20 46 35      Find next. F5
09F7:10A0  2C 36 20 43 6F 6C 6F 72-20 6F 66 20 74 65 78 74   , 6 Color of text
09F7:10B0  0D 20 46 37 2C 38 20 43-6F 6C 6F 72 20 6F 66 20   . F7, 8 Color of
09F7:10C0  73 74 61 74 75 73 20 6C-69 6E 65 73 0D 20 48 6F   status lines. Ho
09F7:10D0  6D 65 20 53 74 61 72 74-20 6F 66 20 66 69 6C 65   me Start of file
09F7:10E0  73 00 0D 20 45 6E 64 20-20 45 6E 64 20 6F 66 20   s.. End  End of 
09F7:10F0  66 69 6C 65 0D 20 20 57-20 20 20 57 72 61 70 20   file.  W   Wrap 
09F7:1100  6C 6F 6E 67 20 6C 69 6E-65 73 20 6F 6E 2F 6F 66   long lines on/of
09F7:1110  66 0D 20 20 50 20 20 20-50 72 69 6E 74 69 6E 67   f.  P   Printing
09F7:1120  20 6F 6E 2F 6F 66 66 0D-20 37 2C 38 20 20 53 74    on/off. 7, 8  St
09F7:1130  72 69 70 20 6F 72 20 6C-65 61 76 65 20 68 69 2D   rip or leave hi-
09F7:1140  62 69 74 0D 20 20 53 20-20 20 53 61 76 65 20 64   bit.  S   Save d
09F7:1150  65 66 61 75 6C 74 73 0D-00 0D 20 45 53 43 20 20   efaults... ESC  
09F7:1160  52 65 74 75 72 6E 20 74-6F 20 66 69 6C 65 FF 2D   Return to file.-
09F7:1170  E0 01 05 1F 00 00 00 FE-09                        .........

