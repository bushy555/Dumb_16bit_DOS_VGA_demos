;
; *** Listing 11.1 ***
;
; Program to demonstrate use of the DAC registers by selecting a
; smoothly contiguous set of 256 colors, then filling the screen
; with concentric diamonds in all 256 colors so that they blend
; into one another to form a continuum of color.
;
; Compiled with TASM 4.0, linked with TLINK 6.10
; Checked by Jim Mischel 11/21/94
;
        .model small
	.stack	200h
	.data

; Table used to set all 256 DAC entries.
;
; Table format:
;	Byte 0: DAC register 0 red value
;	Byte 1: DAC register 0 green value
;	Byte 2: DAC register 0 blue value
;	Byte 3: DAC register 1 red value
;	Byte 4: DAC register 1 green value
;	Byte 5: DAC register 1 blue value
;			:
;	Byte 765: DAC register 255 red value
;	Byte 766: DAC register 255 green value
;	Byte 767: DAC register 255 blue value

SC_INDEX        equ     3c4h    ;SC index register
MAP_MASK        equ     2       ;SC map mask register
GC_INDEX        equ     3ceh    ;GC index register
GC_MODE         equ     5       ;GC mode register
CRTC_INDEX      equ     03d4h   ;CRTC index register
START_ADDRESS_HIGH equ  0ch     ;CRTC start address high byte
START_ADDRESS_LOW equ   0dh     ;CRTC start address low byte
CRTC_OFFSET     equ     13h     ;CRTC offset register
INPUT_STATUS_1  equ     03dah   ;VGA status register
VSYNC_MASK      equ     08h     ;vertical sync bit in status register 1
DE_MASK         equ     01h     ;display enable bit in status register 1
AC_INDEX        equ     03c0h   ;AC index register
CYCLE_SIZE      equ 256
SCREEN_SEGMENT  equ     0a000h  ;mode 13h display memory segment
SCREEN_WIDTH_IN_BYTES equ 320 	;# of bytes across the screen in mode 13h
INPUT_STATUS_1 	equ 	03dah 	;input status 1 register port
DAC_READ_INDEX 	equ 	03c7h  	;DAC Read Index register
DAC_WRITE_INDEX 	equ 	03c8h 	;DAC Write Index register
DAC_DATA        equ     03c9h   ;DAC Data register

COLOR_VAL       equ 1


ColorTable      label   byte
; The first 64 entries are increasingly dim pure green.
X=0
        REPT    64
                db      4 dup(0,X,X)
X=X+1
        ENDM

Palrotate  db 0

ColorDirTable   label byte
        db      256 dup (0)     ; all entries are initiall decrememting

        .code
Start:
	mov	ax,0013h	;AH=0 selects set mode function,
				; AL=13h selects 320x200 256-color
	int	10h		; mode

       mov     dx,offset ColorTable
                               ;point ES:DX to the start of the
                               ; block of RGB three-byte values
                               ; to load into the DAC registers


                                ;now fill the screen with
				; concentric diamonds in all 256
				; color attributes
	mov	ax,0a000h	;point DS to the display memory
	mov	ds,ax		; segment
				;
				;draw diagonal lines in the upper
				; left quarter of the screen
	mov	al,2		;start with color attribute #2
	mov	ah,-1		;cycle down through the colors
	mov	bx,320		;draw top to bottom (distance from
				; one line to the next)
	mov	dx,160		;width of rectangle
	mov	si,100		;height of rectangle
	sub	di,di		;start at (0,0)
	mov	bp,1		;draw left to right (distance from
				; one column to the next)
	call	FillBlock	;draw it
				;
				;draw diagonal lines in the upper
				; right quarter of the screen
	mov	al,2		;start with color attribute #2
	mov	ah,-1		;cycle down through the colors
	mov	bx,320		;draw top to bottom (distance from
				; one line to the next)
	mov	dx,160		;width of rectangle
	mov	si,100		;height of rectangle
	mov	di,319		;start at (319,0)
	mov	bp,-1		;draw right to left (distance from
				; one column to the next)
	call	FillBlock	;draw it

				;draw diagonal lines in the lower
				; left quarter of the screen
	mov	al,2		;start with color attribute #2
	mov	ah,-1		;cycle down through the colors
	mov	bx,-320		;draw bottom to top (distance from
				; one line to the next)
	mov	dx,160		;width of rectangle
	mov	si,100		;height of rectangle
	mov	di,199*320	;start at (0,199)
	mov	bp,1		;draw left to right (distance from
				; one column to the next)
	call	FillBlock	;draw it
				;
				;draw diagonal lines in the lower
				; right quarter of the screen
	mov	al,2		;start with color attribute #2
	mov	ah,-1		;cycle down through the colors
	mov	bx,-320		;draw bottom to top (distance from
				; one line to the next)
	mov	dx,160		;width of rectangle
	mov	si,100		;height of rectangle
	mov	di,199*320+319	;start at (319,199)
	mov	bp,-1		;draw right to left (distance from
				; one column to the next)
	call	FillBlock	;draw it

SetDacLoop:
        call WaitVSync
        call SetDac
	call CyclePal
        mov ah,1
        int 16h
        jnz Done
        jmp SetDacLoop

; Fills the specified rectangular area of the screen with diagonal
; lines.
;
; Input:
;	AL = initial attribute with which to draw
;	AH = amount by which to advance the attribute from
;		one pixel to the next
;	BX = distance to advance from one pixel to the next
;	DX = width of rectangle to fill
;	SI = height of rectangle to fill
;	DS:DN = screen address of first pixel to draw
;	BP = offset from the start of one column to the start of
;		the next



FillBlock:
FillHorzLoop:
	push	di		;preserve pointer to top of column
	push	ax		;preserve initial attribute
	mov	cx,si		;column height
FillVertLoop:
	mov	[di],al		;set the pixel
	add	di,bx		;point to the next row in the column
	add	al,ah		;advance the attribute
	loop	FillVertLoop	;
	pop	ax		;restore initial attribute
	add	al,ah		;advance to the next attribute to
				; start the next column
	pop	di		;retrieve pointer to top of column
	add	di,bp		;point to next column
	dec	dx		;have we done all columns?
        jnz     FillHorzLoop    ;no, do the next column
	ret			;

Done    proc near
        mov     ah,0    ;clear key
        int     16h

        mov     ax,3    ;reset to text mode
        int     10h

        mov     ah,4ch  ;exit to DOS
        int     21h


Done    endp

SetDac proc near
        push cx
        push si
        push ax
        push dx
        push ds
        mov cx,@data
        mov ds,cx

        mov     cx,CYCLE_SIZE   ;# of DAC locations to load
        mov     si,offset ColorTable ;load the DAC from this array
	sub	ah,ah		;start with DAC location 0
DACLoadLoop:
	mov	dx,DAC_WRITE_INDEX
	mov	al,ah
	cli
	out	dx,al		;set the DAC location #
	mov	dx,DAC_DATA
	lodsb
	out	dx,al		;set the red component
	lodsb
	out	dx,al		;set the green component
	lodsb
	out	dx,al		;set the blue component
	sti
	inc	ah
        loop    DACLoadLoop
        pop ds
        pop dx
        pop ax
        pop si
        pop cx
        ret
SetDac endp

; Cycle the palete by 1

CyclePal proc near
        push cx
        push ds
        push bp
        push ax

        mov cx,@data
        mov ds,cx
        mov cx,256
        mov bx,0

incloop:                        ; Outer loop
        mov bp, cx
        mov ax, 256
        sub ax, bp
        mov bp,ax

        cmp byte ptr [ColorTable + bx + COLOR_VAL], 63
        je StartDec
        jmp ContDirTest
StartDec:
        push bx
        mov bx,bp
        dec byte ptr ColorDirTable + bx
        pop bx
ContDirTest:
        cmp byte ptr [ColorTable + bx + COLOR_VAL], 0
        je StartInc
        jmp DirTableTest
StartInc:
        push bx
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
DecCol:
        dec byte ptr [ColorTable + bx + COLOR_VAL]
ContIncLoop:
        add bx, 3
        loop incloop

        pop ax
        pop bp
        pop ds
        pop cx
        ret
CyclePal endp


;
; Wait for the leading edge of vertical sync pulse.
;

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

        end start

