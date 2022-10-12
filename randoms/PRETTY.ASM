; Dissasmebled WORD247.COM by Bush-man on or around the 13 - August - 1995.

; Conversion to Boot-sector will start soon.


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 

@0100:  MOV     AX,0013h
@0103:  INT     10h
@0105:  push	0a000h
	pop	es

@109:   in	al, 060h
	cmp	al, 1
	jne	@here
	mov	ax, 3
	int	10h
	ret
@here:  inc	bp
@011A:  INC     CX
@01A9:  pusha
@01AA:  CALL    @01CE
@01AE:  MOV     es:[BX+DI], CH
@01B0:  popa
@01B1:  PUSH    BP
@01B2:  sar	bp, 02
@01B3:  and	bp, 000fh
@01B9:  MOV     AL, ds:[BP+ count3]
@01BD:  CBW
@01BE:  ADD     DI, AX
@01C1:  MOV     AL, ds:[BP+count4]
@01C5:  CBW
@01C6:  ADD     SI, AX
@01C8:  POP     BP
@01C9:  DEC     DL
@01CB:  JNZ     @01A9
	jmp	@109
@01CE:  sar	si, 006h
@01d1:  imul	bx, si, 0140h
@01D5:  sar	di, 006h
@01D8:  ret


count3 db 000h, 018h, 02Dh, 03Bh
count4 db 040h, 03Bh, 02Dh

@01E0:  db 018h,000h,0E9h,0D4h,0C6h,0C1h,0C6h,0D4h,0E9h,000h
	db 018h,02Dh,03Bh

   code    ENDS
END     start
