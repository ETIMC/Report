= Evaluation
/* - Hvad har vi lavet for at løse problemstillingen (stadiet af produktet på nuværende tidspunkt)
- Objektivt set!
  - To controllers
  - En host
  - Ableton Live
  - Kablet version og ikke WiFi
  - 3D prints (kasse, knobs, knapper)
  - NFC kort implementation for at skifte instrument
*/
/* Rebekka ChatGpttttt
The current state of the product consists of two physical Controllers and a dedicated host device. These components work together to allow cooperative musical interaction through physical engagement with hardware elements.
*/

// Jamie
A physical hardware interface prototype was created to research if such a product could facilitate music creation through curiosity-driven, playful and exploratory interactions. This hardware interface consists of the following:

// David
The prototype consists of two Controllers and a dedicated Host device. The Controllers work by having eight buttons, four low height potentiometers and a NFC reader the user can interact with, all connected to a Pico 1. By inserting NFC cards, each assigned an instrument, the user could use seven of the eight buttons to play notes, harmonically fitting together, using the instrument's sounds. The eighth button activated the NFC reader. The four potentiometers is used to change the volume, delay, reverb and an amp effect differing from instrument to instrument for the selected instrument. Furthermore, a display is used to show custom pixelart images of the selected instruments. Lastly, the Controller contains a power switch on the back and a USB 2.0 Type B port for connecting it to the Host, which also provides power.

// David
All the previously mentioned components are soldered to a custom designed professionally manufactured PCB. The PCB has two layers allowing the buttons, potentiometers and display to be mounted on the top side facing the user, while the Pico 1 and other smaller electrically required components are mounted on the bottom.

// David
The Controller's chassis is 3D printed in PLA and is designed to be modular. It consists of a plane with four corners with slits for mounting different side panels. Two of the side panels are plain, one side has a hole for inserting NFC cards and the last side has holes for the power switch and USB connector. Furthermore, the chassis contains a custom designed mounting mechanism for the NFC reader letting inserted NFC cards sit closely to it to ensure correct functionality. The chassis also contained four standoffs aligned with holes on the PCB, allowing the PCB to be mounted inside the chassis close to the top. Lastly, the chassis' lid was designed to align with the PCBs' soldered components, having holes for the buttons, potentiometers and display. The lid has a decorative design, with music notes and swirls. There are also custom 3D printed knobs mounted on the potentiometers and keycaps on the buttons. 

// David
The Host consists of a Pico 2 connected to two NeoPixel LEDs used for debugging and to the Controllers via a USB 2.0 Type A to B cable assembled on a breadboard. The Host is also connected to a computer running Live via micro-USB for communication and power. The host communicates with the Controllers using I²C, receiving messages regarding users' interactions, processing them, converting them to MIDI and sending them to Live. It is Live's job to receive the MIDI messages and convert them to audio.

A 3D printed enclosure was made for the Host to stabilize the breadboard and USB type A connectors. The lid on the enclosure has the text "HOST" with a hole in the 'O' to see the NeoPixel LEDs.

/*
// Rebekka
The Controller works by turning the Controller on, using the power switch. And then inserting one of the NFC cards, which act as different instruments, and pressing the corresponding reading button. When the card is read by the NFC reader, the display takes over and prints an .BMP image of the chosen instrument. Then, music can be played by pressing the seven buttons and turning the four low height potentiometers. All of these components are soldered to the topside of the PCB and act together with a pico soldered to the other side of the PCB. 

// Rebekka
The Controller's physical form was 3D printed in PLA, designed to be modular. Its base was a plane, four corners with a sliding mechanism, four PCB standoffs, and the NFC reader holder. Four sides, which slid into the corners, where two sides were plain, one side had a hole for the NFC card's insertion, and one side for the power switch and the USB-B cable connector. The lid matched the alignment of the PCB's components. The lid had a decorative design, with music notes and swirls. There were also added custom 3d printed knobs to the potentiometers and keycaps to the buttons. 

// Rebekka
The Controller were connected with a cable to the Host, where the power came from. The Host was a Pico 2 W which were placed on a breadboard, with two neopixels for visual debugging. It was connected to a computer, where Live (Ableton) was run, to be able play the music. The Host gets user input from the Controllers and converts it to MIDI messages, which is sent to Live and then gives musical feedback. A 3D printed enclosure was also made, which could hold the breadboard and had holes for the cables for the computer and Controllers. The lid had text on saying "HOST", with a hole in the 'O' to see the neopixels.

ABLETON
*/
/*
- Controllers
  - Integrere med
    - Switches med 3d printede keycaps
      - en knap til at læse kort
      - resten spiller musik
        - toner som passer sammen
    - Pots (lave) med 3d printede knobs + pots funktion
    - Skærm - feedback
    - NFC læser + kort
  - elektronik indeni
    - pico, styrer alt
    - on/off knap
  - kassen
    - modelleret i fusion 360 
    - printet med pla
    - designet modulær, aftagelige sider
      - sider: normal x2, nfc side, bagside (power knap + usbB connector)
    - hjørner med sliding slits og magnet plads
    - holder til NFC læser
    - standoffs til PCB
    - låg - huller til ting + dekoration

  controllersne kablet til host

- Host
  - pico 2W + breadboard
  - bus-powered (through computer)
  - 2 neopixels for visual debugging and system state feedback
    - Connection LED: Shows different colors/blinking patterns based on connection status (booting, connected, disconnected).
    - MIDI Clock LED: Blinks in sync with MIDI clock messages from Ableton Live (e.g., 24 pulses per beat).
  - lyd gennem ableton
  - The Host acts as a central communication hub between the controllers and the DAW (Ableton Live)
    - modtager input fra controllerne (knap tryk, instrument ændringer)
    - oversættes til MIDI messages
    - Sends MIDI to Live via USB
    - håndtere alt
  - enclosure 3d printed
    - huller til kabler (4xusb + computer connecter)
    - låg med design tekst + hul for LED
*/