
          
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³                                  ³READ³                                  ³
;³                                  ÀÄÄÄÄÙ                                  ³
;³                                                                          ³
;³   BROWSE.COM + SQUID2.COM together, to give an Adlib-Text file reader.   ³
;³                                                                          ³
;³BROWSE.ASM -- Full Screen File Pager                                      ³
;³====================================                                      ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

TRACKS  EQU     7                       ; numero de trilhas para musica

CSEG		Segment
		Assume	CS:CSEG, DS:CSEG, ES:CSEG, SS:CSEG
		Org	0080h
Parameter	Label	Byte
		Org	0100h
		.386
Entry:		Jmp Begin

;	All Data
;	--------

		db	'ATTR='
Attribute	db	0		; Current screen attribute
		db	'SHIFT='
ShiftHoriz	db	8		; Horizontal shift screen default
DosVersionFail	db	'Requires DOS 2.0 or above$'
NoSpaceFail	db	'Not enough memory$'
FileFail	db	'File Not Found$'
ScreenFail	db	'Unsupported video mode$'
ENDMessage	db 	'Written by Bushy. April 1996.$'
Delimiters	db	9,' ,;=/'	; Delimiters in parameter
FileHandle	dw	?		; Use for saving file handle
WSMode		db	0FFh		; AND value for non-WordStar mode
LineLength	db	?		; Length of line (from BIOS)
NumberLines	db	25,0		; Number of lines (check EGA BIOS)
ScreenSize	dw	?		; Size of screen in bytes
CheckRetrace	db	1		; Flag zero if EGA or MONO used
Addr6845	dw	?		; Could use for retrace check	
ScreenAddr	Label	DWord		; Address of screen
ScreenOff	dw	0		; Higher for non-page 0
ScreenSeg	dw	0B800h		; Set to B000h for Mono Mode 7
ScreenStart	dw	?		; Points within buffer 
EndOfFile	dw	?		; Points within buffer
FileOffset	dw	-1, -1		; Address within file of buffer data
HorizOffset	dw	0		; Horizontal offset for display	
RightMargin	dw	0		; Right margin for offset display
Dispatch	dw	Home, Up, PgUp, Dummy, Left
		dw	Dummy, Right, Dummy, EndKEY, Down, PgDn

note2freq       dw      16bh, 181h, 198h, 1b0h, 1cah, 1e5h
                dw      202h, 220h, 241h, 263h, 287h, 2aeh

reg_index       db      00h, 01h, 02h, 08h, 09h, 0ah, 10h, 11h, 12h

arpegiator      db  0,0,5,5,10,10,5,5,40h

arp_pattern LABEL BYTE
db  051h,0a0h,0b0h,0b0h,0a0h,097h,0a7h,0a0h,0b0h
db  0a0h,0b0h,0b0h,0a0h,097h,0a0h,0a7h,0b0h,040h

arp2 LABEL BYTE
db  053h,0d0h,0c7h,0c5h,0c0h,0b7h,0b5h,0b0h,0a7h
db  0d0h,0c7h,0c5h,0c0h,0b7h,0b5h,0b0h,0a7h,13h,13h,040h

basso LABEL BYTE
db  07fh,0a0h,057h,09ah,0a0h                    ; C
db  07fh,095h,057h,000h,090h                    ; F
db  07fh,09ah,057h,000h,0a0h                    ; Bb
db  07fh,095h,057h,004h,008h,0a5h,0a7h,040h     ; F

solo LABEL BYTE
db  06fh,0a0h,000h,0a5h,000h,0aah,057h
db  0aah,0a9h,0a5h,0a2h,06fh,0a0h,000h
db  06bh,0b5h,063h,0b4h,057h,0aah,0b0h
db  07fh,0b5h,057h,0bah,0b9h,06fh,0b5h
db  07fh,000h,000h;,000h
db  06bh,0b5h,063h,0b4h,057h,0b4h,0b5h
db  06bh,0bah,06bh,0b9h,057h,0b0h
db  067h,0b4h,053h,0b5h
db  06bh,0b2h,053h,0b4h,0b5h
db  06fh,0bah,0b9h,06fh,000h,000h
db  000h,0a9h,0b2h,0b5h,0b9h,0a9h,040h

bassdrum LABEL BYTE
db  057h,080h,040h

snaredrum LABEL BYTE
db  057h,000h,051h,090h,000h,000h,090h
db  057h,000h,05fh,090h,090h
db  051h,006h,006h,090h,000h,090h,090h,40h

instruments LABEL BYTE
arpeg           db  00h,  05h, 086h, 0c1h,  02h       ; <-- op 1 (modulator)
                db  00h,  05h, 0d6h, 0c1h,  03h,  03h ; <-- op 2 (carrier)

brass           db  02h,  08h, 0f2h, 0c1h,  01h
                db  01h,  4ah, 082h, 0c1h,  03h,  03h

synth           db  00h, 03fh, 0f6h,  05h,  02h
                db  01h, 03fh, 0f6h,  05h,  03h,  03h

laserharp       db  01h,  3fh, 071h,  02h,  01h
                db  01h,  3fh, 071h,  02h,  02h,  02h

bdrum           db  00h,  03h, 0a7h, 0ffh,  00h
                db  00h,  02h, 0e7h, 0ffh,  00h,  00h

sdrum           db  05h,  3fh, 0f8h, 0ffh,  01h
                db  06h,  3fh, 0f8h, 0ffh,  02h,  0eh


;----------------------------------------------------------------------------;
;  Dados. Os valores nao-inicializados das tabelas nao contam no tamanho     ;
;  do .COM resultante, e por isso sao deixadas no final. Isso evita o uso    ;
;  de utilit rios que removem os dados nao-inicializados.                    ;
;----------------------------------------------------------------------------;

a_ptr           dw      OFFSET arpegiator

sm_table        db      0c2h,0c0h,0c3h,0c1h,0dbh,0c8h,037h,0c3h
                db      0c6h,0c4h,0c7h,0c5h,0c9h,0dbh,0dbh,0c5h
                db      000h,000h,000h,000h,000h,000h,0dbh

base            LABEL   WORD                    ; offset base de cada trilha
canal1          dw      OFFSET arp_pattern
canal2          dw      OFFSET solo
canal3          dw      OFFSET arp2
canal4          dw      OFFSET basso
canal5          dw      OFFSET bassdrum
canal6          dw      OFFSET snaredrum
canal7          dw      OFFSET solo             ; chorus para o solo

finetune        LABEL   BYTE                    ; afina‡ao (usada p/ chorus)
                db      0
                db      4
                db      ?
                db      ?
                db      ?
                db      ?
                db      ?

track           LABEL   WORD                    ; offset atual da trilha
                dw      TRACKS dup (?)

notelen         LABEL   WORD                    ; dura‡ao de nota atual
                dw      TRACKS dup (?)

timer           LABEL   WORD                    ; timer para cada trilha
                dw      TRACKS dup (?)



;	Check DOS Version for 2.0 or above
;	----------------------------------

Begin:		

start:  
	cld                             ; Sou eu!
        cli
	call	init

		Cld			; All string directions forward
		Mov	AH,30h
		Int	21h		; Get DOS Version Number
		Cmp	AL,2		; Check for 2.0 or later
		Jae	DOSVerOK
		Mov	DX,Offset DOSVersionFail
ErrorExit:	Mov	AH,9		; Write error message
		Int	21h
		Int	20h

;	Parse Command Line to get File Name and WordStar flag
;	-----------------------------------------------------

DOSVerOK:	Mov	SI,1 + Offset Parameter	; Points to parameter
NameSearch:	Lodsb				; Get byte
		Cmp	AL,13			; Check if carriage return
		Jz	NoFileFound		; If so, no file name
		Mov	DI,Offset Delimiters	; String of delimiters
		Mov	CX,5			; Number of delimiters (no /)
		Repne	Scasb			; See if a match
		Je	NameSearch		; If a delimiter, keep looking
		Mov	DX,SI			; Otherwise found file name
		Dec	DX			; Points to beginning of it
EndSearch:	Lodsb				; Get next byte
		Cmp	AL,13			; See if carriage return
		Je	GotFileEnd		; If so, we're all done
		Mov	DI,Offset Delimiters	; String of delimiters
		Mov	CX,6			; Number (including /)
		Repne	Scasb			; See if a match
		Jne	EndSearch		; If not, still in file name
		Mov	Byte Ptr [SI - 1],0	; If so, mark end of file name
		Jcxz	GotFlag			; If slash, check for W
		Jmp	EndSearch		; Or continue flag search
GotFlag:	Lodsb				; Get byte after / flag
		Or	AL,20h			; Uncapitalize
		Cmp	AL,'w'			; See if w for WordStar mode
		Jnz	GotFileEnd		; If not, just ignore it
		Mov	[WSMode],7Fh		; AND value for WordStar

;	Open the File
;	-------------

GotFileEnd:	Mov	Byte Ptr [SI - 1],0	; Mark end of file name
						; DX still points to name
		Mov	AX,3D00h		; Open file for reading
		Int	21h			;   by calling DOS
		Jnc	GotTheFile		; If no error, continue	
NoFileFound:	Mov	DX,Offset FileFail	; Otherwise print a message 
		Jmp	ErrorExit
GotTheFile:	Mov	[FileHandle],AX		; Save the file handle

;	Get Screen Mode Information from BIOS Data Area
;	-----------------------------------------------

		Push	ES			; Save register
		Sub	AX,AX
		Mov	ES,AX			; Set ES to 0 (BIOS Data)
		Mov	AL,ES:[0449h]		; Current Video Mode

;;;
		CMP	WORD PTR ES:[0463H],03D4H	; MONOCHROME EMULATION?
		JZ	CHK_IF_TEXT			; NO
		MOV	[SCREENSEG],0B000H		; ELSE ADDRESS MONO
		MOV	[CHECKRETRACE],0		; NO RETR. CHECK NEEDED
CHK_IF_TEXT:
;;;

		Cmp	AL,3			; Check if Color Alpha
		Jbe	DisplayOK		; Continue if so
		Cmp	AL,7			; Check if monochrome display
		Je	Monochrome		; If so, branch
;;;
		MOV	AX,1A00H		; VGA-ONLY BIOS CALL: READ
		INT	10H			;  DISPLAY COMBINATION CODE
		CMP	AL,1AH			; VGA ADAPTER?
		JNZ	TO_SCREENFAIL		; NO, SORRY
		MOV	[CHECKRETRACE],0	; ELSE NO RETRACE CHECK NEEDED
		MOV	DX,3CEH
		MOV	AL,6			; READ BIT 0 OF THE VGA GRAPHICS
		CLI				;  CONTROLLER'S "MISCELLANEOUS"
		OUT	DX,AL			;  REGISTER AT PORT 3CEh, INDEX
		INC	DX			;  6.  IF BIT IS SET THEN WE'RE
		JMP	SHORT $+2		;  *REALLY* IN A GRAPHICS MODE
		IN	AL,DX			;
		STI				;
		TEST	AL,1			; WELL?
		JZ	DISPLAYOK		; OKAY, NOT SET = NOT GRAPHICS
TO_SCREENFAIL:
;;;

		Mov	DX,Offset ScreenFail	; We can't handle graphics
		Jmp	ErrorExit		; So print an error message
Monochrome:	Mov	[ScreenSeg],0B000h	; Use Monochrome Segment
		Mov	[CheckRetrace],0	; Don't have to check retrace
DisplayOK:	Mov	AL,ES:[044Ah]		; Number of Columns
		Mov	[LineLength],AL		; Save it
		Mov	AX,ES:[044Eh]		; Offset into screen buffer
		Mov	[ScreenOff],AX		; Save it		 
		Mov	AX,ES:[0463h]		; Address of 6845 Regsiter
		Mov	[Addr6845],AX		; Save it
		Push	ES
		Sub	DL,DL			; Set Rows to zero first
		Sub	BH,BH
		Mov	AX,1130h		; EGA BIOS: Get Information
		Int	10h
		Pop	ES
		Or	DL,DL			; Check if DL is still zero
		Jz	NoEGA			; If so, skip rest of stuff
		Inc	DL
		Mov	[NumberLines],DL	; Save Number of Lines
		Test	Byte Ptr ES:[0487h],4	; Check if must check retrace
		Jnz	NoEGA
		Mov	[CheckRetrace],0	; EGA says we don't have to
NoEGA:		Mov	BH,ES:[0462h]		; Get Current Page (use later)
		Pop	ES
		Mov	AL,[LineLength]		; Length of each line
		Mul	[NumberLines]		; Total chars on screen
		Add	AX,AX			; Double for attributes
		Mov	[ScreenSize],AX		; And Save it

;	See if enough memory is left
;	----------------------------

		Add	AX,Offset ScreenHold	; Add ScreenSize to code end
		Add	AX,256			; Add a little stack room
		Cmp	AX,SP			; Check against stack pointer
		Jbe	GotEnufMemory		; Continue if OK
		Mov	DX,Offset NoSpaceFail	; Otherwise end program
		Jmp	ErrorExit		;    with error messae
		
;	Get Current Screen Attribute
;	---------------------------- 

GotEnufMemory:	Cmp	[Attribute],0		; Check if attribute pre-set
		Jnz	GotAttribute		; If so, move on
		Mov	DL,' '			; Write out a byte
		Mov	AH,2			;   using DOS
		Int	21h
		Mov	AL,8			; Now backspace
		Mov	AH,14			;   using BIOS call
		Int	10h
		Mov	AH,8			; Read character & attribute
		Int	10h			;   using BIOS call (BH = pg)
		Mov	[Attribute],AH		; And save attribute

;	Save Current Screen
;	-------------------

GotAttribute:	Mov	DX,Offset Terminate	; Set Ctrl-Break exit
		Mov	AX,2523h		;   to terminate that way
		Int	21h

;;;

SAVE_CURSOR:	MOV	AH,0FH
		INT	10H		      ; VIDEO PAGE INTO BH
		MOV	AH,3
		INT	10H		      ; READ CURSOR POSITION
		JMP	SHORT SAVE_CURSOR_2
SAVED_CURSOR	DW	0		      ; STORAGE SPACE (A KLUDGE, I KNOW)
SAVE_CURSOR_2:	MOV	SAVED_CURSOR,DX
		MOV	AH,2
		MOV	DX,-1
		INT	10H		      ; CURSOR TO TIMBUKTU FOR NOW

;;;

		Mov	DI,Offset ScreenHold	; Destination of screen
		Mov	CX,[ScreenSize]		; Size of screen
		Push	DS			; Save Source Segment
		Lds	SI,[ScreenAddr]		; Get screen address
		Rep	Movsb			; Move in the bytes
		Pop	DS			; Restore Source Segment

;	Get Keyboard Key and Decide on Action
;	-------------------------------------

		Call	Home			; Read file in
		Mov	[ScreenStart],SI	; Set buffer address
KeyLoop:	
		Call	UpDateScreen		; Write file to screen
@_fred:
	        call vwait
	        call play
GetKey:		mov	ah, 1
		int	16h
		je	@_fred
		Mov	AH,8			; Get key
		Int	21h			;   by calling DOS
		Cmp	AL,27			; Check if ESC
		Je	Terminate		; If so, terminate 
		Cmp	AL,0			; Check if extended
		Jnz	GetKey			; If not, try again
		Mov	AH,8			; Get extended code
		Int	21h			;   by calling DOS
		Sub	AL,71			; Subtract Home key value
		Jb	GetKey			; If below that, not valid
		Cmp	AL,(81 - 71)		; Check if above PgDn
		Ja	GetKey			; If so, ignore it
		Sub	AH,AH			; Zero out top byte
		Add	AX,AX			; Double for word access
		Mov	BX,AX			; Offset in dispatch table
		Mov	SI,[ScreenStart]	; Set current buffer pointer
		Call	[Dispatch + BX]		; Do the call
		Mov	[ScreenStart],SI	; Set new buffer pointer
		Jmp	KeyLoop			; And update the screen

;	Terminate -- Restore screen and close file
;	------------------------------------------

Terminate:	Mov	SI,Offset ScreenHold	; Address of Saved Screen
		Les	DI,[ScreenAddr]		; Address of Display
		Mov	CX,[ScreenSize]		; Number of characters
		Rep	Movsb			; Move them back 
		Mov	BX,[FileHandle]		; Get File Handle
		Mov	AH,3Eh			; Close File
		Int	21h

;;;

RESTORE_CURSOR:	MOV	AH,0FH
		INT	10H			; VIDEO PAGE INTO BH
		MOV	AH,2
		MOV	DX,SAVED_CURSOR
		INT	10H			; RESTORE ENTRY CURSOR POSITION
;;;
		call	reset
		mov	ah, 9
		mov	dx, offset endmessage
		int	21h

		Int	20h			; Terminate

;	Cursor Key Routines -- Home Key
;	-------------------------------

Home:		Sub	BX,BX			; For zeroing out values
		Mov	AX,[FileOffset]		; Check if read in file
		Or	AX,[FileOffset + 2]
		Mov	[FileOffset],BX		; Zero out file address
		Mov	[FileOffset + 2],BX
		Mov	[HorizOffset],BX	; Zero out horizontal offset	
		Mov	SI,Offset Buffer	; Reset buffer pointer	
		Jz	Dummy			; Skip file read if in already
		Mov	DX,Offset Buffer	; Area to read file in
		Mov	CX,32768		; Number of bytes to read
		Call	FileRead		; Read in file
Dummy:		Ret

;	Up and PgUp Keys
;	----------------

Up:		Call	GetPrevChar		; Get previous char in buffer
		Jc	UpDone			; If none available, finish
UpLoop:		Call	GetPrevChar		; Get previous char again
		Jc	UpDone			; if none, we're done
		Cmp	AL,10			; Check if line feed
		Jnz	UpLoop			; If not, try again 
		Call	GetNextChar		; Get char after line feed
UpDone:		Ret

PgUp:		Mov	CX,Word Ptr [NumberLines]	; Number of lines
PgUpLoop:	Call	Up			; Do UP that many times
		Loop	PgUpLoop
		Ret

;	Left and Right Keys
;	-------------------

Left:		Mov	[HorizOffset],0		; Reset Horizontal Offset
		Ret

Right:		Mov	AL,[ShiftHoriz]		; Get places to shift
		Sub	AH,AH
		Add	[HorizOffset],AX	; Move that many right
		Ret

;	End, Down, and PgDn Keys
;	------------------------

EndKEY:		Mov	BX,SI			; Save buffer pointer
		Call	PgDn			; Go page down
		Cmp	BX,SI			; Check if we did so
		Jnz	EndKEY			; If so, do it again
		Ret

Down:		Call	GetNextChar		; Get next character
		Jc	NoMoreDown		; If no more, we're done
DownLoop:	Call	GetNextChar		; Get one again
		Jc	UpLoop			; If no more, find prev LF
		Cmp	AL,10			; See if line feed
		Jnz	DownLoop		; If not, continue
NoMoreDown:	Ret

PgDn:		Mov	CX,Word Ptr [NumberLines]	; Number of lines
PgDnLoop:	Call	Down			; Do DOWN that many times
		Loop	PgDnLoop
		Ret

;	Update Screen
;	-------------

UpdateScreen:	Push	ES
		Mov	SI,[ScreenStart]	; Address of data in buffer
		Les	DI,[ScreenAddr]		; Address of display
		Mov	CX,ScreenSize		; Number of bytes in screen
		Shr	CX,1			; Half for number of chars
		Mov	AL,' '			; Will blank screen
		Mov	AH,[Attribute]		; With screen attribute
		Rep	Stosw			; Blank it
		Mov	AL,[LineLength]		; Length of display line
		Sub	AH,AH
		Add	AX,[HorizOffset]	; Add Horizontal Offset
		Mov	[RightMargin],AX	; That's right display margin
		Sub	DL,DL			; Line Number
LineLoop:	Sub	BX,BX			; Column Number
		Mov	AL,[LineLength]		; Use Line Length
		Mul	DL			;   and Line Number
		Add	AX,AX			;     to recalculate
		Mov	DI,AX			;       display destination
		Add	DI,[ScreenOff]		; Add beginning address	
CharLoop:	Call	GetNextChar		; Get next character
		Jc	EndOfScreen		; If no more, we're done
		And	AL,[WSMode]		; Will be 7Fh for WordStar
		Cmp	AL,13			; Check for carriage return
		Je	CharLoop		; Do nothing if so
		Cmp	AL,10			; Check for line feed
		Je	LineFeed		; Do routine if so
		Cmp	AL,9			; Check for tab
		Je	Tab			; Do routine if so
		Mov	CX,1			; Just 1 char to display
PrintChar:	Cmp	BX,[HorizOffset]	; See if we can print it
		Jb	NoPrint		
		Cmp	BX,[RightMargin]	; See if within margin
		Jae	NoPrint
		Mov	AH,[Attribute]		; Attribute for display
		Cmp	[CheckRetrace],0	; See if must stop snow
		Jz	WriteIt			; If not, skip retrace wait
		Push	BX
		Push	DX
		Mov	BX,AX			; Save character and attribute
		Mov	DX,[Addr6845]		; Set up I/O address
		Add	DX,6 
RetraceWait1:	In	AL,DX			; Check until
		Shr	AL,1			;   vertical retrace
		Jc	RetraceWait1		;     ends
		Cli				; Clear interrupts
RetraceWait2:	In	AL,DX			; Check until
		Shr	AL,1			;   vertical retrace
		Jnc	RetraceWait2		;     begins
		Mov	AX,BX			; Get back character & attr
		Stosw				; Write to display
		Sti				; Enable interrupts again
		Pop	DX
		Pop	BX
		Jmp	Short NoPrint		; Skip around "no snow" write
WriteIt:	Stosw				; Write without retrace wait
NoPrint:	Inc	BX			; Bump up line counter
		Loop	PrintChar		; Do it CX times
		Jmp	CharLoop		; Then go back to top
Tab:		Mov	AX,BX			; Current column number
		And	AX,07h			; Take lower three bits
		Mov	CX,8
		Sub	CX,AX			; Subtract from 8
		Mov	AL,' '			; Will print CX blanks
		Jmp	PrintChar
LineFeed:	Inc	DL			; Next line
		Cmp	DL,[NumberLines]	; See if down at bottom
		Jb	LineLoop		; If not, continue
EndOfScreen:	Pop	ES			; All done -- leave
		Ret

;	Get Next Character from buffer
;	------------------------------
;		(Input is SI pointing to buffer, Returns AL, CY if no more)

GetNextChar:	Cmp	SI,[EndOfFile]		; See if at end of file
		Jae	NoMoreNext		; If so, no more chars
		Cmp	SI,Offset BufferEnd	; See if at end of buffer
		Jb	CanGetNext		; If not, just get character
		Push	CX			; Otherwise save registers
		Push	DX
		Push	DI
		Push	ES
		Push	DS			; Set ES to DS
		Pop	ES			;   (could be different)
		Mov	SI,Offset BufferMid	; Move 2nd buffer half
		Mov	DI,Offset Buffer	;   to 1st buffer half	
		Mov	CX,16384	   
		Sub	[ScreenStart],CX	; New buffer pointer
		Rep	Movsb			; Move them
		Mov	SI,DI			; SI also buffer pointer
		Add	[FileOffset],32768 	; Adjust file addr to read
		Adc	[FileOffset + 2],0 
		Mov	DX,Offset BufferMid	; Place to read file
		Mov	CX,16384		; Number of bytes
		Call	FileRead		; Read the file
		Sub	[FileOffset],16384	; Now adjust so reflects
		Sbb	[FileOffset + 2],0	;   1st half of buffer
		Pop	ES			; Get back registers
		Pop	DI
		Pop	DX
		Pop	CX
		Jmp	GetNextChar		; And try again to get char
CanGetNext:	Lodsb				; Get the character
NoMoreNext:	Cmc				; So CY set if no more
		Ret				

;	Get Previous Character from buffer
;	----------------------------------

GetPrevChar:	Cmp	SI,Offset Buffer	; See if at top of buffer
		Ja	CanGetPrev		; If not, just get character
		Mov	AX,[FileOffset]		; See if at top of file
		Or	AX,[FileOffset + 2]
		Jz	AtTopAlready		; If so, can't get anymore
		Push	CX			; Save some registers
		Push	DX
		Mov	SI,Offset Buffer	; Move 1st half of buffer
		Mov	DI,Offset BufferMid	;   to 2nd half of buffer
		Mov	CX,16384
		Add	[ScreenStart],CX	; New buffer pointer
		Rep	Movsb			; Do the move
		Sub	[FileOffset],16384	; Adjust file addr for read
		Sbb	[FileOffset + 2],0
		Mov	DX,Offset Buffer	; Area to read file into
		Mov	CX,16384		; Number of bytes
		Call	FileRead		; Read the file
		Pop	DX			; Get back registers
		Pop	CX
		Jmp	Short CanGetPrev	; Now get character
AtTopAlready:	Stc				; CY flag set for no more
		Ret
CanGetPrev:	Dec	SI			; Move pointer back
		Mov	AL,[SI]			; Get the character
		Clc				; CY flag reset for success
		Ret

;	Read CX bytes from the file into DX buffer
;	------------------------------------------ 	

FileRead:	Push	AX			; Save some registers
		Push	BX
		Push	CX
		Push	DX
		Mov	[EndOfFile],-1		; Initialize this
		Mov	DX,[FileOffset]		; Get file address to read
		Mov	CX,[FileOffset + 2]
		Mov	BX,[FileHandle]		; Get file Handle
		Sub	AL,AL			; Do LSEEK from beginning
		Mov	AH,42h			; LSEEK call
		Int	21h
		Pop	DX			; Get back destination
		Pop	CX			; Get back count
		Mov	AH,3Fh			; Read file function call
		Int	21h
		Jnc	NoReadError		; If no error, continue
		Sub	AX,AX			; Otherwise read zero bytes
NoReadError:	Cmp	AX,CX			; See if 32K has been read
		Je	GotItAll		; If so, we're home free
		Add	AX,DX			; Otherwise add to buffer addr
		Mov	[EndOfFile],AX		; And save as end of file
GotItAll:	Pop	BX
		Pop	AX
		Ret



init	proc	near
;        mov     di,OFFSET finetune+2    ; Inicializa vari veis e tabelas
;        mov     cx,6*TRACKS+2*19636     ; em zero
;        repz    stosb                   ; sai com ax==cx==0
        call    reset                   ; Reseta Adlib, sai com cx==0;
        mov     si,OFFSET base          ; Inicializa‡ao das trilhas
        mov     di,OFFSET track
        mov     cx,TRACKS
        repz    movsw                   ; Sai com ax==cx==0
; --- Inicializa‡ao da Adlib
        mov     ax,0120h                ; Habilita bit 5 do reg 1 da Adlib
        call    addata                  ; (Waveforms)

        mov     cl,6                    ; 6 instrumentos a programar
        xor     bx,bx                   ; iniciando no canal 1
        mov     si,OFFSET instruments   ; a partir do 1o instrumento
        call    set_instr

        inc     cx                      ; Chorus para o canal 4
        mov     si,OFFSET brass
        call    set_instr
	ret
init	endp






;----------------------------------------------------------------------------;
;  Loop Principal                                                            ;
;----------------------------------------------------------------------------;


mainloop:

vwait   PROC    NEAR
        mov     dx,3dah                 ; Espera o retra‡o vertical
@@vw1:  in      al,dx                   ; (o timing ‚ realizado atrav‚s da
        and     al,08h                  ; espera de retraco. Se o micro
        jnz     @@vw1                   ; for suficientemente lento para
@@vw2:  in      al,dx                   ; nao poder fazer os calculos entre
        and     al,08h                  ; dois retra‡os, haver  perda de
        jz      @@vw2                   ; sincronismo)
        ret
vwait   ENDP


; --- Mini-player para Adlib

play    PROC    NEAR
        xor     bx,bx                   ; bx indica o canal atual
        mov     cx,TRACKS
@@next: mov     ax,timer[bx]            ; Coleta o timer para o canal
        or      ax,ax                   ; Verifica se expirou
        jnz     @@next_timer

        xor     dx,dx                   ; Zera transposi‡ao
        or      bx,bx                   ; O canal 1 (bx=0) ‚ reservado
        jnz     @@no_arp3               ; para o arpejador

        mov     si,[a_ptr]              ; dl cont‚m a quantia para
        mov     dl,[si]                 ; transposi‡ao
@@no_arp3:
        push    cx
@@reset_tr:
        mov     si,track[bx]
@@new_val:
        lodsb                           ; Coleta evento da trilha
        or      al,al                   ; Verifica se ‚ nota
        jns     @@volume

        mov     ch,al                   ; Processa nota
        and     ax,000fh
        add     ax,dx                   ; Transposi‡ao do arpejador
        cmp     al,12                   ; Verifica overflow de oitava
        jb      @@skip
        sub     al,12                   ; Ajusta overflow de oitava
        add     ch,10h
@@skip: and     cx,0f000h               ; M scara para envio de valor
        shr     ch,2                    ; para Adlib
        shl     ax,1
        add     ax,OFFSET note2freq     ; Coleta frequencia da tabela
        mov     di,ax
        or      cx,[di]
        add     cl,finetune[bx]         ; Soma afina‡ao (para chorus)
@@pause_t1:
        mov     ax,notelen[bx]          ; Coleta dura‡ao da nota
@@pause_tx:
        mov     timer[bx],ax            ; Atualiza ponteiros
        mov     track[bx],si

        mov     ah,bl
        shr     ah,1
        add     ah,0a0h
        mov     al,cl
        call    addata
        add     ah,10h
        xor     al,al
        call    addata
        mov     al,ch
        call    addata

        pop     cx
@@next_timer:
        dec     timer[bx]               ; Decrementa timer do canal atual
        inc     bx                      ; Incrementa canal
        inc     bx
        loop    @@next                  ; Proximo canal
        jmp     @@end                   ; Encerra (em condi‡oes normais
                                        ; seria um ret)
@@volume:
        jnz     @@no_pause
        xor     cx,cx
        jmp     SHORT @@pause_t1
@@no_pause:
        test    al,40h                  ; Flag que indica se um ctrl.
        jnz     @@ctrl
        mov     di,bx
        shr     di,1
        mov     ah,reg_index[di]
        add     ah,40h                  ; Operador & voz correto
                                        ; Coleta em ah o novo volume
        dec     ax
        call    addata                  ; ah= valor, al= porta
        add     ah,03h                  ; Idem para o operador 2
        lodsb
        dec     ax
        call    addata                  ; ah= valor, al= porta...
        jmp     @@new_val         ; Coleta novo valor da trilha
@@ctrl:
        and     al,3fh                  ; Processamento de controle
        jnz     @@no_40h
        mov     ax,base[bx]
        mov     track[bx],ax            ; Verifica terminador de trilha

        or      bx,bx                   ; Arpejador na trilha 0
        jnz     @@no_arp

        inc     WORD PTR [a_ptr]        ; Incrementa ptr p/ transposi‡ao
        mov     bx,[a_ptr]              ; Coleta ptr p/ transposi‡ao
@@new_arp:
        mov     dl,[bx]                 ; Transposi‡ao em dl
        cmp     dl,040h                 ; Verifica final de trilha
        jne     @@no_arp2
        mov     bx,OFFSET arpegiator    ; Reseta ponteiro de transposi‡ao **
        mov     [a_ptr],bx
        jmp     SHORT @@new_arp
@@no_arp2:
        xor     bx,bx
@@no_arp:
        jmp     @@reset_tr              ; Coleta novo valor da trilha
@@no_40h:
;       dec     al
;       jnz     @@no_41h                ; Pausa longa (nao utilizado)
;       lodsw
;       xor     cx,cx
;       jmp     @@pause_tx
;@@no_41h:                              ; Livre para uso...
;       dec     al
;       jnz     @@no_42h
;       jmp     @@new_val
@@no_42h:
        sub     al,0fh                  ; CUIDADO COM ESTE VALOR
        shl     al,2                    ;
        mov     BYTE PTR notelen[bx],al ; dh= 10h - numero de efeitos
        jmp     @@new_val               ; ja processados...
@@end:
ret
play    ENDP

; --- Verifica tecla pressionada


;----------------------------------------------------------------------------;
;  Escrita na porta de registrador e dados da Adlib                          ;
;----------------------------------------------------------------------------;

addata  PROC    NEAR                    ; Envia dado (ah) p/ porta Adlib (al)
        pusha
        xchg    al,ah
        mov     dx,388h                 ; Porta de registrador da Adlib
        out     dx,al
        mov     cx,3
@@wait: in      al,dx
        loop    @@wait                  ; Delay para registrador

        inc     dx                      ; Porta de dados da Adlib
        mov     al,ah
        out     dx,al
        mov     cl,16
        dec     dx
@@wait1:in      al,dx                   ; Delay para dados
        loop    @@wait1
        popa
        ret
addata  ENDP

;----------------------------------------------------------------------------;
;  Programa instrumento na Adlib (si= offset, bx= canal)                     ;
;----------------------------------------------------------------------------;

set_instr  PROC
@@letsgo:
        push    cx
        push    bx
        mov     ah,reg_index[bx]
        mov     dl,02
@@again:mov     cx,0004
@@loop1:add     ah,20h
        lodsb
        call    addata
        loop    @@loop1

        add     ah,60h
        lodsb
        call    addata
        sub     ah,0ddh
        dec     dl
        jnz     @@again

        add     bl,0c0h
        mov     ah,bl
        lodsb
        call    addata

        pop     bx
        pop     cx
        inc     bx
        loop    @@letsgo

        ret
set_instr  ENDP

;----------------------------------------------------------------------------;
;  Reseta Adlib                                                              ;
;----------------------------------------------------------------------------;

reset   PROC    NEAR
        mov     cl,0f5h                 ; Reseta Adlib
        xor     ax,ax
@@reset:
        mov     ah,cl
        call    addata
        loop    @@reset                 ; !!IMPORTANTE!! sai com cx==0
        ret
reset   ENDP




;	File Buffer and Screen Hold Areas
;	---------------------------------

Buffer		Label	Byte			; Area for file reads
BufferMid	equ	Buffer + 16384		; Halfway through it
BufferEnd	equ	BufferMid + 16384	; At end of it		
ScreenHold	equ	BufferEnd		; Area for holding screen
CSEG		EndS				; End of segment
		End	Entry			; Denotes entry point


