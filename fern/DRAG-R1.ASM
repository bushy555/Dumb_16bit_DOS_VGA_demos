; Rotating DRAGON.COM
;244 bytes. ok, I guess.
;8:27pm, Saturday, 12th April, 1997. On Lukes DX'4, while in Brisbane @ 4/94.

number_1        equ     30000
comseg segment
assume cs:comseg,ds:comseg
org 100h
.386
start:  push    02000h
	pop     es
	xor     di, di
	xor     eax, eax
	mov     cx, 16000
	rep     stosd
        push    0A000h
	pop     es
        mov     ax, 013h
	int     10h
        xor     si, si
@main:  inc     si
	cmp     si, number_1
	jl      @main2
@main1: mov     cx, a
	mov     dx, b
        cmp     cx, 280  ;(319, inc Y)
	jl      @e
	dec     cx
	inc     dx
@e:     cmp     dx, 160  ;(dec X, 199)
	jl      @f
        cmp     cx, 80
	jl      @g
	dec     cx
	dec     cx
@f:     cmp     cx, 80    ;(0, dec Y)
	jg      @g
        cmp     dx, 80
	jl      @g
	dec     cx
	dec     dx
@g:     inc     cx
	mov     a, cx
	mov     b, dx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        push    ax
        mov     ax, 0a000h
        mov     es, ax
        mov     ax, 02000h
        mov     ds, ax
        mov     cx, 16000
        xor     si, si
        xor     di, di
        rep     movsd
        mov     ax, 02000h
        mov     es, ax
        xor     di, di
        xor     eax, eax
        mov     cx, 16000
        rep     stosd
        xor     si, si
        mov     ax, cs
	mov     ds, ax
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	pop     ax
        je      @quit
@main2:;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;        lea     eax, [eax + eax * 2]
imul ax, 3
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Setup
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        mov     cx, bx           ;setup for both 50%'s  NewX and NewY.
        add     cx, bp           ;  bit quicker and saves ~15 bytes.
        mov     dx, bx
        neg     dx
        add     dx, bp
        test    ax, ax
        jg      @@_1
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;  First 50%
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;        add     cx, 80          ;newx:=((0.5*x)+(0.5*y)+80);
        add     dx, 75
        sub     ax, cx          ;newy:=((0.5*-x)+(0.5*y)+75);
        mov     bx, a
        shr     bx, 1
        add     cx, bx
        mov     bx, b
        shr     bx, 1
        add     dx, bx
        jmp     @@_Calc
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;  Second 50%
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@@_1:   ; sub     cx, 80          ;newx:=((0.5*x)+(0.5*y)-80);
        add     dx, 125         ;newy:=((0.5*-x)+(0.5*y)+125);
        mov     bx, 320
        sub     bx, a
        shr     bx, 1
        add     cx, bx
        mov     bx, 200
        sub     bx, b
        shr     bx, 1
        add     dx, bx
        add     ax, cx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;   Do the (�*x)'s and (�*y)'s on NewX and NewY.                       (4)(41)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@@_calc:shr     cx, 1
        shr     dx, 1
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;PUTPIXEL routine. (x,y) -> (cx, bx)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        push    ax
        mov     bx, cx
        mov     bp, dx
        mov     ax, 02000h
        mov     es, ax
        mov     ax, 320
        mul     dx
        add     ax, cx
        add     ax, 140         ;Centre it!
        xchg    di, ax                                                 ; (1)
        mov     al, 2
        stosb
        pop     ax
	jmp     @main
@quit:  mov    ax, 0003h
	int    10h
	retn
even
        a       dw 160
        b       dw 80
	count   dw 0

comseg ends
end start







TREE
DATA 4
0.42,0.42,-0.42,0.42,0,0.2,0.4
0.42,-0.42,0.42,0.42,0,0.2,0.4
0.1,0,0,0.1,0,0.2,0.15
0,0,0,0.5,0,0,0.05


