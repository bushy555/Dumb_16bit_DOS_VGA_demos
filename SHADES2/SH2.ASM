;=============================================================================
; shades.asm - Bop Shades Demostration.
;                                                    File created: 10-21-93
; Copyright (c) 1993, Carlos Hasan                  Last modified: 10-21-93
;
; Description:
;   This code implements bop shades using a gray palette of 64 levels in
;   the VGA 320x200x256 graphics mode.
;
; Portability:
;  Requires Turbo Assembler 3.2 or better to be assembled.
;  Dependent on the IBM PC 286 and the VGA graphics card.
;=============================================================================

                jumps
                .model  small,pascal
                .286

                dosseg                          ; used for linking like 
                .stack 1024                     ; an Standalone program.

                global  BopShades:proc

;======================== Demo Equates and Data ==============================

TIMEOUT         equ     2500                    ; Number of Frames Total.
_TIME4          equ     2000                    ; Number of Frames Total.
_TIME3          equ     1500                    ; Number of Frames Total.
_TIME2          equ     1000                    ; Number of Frames Total.
_TIME1          equ     500                    ; Number of Frames Total.
MAXWIDTH        equ     320                     ; Screen Dimens.
MAXHEIGHT       equ     200
CENTERX         equ     160-25                  ; Screen Center Coord.
CENTERY         equ     100-25
MAXBOPS         equ     125                     ; Number of Bops.
RADIUSX         equ     120                     ; Bops Path Radius.
RADIUSY         equ     60

                .data

                include shades.inc              ; Bop Points Table.
                include sincos.inc              ; Sin/Cos Table.

BopQueue        dw      MAXBOPS dup(?)          ; Bops Positions Queue.
BopHead         dw      ?                       ; Current Queue Head.
Angle           dw      ?                       ; Bops Path Generation
Phase1          dw      ?                       ; Parameters.
Phase2          dw      ?                       ; Angle, Phase, Incs.
PhInc1          dw      ?
PhInc2          dw      ?
Frames          dw      ?                       ; Frame Counter.

;======================== Demo Routines ======================================

                .code

;-----------------------------------------------------------------------------
; ShowBop - Shows a BopShade at specified position.
; In:
;   DI  - Position Offset.
;-----------------------------------------------------------------------------

ShowBop         proc near

                mov     ax,0A000h
                mov     es,ax
                xor     si,si
                mov     cx,BOPPTS
ShowLoop:       mov     al,[BopAddTab+si]
                shl     si,1
                mov     bx,[BopTab+si]
                shr     si,1
                add     es:[bx+di],al
                inc     si
                loop    ShowLoop
                ret

ShowBop         endp

;-----------------------------------------------------------------------------
; HideBop - Hides a BopShade at specified position.
; In:
;   DI  - Position Offset.
;-----------------------------------------------------------------------------

HideBop         proc near

                mov     ax,0A000h
                mov     es,ax
                xor     si,si
                mov     cx,BOPPTS
HideLoop:       mov     al,[BopAddTab+si]
                shl     si,1
                mov     bx,[BopTab+si]
                shr     si,1
                sub     es:[bx+di],al
                inc     si
                loop    HideLoop
                ret

HideBop         endp

;-----------------------------------------------------------------------------
; InitBops - Initializes the BopShade Queue.
;-----------------------------------------------------------------------------

InitBops        proc near

                mov     ax,ds
                mov     es,ax
                lea     di,[BopQueue]
                mov     cx,MAXBOPS
                mov     ax,0FFFFh               ; illegel offset,
                cld                             ; because first bops
                rep     stosw                   ; are hidden.
                mov     [BopHead],0
                ret

InitBops        endp

;-----------------------------------------------------------------------------
; PutBop - Puts a new BopShade onto the Queue and updates the screen.
; In:
;   (CX,DX) - Screen coordinates.
;-----------------------------------------------------------------------------

PutBop          proc near

                mov     di,dx
                imul    di,MAXWIDTH
                add     di,cx
                mov     bx,[BopHead]
                xchg    [BopQueue+bx],di
                cmp     di,MAXWIDTH*MAXHEIGHT
                jae     PutNewBop
                call    HideBop
PutNewBop:      mov     bx,[BopHead]
                mov     di,[BopQueue+bx]
                cmp     di,MAXWIDTH*MAXHEIGHT
                jae     SkipShow
                call    ShowBop
SkipShow:       add     [BopHead],2
                cmp     [BopHead],2*MAXBOPS
                jb      ByePutBop
                mov     [BopHead],0
ByePutBop:      ret

PutBop          endp


;-----------------------------------------------------------------------------
; BopShades - Performs the Demostration.
; In:
;   DS - Data Segment.
;-----------------------------------------------------------------------------

Start       proc
                mov     ax,@Data
                mov     ds,ax

                mov     ax,13h                  ; Sets 320x200x256 mode.
                int     10h

                mov     dx,3C8h                 ; Set the Shaded Palette.
                xor     al,al
                out     dx,al
                inc     dx
                mov     cx,256
                xor     ah,ah
SetPal:         xor     al,al
		mov	al, ah
                out     dx,al
                mov     al,ah
                out     dx,al
		mov	al, 0;fdh
                out     dx,al
                cmp     ah,63
                jae     SetBrk
                inc     ah
SetBrk:         loop    SetPal

                call    InitBops                ; Init BopsQueue.

                mov     [Angle],0               ; Init Variables.
                mov     [Phase1],2*1024
                mov     [Phase2],2*1024
                mov     [PhInc1],2
                mov     [PhInc2],3
                mov     [Frames],0

ShadesLoop:     mov     ax,[Angle]              ; Compute X Coord.
                imul    [Phase1]
                mov     bl,ah
                mov     bh,dl
                shr     bx,2
                xor     bh,bh
                mov     al,[CosTable+bx]
                mov     ah,RADIUSX
                imul    ah
                sar     ax,6
                add     ax,CENTERX
                mov     cx,ax

                mov     ax,[Angle]              ; Compute Y Coord.
                imul    [Phase2]
                mov     bl,ah
                mov     bh,dl
                shr     bx,2
                xor     bh,bh
                mov     al,[SinTable+bx]
                mov     ah,RADIUSY
                imul    ah
                sar     ax,6
                add     ax,CENTERY
                mov     dx,ax

                call    PutBop                  ; Puts BopShade at (CX,DX)

                mov     ax,[Angle]              ; Increment Angle.
                inc     ax
                and     ax,1023
                mov     [Angle],ax

                mov     ax,[Phase1]             ; Increment Phase1.
                add     ax,[PhInc1]
                cwd
                mov     bx,5*1024
                div     bx
                mov     [Phase1],dx

                mov     ax,[Phase2]             ; Increment Phase2.
                add     ax,[PhInc2]
                cwd
                mov     bx,5*1024
                div     bx
                mov     [Phase2],dx

                inc     [Frames]                ; enough frames showed?


                cmp     [Frames],_TIME1
		jne	@@0

                mov     dx,3C8h                 ; Set the Shaded Palette.
                xor     al,al
                out     dx,al
                inc     dx
                mov     cx,256
                xor     ah,ah
SetPal2:         xor     al,al
		mov	al, ah
                out     dx,al
                mov     al,0;ah
                out     dx,al
		mov	al, 0;fdh
                out     dx,al
                cmp     ah,63
                jae     SetBrk2
                inc     ah
SetBrk2:         loop    SetPal2
		jmp	short @@TIMEOUT


@@0:            cmp     [Frames],_TIME2
		jne	@@1

                mov     dx,3C8h                 ; Set the Shaded Palette.
                xor     al,al
                out     dx,al
                inc     dx
                mov     cx,256
                xor     ah,ah
SetPal3:         xor     al,al
		mov	al, ah
                out     dx,al
                mov     al,ah
                out     dx,al
		mov	al, 0;fdh
                out     dx,al
                cmp     ah,63
                jae     SetBrk3
                inc     ah
SetBrk3:         loop    SetPal3
		jmp	short @@TIMEOUT

@@1:            cmp     [Frames],_TIME3
		jne	@@2

                mov     dx,3C8h                 ; Set the Shaded Palette.
                xor     al,al
                out     dx,al
                inc     dx
                mov     cx,256
                xor     ah,ah
SetPal4:         xor     al,al
                out     dx,al
                out     dx,al
                mov     al,ah
                out     dx,al
                cmp     ah,63
                jae     SetBrk4
                inc     ah
SetBrk4:         loop    SetPal4
		jmp	short @@TIMEOUT


@@2:            cmp     [Frames],_TIME4
		jne	@@3

                mov     dx,3C8h                 ; Set the Shaded Palette.
                xor     al,al
                out     dx,al
                inc     dx
                mov     cx,256
                xor     ah,ah
SetPal5:         xor     al,al
                mov     al,ah
                out     dx,al
                out     dx,al
                out     dx,al
                cmp     ah,63
                jae     SetBrk5
                inc     ah
SetBrk5:         loop    SetPal5

@@3:


@@TIMEOUT:	cmp	[frames], TIMEOUT
		jne	@@key
		mov	[frames], 0

@@key:          mov     ah,1                    ; any key pressed?
                int     16h
                je      ShadesLoop

ShadesBye:      
                mov     cx,MAXBOPS              ; Hides all the Bops.
HidesLoop:      push    cx
                mov     cx,0FFFFh
                mov     dx,cx
                call    PutBop
                pop     cx
                loop    HidesLoop

                mov     ax,03h
                int     10h
                mov     ax,4C00h
                int     21h

Start       endp


                end     Start
