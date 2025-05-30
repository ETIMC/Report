= Methods & Materials
/*
- Målgruppe
- Værktøjer
- Materialer
- Testmetoder
- Iterativ arbejdsproces
- Tests oversat fra Dansk til Engelsk
  - Forklar hvorfor oversættelserne kan være lidt tossede
*/

The project employed an iterative, user-centered design approach, in which features were continuously refined and added based on user feedback gathered during multiple stages of prototype development.

Testing was primarily conducted with the target user group, children aged 9 to 12, and incorporated a combination of think-aloud protocols, A/B testing, and unstructured interviews.The informal test-formats allowed the facilitator to respond flexibly to questions and moments of confusion, thereby improving the quality of feedback collected.

All testing sessions were conducted in Danish, as they took place in Denmark. Consequently, all participant quotes presented in this report have been translated from Danish to English. While every effort has been made to preserve the original meaning, some quotes may appear fragmented or imprecise due to the informal nature of children's speech and the challenges of direct translation.

During development, CircuitPython was selected as the primary programming language. This choice was made because the project relied on several Adafruit components, and CircuitPython, developed by Adafruit, is tightly integrated with their hardware ecosystem. This ensured seamless library support, simplified setup, and reduced the amount of low-level configuration required, which accelerated development and prototyping.

For hardware design, KiCad was used to design custom Printed Circuit Board (PCB) layouts. KiCad was chosen for its open-source nature, flexibility, and ability to produce precise schematics and layouts suitable for fabrication.

Fusion

To support potential replication or further development, a bill of materials is included as an appendix. This document outlines the components used in the project and demonstrates how cost-efficiency was achieved—one of the key design requirements.

Bill of hardware materials for one Controller:
#figure(
  table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: start,
  table.header([*Id*], [*Component*], [*Description*], [*Quantity*], [*Source*], [*Price*]),
  [], [_Electronics_],[],[],[],[],
  [1], [Raspberry Pi Pico W], [], [1], [@raspberrypidk_raspberry_nodate-1],[59 DKK],
  [2], [NFC reader], [], [1], [@arduinotechdk_rfid_2025],[40 DKK],
  [3], [Display], [], [1], [@pimoroni_pico_2025],[168 DKK],
  [4], [Potentiometer], [], [4], [@rs_components_bourns_nodate],[31 DKK],
  [5], [Switches], [], [8], [@nuphy_nuphy_2025],[20 DKK],
  [6], [Multiplexer], [], [1], [@arduinotechdk_74hc4051_2025],[8,75 DKK],
  [7], [USB B connector], [], [1], [@ardustoredk_usb_nodate-1],[3 DKK],
  [8], [On/off switch], [], [1], [@arduinotechdk_vippekontakt_2025],[8.75 DKK],
  [9], [Pinheader 8 holes], [], [1], [@digikey_pptc081lfbn-rc_2025],[3,63 DKK],
  [10], [Cable to Host], [], [1], [@av-cablesdk_usb_nodate],[45 DKK],
  [11], [Wires], [], [], [],[],
  [], [_Molex_],[],[],[],[],
  [1], [Molex 4-polet Straight Through Hole Pin Header], [], [1], [@rs_components_22-27-2041_nodate],[4,37 DKK],
  [2], [Molex 4-polet Female Connector Housing], [], [1], [@rs_components_22-01-3047_nodate],[1,75 DKK],
  [3], [Molex 2-polet Straight Through Hole Pin Header], [], [1], [@rs_components_22-27-2021_nodate],[2,25 DKK],
  [4], [Molex 2-polet Female Connector Housing], [], [1], [@rs_components_22-01-2021_nodate],[1,35 DKK],
  [5], [Molex Crimpterminal], [], [6], [@rs_components_08-52-0072_nodate],[6,5 DKK],
  [], [_Chassis_],[],[],[],[],
  [], [Black filament 290g], [],[], [],[],
  [], [White filament 18g], [],[], [],[],
  [], [Silver filament 22,5g], [],[], [],[],
  [], [_Sum_], [], [], [], [Too much DKK]
  ),
  caption: [Single Controller bill of materials.],
) <table:ControllerHardwareMaterials>


Bill of hardware materials for the Host:
#figure(
  table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: start,
  table.header([*Id*], [*Component*], [*Description*], [*Quantity*], [*Source*], [*Price*]),
  [1], [Raspberry Pi Pico 2 W], [],[1], [@raspberrypidk_raspberry_nodate],[69 DKK],
  [2], [Breadboard], [],[1], [@arduinotechdk_breadboard_2025],[30 DKK],
  [3], [NeoPixel], [],[1], [@adafruit_breadboard-friendly_2025],[10,5 DKK],
  [4], [Resistor 82k$Omega $], [],[2], [@rs_components_rs_nodate],[0,18 DKK],
  [5], [USB A connector], [],[alt efter hvor mange skal connectes], [@ardustoredk_usb_nodate],[8 DKK],
  [6], [Cable to pico], [],[1], [@raspberrypidk_officiel_nodate],[39 DKK],
  [7], [Wires], [],[], [],[],
  [], [_3D printet enclosure_], [],[], [],[],
  [], [Black filament 175g], [],[], [],[],
  [], [Green filament 3,5g], [],[], [],[],
  ),
  caption: [Host],
) <table:HostHardwareMaterials>

