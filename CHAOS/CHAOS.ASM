;CHAOS.COM. 68 Bytes.
comseg segment
assume cs:comseg,ds:comseg
org 100h
.386
start:  push    0A000h
        pop     es
        mov     al, 013h
        int     10h
@main:;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".     lea     eax, [eax + eax * 2]     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        imul    ax, 3
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        cmp     ax, -10923
        jl      @Calc
        cmp     ax, 10923
        jg      @Next
        add     bp, 320
	jmp     short @calc
@Next:  add     bp, 160
        add     bx, 200
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Calculate the two formula's for the next pixel...
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
@Calc:  shr     bp, 1
        shr     bx, 1
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; PUTPIXEL routine. (x,y) -> (cx, bx)
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        push    ax
        imul    di, bx, 320
        add     di, bp
        mov     al, 9
        stosb
        sub     di, 4
        mov     al, 4
        stosb
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        in      al, 060h
        cmp     al, 01
        pop     ax
        jne     @main
@quit:  mov     ax, 0003h
        int     10h
	retn
comseg ends
end start
