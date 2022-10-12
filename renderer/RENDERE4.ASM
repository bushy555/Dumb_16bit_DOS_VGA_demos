;uses Mr Thingies line drawin algorithm.

Displays a nice lisajous effect when drawing....

though stuffs up after a while. Looks like a push/pop junk not working. fix!


SCREEN_WIDTH    equ 320
SCREEN_SEGMENT	equ 0a000h
number_1 	equ	1
num_width	equ	319
num_height	equ	199
distance 	equ    6
LOCAL_SIZE 	equ	8;equ  8
XAdvance 	equ	-8;equ -8      		;1 or -1, for direction in which X advances
WholeStep 	equ	-6;	equ -6      		;minimum run length
AdjDown 	equ	-4;	equ -4  			;error term adjust down when error term turns over

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
start: 
@0100:  push    0A000h
@0101:  pop     es
@0105:  mov     ax, 0013h
@0107:  INT     10h
@0109:  MOV     DX, 03C8h
@010C:  MOV     AL, 00
@010E:  OUT     DX, AL
@010F:  INC     DX
@0110:  MOV     CX, 00Ffh
@0113:  SUB     AL, AL
@0115:  OUT     DX, AL
@0116:  OUT     DX, AL
@0117:  MOV     AL, CL
@0119:  shr     al, 02
@011A:  out     dx, al
@011D:  LOOP    @0113
	
	
@main:
	inc     count
	cmp     count, number_1
	jl      @main2  ;g      @main1
@main1:
	cmp     e, 0    ;(0,dec Y)
	jg      @a
	cmp     f, 1
	jl      @a
	dec     f
	inc     e
@a:
	cmp     f, 0    ;(inc X, 0)
	jg      @b
	cmp     e, 318
	jg      @b
	inc     e
	inc     e
@b:
	cmp     e, 319  ;(319, dec Y)
	jl      @c
	cmp     f, 198
	jg      @c
	inc     e
	inc     f
@c:
@d:
	cmp     a, 319  ;(319, inc Y)
	jl      @e
	cmp     b, 198
	jg      @e
	dec     a
	inc     b
@e:
	cmp     b, 199  ;(dec X, 199)
	jl      @f
	cmp     a, 1
	jl      @f
	dec     a
	dec     a
@f:
	cmp     a, 0    ;(0, dec Y)
	jg      @g
	cmp     b, 1
	jl      @g
	dec     a
	dec     b
@g:
@h:     
	cmp     d, 199  ;(dec X, 199)
	jl      @i
	cmp     c, 0
	jl      @i
	dec     c
	dec     d
@i:
	cmp     c, 0    ;(0, dec Y)
	jg      @j
	cmp     d, 0
	jl      @j
	dec     d
	dec     d
@j:
	cmp     d, 0    ;(inc X, 0)
	jg      @k
	cmp     c, 319
	jg      @k
	dec     d
	inc     c
@k:
	inc     a
	inc     d
	dec     e
	mov     count, 0
		
	cmp     flag1, 0
	je      @here1
	cmp     flag1, 1
	je      @here2
@here1: cmp     color, 254
	jne     @here12
	mov     flag1, 1
	jmp     short   @main2
@here12:inc     color               
	jmp     short   @main2
@here2: cmp     color, 1       
	jne     @here22
	mov     flag1, 0
	jmp     short   @main2
@here22:dec     color

@main2:
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; RANDOM NUM.  ax = -32768 to +32768.    
; random number = "AX".                                     "GET A DOG UP YA"
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

	lea     eax, [eax + eax * 2]
	add     ax, si

;----------------------------------------------------------------
; Determines which point (0,0), (320, 0) or (320, 200) to go to.
;----------------------------------------------------------------
	cmp     ax, -10923
	jg      @2
	mov     cx, a
	mov     dx, b
	add     si, 3                   ; Add a bit for the random value.
	jmp     short @calc
@2:
	cmp     ax, 10923
	jg      @3
	mov     cx, c
	mov     dx, d
	jmp     short @calc
@3:
	mov     cx, e
	mov     dx, f
;---------------------------------------------------
;Calculate the two formula's for the next pixel... 
;---------------------------------------------------
@calc:  add     bp, cx                   ; S := ((S + X[R]) DIV 2);
	shr     bp, 1

	add     bx, dx                   ; T := ((T + Y[R]) DIV 2);     
	shr     bx, 1                           
;------------------------------------
;PUTPIXEL routine. (x,y) -> (bp, bx)
;------------------------------------
;	push    ax                      ;ax = random number (global), so PUSH.
pusha

mov	xstart, cx
mov	ystart, dx
mov	ax, c
mov	xend, ax
mov	ax, d
mov	yend, ax

push	cs
pop	ds
    cld
   push    bp  				;preserve caller's stack frame
   mov bp,sp   				;point to our stack frame
;    sub sp,LOCAL_SIZE   			;allocate space for local variables
;    push    si  				;preserve C register variables
;   push    di
;    push    ds  				;preserve caller's DS
; We'll draw top to bottom, to reduce the number of cases we have to handle,
; and to make lines between the same endpoints always draw the same pixels.
    mov ax,YStart
    cmp ax,YEnd
    jle LineIsTopToBottom
    xchg    YEnd,ax                        ;swap endpoints
    mov YStart,ax
    mov bx,XStart
    xchg    XEnd,bx
    mov XStart,bx
LineIsTopToBottom:
; Point DI to the first pixel to draw.
    mov dx,SCREEN_WIDTH
    mul dx              			;YStart * SCREEN_WIDTH
    mov si,cs:XStart
    mov di,si
    add di,ax           			;DI = YStart * SCREEN_WIDTH + XStart
                				; = offset of initial pixel
; Figure out how far we're going vertically (guaranteed to be positive).
    mov cx,YEnd
    sub cx,YStart                          ;CX = YDelta
; Figure out whether we're going left or right, and how far we're going
; horizontally. In the process, special-case vertical lines, for speed and
; to avoid nasty boundary conditions and division by 0.
    mov dx,XEnd
    sub dx,si       			;XDelta
    jnz NotVerticalLine 			;XDelta == 0 means vertical line
                				;it is a vertical line
                				;yes, special case vertical line
    mov ax,SCREEN_SEGMENT
    mov ds,ax           			;point DS:DI to the first byte to draw
    mov al,cs:Color
VLoop:
    mov [di],al
    add di,SCREEN_WIDTH
    dec cx
    jns VLoop
    jmp Done
	
; Special-case code for horizontal lines.
    align   2
IsHorizontalLine:
    mov ax,SCREEN_SEGMENT
    mov es,ax           			;point ES:DI to the first byte to draw
    mov al,cs:Color
    mov ah,al       			;duplicate in high byte for word access
    and bx,bx   				;left to right?
    jns DirSet  				;yes
    sub di,dx   				;currently right to left, point to left end so we
            				; can go left to right (avoids unpleasantness with
            				; right to left REP STOSW)
DirSet:
        mov     cx,dx
        inc     cx      			;# of pixels to draw
    shr cx,1    				;# of words to draw
    rep stosw   				;do as many words as possible
    adc cx,cx
    rep stosb   				;do the odd byte, if there is one
    jmp Done
; Special-case code for diagonal lines.
    align   2
IsDiagonalLine:
    mov ax,SCREEN_SEGMENT
    mov ds,ax           			;point DS:DI to the first byte to draw
    mov al,cs:Color
    add bx,SCREEN_WIDTH 			;advance distance from one pixel to next
DLoop:
    mov [di],al
    add di,bx
    dec cx
    jns DLoop
    jmp Done

    align   2
NotVerticalLine:
    mov bx,1        			;assume left to right, so XAdvance = 1
                				;***leaves flags unchanged***
    jns LeftToRight 			;left to right, all set
    neg bx      				;right to left, so XAdvance = -1
    neg dx      				;|XDelta|
LeftToRight:
; Special-case horizontal lines.
    and cx,cx   				;YDelta == 0?
    jz  IsHorizontalLine ;yes
; Special-case diagonal lines.
    cmp cx,dx   ;YDelta == XDelta?
    jz  IsDiagonalLine 	;yes
; Determine whether the line is X or Y major, and handle accordingly.
        cmp     dx,cx
        jae     XMajor
        jmp     YMajor
; X-major (more horizontal than vertical) line.
        align   2
XMajor:
    mov ax,SCREEN_SEGMENT
    mov es,ax           			;point ES:DI to the first byte to draw
        and     bx,bx    		;left to right?
        jns     DFSet    		;yes, CLD is already set
        std              		;right to left, so draw backwards
DFSet:
        mov     ax,dx    		;XDelta
        sub     dx,dx    		;prepare for division
        div     cx              		;AX = XDelta/YDelta
                                		; (minimum # of pixels in a run in this line)
                                		;DX = XDelta % YDelta
        mov     bx,dx           		;error term adjust each time Y steps by 1;
        add     bx,bx           		; used to tell when one extra pixel should be
        mov     cs:AdjUp,bx                   ; drawn as part of a run, to account for
                                		; fractional steps along the X axis per
                                		; 1-pixel steps along Y
        mov     si,cx           		;error term adjust when the error term turns
        add     si,si           		; over, used to factor out the X step made at
        mov     cs:AdjDown,si                 ; that time
; Initial error term; reflects an initial step of 0.5 along the Y axis.
        sub     dx,si           		;(XDelta % YDelta) - (YDelta * 2)
                                		;DX = initial error term
; The initial and last runs are partial, because Y advances only 0.5 for
; these runs, rather than 1. Divide one full run, plus the initial pixel,
; between the initial and last runs.
        mov     si,cx           		;SI = YDelta
        mov     cx,ax           		;whole step (minimum run length)
        shr     cx,1
        inc     cx              		;initial pixel count = (whole step / 2) + 1;
                                		; (may be adjusted later). This is also the
                				; final run pixel count
        push    cx              		;remember final run pixel count for later
; If the basic run length is even and there's no fractional advance, we have
; one pixel that could go to either the initial or last partial run, which
; we'll arbitrarily allocate to the last run.
; If there is an odd number of pixels per run, we have one pixel that can't
; be allocated to either the initial or last partial run, so we'll add 0.5 to
; the error term so this pixel will be handled by the normal full-run loop.
        add     dx,si           		;assume odd length, add YDelta to error term
                				; (add 0.5 of a pixel to the error term)
        test    al,1            		;is run length even?
        jnz     XMajorAdjustDone 		;no, already did work for odd case, all set
        sub     dx,si           		;length is even, undo odd stuff we just did
        and     bx,bx           		;is the adjust up equal to 0?
        jnz     XMajorAdjustDone 		;no (don't need to check for odd length,
                 			; because of the above test)
        dec     cx              		;both conditions met; make initial run 1
                                		; shorter
XMajorAdjustDone:
        mov     cs:WholeStep,ax       ;whole step (minimum run length)
        mov     al,cs:Color                   ;AL = drawing color
; Draw the first, partial run of pixels.
        rep     stosb           		;draw the final run
        add     di,SCREEN_WIDTH 		;advance along the minor axis (Y)
; Draw all full runs.
        cmp     si,1            		;are there more than 2 scans, so there are
                				; some full runs? (SI = # scans - 1)
        jna     XMajorDrawLast  		;no, no full runs
        dec     dx              		;adjust error term by -1 so we can use
                                		; carry test
        shr     si,1            		;convert from scan to scan-pair count
        jnc     XMajorFullRunsOddEntry  	;if there is an odd number of scans,
                                        	; do the odd scan now
XMajorFullRunsLoop:
        mov     cx,cs:WholeStep       ;run is at least this long
        add     dx,bx           		;advance the error term and add an extra
        jnc     XMajorNoExtra   		; pixel if the error term so indicates
        inc     cx              		;one extra pixel in run
        sub     dx,cs:AdjDown                 ;reset the error term
XMajorNoExtra:
    rep     stosb           		;draw this scan line's run
        add     di,SCREEN_WIDTH 		;advance along the minor axis (Y)
XMajorFullRunsOddEntry:         		;enter loop here if there is an odd number
                                		; of full runs
        mov     cx,cs:WholeStep       ;run is at least this long
        add     dx,bx           		;advance the error term and add an extra
        jnc     XMajorNoExtra2  		; pixel if the error term so indicates
        inc     cx              		;one extra pixel in run
        sub     dx,cs:AdjDown                 ;reset the error term
XMajorNoExtra2:
    rep     stosb           		;draw this scan line's run
        add     di,SCREEN_WIDTH 		;advance along the minor axis (Y)

        dec     si
        jnz     XMajorFullRunsLoop
; Draw the final run of pixels.
XMajorDrawLast:
        pop     cx              		;get back the final run pixel length
        rep     stosb           		;draw the final run

        cld                     		;restore normal direction flag
        jmp     Done
; Y-major (more vertical than horizontal) line.
        align   2
YMajor:
        mov     cs:XAdvance,bx                ;remember which way X advances
    mov ax,SCREEN_SEGMENT
    mov ds,ax           			;point DS:DI to the first byte to draw
        mov     ax,cx           		;YDelta
        mov     cx,dx           		;XDelta
        sub     dx,dx           		;prepare for division
        div     cx              		;AX = YDelta/XDelta
                                		; (minimum # of pixels in a run in this line)
                                		;DX = YDelta % XDelta
        mov     bx,dx           		;error term adjust each time X steps by 1;
        add     bx,bx           		; used to tell when one extra pixel should be
        mov     cs:AdjUp,bx                   ; drawn as part of a run, to account for
                                		; fractional steps along the Y axis per
                                		; 1-pixel steps along X
        mov     si,cx           		;error term adjust when the error term turns
        add     si,si           		; over, used to factor out the Y step made at
        mov     cs:AdjDown,si                 ; that time

; Initial error term; reflects an initial step of 0.5 along the X axis.
        sub     dx,si           		;(YDelta % XDelta) - (XDelta * 2)
                                		;DX = initial error term
; The initial and last runs are partial, because X advances only 0.5 for
; these runs, rather than 1. Divide one full run, plus the initial pixel,
; between the initial and last runs.
        mov     si,cx           		;SI = XDelta
        mov     cx,ax           		;whole step (minimum run length)
        shr     cx,1
        inc     cx              		;initial pixel count = (whole step / 2) + 1;
                                		; (may be adjusted later)
        push    cx              		;remember final run pixel count for later

; If the basic run length is even and there's no fractional advance, we have
; one pixel that could go to either the initial or last partial run, which
; we'll arbitrarily allocate to the last run.
; If there is an odd number of pixels per run, we have one pixel that can't
; be allocated to either the initial or last partial run, so we'll add 0.5 to
; the error term so this pixel will be handled by the normal full-run loop.
        add     dx,si           		;assume odd length, add XDelta to error term
        test    al,1            		;is run length even?
        jnz     YMajorAdjustDone 		;no, already did work for odd case, all set
        sub     dx,si           		;length is even, undo odd stuff we just did
        and     bx,bx           		;is the adjust up equal to 0?
        jnz     YMajorAdjustDone 		;no (don't need to check for odd length,
                 ; because of the above test)
        dec     cx              		;both conditions met; make initial run 1
                                		; shorter
YMajorAdjustDone:
        mov     cs:WholeStep,ax       ;whole step (minimum run length)
        mov     al,cs:Color           ;AL = drawing color
        mov     bx,cs:XAdvance        ;which way X advances
; Draw the first, partial run of pixels.
YMajorFirstLoop:
        mov     [di],al         		;draw the pixel
        add     di,SCREEN_WIDTH 		;advance along the major axis (Y)
        dec     cx
        jnz     YMajorFirstLoop
        add     di,bx           		;advance along the minor axis (X)
; Draw all full runs.
        cmp     si,1            		;# of full runs. Are there more than 2
                				; columns, so there are some full runs?
                				; (SI = # columns - 1)
        jna     YMajorDrawLast  		;no, no full runs
        dec     dx              		;adjust error term by -1 so we can use
                                		; carry test
        shr     si,1            		;convert from column to column-pair count
        jnc     YMajorFullRunsOddEntry  	;if there is an odd number of
                                        	; columns, do the odd column now
YMajorFullRunsLoop:
        mov     cx,cs:WholeStep       ;run is at least this long
        add     dx,cs:AdjUp                   ;advance the error term and add an extra
        jnc     YMajorNoExtra   		; pixel if the error term so indicates
        inc     cx              		;one extra pixel in run
        sub     dx,cs:AdjDown                 ;reset the error term
YMajorNoExtra:
                                		;draw the run
YMajorRunLoop:
        mov     [di],al         		;draw the pixel
        add     di,SCREEN_WIDTH 		;advance along the major axis (Y)
        dec     cx
        jnz     YMajorRunLoop
        add     di,bx           		;advance along the minor axis (X)
YMajorFullRunsOddEntry:         		;enter loop here if there is an odd number
                                		; of full runs
        mov     cx,cs:WholeStep       ;run is at least this long
        add     dx,cs:AdjUp                   ;advance the error term and add an extra
        jnc     YMajorNoExtra2  		; pixel if the error term so indicates
        inc     cx              		;one extra pixel in run
        sub     dx,cs:AdjDown                 ;reset the error term
YMajorNoExtra2:
                                		;draw the run
YMajorRunLoop2:
        mov     [di],al         		;draw the pixel
        add     di,SCREEN_WIDTH 		;advance along the major axis (Y)
        dec     cx
        jnz     YMajorRunLoop2
        add     di,bx           		;advance along the minor axis (X)

        dec     si
        jnz     YMajorFullRunsLoop
; Draw the final run of pixels.
YMajorDrawLast:
        pop     cx              		;get back the final run pixel length
YMajorLastLoop:
        mov     [di],al         		;draw the pixel
        add     di,SCREEN_WIDTH 		;advance along the major axis (Y)
        dec     cx
        jnz     YMajorLastLoop
Done:
;    	pop ds  				;restore caller's DS
;    	pop di
;    	pop si  				;restore C register variables
    	mov sp,bp   			;deallocate local variables
   	pop bp  				;restore caller's stack frame
push	cs
pop	ds

;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;READ keyboard for <ESC>
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
	in      al, 060h
	cmp     al, 01
	popa
	je      @quit
	jmp     @main

@quit:
	mov    	ax, 0003h
	int    	10h
	int	20h
	;retn


	a       dw 0
	b       dw 199
	c       dw 160
	d       dw 99
	e       dw 0
	f       dw 199
	count   dw 0

	AdjUp   	dw	-2;	equ -2  			;error term adjust up on each advance

	flag1   db      ?
	XStart  dw  	?				;X start coordinate of line
	YStart  dw  	?				;Y start coordinate of line
	XEnd    dw  	?				;X end coordinate of line
	YEnd    dw  	?				;Y end coordinate of line
	Color   db  	?				;color in which to draw line
		db   	?

   code    ENDS
END     start


