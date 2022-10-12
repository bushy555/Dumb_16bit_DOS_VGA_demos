
; slow aint it...  6th March, 1997.

number_1   equ  32000
maxx    equ     81;240;300;320
maxy    equ     50;120;180;200
minx    equ     1
miny    equ     1
halfx   equ     40
INPUT_STATUS_1  equ     03dah   ;VGA status register
VSYNC_MASK      equ     08h     ;vertical sync bit in status register 1
CYCLE_SIZE      equ     256
DAC_WRITE_INDEX equ     03c8h   ;DAC Write Index register
DAC_DATA        equ     03c9h   ;DAC Data register
COLOR_VAL       equ     1


comseg segment
assume cs:comseg,ds:comseg
org 100h
.386
start:
	call WaitVSync
	call SetDac
	call CyclePal
	
	push    02000h
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
@main:
@main1:
	mov     cx, e
	mov     dx, f

	cmp     cx, minx    ;(0,dec Y)
	jg      @a
	cmp     dx, miny
	jl      @a
	dec     dx
	inc     cx
@a:
	cmp     dx, miny    ;(inc X, 0)
	jg      @b
	cmp     cx, maxx
	jg      @b
	inc     cx
	inc     cx
@b:
	cmp     cx, maxx  ;(319, dec Y)
	jl      @c
	cmp     dx, maxy
	jg      @c
	inc     cx
	inc     dx
@c:     dec     cx
	mov     e, cx
	mov     f, dx
@d:
	mov     cx, a
	mov     dx, b
	cmp     cx, maxx  ;(319, inc Y)
	jl      @e
	cmp     dx, maxy
	jg      @e
	dec     cx
	inc     dx
@e:
	cmp     dx, maxy  ;(dec X, 199)
	jl      @f
	cmp     cx, minx
	jl      @f
	dec     cx
	dec     cx
@f:
	cmp     cx, minx    ;(0, dec Y)
	jg      @g
	cmp     dx, miny
	jl      @g
	dec     cx
	dec     dx
@g:     inc     cx
	mov     a, cx
	mov     b, dx
@h:     
	mov     cx, c
	mov     dx, d

	cmp     dx, maxy  ;(dec X, 199)
	jl      @i
	cmp     cx, minx
	jl      @i
	dec     cx
	dec     dx
@i:
	cmp     cx, minx    ;(0, dec Y)
	jg      @j
	cmp     dx, miny
	jl      @j
	dec     dx
	dec     dx
@j:
	cmp     dx, miny    ;(inc X, 0)
	jg      @k
	cmp     cx, maxx
	jg      @k
	dec     dx
	inc     cx
@k:
	inc     dx
	mov     c, cx
	mov     d, dx
		

@waydownhere:
	cmp     flag1, 1
	je      @@down
	inc     colour
	inc     colour
	cmp     colour, 254
	jg      @@cont
	mov     flag1, 1
	jmp     @@cont
@@down: dec     colour
	dec     colour
	cmp     colour, 50
	jg      @@cont
	mov     flag1, 0
@@cont: push    ax

	mov     ax, 0a000h
	mov     es, ax
	mov     ax, 02000h
	mov     ds, ax
	mov     cx, 16000
	xor     si, si
	xor     di, di
	rep     movsd

;        mov     ax, 02000h
;        mov     es, ax
;        xor     di, di
;        xor     eax, eax
;        mov     cx, 16000
;        rep     stosd



;       clear 
     ;   mov     ax, 02000h
    ;    mov     es, ax
   ;     xor     di, di
  ;      xor     eax, eax
 ;       mov     cx, 16000
;        rep     stosd

	xor     si, si

	mov     ax, cs
	mov     ds, ax

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	call WaitVSync
	call SetDac
	
	in      al, 060h
	cmp     al, 01
	pop     ax
	je      @quit;main2

@main2:

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	lea     eax, [eax + eax * 2]
;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	add     bp, a
	add     bx, b
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	add     bp, c
	add     bx, d
	jmp     short @calc
@3:
	add     bp, e
	add     bx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:  
	shr     bp, 1
	shr     bx, 1                           
;------------------------------------
;PUTPIXEL routine. (x,y) -> (cx, bx)
;------------------------------------
	push    ax                      ;ax = random number (global), so PUSH.

	mov     ax, 02000h
	mov     es, ax
	lea     edi, [ebx+ebx*4]
	shl     edi, 6
	push    di
	add     di, bp
	mov     al, colour;09                  ;  CYAN = 3.   BLUE = 9.
	stosb   
	add     di, 159         ;x1
	stosb
	add     di, 15759       ;x2
	stosb
	add     di, 159         ;x3
	stosb
	add     di, 15439       ;x4
	stosb
	add     di, 158         ;x5
	stosb
	add     di, 15599       ;x6
	stosb
	add     di, 159         ;x7
	stosb

	pop     di
	mov     dx, 321
	sub     dx, bp
	add     di, dx
	mov     al, colour;9                   ;  RED 
	stosb
	sub     di, 161         ;y1
	stosb
	add     di, 15599       ;y2        
	stosb
	add     di, 159         ;y3
	stosb
	add     di, 15599       ;y4 
	stosb
	add     di, 159         ;y5
	stosb
	add     di, 15599       ;y6
	stosb
	add     di, 159         ;y7
	stosb



	pop     ax
	inc     si
	cmp     si, number_1
	jl      @main2
	jmp     @main
@quit:
	mov    ax, 0003h
	int    10h
	retn

even
	a       dw minx;0
	b       dw miny;0
	c       dw maxx;319
	d       dw miny;0
	e       dw halfx;160
	f       dw maxy;199
	count   dw 0
	colour  db 50
	flag1   db 0
ColorTable      label   byte
X=0
	REPT    64
	db      0,0,x, 0,0,x,0,0,x,0,0,x
X=X+1
	ENDM
Palrotate  db 0
ColorDirTable   label byte
	db      256 dup (0)     ; all entries are initiall decrememting


SetDac proc near
	push cx
	push si
	push ax
	push dx
	push ds
	mov     cx,CYCLE_SIZE   ;# of DAC locations to load
	mov     si,offset ColorTable ;load the DAC from this array
	sub     ah,ah           ;start with DAC location 0
DACLoadLoop:
	mov     dx,DAC_WRITE_INDEX
	mov     al,ah
	cli
	out     dx,al           ;set the DAC location #
	mov     dx,DAC_DATA
	lodsb
	out     dx,al           ;set the red component
	lodsb
	out     dx,al           ;set the green component
	lodsb
	out     dx,al           ;set the blue component
	sti
	inc     ah
	loop    DACLoadLoop
	pop ds
	pop dx
	pop ax
	pop si
	pop cx
	ret
SetDac endp
CyclePal proc near
	push cx
	push ds
	push bp
	push ax
	mov cx,256
	mov bx,0
incloop:mov bp, cx
	mov ax, 256
	sub ax, bp
	mov bp,ax
	cmp byte ptr [ColorTable + bx + COLOR_VAL], 63
	je StartDec
	jmp ContDirTest
StartDec:push bx
	mov bx,bp
	dec byte ptr ColorDirTable + bx
	pop bx
ContDirTest:cmp byte ptr [ColorTable + bx + COLOR_VAL], 0
	je StartInc
	jmp DirTableTest
StartInc:push bx
	mov bx,bp
	inc byte ptr ColorDirTable + bx
	pop bx
DirTableTest:
	push bx
	mov bx,bp
	cmp byte ptr ColorDirTable + bx, 0
	pop bx
	je DecCol
	inc byte ptr [ColorTable + bx + COLOR_VAL]
	jmp ContIncLoop
DecCol: dec byte ptr [ColorTable + bx + COLOR_VAL]
ContIncLoop:add bx, 3
	loop incloop
	pop ax
	pop bp
	pop ds
	pop cx
	ret
CyclePal endp
WaitVSync       proc    near
	push    dx
	push    ax
	mov     dx,INPUT_STATUS_1
WaitNotVSyncLoop:
	in      al,dx
	and     al,VSYNC_MASK
	jnz     WaitNotVSyncLoop
WaitVSyncLoop:
	in      al,dx
	and     al,VSYNC_MASK
	jz      WaitVSyncLoop
	pop ax
	pop dx
	ret
WaitVSync       endp


comseg ends
end start

