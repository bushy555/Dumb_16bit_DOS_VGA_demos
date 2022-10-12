code    SEGMENT PARA PUBLIC 'code'
        ASSUME cs:code, ds:code, es:code, ss:code
        org     100h
.386



start      proc near

           mov ax, 13h
           int 10h

           mov di, 0a000h
           mov es, di

           mov si, offset dac2
           call savedac

bax:
        in      al,  060h
        cmp     al,  1
	je	exit
           call updbadd
           mov cx, xvar[0]
           mov ax, yvar[0]
           call block
           mov cx, xvar[2]
           mov ax, yvar[2]
           call block
           mov cx, xvar[4]
           mov ax, yvar[4]
           call block
	jmp	short bax

exit:
        mov     ax, 3
	int	10h
        mov     ax, 4c00h
        int     21h
start      endp


savedac    proc      near
           mov       dx, 3c8h
           mov       al, 0
           out       dx, al
           sti
           push      ax
check:     mov       dx, 3dah
           in        al, dx
           test      al, 8
           jz        check
           mov       cx, 256
           pop       ax
step:      push      ax
           mov       dx, 3dah
instep:    in        al, dx
           test      al, 1
           jz        instep
           mov       dx, 03c9h
           pop       ax
           lodsb
           out       dx, al
           lodsb
           out       dx, al
           lodsb
           out       dx, al
           loop      step
           cli
           ret
savedac    endp



block      proc near   ; cx, ax = x, y...

;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
        mov     di, ax
        lea     edi, [edi+edi*4]
        shl     edi, 6
        add     di, cx

;          mov bx, 320
 ;         mul bx
  ;        add ax, cx
   ;       mov di, ax



           mov cx, 30
badd2:
           push cx
           mov cx, 30
badd:
           inc byte ptr es:[di]
           inc di
           loop badd
           pop cx
           add di, 290
           loop badd2
           ret
block      endp

updbadd    proc near
           xor di, di
bagain:
           mov ax, dirleft[di]
           add xvar[di], ax
           cmp xvar[di], 0
           jne not1
           mov dirleft[di], 1
not1:
           cmp xvar[di], 290
           jne not2
           mov dirleft[di], -1
not2:
           mov ax, dirup[di]
           add yvar[di], ax
           cmp yvar[di], 0
           jne not3
           mov dirup[di], 1
not3:
           cmp yvar[di], 170
           jne not4
           mov dirup[di], -1
not4:
           add di, 2
           cmp di, 6
           jne bagain
           ret
updbadd    endp


dac2       label byte
           i = 0
           REPT 64
           db 0, i, i
           i = i + 1
           ENDM
           i = 63
           REPT 64
           db 63-i, 63, i
           i = i - 1
           ENDM
           i = 0
           REPT 64
           db 63, 63-i, i
           i = i + 1
           ENDM
           i = 63
           REPT 64
           db i, i, i
           i = i - 1
           ENDM



xvar       dw 0, 100, 200
yvar       dw 100, 0, 100
dirup      dw 1, 1, 1
dirleft    dw 1, 1, 1

code      ends
           end start



