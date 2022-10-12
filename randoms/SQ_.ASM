
TRACKS  EQU     7                       ; numero de trilhas para musica


code    SEGMENT PARA PUBLIC 'code'
        ASSUME cs:code, ds:code, es:code, ss:code
        LOCALS
        .386

        ORG     100h                    ; Queremos um .COM, o menor possivel

start:  cld                             ; Sou eu!
        cli
	call	init
@@1:	call	vwait
	call	play
        in      al,60h                  ; Coleta scancode
        cmp     al,1                    ; 1 == <ESC>
        jne     @@1
getout: mov     ax,3                    ; Modo de v¡deo 3 (limpa a tela)
        int     10h
        call    reset                   ; Reseta Adlib -- sai com ax==0
bye:    sti                             ; Habilita interrup‡oes
        mov     ah,4ch                  ; Retorna ao DOS
        int     21h

;----------------------------------------------------------------------------;
;  Inicializa‡oes                                                            ;
;----------------------------------------------------------------------------;
init	proc	near

        mov     di,OFFSET finetune+2    ; Inicializa vari veis e tabelas
        mov     cx,6*TRACKS+2*19636     ; em zero
        repz    stosb                   ; sai com ax==cx==0

        call    reset                   ; Reseta Adlib, sai com cx==0;

        mov     fs,cx                   ; fs aponta pra tabela de vetores
        mov     ax,1124h                ; Seta int 43h para fonte 8x16
        int     10h

        mov     si,OFFSET base          ; Inicializa‡ao das trilhas
        mov     di,OFFSET track
        mov     cx,TRACKS
        repz    movsw                   ; Sai com ax==cx==0

        push    ds
        mov     di,10ch                 ; Offset para int 43h
        lds     si,DWORD PTR fs:[di]    ; ds:si aponta para o fonte 8x16

        mov     ch,4                    ; Copia fonte 8x16 pro buffer
        mov     di,OFFSET fontbuffer    ; (cl vale zero)
        push    di
        repz    movsw                   ; cx vale zero na saida

        pop     di                      ; di cont‚m offset de fontbuffer
        pop     ds                      ; ds cont‚m segmento dos dados
        push    di
        push    di                      ; Reserva para setar o fonte da VGA
        add     di,'A'*16               ; Copia a tabela de caracteres
        mov     si,OFFSET fonte
        mov     cl,23                   ; 23 caracteres redefinidos
copy:   push    cx
        xor     ax,ax                   ; Preenche os dois zeros iniciais
        stosw                           ; e o zero final da tabela de
        mov     cl,13                   ; caracteres.
        repz    movsb
        stosb
        pop     cx
        loop    copy                    ; Proximo caracter


; --- Reprograma os caracteres para suavizamento

        mov     di,OFFSET fontbuffer+0c0h*16
        mov     bp,di
        inc     ax                      ; Prepara as quatro "rampas"
        mov     bx,8000h                ; Bitmasks ax=00000001 bx=10000000
        mov     cl,32
        mov     dx,cx
@@doit: or      [di],ah                 ; Os endere‡os estao previamente
        or      [di+64],al              ; zerados. O preenchimento ‚
        or      [di+32],bh              ; feito por colunas.
        or      [di+96],bl
        inc     di
        loop    @@doit                  ; Proxima linha
        shl     ax,1                    ; Atualiza bitmasks e ponteiros
        shr     bx,1
        inc     bp
        mov     di,bp
        dec     dx
        dec     dx
        mov     cl,dl
        or      cl,cl
        jnz     @@doit                  ; Proxima coluna

        dec     ax                      ; Faz as "bandeirinhas"
        mov     cl,8
        mov     di,OFFSET fontbuffer + 0c8h*16
        mov     si,OFFSET fontbuffer + 0c8h*16+15
@@r5:   stosb
        mov     [si],al
        dec     si
        shr     al,1
        loop    @@r5

        dec     ax
        mov     cl,8
        mov     di,OFFSET fontbuffer + 0c9h*16
        mov     si,OFFSET fontbuffer + 0c9h*16+15
@@r6:   stosb
        mov     [si],al
        dec     si
        shl     al,1
        loop    @@r6                    ; sai com cx==0 e al==0

        mov     ah,11h                  ; Reprograma fonte (al==0)
        mov     bx,1000h                ; 16 bytes/caracter - bloco 0
        mov     cl,0cfh                 ; # de caracteres a reprogramar
        xor     dx,dx                   ; comecando do 0
        pop     bp                      ; Tabela do novo fonte
        int     10h

        pop     si                      ; si cont‚m offset de fontbuffer
        mov     di,OFFSET extended
        mov     cl,127                  ; 127 caracteres
@@xt:   push    cx
        mov     bl,80h
        mov     cl,8                    ; 8 colunas por caracter
@@@each: push    cx                      ; Loop para cada caracter
        mov     cl,16                   ; 16 linhas por caracter
@@col:  lodsb                           ; Loop para cada coluna
        test    al,bl
        jz      @@blank
        mov     WORD PTR [di],0110h     ; Bloco e atributo **
@@blank:inc     di                      ;
        inc     di
        loop    @@col                   ; Proxima linha
        sub     si,16                   ; Retorna ao in¡cio do caracter
        shr     bl,1                    ; Incrementa coluna
        pop     cx
        loop    @@@each                  ; Proxima coluna
        add     si,16                   ; Avan‡a um caracter
        pop     cx
        loop    @@xt

        mov     si,OFFSET extended+ '/'*16*16
        mov     cx,16*8*('z'-'/'+1)
@@each: cmp     BYTE PTR [si],10h       ; Uma rotina de AI que d  um
        jne     @@next                  ; tratamento especial nos
        xor     ax,ax                   ; caracteres ampliados.
        mov     bx,0ffdeh               ; Funciona muito bem, e sua
        mov     dx,0ffc0h               ; demonstra‡ao ‚ not vel -
        mov     bp,0004h                ; mas esta margem ‚ pequena
@@getx: mov     al,[si+bx]              ; demais para conte-la!
        add     al,0f0h
        rcl     ah,1                    ; Obs: tentar entender como
        xor     bx,dx                   ; isto funciona pode ser
        xor     dx,0fffch               ; perigoso para sua sa£de :-))
        dec     bp
        jnz     @@getx
        mov     bx,20h                  ;
        mov     al,0f9h                 ;            XXXXXX
@@again:                                ;           XX    XX
        mov     dx,ax                   ;           XX
        xor     dh,dl                   ;            XXXXXX
        mov     dl,dh                   ;                 XX
        and     dl,0ah                  ;           XX    XX
        shr     dl,1                    ;            XXXXXX
        and     dl,dh                   ;
                                        ;
        jz      @@skip                  ;             vira
        cmp     BYTE PTR [si+bx],010h   ;
        je      @@skip                  ;           /XXXXXX\
                                        ;           XX/  \XX
        mov     dh,dl                   ;           XX\
        and     dh,04h                  ;           \XXXXXX\
        and     dl,01h                  ;                \XX
        cmp     al,10h                  ;           XX\  /XX
        rcl     dl,1                    ;           \XXXXXX/
        or      dl,dh                   ;
        add     [si+bx],dl              ;      Tricky code, eh? :-)
        mov     BYTE PTR [si+bx+1],1
@@skip: cmp     al,06h
        jz      @@next                  ; Obs: O codigo ao lado pode ser
        not     al                      ; dif¡cil de entender, mas foi
        neg     bx                      ; uma grande sacada do Doctor.
        jmp     SHORT @@again           ; Meus aplausos a ele - excelente
@@next: inc     si                      ; efeito!
        inc     si
        loop    @@each


;  Patches para '1' e '4' - suavizamento acima nao os reconhece :-((
;  Espero que todas as VGAs tenham o mesmo formato para os dois caracteres.

        mov     ax,0103h
        mov     WORD PTR [extended+'4'*32*8+16*4+6],ax
        mov     WORD PTR [extended+'4'*32*8+16*4+36],ax
        mov     WORD PTR [extended+'1'*32*8+16*2+6],ax
        mov     WORD PTR [extended+'1'*32*8+16*2+36],ax

; --- Inicializa‡ao da Adlib

        mov     ax,0120h                ; Habilita bit 5 do reg 1 da Adlib
        call    addata                  ; (Waveforms)

        mov     cl,6                    ; 6 instrumentos a programar
        xor     bx,bx                   ; iniciando no canal 1
        mov     si,OFFSET instruments   ; a partir do 1o instrumento
        call    set_instr

        inc     cx                      ; Chorus para o canal 4
        mov     si,OFFSET brass
        call    set_instr

; --- Inicializa‡ao de tela

        push    0b800h                  ; es contem o segmento de video,
        pop     es                      ; modo texto

        xor     di,di                   ; Esconde o cursor
        mov     ax,di                   ; Este m‚todo economiza bytes
        stosw                           ; se comparado a desabilit -lo
init	endp
;----------------------------------------------------------------------------;
;  Loop Principal                                                            ;
;----------------------------------------------------------------------------;

mainloop:

vwait   PROC    NEAR
        mov     dx,3dah                 ; Espera o retra‡o vertical
@@vw1:  in      al,dx                   ; (o timing ‚ realizado atrav‚s da
        and     al,08h                  ; espera de retraco. Se o micro
        jnz     @@vw1                   ; for suficientemente lento para
@@vw2:  in      al,dx                   ; nao poder fazer os calculos entre
        and     al,08h                  ; dois retra‡os, haver  perda de
        jz      @@vw2                   ; sincronismo)
	ret
vwait   ENDP


; --- Mini-player para Adlib

play    PROC    NEAR
        xor     bx,bx                   ; bx indica o canal atual
        mov     cx,TRACKS
@@next: mov     ax,timer[bx]            ; Coleta o timer para o canal
        or      ax,ax                   ; Verifica se expirou
        jnz     @@next_timer

        xor     dx,dx                   ; Zera transposi‡ao
        or      bx,bx                   ; O canal 1 (bx=0) ‚ reservado
        jnz     @@no_arp3               ; para o arpejador

        mov     si,[a_ptr]              ; dl cont‚m a quantia para
        mov     dl,[si]                 ; transposi‡ao
@@no_arp3:
        push    cx
@@reset_tr:
        mov     si,track[bx]
@@new_val:
        lodsb                           ; Coleta evento da trilha
        or      al,al                   ; Verifica se ‚ nota
        jns     @@volume

        mov     ch,al                   ; Processa nota
        and     ax,000fh
        add     ax,dx                   ; Transposi‡ao do arpejador
        cmp     al,12                   ; Verifica overflow de oitava
        jb      @@skip
        sub     al,12                   ; Ajusta overflow de oitava
        add     ch,10h
@@skip: and     cx,0f000h               ; M scara para envio de valor
        shr     ch,2                    ; para Adlib
        shl     ax,1
        add     ax,OFFSET note2freq     ; Coleta frequencia da tabela
        mov     di,ax
        or      cx,[di]
        add     cl,finetune[bx]         ; Soma afina‡ao (para chorus)
@@pause_t1:
        mov     ax,notelen[bx]          ; Coleta dura‡ao da nota
@@pause_tx:
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
@@next_timer:
        dec     timer[bx]               ; Decrementa timer do canal atual
        inc     bx                      ; Incrementa canal
        inc     bx
        loop    @@next                  ; Proximo canal
        jmp     @@end                   ; Encerra (em condi‡oes normais
                                        ; seria um ret)
@@volume:
        jnz     @@no_pause
        xor     cx,cx
        jmp     SHORT @@pause_t1
@@no_pause:
        test    al,40h                  ; Flag que indica se um ctrl.
        jnz     @@ctrl
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
        jmp     SHORT @@new_val         ; Coleta novo valor da trilha
@@ctrl:
        and     al,3fh                  ; Processamento de controle
        jnz     @@no_40h
        mov     ax,base[bx]
        mov     track[bx],ax            ; Verifica terminador de trilha

        or      bx,bx                   ; Arpejador na trilha 0
        jnz     @@no_arp

        inc     WORD PTR [a_ptr]        ; Incrementa ptr p/ transposi‡ao
        mov     bx,[a_ptr]              ; Coleta ptr p/ transposi‡ao
@@new_arp:
        mov     dl,[bx]                 ; Transposi‡ao em dl
        cmp     dl,040h                 ; Verifica final de trilha
        jne     @@no_arp2
        mov     bx,OFFSET arpegiator    ; Reseta ponteiro de transposi‡ao **
        mov     [a_ptr],bx
        jmp     SHORT @@new_arp
@@no_arp2:
        xor     bx,bx
@@no_arp:
        jmp     @@reset_tr              ; Coleta novo valor da trilha
@@no_40h:
;       dec     al
;       jnz     @@no_41h                ; Pausa longa (nao utilizado)
;       lodsw
;       xor     cx,cx
;       jmp     @@pause_tx
;@@no_41h:                              ; Livre para uso...
;       dec     al
;       jnz     @@no_42h
;       jmp     @@new_val
@@no_42h:
        sub     al,0fh                  ; CUIDADO COM ESTE VALOR
        shl     al,2                    ;
        mov     BYTE PTR notelen[bx],al ; dh= 10h - numero de efeitos
        jmp     @@new_val               ; ja processados...
@@end:	ret
play    ENDP

; --- Verifica tecla pressionada


; --- Retorno ao DOS



;----------------------------------------------------------------------------;
;  Escrita na porta de registrador e dados da Adlib                          ;
;----------------------------------------------------------------------------;

addata  PROC    NEAR                    ; Envia dado (ah) p/ porta Adlib (al)
        pusha
        xchg    al,ah
        mov     dx,388h                 ; Porta de registrador da Adlib
        out     dx,al
        mov     cx,3
@@wait: in      al,dx
        loop    @@wait                  ; Delay para registrador

        inc     dx                      ; Porta de dados da Adlib
        mov     al,ah
        out     dx,al
        mov     cl,16
        dec     dx
@@wait1:in      al,dx                   ; Delay para dados
        loop    @@wait1
        popa
        ret
addata  ENDP

;----------------------------------------------------------------------------;
;  Programa instrumento na Adlib (si= offset, bx= canal)                     ;
;----------------------------------------------------------------------------;

set_instr  PROC
@@letsgo:
        push    cx
        push    bx
        mov     ah,reg_index[bx]
        mov     dl,02
@@again:mov     cx,0004
@@loop1:add     ah,20h
        lodsb
        call    addata
        loop    @@loop1

        add     ah,60h
        lodsb
        call    addata
        sub     ah,0ddh
        dec     dl
        jnz     @@again

        add     bl,0c0h
        mov     ah,bl
        lodsb
        call    addata

        pop     bx
        pop     cx
        inc     bx
        loop    @@letsgo

        ret
set_instr  ENDP

;----------------------------------------------------------------------------;
;  Reseta Adlib                                                              ;
;----------------------------------------------------------------------------;

reset   PROC    NEAR
        mov     cl,0f5h                 ; Reseta Adlib
        xor     ax,ax
@@reset:
        mov     ah,cl
        call    addata
        loop    @@reset                 ; !!IMPORTANTE!! sai com cx==0
        ret
reset   ENDP



;----------------------------------------------------------------------------;
;  Caracteres 8x16 (somente 13 bytes sao definidos, para poupar espa‡o)      ;
;  Alguns caracteres sofreram simplifica‡ao devido … rotina de suavizamento  ;
;  de angulos. Os caracteres G, J e X (que nao foram usados no texto) estao  ;
;  em coment rio. O caracter 0 foi redefinido devido a varia‡ao da forma do  ;
;  caracter entre diferentes placas de video. Caracteres como M e W ainda    ;
;  ficaram meio esquisitos.                                                  ;
;----------------------------------------------------------------------------;

fonte LABEL BYTE

 db 000h,07fh,0c0h,0c6h,0c6h,0ffh,0c6h,0c6h,0c6h,0c6h,0c0h,0c0h,080h ; A  A
 db 000h,0fch,046h,066h,066h,07eh,063h,063h,063h,06eh,040h,000h,000h ; B  B
 db 000h,000h,07eh,0c3h,0c3h,0c0h,0c0h,0c0h,0c0h,0ffh,000h,000h,000h ; C  C
 db 000h,0feh,043h,063h,063h,063h,063h,063h,063h,06eh,040h,000h,000h ; D  D
 db 000h,0feh,043h,061h,060h,07ch,060h,060h,060h,07fh,000h,000h,000h ; E  E
 db 000h,0feh,043h,061h,060h,07ch,060h,060h,060h,060h,060h,060h,040h ; F  F
db 000h,07eh,0c3h,0c3h,0c0h,0c0h,0cfh,0c3h,063h,03fh,003h,003h,001h ; G
 db 0e0h,063h,063h,063h,063h,07fh,063h,063h,063h,063h,003h,003h,001h ; H  G
 db 000h,03ch,018h,018h,018h,018h,018h,018h,018h,03ch,000h,000h,000h ; I  H
db 000h,07ch,010h,018h,018h,018h,018h,018h,018h,018h,018h,030h,020h ; J
 db 003h,0e3h,063h,063h,066h,07eh,063h,063h,063h,063h,003h,003h,001h ; K  I
 db 000h,0f0h,040h,060h,060h,060h,060h,061h,063h,0ffh,000h,000h,000h ; L  J
 db 001h,0e3h,077h,07fh,06bh,063h,063h,063h,063h,063h,060h,060h,040h ; M  K
db 080h,0c3h,0e3h,0f3h,0fbh,0dfh,0cfh,0c7h,0c3h,0c1h,080h,000h,000h ; N
 db 000h,000h,07eh,0c3h,0c3h,0c3h,0c3h,0c3h,0c3h,07eh,000h,000h,000h ; O  L
 db 000h,0feh,003h,063h,063h,063h,063h,0feh,060h,060h,060h,040h,000h ; P  M
 db 000h,07fh,0c0h,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h,07fh,006h,006h,002h ; Q  N
 db 000h,0feh,003h,063h,063h,07eh,063h,063h,063h,063h,003h,003h,001h ; R  O
 db 000h,07fh,0c0h,060h,030h,018h,00ch,006h,003h,0feh,000h,000h,000h ; S  P
 db 000h,0ffh,090h,018h,018h,018h,018h,018h,018h,018h,010h,000h,000h ; T  Q
 db 000h,0e3h,063h,063h,063h,063h,063h,063h,063h,03fh,000h,000h,000h ; U  R
 db 0e0h,063h,063h,063h,063h,063h,063h,033h,01bh,00fh,000h,000h,000h ; V  S
 db 0e0h,063h,063h,063h,063h,063h,06bh,07fh,077h,0e3h,001h,000h,000h ; W  T
db 000h,0c1h,0c3h,066h,03ch,018h,03ch,066h,0c3h,083h,000h,000h,000h ; X
 db 07ch,0c6h,0c6h,0c6h,0d6h,0d6h,0c6h,0c6h,0c6h,07ch,000h,000h,000h ; 0  U
 db 000h,0ffh,0c3h,086h,00ch,018h,030h,060h,0c1h,0c3h,0ffh,000h,000h ; Z  V
 db 0c3h,0c3h,0c3h,0c3h,0c3h,07eh,018h,018h,018h,018h,018h,018h,000h ; Y  W


note2freq       dw      16bh, 181h, 198h, 1b0h, 1cah, 1e5h
                dw      202h, 220h, 241h, 263h, 287h, 2aeh

                ;  ^--- Obs: afinamos a Adlib em C#. Nenhum motivo especial.


reg_index       db      00h, 01h, 02h, 08h, 09h, 0ah, 10h, 11h, 12h


;----------------------------------------------------------------------------;
;  Trilhas e instrumentos                                                    ;
;                                                                            ;
;  O mini-player ‚ organizado por trilhas c¡clicas que podem ser designadas  ;
;  para qualquer dos 9 canais da Adlib. O "arpejador" ‚ uma trilha especial  ;
;  em que cada nota ‚ transposta segundo valores pr‚-definidos.  Os c¢digos  ;
;  v lidos para os dados em uma trilha sao:                                  ;
;                                                                            ;
;  50h : 1/32 compasso  (note length)                                        ;
;  51h : 1/16 compasso                                                       ;
;  53h : 1/8  compasso                                                       ;
;  57h : 1/4  compasso                                                       ;
;  5fh : 1/2  compasso                                                       ;
;  6fh : 1    compasso                                                       ;
;  80h a ffh: nota (oitava no nibble superior e nota no inferior, 0==d¢)     ;
;  00h a 3fh: volume, seguido por dois bytes de volume para os operadores    ;
;  40h : Encerrador de trilha                                                ;
;                                                                            ;
;----------------------------------------------------------------------------;


arpegiator      db  0,0,5,5,10,10,5,5,40h


;               Base: C C F F Bb Bb F F  --  Pequena e repetitiva
;                                            musica de elevador
;
;                 Padrao do arpejador:
;
;                 pitch  ^
;                        |
;                  2  -  | x x         x   x x         x
;                     -  |         x                 x
;                  1  -  x     x     x   x     x   x
;                     -  |       x               x
;                  0  - -+-------+-------+-------+--------> tempo
;                        1 . . . 2 . . . 3 . . . 4 . . .
;
;
;  A musiquinha abaixo foi escrita "em hexa", e a principal preocupa‡ao
;  foi a economia de bytes - as notas sao longas, o loop ‚ curto e o
;  t¡tulo ‚ bem sugestivo :-)))


;  Muzak: "Cycle: loop cycle"
;  (just a boring Casiotone-style muzak - no room for
;   something better in this 1899 byte addy!)

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


; Measure  1___.___|___.___2___.___|___.___
;  Sdrum   ....x..x....x.......x.......x.xx
;  Bdrum   x...x...x...x...x...x...x...x...

bassdrum LABEL BYTE
db  057h,080h,040h

snaredrum LABEL BYTE
db  057h,000h,051h,090h,000h,000h,090h
db  057h,000h,05fh,090h,090h
db  051h,006h,006h,090h,000h,090h,090h,40h


; --- Programa‡ao dos instrumentos

instruments LABEL BYTE
;
;  Estes instrumentos sao simplifica‡oes de alguns que eu programei num
;  Yamaha DX-100. Infelizmente, o FM nao permite (de modo simples) obter
;  instrumentos de percussao decentes - um bom snaredrum faz falta :-((
;  Controles para modula‡ao de amplitude e pitch nao estao incluidos
;  nesta versao.
;
;
;          Waveform -------------------------+
;   Sustain/Release -------------------+     |
;      Attack/Decay -------------+     |     |
; Scale Lev/Tot Lev -------+     |     |     |     +--- Feedback/Algorithm
; AMD/PMD/EG/KSR/MF -+     |     |     |     |     |
;                    |     |     |     |     |     |
;                                                  |
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


;----------------------------------------------------------------------------;
;  Dados. Os valores nao-inicializados das tabelas nao contam no tamanho     ;
;  do .COM resultante, e por isso sao deixadas no final. Isso evita o uso    ;
;  de utilit rios que removem os dados nao-inicializados.                    ;
;----------------------------------------------------------------------------;

a_ptr           dw      OFFSET arpegiator

sm_table        db      0c2h,0c0h,0c3h,0c1h,0dbh,0c8h,037h,0c3h
                db      0c6h,0c4h,0c7h,0c5h,0c9h,0dbh,0dbh,0c5h
                db      000h,000h,000h,000h,000h,000h,0dbh

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

scroll_index    dw      ?                       ; conta cada coluna
angle           db      ?                       ; angulo para sinusbars
fontbuffer      db      16*256 dup (?)          ; espa‡o pro fonte 8x16
pal_table       db      8 *300 dup (?)          ; palette
extended        db      16*128*16 dup (?)       ; tabela estendida

code    ENDS

;----------------------------------------------------------------------------;
;  Fim do programa. Simples, nao?                                            ;
;----------------------------------------------------------------------------;

END     start

