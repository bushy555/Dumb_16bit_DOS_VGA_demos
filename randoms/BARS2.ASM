
code    SEGMENT PARA PUBLIC 'code'
	ASSUME cs:code, ds:code, es:code, ss:code
	.8086

	ORG     100h                    ; Queremos um .COM, o menor possivel

start:  cld                             ; Sou eu!
	cli
	mov     ax,3                    ; Modo de video 3 (texto 80x25)
	int     10h


	mov     bl, 30
	mov ax,1202
	int     10h

	.386                            ; Se passou pelos testes, ‚ 386


	push    0b800h                  ; es contem o segmento de video,
	pop     es                      ; modo texto

	xor     di,di                   ; Esconde o cursor
	mov     ax,di                   ; Este m‚todo economiza bytes
	stosw                           ; se comparado a desabilit -lo



mainloop:

vwait   PROC    NEAR
	mov     dx,3dah                 ; Espera o retra‡o vertical
@@vw1:  in      al,dx                   ; (o timing ‚ realizado atrav‚s da
	and     al,08h                  ; espera de retraco. Se o micro
	jnz     @@vw1                   ; for suficientemente lento para
@@vw2:  in      al,dx                   ; nao poder fazer os calculos entre
	and     al,08h                  ; dois retra‡os, haver  perda de
	jz      @@vw2                   ; sincronismo)
vwait   ENDP

	mov     si,OFFSET pal_table
	mov     cx,290                  ; Contador de linhas

doscreen:                               ; Loop realizado para as primeiras
					; 290 linhas da tela

	mov     dl,0c8h                 ; Reprograma a palette, cor 0
	outsw                           ; (dh==3)
	inc     dx
	outsb
	outsb
	dec     dx                      ; Reprograma a palette, cor 1
	outsw
	inc     dx
	outsb
	outsb

	loop    doscreen                ; Sai com cx==0 e dh==3



initr   PROC    NEAR
	mov     si,OFFSET pal_table
	mov     cx,290                  ; Numero de linhas

@@fill7: xor     dx,dx
	mov     ax,cx                   ; ax cont‚m a cor
	shr     ax,3
	mov     ah,al
	mov     WORD PTR [si],dx        ; Cor 0 (degradee cyan -> preto), R
	mov     [si+2],ax               ; G,B
_init_  LABEL   WORD                    ; inc dx -> jmp SHORT @@go
	inc     dx
	not     ax
	mov     WORD PTR [si+4],dx      ; Cor 1 (degradee preto -> cyan), R
	mov     [si+6],ax               ; G,B

@@go7:   add     si,8
	loop    @@fill7
	mov     [_init_],07ebh          ; patch de inicializa‡ao ;-)
initr   ENDP




sinbar  PROC    NEAR
	mov     cl,10                    ; Numero de barras (ch==0)
@@go8:   mov     bx,cx
	push    cx
	shl     bx,3
	mov     al,[angle]              ; Coleta angulo atual
	sub     al,bl

; --- Coleta seno do angulo

	xor     dl,dl                   ; Inicializa dl
	mov     bx,OFFSET sintable
	test    al,80h                  ; Verifica se quadrante 3 ou 4
	jz      q12
	dec     dx                      ; 3 ou 4, faz dl=0ffh
	and     al,7fh                  ; Reduz para 1 ou 2
q12:    cmp     al,40h                  ; Verifica se quadrante 1 ou 2
	jbe     q1
	neg     ax                      ; Redu‡ao ao 1o quadrante
	and     al,3fh
q1:     xlat                            ; Coleta seno do angulo
	xor     al,dl                   ; not ax se dl==0ffh

; --- Seno coletado em al

	cbw
	add     ax,137                  ; Varia‡ao: 10 a 264
	shl     ax,3                    ; Cada entrada tem 8 bytes
	mov     si,OFFSET pal_table
	add     si,ax
	mov     cl,24                   ; Espessura da barra
	mov     al,48                   ; Cor para barras
@@bar8:  mov     [si+1],al               ; R
	mov     [si+2],al               ; G
	mov     [si+3],al               ; B
	add     si,8                    ; Proxima entrada
	sub     al,2                    ; Cor para degradee
	loop    @@bar8
	pop     cx
	loop    @@go8                    ; Proxima barra
	dec     [angle]                 ; Incrementa angulo
sinbar  ENDP

; --- Verifica tecla pressionada

	in      al,60h                  ; Coleta scancode
	cmp     al,1                    ; 1 == <ESC>
	jne     mainloop


; --- Retorno ao DOS

getout: mov     ax,3                    ; Modo de v¡deo 3 (limpa a tela)
	int     10h

bye:    sti                             ; Habilita interrup‡oes
	mov     ah,4ch                  ; Retorna ao DOS
	int     21h


sintable LABEL BYTE

 db     0,   3,   6,   9,  12,  16,  19,  22,  25,  28,  31,  34,  37,  40
 db    43,  46,  49,  51,  54,  57,  60,  63,  65,  68,  71,  73,  76,  78
 db    81,  83,  85,  88,  90,  92,  94,  96,  98, 100, 102, 104, 106, 107
 db   109, 111, 112, 113, 115, 116, 117, 118, 120, 121, 122, 122, 123, 124
 db   125, 125, 126, 126, 126, 127, 127, 127, 127

angle           db      ?                       ; angulo para sinusbars
pal_table       db      ?

code    ENDS

END     start

sintable LABEL BYTE

db 00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20
db 21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40
db 41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60
db 61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80
db 81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100
db 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120
db 121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140
db 141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160
db 161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180
db 181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200
