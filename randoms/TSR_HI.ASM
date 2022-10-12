com_seg segment
	ASSUME CS:com_seg, ds:com_seg,es:com_seg, ss:com_seg

org 100h
int8 proc far

jmp install
a db '                                 лл   лл   лллллллл                             '
db '                                 лл   лл      лл                                '
db '                                 лл   лл      лл                                '
db '                                 ллллллл      лл                                '
db '                                 лл   лл      лл                                '
db '                                 лл   лл      лл                                '
db '                                 лл   лл   лллллллл                             '

run_time:
	push si
	push di
	push cx
	push ax
	push es
	push ds
	push cs
	pop ds

	mov	ax,0b800h
	mov	es, ax
	mov	si,offset a
	mov	di, 0
	mov	ah, 00eh
	mov	cx,0230h
	next_char:	lodsb
	stosw
	loop	next_char

	pop ds
	pop es
	pop ax
	pop cx
	pop di
	pop si
	iret

install:
	mov     al, 1ch
	mov     ah, 35h
	int     21h
	mov     dx, offset run_time
	mov     al, 1ch
	mov     ah, 25h
	int     21h
	mov     dx, offset install
	int     27h        

int8	endp
com_seg ends
end int8
