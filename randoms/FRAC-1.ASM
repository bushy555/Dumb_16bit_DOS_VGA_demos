maxloop equ 16

codestuff       segment
        assume  cs:codestuff, ds:codestuff
        org 100h
.386
main:
        mov     al, 13h
        int     10h

        push    0a000h
        pop     es

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Draw fractal (Zeleps method)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@@run:  xor     bx, bx
        xor     ax, ax
        mov     di, 320
        mov     cl, 198          ; ch=0
next_y: stosb                   ; draw border
        mov     bp, -318
next_x: xor     ax, ax
        xor     bx, bx
        mov bx, fred
        push    di
        mov     di, maxloop
repeatl:
        movsx   esi, bx
        imul    bx, ax
        cwde
        imul    eax
        mov     edx, eax
        imul    esi, esi
        sub     eax, esi
        sar     eax, 7
        sub     ax, bp
        sub     ax, 256
        sar     bx, 6
        sub     bx, cx
        add     bx, 100
        add     edx, esi
        shr     edx, 16
        jnz     plot
        dec     di
        jnz     repeatl
plot:   mov     ax, di
        add     al, 16
        pop     di

        stosb
        inc     bp
        jnz     next_x

        stosb                   ; draw border
        loop    next_y

        inc     fred
        in      al, 060h
        cmp     al, 1
        jne     @@run


xor     ax,  ax
int     16h
mov     ax,  3
int     10h
ret
fred dw 0
codestuff       ends
end     main
