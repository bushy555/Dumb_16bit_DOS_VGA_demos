%out ÿ
%out TinyWorm. (256 byte game). ripped by someone.
%out ÿ

.model tiny
.286
.code
        org     100h
s:      mov     ax,cs
        add     ax,4096
        mov     ds,ax
        push    0a000h
        pop     es

        mov     ax,19
        int     10h
        mov     di,64000
        mov     cx,1536
        rep     stosb           ;13h is fine.

        ; si remove pointer, di insert pointer, bp delay
        sub     si,si
        mov     bp,10

        jmp     mkfood

play:   push	dx
	mov     dx,03dah
lb1:    in      al,dx
        test    al,8
        jnz     lb1
lb2:    in      al,dx
        test    al,8
        jz      lb2
	pop	dx

	and     bp,bp
        jnz     norem
        lodsw
        xchg    ax,bx
        mov     byte ptr es:[bx],0
        mov     bx,ax
        inc     bp
norem:  dec     bp
        

        mov     ah,1
        int     16h
        jz      advance
        sub     ah,ah
        int     16h
	cmp	ah, 1
	je	@quit
        cmp     ah,48h
        jne     notup
        mov     dx,-320
notup:  cmp     ah,50h
        jne     notdn
        mov     dx,320
notdn:  cmp     ah,4Bh
        jne     notlt
        mov     dx,-1
notlt:  cmp     ah,4Dh
        jne     advance
        mov     dx,1
advance:

	add     bx,dx
        mov     al,es:[bx]
        and     al,al
        jz      nofix
        cmp     al,00Dh
        je      remove
@quit:	; mov	ax, 3
      	; int	10h
      	; ret
	int	19h

nofix:  mov     [di],bx
        inc     di
        inc     di
        mov     byte ptr es:[bx],9
pot     label   byte
        jmp     play

remove: push    bx
        mov     bx,cx
        sub     ax,ax
        call    pixel
        call    random
        and     ax,63
        mov     bp,ax
        mov     cs:pot+1,offset zot-offset pot-2
        pop     bx
        jmp     nofix

zot:    mov     cs:pot+1,08Bh
mkfood: push    bx
mkfod:  call    random
        and     ax,0fffeh
        mov     bx,ax
        sub     ax,ax
        cmp     word ptr es:[bx],ax
        jnz     mkfod
        cmp     word ptr es:[bx+320],ax
        jnz     mkfod
        mov     cx,bx
        mov     ax,0d0dh
        call    pixel
        pop     bx
	mov	dx, 1
        jmp     play

pixel   proc
        mov     es:[bx],ax
        mov     es:[bx+320],ax
        ret
pixel   endp

;create pseudorandom value in range of 0..65535 which is returned in ax
random  proc                            ;linear random, theoretically
;	push	cx
;        mov     ax,dx             ;returns each and every value
        push    dx
	xor	ax, ax
	int	1ah
	mov	ax, dx
        pop     dx
;        mov     cx,36421                ;between min/max in a series
;        mul     cx                      ;of max-min+1 calls
;        inc     ax
 ;       mov     dx,ax
;	pop	cx
        ret
random  endp

;cdir    dw      1

;rseed   dw      ?
;foodo   dw      ?

        end     s
