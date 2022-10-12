code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
	.386
start: 
	mov     ax, 0013h
	int     10h
	mov     dx, 03C8h
	mov     al, 01
	out     dx, al
	inc     dx
	mov     cx, 0020h
	push    cx
	sub     bh, bh
@0112:  sub     al, al
	out     dx, al
	out     dx, al
	mov     al, bh
	out     dx, al
	add     bh, 02
	loop    @0112
	pop     cx
	mov     al, 03Fh
@0121:  out     dx, al
	out     dx, al
	out     dx, al
	sub     al, 02
	loop    @0121
@main:	mov     si, bp
	mov     di, offset num5                
	mov     cx, 0100h
@0130:  mov     bl, 08
@0132:  mov     dx, 0007
	lodsb
@0136:  push    ax
	bt      ax, dx
	jnb     @0140
	mov     al, 020h
	jmp     @0142
@0140:  sub     al, al
@0142:  stosb
	pop     ax
	dec     dx
	and     dx, dx
	jnl     @0136
	dec     bl
	jne     @0132
	loop    @0130
	add     ax, 01000h
	mov     [num3], ax
	add     ax, 0960h
	mov     [num4], ax
	push    0A000h
	pop     es
	xor     di, di
	mov     esi, 0FFB33333h
@0167:  mov     cx, 0140h
	mov     ebp, 0FE733334h
@0170:  push    cx
	push    di
	sub     eax, eax
	mov     cx, ax
	mov     [num1], eax
	mov     [num2], eax
@017F:  inc     cx
	mov     eax, [num2]
	imul    eax
	shrd    eax, edx, 018h
	mov     edi, eax
	mov     eax, [num1]
	imul    eax
	shrd    eax, edx, 018h
	mov     ebx, eax
	add     eax, edi
	cmp     eax, 04000000h
	jnl     @01D3
	mov     eax, [num2]
	shl     eax, 1
	imul    dword ptr [num1]
	shrd    eax, edx, 018h
	add     eax, esi
	mov     [num2], eax
	mov     eax, ebx
	sub     eax, edi
	add     eax, ebp
	mov     [num1], eax
	cmp     cx, 0021h
	jl      @017F
@01D3:  mov     ax, cx
	dec     al
	pop     di
	stosb
	add     ebp, fredx;000051EBh
	pop     cx
	loop    @0170
	add     esi, fredy;00051EBh
	cmp     di, 0FA00h
	jne     @0167
@here_2:
	xor	ax, ax
	int	16h
	cmp	ah, 1
	je	quit
	cmp	ah, 04bh
	jne	@1
	sub	fredx, 00002000h
@1:	cmp	ah, 048h
	jne	@2
	sub	fredy, 00002000h
@2:	cmp	ah, 04dh
	jne	@3
	add	fredx, 00002000h
@3:	cmp	ah, 050h
	jne	@4
	add	fredy, 00002000h
@4:	jmp	@main

quit:
	mov     ax, 0003
	int     10h
	ret

fredy	dd 05000h;0a000h
fredx	dd 05000h;0a000h
num1    dd ?
num2    dd ?
num3    dw ?
num4    dw ?
num5    label byte 

   code    ENDS
END     start
