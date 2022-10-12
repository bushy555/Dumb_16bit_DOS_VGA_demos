TRACKS  EQU     7                       ; numero de trilhas para musica

code    SEGMENT PARA 
	ASSUME cs:code, ds:code, es:code, ss:code

	ORG     100h                    ; Queremos um .COM, o menor possivel

start: 
	.386                            ; Se passou pelos testes, ‚ 386

	mov     si,OFFSET base          ; Inicializa‡ao das trilhas
	mov     di,OFFSET track
	mov     cx,TRACKS
	repz    movsw                   ; Sai com ax==cx==0

	mov     ax,0120h                ; Habilita bit 5 do reg 1 da Adlib
	call    addata                  ; (Waveforms)

	mov     cl,6                    ; 6 instrumentos a programar
	xor     bx,bx                   ; iniciando no canal 1
	mov     si,OFFSET instruments   ; a partir do 1o instrumento
	call    set_instr

	inc     cx                      ; Chorus para o canal 4
	mov     si,OFFSET brass
	call    set_instr


mainloop:

	mov cx, 13000
@@loop_dj2:
	loop @@loop_dj2


play    PROC    NEAR
	xor     bx,bx                   ; bx indica o canal atual
	mov     cx,TRACKS
@@next9: mov     ax,timer[bx]            ; Coleta o timer para o canal
	or      ax,ax                   ; Verifica se expirou
	jnz     @@next_timer9

	xor     dx,dx                   ; Zera transposi‡ao
	or      bx,bx                   ; O canal 1 (bx=0) ‚ reservado
	jnz     @@no_arp39               ; para o arpejador

	mov     si,[a_ptr]              ; dl cont‚m a quantia para
	mov     dl,[si]                 ; transposi‡ao
@@no_arp39:
	push    cx
@@reset_tr9:
	mov     si,track[bx]
@@new_val9:
	lodsb                           ; Coleta evento da trilha
	or      al,al                   ; Verifica se ‚ nota
	jns     @@volume9

	mov     ch,al                   ; Processa nota
	and     ax,000fh
	add     ax,dx                   ; Transposi‡ao do arpejador
	cmp     al,12                   ; Verifica overflow de oitava
	jb      @@skip9
	sub     al,12                   ; Ajusta overflow de oitava
	add     ch,10h
@@skip9: and     cx,0f000h               ; M scara para envio de valor
	shr     ch,2                    ; para Adlib
	shl     ax,1
	add     ax,OFFSET note2freq     ; Coleta frequencia da tabela
	mov     di,ax
	or      cx,[di]
	add     cl,finetune[bx]         ; Soma afina‡ao (para chorus)
@@pause_t19:
	mov     ax,notelen[bx]          ; Coleta dura‡ao da nota
@@pause_tx9:
	mov     timer[bx],ax            ; Atualiza ponteiros
	mov     track[bx],si

	mov     ah,bl
	shr     ah,1
	add     ah,0a0h
	mov     al,cl
	call    addata
	add     ah,10h
	xor     al,al
	call    addata
	mov     al,ch
	call    addata

	pop     cx
@@next_timer9:
	dec     timer[bx]               ; Decrementa timer do canal atual
	inc     bx                      ; Incrementa canal
	inc     bx
	loop    @@next9                  ; Proximo canal
	jmp     @@end9                   ; Encerra (em condi‡oes normais
					; seria um ret)
@@volume9:
	jnz     @@no_pause9
	xor     cx,cx
	jmp     SHORT @@pause_t19
@@no_pause9:
	test    al,40h                  ; Flag que indica se um ctrl.
	jnz     @@ctrl9
	mov     di,bx
	shr     di,1
	mov     ah,reg_index[di]
	add     ah,40h                  ; Operador & voz correto
					; Coleta em ah o novo volume
	dec     ax
	call    addata                  ; ah= valor, al= porta
	add     ah,03h                  ; Idem para o operador 2
	lodsb
	dec     ax
	call    addata                  ; ah= valor, al= porta...
	jmp     @@new_val9         ; Coleta novo valor da trilha
@@ctrl9:
	and     al,3fh                  ; Processamento de controle
	jnz     @@no_40h9
	mov     ax,base[bx]
	mov     track[bx],ax            ; Verifica terminador de trilha

	or      bx,bx                   ; Arpejador na trilha 0
	jnz     @@no_arp9

	inc     WORD PTR [a_ptr]        ; Incrementa ptr p/ transposi‡ao
	mov     bx,[a_ptr]              ; Coleta ptr p/ transposi‡ao
@@new_arp9:
	mov     dl,[bx]                 ; Transposi‡ao em dl
	cmp     dl,040h                 ; Verifica final de trilha
	jne     @@no_arp29
	mov     bx,OFFSET arpegiator    ; Reseta ponteiro de transposi‡ao **
	mov     [a_ptr],bx
	jmp     SHORT @@new_arp9
@@no_arp29:
	xor     bx,bx
@@no_arp9:
	jmp     @@reset_tr9              ; Coleta novo valor da trilha
@@no_40h9:
@@no_42h9:
	sub     al,0fh                  ; CUIDADO COM ESTE VALOR
	shl     al,2                    ;
	mov     BYTE PTR notelen[bx],al ; dh= 10h - numero de efeitos
	jmp     @@new_val9               ; ja processados...
@@end9:
play    ENDP

;-keyboard

	in      al,60h                  ; Coleta scancode
	cmp     al,1                    ; 1 == <ESC>
	jne     mainloop

;-exit to  dos

bye:    int 20


addata  PROC    NEAR                    ; Envia dado (ah) p/ porta Adlib (al)
	pusha
	xchg    al,ah
	mov     dx,388h                 ; Porta de registrador da Adlib
	out     dx,al
	mov     cx,3
@@wait10: in      al,dx
	loop    @@wait10                  ; Delay para registrador

	inc     dx                      ; Porta de dados da Adlib
	mov     al,ah
	out     dx,al
	mov     cl,16
	dec     dx
@@wait110:in      al,dx                   ; Delay para dados
	loop    @@wait110
	popa
	ret
addata  ENDP


set_instr  PROC
@@letsgo12:
	push    cx
	push    bx
	mov     ah,reg_index[bx]
	mov     dl,02
@@again12:mov     cx,0004
@@loop112:add     ah,20h
	lodsb
	call    addata
	loop    @@loop112

	add     ah,60h
	lodsb
	call    addata
	sub     ah,0ddh
	dec     dl
	jnz     @@again12

	add     bl,0c0h
	mov     ah,bl
	lodsb
	call    addata

	pop     bx
	pop     cx
	inc     bx
	loop    @@letsgo12

	ret
set_instr  ENDP




note2freq       dw      16bh, 181h, 198h, 1b0h, 1cah, 1e5h
		dw      202h, 220h, 241h, 263h, 287h, 2aeh

reg_index       db      00h, 01h, 02h, 08h, 09h, 0ah, 10h, 11h, 12h

arpegiator      db  0,0,5,5,10,10,5,5,40h

arp_pattern LABEL BYTE
db  051h,0a0h,0b0h,0b0h,0a0h,097h,0a7h,0a0h,0b0h
db  0a0h,0b0h,0b0h,0a0h,097h,0a0h,0a7h,0b0h,040h

arp2 LABEL BYTE
db  053h,0d0h,0c7h,0c5h,0c0h,0b7h,0b5h,0b0h,0a7h
db  0d0h,0c7h,0c5h,0c0h,0b7h,0b5h,0b0h,0a7h,13h,13h,040h

basso LABEL BYTE
db  07fh,0a0h,057h,09ah,0a0h                    ; C
db  07fh,095h,057h,000h,090h                    ; F
db  07fh,09ah,057h,000h,0a0h                    ; Bb
db  07fh,095h,057h,004h,008h,0a5h,0a7h,040h     ; F

solo LABEL BYTE
db  06fh,0a0h,000h,0a5h,000h,0aah,057h
db  0aah,0a9h,0a5h,0a2h,06fh,0a0h,000h
db  06bh,0b5h,063h,0b4h,057h,0aah,0b0h
db  07fh,0b5h,057h,0bah,0b9h,06fh,0b5h
db  07fh,000h,000h;,000h
db  06bh,0b5h,063h,0b4h,057h,0b4h,0b5h
db  06bh,0bah,06bh,0b9h,057h,0b0h
db  067h,0b4h,053h,0b5h
db  06bh,0b2h,053h,0b4h,0b5h
db  06fh,0bah,0b9h,06fh,000h,000h
db  000h,0a9h,0b2h,0b5h,0b9h,0a9h,040h

bassdrum LABEL BYTE
db  057h,080h,040h

snaredrum LABEL BYTE
db  057h,000h,051h,090h,000h,000h,090h
db  057h,000h,05fh,090h,090h
db  051h,006h,006h,090h,000h,090h,090h,40h


instruments LABEL BYTE

arpeg           db  00h,  05h, 086h, 0c1h,  02h       ; <-- op 1 (modulator)
		db  00h,  05h, 0d6h, 0c1h,  03h,  03h ; <-- op 2 (carrier)

brass           db  02h,  08h, 0f2h, 0c1h,  01h
		db  01h,  4ah, 082h, 0c1h,  03h,  03h

synth           db  00h, 03fh, 0f6h,  05h,  02h
		db  01h, 03fh, 0f6h,  05h,  03h,  03h

laserharp       db  01h,  3fh, 071h,  02h,  01h
		db  01h,  3fh, 071h,  02h,  02h,  02h

bdrum           db  00h,  03h, 0a7h, 0ffh,  00h
		db  00h,  02h, 0e7h, 0ffh,  00h,  00h

sdrum           db  05h,  3fh, 0f8h, 0ffh,  01h
		db  06h,  3fh, 0f8h, 0ffh,  02h,  0eh



a_ptr           dw      OFFSET arpegiator


base            LABEL   WORD                    ; offset base de cada trilha
canal1          dw      OFFSET arp_pattern
canal2          dw      OFFSET solo
canal3          dw      OFFSET arp2
canal4          dw      OFFSET basso
canal5          dw      OFFSET bassdrum
canal6          dw      OFFSET snaredrum
canal7          dw      OFFSET solo             ; chorus para o solo

finetune        LABEL   BYTE                    ; afina‡ao (usada p/ chorus)
		db      0
		db      4
		db      ?
		db      ?
		db      ?
		db      ?
		db      ?

track           LABEL   WORD                    ; offset atual da trilha
		dw      TRACKS dup (?)

notelen         LABEL   WORD                    ; dura‡ao de nota atual
		dw      TRACKS dup (?)

timer           LABEL   WORD                    ; timer para cada trilha
		dw      TRACKS dup (?)

code    ENDS

END     start