MODULE Limits; (* IN V5 *)  (* hk 31-12-2022 *)
  IMPORT SYSTEM;
  
  CONST
    maxBYTE* = 255;                       (* (2^8)-1 *)
    maxINT8  = 127;                       (* (2^7)-1 *)
    maxINT16 = 32767;                     (* (2^15)-1 *) 
    maxINT32 = 2147483647;                (* (2^31)-1 *)
 (* maxINT64 = 9223372036854775807;       (* 2^63)-1 *)  *)
 
    maxFLT32 = 16777215;                  (* 2^24-1 *)
    maxFLOOR32 = 16777215.00;

    maxREAL32 = 3.40282347E+38;           (* 7 significant digits *)
    minREAL32 = 0.2E-37;                  (** don't use 2.0E-38 ! *)  (* IEEE 754: 1.17549435E-38 *)

    (** limitation of Texts.WriteReal *)
    minPosWriteReal* =  1.232596E-32;     (* Reals.Real(0A800005H) *) 
    maxNegWriteReal* = -1.232596E-32;     (* Reals.Real(8A800005H) *) 

 (* maxREAL64 = 1.79769313486232E+308;    (* 1.7976931348623157E308;  15 significant digits *)  *)

  VAR 
    intSize, realSize: INTEGER;
    maxINT*, minINT*, maxSET*, maxFLT*: INTEGER;
    maxREAL*, minREAL*, maxFLOOR*: REAL;
    
  PROCEDURE MaxSET ( ): INTEGER;
  (* After Karl Landstroem, the developer of OBNC. 
   * https://miasap.se/obnc/faq.html  
   *)
    VAR x: INTEGER;  s: SET;
  BEGIN
    x := -1;  s := - {};
    REPEAT
      INC(x);  EXCL(s, x)
    UNTIL s = {}
  RETURN x
  END MaxSET;

BEGIN
  intSize := SYSTEM.SIZE(INTEGER);
  IF intSize = 1 THEN maxINT := maxINT8
  ELSIF intSize = 2 THEN maxINT := maxINT16
  ELSIF intSize = 4 THEN maxINT := maxINT32
  ELSIF intSize = 8 THEN (* maxINT := maxINT64 *)
    ASSERT(FALSE)  (* Limits.maxINT64 not yet implemented *)
  END;
  minINT := -maxINT - 1;

  realSize := SYSTEM.SIZE(REAL);
  IF realSize = 4 THEN 
    maxREAL := maxREAL32;
    minREAL := minREAL32;
    maxFLOOR := maxFLOOR32;
    maxFLT := maxFLT32;
  ELSIF realSize = 8 THEN (* maxREAL := maxREAL64 *)
    ASSERT(FALSE)  (* Limits.maxREAL64: not yet implemented *)
  END;
  maxSET := MaxSET( )
END Limits.
