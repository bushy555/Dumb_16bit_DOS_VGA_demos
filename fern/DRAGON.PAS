program Fern_Fractal;

uses crt;

var
pk, pt, k, i, j: integer;
newx, newy, x, y : real;

begin
   RANDOMIZE;
      asm
         mov     ax, 13h
         int     10h
         mov     ax, 0a000h
         mov     es, ax
      end;
   x := 0;
   y := 0;
   repeat
      pk := random (100);
         asm
            cmp     pk, 50
            jg      @@_1
            mov	    k, 1
            jmp     @@_@
@@_1:       mov	    k, 2
            jmp     @@_@
@@_@:
          end;
      if k=1 then
         begin
            newx:=(x)+(y)+100;
            newy:=(-x)+(y)+200;
         end;
      if k=2 then
         begin
            newx:=(x)+(y)-100;
            newy:=(-x)+(y)+200;
         end;
      newx:=newx/2;
      newy:=newy/2;
      i:=(round(newx+50));
      j:=(round(newy));
         asm
            mov     dx, 320
            mov     ax, j
            mul     dx
            add     ax, i
            mov     di, ax
            mov     ax, 0002h
            stosb
         end;
      x := newx;
      y := newy;
   until (keypressed);
end.



TREE
DATA 4
0.42,0.42,-0.42,0.42,0,0.2,0.4
0.42,-0.42,0.42,0.42,0,0.2,0.4
0.1,0,0,0.1,0,0.2,0.15
0,0,0,0.5,0,0,0.05

