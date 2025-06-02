#set par(spacing: 1em)

= Bill of Materials <app:bom>
OBS: Bill of materials does not include software licenses or external computer pricing.

== Single Controller
#figure(
  table(
  columns: (0.25fr, 3fr, 0.7fr, 1.6fr, 0.8fr),
  align: start,
  table.header([*Id*], [*Component*], [*Quantity*], [*Source*], [*Price*]),
  [], [_Electronics_],[],[],[],
  [1], [Raspberry Pi Pico W], [1], [#cite(<raspberrypidk_raspberry_nodate-1>, form: "prose")],[59 DKK],
  [2], [NFC reader], [1], [#cite(<arduinotechdk_rfid_2025>, form: "prose")],[40 DKK],
  [3], [Display], [1], [#cite(<pimoroni_pico_2025>, form: "prose")],[168 DKK],
  [4], [Potentiometer], [4], [#cite(<rs_components_bourns_nodate>, form: "prose")],[31 DKK],
  [5], [Switches], [8], [#cite(<nuphy_nuphy_2025>, form: "prose")],[20 DKK],
  [6], [Multiplexer], [1], [#cite(<arduinotechdk_74hc4051_2025>, form: "prose")],[8,75 DKK],
  [7], [USB B connector], [1], [#cite(<ardustoredk_usb_nodate-1>, form: "prose")],[3 DKK],
  [8], [On/off switch], [1], [#cite(<arduinotechdk_vippekontakt_2025>, form: "prose")],[8.75 DKK],
  [9], [Pinheader 8 holes], [1], [#cite(<digikey_pptc081lfbn-rc_2025>, form: "prose")],[3,63 DKK],
  [10], [Cable to Host], [1], [#cite(<av-cablesdk_usb_nodate>, form: "prose")],[45 DKK],
  [11], [Custom PCB], [1], [#cite(<jlcpcbcom_pcb_2025>, form: "prose")],[$approx$ 50 DKK],
  [], [_Molex_],[],[],[],
  [12], [Molex Straight Through Hole Pin Header, 4 Contacts], [1], [#cite(<rs_components_22-27-2041_nodate>, form: "prose")],[4,37 DKK],
  [13], [Molex Female Connector Housing, 2 Way], [1], [#cite(<rs_components_22-01-3047_nodate>, form: "prose")],[1,75 DKK],
  [14], [Molex Straight Through Hole Pin Header, 2 Contacts], [1], [#cite(<rs_components_22-27-2021_nodate>, form: "prose")],[2,25 DKK],
  [15], [Molex Female Connector Housing, 2 Way], [1], [#cite(<rs_components_22-01-2021_nodate>, form: "prose")],[1,35 DKK],
  [16], [Molex Female Crimp Terminal], [6], [#cite(<rs_components_08-52-0072_nodate>, form: "prose")],[6,5 DKK],
  [], [_Chassis_],[],[],[],
  [17], [Black filament, Black (10101)], [290 g], [#cite(<bambu_lab_pla_nodate>, form: "prose")],[50 DKK],
  [18], [White filament, Jade White (10100)], [18 g],[#cite(<bambu_lab_pla_nodate>, form: "prose")], [3,1 DKK],
  [19], [Silver filament, Silver (10102)], [23 g],[#cite(<bambu_lab_pla_nodate>, form: "prose")], [4 DKK],
  [], [_Sum_], [], [],  [510,45 DKK]
  ),
  caption: [Bill of materials for a single Controller.],
) <table:ControllerHardwareMaterials>

#colbreak()
== Host, connecting to a single Controller
#figure(
  table(
  columns: (0.25fr, 3fr, 0.7fr, 1.6fr, 0.8fr),
  align: start,
  table.header([*Id*], [*Component*], [*Quantity*], [*Source*], [*Price*]),
  [], [_Electronics_], [], [], [],
  [1], [Raspberry Pi Pico 2 W], [1], [#cite(<raspberrypidk_raspberry_nodate>, form: "prose")],[69 DKK],
  [2], [Breadboard], [1], [#cite(<arduinotechdk_breadboard_2025>, form: "prose")],[30 DKK],
  [3], [NeoPixel], [1], [#cite(<adafruit_breadboard-friendly_2025>, form: "prose")],[10,5 DKK],
  [4], [Resistor 82k$Omega $], [2], [#cite(<rs_components_rs_nodate>, form: "prose")],[0,18 DKK],
  [5], [USB A connector], [1], [#cite(<ardustoredk_usb_nodate>, form: "prose")],[8 DKK],
  [6], [Cable to Pico], [1], [#cite(<raspberrypidk_officiel_nodate>, form: "prose")],[39 DKK],
  [], [_3D printed enclosure_], [],[], [],
  [7], [Black filament, Black (10101)], [175 g],[#cite(<bambu_lab_pla_nodate>, form: "prose")], [30 DKK],
  [8], [Green filament, Alpine Green Sparkle (13501)], [4 g],[#cite(<bambu_lab_pla_nodate-1>, form: "prose")], [0,8 DKK],
  [], [_Sum_], [], [],  [187,48 DKK]
  ),
  caption: [Bill of materials for Host connecting to a single Controller],
) <table:HostHardwareMaterials>

#colbreak()
= Schematic after second sprint <app:schematicSprint2>
#figure(
  rect(image("appendices/Scematic sprint 2 (c0b079c).svg"), radius: 2mm),
)

#colbreak()
= Schematic after third sprint <app:schematicSprint3>
#figure(
  rect(image("appendices/Scematic sprint 3 (bf286ac).svg"), radius: 2mm)
)

#colbreak()
= Schematic after fourth sprint <app:schematicSprint4>
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
= Sprint 2 transcriptions <app:Sprint2Transcriptions>
== Test 1:
#include "appendices/sprint-2-test/test1.typ"
<no-wc>

#colbreak()
== Test 2:
#include "appendices/sprint-2-test/test2.typ"
<no-wc>

#colbreak()
== Test 3:
#include "appendices/sprint-2-test/test3.typ"
<no-wc>

#colbreak()
== Test 4:
#include "appendices/sprint-2-test/test4.typ"
<no-wc>

#colbreak()
= Sprint 3 transcriptions <app:Sprint3Transcriptions>
== Test 1:
#include "appendices/sprint-3-test/test1.typ"
<no-wc>

#colbreak()
== Test 2:
#include "appendices/sprint-3-test/test1.typ"
<no-wc>

#colbreak()
== Test 3:
#include "appendices/sprint-3-test/test1.typ"
<no-wc>

#colbreak()
= Sprint 4 transcriptions <app:Sprint4Transcriptions>
== Test 1:
#include "appendices/sprint-4-test/test1.typ"
<no-wc>

#colbreak()
== Test 2:
#include "appendices/sprint-4-test/test2.typ"
<no-wc>

#colbreak()
== Test 3:
#include "appendices/sprint-4-test/test3.typ"
<no-wc>

#colbreak()
== Test 4:
#include "appendices/sprint-4-test/test4.typ"
<no-wc>

#colbreak()
= Sprint 5 transcriptions <app:Sprint5Transcriptions>
== Test 1:
#include "appendices/sprint-5-test/test1.typ"
<no-wc>

#colbreak()
== Test 2:
#include "appendices/sprint-5-test/test2.typ"
<no-wc>

#colbreak()
== Test 3:
#include "appendices/sprint-5-test/test3.typ"
<no-wc>

#colbreak()
