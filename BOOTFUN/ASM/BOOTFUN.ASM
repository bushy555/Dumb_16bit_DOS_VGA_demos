CODE     SEGMENT    PARA
	 ASSUME   CS:CODE, DS:code, es:code, ss:code
org 100h

start:  
	jmp     begin


number3 label   word
	include     sig.dbg
number5 label   word
	include     drive_a.dbg
number1 label   word
	include     boot.dbg
number2 label   word
	include     fire.dbg
number4 label   word
	include     my2.dbg
number7 label   word
	include     walk.dbg
number8 label   word
	include     fill.dbg
number9 label   word
	include     boot_b.dbg
number10 label  word
	include     boot_c.dbg

newboot label   word
header  label   word
	db      03eh    dup (0) ;space for header.  <= 62d bytes.
newprog label   word
	db      01c0h   dup (0) ;new sector program. <= 448d bytes.
	db      055h
	db      0aah


msg0    db      0ah,0dh,0ah,'Bushy''s Boot Fun.', 0ah, 0dh
	db      0ah,0dh,'  1. Original MS-DOS v5.0 boot sector program.'
	db      0ah,0dh,'  2. Fire routine.'
	db      0ah,0dh,'  3. Signature (enter your own message).'
	db      0ah,0dh,'  4. "My Disk".'
	db      0ah,0dh,'  5. "Error reading drive A".'
	db      0ah,0dh,'  6. "Error reading drive C".'
	db      0ah,0dh,'  7. Walk.'
	db      0ah,0dh,'  8. Fill the screen with COLOUR.'
	db      0ah,0dh,'  9. Boot drive B:.'
	db      0ah,0dh,'  0. Boot drive C:.'
SER label word
	db      0ah,0dh,'  :. Change SERIAL number. (DOS 5.0+)'
	db      0ah,0dh,0ah,'  <ESC> Quits.'
	db      0ah,0dh,0ah,'  Selection? > $'
msg1    db      0ah,0dh,0ah, 'Please enter in the drive that you wish to modify (A-D): $'
msg2    db      0ah,0dh, 'Drive $'
msg3    db      ': sure? (Y/N). $'
msg4    db      0ah,0dh,0ah,'Done! The disk is now modified.$'
msg5    db      0dh,'Enter text to be displayed : "$'
msg6    db      '                                 "$'
msg8    db      0ah,0dh,0ah,'Enter new Serial number (8 hex-digits. eg "0000-000F") :  $'
endmsg  db      0ah, 0ah, 0dh, 'Thanks for using Boot Fun.',0dh,0ah,'$'
error0  db      0dh,'                 ',0dh,'  Selection? : $'
error1  db      0ah,0dh,0ah,'Drive out of range.$'
error2  db      0ah,0dh,0ah,'Disk is write-protected. Please fix and re-try.',0dh,0ah,0ah,'$'
error3  db      0ah,0dh,0ah,'No disk in drive. Please fix and re-try.',0dh,0ah,0ah,'$'
char    db      0
serial	db	0

new_ser label word		;buffer for inputted SERIAL# number.
	db      5 dup (0)
	

begin:	mov	serial, 0  
	lea     dx, msg0
	mov     ah, 9
	int     21h
input1: mov     ah, 1
	int     21h
	cmp     al, 01bh
	jne     @0
endin:  lea     dx, endmsg
	mov     ah, 9
	int     21h
	int     20h     
@0:     cmp     al, 030h
	jl      error1_
	cmp     al, 03ah
	jg      error1_
	jmp     @cmp_input
	
error1_:
	lea     dx, error0
	mov     ah,9
	int     21h
	jmp     input1

@cmp_input:
	cmp     al, 031h
	jne     @1
	lea     bx, number1
	jmp     @6
@1:     cmp     al, 032h
	jne     @2
	lea     bx, number2
	jmp     @6
@2:     cmp     al, 033h
	jne     @3
	lea     bx, number3
	mov     cx, 023h
	mov     al, 020h
	mov     di, [0010eh]
	repz    stosb
	lea     dx, msg5
	mov     ah, 9
	int     21h
	lea     dx, msg6
	mov     ah, 9
	int     21h
	lea     dx, msg5
	mov     ah, 9
	int     21h
	push    bx
	mov     dx, [0010ch]
	mov     ah, 0ah
	int     21h
	mov     al, 020h
	mov     bx, cs:[010dh]
	xor     bh, bh
	add     bx, 0010eh
	mov     [bx], al
	pop     bx
	jmp     @6
@3:     cmp     al, 034h
	jne     @4
	lea     bx, number4
	jmp     @6
@4:     cmp     al, 035h
	jne     @5
	lea     bx, number5 ;drive_a
	jmp     @6
@5:     cmp     al, 036h
	jne     @52
	lea     bx, number5 ;drive_c - modified from drive_a
	mov     bp, 001bdh
	mov     al, 043h
	mov     [bp], al        
	mov     bp, 001feh
	mov     al, 002h
	mov     [bp], al        
	jmp     @6

@52:    cmp     al, 037h
	jne     @53
	lea     bx, number7 ;walk
	jmp     @6
@53:    cmp     al, 038h
	jne     @54
	lea     bx, number8 ;fill screen with COLOUR
	jmp     @6
@54:    cmp     al, 039h
	jne     @55
	lea     bx, number9     ;BOOT Drive B:.  The header must be modified.
	jmp     @6
@55:    cmp     al, 030h
	jne     @56
	lea     bx, number10    ;BOOT Drive C:.  A check must be made.
	jmp     @6
@56:    mov	serial, 1	; 031h.
	lea     dx, msg8        ;+-----------------------------------------+
	mov     ah, 9           ;+      Dont try and understand this..     +
	int     21h             ;+             It just works.              +
;	push    bx              ;+-----------------------------------------+
	lea     bx, new_ser + 4
@560:   mov     ah, 8
	int     21h
	mov     char, al
	call    check
	push    ax
	mov     al, char
	mov     ah, 0eh
	int     10h
	pop     ax
	mov     dx, ax
	mov     cl, 4
	shl     dl, cl

	mov     ah, 8
	int     21h
	mov     char, al
	call    check
	push    ax
	mov     al, char
	mov     ah, 0eh
	int     10h
	lea     ax, new_ser + 3
	cmp     bx, ax
	jne     down_here
	mov     ah, 0eh
	mov     al, 02dh
	int     10h

down_here:
	pop     ax
	
	add     dx, ax
	mov     ax, dx
	jmp     @561

check:; cmp     al, 0dh
;       je      @560
;       cmp     al, 08
;       je      b@560
	cmp     al, 030h
	jl      @560
	cmp     al, 066h
	jg      @560
	cmp     al, 039h
	jg      @5601
	xor     al, 030h
	ret     ;jmp    @561
@5601:  cmp     al, 041h        ;uppercase
	jl      @560
	cmp     al, 046h
	jg      @5602
	sub     al, 037h
	ret     ;jmp    @561
@5602:  cmp     al, 061h        ;lowercase
	jl      @560
	sub     al, 057h
	ret     ;jmp    @561

@561:   mov     [bx] , al
	dec     bx
	lea     ax, new_ser
	cmp     ax, bx
	je      @562
	jmp     @560
@562:				;we dont need bx to be pushed for SERIAL.

@6:     push    bx
	lea     dx, msg1
	mov     ah, 9
	int     21h
	
	mov     ah, 1
	int     21h
	cmp     al, 01bh
	jne     @62
	jmp     start
@62:    push    ax
	cmp     al, 041h ; A:
	jne     @7
	xor     dx, dx
	jmp     @15
@7:     cmp     al, 061h
	jne     @8
	xor     dx, dx
	jmp     @15
@8:     cmp     al, 042h ; B:
	jne     @9
	mov     dx, 0001
	jmp     @15
@9:     cmp     al, 062h
	jne     @10
	mov     dx, 0001
	jmp     @15
@10:    cmp     al, 043h ; C:
	jne     @11
	mov     dx, 0002
	jmp     @111
@11:    cmp     al, 063h
	jne     @12
	mov     dx, 0002
	lea     ax, number10
@111:   cmp     ax, bx
	jne     @15
	jmp     begin
@12:    cmp     al, 044h ; D:
	jne     @13
	mov     dx, 0003
	jmp     @15
@13:    cmp     al, 064h
	jne     @14
	mov     dx, 0003
	jmp     @15
@14:    lea     dx, error1
	mov     ah, 9
	int     21h
	jmp     start
@15:    push    dx
	lea     dx, msg2
	mov     ah, 9
	int     21h
	pop     ax
	pop     dx      ;get pushed drive letter.
	push    ax
	mov     ah, 2
	int     21h
	lea     dx, msg3
	mov     ah, 9
	int     21h
	mov     ah, 1
	int     21h
	cmp     al, 059h
	je      @16
	cmp     al, 079h
	je      @16
	jmp     start
@16:    

	pop     dx              ;drive
	
reading:
	mov	cl, 5
read_2:
	push	cx
	xor	ax, ax
	int	13h

	mov     ax, 0201h       ;load old boot sector program.
	lea     bx, header
	mov     cx, 0001
	int     13h

	pop	cx
	loop	read_2

	pop     bx
	push    bx
	lea     ax, number9     ; > Modification to header for number 9.        
	cmp     ax, bx
	lea     bx, header
	jne     @16_2           ;\
	
	mov     [bx], 066ebh    ;/   ---> (reversed, ok?)
	jmp     @16_3
@16_2:  mov     [bx], 03cebh

@16_3: 	cmp	serial, 1	;get new SERIAL number input.(was it selected?)
	jne     @16_5
	lea     bx, header
	add     bx, 027h
	mov	ax, new_ser+1
	mov     [bx], ax     ;copy the new modified number over to new_boot
	inc     bx
	inc	bx
	mov	ax, new_ser+3
	mov     [bx], ax

@16_42: pop     bx
	jmp     writing
@16_5:  mov     cx, 01c0h       ;blank out old bootsectorprogram. Leave the
	lea     ax, newprog     ; header in-tact.
	mov     di, ax
	xor     ax, ax
	repz    stosb

	pop     bx      ;location
	push    dx
	push    bx

	pop     bx              ;copies actual body of new bootstrap code.
	mov     si, bx
	lea     ax, newprog
	mov     di, ax
	mov     cx, 01c0h
	repz    movsb

writing:
	xor     ax, ax          ;reset disk_controller
	int     13h

	lea     bx, newboot     ;source
	pop     dx              ;drive
	mov     ax, 00301h      ;write 1 sector. 200h bytes. 512d bytes.
	mov     cx, 0001        ;ch=track(0). cl=sector(1).
	int     13h             ; *** DO IT ***

	cmp     ah, 06
	je      writing
	cmp     ah, 80h
	jne     @17
	lea     dx, error3
	mov     ah, 9
	int     21h
	jmp     start
@17:    cmp     ah, 03h
	jne     @18
	lea     dx, error2
	mov     ah, 9
	int     21h
	jmp     start
@18:	lea     dx, msg4
	mov     ah, 9
	int     21h
    	cmp	serial, 1
	jne	quit
	jmp	start
quit:	jmp     endin



CODE     ENDS
	 END   START
