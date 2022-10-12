CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h





start:
	;include	dos52.dbg

begin:	mov	dx, 01800h
	mov	ax, 01300h
	mov	bx, 0007
	mov	cx, 034h
	lea	bp, msg1
	int	10h
	mov	ah, 2
	xor	bx, bx
	xor	cx, cx
	mov	dx, 01914h
	int	10h
	xor	ax, ax
	int	16h
	mov	ah, 0eh
	int	10h
	mov	ax, 201
	xor	bx, bx
	xor	cx, cx
	xor	dx, dx
	int	13h
	jmp	begin

msg1	db 0ah,0dh,0ah,0ah,0ah,'Not ready reading drive A'
	db 0ah,0dh,'Abort, Retry, Fail? $'


CODE     ENDS
	 END   START
