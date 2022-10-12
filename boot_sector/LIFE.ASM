;For boot sector of Disk/Hard Drive
;Was 256 bytes in size. Knocked it down to 148 bytes. ~early 1996.
;
;138 bytes. 31/May/1997.
;123 bytes. 01/June/1997.
;115 bytes. 22/Jan/1998. 10:30 to 11:49pm (8 bytes...).
;
; Add this to your boot sector for a little surprise when you next forget to
; take your disk out!
; Load this .COM file into debug by:
;	DEBUG LIFE3.COM
;       F 100 0 0 5000 0    <Fill memory with 0000etc>
;	L		    <Load LIFE3.COM back in>
;	M 100 500 1000      <Move it from 100-200 to 1000-1100>
;	L 100 0 0 1	    <Load the 1st sector of Drive A. C:=" L 100 2 0 1">
;	U 100		    <Unassemble beginning at 100>
;	<Note the first JMP XXXX. DOS 5+ it is 13E.  v3.3 it should be 120.>
;	M 1000 1500 XXXX    <The first number after that JMP instruction at 100>
;	W 100 0 0 1	    <Write one sector back to 1st sector on A:>
;	Q		    <Quit>
;	<and re-boot!>

; Bushy '95.    <Original comments below...>

;------------------------------------------------------------;
;  LIFE.COM -- Conway's Game of Life                         ;
;  Danny Dulai's submission to the 256 byte game competition ;
;                                                            ;
;  Arrow keys - move cursor                                  ;
;  Space      - places cell                                  ;
;  Enter      - one generation                               ;
;                                                            ;
; NOTE: NO ERROR HANDLING! MAKE SURE YOU HAVE AT LEAST       ;
;       192K AVAILIBLE MEMORY!                               ;
;                                                            ;
;------------------------------------------------------------;

.model tiny
.code
.386
org 100h
start proc

	push	ax
	push	ax
	pop	fs
	pop	ds
        mov     ax, 00013h
	int	10h
        push    0a000h
	pop	es
;--------------------------------------- 13 13

        mov     cl, 0ch                 ;start the ball rolling...
@lop:   inc     si
        mov     byte ptr [si], 1
        loop    @lop
;---------------------------------------- 8 21

@@_0:   xor     si,si
	xor	di,di
        mov     cx, 16000
	rep	movsd

        in      al, 060h                ;<ESC> pressed?...
	cmp	al, 1
        jne     NoExit
;--------------------------------------- 15 36

        mov     al, 3
        int     10h
        int     19h
;--------------------------------------- 6  42

NoExit: mov     cx, 63358
        mov     si, 321
@@_1:   mov     al, [si-1]
        add     al, [si+1]
        add     al, [si-319]
        add     al, [si+319]
        add     al, [si-320]
        add     al, [si+320]
        add     al, [si-321]
        add     al, [si+321]
        mov     bl, 1
        cmp     al, 2
        je      @@_2
        cmp     al, 3
        je      @@_4
        jmp     @@_3
@@_2:   cmp     byte ptr [si], 0
        jne     @@_4
@@_3:   dec     bx
@@_4:   mov     byte ptr fs:[si], bl
        inc     si
        dec     cx
        jnz     @@_1
        mov     bx, ds
        mov     dx, fs
        mov     ds, dx
        mov     fs, bx
        jmp     @@_0

start endp
end start
