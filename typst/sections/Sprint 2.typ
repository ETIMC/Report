#import "@preview/subpar:0.2.2"
#import "@preview/codly:1.3.0": *

During sprint 1 the team planned and began the prototyping of the product. Design choices where made which included that the system would consist of a host device, and one or more controller devices communicating via wifi. Capabilities of making the controller modular, such as experimentation with an NFC reader for deciding the instrument played, and a display visualizing the choice was initiated during the prior sprint. The team also created a paper prototype where a test was held to gather feedback that could then be taken into consideration #text(red)[highlight which parts we used during this sprint to guide the development!]. The sprint successfully established that the components were usable in stand-alone implementations.

For this sprint the team wanted to interconnect the individual components into a functional breadboard prototype. This for example meant that choosing an instrument using an NFC card would trigger the screen to display a picture of the selected instrument, and change the sounds played through Ableton.

== WiFi problems <sec:sprint2WifiProblems>
During further WiFi connectivity tests between the Host and a Controller, the Host’s WiFi driver would crash unpredictably, often within a minute of establishing a connection. This instability generated significant confusion, leading to doubts about the viability of WiFi as the communication protocol of choice. As a fallback, Bluetooth was briefly trialed, but its inherent latency was incompatible with the low-latency requirement (Requirement 9, @table:technicalRequirements).

Debugging eventually uncovered a pattern: only a full power cycle of the Pico 2 before initiating the WiFi connection yielded a stable result. In contrast, soft reboots from the REPL almost invariably triggered driver failures shortly thereafter, particularly when performed in rapid succession. By adopting a strict procedure of completely disconnecting and reconnecting power to the Host prior to each WiFi session, the driver crashes ceased entirely, restoring reliable performance.

During internal testing it was also discovered that there was a small but noticeable delay from pressing buttons on the Controller to the message showing up in the Host's REPL. The delay was minimized somewhat by tweaking asyncio delay lengths, making the Host query for notes more often. In the end, however, it was concluded that the primary delay was network latency. There were two suggested primary reasons for this. The first one was that the WiFi chip on the Pico 1 and Pico 2 may not have been designed for low-latency communication. A possible solution for this would be exchanging the Pico 1 and Pico 2's for a different MCU. A contender would be the ESP32 line of devices, since they have both a dedicated wireless protocol for low latency communication and a library for sending MIDI messages @espressif_systems_esp-now_2025 @geissl_thomasgeisslesp-now-midi_2025. For affordability and availability reasons, this idea was not further explored. The other possible reason for the latency was the using of TCP, which contains extra headers and acknowledgement messages adding overhead to each sent message. It was decided that TCP should be exchanged for UDP, which has less overhead, during the next sprint.

Lastly, it was sometimes experienced that a controller would disconnect from the host without the host ever finding out. To fix this, heartbeat-messages were implemented. They worked by having the host sending a heartbeat request message to the controller every few seconds. If the controller didn't answer the heartbeat three times in a row, the Host would forget the Controller.

== Circuitry
A schematic was created to provide an overview of the internal wiring of the controller and to ensure correct and consistent integration of the system’s components (@app:schematicSprint2). This step was essential to validate that all hardware elements could function together as intended and that the correct GPIO pins on the Pico were used.
The schematic brings together all the hardware elements of the controller: 
- NFC reader (RC522)
  - The NFC reader was connected to the Pico 1's SPI0 bus, which was one of the Pico's two SPI busses.
- Display (Pico Display 2.0)
  - The display was also connected to the Pico 1's SPI0 bus though with a different CSn pin. Since both the NFC reader and the display used SPI, it seemed like an obvious way to use fewer GPIO pins on the Pico's.
- Buttons
  - The eight buttons planned for in @sec:sprint1MusicalInteraction was added. Furthermore, external pull-up resistors were added. This was an oversight, since the Pico 1's internal pull'up resistors would be used.
- Potentiometers via multiplexer
  - As mentioned in @sec:sprint1MusicalInteraction the four potentiometers would require more analog inputs than what the Pico 1's offered. A multiplexer was therefore added, allowing the Pico 1's to receive analog inputs from all four potentiometers using only one analog GPIO pin.
- Power system
  - Four AA batteries where added as the primary power source. This would result in a power supply of $4 dot 1.2V = 4.8V$, closely resembling the 5V the Pico 1's would receive when connected to a computer via USB.
  - A power switch was added to allow for the user to turn off the controllers without removing the batteries.
  - A MOSFET transistor and resistor was added in accordance with the recommendations of #cite(<raspberry_pi_raspberry_2024-1>, form: "prose"). This was done so that the batteries would be automatically disconnected when the Pico 1's were connected to a computer for debugging to make sure neither the Pico 1's or connected computers would be damaged.
- LEDs
  - For visual purposes, ten LED's were added to schematic. The LED's chosen were the _Breadboard-friendly RGB Smart NeoPixel_ #cite(<adafruit_breadboard-friendly_2025>). These were chosen for their availability, flexibility and affordable pricing. By using NeoPixel LED's it was possible to control multiple LED's using only one GPIO pin. Furthermore, the _RGB Smart NeoPixel_ LED's are full RGB LED's meaning a single LED can display a wide array of colors. Lastly, as both the NeoPixel LED's and CircuitPython are made by Adafruit, a first-party library made them easy to integrate #cite(<george_adafruit_2025>).
  - A level shifter was added to make the NeoPixels run at 4.8V. This was done to make sure the LED's would be bright enough for both inside and outside use, as they were reported to have a lower brightness when connected to a 3.3V source @adafruit_breadboard-friendly_2025.
  
== Controller breadboard prototype
By following the schematic (@app:schematicSprint2), a controller was successfully assembled on a breadboard to test how the individual parts interacted. The LED's were deemed not strictly important for the functionality of the Controller and was therefore not implemented on the breadboard.

=== Buttons <sec:sprint2Buttons>
Four tactile switch buttons @adafruit_tactile_nodate were added to the breadboard, according to the schematic. Each button was connected to the Pico using an internal pull-up configuration as mentioned in @sec:sprint1MusicalInteraction. The buttons were implemented so that, when a button was pressed, the controller send a single message to the host indicating which button had been activated (e.g., “Button 3 pressed”) (@listing:sprint2Buttons).

Multiple buttons were handled by having references to them in a programmatic array. This array would be constantly iterated through, checking the state of each button, comparing it to its previous state (@listing:sprint2Buttons:1) to monitor it's state and whether it was being pressed. If it had been pressed the beforementioned message would be sent and a short asynchronous wait would begin (@listing:sprint2Buttons:3) so that other parts of the code had time to run, before the next button was checked.

#figure(
  ```cpy
if current_state == False and self.button_states[idx] == True:
  self.wifi_handler.send_note(idx)
  await asyncio.sleep(0.001)
  ```,
  caption: [Example of code handling button press.]
) <listing:sprint2Buttons>

=== NFC Reader
When the NFC reader was integrated into the controller breadboard, several issues were encountered. Although the module had functioned correctly in earlier isolated tests, the NFC code now blocked the other components, as it continuously attempted to read cards. Various libraries and timeout adjustments were tested, and even the use of `asyncio()` failed to resolve the issue, as the code continued to block.
The solution was to add a physical read button next to the NFC reader, acting as a sensor, which had to be pressed to initiate a card scan. This approach resolved the problem by allowing the rest of the system to operate uninterrupted. In practice, the NFC reader was therefore moved to a smaller breadboard because of space problems. This also made it easier to operate, as it was not all pressed compactly together.

The button was monitored in an asynchronous loop (@listing:nfcReadWButton:1) that repeatedly checked its state every 100 milliseconds (@listing:nfcReadWButton:6). When the button was pressed (@listing:nfcReadWButton:4), a message was printed to the console and the `read_nfc()` function was called (@listing:nfcReadWButton:6). This function sent a request to the RFID module to look for a card (@listing:nfcReadWButton:11).  When a card was found(@listing:nfcReadWButton:17) it was compared to the card labels (@listing:nfcCardLabels). If the card matched a label, a message was then sent to the host indicating which instrument the card represented @listing:nfcReadWButton:19).

To ensure the reader continued working reliably, it was reinitialized on each read (@listing:nfcReadWButton:24). Without this line, the reader would occasionally fail after repeated scans.

#figure(
  ```cpy
async def check_nfc_sensor(self):
  while True:
    # If button is pressed
		if not self.sensor.value:
			print("Reading RFID card...")
			self.read_nfc()
		await asyncio.sleep(0.1)

def read_nfc(self):
	# Request for a card in idle mode
	(status, tag_type) = self.rfid.request(self.rfid.REQIDL)
	if status != self.rfid.OK:
		print("No card detected.")
		return

  # Check if the card UID matches a known label
	if card_str in self.card_labels:
		print("Card recognized as:", self.card_labels[card_str])
		self.wifi_handler.send_instrument_change(self.card_labels[card_str])
	else:
		print("Unknown card.")

  # Reinitialize the RFID module
  self.rfid.init()  
  ```,
  caption: [Button for reading NFC cards]
) <listing:nfcReadWButton>

//- sættes sammen på breadboard med resten
//- Opdager at DEN tager for meget tid (blokere resten af koden, scanner hele tiden) (pt. uden læse knap) (eksperimentation, andre bib og timeout værdi)
 // - På trods af brug a asyncio (nævnt tidliger)
//  - Løst ved læse knap (sensor) for at scanne (nævn i testen at børnene glemte at bruge den, så det måske skal laves om til automatisk sensor)
//- slutning: sender wifi besked til hosten, om hvilket instrument der skal spilles

=== Display <sec:Sprint2Display>
As explained in @sprint1display, Adafruit's example code served as the foundation for the display's implementation. However, the original code was modified to support image rendering, rather than solely displaying text. Through experimentation, the function presented in @listing:displayImage was created to encapsulate the image loading process.

#figure(
  ```cpy
def display_image(image_file):
    splash = displayio.Group()
    display.root_group = splash

    try:
        bitmap = displayio.OnDiskBitmap(image_file)
        image_sprite = displayio.TileGrid(bitmap, pixel_shader=bitmap.pixel_shader)
        splash.append(image_sprite)
    except Exception as e:
        print(f"Error loading image: {e}")

  ```,
  caption: [`display_image(image_file)` function to load images onto the display.]
) <listing:displayImage>

Within this function, the variable `splash` is first instantiated as a `display.io` group, which is then assigned as the display's `root_group` (@listing:displayImage:2 to @listing:displayImage:3). A `try-except` block is utilized (@listing:displayImage:5 to @listing:displayImage:10) to attempt the creation of a bitmap from the provided `image_file`, which is subsequently appended to the `splash` group.

To achieve the desired interaction between the display and the NFC reader, integration was implemented via the SPI protocol. Within the `def read_nfc(self)` function, a task is initiated wherein `display_image` is invoked upon successful card recognition (@listing:NFCDisplay:6). The card's label is converted into a string, which is then used to determine the corresponding image to be loaded on the display (@listing:NFCDisplay:7).

#figure(
  ```cpy
#Check if the card UID matches a known label
if card_str in self.card_labels:
    print("Card recognized as:", self.card_labels[card_str])
    self.connection_handler.send_instrument_change(self.card_labels[card_str])
    asyncio.create_task(
      self.display_controller.display_image(
      "/images/" + self.card_labels[card_str] + ".bmp")
  ```,
  caption: [Codesnippet from the function: `def read_nfc(self)` in nfc_handler.py.]
) <listing:NFCDisplay>

In the initial circuit design, both the NFC reader and the display were intended to operate on a shared SPI bus. However, upon integrating the display, the NFC reader began exhibiting unstable behavior, failing to consistently recognize cards. To resolve this issue, several potential causes were investigated, including the possibility of timing conflicts arising from shared use of the Pico's internal timers. Efforts were also made to interpret error messages generated under the shared SPI configuration. Ultimately, it was decided that the display and NFC reader should be allocated separate SPI busses in a later iteration.

=== Potentiometers and multiplexer <sec:potsSprint2>
To accommodate the requirement of integrating four potentiometers into the circuit, a multiplexer was chosen to address the limitation of available GPIO pins on the Pico. The specific component selected for this purpose was the Texas Instruments 74HC4051 multiplexer #text(red)[cite].

To verify the functionality of the multiplexer, an initial test circuit was constructed using three LEDs. In this setup, the Pico was programmed to send signals to different channels of the multiplexer, thereby activating each LED in succession. 

A second test environment was developed using potentiometers. Here, the approach involved configuring the Pico to read inputs from the various potentiometers by selecting the appropriate channels on the multiplexer. During this testing phase, it was observed that leaving unused multiplexer channels unconnected led to unstable behavior; the analog readings would fluctuate and interfere with one another. This issue was resolved by grounding the unused pins, which stabilized the readings and ensured proper functionality.

== Host breadboard prototype
The Host was very simply implemented on a breadboard as it only consisted of a Pico 2. By using WiFi no other wires had to be added. However, difficulties arose that led to adding LED's to the Host breadboard prototype.

=== Visual feedback
During development and internal testing it was discovered that it was difficult to debug the connection between the controller and the host as both would have to be physically connected to a computer running an instance of Visual Studio Code each to monitor the REPL. To make this debugging easier and to further device feedback (requirement 4, @table:usabilityRequirements) it was decided that the host should have two NeoPixel LED's @adafruit_breadboard-friendly_2025 for displaying the system's current state.

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
  ),
  annotation-format: none
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

// === FØR DETTE MÅ DER IKKE NÆVNES NOGET OM NOTE BESKEDER ELLER CHANGE SOUND BESKEDER ===  
// === FØR DETTE KAN INTET LAVE LYD ===  
== Ableton Live setup
In Ableton Live a new project was set up with two MIDI tracks. Each track was assigned a different input MIDI channel and was then given an instrument (@fig:abletonTwoInstrument). The two instruments were drums and piano. These instruments were chosen as they were easily recognizable, very different sounding, and their real counterparts very different looking.

During the configuration of Ableton Live, it was decided to not prioritize looping functionality (Requirement 8, @table:usabilityRequirements). This decision was made since Ableton Live already implements looping. Therefore it seemed wiser to focus on other aspects of the product as the user would already be able to use looping through Ableton Live.

#figure(
  image("../images/sprint 2/Ableton-2Tracks.png", width: 50%),
  caption: [Ableton Live 11 setup for playing playing different instruments on different MIDI channels.]
) <fig:abletonTwoInstrument>

== Host MIDI interface <sec:sprint2HostMidiInterface>
During early host development, two diagrams (@fig:diagramMessageFlow) were drafted to clarify controller-to-host interactions. One diagram illustrated how input signals (button presses and potentiometer turns) should be sent to, and processed by, the host (@fig:DevicePlayingDiagram). Controllers were required only to emit a simple message identifying the activated input; all higher-level processing would occur on the host.

#subpar.grid(
  columns: (auto, auto),
  caption: [Diagrams showing message flow.],
  label: <fig:diagramMessageFlow>,
  align: top,
  figure(image("../images/sprint 2/DevicePlayingDiagram.png", width: 98%),
    caption: [Message flow when using Controller.]), <fig:DevicePlayingDiagram>,
  figure(image("../images/sprint 2/ChangeSoundDiagram.png", width: 100%),
    caption: [Message flow when changing instrument.]), <fig:ChangeSoundDiagram>
)

The host was designed around three lookup tables: a controller-to-instrument map (@listing:lookUpTables2Instr:1), an instrument-to-MIDI-channel map (@listing:lookUpTables2Instr:2), and an instrument-specific table of controller-button to MIDI-note assignments (@listing:lookUpTables2Instr:6) which trialed used the `note_parser()` function from the MIDI library #cite(<walters_adafruit_2025>) to convert the name of the notes to the right MIDI number. When a message arrived indicating, for example, that Controller A’s Button 1 was pressed, the host would determine Controller A’s assigned instrument (@listing:receivedNote:5), select that instrument’s MIDI channel (@listing:receivedNote:6), look up the MIDI note tied to Button 1 for that instrument (@listing:receivedNote:8), and forward a corresponding MIDI message on the correct channel to Ableton Live (@listing:receivedNote:9). To change instruments, controllers sent special messages indicating the desired instrument; the host then updated the controller-to-instrument map accordingly (@fig:ChangeSoundDiagram). By pre-allocating one channel per instrument, sound changes required no additional latency—messages simply switched channels—ensuring seamless, low-latency response as required by the low latency technical requirement (Requirement 9, @table:technicalRequirements). However, it was noted that this limited the amount of instruments as this is the limit of the MIDI protocol @levin_how_2024.

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

== Fusion 3D Experimentation
The controller needed to be enclosed in a physical chassis. Since a 3D printer was available, it was decided to design the enclosure in Fusion 360 and print it using PLA. As none of the team members had significant experience with CAD modelling, the process involved considerable experimentation and iteration.
Using the paper prototype as a reference, the first version of the model was created. It featured a flat square base with detachable sides, allowing easier access to the internal components during development. This modular design also made it possible to make small adjustments without reprinting the entire structure. The corners were modelled with slits into which the side panels could slide. Holes for magnets were added to later allow a lid to snap into place. Additionally, all sharp edges were rounded to create a more comfortable and polished finish.

The first 3D model (@fig:fus2FirstAttempt) captured the core design, but several issues were quickly identified. The corners did not grip the sides securely, and the overall structure was considered too thin to provide stability. To address this, the corners were resigned to be thicker while keeping the same sliding slit mechanism. The side panels were also adjusted to fit the new corner dimensions. However, this redesign led to reduced internal space. 
To solve this, a slight inward curve was added to the side panels. This preserved structural stability at the corners while reclaiming space in the center of the enclosure. The updated model (@fig:fus2Assembled) was then 3D printed, as shown in @fig:3DFirstPrintedBox.

#subpar.grid(
  columns: (auto, auto, auto),
  caption: [Controller chassis'.],
  label: <fig:fus2>,
  align: top,
  figure(image("../images/Fusion/fus2FirstAttemptBox.png", width: 100%),
    caption: [First attempt at designing controller box.]), <fig:fus2FirstAttempt>,
  figure(image("../images/Fusion/fus2Assembled.png", width: 95%),
    caption: [Controller chassis after changes.]), <fig:fus2Assembled>,
  figure(image("../images/Fusion/3DFirstBox.jpg", width: 80%),
    caption: [3D printed controller chassis.]), <fig:3DFirstPrintedBox>
)

== Pixelart for the Display
#figure(
  image("../images/sprint 2/pixel-art.png", height: 20%),
  caption: [Instrument Pixel Art],
) <fig:pixelart>

All visual assets used for the display were created specifically for the project, as the Picos had limited storage capacity and the chosen display module required the picture format to be in bitmap (.BMP) format @alexa_davis_what_2025 for proper image rendering. Common image formats were incompatible, and the availability of suitable .BMP files was limited. Consequently, images of the instruments for the display were produced using Aseprite #cite(<igara_studio_aseprite_2025>), a tool suited for pixel art creation. This application was selected due to its ability to export compatible files, precise scaling for the display's resolution, and prior familiarity with the software. In addition, the pixel art style was considered suitable for the target audience, due to its playful and accessible visual expression (Requirement 4 & 11, @table:usabilityRequirements). For the initial breadboard implementation, two instrument images– a drum and a piano– were created as seen in @fig:pixelart. 

== Testing <sec:sprint2test>
Testing was conducted at the University of Southern Denmark, where the prototype was evaluated by five individual participants within the target group. These participants were all enrolled at Teknologiskolen @teknologiskolen_om_2025, an extracurricular activity with the focus of teaching kids about hardware. This meant they had prior knowledge of breadboard setups and hardware in general, which made it possible to test a very early implementation of the system without causing the target group too much confusion. The testing procedure consisted of a think-aloud part, where testers could experiment using the product while providing feedback. This was followed by an unstructured interview. These methods were selected for their adaptability, which proved particularly beneficial given that the participants were children. This adaptability allowed the children to guide parts of the session by posing questions, offering detailed feedback, or requesting additional guidance on the use of the product and its features. On average, each testing session lasted approximately 10 minutes.

In one instance, two participants were present in the room simultaneously; however, they completed the test individually and responded to the predefined questions together afterward. All remaining sessions involved one participant at a time.

#figure(
  image("../images/sprint 2/sprint2-test-setup.png", height: 20%, width: 70%),
  caption: [Test Setup for Sprint 2],
) <fig:sprint2setup>

All participants demonstrated a clear enjoyment of musical engagement. Two individuals reported prior familiarity with keyboard instruments, noting regular usage at home, while none had received formal music training. Participants without previous experience playing instruments expressed a curiosity and interest in learning. Across the board, testers described the product as intuitive, easy to navigate. No confusion or operational difficulties were reported during interaction with the prototype (@app:Sprint2Transcriptions).

Various A/B tests were conducted. The first one was to determine which switch to use in the final rendition of the product. The choice was between something like the SKHH-1370651 switches @mouser_electronics_skhhbwa010_2025, and Nuphy low-profile mechanical keyboard switches in the MOSS style @nuphy_nuphy_2025. Here, five of the six participants indicated a preference for the keyboard-style switches over those integrated into the breadboard configuration as seen in @fig:sprint2setup. Another A/B test had the aim of determining the best placement hole to put an NFC card into, this was conducted with the paper prototype. Participants favored the positioning of the hole on the right-hand side of the device. Upon asking, it emerged that all participants were right-handed, raising the possibility of a handedness bias influencing the preference. Additionally, another interaction method was proposed by a participant, which included "swiping" the NFC card along the front panel in the style of contactless payment options, or Rejsekort when travelling with public transport in Denmark.

When asked about how to further incorporate visual feedback, all testers responded positively to the idea of incorporating LEDs, some specifying that color-coded placement near the buttons would be beneficial to enhance association with the pitch of notes as described in the following quote: #quote[Then you could have different colors, like, for the sounds. So if they were deep sounds, they could be dark blue, and if there were lighter ones, they could be light colors, like spring colors. The dark tones could then be winter colors.] (translated from Danish to English) (@app:Sprint2Transcriptions).

Durability was briefly addressed by one participant, who raised concerns about the potential for damage if inappropriate objects were inserted into the NFC slot #quote[Can you put other stuff into it? [...] so that it says kaboom?] (translated from Danish to English) (@app:Sprint2Transcriptions) or if the device were to be dropped #quote[But what about switches? What if they fall off if you accidentally drop it from the Eiffel Tower?] (translated from Danish to English) (@app:Sprint2Transcriptions). 

Interaction with potentiometers emerged as an area of concern as participants found them unintuitive and awkward to handle, largely due to their compact physical dimensions and the limited rotational range. Finally, the concept of collaborative play elicited positive reactions, with all testers expressing enthusiasm about a shared music-making experience. However, one participant noted that simultaneous use of identical instrument sounds could lead to an uncomfortable auditory experience.

Finally, one tester showed interest in the power supply options for the product. In response, two possibilities were presented: incorporating batteries or using a wired power connection. The tester indicated a preference for the wired option, as replacing batteries would become an inconvenience. #quote[Yes, but maybe I think it's a bit easier with a cord, you know. Batteries—you actually have to go out and buy them.] (translated from Danish to English) (@app:Sprint2Transcriptions). This was taken into consideration, as testers had difficulty creating beats with the product, which was partly observed to be because of WiFi latency problems.

