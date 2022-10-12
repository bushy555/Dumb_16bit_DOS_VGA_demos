program chaos;

uses crt, graph;

var
a: array [1..4] of real;
b: array [1..4] of real;
c: array [1..4] of real;
d: array [1..4] of real;
e: array [1..4] of real;
f: array [1..4] of real;
p: array [1..4] of real;
pk, pt, k: integer;
newx, newy, x, y: real;
graphdriver, graphmode: integer;

begin
a[1] := 0.86;
b[1] := 0.03;
c[1] := -0.03;
d[1] := 0.86;
e[1] := 0;
f[1] := 1.5;
p[1] := 0.83;

a[2] := 0.2;
b[2] := -0.25;
c[2] := 0.21;
d[2] := 0.23;
e[2] :=  0;
f[2] := 1.5;
p[2] := 0.91;

a[3] := -0.15;
b[3] := 0.27;
c[3] := 0.25;
d[3] := 0.26;
e[3] :=  0;
f[3] := 0.45;
p[3] :=  0.99;

a[4] :=  0;
b[4] :=  0;
c[4] :=  0;
d[4] := 0.17;
e[4] :=  0;
f[4] :=  0;
p[4] :=  1.03;


     RANDOMIZE;

    graphdriver := detect;
    detectgraph (graphdriver, graphmode);
    initgraph(graphdriver, graphmode, '');

{FERN.BAS data...
DATA 4
DATA .86,.03,-.03,.86,0,1.5,.83
DATA .2,-.25,.21,.23,0,1.5,.08
DATA -.15,.27,.25,.26,0,.45,.08
DATA 0,0,0,.17,0,0,.04

Sierpinksi Triangle data
DATA 4
0.5,0,0,0.5,0.5,0.5,0.34
0.5,0,0,0.5,1,0,0.33
0.5,0,0,0.5,0,0,0.33


TREE
DATA 4
0.42,0.42,-0.42,0.42,0,0.2,0.4
0.42,-0.42,0.42,0.42,0,0.2,0.4
0.1,0,0,0.1,0,0.2,0.15
0,0,0,0.5,0,0,0.05

DRAGON
DATA2
0.5,0.5,-0.5,0.5,0.125,0.625,0.5
0.5,0.5,-0.5,0.5, -0.125,0.375,0.5



READ m}
{pt := 0
FOR j = 1 TO m
        READ a(j), b(j), c(j), d(j), e(j), f(j), pk
        LET pt = pt + pk
        LET p(j) = pt
NEXT j}


x := 0;
y := 0;


 repeat
    pk := random (103);


        IF pk <= 83 THEN k := 1
        ELSE
           IF pk <= 91 THEN k := 2
           ELSE
              IF pk <= 99 THEN k := 3
              ELSE
                  k := 4;


{        IF pk <= p[1] THEN k := 1
        ELSE
           IF pk <= p[2] THEN k := 2
           ELSE
              IF pk <= p[3] THEN k := 3
              ELSE
                  k := 4;}

        newx := ((a[k] * x) + (b[k] * y) + e[k]);
        newy := ((c[k] * x) + (d[k] * y) + f[k]);
        Putpixel ((320-round(newx*80)), (480-round(newy*45)), 10);
        x := newx;
        y := newy;

      until (keypressed);

end.