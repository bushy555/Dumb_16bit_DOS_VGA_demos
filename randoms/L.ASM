

;********* File: ADLIB.COM *************
;
    code     SEGMENT
             ASSUME CS:code,  DS:code
             ORG 100h
             .386
  
    strt:

db 033h,008h,001h,000h,000h,000h,040h,000h,0E0h,0B1h,080h,03Eh,000h
db 00Ch,018h,024h,030h,03Bh,046h,050h,059h,062h,069h,070h,075h,079h,07Ch,07Eh,07Fh
db 07Eh,07Ch,079h,075h,070h,069h,062h,059h,050h,046h,03Bh,030h,024h,018h,00Ch,000h
db 0F4h,0E8h,0DCh,0D0h,0C5h,0BAh,0B0h,0A7h,09Eh,097h,090h,08Bh,087h,084h,082h,081h
db 082h,084h,087h,08Bh,090h,097h,09Eh,0A7h,0B0h,0BAh,0C5h,0D0h,0DCh,0E8h,0F4h,000h
db 003h,006h,009h,00Ch,00Fh,012h,015h,018h,01Bh,01Eh,021h,024h,027h,02Ah,02Dh,030h
db 033h,036h,039h,03Bh,03Eh,041h,043h,046h,020h,021h,022h,028h,029h,02Ah,030h,031h
db 032h,06Bh,021h,081h,021h,098h,021h,0B0h,021h,0CAh,021h,0E5h,021h,002h,022h,020h
db 022h,041h,022h,063h,022h,087h,022h,064h,023h,000h,000h,000h,000h,000h,00Fh,023h
db 000h,010h,01Eh,030h,000h,020h,02Dh,037h,000h,03Ch,03Dh,03Eh,004h,034h,024h,034h
db 014h,034h,024h,034h,001h,003h,023h,013h,023h,044h,044h,044h,044h,008h,002h,012h
db 044h,044h,033h,033h,044h,044h,004h,001h,044h,033h,044h,022h,044h,033h,044h,002h
db 0ECh,006h,04Eh,007h,02Dh,007h,043h,007h,038h,007h,038h,007h,022h,007h,022h,007h
db 043h,007h,041h,0C2h,006h,000h,023h,0F2h,0F0h,0F0h,001h,000h,004h,091h,040h,087h
db 080h,0F3h,06Fh,023h,003h,001h,001h,002h,0E1h,021h,011h,080h,011h,013h,022h,022h
db 000h,000h,00Ch,061h,021h,01Bh,000h,062h,084h,056h,055h,000h,000h,00Eh,091h,040h
db 087h,088h,0F3h,06Fh,023h,003h,001h,001h,002h,079h,007h,07Ah,007h,08Bh,007h,08Ch
db 007h,09Dh,007h,0B0h,007h,0C1h,007h,0C1h,007h,0D9h,007h,0D9h,007h,0F2h,007h,0F2h
db 007h,006h,008h,006h,008h,01Ah,008h,01Ah,008h,081h,057h,050h,050h,055h,057h,050h
db 055h,057h,050h,055h,057h,050h,055h,057h,050h,055h,000h,081h,050h,055h,057h,050h
db 055h,057h,050h,055h,057h,050h,055h,057h,050h,055h,057h,050h,000h,0C0h,050h,084h
db 030h,020h,030h,020h,02Ah,01Ah,02Ah,01Ah,030h,020h,030h,020h,02Ah,01Ah,02Ah,01Ah
db 030h,020h,030h,020h,02Ah,01Ah,02Ah,01Ah,025h,015h,025h,015h,028h,018h,02Ah,01Ah
db 000h,0A0h,050h,040h,0C0h,040h,088h,040h,040h,03Ah,042h,090h,045h,088h,040h,042h
db 040h,047h,090h,04Ah,088h,045h,098h,040h,000h,0A0h,050h,030h,0C0h,047h,088h,047h
db 043h,042h,045h,047h,045h,048h,047h,047h,050h,052h,084h,050h,04Ah,088h,050h,098h
db 045h,000h,0C0h,020h,0A0h,010h,010h,090h,010h,02Ah,025h,088h,028h,02Ah,090h,010h
db 02Ah,025h,088h,028h,02Ah,000h,0C0h,020h,0A0h,020h,020h,090h,020h,01Ah,015h,088h
db 018h,01Ah,090h,020h,01Ah,015h,088h,018h,01Ah,000h,0C0h,00Ch,0FEh,050h,090h,00Ch
db 081h,04Ah,050h,084h,052h,055h,086h,04Ah,081h,050h,04Ah,086h,050h,082h,055h,098h
db 045h,000h,0FCh,01Eh,019h

        DB      "     BUSHY HERE... ROCKING THE COMMUNITY ONCE" ;00835
	DB	" AGAIN...                                    "	;00862
	DB	"                                             "	;0088F
	DB	"                                             "	;008BC
	DB	"                                             "	;008E9
	DB	"                                             "	;00916
	DB	"                                             "	;00943
	DB	"                                             "	;00970
	DB	"                                             "	;0099D
	DB	"                                             "	;009CA
	DB	"                                             "	;009F7
	DB	"                                             "	;00A24
	DB	"                                             "	;00A51
	DB	"                                             "	;00A7E
	DB	"                                             "	;00AAB
	DB	"                               "	;00AD8
        DB      0Dh, 0Ah, 0Dh, 0Ah, 0Dh, 0Ah, "$", 0FCh, 00h

    code     ENDS
             END  strt
   
