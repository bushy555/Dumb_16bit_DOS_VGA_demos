
code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
 	org     100h
	.386
start:
	mov     al, 013h                ;may need to be AX, 013h sometimes.
 	int     10h			;				 (4)(4)

 	mov     ax, 0a000h		;could save a byte here, though using
 	mov     es, ax			;   BH/BX stuffs up... why? (DX=CS&DS)
					;				 (5)(9)
;����������������������������������������������������������������������������
; RANDOM NUM.  ax = RND (-32768 to +32768).				(5)(14)
;                                                             "GET A DOG UP YA"
;����������������������������������������������������������������������������
@main:  imul    ax, 03			;smallest random number generator!
	add     ax, cx			; add some amount for the random number
;����������������������������������������������������������������������������
;PUTPIXEL routine. Slow... but small!. (BP �> X) (BX �> Y).           (19)(62)
;����������������������������������������������������������������������������
 	push    ax                      ;ax = random number (global), so PUSH.
 	mov     ax, 320			;ax := 320.  Width of screen.
 	mul     bx                      ;AX := 320 * Y
 	add     ax, bp                  ;AX := AX + X
 	mov     di, ax                  ;final destination offset.
 	mov     al, 9            	;3=cyan 4=red 9=blue.
 	stosb				;plot the pixel.
	pop	ax
;����������������������������������������������������������������������������
; Determines which point (0,0), (320, 0) or (320, 200) to plot.	        
;����������������������������������������������������������������������������
 ;������������������������������
 ;  (0,0)                        	;dont add anything.            (5)(19)
 ;������������������������������
	cmp     ax, -10923              ; -21845 for a freaky slide effect.
	jl      short @calc1
 ;������������������������������
 ;  (320,0)							       (12)(31)
 ;������������������������������
     	cmp     ax, 10923               ; 21845 for a freaky slide effect
 	jg      @next1
 	inc     cx			;some amount to add to RAND number.
 	add	bp, 320;		;add 320 to  X.
 	jmp     short @calc1
 ;������������������������������
 ;  (160,200)							       (8)(39)
 ;������������������������������
@next1:  add	bp, 160			;add 160 to  X.
	add	bx, 200			;add 200 to  Y.
;����������������������������������������������������������������������������
;   Calculate the two formula's for the next pixel.                    (4)(43)
;����������������������������������������������������������������������������
@calc1: 	shr     bp, 1			;original formula: 
					;       S := ((S + X[R]) DIV 2);

 	shr     bx, 1	             	;original formula:
					;       T := ((T + Y[R]) DIV 2);

;����������������������������������������������������������������������������
; RANDOM NUM.  ax = RND (-32768 to +32768).				(5)(14)
;                                                             "GET A DOG UP YA"
;����������������������������������������������������������������������������
imul	ax, 03
add	ax, cx
;����������������������������������������������������������������������������
; Determines which point (0,0), (320, 0) or (320, 200) to plot.	        
;����������������������������������������������������������������������������
 ;������������������������������
 ;  (0,200)                        	;dont add anything.            (5)(19)
 ;������������������������������
	cmp     ax, -10923              ; -21845 for a freaky slide effect.
	jg	@next0
	add	bx, 200
	jmp     short @calc2
 ;������������������������������
 ;  (320,200)							       (12)(31)
 ;������������������������������
@next0: cmp     ax, 10923               ; 21845 for a freaky slide effect
 	jg      @next2
 	inc     cx			;some amount to add to RAND number.
 	add	bp, 320;		;add 320 to  X.
	add	bx, 200
 	jmp     short @calc2
 ;������������������������������
 ;  (160,0)							       (8)(39)
 ;������������������������������
@next2:  add	bp, 160			;add 160 to  X.
;����������������������������������������������������������������������������
;   Calculate the two formula's for the next pixel.                    (4)(43)
;����������������������������������������������������������������������������
@calc2: 	shr     bp, 1			;original formula: 
					;       S := ((S + X[R]) DIV 2);

 	shr     bx, 1	             	;original formula:
					;       T := ((T + Y[R]) DIV 2);


;����������������������������������������������������������������������������
;READ keyboard for <ESC>					    (7)(69)
;����������������������������������������������������������������������������
	push	ax 
	in      al, 060h
 	cmp     al, 01
	pop	ax
 	jne     @main
;����������������������������������������������������������������������������
@quit:					;			     (6)(75)
;����������������������������������������������������������������������������
 	mov    ax, 0003
 	int    10h
 	retn
code    ENDS
END     start


;
;
;x[0] := 320; 
;y[0] := 438;
;x[1] := 638;
;y[1] := 0;
;x[2] := 0;
;y[2] := 0;
;
;x[3] := 320;
;y[3] := 0;
;x[4] := 638;
;y[4] := 438;
;x[5] := 0; {438;}
;y[5] := 438; {0;}
;s := 0;
;t := 0;
;
;
;       r := random (3);
;
;       putpixel (s, t, 04);
;       s := (s + x[r]) div 2;
;       t := (t + y[r]) div 2;
;
;       r := random (3);
;
;       s := (s + x[r+3]) div 2;
;       t := (t + y[r+3]) div 2;


