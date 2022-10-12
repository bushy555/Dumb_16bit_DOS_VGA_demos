;                            --== Moving star ==--
; 
; * Took around 1 hour to wrack this up....   slow!!  took to long.
;
; * Move the star with arrow keys. Has border checking.
; * <ESC> - quits.
;
; * Basically, was ripped from an exercise the C++ persons had to do... and I 
;     had to prove to myself that I could do the same stuff in ASM. 
; * They took around 30-45 mins. I took an hour.
; * Also is optimized as far I can go, or at least the most I can optimize 
;     within an hour.
;
; STAR.COM:  116 bytes.


code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
mov	al, 3h
int	10h
push 0b800h
pop  es
mov	bx, 80
mov	dx, 12
jmp	short @5
key:
xor	ax, ax
int	16h
cmp	ah, 048h
je	north
cmp	ah, 050h
je	south
cmp	ah, 04bh
je	west
cmp	ah, 04dh
je	east
cmp	ah, 01h
jne	short key
quit:
ret

north:
dec	dx
jmp	short display_

south:
inc	dx
jmp	short display_

west:
dec	bx
dec	bx
jmp	short display_

east:
inc	bx
inc	bx

display_:
cmp	dx, 0
jnl	@1
mov	dx, 0
@1:
cmp	dx, 24
jng	@2
mov	dx, 24
@2:
cmp	bx, 0
jnl	@3
mov	bx, 0
@3:
cmp	bx, 159
jng	@4
mov	bx, 158
@4:

mov	al, 020h
mov	di, si
stosb
@5:
push	dx
mov	ax, 0160
mul	dx
add	ax, bx
mov	di, ax
xor	ax, ax
mov	al, "*"
mov	si, di
stosb
pop	dx
jmp	short key


   code    ENDS
END     start
