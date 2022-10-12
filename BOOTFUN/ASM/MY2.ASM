com_seg segment
	ASSUME CS:com_seg, ds:com_seg,es:com_seg, ss:com_seg

org 100h
start:
jmp run_time
       
a  db ' ллл  л л  л  ллл    л  ллл    лл   лл  л   л    лл   л  ллл  л  л              '
db '  л   л л  л  л      л  л      л л л л   л л     л л  л  л    л л               '
db '  л   ллл  л   л     л   л     л  л  л    л      л л  л   л   лл                '
db '  л   л л  л    л    л    л    л     л    л      л л  л    л  л л               '
db '  л   л л  л  ллл    л  ллл    л     л    л      лл   л  ллл  л  л  '
msg2 db 'So may I have it back please!$'
run_time:
	mov	ax, 01300h
	mov	bx, 000ah
	mov	cx, 29
	mov	dx, 01319h
	mov	bp, offset msg2;+7b20h
	int	10h

mov	bl, 00
@1:
	inc	bl
;	inc	bl
	cmp	bl, 13
	je	@2
	call	disp
	jmp	@1
@2:
	dec	bl
;	dec	bl
	cmp	bl, 0
	je	@1
	call	disp
	jmp	@2


disp:	
here7:
	in	al,060h
	cmp	al, 1
	jne	@10
	int 	20h
@10:
	mov	ax, cs
	mov	es, ax
	mov	ax, 1300h
	mov	bp, offset a;+07b20h
	mov	cx, 388
	mov	dh, 10
	mov	dl, bl
	push	bx
	mov	bx, 0eh
	int	10h
	pop	bx
	call	delay
	call	delay
	call	delay
	ret
delay:
	mov	cx, 0fff0h
delay2:
	loop	delay2

	ret

com_seg ends
end start
