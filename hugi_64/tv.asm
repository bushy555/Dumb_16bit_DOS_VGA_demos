; TV screen.
; With <ESC> quit.
;
code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
start: 
	mov	al, 012h
	int	10h
	mov	bh, 0a0h
	mov	es, bx
@0109:  mov	di, bx
  	mov	dl, 0c0h
@0124:  mov	cx, 0141h
@0127:  rep 	movsb
@0141: 	dec 	dx
  	jnz 	@0124
  	in	al, 060h
  	cmp 	al, 01
  	jne 	short @0109
@0140:  mov 	al, 03h
  	int	10h
  	ret

   code    ENDS
END     start
