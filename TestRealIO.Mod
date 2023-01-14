MODULE TestRealIO;
  IMPORT SYSTEM, Fonts, Texts, Texts1, Oberon, Reals, Limits;

  CONST
    pi = 3.14159265358979;
    e = 2.71828182846;
 
  VAR 
    W: Texts.Writer;
    scan: PROCEDURE(VAR S: Texts.Scanner);

  PROCEDURE SwapScan*;
  BEGIN
    IF scan = Texts.Scan THEN 
      scan := Texts1.Scan;
      Texts.WriteString(W, "-- Texts1.Scan active --")
    ELSE 
      scan := Texts.Scan;
      Texts.WriteString(W, "-- Texts.Scan active --")
    END; 
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END SwapScan;

  PROCEDURE Do*;
    VAR x: REAL;  n, k: INTEGER; 
      beg, end, time: INTEGER;
      T: Texts.Text;  S: Texts.Scanner;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); 
    scan(S);
    IF (S.class = Texts.Char) & ( (S.c = "@") OR (S.c= "^") ) THEN
      Oberon.GetSelection(T, beg, end, time);
      IF time >= 0 THEN Texts.OpenScanner(S, T, beg)
      ELSE Texts.WriteString(W, "no selection"); Texts.WriteLn(W)
      END
    ELSE
      T := Oberon.Par.text;  beg := Oberon.Par.pos;
      Texts.OpenScanner(S, T, beg)
    END;
    scan(S);
    IF S.class = Texts.Real THEN x := S.x;  scan(S);
      IF S.class = Texts.Int THEN n := S.i;  scan(S); 
        IF S.class = Texts.Int THEN k := S.i;
          Texts.WriteString(W, "  Texts1.WriteRealHex:"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
          Texts.WriteString(W, "     Texts.WriteReal:"); Texts.WriteReal(W, x, n); Texts.WriteLn(W);
          Texts.WriteString(W, "    Texts1.WriteReal:"); Texts1.WriteReal(W, x, n); Texts.WriteLn(W);
          Texts.WriteString(W, "  Texts.WriteRealFix:"); Texts.WriteRealFix(W, x, n, k); Texts.WriteLn(W); 
          Texts.WriteString(W, " Texts1.WriteRealFix:"); Texts1.WriteRealFix(W, x, n, k); Texts.WriteLn(W)
        ELSE Texts.WriteString(W, "parameter error"); Texts.WriteLn(W) 
        END       
      ELSE Texts.WriteString(W, "parameter error"); Texts.WriteLn(W)
      END
    ELSE Texts.WriteString(W, "parameter error"); Texts.WriteLn(W)
    END;
    Texts.WriteLn(W);  Texts.Append(Oberon.Log, W.buf)
  END Do;

  PROCEDURE WriteReal*;
    VAR x: REAL;  n: INTEGER;
  BEGIN
    x := 1554.70E5; 
    Texts.SetFont(W, Fonts.This("Courier10.Fnt"));
    FOR n := 0 TO 15 DO
      Texts.WriteInt(W, n, 2);  Texts.WriteReal(W, x, n);  Texts1.WriteReal(W, x, n);
      Texts.WriteLn(W)
    END;
    Texts.WriteLn(W);  Texts.Append(Oberon.Log, W.buf)
  END WriteReal;

  PROCEDURE DoInt*;
    VAR x: REAL;  k: INTEGER; 
      beg, end, time: INTEGER;
      T: Texts.Text;  S: Texts.Scanner;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); 
    scan(S);
    IF S.class = Texts.Char THEN
      IF (S.c = "@") OR (S.c= "^") THEN
        Oberon.GetSelection(T, beg, end, time);
        IF time >= 0 THEN Texts.OpenScanner(S, T, beg);  scan(S);
          IF S.class = Texts.Int THEN x := Reals.Real(S.i);  scan(S);
            IF S.class = Texts.Int THEN k := S.i;
              Texts.WriteString (W, " Texts1.WriteRealHex:"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
              Texts.WriteString(W, "     Texts.WriteReal:"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W);
              Texts.WriteString(W, "    Texts1.WriteReal:"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
              Texts.WriteString(W, "  Texts.WriteRealFix:"); Texts.WriteRealFix(W, x, 14, k); Texts.WriteLn(W);
              Texts.WriteString(W, " Texts1.WriteRealFix:"); Texts1.WriteRealFix(W, x, 14, k); Texts.WriteLn(W);
            ELSE Texts.WriteString(W, "parameter error"); Texts.WriteLn(W)
            END
          ELSE Texts.WriteString(W, "parameter error"); Texts.WriteLn(W)
          END
        ELSE Texts.WriteString(W, "no selection"); Texts.WriteLn(W);
        END
      END
    END;
    Texts.WriteLn(W);  Texts.Append(Oberon.Log, W.buf)
  END DoInt;

  PROCEDURE DivByZero*;
    VAR x, y: REAL; 
  BEGIN
    x := 9.0;  y := 0.0;
    x := x / y;
    Texts.WriteString (W, "x := 9.0;  y := 0.0;  x := x / y;"); Texts.WriteLn(W);
    Texts.WriteString (W, "      Texts1.WriteRealHex(W, x):"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
    Texts.WriteString (W, "      Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W); 
    Texts.WriteString (W, "     Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
    Texts.WriteString (W, " Texts.WriteRealFix(W, x, 0, 6):"); Texts.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
    Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 6):"); Texts1.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W); 
    Texts.WriteLn(W);
    x := -9.0;  y := 0.0;
    x := x / y;
    Texts.WriteString (W, "x := -9.0;  y := 0.0;  x := x / y;"); Texts.WriteLn(W);
    Texts.WriteString (W, "      Texts1.WriteRealHex(W, x):"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
    Texts.WriteString (W, "      Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W); 
    Texts.WriteString (W, "     Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
    Texts.WriteString (W, " Texts.WriteRealFix(W, x, 0, 6):"); Texts.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
    Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 6):"); Texts1.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W); 
    Texts.WriteLn(W);
    x := 0.0;  y := 0.0;
    x := x / y; 
    Texts.WriteString (W, "x := 0.0;  y := 0.0;  x := x / y;"); Texts.WriteLn(W);
    Texts.WriteString (W, "      Texts1.WriteRealHex(W, x):"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
    Texts.WriteString (W, "      Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W); 
    Texts.WriteString (W, "     Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
    Texts.WriteString (W, " Texts.WriteRealFix(W, x, 0, 6):"); Texts.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
    Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 6):"); Texts1.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W); 
    Texts.WriteLn(W);
    Texts.Append(Oberon.Log, W.buf)
  END DivByZero;

  PROCEDURE Limits1*;
    VAR i, xi: INTEGER;  x: REAL;
  BEGIN
    x := 3.402823E+38;  Texts.WriteString (W, "x := 3.402823E+38;"); Texts.WriteLn(W); Texts.WriteLn(W);
    xi := Reals.Int(x);
    i := 0;
    WHILE i < 6 DO
      Texts.WriteString (W, "      Texts1.WriteRealHex(W, x):"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
      Texts.WriteString (W, "      Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W); 
      Texts.WriteString (W, "     Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString (W, " Texts.WriteRealFix(W, x, 0, 6):"); Texts.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
      Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 6):"); Texts1.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
      xi := Reals.Int(x);
      INC(xi);  INC(i);
      x := Reals.Real(xi);
      Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END Limits1;

  PROCEDURE Limits2*;
    VAR i, xi: INTEGER;  x: REAL;
  BEGIN
    x := -3.402823E+38;  Texts.WriteString (W, "x := -3.402823E+38;"); Texts.WriteLn(W); Texts.WriteLn(W);
    xi := Reals.Int(x);
    i := 0;
    WHILE i < 6 DO
      Texts.WriteString (W, "      Texts1.WriteRealHex(W, x):"); Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
      Texts.WriteString (W, "      Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W); 
      Texts.WriteString (W, "     Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString (W, " Texts.WriteRealFix(W, x, 0, 6):"); Texts.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
      Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 6):"); Texts1.WriteRealFix(W, x, 0, 6); Texts.WriteLn(W);
      xi := Reals.Int(x);
      INC(xi);  INC(i);
      x := Reals.Real(xi);
      Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END Limits2;

  PROCEDURE Limits3*;
    VAR i, xi: INTEGER;  x, x0: REAL;
  BEGIN
    Texts.WriteString (W, "Test of underflow and subnormals"); Texts.WriteLn(W);
    Texts.WriteString (W, "2.0E-38 = "); Texts1.WriteRealHex(W, 2.0E-38); Texts.WriteLn(W);
    Texts.WriteString (W, "0.2E-37 = "); Texts1.WriteRealHex(W, 0.2E-37); Texts.WriteLn(W);
    Texts.WriteString (W,    "0.1999999999999999999999E-37 = "); 
    Texts1.WriteRealHex(W, 0.1999999999999999999999E-37); Texts.WriteLn(W);
    Texts.WriteString (W, "0.2E-37 / 2.0 = ");  Texts1.WriteRealHex(W, 0.2E-37 / 2.0); Texts.WriteLn(W);
    x0 := 0.2E-37;  x := 10.0 * x0;
    Texts.WriteString (W, "10.0 * "); Texts1.WriteRealHex(W, x0); Texts.WriteString (W, " = "); 
    Texts1.WriteRealHex(W, x); Texts.WriteLn(W);
    FOR i := 1 TO 10 DO
      x := x - x0;
      Texts.WriteInt(W, i, 2); Texts.WriteString (W, ". "); 
      Texts1.WriteRealHex(W, x); Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END Limits3;


  PROCEDURE WriteNumbers*;
    VAR i: INTEGER;  x: REAL;
  BEGIN
    x := 16777212.0;
    i := 0;
    WHILE i < 10 DO
      Texts.WriteString (W, "Texts1.WriteRealHex(W, x):");  Texts1.WriteRealHex(W, x);  Texts.WriteLn(W);
      Texts.WriteString (W, "Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString (W, "Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString(W, "Texts.WriteRealFix(W, x, 0, 7):"); Texts.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W); 
      Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 7):"); Texts1.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W);
      x := x + 1.0;
      INC(i);
      Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END WriteNumbers;

  PROCEDURE WriteNumbers1*;
    VAR i: INTEGER;  x: REAL;
  BEGIN  
    x := -16777212.0;
    i := 0;
    WHILE i < 10 DO
      Texts.WriteString (W, "Texts1.WriteRealHex(W, x):");  Texts1.WriteRealHex(W, x);  Texts.WriteLn(W);
      Texts.WriteString (W, "Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString (W, "Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString(W, "Texts.WriteRealFix(W, x, 0, 7):"); Texts.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W); 
      Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 7):"); Texts1.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W);
      x := x - 1.0;
      INC(i);
      Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END WriteNumbers1;

  PROCEDURE WriteNumbers2*;
    VAR i, xi: INTEGER;  x: REAL;
  BEGIN  
    x := 1.232596E-32;
    i := 0;
    WHILE i < 10 DO
      Texts.WriteString (W, "Texts1.WriteRealHex(W, x):");  Texts1.WriteRealHex(W, x);  Texts.WriteLn(W);
      Texts.WriteString (W, "Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString (W, "Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString(W, "Texts.WriteRealFix(W, x, 0, 7):"); Texts.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W); 
      Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 7):"); Texts1.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W);
      xi := Reals.Int(x);
      xi := xi - 1;
      x := Reals.Real(xi);
      INC(i);
      Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END WriteNumbers2;

  PROCEDURE WriteNumbers3*;
    VAR i, xi: INTEGER;  x: REAL;
  BEGIN  
    x := -1.232595E-32;
    i := 0;
    WHILE i < 10 DO
      Texts.WriteString (W, "Texts1.WriteRealHex(W, x):");  Texts1.WriteRealHex(W, x);  Texts.WriteLn(W);
      Texts.WriteString (W, "Texts.WriteReal(W, x, 14):"); Texts.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString (W, "Texts1.WriteReal(W, x, 14):"); Texts1.WriteReal(W, x, 14); Texts.WriteLn(W);
      Texts.WriteString(W, "Texts.WriteRealFix(W, x, 0, 7):"); Texts.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W); 
      Texts.WriteString (W, "Texts1.WriteRealFix(W, x, 0, 7):"); Texts1.WriteRealFix(W, x, 0, 7); Texts.WriteLn(W);
      xi := Reals.Int(x);
      xi := xi + 1;
      x := Reals.Real(xi);
      INC(i);
      Texts.WriteLn(W)
    END;
    Texts.Append(Oberon.Log, W.buf)
  END WriteNumbers3;

  PROCEDURE WriteTable*;
    CONST maxFLT = 16777215;  (* largest integer that FLT(i) can handle without overflow *)
    VAR i: INTEGER;  x: REAL;
  BEGIN Texts.SetFont(W, Fonts.This("Courier10.Fnt"));
    i := 0;  x := 0.0001;
    Texts.WriteRealFix(W, FLT(maxFLT), 17, 6); 
    Texts.WriteRealFix(W, FLT(maxFLT + 1), 17, 6); Texts.WriteLn(W);
    WHILE i < 28 DO
      Texts.WriteRealFix(W, x, 17, 6);
      x := 2.45 * x;
      Texts.WriteRealFix(W, x, 17, 6);
      x := x + 0.0001;
      Texts.WriteLn(W);
      INC(i);
      IF i MOD 2 = 0 THEN x := -x END
    END;
    Texts.WriteRealFix(W, 0.0/0.0, 17, 6);
    Texts.WriteRealFix(W, pi, 17, 6);  Texts.WriteLn(W);    
    Texts.WriteRealFix(W, Reals.Real(7F800000H), 17, 6); (* +INF *)
    Texts.WriteRealFix(W, -1234.56789, 17, 6); Texts.WriteLn(W);  
    Texts.WriteRealFix(W, Reals.Real(0FF800000H), 17, 6); (* -INF *)
    Texts.WriteRealFix(W, 12.3456789, 17, 6); Texts.WriteLn(W);  
    Texts.WriteRealFix(W, Reals.Real(7F800001H), 17, 6); (* NaN *)
    Texts.WriteRealFix(W, -0.00123456789, 17, 6); Texts.WriteLn(W);  
    Texts.WriteRealFix(W, Reals.Real(7FFFFFFFH), 17, 6); (* NaN *)
    Texts.WriteRealFix(W, -123456.789, 17, 6); Texts.WriteLn(W);  
    Texts.WriteRealFix(W, 0.1 + 0.2, 17, 6);
    Texts.WriteRealFix(W, 2.0*2.03 + 2.0*3.5, 17, 6); Texts.WriteLn(W);
    Texts.WriteLn(W);
    Texts.Append(Oberon.Log, W.buf)
  END WriteTable;

  PROCEDURE WriteTable1*;
    CONST maxFLT = 16777215;  (* largest integer that FLT(i) can handle without overflow *)
    VAR i: INTEGER;  x: REAL;
  BEGIN Texts.SetFont(W, Fonts.This("Courier10.Fnt"));
    i := 0;  x := 0.0001;
    Texts1.WriteRealFix(W, FLT(Limits.maxFLT), 17, 6); 
    Texts1.WriteRealFix(W, FLT(Limits.maxFLT + 1), 17, 6); Texts.WriteLn(W);
    WHILE i < 28 DO
      Texts1.WriteRealFix(W, x, 17, 6);
      x := 2.45 * x;
      Texts1.WriteRealFix(W, x, 17, 6);
      x := x + 0.0001;
      Texts.WriteLn(W);
      INC(i);
      IF i MOD 2 = 0 THEN x := -x END
    END;
    Texts1.WriteRealFix(W, 0.0/0.0, 17, 6);
    Texts1.WriteRealFix(W, pi, 17, 6);  Texts.WriteLn(W);   
    Texts1.WriteRealFix(W, Reals.Real(7F800000H), 17, 6); (* +INF *)
    Texts1.WriteRealFix(W, -1234.56789, 17, 6); Texts.WriteLn(W);  
    Texts1.WriteRealFix(W, Reals.Real(0FF800000H), 17, 6); (* -INF *)
    Texts1.WriteRealFix(W, 12.3456789, 17, 6); Texts.WriteLn(W);  
    Texts1.WriteRealFix(W, Reals.Real(7F800001H), 17, 6); (* NaN *)
    Texts1.WriteRealFix(W, -0.00123456789, 17, 6); Texts.WriteLn(W);  
    Texts1.WriteRealFix(W, Reals.Real(7FFFFFFFH), 17, 6); (* NaN *)
    Texts1.WriteRealFix(W, -123456.789, 17, 6); Texts.WriteLn(W);  
    Texts1.WriteRealFix(W, 0.1 + 0.2, 17, 6);
    Texts1.WriteRealFix(W, 2.0*2.03 + 2.0*3.5, 17, 6); Texts.WriteLn(W);
    Texts.WriteLn(W);
    Texts.Append(Oberon.Log, W.buf)
  END WriteTable1;

  PROCEDURE FltFloor*;
    VAR i, lim: INTEGER;  x: REAL;
  BEGIN 
    Texts.SetFont(W, Fonts.This("Courier10.Fnt"));
    lim := Limits.maxFLT - 4;
    x := Limits.maxFLOOR - 4.0;
    Texts.WriteLn(W);
    Texts.WriteString(W, "i         FLT(i)    x (hex)    x (dec)     FLOOR(x)"); 
    Texts.WriteLn(W);
    FOR i := lim TO lim + 9 DO
      Texts.WriteInt(W, i, 2);
      Texts1.WriteRealFix(W, FLT(i), 11, 0);
      Texts1.WriteRealHex(W, x); 
      Texts1.WriteRealFix(W, x, 0, 1);
      Texts.WriteInt(W, FLOOR(x), 10);  Texts.WriteLn(W);
      x := x + 1.0
    END;
    Texts.Append(Oberon.Log, W.buf)
  END FltFloor;

BEGIN Texts.OpenWriter(W);
  scan := Texts.Scan;  Texts.WriteString(W, "Texts.Scan active");  Texts.WriteLn(W);  Texts.WriteLn(W)
END TestRealIO.


TestRealIO.Do^                  TestRealIO.DoInt^               TestRealIO.SwapScan        TestRealIO.Limits1    TestRealIO.FltFloor
TestRealIO.WriteReal           TestRealIO.WriteTable        TestRealIO.WriteTable1     TestRealIO.Limits2    TestRealIO.DivByZero      
TestRealIO.WriteNumbers    TestRealIO.WriteNumbers2                                            TestRealIO.Limits3
TestRealIO.WriteNumbers1  TestRealIO.WriteNumbers3  

To do these tests you have to compile the following four modules:
ORP.Compile Limits.Mod Reals.Mod Texts1.Mod TestRealIO.Mod ~

[ If you make changes to the original Texts.Mod you have to compile (part of) the whole Oberon System, 
   otherwise you might end up with a system that does not boot anymore. This sounds more daunting than it is.
   Just use the text Rebuild.Tool from my GitHub pages and compile the line containing Texts.Mod and then
   compile ALL THE LINES BELOW THAT LINE (middle-click each ORP.Compile). That's it!                                     ]

Right-click the first digit of one of the REAL numbers below, then middle-click  TestRealIO.Do^ 
 1554.70E5     6 2
 1554.70E5     7 2
 1554.70E5     8 2
 1554.70E5     9 2
 12345.678    14 3
 22345.678    14 3
 22345.678    14 2
 12345678.0   14 1
 22345678.0   14 1
 123456789.0  14 1
 1.0E6        14 1
 1.0E6        14 2
 1.0E7        14 1
 1.0E8        14 1
 1.0E9        14 1
 2.0E-32      14 1
 1.0E-32      14 1
 1.232596E-32 14 1
 1.232595E-32 14 1
-1.232596E-32 14 1
-1.232595E-32 14 1

Now middle-click  TestRealIO.SwapScan  to switch to the improved version of Texts.Scan (Texts1.Scan) 
and repeat  TestRealIO.Do^  with the values above. You'll notice that values which can't be handled by
Texts1.Scan are properly trapped.

To show that even the trapped values can be handled by Texts.WriteReal and by the improved Texts1.WriteRealFix
we can use the INTEGER-encoded ('raw integer') value of a REAL number. In this way a REAL can be input directly
without using Texts.Scan. Below are two representations of the INTEGER encoding of the number 22345678.0
(in decimal and hexadecimal form). Select (the start of) one of those numbers and then middle-click TestRealIO.DoInt^.
 1269464039  3 
 4BAA7BE7H   3

The next lines show several other examples of REAL numbers that cannot be handled by Texts.Scan and Texts.WriteRealFix,
and in two cases not even by Texts.WriteReal (4B7FFFFFH and 0CB7FFFFFH). The improved output procedures of Texts1
can be shown to have no problem with these values if Text.Scan is not used and the values are input as an INTEGER-encoded
REAL with TestRealIO.DoInt^ (verify them on https://float.exposed):

 21474836.0  14 3     +INF
 4BA3D70AH   3        7F800000H   3

2147483648.0 14 1     -INF
 4F000000H   0        0FF800000H  3

-2147483904.0 14 1    0CF000001H  0
-2147483648.0 14 1    0CF000000H  0
-2147483520.0 14 1    0CEFFFFFFH  0 

 214748352.0  14 1     NaN (one of many possible values)
 4D4CCCCCH   1        7FC00000H   3       

 16777215.00 14 1      16777216.0 14 1      16777216.0E0 14 1
 4B7FFFFFH   1        4B800000H   1

-16777215.00 14 1     -16777216.0 14 1      16777215.878E1 14 5
 0CB7FFFFFH  1        0CB800000H  1

To see the tabulation of numbers with the new Texts1.WriteRealFix middle-click TestRealIO.WriteTable1, 
and compare the output with that of TestRealIO.WriteTable (produced by the present Texts.WriteRealFix).

TestRealIO.DivByZero shows how NaN and Infinities are produced. It also shows that 0.0/0.0 has result 0, 
which ought to be a NaN.

TestRealIO.Limits1 and TestRealIO.Limits2 show the upper and lower limits of the REAL number range.

TestRealIO.WriteNumbers and TestRealIO.WriteNumbers1 show two points where Texts.WriteReal is in error: 
at x = 16777215.00 or ORD(x) = 4B7FFFFFH and at x = -16777215.00 or ORD(x) = 0CB7FFFFFH

TestRealIO.WriteNumbers2 and TestRealIO.WriteNumbers3 show the points where Texts1.WriteReal underflows
when numbers get nearer to zero. In Limits.Mod I called these values minPosWriteReal and maxNegWriteReal.

1.232596E-32 14 1   -1.232596E-32 14 1 
0A800000H    1       8A800000H    1

1.232595E-32 14 1   -1.232595E-32 14 1 
0A7FFFFFH    1       8A7FFFFFH    1

When a floating point routine in Oberon System V5 spits out such tiny numbers, at the moment there will be
no other way than to use Texts1.WriteRealHex and look up the decimal numbers on https://float.exposed .

The ORP compiler and the RISC hardware can get closer to zero. The limit in that direction is  0.2E-37. 
I suspect that even subnormal REAL values are supported, because it can be show that the following 
can be calculated:  0.2E-37 / 2.0 =  0059C7DCH (which is  8.2450551E-39).
Note that the compiler can't cope with smaller negative exponents than -37, so 2.0E-38 will be seen as  0.0 
but 0.2E-37 not!  See TestRealIO.Limits3

Below you find a large assortment of input values to test and compare the old and new REAL I/O procedures.
Remember to use TestRealIO.DoInt^ for the (hexadecimal) integer inputs and TestRealIO.Do^ for the others.
Use TestRealIO.SwapScan to alternate between Texts.Scan and the new Texts1.Scan.
Use a monospace font for nicer alignment of the numbers (I used Courier10.Fnt).

 987654.65   20 7     0.009956789    8 16   5.0E-1 14 10        3.141593 14 4
-987654.32   14 2     0.00009876543 18 14   8.0     8  2        9999991.0 14 1  
                      1234.000967   17 7                                              
 98765.75    14 2     0.05534564    14 2   -0.0053356789123E-19  17 7
-987654.32   14 2     0.001234567   10 2   -0.0053356789123E-19  14 22
 9876543.21  14 2     0.000016545   14 13  -0.0053356789123E-19  14 11
 98765432.1  14 1     21474836.0    14 3    1.1E6  17  2
                      4BA3D70AH      3      9.3456789876 14 14
 9876543.6E9 14 1     1234.0009     14 3    1.0E7  14  1  
                      2147483646.0  14 0      
 98722345.67 14 3     2147483647.0  14 0    1.2345670E8  14 0   23456.789  14 2
 1.0545610   14 7     2147483648.0  14 0    1.0E9  14  0        23456.78   14 3
 92345678.9  14 5    -2147483648.0  14 0    1.0E10 14  0        23456.789  14 2 
 12345678.0  14 1    -0.00987654321  9 3   -1.2345678E-5 14 6   2345678.0  14 0 
 22345678.9  14 1     2000.0        17 6    2.345681E35  14 6   4CABA950H  14
 3456789.89  14 2     34.0067       14 2    3.402823E38  14 6
 3456789.00  14 2                           3.402824E38  14 6

 123456789.0 14 0    -2000.12345    14  4   0.0    10  3
 9876.5678   14 1    -2147483649.0  14  3   90000000.0   14 1   130000.0  14 3
 9876543.210 14 1     214748364.0   14  0   1.0E7  14  1        131.1234  14 5
 16777214.00 14 0     21474836000.0 14  0   9.999999E6   14 1   131.12345 14 6
 16777215.00 11 0     2147483600.0  14  0  -9.0E6  14  2        280.0     14 5
 16777216.00 14 0     21474840.0    14  0   1.0E5  14  3       -130000.0  14 6
 16777217.0  14 0     2147483.6     14  1  -1634567.8E12 14 5   0.0       14 9
 1.234567890 14 14    2147484.0     14  2   214748.0     14 1   25678.929 14 3      
 223456.78   14 2     2147484.0     14  3   214748.0     14 4   256.0     14 5
 123456.78   14 2     2147484.0     14  8   214748.0     14 5   256.0      4 3
 24879352.0  14 1
-258907.7E3  14 1
46C90004H       4                                               1000001.2 14 2
25728.00295  14 4     25728.0078     0  3   47C35000H  1        999999.7  14 1
49742401H       1     49742401H      1      47C35001H  1        1101234567.0 12 1
9876543.21   14 2     0.000015344    0  0  -0.00353335633 14 7
                                           -3.33335633 14 3
98765432.0   14 1     =  4CBC614FH 1        100000.0   14 3
9876543.0    14 2     =  4B16B43FH 1
9999999.0    14 1     =  4B18967FH 1
14748364.0  14 13     1.0E6 14  1           1.0E10 14  1
123456.789  14  1     2147483647.0   0  0   9.0E7  14  1       2345.6789  0  4
1.0545610   14  0     2147483648.0   0  0   1.0E8  14  1       23456.78   0  3
1234567.89  14  2    -2147483648.0   0  0   1.0E9  14  0       23456.789  0  2 
12345678.0  14  1     0.987654321   14  9  -1.2345678E10 0 3   23456789.0 0  0
12345678.90 14  9     4.0E9         15  3   2.2345678E11 0 3
123456789.0 14  0    -2000.12345    14  4   6.0    15  3
987654.32   14  2    -2147483649.0  14  3   1.0E-7  0 20       130000.0   14   3
9876543.210 14  1     214748364.0   14  0   1.0E5   0  1       131.1234   14   5
987654321.0 14  0     21474836000.0 14  0   1.0E6   0  5       131.12345  14   6
16777215.0  17  7     2147483600.0  0   0  -1.0E6   0  2       280.0      14   5
16777216.0  14  0     21474840.0    0   0   1.0E5   0  3      -130000.0    5   6
16777217.0  14  0     2147483.6     0   0  -163456.7E-37 0 50  0.0         0   9
1.234567890 14  3     2147484.0     0   2   214748.0  14 1     25678.929   0   3      
223456.79   14  2     2147484.0     0   3   214748.0  14 4     256.0      14   5
123456.7111 14  4     2147484.0     0   8   214748.0  14 5     256.0      14 100
                                                              -258907.7E3 14   1
46C90004H      4                                               1000001.2  14   2
25728.002953 0 4      25728.0078 15 3     47C35000H  1         999999.7   14   1
49742401H      1      49742401H     1     47C35001H  1
43031F99H      6      49742402H     1     47C35002H  1
0BF9E064BH    18      49742403H     1     47C35003H  1
487A5668H      2      49742404H     1     47C35004H  1
-1.2345678  14 7      49742405H     1     47C35005H  1
9.99999  14 4         49742406H     1     47C35006H  1
9.999999 14 3         49742406H     1     47C35006H  1
9.9      14 5         0.000000000004974247 24 18
9.9      14 6         0.000000000004974247 24 17
9.9      14 7         0.000000000004974247 24 16
9.9      14 8         0.000000000004974247 24 15
9.9      14 9         0.000000000004974247 24 14
9.9      14 10        0.000000000004974247 24 13
9.9      14 11        0.000000000004974247 24 12
9.9      14 12        0.000000000004974247 24 11 (bug)
999999.9     14 2     49742407H     1     47C35007H  1
49712065H       2     49742408H     1     47C35008H  1
1554.70E5    12 0     49742409H     1     47C35009H  1
1554.70E5    12 2     4974240AH     1     47C3500AH  1
1554.7432    14 2
12345.78     14 2     7F800000H     0
-123245.78   14 2
12.78        14 2
1.4444444    14 7     1.5555555 14  7     0.0034214    14  7
1.4444444    14 6     1.5555555 14  6     0.0000002    14 10
1.4444444    14 5     1.5555555 14  5     0.0055555    14  5
1.4444444    14 4     1.5555555 14  4     0.0055555    14  4
1.4444444    14 3     1.5555555 14  3     0.0055555    14  3
1.4444444    14 2     1.5555555 14  2     0.0055555    14  2
1.4444444    14 1     1.5555555 14  1     0.0055555    14  1
1.4444444    14 0     1.5555555 14  0     0.0055555    14  0

1554.70E5  6  2      1554.70E2  14  2     3.1415926535 14 8
1554.70E5  7  2      1554.70E3  14  2     3.1415926535 14 7
1554.70E5  8  2      1554.70E4  14  2     3.1415926535 14 6
1554.70E5  9  2      1554.70E5  14  2     3.1415926535 14 5
1554.70E5 10  2      1554.70E6  14  2     3.1415926535 14 4
1554.70E5 11  2      1554.70E7  14  2     3.1415926535 14 3
1554.70E5 12  2      1554.70E8  14  2     3.1415926535 14 2
1554.70E5 13  2      2554.70E0  14  2     3.1415926535 14 1
1554.70E5 14  2      2554.70E1  14  2     3.1415926535 14 0
0.0       18  2      2554.70E2  14  2     3.5 14 0
1554.70E5 14  9      2554.70E3  14  2     1.3 14 5
1554.70E5 14 10      2554.70E4  14  2     1.3 14 6
1554.70E5 14 11      2554.70E6  14  2     1.3 14 7
1554.70E5 14 12      2554.70E7  14  2     1.3 14 8
1554.70E5 14 13      2554.70E8  14  2     1.3 14 9
1554.70E5 14 14      2554.70E35 14  2     1.3 14 10
1554.70E5 14 15      2554.70E36 14  2     1.3 14 11
