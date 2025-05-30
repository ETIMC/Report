= Bill of Materials <app:bom>
#figure(
  table(
    
  ),
)

#colbreak()
= Sprint 2 transcriptions <app:Sprint2Transcriptions>
== Test 1
//#figure(
//  rect(image("appendices/sprint-2-test/Test 1.svg", width: 92%), radius: 2mm)
//)

#colbreak()
== Test 2
//#figure(
//  rect(image("appendices/sprint-2-test/Test 2.svg", width: 92%), radius: 2mm)
//)

#colbreak()
== Test 3
//#figure(
//  rect(image("appendices/sprint-2-test/Test 3.svg", width: 92%), radius: 2mm)
//)

#colbreak()
== Test 4
//#figure(
//  rect(image("appendices/sprint-2-test/Test 4.svg", width: 92%), radius: 2mm)
//)

#colbreak()
#heading([Sprint 3 transcriptions]) <app:Sprint3Transcriptions>

#colbreak()
#heading([Sprint 4 transcriptions]) <app:Sprint4Transcriptions>

#colbreak()
#heading([Sprint 5 transcriptions]) <app:Sprint5Transcriptions>

#colbreak()
= Schematic after second sprint <app:schematicSprint2>
#figure(
  rect(image("appendices/Scematic sprint 2 (c0b079c).svg"), radius: 2mm),
)

#colbreak()
= Schematic after third sprint <app:schematicSprint3>
- USB 2.0 Type B Connector
- Separate SPI busses for display and NFC reader
- LDR sensor and associated LED
#figure(
  rect(image("appendices/Scematic sprint 3 (bf286ac).svg"), radius: 2mm)
)

#colbreak()
= Schmatic after fourth sprint <app:schematicSprint4>
#figure(
  rect(image("appendices/Scematic sprint 4 (c3da3fa).svg"), radius: 2mm)
)

#colbreak()
= Automatic card detection calculation <app:automaticCardDetection>
#[
  *LED Resistor Calculation:*
  The chosen LED had a forward voltage of approximately $1.8V$ at $20"mA"$ @nte_electronics_inc_nte3019_nodate. With the Pico's GPIO supplying $3.3V$, the resistor value was calculated by
  $ R = (V_("supply") - V_F) / I_F = (3.3V - 1.8V) / (0.02A) = 75 Omega $
  
  *LDR:*
  To calculate the correct resistor to use for the voltage divider with the LDR, the LDRs resistance, when placed in the Controller, was measured:
  - With an NFC card inserted: $1.900.000 Omega$
  - Without an NFC card inserted: $300.000 Omega$
  
  To create a voltage divider ensuring correct functionality, the resistor's resistance was calculated by calculating the ratio of the extremes @math:ratio1, calculating the square root to find how many times larger the fixed resistor should be than the smaller LDR value @math:sqrt, and multiplying/dividing with the measured LDR resistances @math:calc1 @math:calc2.
  
  $ (1.900.000 Omega) / (300.000 Omega) approx 6.33 $ <math:ratio1>
  $ sqrt(6.33) approx 2.52 $ <math:sqrt>
  $ 300.000 Omega dot 2.25 = 753.000 Omega $ <math:calc1>
  $ (1.900.000)/(2.52) = 756.369 Omega $ <math:calc2>
  
  For the project, no resistor the exact size was available and as such, a resistor of $0.75 M Omega$ was chosen. With the resistor and LDR combined to create a voltage divider, it's values were read by a Pico:
  - Observed voltage with NFC card inserted: $0.9V$
  - Observed voltage without NFC card inserted: $1.3V$
  
  For verification, the theoretical values were also calculated:
  
  With NFC card: 
  $ V_1 = 3.3V dot (1.900.000 Omega)/(1.900.000 Omega + 750.000 Omega) = 2.37V $
  $ V_"out" = V - V_1 = 3.3V - 2.37V = 0.93V $
  
  Without NFC card: 
  $ V_1 = 3.3V dot (300.000 Omega)/(300.000 Omega + 750.000 Omega) = 0.943V $
  $ V_"out" = V - V_1 = 3.3V - 0.94V = 2.36V $
] <no-wc>

#colbreak()
