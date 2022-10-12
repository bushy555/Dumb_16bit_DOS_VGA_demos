0AF3:0100 33F6          XOR	SI,SI                              
0AF3:0102 BB7B01        MOV	BX,017B                            
0AF3:0105 8BCB          MOV	CX,BX                              
0AF3:0107 BD1806        MOV	BP,0618                            
0AF3:010A BF00A0        MOV	DI,A000                            
0AF3:010D 57            PUSH	DI                                 
0AF3:010E 8BC6          MOV	AX,SI                              
0AF3:0110 C1            DB	C1                                 
0AF3:0111 F8            CLC	                                   
0AF3:0112 07            POP	ES                                 
0AF3:0113 AB            STOSW	                                   
0AF3:0114 8BC6          MOV	AX,SI                              
0AF3:0116 99            CWD	                                   
0AF3:0117 F7FD          IDIV	BP                                 
0AF3:0119 2BD8          SUB	BX,AX                              
0AF3:011B 03F3          ADD	SI,BX                              
0AF3:011D E2EF          LOOP	010E                               
0AF3:011F 07            POP	ES                                 
0AF3:0120 B013          MOV	AL,13                              
0AF3:0122 CD10          INT	10                                 
0AF3:0124 BADA03        MOV	DX,03DA                            
0AF3:0127 EC            IN	AL,DX                              
0AF3:0128 A808          TEST	AL,08                              
0AF3:012A 75FB          JNZ	0127                               
0AF3:012C EC            IN	AL,DX                              
0AF3:012D A808          TEST	AL,08                              
0AF3:012F 74FB          JZ	012C                               
0AF3:0131 BECF01        MOV	SI,01CF                            
0AF3:0134 BB1800        MOV	BX,0018                            
0AF3:0137 BD80FF        MOV	BP,FF80                            
0AF3:013A B108          MOV	CL,08                              
0AF3:013C AC            LODSB	                                   
0AF3:013D A801          TEST	AL,01                              
0AF3:013F 7403          JZ	0144                               
0AF3:0141 48            DEC	AX                                 
0AF3:0142 02C9          ADD	CL,CL                              
0AF3:0144 D0C0          ROL	AL,1                               
0AF3:0146 7346          JNB	018E                               
0AF3:0148 BF4100        MOV	DI,0041                            
0AF3:014B 60            DB	60                                 
0AF3:014C 57            PUSH	DI                                 
0AF3:014D 52            PUSH	DX                                 
0AF3:014E E85B00        CALL	01AC                               
0AF3:0151 E85800        CALL	01AC                               
0AF3:0154 87FD          XCHG	DI,BP                              
0AF3:0156 E85300        CALL	01AC                               
0AF3:0159 41            INC	CX                                 
0AF3:015A FEC7          INC	BH                                 
0AF3:015C 97            XCHG	DI,AX                              
0AF3:015D 99            CWD	                                   
0AF3:015E D3E0          SHL	AX,CL                              
0AF3:0160 F7FB          IDIV	BX                                 
0AF3:0162 95            XCHG	BP,AX                              
0AF3:0163 99            CWD	                                   
0AF3:0164 D3E0          SHL	AX,CL                              
0AF3:0166 5E            POP	SI                                 
0AF3:0167 8B3C          MOV	DI,[SI]                            
0AF3:0169 AA            STOSB	                                   
0AF3:016A F7FB          IDIV	BX                                 
0AF3:016C BFC0FE        MOV	DI,FEC0                            
0AF3:016F F7EF          IMUL	DI                                 
0AF3:0171 7205          JB	0178                               
0AF3:0173 97            XCHG	DI,AX                              
0AF3:0174 8DBBA07D      LEA	DI,[BP+DI+7DA0]                    
0AF3:0178 893C          MOV	[SI],DI                            
0AF3:017A 58            POP	AX                                 
0AF3:017B 0443          ADD	AL,43                              
0AF3:017D 7206          JB	0185                               
0AF3:017F B068          MOV	AL,68                              
0AF3:0181 7A02          JPE	0185                               
0AF3:0183 B001          MOV	AL,01                              
0AF3:0185 AA            STOSB	                                   
0AF3:0186 61            DB	61                                 
0AF3:0187 42            INC	DX                                 
0AF3:0188 42            INC	DX                                 
0AF3:0189 83EF32        SUB	DI,+32                             
0AF3:018C 7ABD          JPE	014B                               
0AF3:018E 83C506        ADD	BP,+06                             
0AF3:0191 E2B1          LOOP	0144                               
0AF3:0193 7BA5          JPO	013A                               
0AF3:0195 83EB06        SUB	BX,+06                             
0AF3:0198 83FBDC        CMP	BX,-24                             
0AF3:019B 759A          JNZ	0137                               
0AF3:019D FE4CB0        DEC	BYTE PTR [SI-50]                   
0AF3:01A0 96            XCHG	SI,AX                              
0AF3:01A1 CD16          INT	16                                 
0AF3:01A3 0F            DB	0F                                 
0AF3:01A4 847DFF        TEST	BH,[DI-01]                         
0AF3:01A7 B80300        MOV	AX,0003                            
0AF3:01AA CD10          INT	10                                 
0AF3:01AC BE0050        MOV	SI,5000                            
0AF3:01AF 03F6          ADD	SI,SI                              
0AF3:01B1 AD            LODSW	                                   
0AF3:01B2 8B747E        MOV	SI,[SI+7E]                         
0AF3:01B5 8BC8          MOV	CX,AX                              
0AF3:01B7 F7EB          IMUL	BX                                 
0AF3:01B9 0F            DB	0F                                 
0AF3:01BA AF            SCASW	                                   
0AF3:01BB CF            IRET	                                   
0AF3:01BC 0F            DB	0F                                 
0AF3:01BD AF            SCASW	                                   
0AF3:01BE FE0F          DEC	BYTE PTR [BX]                      
0AF3:01C0 AF            SCASW	                                   
0AF3:01C1 DE03          	FIADD	WORD PTR [BP+DI]             
0AF3:01C3 F8            CLC	                                   
0AF3:01C4 2BD9          SUB	BX,CX                              
0AF3:01C6 B107          MOV	CL,07                              
0AF3:01C8 D3FB          SAR	BX,CL                              
0AF3:01CA D3FF          SAR	DI,CL                              
0AF3:01CC 87DD          XCHG	BX,BP                              
0AF3:01CE C3            RET	                                   
0AF3:01CF 7CC6          JL	0197                               
0AF3:01D1 107D60        ADC	[DI+60],BH                         
0AF3:01D4 C738C7F0      MOV	WORD PTR [BX+SI],F0C7              
0AF3:01D8 C76CC7F0C0    MOV	WORD PTR [SI-39],C0F0              
0AF3:01DD C7C660F0      MOV	SI,F060                            
0AF3:01E1 C0            DB	C0                                 
0AF3:01E2 FEC7          INC	BH                                 
0AF3:01E4 3860C0        CMP	[BX+SI-40],AH                      
0AF3:01E7 C6FEC6        MOV	DH,C6                              
0AF3:01EA 0C60          OR	AL,60                              
0AF3:01EC C0            DB	C0                                 
0AF3:01ED C7C60660      MOV	SI,6006                            
0AF3:01F1 C7C7C600      MOV	DI,00C6                            
0AF3:01F5 C7C7C660      MOV	DI,60C6                            
0AF3:01F9 7CC7          JL	01C2                               
0AF3:01FB 7D60          JGE	025D                               
0AF3:01FD 0000          ADD	[BX+SI],AL                         
0AF3:01FF 0000          ADD	[BX+SI],AL                         
-q
