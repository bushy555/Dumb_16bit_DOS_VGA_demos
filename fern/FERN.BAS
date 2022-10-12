RANDOMIZE
DIM a(4), b(4), c(4), d(4), e(4), f(4), p(4)
DATA 4
DATA .86,.03,-.03,.86,0,1.5,.83
DATA .2,-.25,.21,.23,0,1.5,.08
DATA -.15,.27,.25,.26,0,.45,.08
DATA 0,0,0,.17,0,0,.04
READ m
LET pt = 0
FOR j = 1 TO m
        READ a(j), b(j), c(j), d(j), e(j), f(j), pk
        LET pt = pt + pk
        LET p(j) = pt
NEXT j

SCREEN 13
LET x = 0
LET y = 0
REM ;FOR n = 1 TO 25000
10      pk = RND(4)
        IF pk <= p(1) THEN k = 1 ELSE IF pk <= p(2) THEN k = 2 ELSE IF pk <= p(3) THEN k = 3 ELSE k = 4

        
        LET newx = a(k) * x + b(k) * y + e(k)
        LET newx = c(k) * x + d(k) * y + f(k)
        COLOR 10
        PSET (newx, newy)
        LET x = newx
        LET y = newy
GOTO 10

END



