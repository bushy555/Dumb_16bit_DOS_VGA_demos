
com_seg segment
	ASSUME CS:com_seg, ds:com_seg,es:com_seg, ss:com_seg
	.286
	org 100h
int8 proc far

jmp install

;====- DATA -=====
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

run_time:
	push si
	push di
	push cx
	push ax
	push es
	push ds
	push cs
	pop ds

	mov	ax, cs
	mov     [SegCode],ax

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
jmp exit

;========- SubRoutines -========


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

exit:	pop ds
	pop es
	pop ax
	pop cx
	pop di
	pop si
	iret

install:
	mov     al, 1ch
	mov     ah, 35h
	int     21h
	mov     dx, offset run_time
	mov     al, 1ch
	mov     ah, 25h
	int     21h
	mov     dx, offset install
	int     27h        

int8	endp
com_seg ends
end int8


