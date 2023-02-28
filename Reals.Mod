MODULE Reals; (* IN V5 *)
(** Low-level procedures for conversion of a sequence of digits into an internal floating-point representation and vice versa *)
(* Procedure Convert after a 64-bit version found here: 
    https://github.com/vishaps/voc/blob/master/src/runtime/Reals.Mod
  JT, 5.2.90 / RC 9.12.91 conversion between reals and strings for HP-700, MB 9.12.91, JT for Ofront, 16.3. 95.
  DCWB 20160817 Made independent of INTEGER size.
  Ported to Oberon-07 / Oberon System V5  (32-bit REAL)  hk 28-9-2022.

  Real number formats (IEEE 754)
  -------------------------

    TYPE REAL - Single precision or Binary32 (1+8+23):

  x = 1.m * 2^(e-127)   bit 0: sign, bits 1- 8: e, bits  9-31: m

    e = exponent (8 bits):
       stored as exponent value + 127.
    m ('mantissa') = significand or fraction (23 bits):
       excludes the leading (most significant) 'hidden' or 'implicit' bit which is assumed to be 1.

    TYPE REAL - Double precision or Binary64 (1+11+52), not implemented here:

  x = 1.m * 2^(e-1023)  bit 0: sign, bits 1-11: e, bits 12-63: m

    e = exponent (11 bits): 
       stored as exponent value + 1023.
    m ('mantissa') = significand or fraction (52 bits):
       excludes the leading (most significant) 'hidden' or 'implicit' bit which is assumed to be 1.
*)

  IMPORT SYSTEM, Limits; 

  PROCEDURE Eps1* ( ): REAL;
  (* Finds the machine epsilon (definition a). See: https://en.wikipedia.org/wiki/Machine_epsilon *)
    VAR eps: REAL;
  BEGIN eps := 1.0;
    WHILE 1.0 + 0.5 * eps # 1.0 DO
      eps := 0.5 * eps
    END
  RETURN eps
  END Eps1;
(*
  PROCEDURE Eps1* ( ): REAL;
  (* Finds the machine epsilon (definition a), alternative implementation *)
    VAR eps: REAL;
  BEGIN eps := 1.0;
    WHILE 1.0 + eps / 2.0 > 1.0 DO
      eps := eps / 2.0
    END
  RETURN eps
  END Eps1;
*)
  PROCEDURE Eps2* ( ): REAL;
  (* Finds the machine epsilon (definition b). See: https://en.wikipedia.org/wiki/Machine_epsilon *)
    VAR a, b, c: REAL;
  BEGIN
    a := 4.0/3.0;
    b := a - 1.0;
    c := b + b + b
  RETURN c - 1.0
  END Eps2;


  PROCEDURE Real* (h: INTEGER): REAL;
  (** Returns a REAL given its raw (hexadecimal or decimal) encoded INTEGER value *)
    VAR x: REAL;
  BEGIN SYSTEM.PUT(SYSTEM.ADR(x), h)
  RETURN x
  END Real;

  PROCEDURE Int* (x: REAL): INTEGER;
  (** Returns the raw (hexadecimal or decimal) encoded INTEGER value of a REAL *)
    VAR i: INTEGER;
  BEGIN SYSTEM.PUT(SYSTEM.ADR(i), x)
  RETURN i
  END Int;
(*
  PROCEDURE Int* (x: REAL): INTEGER;
  (** Returns the raw (hexadecimal or decimal) encoded INTEGER value of a REAL *)
  (* Alternative implementation; assumes SYSTEM.SIZE(INTEGER) = SYSTEM.SIZE(REAL) *)
  BEGIN RETURN ORD(x)
  END Int; 
*)

  PROCEDURE Convert* (x: REAL; n: INTEGER; VAR d: ARRAY OF CHAR);
  (** Convert REAL: Write positive integer value of x into array d.
    The value is stored backwards, i.e. least significant digit
    first; n digits are written, with trailing zeros fill.
    On entry x has been scaled to the number of digits required.
  *)
    VAR i, j, k: INTEGER;
  BEGIN
    IF x < 0.0 THEN x := -x END;
    k := 0;

    IF n > 7 THEN
      (* There are more decimal digits than can be handled by FLT(i):
        FLT(i) for 32-bit REAL can't handle more than 24 bits: maxFLT = 16777215 (2^24 - 1).
      *)
      i := FLOOR(x /           10000000.0);   (* The 8th and higher digits *)
      j := FLOOR(x - (FLT(i) * 10000000.0));  (* The lower 7 digits *)
      (* First generate the lower 7 digits *)
      IF j < 0 THEN j := 0 END;
      WHILE k < 7 DO
        d[k] := CHR(j MOD 10 + 48); j := j DIV 10; INC(k)
      END;
      (* Fall through to generate the upper digits *)
    ELSE
      (* We can generate all the digits in one go *)
      i := FLOOR(x);
    END;

    WHILE k < n DO
      d[k] := CHR(i MOD 10 + 48); i := i DIV 10; INC(k)
    END
  END Convert;

END Reals.
