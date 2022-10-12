page ,130
ivt     segment at 0h
	org     9h * 4
keybd   dw      2 dup (0)
ivt     ENDS




CODE SEGMENT    PARA PUBLIC
	ASSUME  cs:code, ds:code, es:code, ss:code
.286
org 100h
front   label   near
begin:
	jmp     init
oldkb   label   dword
oldkey  dw      2 dup (0)
pretend dw      2 dup (0)
res     =       ((rear - front) / 16 ) + 11h
    csseg	dw 0
    VgaSeg      dw  0a000h  ;segment for VGA
    SegCode     dw  ?

    Numcolors   dw  280     ;# of colors to rotate
    NumColors3  dw  280*3   ;# of colors*3
    StartAt     db  1       ;color to start rotate at
    PalIndex    dw  0       ;color to start write at- increased every time
			    ;to produce the rotating effect
    PalIndexVel dw  1       ;amount PalIndex Changes for each screen

    Palette     LABEL BYTE
	i=0 
      REPT 63
		db i,i/2,i/3    ;63 increasing colors
	i=i+1
      ENDM

	i=63 
      REPT 63
		db i,i/2,i/3    ;63 decreasing colors
	i=i-1
      ENDM

	i=0 
      REPT 63
		db i/2,i/3,i    ;32 incr colors
	i=i+1
      ENDM

	i=63 
      REPT 63
		db i/2,i/3,i    ;32 decr colors
	i=i-1
      ENDM
		db  28*3 dup (0) ;buffer out to 200 colors total

	

MAIN    PROC    NEAR
	sti
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push ds
	push es
	pushf
	push cs
	pop ds
	call cs:oldkb
	mov ah,1
	int 16h
	jnz here2
	jmp     here2
 here1:       cmp al,0
	je here2
	jmp     exit
 here2:
 
;----------
	mov	ax, csseg
	mov	ax, cs
;    mov     ax,cs
    mov     ds,ax
    mov     es,ax
    mov     [SegCode],ax


;    call    WriteLines
MainLoop:

    mov     dx,3dah
VRT:
    in      al,dx
    test    al,8
    jnz     VRT         ;wait until Verticle Retrace starts

   call    RotatePalette
    
    mov     dx,3dah
NoVRT:
    in      al,dx
    test    al,8
    jz      NoVRT       ;wait until Verticle Retrace ends
			;so that we dont rotate more than once a frame

	JMP     EXIT

WriteLines  PROC NEAR
    pusha
    mov   es,cs:[VgaSeg]

    mov   di,10*320
    mov   al,200-20
WrLiLoop:
    mov   ah,al
    mov   cx,160
    rep   stosw

    dec   al
    jne   WrLiLoop

    popa
    ret
WriteLines  ENDP

RotatePalette PROC NEAR
    pusha

    call  WritePalette

    mov   ds,cs:[SegCode]

    mov   ax,[PalIndexVel]
    add   [PalIndex],ax    ;change the palette index

    mov   ax,[PalIndex]    ;are we over the number of colors?
    mov   bx,[NumColors]

    cmp   ax,bx
    jl    NotTooHigh
    sub   [PalIndex],bx    ;add [Numcolors] to the index
    jmp   NotTooLow
NotTooHigh:
    cmp   ax,0
    jge   NotTooLow
    add   [PalIndex],bx    ;subtract [Numcolors] to the index
NotTooLow:

    popa
    ret
RotatePalette ENDP

WritePalette PROC NEAR        
    mov   ds,cs:[SegCode]
    cld

    mov   dx,[PalIndex]
    mov   bx,dx
    add   bx,bx           ;This just multiplies
    add   bx,dx           ;bx by three ( bx = bx + 2*bx )

    mov   si,offset Palette
    mov   dx,03c8h
    mov   ax,[PalIndex]
    add   al,[StartAt]
    out   dx,al           ;start writing at [PalIndex]+[StartAt]
    inc   dx
    mov   cx,[NumColors3]
    sub   cx,bx           ;get the number of colors to write
    rep outsb

    mov   al,[StartAt]
    dec   dx              ;point to palette index
    out   dx,al           ;out the number we want to start writing at 
    inc   dx
    mov   cx,bx           ;get the number of colors to write
    rep outsb             ;note that SI is already where we want it

    ret
WritePalette ENDP         ;well, that's all there is to it


exit:
	pop es
	pop ds
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	iret
rear    label   near
main    endp

INIT    PROC    NEAR
	mov ax,ivt
	mov ds,ax
	mov	ax, cs
	mov	csseg, ax
Assume ds:ivt
	mov ax,ds:keybd
	mov cs:oldkey,ax
	mov ax,ds:keybd+2
	mov cs:oldkey+2,ax
	cli
	mov keybd, offset MAIN
	mov keybd+2,cs
	sti
	mov dx,res
	mov ah,31h
	int 21h
init    endP
CODE    ENDS
	END     BEGIN

	


