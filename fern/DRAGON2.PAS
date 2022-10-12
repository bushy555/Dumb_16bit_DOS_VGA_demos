program Fern_Fractal;

uses crt, graph;

var
pk, pt, k, i, j: integer;
newx, newy, x, y : real;
graphdriver, graphmode: integer;

begin
   RANDOMIZE;
   graphdriver := detect;
   detectgraph (graphdriver, graphmode);
   initgraph(graphdriver, graphmode, '');
   x := 0;
   y := 0;
   repeat
      pk := random (100);
         asm
            cmp    pk, 50
            jg     @@_1
            mov    k, 1
            jmp    @@_@
@@_1:       mov    k, 2
            jmp    @@_@
@@_@:
        end;

        if k=1 then
           begin
              newx:=(50*x)+(50*y)+12.5;
              newy:=(-50*x)+(50*y)+62.5;
           end;
        if k=2 then
           begin
              newx:=(50*x)+(50*y)+-12.5;
              newy:=(-50*x)+(50*y)+37.5;
           end;
        newx:=newx/100;
        newy:=newy/100;
        i:=(round(newx*640));
        j:=(round(newy*480));
        putpixel (i,j,10);
        x := newx;
        y := newy;
        until (keypressed);
end.





{
Sierpinksi Triangle data
DATA 4

TREE
DATA 4
0.42,0.42,-0.42,0.42,0,0.2,0.4
0.42,-0.42,0.42,0.42,0,0.2,0.4
0.1,0,0,0.1,0,0.2,0.15
0,0,0,0.5,0,0,0.05

