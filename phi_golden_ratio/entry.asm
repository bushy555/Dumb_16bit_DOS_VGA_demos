;Display the Golden Ratio (phi) accurate to 2400 places after the decimal point
; I've put no thought into the algorithm what so ever. I just tried file-size optimising the example.asm listing.
; 21 bytes in seven calls. yeesh - I'm hopeless, but wanna learn off you other guru's.
; Thanks to Peter Blick for a *blatant* 2 byte over look!
;
; Dave "Bushy" Maunder.  29/May/2k6.
;
;
;Assemble with:
; tasm /m example
; tlink /t example


	.486
cseg	segment dword public use16 'code'
	assume	cs:cseg, ds:cseg, es:cseg, ss:cseg

siz	equ	3433			;size of the array
	org	100h
start:	inc	ax			; ax := 0001
        mov     cx, siz			; Dump out the 3433 byte table
        mov     di, offset array + 4
        rep     stosw
	mov	si, 801			;calculate 800*3 digits after the decimal point
phi10:	mov	bx, siz-1		;J:= siz-1			bx = J
phi20:	xor	eax, eax
	call	@@5			; am doing some weird stuff here. This somehow just works.
	call	@@6
	imul	edi, ebx, 2
	dec	di
	mul	edi
	xchg	edi, eax
	dec	bx			;J--
	ja	phi20			;for each element in array (except the first)...
phi30:	test	cx, cx			; Been here yet?  (1)
	je	phi50			
phi40:	call	@@4
	add	ax, [array]
	mov	bp, 100
	call	@@3
	mov	bp, 10			; aam should fit in here...
	call	@@3
phi50:	call	@@31
	inc	cx
	call	@@4
	mov	[array], dx
	dec	si
	jnz	phi10
	mov	ah, 2		
	mov	dl, 0Dh			;output carriage return
	int	21h
	mov	al, 0Ah			;output line feed
	jmp	@@32			; saves 1 byte by jmping down there to exit.
@@3:	cwd				;xor dx, dx
	div	bp			;ax(q):dx(r):= dx:ax/bp
@@31:	or	al, '0'			;convert to ASCII
@@32:	push	dx			;save remainder
	xchg	dx, ax			; mov dl, al		;output character
	mov	ah, 2			;output char
	int	21h
	test	cx, cx			; very wasteful - couldnt work out how to incorporate this above (1)
	jne	phi53
	mov	dl, '.'
	int	21h
phi53:	pop	ax			;get remainder
	ret

@@6:	xchg	ax, dx
@@5:	push	bx
	shl	bx, 1			;index words (instead of bytes)
	xchg	ax, [bx+array]		;edi:= edi + array(J)*1000
	pop	bx
	imul	eax, 1000		; help! I need another register to hold '1000'
	add	edi, eax
	imul	ebp, ebx, 10		;array(J):= rem(edi/(J*10))
	jmp	@@41
@@4:	mov	bp, 1000
@@41:	mov	eax, edi		;numOut:= array(0) + edi/1000
	cdq				; xor	edx, edx
	div	ebp			;eax(q):edx(r):= edx:eax/ebp
	ret


array	dw	1, 6			;start with '1.6'
	dw	siz-3 dup (?)

cseg	ends
	end	start
