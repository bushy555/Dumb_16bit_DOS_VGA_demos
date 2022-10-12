
CODE	SEGMENT PARA
	ASSUME CS:CODE, DS:code, SS:code, ES:code

org 100h
START:
	include	dos5head.inc
	jmp	begin
	walk0	db	'  Û '
		db	'  ³  '
		db	' /³\ '
		db	'  ³  '
		db	' / \ '
		db	' ³  \'
	walk1	db	'  Û '
		db	'  ³  '
		db	' /³³ '
		db	'  ³  '
		db	' / \ '
		db	' \  ³'
	walk2	db	'  Û '
		db	'  ³  '
		db	' ³³\ '
		db	'  ³  '
		db	' ³ ³ '
		db	'  \/ '
	walk3	db	'  Û '
		db	'  ³  '
		db	'  ³  '
		db	'  ³  '
		db	'  ³³ '
		db 	'  \³ '
        
;----------------------------------------------------------
begin:
	mov	ax, 0b800h
	mov	es, ax
	mov	ds, ax
	mov	dx, 000ffh
@l0:	mov	ax, 0460h
	mov	si, ax
	mov	di, ax
	mov	cx, 0b40h
@l1:	lodsb
	cmp	al, 020h
	je	@l3
	inc	ax
	stosb
@l2:	inc	si
	inc	di
	loop	@l1
	dec	dx
	jg	@l0
	jmp	picy
@l3:	inc	di
	jmp	@l2


picy:	push	cs
	pop	ds
	mov	bx, 0460h
	mov	ax, 007dbh
	call	fill

	mov	bx, 0640h
	mov	ax, 007b2h
	call	fill

	mov	bx, 0820h
	mov	ax, 007b1h
	call	fill

	mov	bx, 0a00h
	mov	ax, 007b0h
	call	fill

	xor	cx, cx
	mov	bx, 0be0h	

mainline:
	cmp	bx, 0c7ah 
	jng 	@a1
	lea	dx, walk4+07b00h
	push	es
	push	cs
	pop	es
	mov	di, dx
	mov	cl, 30
	mov	al, 32
	repz	stosb
	pop	es
	mov	bx, 0c7ah
	call	disp
	mov	bx, 0be0h
@a1:	call	cruise
	jmp	mainline


Delay:
	mov	cl, 003h
Del4:
	hlt
	loop Del4
	ret
;------
;hlt
;------


Disp:
	mov 	si, dx
	mov	ax, bx
	mov	di, ax
	mov	cl, 5
a:	lodsb
	mov	ah, 07
	stosw
	loop	a
	mov	cl, 5
	mov	ax, bx
	add	ax, 0a0h
	mov	di, ax
a2:	lodsb
	mov	ah, 07
	stosw
	loop	a2
	mov	cl, 5
	mov	ax, bx
	add	ax, 0140h
	mov	di, ax
a3:	lodsb
	mov	ah, 07
	stosw
	loop	a3
	mov	cl, 5
	mov	ax, bx
	add	ax, 01e0h
	mov	di, ax
a4:	lodsb
	mov	ah, 07
	stosw
	loop	a4

	mov	cl, 5
	mov	ax, bx
	add	ax, 0280h
	mov	di, ax
a5:	lodsb
	mov	ah, 07
	stosw
	loop	a5
	mov	cl, 5
	mov	ax, bx
	add	ax, 0320h
	mov	di, ax
a6:	lodsb
	mov	ah, 07
	stosw
	loop	a6

	call	delay
	inc	bx
	inc	bx

	ret


Cruise:


	lea	dx, walk0+07b00h
	call	disp
	lea	dx, walk1+07b00h
	call	disp
	lea	dx, walk2+07b00h
	call	disp
	lea	dx, walk3+07b00h
	call	disp
	lea	dx, walk2+07b00h
	call	disp
	lea	dx, walk1+07b00h
	call	disp

	ret

fill:
	mov	di, bx
	mov	cl, 0f0h
	repz	stosw
	ret
walk4 label word

CODE	ENDS
	END	START