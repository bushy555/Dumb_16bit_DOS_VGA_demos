CODE	SEGMENT PARA
	ASSUME CS:CODE, DS:code, SS:code, ES:code

org 100h
START:
	mov     ax, 0b800h
	mov     es, ax

	call	fadeout
	call	mode50
	call	fadeout

	lea	dx, bushy
	mov	bl, 07h
	call	disp

	call	fadein
	call	Delay2
	call	fadeout
	
	lea	dx, bushy2
	call	disp
	
	call	fadein
	call	Delay2
	call	fadeout

	call	mode50

	mov	bl, 01
	
mainline:
	in	al, 060h
	cmp	al, 1
	je	quit
	call	cruise
	inc	bl
	cmp	bl, 0ffh
	jne	mainline
	mov	bl, 01
	jmp	mainline


quit:
	call	fadeout
	mov     ax, 3
	int     10h

	int     20h

Delay:
	mov	cx, 0ff00h
Delay_2:
	loop Delay_2
	ret

Delay2:
	mov	cx, 20
Delay2_2:
	push	cx
	call	Delay
	pop	cx
	loop	Delay2_2	
	ret

Disp:
	push	dx
	call	retrace
	pop	dx
	mov 	si, dx
	xor	ax, ax
	mov	di, ax
	mov	cx, 4000
dispL:	lodsb
	mov	ah, bl
	stosw
	loop	dispL

	call	delay
;	call	delay

	ret


Cruise:


	lea	dx, dance1
	call	disp
	lea	dx, dance2
	call	disp
	lea	dx, dance3
	call	disp
	lea	dx, dance4
	call	disp
	lea	dx, dance3
	call	disp
	lea	dx, dance2
	call	disp

	ret



mode50:	mov     AX,0500h
	INT     10h
	MOV     AX,1200h
	MOV     BL,10h
	XOR     CX,CX
	INT     10h
	OR      CX,CX
	JZ      mode50_2
	MOV     BL,30h
	MOV     AX,1202h
	INT     10h
	MOV     AX,0007h
	OR      BH,BH
	JNZ     mode50_1
	MOV     AL,03
mode50_1:
	INT     10h
	MOV     AX,1112h
	MOV     BL,00
	INT     10h
	jmp     cruisin
mode50_2:  
	lea     dx, sorry
	mov     ah, 9
	int     21h

	int     20h
cruisin:
	mov	ax, 0100h
	mov	cx, 0800h
	int	10h
	ret


retrace:
@L1:	mov	dx, 03dah
	in	al, dx
	and	al, 08
	or	al, al
	jnz	@L1
@L2:	mov	dx, 03dah
	in	al, dx
	and	al, 08
	cmp	al, 08
	jnz	@L2
	ret

fadeout:
	mov	count1, 028h
	mov	count2, 00
	jmp 	@1
@0:	sub	count1, 1
	sbb	count2, 0
@1:	call	retrace
	mov	count3, 1
	mov	count4, 0
	jmp	@3
@2:	add	count3, 1
	adc	count4, 0
@3:	mov	al, count3
	mov	dx, 03c8h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	cmp	count4, 0
	jnz	@2
	cmp	count3, 010h
	jnz	@2
	cmp	count2, 0
	jnz	@0
	cmp	count1, 1
	jnz	@0

	ret


fadein:	mov	count1, 1
	mov	count2, 00
	jmp 	@in1
@in0:	add	count1, 1
	adc	count2, 0
@in1:	call	retrace
	mov	count3, 1
	mov	count4, 0
	jmp	@in3
@in2:	add	count3, 1
	adc	count4, 0
@in3:	mov	al, count3
	mov	dx, 03c8h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	mov	al, count1
	mov	dx, 03c9h
	out	dx, al
	cmp	count4, 0
	jnz	@in2
	cmp	count3, 010h
	jnz	@in2
	cmp	count2, 0
	jnz	@in0
	cmp	count1, 28
	jnz	@in0

	ret

;----------------------------------------------------------
count1	db	0
count2	db	0
count3	db	0
count4	db	0

sorry   db      0ah, 0dh, 'Sorry. Bushy-Mania detected no VGA card.', 0ah, 0dh, '$'
dance1 db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                   мллм                                         '
db '                                  лллллл                                        '
db '                                 оллллллн                                       '
db '                                 лллллллл                                       '
db '                                оллллллллн                                      '
db '                                оллллллллн                                      '
db '                                лллллллллл                                      '
db '                                лллллллллл                                      '
db '                                ллллллллллн                                     '
db '                                ллллллллллн                                     '
db '                                ллллллллллн                                     '
db '                                оллллллллл                 мллм                 '
db '                               мллллллллллмм             млллллн                '
db '                              ллллллллллллллллм        млллллллн                '
db '                             лллллллллллллллллллмм   млллллп пп                 '
db '                            лллллллллллллллллллллллллллллл                      '
db '                           лллллллллллллллл плллллллллллл                       '
db '                          лллл лллллллллллл   ппллллллпп                        '
db '                       ммлллл  лллллллллллл       пп                            '
db '              мм  мммллллллл   оллллллллллл                                     '
db '             лллллллллллллл     ллллллллллн                                     '
db '             плллппллллппп      ллллллллллн                                     '
db '                                лллллллллл                                      '
db '                                оллллллллл                                      '
db '                                оллллллллл                                      '
db '                                оллллллллл                                      '
db '                                олллллллллн                                     '
db '                                 лллллллллл                                     '
db '                                 ллллллллллл                                    '
db '                                 лллллллллллн                                   '
db '                                 оллллллллллл                                   '
db '                                 олллллллллллн                                  '
db '                                 оллллоллллллл                                  '
db '                                 олллл лллллллн                                 '
db '                                 оллллн ллллллл                                 '
db '                                 оллллн  ллллллн                                '
db '                                 оллллл  олллллл                                '
db '                                  ллллл   лллллл                                '
db '                                  лллллн  олллллн                               '
db '                                  оллллн   лллллн                               '
db '                                  оллллл   оллллл                               '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                            Bushymania by Bushy''95.                            '
dance2	db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                  мллм                                          '
db '                                 лллллл                                         '
db '                                оллллллн                                        '
db '                                лллллллл                                        '
db '                               оллллллллн                                       '
db '                               оллллллллн                                       '
db '                               лллллллллл                                       '
db '                               лллллллллл                                       '
db '                               ллллллллллн                                      '
db '                               ллллллллллн                                      '
db '                               ллллллллллн                                      '
db '                               оллллллллл                                       '
db '                              мллллллллллмм                                     '
db '                             ллллллллллллллллм                                  '
db '                            лллллллллллллллллллмм                               '
db '                           ллллллллллллллллллллллллмм                           '
db '              мм          лллллллллллллллл пллллллллллллмммлллм                 '
db '            мллллммм     лллл лллллллллллл   пплллллллллллллллл                 '
db '            олллллллллммлллл  лллллллллллл       пппллллппплллп                 '
db '             пллплллллллллл   оллллллллллл                                      '
db '                  пллллллл     ллллллллллн                                      '
db '                    ппллп      ллллллллллн                                      '
db '                               лллллллллл                                       '
db '                               оллллллллл                                       '
db '                               оллллллллл                                       '
db '                               оллллллллл                                       '
db '                               олллллллллн                                      '
db '                                лллллллллл                                      '
db '                                ллллллллллл                                     '
db '                                лллллллллллл                                    '
db '                                олллллллллллн                                   '
db '                                олллллллллллн                                   '
db '                                оллллнллллллл                                   '
db '                                оллллнолллллл                                   '
db '                                оллллл ллллллн                                  '
db '                                оллллл олллллн                                  '
db '                                оллллл  лллллн                                  '
db '                                 ллллл  лллллл                                  '
db '                                 лллллн оллллл                                  '
db '                                 оллллн  лллллн                                 '
db '                                 оллллн  лллллн                                 '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                            Bushymania by Bushy''95.                            '
dance3 db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                   мллм                                         '
db '                                  лллллл                                        '
db '                                 оллллллн                                       '
db '                                 лллллллл                                       '
db '                                оллллллллн                                      '
db '                                оллллллллн                                      '
db '                                лллллллллл                                      '
db '                                лллллллллл                                      '
db '                                ллллллллллн                                     '
db '                                ллллллллллн                                     '
db '                                ллллллллллн                                     '
db '                                оллллллллл                                      '
db '                              мммлллллллллммм                                   '
db '             мм            ммллллллллллллллллл                                  '
db '           мллллммм      мллллллллллллллллллллн                                 '
db '           олллллллллммлллллллллллллллллллллллл                                 '
db '            пллпллллллллллллпплллллллллллллолллл                                '
db '                 пллллллллп    лллллллллллл лллллмм                             '
db '                   ппллпп      лллллллллллл  лллллллллмммлллм                   '
db '                               оллллллллллл   ллллллллллллллл                   '
db '                                ллллллллллн    пллллллппплллп                   '
db '                                ллллллллллн                                     '
db '                                лллллллллл                                      '
db '                                оллллллллн                                      '
db '                                оллллллллн                                      '
db '                                оллллллллн                                      '
db '                                оллллллллн                                      '
db '                                 ллллллллл                                      '
db '                                 лллллллллл                                     '
db '                                 ллллллллллл                                    '
db '                                 лллллллллллн                                   '
db '                                 лллллллллллн                                   '
db '                                олллллолллллл                                   '
db '                                оллллл лллллл                                   '
db '                                оллллл оллллл                                   '
db '                                оллллл олллллн                                  '
db '                                оллллл  лллллн                                  '
db '                                оллллл  лллллн                                  '
db '                                олллллн олллл                                   '
db '                                 лллллн олллл                                   '
db '                                 лллллн олллл                                   '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                            Bushymania by Bushy''95.                            '
dance4 db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                      мллм                                      '
db '                                     лллллл                                     '
db '                                    оллллллн                                    '
db '                                    лллллллл                                    '
db '                                   оллллллллн                                   '
db '                                   оллллллллн                                   '
db '                                   лллллллллл                                   '
db '                                   лллллллллл                                   '
db '                                   ллллллллллн                                  '
db '                                   ллллллллллн                                  '
db '                мм                 ллллллллллн                                  '
db '              мллллммм             оллллллллл                                   '
db '              олллллллллмм       мммлллллллллммм                                '
db '               пллплллллллллллллллллллллллллллллл                               '
db '                    пллллллллллллллллллллллллллллн                              '
db '                      пплллллллллллллллллллллллллл                              '
db '                             пппплллллллллллллоллл                              '
db '                                  ллллллллллллолллн                             '
db '                                  лллллллллллл лллл                             '
db '                                  оллллллллллл ллллм                            '
db '                                   ллллллллллн олллллллмммлллм                  '
db '                                   ллллллллллн  лллллллллллллл                  '
db '                                   лллллллллл    ппллллппплллп                  '
db '                                   оллллллллн                                   '
db '                                   оллллллллн                                   '
db '                                   оллллллллн                                   '
db '                                   оллллллллн                                   '
db '                                   оллллллллн                                   '
db '                                   лллллллллл                                   '
db '                                  оллллллллллн                                  '
db '                                  лллллллллллл                                  '
db '                                  лллллллллллл                                  '
db '                                 олллллнлллллл                                  '
db '                                 олллллнлллллл                                  '
db '                                 оллллл оллллл                                  '
db '                                 лллллн олллллн                                 '
db '                                 ллллл   лллллн                                 '
db '                                 ллллн   лллллн                                 '
db '                                олллл    олллл                                  '
db '                                олллл    олллл                                  '
db '                                ллллн     лллл                                  '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                            Bushymania by Bushy''95.                             '
Bushy db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '               лллллллл                                                         '
db '               ллллллллл                                                        '
db '              ллл    ллл                                                        '
db '              ллл     ллл                                                       '
db '             ллл      ллл                                                       '
db '             ллл       ллл                                                      '
db '            ллл       ллл                                                       '
db '            ллл      ллл                                                        '
db '           ллл     ллл                                                          '
db '           ллл    ллл                                                           '
db '          ллл   ллл                                                             '
db '          лллллллл                                                              '
db '         ллл    ллл                                                             '
db '         ллл     ллл                                                            '
db '        ллл      ллл                                                            '
db '        ллл        ллл      лл    лл        ллллл       лл    лл     лл      лл '
db '       ллл         ллл     лл    лл       лл   лл      лл    лл      лл    лл   '
db '       ллл         ллл     лл    лл      лл     лл     лл    лл       лл  лл    '  
db '      ллл        ллл      лл    лл       лл           лл    лл        лллл      '
db '      ллл      ллл        лл    лл        ллллл       лллллллл         лл       '
db '     ллл     ллл         лл    лл            лл      лл    лл         лл        '
db '     ллл    ллл          лл    лл      лл     лл     лл    лл         лл        '
db '    ллллллллл           лл    лл       лл   лл      лл    лл         лл         '
db '    лллллллл             лллллл         ллллл       лл    лл         лл         '   
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '     ллллл     ллллл     лллллл   ллллл     лллллл  лл     лл  лллллллл   ллллл '
db '    лл   лл   лл   лл   лл       лл   лл   лл       ллл    лл     лл     лл   лл'
db '   лл    лл  лл    лл  лл      лл         лл       лллл   лл     лл    лл       '
db '   лл   лл   лл   лл   лл       лл        лл       лл лл  лл     лл     лл      '
db '  лл  лл    лл  лл    ллллл     ллллл    ллллл    лл  лл лл     лл      ллллл   '
db '  лл лл     лл лл     лл            лл   лл       лл   лллл     лл          лл  '
db ' лллл      ллллл     лл             лл  лл       лл    ллл     лл           лл  '
db ' лл        лл  лл    лл       лл   лл   лл       лл     лл     лл     лл   лл   ' 
db 'лл        лл   лл    лллллл   ллллл     лллллл  лл     лл     лл      ллллл     '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
Bushy2 db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '          лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл          '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '       ллллл                                                                    '
db '       лллллл                                                                   '
db '       лл  ллл                                                                  '
db '      лл   ллл                                                                  '
db '      лл    ллл                                                                 '
db '      лл     ллл                                                                '
db '     лл     ллл                                                                 '
db '     лл    ллл                                                                  '
db '     лл   ллл                                                                   '
db '    лл  ллл                                                                     '
db '    лл ллл                                                                      '
db '    ллллл                                                                       '
db '   лл  ллл                                                                      '
db '   лл   ллл                                                                     '
db '   лл    ллл                                                                    '
db '  лл      ллл  лл  лл   лллл   лл  лл лл  лл лл     лл   лл   лл    лл лл   лл  '
db '  лл       ллл лл  лл  лл  лл  лл  лл лл  лл ллл   ллл  лллл  лл    лл лл  лллл '
db '  лл       ллл лл  лл лл    лл лл  лл  лллл  лллл лллл лл  лл ллл   лл лл лл  лл'
db ' лл      ллл  лл  лл  лл      лл  лл   лл   лл ллл лл лл  лл лллл  лл лл лл  лл '
db ' лл    ллл    лл  лл   лллл   лллллл   лл   лл  л  лл лллллл лл лл лл лл лллллл '
db ' лл   ллл     лл  лл      лл  лл  лл   лл   лл     лл лл  лл лл  лллл лл лл  лл '
db 'лл  ллл      лл  лл лл    лл лл  лл   лл   лл     лл лл  лл лл   ллл лл лл  лл  '
db 'лллллл       лл  лл  лл  лл  лл  лл   лл   лл     лл лл  лл лл    лл лл лл  лл  '
db 'ллллл         лллл    лллл   лл  лл   лл   лл     лл лл  лл лл    лл лл лл  лл  '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '          лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл          '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '
db '                                                                                '

CODE	ENDS
	END	START
