MODULE Texts1; (* IN V5 *)  (* hk  26.12.2022 *)
(* Proposed changes for Scan, WriteReal and WriteRealFix of module Texts in Oberon V5.
   WriteRealHex and seq added.
*)

  IMPORT SYSTEM, Files, Fonts, Texts, Oberon, Reals;                                      (* hk 26.11.2022 *)
 
  CONST (*scanner symbol classes*)
    Inval* = 0;     (*invalid symbol*)
    Name* = 1;      (*name s (length len)*)
    String* = 2;    (*literal string s (length len)*)
    Int* = 3;       (*integer i (decimal or hexadecimal)*)
    Real* = 4;      (*real number x*)
    Char* = 6;      (*special character c*) 

    TAB = 9X; CR = 0DX;  maxD = 9;

  VAR W: Texts.Writer;  S: Texts.Scanner;  T: Texts.Text;
    beg: INTEGER;


  PROCEDURE Ten(n: INTEGER): REAL;
    VAR t, p: REAL;
  BEGIN t := 1.0; p := 10.0;  (*compute 10^n *)
    WHILE n > 0 DO
      IF ODD(n) THEN t := p * t END ; 
      p := p*p; n := n DIV 2
    END ;
    RETURN t
  END Ten;


  PROCEDURE Scan* (VAR S: Texts.Scanner);
  
    CONST maxExp = 38;  maxM = 16777216 - 1;  (* 2^24 - 1 *)                              (* hk 26.11.2022 *) 
    VAR ch: CHAR;
      neg, negE, hex: BOOLEAN;
      i, j, h, d, e, n, s: INTEGER;
      x: REAL;
  BEGIN ch := S.nextCh; i := 0;
    WHILE (ch = " ") OR (ch = TAB) OR (ch = CR) DO
      IF ch = CR THEN INC(S.line) END ;
      Texts.Read(S, ch)
    END ;
    IF ("A" <= ch) & (ch <= "Z") OR ("a" <= ch) & (ch <= "z") THEN (*name*)
      REPEAT S.s[i] := ch; INC(i); Texts.Read(S, ch)
      UNTIL ((ch < "0") & (ch # ".") OR ("9" < ch) & (ch < "A") OR ("Z" < ch) & (ch < "a") OR ("z" < ch)) OR (i = 31);
      S.s[i] := 0X; S.len := i; S.class := Name
    ELSIF ch = 22X THEN (*string*)
      Texts.Read(S, ch);
      WHILE (ch # 22X) & (ch >= " ") & (i # 31) DO S.s[i] := ch; INC(i); Texts.Read(S, ch) END;
      S.s[i] := 0X; S.len := i+1; Texts.Read(S, ch); S.class := String
    ELSE hex := FALSE;
      IF ch = "-" THEN neg := TRUE; Texts.Read(S, ch) ELSE neg := FALSE END ;
      IF ("0" <= ch) & (ch <= "9") THEN (*number*)
        n := ORD(ch) - 30H; h := n; Texts.Read(S, ch);
        WHILE ("0" <= ch) & (ch <= "9") OR ("A" <= ch) & (ch <= "F") DO
          IF ch <= "9" THEN d := ORD(ch) - 30H ELSE d := ORD(ch) - 37H; hex := TRUE END ;
          n := 10*n + d; h := 10H*h + d; Texts.Read(S, ch) 
        END ;
        IF ch = "H" THEN (*hex integer*) Texts.Read(S, ch); S.i := h; S.class := Texts.Int (*neg?*)
        ELSIF ch = "." THEN (*real number*)
          (* Max. 7 (or 8, if x < 16777216.0) digits before the decimal point, otherwise TRAP 7.                   *)
          (* Most unacceptable values are trapped by the first Boolean, values with 8 digits  > 16777215 by the    *)
          (* second, -2147483648 (the only value in which the sign is not flipped) is trapped by the last Boolean. *)
          (* *************************************************************************************** hk 26.11.2022 *)
          IF (ABS(n) # n) OR (ABS(n) > maxM) OR (n < -2147483647) THEN 
             Texts.WriteString(W, "Overflow of FLT(x) in Texts1.Scan"); Texts.Append(Oberon.Log, W.buf);
            ASSERT(FALSE)
          END;
          (* *************************************************************************************** hk 26.11.2022 *)
          Texts.Read(S, ch); x := 0.0; e := 0; j := 0;
          WHILE ("0" <= ch) & (ch <= "9") DO (*fraction*) 
            h := 10*n + (ORD(ch) - 30H);
            IF h < maxM THEN n := h; INC(j) END ; 
            Texts.Read(S, ch)
          END ;
          IF ch = "E" THEN (*scale factor*)
            s := 0; Texts.Read(S, ch);
            IF ch = "-" THEN negE := TRUE; Texts.Read(S, ch)
            ELSE negE := FALSE;
              IF ch = "+" THEN Texts.Read(S, ch) END
            END ;
            WHILE ("0" <= ch) & (ch <= "9") DO
              s := s*10 + ORD(ch) - 30H; Texts.Read(S, ch)
            END ;
            IF negE THEN DEC(e, s) ELSE INC(e, s) END ;
          END;
          x := FLT(n); DEC(e, j);
          IF e < 0 THEN
            IF e >= -maxExp THEN x := x / Ten(-e) ELSE x := 0.0 END
          ELSIF e > 0 THEN
            IF e <= maxExp THEN x := Ten(e) * x ELSE x := 0.0 END
          END ;
          IF neg THEN S.x := -x ELSE S.x := x END ;
          IF hex THEN S.class := 0 ELSE S.class := Real END
        ELSE (*decimal integer*)
          IF neg THEN S.i := -n ELSE S.i := n END;
          IF hex THEN S.class := Inval ELSE S.class := Int END
        END
      ELSE (*special character*) S.class := Char;                                         (* hk 26.9.2022 *)
        IF neg THEN S.c := "-" ELSE S.c := ch; Texts.Read(S, ch) END
      END
    END ;
    S.nextCh := ch
  END Scan;


  PROCEDURE WriteRealHex* (VAR W: Texts.Writer; x: REAL);
  (* Write the encoded ('raw') hexadecimal INTEGER value of a REAL *)
  BEGIN Texts.WriteHex(W, Reals.Int(x)); Texts.Write(W, "H")
  END WriteRealHex;


  PROCEDURE seq (VAR W: Texts.Writer; ch: CHAR; n: INTEGER);
  (* Write a sequence of n characters ch *)
  BEGIN WHILE n > 0 DO Texts.Write(W, ch); DEC(n) END 
  END seq;


  PROCEDURE WriteReal* (VAR W: Texts.Writer; x: REAL; n: INTEGER);
  (* NW 10.1.2019 / hk 27.12.2023 (ELSIF clauses) *)
    VAR e, i, k, m: INTEGER;
      d: ARRAY 16 OF CHAR;
  BEGIN
    e := ASR(ORD(x), 23) MOD 100H;  (* binary exponent = shifted exponent of 2 (0 <= e < 256) *)
    IF e = 0 THEN seq(W, " ", n-14); Texts.WriteString(W, "  0     ");  seq(W, " ", n-8)
    ELSIF e = 255 THEN 
      IF ORD(x) = 7F800000H THEN seq(W, " ", n-14); Texts.WriteString(W, " +INF   "); seq(W, " ", n-8)
      ELSIF ORD(x) = 0FF800000H THEN seq(W, " ", n-14); Texts.WriteString(W, " -INF   "); seq(W, " ", n-8)
      ELSE seq(W, " ", n-14); Texts.WriteString(W, " NaN    "); seq(W, " ", n-8)
      END
    ELSIF ORD(x) = 4B7FFFFFH THEN seq(W, " ", n-14); Texts.WriteString(W, "  1.677721E+07"); 
    ELSIF ORD(x) = 0CB7FFFFFH THEN seq(W, " ", n-14); Texts.WriteString(W, " -1.677721E+07");
    ELSIF ORD(ABS(x)) < 0A800000H THEN  (* ABS(x) < 1.232596E-32 *)
      Texts.WriteString(W, " Underflow in Texts1.WriteReal");  Texts.Append(Oberon.Log, W.buf);
      (*ASSERT(FALSE)*)
    ELSE Texts.Write(W, " ");
      WHILE n >= 15 DO DEC(n); Texts.Write(W, " ") END ;
      IF n < 9 THEN n := 9 END;                                                           (* hk 03.10.2020 *)
      (* 2 < n < 9 digits to be written*)
      IF x < 0.0 THEN Texts.Write(W, "-"); x := -x ELSE Texts.Write(W, " ") END ;
      e := (e - 127) * 77 DIV 256 - 6;  (* decimal exponent = exponent of 10 *)
      IF e >= 0 THEN x := x / Ten(e) ELSE x := Ten(-e) * x END;
      m := FLOOR(x + 0.5);  (* significand or mantissa; 7 or 8 digits; last digit rounded, half rounded towards +INF *)
      IF m >= 10000000 THEN INC(e); m := m DIV 10 END ;  (* 7 digits *)
      i := 0; k := 13-n;
      REPEAT
        IF i = k THEN INC(m, 5) END;  (* rounding of k-th decimal *)
        d[i] := CHR(m MOD 10 + 30H); m := m DIV 10; INC(i)
      UNTIL m = 0;
      DEC(i); Texts.Write(W, d[i]); Texts.Write(W, ".");
      IF i < n-7 THEN n := 0 ELSE n := 14 - n END ;
      WHILE i > n DO DEC(i); Texts.Write(W, d[i]) END ;
      Texts.Write(W, "E"); INC(e, 6);
      IF e < 0 THEN Texts.Write(W, "-"); e := -e ELSE Texts.Write(W, "+") END ;
      Texts.Write(W, CHR(e DIV 10 + 30H)); Texts.Write(W, CHR(e MOD 10 + 30H))
    END
  END WriteReal;

  PROCEDURE WriteRealFix* (VAR W: Texts.Writer; x: REAL; n, k: INTEGER);
  (* JG  21.11.1990 / hk 29.10.2022 *)
    CONST maxD = 9;  (* maximal number of digits written, apart from leading zeros; 11 is a hard upper limit! *)
    VAR e, i, j, k0: INTEGER; sign: CHAR; x0, xOrg: REAL;
      d: ARRAY maxD OF CHAR;  (* digits *)

    PROCEDURE dig (VAR W: Texts.Writer; d: ARRAY OF CHAR; VAR i: INTEGER; n: INTEGER);
    (* Write n digits taken from string d *)
    BEGIN WHILE n > 0 DO DEC(i); Texts.Write(W, d[i]); DEC(n) END 
    END dig;
  
  BEGIN xOrg := x;                                                                        (* hk 22.10.2022 *)
    e := ASR(ORD(x), 23) MOD 100H;  (* binary exponent = biased exponent of 2 (0 <= e < 256 *)
    IF k < 0 THEN k := 0 END;
    IF e = 0 THEN seq(W, " ", n-k-4); Texts.WriteString(W, "  0"); seq(W, " ", k+1)
    ELSIF e = 255 THEN
      IF ORD(x) = 7F800000H THEN seq(W, " ", n-k-6); Texts.WriteString(W, " +INF"); seq(W, " ", k+1)
      ELSIF ORD(x) = 0FF800000H THEN seq(W, " ", n-k-6); Texts.WriteString(W, " -INF"); seq(W, " ", k+1)
      ELSE seq(W, " ", n-k-5); Texts.WriteString(W, " NaN"); seq(W, " ", k+1)
      END
      ELSE e := (e - 127) * 77 DIV 256;   (* 77/256 = log 2 *)
      IF x < 0.0 THEN sign := "-"; x := -x ELSE sign := " " END;
      IF e >= 0 THEN (* x >= 1.0 *) x := x/Ten(e)
      ELSE (* x < 1.0 *) x := Ten(-e) * x 
      END;
      IF x >= 10.0 THEN x := 0.1*x; INC(e) END; 
      (* 1 <= x < 10 *)
      k0 := k;                                                                            (* hk 29.09.2022 *)
      IF k+e >= maxD-1 THEN k := maxD-1-e
      ELSIF k+e < 0 THEN (* k := -e-1; *) k := -e; x := 0.0                               (* hk 24.10.2022 *)
      END;
      x0 := Ten(k+e);  x := x0*x + 0.5; 
      IF x >= 10.0*x0 THEN INC(e) END; 
      (* e = no. of digits before decimal point *)
      INC(e); i := k+e;
      IF e <= maxD THEN                                                                   (* hk 22.10.2022 *)
        Reals.Convert(x, i, d);
        Texts.Write(W, " ");
        IF e > 0 THEN
          seq(W, " ", n-e-3-k0); Texts.Write(W, sign); dig(W, d, i, e);
          Texts.Write(W, "."); dig(W, d, i, k); seq(W, " ", k0-k)
        ELSE 
          seq(W, " ", n-k-4); Texts.Write(W, sign); Texts.Write(W, "0"); Texts.Write(W, ".");
          IF x = 0.5 THEN seq(W, "0", k0) ELSE seq(W, "0", -e);  dig(W, d, i, k+e) END    (* hk 25.10.2022 *)
        END
      ELSE (* e > maxD, x >= 10^maxD *) 
        WriteReal(W, xOrg, n)    (* last resort, otherwise:
                                     - if e > maxD then array index overflow in procedure dig, or 
                                     - if maxD > 11 then wrong result                                      *)
      END
    END
  END WriteRealFix;

BEGIN Texts.OpenWriter(W)
END Texts1.
