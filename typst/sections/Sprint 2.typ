#import "@preview/subpar:0.2.2"

During sprint 1 the team planned and began the prototyping of the product. Design choices where made which included that the system would consist of a host device, and one or more controller devices communicating via wifi. Capabilities of making the controller modular, such as experimentation with an NFC reader for deciding the instrument played, and a display visualizing the choice was initiated during the prior sprint. The team also created a paper prototype where a test was held to gather feedback that could then be taken into consideration #text(red)[highlight which parts we used during this sprint to guide the development!]. The sprint successfully established that the components were usable in stand-alone implementations.

== Focus of Sprint 2
For this sprint the team wanted to interconnect the individual components into a functional breadboard prototype. This for example meant that choosing an instrument using an NFC card would trigger the screen to display a picture of the selected instrument, and change the sounds played through Ableton.

== Host MIDI interface
During early host development, two diagrams (@fig:diagramMessageFlow) were drafted to clarify controller-to-host interactions. One diagram illustrated how input signals (button presses and potentiometer turns) should be sent to, and processed by, the host (@fig:DevicePlayingDiagram). Controllers were required only to emit a simple message identifying the activated input; all higher-level processing would occur on the host.

The host was designed around three lookup tables: a controller-to-instrument map, an instrument-to-MIDI-channel map, and an instrument-specific table of controller-button to MIDI-note assignments. When a message arrived indicating, for example, that Controller A’s Button 1 was pressed, the host would determine Controller A’s assigned instrument (@listing:receivedNote:5), select that instrument’s MIDI channel (@listing:receivedNote:6), look up the MIDI note tied to Button 1 for that instrument (@listing:receivedNote:8), and forward a corresponding MIDI message on the correct channel to Ableton Live (@listing:receivedNote:9). To change instruments, controllers sent special messages indicating the desired instrument; the host then updated the controller-to-instrument map accordingly (@fig:ChangeSoundDiagram). By pre-allocating one channel per instrument, sound changes required no additional latency—messages simply switched channels—ensuring seamless, low-latency response as required by the low latency technical requirement (requirement 9, @table:technicalRequirements).



- Sounds in Ableton (Native Instruments)
  - Choice of specific sounds

#subpar.grid(
  columns: (auto, auto),
  caption: [Diagrams showing message flow.],
  label: <fig:diagramMessageFlow>,
  align: top,
  figure(image("../images/DevicePlayingDiagram.png", width: 98%),
    caption: [Message flow when using Controller.]), <fig:DevicePlayingDiagram>,
  figure(image("../images/ChangeSoundDiagram.png", width: 100%),
    caption: [Message flow when changing instrument.]), <fig:ChangeSoundDiagram>
)

#figure(
  ```cpy
  def _received_note(self, socket, buffer):
        try:
            parts = buffer.split(b":")
            note_idx = bytes(parts[1].strip())
            instrument = self.client_instruments[socket]
            channel = self.instrument_channels[instrument]
            if note_idx in self.instrument_notes.get(instrument, {}):
                note = self.instrument_notes[instrument][note_idx]
                self.midi_handler.add_to_queue(note, channel)
            else:
                print(f"Unknown note index: {note_idx} for instrument {instrument}")
        except Exception as e:
  ```,
  caption: [`_received_note(socket, buffer)` function on Host for processing Controller input messages.]
) <listing:receivedNote>

#figure(
  [BILLEDE FRA ABLETON],
  caption: [Ableton Live 11 setup for playing playing different instruments on different MIDI channels.]
) <fig:abletonFourInstrument>

== Circuitry schematics
A schematic was created to provide an overview of the internal wiring of the controller and to ensure correct and consistent integration of the system’s components (#text(red)[reference til bilag]. This step was essential to validate that all hardware elements could function together as intended and that the correct GPIO pins on the Pico were used.
The schematic brings together all the hardware elements of the controller: 
- NFC reader (RC522)
- Display (Pico Display 2.0)
- Push buttons
- Potentiometers via multiplexer
- LEDs (NeoPixels)
- Power system
This schematic served as a key step in moving from individual hardware tests to a fully integrated prototype.





== Breadboard prototype

=== General setup of Controller
- Interconnecting different elements of the project together.

==== Display

==== NFC Reader
- Many problems
  - Code from sprint 1, did not work, when implemented on the breadboard with the other components...
- Tested and tried different code examples, but RFID reader could not properbly do it
  - Maybe because overbelastning?
- Implemented on "clean" breadboard (away from other components) 
  - Found new library from https://github.com/domdfcoding/circuitpython-mfrc522
    - Made it easier
    - Simple code - push button to read card
      - Importent line! 'rfid.init()' which reinitialize the RFID module
        - Does not work properly without that line!
      - Initializes the RFID reader (MFRC522) by setting up the necessary pins for SPI communication (SCK, MOSI, MISO, RESET, and Chip Select)
      - Button to trigger trying to read (button pressed = active low = reading)
        - Code sends request to check if there is a card
          - Presented card - retrieves the cards UUID (uniques identifier)
          - Converts the UUID into a hex string, so it can be compared with the card_label
            - If cards UUID matches, print result
        - After reading card (whether it was known or unknown), the code reinitializes the RFID reader to prepare for the next read. This ensures that the system remains stable and can read cards correctly over time

==== SPI Issues
  
==== Buttons
- Setup buttons on breadboard.

==== Potentiometers and multiplexer

- Potentially put on potentiometers, and figure out functionality.
- Tested multiplexer in its own circuit with three LED's, which worked! (to test its functionality)

=== General setup of Host

==== Visual feedback
During development and internal testing it was discovered that it was difficult to debug the connection between the controller and the host as both would have to be physically connected to a computer running an instance of Visual Studio Code each to monitor the REPL. To make this debugging easier and to further device feedback (requirement 4, @table:usabilityRequirements) it was decided that the host should have two LED's for displaying the system's current state.

The LED's chosen were the _Breadboard-friendly RGB Smart NeoPixel_ #cite(<adafruit_breadboard-friendly_2025>). These were chosen for their availability, flexibility and affordable pricing. By using NeoPixel LED's it became possible to control multiple LED's using only GPIO on the host Pico 2. Furthermore, the _RGB Smart NeoPixel_ LED's are full RGB LED's meaning a single LED can display a wide array of colors. Lastly, as both the NeoPixel LED's and CircuitPython are made by Adafruit, a first-party library made them easy to integrate #cite(<george_adafruit_2025>).

It was decided that that the first LED should be used for connection states. It was programmed to blink yellow while the Host was turning on and setting up it's WiFi hotspot. Upon successfully turning on the LED would turn green.
When a controller connected to the Host the LED would blink blue, and when it disconnected the LED would blink purple (@listing:handleNewConnectionLed). This was done to monitor the connection of the host and controller without needing to have them both connected to a computer.

#figure(
  ```cpy
  async def handle_new_connection_led():
    last_stations_len = len(wifi.radio.stations_ap)
    while True:
        current_stations_len = len(wifi.radio.stations_ap)
        if current_stations_len > last_stations_len: # New device
            for _ in range(3): # Blink blue
                await set_led(0, 0, 20)
                await asyncio.sleep(0.25)
                await set_led(0, 0, 0)
                await asyncio.sleep(0.25)
            await set_led(20, 20, 0)
        elif current_stations_len < last_stations_len: # Lost device
            for _ in range(3): # Blink purple
                await set_led(20, 0, 20)
                await asyncio.sleep(0.25)
                await set_led(0, 0, 0)
                await asyncio.sleep(0.25)
            await set_led(20, 20, 0)
        last_stations_len = current_stations_len
        await asyncio.sleep(1)
  ```,
  caption: [`handle_new_connection_led()` method on Host, blinking an LED when a client connects or disconnects.]
) <listing:handleNewConnectionLed>

The second LED was programmed to display MIDI information. In practice this meant that it would blink according to the MIDI `TimingClock` message sent by Ableton to the Host.

== Wireless connectivity and message handling

== Fusion 3D Experimentation
- Design chassis (sketches first)
- First button/pad designs
- Possibly potentiometer handles

== Pixelart for the display
#figure(
  image("../images/pixel-art.png", height: 20%),
  caption: [Instrument Pixel Art],
) <fig:pixelart>

All visual assets used for the display were created specifically for the project, as it was discovered during testing that the Picos had limited storage capacity and that the chosen display module required the picture format to be in bitmap (.BMP) format #text(red)[cite] for proper image rendering. Common image formats were incompatible, and the availability of suitable .BMP files was limited. Consequently, the team produced the required imagery using Aseprite #text(red)[cite], a tool suited for pixel art creation. This application was selected due to its ability to export compatible files, precise scaling for the display's resolution, and prior familiarity with the software. In addition, the pixel art style was considered suitable for the target audience, due to its playful and accessible visual expression– it would also be used to fulfill requirements 3 and 11 in @table:usabilityRequirements.

For the initial breadboard implementation, two instrument images– a drum and a piano– were created as seen in @fig:pixelart. Feedback obtained during testing indicated interest in additional instruments, specifically a guitar and a trumpet. These images were subsequently developed and included in the system later in the development process.

== Testing on the Target Group
The test was conducted at the University of Southern Denmark, where the prototype was evaluated by five individual participants. All participants fell within the age range of the intended target group. The testing procedure consisted of a think-aloud part, where testers could experiment using the product while providing feedback. This was followed by an unstructured interview. These methods were selected for their adaptability, which proved particularly beneficial given that the participants were children. This flexibility allowed the children to guide parts of the session by posing questions, offering detailed feedback, or requesting additional guidance on the use of the product and its features. On average, each testing session lasted approximately 10 minutes.

Before the test took place, the team developed a set of standardized questions that were posed to all participants. This approach ensured consistency and allowed specific areas of interest to be thoroughly explored and assessed.

In one instance, two participants were present in the room simultaneously; however, they completed the test individually and responded to the predefined questions together afterward. All remaining sessions involved one participant at a time.

During the test, the main focus points were: 
1. Testing the breadboard implementation and getting feedback on usability as seen in @fig:sprint2setup.
2. Testing which buttons were preferred by the testers.
3. Showcasing the paper-prototype and getting feedback on colorschemes and dimensions.

#figure(
  image("../images/sprint2-test-setup.png", height: 20%, width: 70%),
  caption: [Test Setup for Sprint 2],
) <fig:sprint2setup>

*Summarized Feedback:*

All participants expressed an enjoyment of playing music. Two noted that they regularly played on keyboards at home. None of the testers had received formal instruction through a music school or similar program. Those without prior experience playing an instrument showed a clear interest in learning. Additionally, all testers found the product intuitive and easy to use, with no reports of confusion or difficulty. Universally, the product was described as fun and engaging.

*Specific Feedback Points:*

1 SWITCHES
- Five out of six testers expressed a preference for the keyboard switches over the switches used on the breadboard. 
2 VISUAL FEEDBACK
- All testers responded positively to the idea of incorporating LEDs in different colors. 
- One tester suggested dark colors (Winter colors) for lower notes and lighter (Spring colors) for higher notes if the LEDs were placed by the buttons. 
3 NFC READER PLACEMENT AND INTERACTION
- All testers preferred inserting the NFC card on the right-hand side of the product. Upon further inquiry, it was revealed that all participants were right-handed, suggesting this preference may be due to handedness bias.
- Alternative suggestions included:
  - Swiping the card along the front of the product to trigger instrument changes.
  - Simply placing the card on top of the device to activate a new instrument.
4 POTENTIOMETERS
- All testers found the potentiometers somewhat confusing and challenging to use.
- The difficulty stemmed from their small size and limited range of rotation due to a built-in stopper, which restricted the degree of movement.
5 DURABILITY CONCERNS
- One tester expressed concern about the potential for the device to be damaged if objects other than the NFC card were inserted.
- The same tester also mentioned worrying about the product being easily damaged if dropped.
6 COLLABORATIVE PLAY
- All testers expressed enthusiasm about playing music with others.
- However, one tester raised a concern that if all users played the same instrument simultaneously, it might become irritating. They suggested that using different instruments would make the experience more enjoyable.