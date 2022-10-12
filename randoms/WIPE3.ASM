;4:55pm  14/3/97 100 bytes
;10:19pm 15/3/97 70 bytes

wipe3 segment
assume cs:Wipe3,ds:Wipe3
org 100h
.386
start:  mov     ah, 0b8h
        mov     ds, ax
        mov     es, ax

@@_3:   xor     bp, bp
@@_2:   mov     dl, 24
@@_1:   mov     al, dl
        mov     cl, 160
        mul     cl
       
        add     ax, bp
        mov     si, 4000
        push    si
        sub     si, ax
        mov     di, si
        sub     di, 160
        movsw

        dec     dx
        cmp     dl, -1
        pop     di
        jne     @@_1

        sub     di, bp
        xor     ax, ax
        stosw

        inc     bp
        inc     bp
        cmp     bp, bx
        jl      @@_2

        mov     dx, 03dah
@@_W1:  in      al, dx
        and     al, 8
        jz      @@_W1

        inc     bx
        inc     bx
        cmp     bx, 220
        jl      @@_3

@@_quit:mov     al, 3
        int     10h
        ret
        
Wipe3 ends
end start
