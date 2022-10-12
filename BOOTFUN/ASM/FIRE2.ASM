
code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
start: 
	MOV     Al,13h
	INT     10h
	CLI
	MOV     DX,3c4h
	MOV     AX,604h                 ; "Unchain my heart". And my VGA...
	OUT     DX,AX
	MOV     AX,0F02h                ; All planes
	OUT     DX,AX

	MOV     DX,3D4h
	MOV     AX,14h                  ; Disable dword mode
	OUT     DX,AX
	MOV     AX,0E317h               ; Enable byte mode.
	OUT     DX,AX
	MOV     AL,9
	OUT     DX,AL
	INC     DX
	IN      AL,DX
	AND     AL,0E0h                 ; Duplicate each scan 8 times.
	ADD     AL,7
	OUT     DX,AL

	MOV     DX,3c8h                 ; Setup palette.
	XOR     AL,AL
	OUT     DX,AL
	INC     DX
	MOV     CX,64*3
	MOV     SI,OFFSET FirePal       ; Prestored...
@@pl1:
	 LODSB
	 OUT    DX,AL
	 LOOP   @@pl1
	MOV     AL,63
	MOV     CX,192*3                ; And white heat.
@@pl2:
	 OUT    DX,AL
	 LOOP   @@pl2
	STI

	MOV     DI,OFFSET Imagen        ; Cleanup both Images.
	MOV     CX,80*50
	XOR     AX,AX
	REP STOSW

MainLoop:
	MOV     DX,3DAh                 ; Retrace sync.
@@vs1:
	IN      AL,DX
	TEST    AL,8
	JZ      @@vs1
@@vs2:
	IN      AL,DX
	TEST    AL,8
	JNZ     @@vs2

	PUSH    DS
	POP     ES
	MOV     SI,81+OFFSET Imagen     ; Funny things start here. 8-P
	MOV     DI,81+OFFSET Imagen2
	MOV     CX,48*80-2
	XOR     BH,BH
@@lp:
	XOR     AX,AX
	ADD     AL,-1[SI]
	ADC     AH,BH
	ADD     AL,-80[SI]
	ADC     AH,BH
	ADD     AL,-79[SI]
	ADC     AH,BH
	ADD     AL,-81[SI]
	ADC     AH,BH
	ADD     AL,1[SI]
	ADC     AH,BH
	ADD     AL,80[SI]
	ADC     AH,BH
	ADD     AL,79[SI]
	ADC     AH,BH
	ADD     AL,81[SI]
	ADC     AH,BH
	ROR     AX,1
	ROR     AX,1
	ROR     AX,1
	TEST    AH,60h                  ; Wanna know why 60h? Me too.
	JNZ     @@nx                    ; This is pure experience.
	 CMP    DI,46*80+OFFSET Imagen2 ; And this was a bug.
	 JNC    @@dec                   ; This one's by my cat.
	  OR    AL,AL                   ; My dog coded here too.
	  JZ    @@nx                    ; I helped my sister with this one.
@@dec:
	   DEC  Ax                      ; Yeah! Cool a bit, please.
@@nx:
	INC     SI
	STOSB
	LOOP    @@lp                    ; New image stored in Imagen2.

	MOV     SI,80+OFFSET Imagen2    ; Scrolling copy. :-)
	MOV     DI,OFFSET Imagen
	MOV     CX,40*48
	REP     MOVSW

	MOV     SI,80*43+OFFSET Imagen2 ; Get rid of some ashes.
	MOV     CX,6*80
	MOV     AH,22
@@rcl:
	 MOV    AL,[SI]
	 CMP    AL,15
	 JNC    @@rcn
	  SUB   AL,AH
	  NEG   AL
	  MOV   [SI],AL
@@rcn:
	 INC    SI
	 LOOP   @@rcl

	MOV     SI,80+OFFSET Imagen2    ; And show it.
	MOV     DI,0
	MOV     AX,0A000h
	MOV     ES,AX
	MOV     CX,40*48
	REP     MOVSW

	in      al, 060h
	cmp     al, 1
	je      bye
	jmp     mainloop
;       MOV     AH,1
;       INT     16h
;       JNZ     Bye
;       JMP     MainLoop
Bye:
;       XOR     AH,AH
;       INT     16h
	MOV     AX,3
	INT     10h
;       MOV     AX,4C00h
;       INT     21h
ret


firepal label byte
	DB        0,   0,   0,   0,   1,   1,   0,   4,   5,   0,   7,   9
	DB        0,   8,  11,   0,   9,  12,  15,   6,   8,  25,   4,   4
	DB       33,   3,   3,  40,   2,   2,  48,   2,   2,  55,   1,   1
	DB       63,   0,   0,  63,   0,   0,  63,   3,   0,  63,   7,   0
	DB       63,  10,   0,  63,  13,   0,  63,  16,   0,  63,  20,   0
	DB       63,  23,   0,  63,  26,   0,  63,  29,   0,  63,  33,   0
	DB       63,  36,   0,  63,  39,   0,  63,  39,   0,  63,  40,   0
	DB       63,  40,   0,  63,  41,   0,  63,  42,   0,  63,  42,   0
	DB       63,  43,   0,  63,  44,   0,  63,  44,   0,  63,  45,   0
	DB       63,  45,   0,  63,  46,   0,  63,  47,   0,  63,  47,   0
	DB       63,  48,   0,  63,  49,   0,  63,  49,   0,  63,  50,   0
	DB       63,  51,   0,  63,  51,   0,  63,  52,   0,  63,  53,   0
	DB       63,  53,   0,  63,  54,   0,  63,  55,   0,  63,  55,   0
	DB       63,  56,   0,  63,  57,   0,  63,  57,   0,  63,  58,   0
	DB       63,  58,   0,  63,  59,   0,  63,  60,   0,  63,  60,   0
	DB       63,  61,   0,  63,  62,   0,  63,  62,   0,  63,  63,   0

Imagen  DB 80*50 DUP (?)
Imagen2 DB 80*50 DUP (?)


code    ENDS
END     start
