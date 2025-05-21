#import "@preview/subpar:0.2.2"
#import "@preview/codly:1.3.0": *

During sprint 1 the team planned and began the prototyping of the product. Design choices where made which included that the system would consist of a host device, and one or more controller devices communicating via wifi. Capabilities of making the controller modular, such as experimentation with an NFC reader for deciding the instrument played, and a display visualizing the choice was initiated during the prior sprint. The team also created a paper prototype where a test was held to gather feedback that could then be taken into consideration #text(red)[highlight which parts we used during this sprint to guide the development!]. The sprint successfully established that the components were usable in stand-alone implementations.

== Focus of Sprint 2
For this sprint the team wanted to interconnect the individual components into a functional breadboard prototype. This for example meant that choosing an instrument using an NFC card would trigger the screen to display a picture of the selected instrument, and change the sounds played through Ableton.

== WiFi problems <sec:sprint2WifiProblems>
During further WiFi connectivity tests between the Host and a Controller, the Host’s WiFi driver would crash unpredictably, often within a minute of establishing a connection. This instability generated significant confusion, leading to doubts about the viability of WiFi as the communication protocol of choice. As a fallback, Bluetooth was briefly trialed, but its inherent latency was incompatible with the low-latency requirement (Requirement 9, @table:technicalRequirements).

Debugging eventually uncovered a pattern: only a full power cycle of the Pico 2 before initiating the WiFi connection yielded a stable result. In contrast, soft reboots from the REPL almost invariably triggered driver failures shortly thereafter, particularly when performed in rapid succession. By adopting a strict procedure of completely disconnecting and reconnecting power to the Host prior to each WiFi session, the driver crashes ceased entirely, restoring reliable performance.

During internal testing it was also discovered that there was a small but noticeable delay from pressing buttons on the Controller to a sound was played by Ableton Live. The delay was minimized somewhat by tweaking asyncio delay lengths, making the Host query for notes more often. In the end, however, it was concluded that the primary delay was caused by using the TCP protocol, which contains a extra headers and acknowledgement messages adding overhead to each sent message over WiFi. It was decided that TCP should be exchanged for UDP, which has less overhead, during the next sprint.

Lastly, it was sometimes experienced that a controller would disconnect from the host without the host ever finding out. To fix this, heartbeat-messages were implemented. They worked by having the host sending a heartbeat request message to the controller every few seconds. If the controller didn't answer the heartbeat three times in a row, the Host would forget the Controller.

== Host MIDI interface
During early host development, two diagrams (@fig:diagramMessageFlow) were drafted to clarify controller-to-host interactions. One diagram illustrated how input signals (button presses and potentiometer turns) should be sent to, and processed by, the host (@fig:DevicePlayingDiagram). Controllers were required only to emit a simple message identifying the activated input; all higher-level processing would occur on the host.

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

The host was designed around three lookup tables: a controller-to-instrument map (@listing:lookUpTables2Instr:1), an instrument-to-MIDI-channel map (@listing:lookUpTables2Instr:2), and an instrument-specific table of controller-button to MIDI-note assignments (@listing:lookUpTables2Instr:6) which trialed used the `note_parser()` function from the MIDI library #cite(<walters_adafruit_2025>) to convert the name of the notes to the right MIDI number. When a message arrived indicating, for example, that Controller A’s Button 1 was pressed, the host would determine Controller A’s assigned instrument (@listing:receivedNote:5), select that instrument’s MIDI channel (@listing:receivedNote:6), look up the MIDI note tied to Button 1 for that instrument (@listing:receivedNote:8), and forward a corresponding MIDI message on the correct channel to Ableton Live (@listing:receivedNote:9). To change instruments, controllers sent special messages indicating the desired instrument; the host then updated the controller-to-instrument map accordingly (@fig:ChangeSoundDiagram). By pre-allocating one channel per instrument, sound changes required no additional latency—messages simply switched channels—ensuring seamless, low-latency response as required by the low latency technical requirement (Requirement 9, @table:technicalRequirements).

#figure(
  ```cpy
  self.client_instruments = {}
  self.instrument_channels = {
      "DRUMS": 1,
      "PIANO": 2,
  }
  self.instrument_notes = {
      "DRUMS": {
          b"0": note_parser("D#2"),  # 39 - Hand Clap
          b"1": note_parser("F#2"),  # 42 - Closed Hi-Hat
          b"2": note_parser("G#2"),  # 44 - Tambourine
          b"3": note_parser("C2"),  # 36 - Bass Drum
          b"4": note_parser("D2"),  # 38 - Snare Drum
          b"5": note_parser("A#2"),  # 46 - Open Hi-Hat
          b"6": note_parser("C#3"),  # 49 - Crash Cymbal
          b"7": note_parser("D#3"),  # 51 - Ride Cymbal
      },
      "PIANO": {
          b"0": note_parser("C4"),  # 60 - Middle C
          b"1": note_parser("E4"),  # 64
          b"2": note_parser("G4"),  # 67
          b"3": note_parser("C5"),  # 72
          b"4": note_parser("E5"),  # 76
          b"5": note_parser("G5"),  # 79
          b"6": note_parser("C6"),  # 84
          b"7": note_parser("E6"),  # 88
      }
  }
  ```,
  caption: [Look-up table on Host.]
) <listing:lookUpTables2Instr>

The lookup table mapping controller button-presses to MIDI notes was defined to guarantee harmonic consistency (Requirement 7, @table:usabilityRequirements). Two octaves of the C-major triad were selected so users could access both high and low pitches without additional configuration. To support a future use case where a potentiometer might shift octaves, a pentatonic scale was considered—its five notes per octave offering broader melodic flexibility without risking dissonance #cite(<farrant_what_2020>).


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

The sending of notes themselves was driven by a programmatic queue. When a controller registered a button input a message with the new instrument was sent to the Host. This message would undergo the previously mentioned processing before being added to a queue (@listing:receivedNote:9). The way the queue was emptied was quite interesting. When the "Play" button in Ableton Live was pressed it would begin sending 24 `TimingClock` messages to the host per beat. This means that if Ableton Live was set to play at 120 BPM the message would be received by the Host $24 dot 120 = 2880$ times a minute. By counting these messages and only emptying the queue, sending the MIDI messages to the host, every 24 `TimingClock` messages, the Controllers input was quantized to the beat, overlooking potential timing-mishaps by the user (requirement 7, @table:usabilityRequirements). It was however also discovered that this didn't "feel" as nice to use as when the MIDI signals were immediately send to Ableton and the feedback heard instantly. This was also the case when emptying the queue every half-beat (every 12 `TimingClock` messages). For this reason, this feature was turned off during testing on the target group.

== Ableton Live setup
In Ableton Live a new project was set up with four MIDI tracks. Each track was assigned a different input MIDI channel. Each track was then given an instrument (@fig:abletonFourInstrument). The four instruments were drums, piano, guitar and trumpet. These instruments were chosen as they were easily recognizable, very different sounding, and their real counterparts very different looking.

During the configuration of Ableton Live, it was decided to not prioritize looping functionality (Requirement 9, @table:usabilityRequirements). This decision was made since Ableton Live already implements looping. Therefore it seemed wiser to focus on other aspects of the product as the user would already be able to use looping by using the required instance of Ableton Live.

#figure(
  [BILLEDE FRA ABLETON PÅ DAVIDS BÆRBAR],
  caption: [Ableton Live 11 setup for playing playing different instruments on different MIDI channels.]
) <fig:abletonFourInstrument>

== Circuitry schematics
A schematic was created to provide an overview of the internal wiring of the controller and to ensure correct and consistent integration of the system’s components (#text(red)[reference til bilag (Schematic sprint 2)]). This step was essential to validate that all hardware elements could function together as intended and that the correct GPIO pins on the Pico were used.
The schematic brings together all the hardware elements of the controller: 
- NFC reader (RC522)
- Display (Pico Display 2.0)
- Push buttons
- Potentiometers via multiplexer
- LEDs (NeoPixels)
- Power system

The schematic served as a key step in moving from individual hardware tests to a fully integrated prototype.

== Breadboard prototype
By following the schematic, all components were successfully connected on a breadboard to simulate the controller's functionality and test how the individual parts interacted.

- Interconnecting different elements of the project together.
- både host og controller

=== General setup of Controller

==== Buttons
- Setup buttons on breadboard.
- som nævnt i sprint 1, bruges pull-up resistor, sat op som schematic
- tilføjet kode om at man trykker på knapper - sender besked til hosten (ikke yddyb for meget, blot knap 1 sender "jeg er 1")
- Noget om knap koden (asyncio) + gammel debouncing (David)

==== NFC Reader

- sættes sammen på breadboard med resten
- Opdager at DEN tager for meget tid (blokere resten af koden, scanner hele tiden) (pt. uden læse knap) (eksperimentation, andre bib og timeout værdi)
  - På trods af brug a asyncio (nævnt tidliger)
  - Løst ved læse knap (sensor) for at scanne (nævn i testen at børnene glemte at bruge den, så det måske skal laves om til automatisk sensor)
- slutning: sender wifi besked til hosten, om hvilket instrument der skal spilles

/*
When integrating the NFC reader into the controller breadboard setup, numerous problems were encountered. Although the module had worked in earlier isolated tests, the code failed to function properly when implemented alongside the other components. Several alternative code examples were tested, but the reader consistently failed to return reliable results. It was suspected that the reader was experiencing overload from continuous polling since it happened every 50 milliseconds.

To isolate the issue, the NFC reader was temporarily moved to a clean breadboard, disconnected from the rest of the system. This allowed for targeted experimentation. During this process, a new library circuitpython-mfrc522 #text(red)[kilde] was discovered. The library proved more stable and easier to work with compared to the previously used codebase.

Instead of polling continuously, the revised implementation introduced a physical button that triggered card reads only when pressed. This resolved the suspected overload issue. Additionally, the library required the reader to be explicitly re-initialized with rfid.init() before each read; omitting this line caused the reader to behave unpredictably over time. The updated code also configured the reader for SPI communication using the necessary pins (SCK, MOSI, MISO, RESET, and Chip Select). When a card was presented, the reader retrieved its UUID, converted it into a hexadecimal string, and compared it against predefined labels. After each read—regardless of whether the card was recognized—the reader was re-initialized to maintain system stability.

With these changes, the NFC reader began functioning reliably and was subsequently reconnected to the main controller breadboard for continued integration and testing.

Using this library, a simplified script was developed where a physical button was used to trigger each read attempt, instead of polling continuously. Pressing the button would initiate the card check. The following adjustments were made to ensure stable operation:

    The NFC reader was explicitly re-initialized on each read using the rfid.init() command. This line turned out to be critical; without it, the module failed to operate correctly over time.

    The script initialized the MFRC522 module for SPI communication by setting up the required pins: SCK, MOSI, MISO, RESET, and Chip Select.

    When a card was presented, the module retrieved its UUID, converted it into a hexadecimal string, and compared it against predefined card labels.

    Regardless of whether the scanned card was recognized, the module was re-initialized after every read, ensuring consistent performance in subsequent reads.

These changes resolved the earlier issues. The NFC reader operated reliably under the new setup and was subsequently reintegrated into the controller’s main breadboard circuit for continued development and testing.


When the NFC reader was connected to the breadboard, several issues arose. The code used during earlier experimentation no longer functioned as expected, which led to the need for further testing with alternative implementations. 


It appeared that the NFC reader was being overloaded by continuous read attempts. 

To address this new libraries was experienced with. The library by (#text(red)[kilde]) was chosen, which simplified the code and made it easier to work with. A button was introduced to trigger card reads only when pressed, replacing the previous setup where the reader constantly polled for cards.

This change resolved the issue, and the NFC reader began functioning reliably again. It was then reconnected to the main controller breadboard for continued integration and testing.
*/
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


==== Display

aktiveres af NFC læser + evt. kode derfra

==== SPI Issues

efter skærmen er sat til nfc ustabil
  tog tid før at vi fandt ud af at det var skærmen der var problemet
prøvede forskjellige ting - bla. om det er fordi de begge bruger den samme indbygede timer på picoen
  sandsynligvist pga deling af spi bus, bib understøttede ikke delt spi bus
Beslutning til test: skærm for sig selv, med egen pico

beslutning om ændring: skærm og nfc skal have hver deres spi bus


==== Potentiometers and multiplexer

- Potentially put on potentiometers, and figure out functionality.
- Tested multiplexer in its own circuit with three LED's, which worked! (to test its functionality)

=== General setup of Host
The Host was very simply implemented on a breadboard as it only consisted of a Pico 2. By using WiFi no other wires had to be added. However, difficulties arose that led to adding LED's to the Host breadboard prototype.

==== Visual feedback
During development and internal testing it was discovered that it was difficult to debug the connection between the controller and the host as both would have to be physically connected to a computer running an instance of Visual Studio Code each to monitor the REPL. To make this debugging easier and to further device feedback (requirement 4, @table:usabilityRequirements) it was decided that the host should have two LED's for displaying the system's current state.

The LED's chosen were the _Breadboard-friendly RGB Smart NeoPixel_ #cite(<adafruit_breadboard-friendly_2025>). These were chosen for their availability, flexibility and affordable pricing. By using NeoPixel LED's it became possible to control multiple LED's using only GPIO on the host Pico 2. Furthermore, the _RGB Smart NeoPixel_ LED's are full RGB LED's meaning a single LED can display a wide array of colors. Lastly, as both the NeoPixel LED's and CircuitPython are made by Adafruit, a first-party library made them easy to integrate #cite(<george_adafruit_2025>).

It was decided that that the first LED should be used for connection states. It was programmed to blink yellow while the Host was turning on and setting up it's WiFi hotspot. Upon successfully turning on the LED would turn green.
When a controller connected to the Host the LED would blink blue, and when it disconnected the LED would blink purple (@listing:handleNewConnectionLed). This was done to monitor the connection of the host and controller without needing to have them both connected to a computer and was implemented by monitoring the amount of devices connected to the Host's hotspot (@listing:handleNewConnectionLed:4).

#codly(
  annotations: (
    (
      start: 5,
      end:  11,
      content: block(
        width: 20em,
        align(left, box(width: 100pt)[Blink LED blue if there are more devices than last check.])
      )
    ),
    (
      start: 12,
      end:  18,
      content: block(
        width: 20em,
        align(left, box(width: 100pt)[Blink LED purple if there are less devices than last check.])
      )
    ),
  )
)
#figure(
  ```cpy
  async def handle_new_connection_led():
    last_stations_len = len(wifi.radio.stations_ap)
    while True:
        current_stations_len = len(wifi.radio.stations_ap)
        if current_stations_len > last_stations_len:
            for _ in range(3)
                await set_led(0, 0, 20)
                await asyncio.sleep(0.25)
                await set_led(0, 0, 0)
                await asyncio.sleep(0.25)
            await set_led(20, 20, 0)
        elif current_stations_len < last_stations_len:
            for _ in range(3):
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

== Fusion 3D Experimentation
- Design chassis (sketches first)
- First button/pad designs
- Possibly potentiometer handles

== Pixelart for the display
#figure(
  image("../images/pixel-art.png", height: 20%),
  caption: [Instrument Pixel Art],
) <fig:pixelart>

All visual assets used for the display were created specifically for the project, as it was discovered during testing that the Picos had limited storage capacity and that the chosen display module required the picture format to be in bitmap (.BMP) format #text(red)[cite] for proper image rendering. Common image formats were incompatible, and the availability of suitable .BMP files was limited. Consequently, the team produced the required imagery using Aseprite #cite(<igara_studio_aseprite_2025>), a tool suited for pixel art creation. This application was selected due to its ability to export compatible files, precise scaling for the display's resolution, and prior familiarity with the software. In addition, the pixel art style was considered suitable for the target audience, due to its playful and accessible visual expression– it would also be used to fulfill requirements 3 and 11 in @table:usabilityRequirements.

For the initial breadboard implementation, two instrument images– a drum and a piano– were created as seen in @fig:pixelart. Feedback obtained during testing indicated interest in additional instruments, specifically a guitar and a trumpet. These images were subsequently developed and included in the system later in the development process.

== Testing on the Target Group
The test was conducted at the University of Southern Denmark, where the prototype was evaluated by five individual participants. All participants fell within the age range of the intended target group. The testing procedure consisted of a think-aloud part, where testers could experiment using the product while providing feedback. This was followed by an unstructured interview. These methods were selected for their adaptability, which proved particularly beneficial given that the participants were children. This flexibility allowed the children to guide parts of the session by posing questions, offering detailed feedback, or requesting additional guidance on the use of the product and its features. On average, each testing session lasted approximately 10 minutes.

In one instance, two participants were present in the room simultaneously; however, they completed the test individually and responded to the predefined questions together afterward. All remaining sessions involved one participant at a time.

#figure(
  image("../images/sprint2-test-setup.png", height: 20%, width: 70%),
  caption: [Test Setup for Sprint 2],
) <fig:sprint2setup>

All participants demonstrated a clear enjoyment of musical engagement. Two individuals indicated prior familiarity with keyboard instruments, noting regular usage at home, while none had received formal music education through institutions such as music schools. Participants without previous experience in playing instruments expressed a curiosity and interest in learning. Across the board, testers described the product as intuitive, easy to navigate. No confusion or operational difficulties were reported during interaction with the prototype.

Various A/B tests were conducted. In one to determine which switch to use in the final rendition of the product, five of the six participants indicated a preference for the keyboard-style switches over those integrated into the breadboard configuration as seen in @fig:sprint2setup. Another test had the aim of determining the best placement of the NFC reader. Participants favored the positioning of the card reader on the right-hand side of the device. Upon asking, it emerged that all participants were right-handed, raising the possibility of a handedness bias influencing the preference. Additionally, another interaction method was proposed by a participant, which included "swiping" the NFC card along the front panel.

When asked about how to further incorporate visual feedback, all testers responded positively to the idea of incorporating LEDs, some specifying that color-coded placement near the buttons would be beneficial to enhance association with the pitch of notes as described in the following quote: #quote[Then you could have different colors, like, for the sounds. So if they were deep sounds, they could be dark blue, and if there were lighter ones, they could be light colors, like spring colors. The dark tones could then be winter colors.] (translated from Danish to English) #text(red)[reference to appendix].

Durability was briefly addressed by one participant, who raised concerns about the potential for damage if inappropriate objects were inserted into the NFC slot #quote[Can you put other stuff into it? [...] so that it says kaboom?] (translated from Danish to English) #text(red)[appendix reference] or if the device were to be dropped #quote[But what about switches? What if they fall off if you accidentally drop it from the Eiffel Tower?] (translated from Danish to English) #text(red)[appendix reference].

Interaction with potentiometers emerged as an area of concern as participants found them unintuitive and awkward to handle, largely due to their compact physical dimensions and the limited rotational range. Finally, the concept of collaborative play elicited uniformly positive reactions, with all testers expressing enthusiasm about a shared music-making experience. However, one participant noted that simultaneous use of identical instrument sounds could lead to an uncomfortable auditory experience.