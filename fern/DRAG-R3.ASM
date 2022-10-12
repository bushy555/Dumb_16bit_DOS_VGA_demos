_Counter1 EQU   25000

code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	org     100h
.386
    LOCALS
Start:
    mov     ax,0013h                ;set 320x200x256 mode
    int     10h
    
BoxLoop:
    pushad          ;saves EVERYTHING (extended registers, too), except flags
    mov     ax,cs
    mov     ds,ax
    mov     es,ax

    mov     bp,0    ;point counter
@@DoNextPoint:
    mov     bx,[XYCord.X +bp]   ;load in cordinates to rotate
    mov     cx,[XYCord.Y +bp]
    push    bp
    push    ds
    mov     ax,cs                   ;the basic formula for rotations:
    mov     ds,ax                   ; X := cos(angle) * x - sin(Xan) * y
                                    ; Y := sin(angle) * x + cos(Xan) * y
    mov     si,[Angle.W]
    add     si,si                   ; si = angle*2
    mov     ax,[Cosine+si]          ; ax = cos(angle)
    imul    bx                      ; ax = cos(angle) * x
    shl     edx,16                  ; put dx in high edx
    mov     dx,ax                   ; save all 32 bits
    mov     edi,edx                 ; store for later use

    mov     ax,[Sine+si]            ; ax = sin(angle)
    imul    cx                      ; ax = sin(angle) * y
    shl     edx,16
    mov     dx,ax
    sub     edi,edx                 ; edi = edi-eax=cos(angle)*x-sin(angle)*y
    sar     edi,8                   ; remove the "256-factor"
    mov     ebp,edi                 ; ebp = x-coordinate

    mov     ax,[Sine+si]            ; ax = sin(angle x)
    imul    bx                      ; ax = sin(angle x) * x
    shl     edx,16
    mov     dx,ax
    mov     edi,edx

    mov     ax,[Cosine+si]          ; ax = cos(angle x)
    imul    cx                      ; ax = cos(angle x) * y
    shl     edx,16
    mov     dx,ax
    add     edi,edx                 ; di = di-ax = sin(vx)*y + cos(vx)*z
    sar     edi,8                   ; remove the (co)sin "256-factor"

    mov     bx,bp                   ; update X
    mov     cx,di                   ; update Y

    pop     ds
    pop     bp

    mov     [RotCord.X +bp],bx  ;save rotated cordinates IN A DIFFERENT PLACE
    mov     [RotCord.Y +bp],cx

    add     bp,4            ;size of each entry
    cmp     bp,NumPts*4     ;are we done, yet?
    jb      @@DoNextPoint   ;No. Do another
    
    popad

    mov     al,[AngleVel]
    add     [Angle.b],al    ;note that by just increasing the byte part, the 
                            ;ranging is automatic (stays in 0-255 range)
    mov     dx,3dah
VRT:
    in      al,dx
    test    al,8
    jnz     VRT         ;wait until Verticle Retrace starts

NoVRT:
    in      al,dx
    test    al,8
    jz      NoVRT       ;wait until Verticle Retrace Ends

    pusha               ;saves only non extended registers

    mov     ax,cs
    mov     ds,ax
    
    mov     bp,0        ;point counter
    mov     al,[Color]
@@DoNextPoint:
    mov     si,bp
    add     si,si
    mov     bx,si       ;bx= bp*2
    add     si,si       ;si= bp*4
    mov     di,[OldDI+bx]
    mov     BYTE PTR es:[di],0  ;clear out old point
    mov     di,[RotCord.Y +si]        ;pixel location = ScreenWidth*Ypos + Xpos = 320 * (Y+AddY) + X + AddX
    add     di,[AddY]
    mov	    y1, di
    mov     di,[AddX]
    add     di,[RotCord.X +si]
    mov	    x1, di
    mov     [OldDi+bx],di
    inc     bp

    mov     si,bp
    add     si,si
    mov     bx,si       ;bx= bp*2
    add     si,si       ;si= bp*4
    mov     di,[OldDI+bx]
    mov     BYTE PTR es:[di],0  ;clear out old point
    mov     di,[RotCord.Y +si]        ;pixel location = ScreenWidth*Ypos + Xpos = 320 * (Y+AddY) + X + AddX
    add     di,[AddY]
    mov	    y2, di
    mov     di,[AddX]
    add     di,[RotCord.X +si]
    mov	    x2, di
    inc     bp

    mov     si,bp
    add     si,si
    mov     bx,si       ;bx= bp*2
    add     si,si       ;si= bp*4
    mov     di,[OldDI+bx]
    mov     BYTE PTR es:[di],0  ;clear out old point
    mov     di,[RotCord.Y +si]        ;pixel location = ScreenWidth*Ypos + Xpos = 320 * (Y+AddY) + X + AddX
    add     di,[AddY]
    mov	    y3, di
    mov     di,[AddX]
    add     di,[RotCord.X +si]
    mov	    x3, di					
    inc     bp

;---
	mov	ax, 0a000h	;copy from 2000 to A000 (Mem to Screen)
	mov	es, ax
	mov	ax, 02000h
	mov	ds, ax
	mov	cx, 16000
        xor     si, si
        xor     di, di
	rep	movsd

	mov	ax, 02000h	;Clear 2000 (Mem)
	mov	es, ax
        xor     di, di
        xor     eax, eax
	mov 	cx, 16000
	rep 	stosd

	mov	ax, cs
	mov	ds, ax

;----
	mov	ax, 02000h
	mov	es, ax

        mov     cx, _Counter1
@main:  push    cx
        mov     ax, rand
	inc	ax
	imul    ax, 03			;smallest random number generator!
	mov	rand, ax

        mov     cx, bx           ;setup for both 50%'s  NewX and NewY.
        add     cx, bp           ;  bit quicker and saves ~15 bytes.
        mov     dx, bx
        neg     dx
        add     dx, bp
        test    ax, ax
        jg      @@_1
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;  First 50%
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        add     cx, 40          ;newx:=((0.5*x)+(0.5*y)+80);
        add     dx, 37
        sub     ax, cx          ;newy:=((0.5*-x)+(0.5*y)+75);
        mov     bx, x1
        shr     bx, 1
        add     cx, bx
        mov     bx, y1
        shr     bx, 1
        add     dx, bx
        jmp     @@_Calc
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;  Second 50%
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@@_1:    sub     cx, 40          ;newx:=((0.5*x)+(0.5*y)-80);
        add     dx, 75         ;newy:=((0.5*-x)+(0.5*y)+125);
        mov     bx, 320
        sub     bx, x1
        shr     bx, 1
        add     cx, bx
        mov     bx, 200
        sub     bx, y1
        shr     bx, 1
        add     dx, bx

;mov     bx, x1
;shr bx, 1
;add     cx, bx
;mov bx, y1
;shr bx, 1
;add dx, bx

        add     ax, cx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;   Do the («*x)'s and («*y)'s on NewX and NewY.                       (4)(41)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
@@_calc:shr     cx, 1
        shr     dx, 1
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;PUTPIXEL routine. (x,y) -> (cx, bx)
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        push    ax
        mov     bx, cx
        mov     bp, dx
        mov     ax, 02000h
        mov     es, ax
        mov     ax, 320
        mul     dx
        add     ax, cx
        add     ax, 140         ;Centre it!
        xchg    di, ax                                                 ; (1)
        mov     al, 2
        stosb
        pop     ax
        pop     cx
 	loop	@Main

    popa
    
	
    mov     ah,1
    int     16h         ;has a key been pressed? Z flag is set if not
    jz      BoxLoop
    mov     ah,0        ;a key has been pressed, 
    int     16h         ; get it in AX (al= ascii, ah=scan code)

    cmp     al,27       ;was it the ESCAPE key?
    je      ByeBye      ;Yup, take off

    cmp     al,"+"          ;increases angle velocity
    jne     NotPlus
    inc     [AngleVel]
    jmp     BoxLoop
NotPlus:
    cmp     al,"-"          ;decreases angle velocity
    jne     NotMinus
    dec     [AngleVel]
    jmp      BoxLoop
NotMinus:

    jmp     BoxLoop

ByeBye:    
    mov     ax,0003h    ;set 80x25x16 text
    int     10h
    mov     ax,4c00h    ;return control to DOS
    int     21h






ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;=== Data Includes -include physically puts the file in this one on compile
INCLUDE sincos.dw       ;Labels SINE: and COSINE: contains sine(0-255)*256
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;=== DATA Structures
    
    Angle_Union     UNION
        B       db  0
        W       dw  0
    Angle_Union     ENDS    ;creates a new data type (eg. DW, DB, DD) called
                            ;Angle_Union. Used just like in C
    Point_Struc     STRUC
        X       dw  ?
        Y       dw  ?
    Point_Struc     ENDS    ;Create a structure (or a record)

ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;=== DATA

NumPts      EQU 3

XYCord      Point_Struc <-50,50>,<50,50>,<-50,-50>,<50,-50>
            Point_Struc <-30,30>,<30,30>,<-30,-30>,<30,-30>
    ;sets up data for the corners of a 2d box

RotCord     Point_Struc NumPts DUP(<>)

OldDi       dw  NumPts DUP (0)  ;holds di for quick erasing

Angle       Angle_Union <?,?>   ; the '?' defaults to zero, but you can't
                                ;specify in a Union
AngleVel    db  1       ;angle velocity

AddX        dw  160     ;amount to ADD to each X cordinate
AddY        dw  100     ;amount to ADD to each Y cord

;Palette     db  3 dup (0)   ;sets up a palette that fades from (0,0,0) to
;    i = 1                   ;(15*4,15*3,15*2) in 16 steps
;    REPT    15
;            db  4*i,3*i,2*i
;        i=i+1
;    ENDM

Color       db  15

rand            dw ?
x1      dw ?
y1      dw ?
x2      dw ?
y2      dw ?
x3      dw ?
y3      dw ?


   code    ENDS
END     start





TREE
DATA 4
0.42,0.42,-0.42,0.42,0,0.2,0.4
0.42,-0.42,0.42,0.42,0,0.2,0.4
0.1,0,0,0.1,0,0.2,0.15
0,0,0,0.5,0,0,0.05


