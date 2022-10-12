CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h


start:
	;include	dos52.dbg

begin:	
	mov	ah, 00eh
	mov	bx, 0007
	mov	cx, 030h
	xor 	bp, bp
looping:
	mov	al, [msg1 + bp]
	inc	bp
	int	10h
	loop	looping

	xor	ax, ax
	int	16h
	mov	ah, 0eh
	int	10h
	mov	ax, 00201h
;	xor	bx, bx
;	xor	cx, cx
;	xor	dx, dx
	mov	bx, 2000
	mov	cx, 0001
	mov	dx, 0002
	int	13h
	jmp	begin

msg1 label byte
	db 0ah,0dh,0ah,'Not ready reading drive C'
	db 0ah,0dh,'Abort, Retry, Fail?'


CODE     ENDS
	 END   START
