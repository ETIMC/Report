#import "@preview/subpar:0.2.2"
#import "@preview/codly:1.3.0": *
= Sprint 2: _Breadboard implementation, Wifi and Host functionalities_
Building on the insights gathered during Sprint 1, the focus shifted to integrating the individual functional components into a cohesive system. This involved interconnecting the components to form a working breadboard prototype suitable for further testing and iteration. Testing (@sec:sprint1test) confirmed the physical design had a good layout and size, but could be worked upon further.

== WiFi problems <sec:sprint2WifiProblems>
During WiFi connectivity testing between the Host and the Controller, the Host’s WiFi driver would crash unpredictably, often within a minute of establishing a connection. This instability generated significant confusion, leading to doubts about the viability of WiFi as the communication protocol of choice. As a fallback, Bluetooth was briefly trialed, but its inherent latency was incompatible with the low-latency requirement (Requirement 9, @table:technicalRequirements).

Debugging eventually uncovered a pattern: only a full power cycle of the Pico 2 before initiating the WiFi connection yielded a stable result. In contrast, soft reboots from the REPL almost invariably triggered driver failures shortly thereafter, particularly when performed in rapid succession. By adopting a strict procedure of completely disconnecting and reconnecting power to the Host prior to each WiFi session, the driver crashes ceased entirely, restoring reliable performance.

During internal testing it was also discovered that there was a small but noticeable delay from pressing buttons on the Controller to the message showing up in the Host's REPL. The delay was minimized somewhat by tweaking asyncio delay lengths, making the Host query for notes more often. In the end, however, it was concluded that the primary delay was network latency. There were two suggested reasons for this. The first one was that the WiFi chip on the Pico 1 and Pico 2 may not have been designed for low-latency communication. A possible solution for this would be exchanging the Pico 1's and Pico 2's for different MCUs. A contender would be the ESP32 line of devices, since they have both a dedicated wireless protocol for low latency communication and a library for sending MIDI messages @espressif_systems_esp-now_2025 @geissl_thomasgeisslesp-now-midi_2025. For affordability and availability reasons, this idea was not further explored. The second possible reason for the latency was the usage of Transmission Control Protocol (TCP), which contains extra headers and acknowledgement messages, adding overhead to each sent message #cite(<kurose_computer_2020>, supplement: [ch. 3]). It was decided that TCP should be exchanged for User Datagram Protocol (UDP), which has less overhead #cite(<kurose_computer_2020>, supplement: [ch. 3]).

Lastly, if the Controller disconnected, the Host would never notice. To fix this, "heartbeat-messages" were implemented. They worked by having the Host sending a heartbeat request message to the Controller every few seconds. If the Controller didn't answer the heartbeat request  three times in a row, the Host would forget the Controller.

== Circuitry <sec:sprint1Circuitry>
A schematic was created to provide an overview of the internal wiring of the Controller and to ensure correct and consistent integration of the system’s components (@app:schematicSprint2). This step was essential to validate that all hardware elements could function together as intended and that the correct GPIO pins on the Pico were used.
The schematic contains the hardware elements of the Controller: 
- NFC reader (RC522)
  - The NFC reader was connected to the Pico 1's SPI-0 bus.
- Display (Pico Display 2.0)
  - The display was also connected to the Pico 1's SPI-0 bus though with a different _CSn_ pin rather than using the SPI-1 bus, since it seemed like an obvious possibility to use fewer GPIO pins on the Pico's.
- Buttons
  - The eight buttons (@sec:sprint1MusicalInteraction) were added using the Pico 1's internal pull-up resistors.
- Potentiometers via multiplexer
  - The four potentiometers would require more analog inputs than what the Pico 1's offered (@sec:sprint1MusicalInteraction). A multiplexer @arduinotechdk_74hc4051_2025 was therefore added, allowing the Pico 1's to receive analog inputs from all potentiometers using only one analog GPIO pin. This solution did, however, also require three digital GPIO pins.
- Power system
  - Four AA batteries where added as the primary power source. This would result in a power supply of $4 dot 1.2V = 4.8V$, closely resembling the 5V the Pico 1's would receive when connected to a computer via USB.
  - A power switch was added to allow for the user to turn off the Controllers without removing the batteries @arduinotechdk_vippekontakt_2025.
  - A MOSFET transistor and a resistor was added in accordance with the recommendations of #cite(<raspberry_pi_raspberry_2024-1>, form: "prose") This was done so that the batteries would be automatically disconnected when the Pico 1's were connected to a computer for debugging, ensuring neither could be damaged.
- LEDs
  - Based on testing (@sec:sprint1test), ten _Breadboard-friendly RGB Smart NeoPixel_ @adafruit_breadboard-friendly_2025 LED's were added to the schematic. These were chosen for their availability, pricing, and flexibility allowing the control of multiple RGB LED's using only one GPIO pin and a first-party library made by Adafruit @george_adafruit_2025.
  - A level shifter was added to make the NeoPixels run at 4.8V as opposed to 3.3V. This ensured the LEDs would be bright enough for multiple lighting conditions @adafruit_breadboard-friendly_2025.
  
== Controller breadboard prototype
By following the schematic (@app:schematicSprint2), a Controller was successfully assembled on a breadboard to test, how the individual parts interacted. The LED's were deemed not strictly important for the functionality of the Controller and was therefore not implemented on the breadboard.

=== Buttons <sec:sprint2Buttons>
Only four of the eight buttons (@sec:sprint1MusicalInteraction) were added to the breadboard due to limited space. The buttons were implemented so that, when a button was pressed, the Controller would send a single message to the Host indicating which button had been activated (e.g., “Button 3 pressed”) (@listing:sprint2Buttons).

Multiple buttons were handled by having references to them in an array in the code. This array would be constantly iterated through, checking the state of each button, comparing it to its previous state (@listing:sprint2Buttons:1) to monitor whether it was being pressed. If it had been pressed, the beforementioned message would be sent (@listing:sprint2Buttons:2) and a short asynchronous wait would begin (@listing:sprint2Buttons:3) so that other parts of the Controller's code had time to run, before the next button was checked.

#figure(
  ```cpy
if current_state == False and self.button_states[idx] == True:
  self.wifi_handler.send_note(idx)
  await asyncio.sleep(0.001)
  ```,
  caption: [Example of code handling button presses.]
) <listing:sprint2Buttons>

=== NFC Reader
Several issues were encountered, when the NFC reader was integrated into the Controller breadboard. Although the module had functioned correctly in earlier isolated tests (@sprint1nfc), the NFC reader now seemed to block the code handling the buttons. After debugging, it was concluded this was caused by the NFC reader continuously attempting to read cards. Various libraries and timeout adjustments were tested, and even the use of `asyncio` failed to resolve the issue. The solution was to add a physical button next to the NFC reader, that had to be pressed to initiate a card scan. This approach resolved the problem by allowing the rest of the system to operate uninterrupted. After solving the bug, the NFC reader was moved to a smaller breadboard to not have all components placed compactly together.

The button was monitored in an asynchronous loop (@listing:nfcReadWButton:2) that repeatedly checked its state (@listing:nfcReadWButton:7). When the button was pressed (@listing:nfcReadWButton:4), a message was printed to the console and the `read_nfc` function was called (@listing:nfcReadWButton:9). This function sent a request to the NFC reader to look for a card (@listing:nfcReadWButton:10).  When a card was found (@listing:nfcReadWButton:15), it was compared to a pre-defined list of card labels (@listing:nfcCardLabels). If the card matched a label, a message was sent to the Host indicating the instrument that label represented (@listing:nfcReadWButton:17).

To ensure the reader continued working reliably, it was reinitialized on each read (@listing:nfcReadWButton:21). Without this line, the reader would occasionally fail after repeated scans.

#codly(
  annotations: (
    (
      start: 2,
      end:  7,
      content: block(
        width: 12em,
        align(left, box(width: 120pt)[Wait for \ button press.])
      )
    ),
    (
      start: 9,
      end:  13,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Read NFC card.])
      )
    ),
    (
      start: 15,
      end:  19,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Check label \ associated with card \ and send message \ to Host.])
      )
    ),
  ),
  annotation-format: none
)
#figure(
  ```cpy
  
async def check_nfc_sensor(self):
  while True:
		if not self.sensor.value:
			print("Reading RFID card...")
			self.read_nfc()
		await asyncio.sleep(0.1)

def read_nfc(self):
	(status, tag_type) = self.rfid.request(self.rfid.REQIDL)
	if status != self.rfid.OK:
		print("No card detected.")
		return

	if card_str in self.card_labels:
		print("Card recognized as:", self.card_labels[card_str])
		self.wifi_handler.send_instrument_change(self.card_labels[card_str])
	else:
		print("Unknown card.")

  self.rfid.init()  
  ```,
  caption: [Functions for reading and handling NFC.]
) <listing:nfcReadWButton>

=== Display <sec:Sprint2Display>
The example code (@sprint1display) was modified to support image rendering, rather than solely displaying text. Through experimentation, the function presented in @listing:displayImage was created to encapsulate the image loading process. Within this function, the variable `splash` was first instantiated as the group containing what should be rendered on the display (@listing:displayImage:2). A `try-except` block was utilized (@listing:displayImage:5 to @listing:displayImage:10) to attempt loading a bitmap image file from the internal storage, which was subsequently appended to the `splash` group, rendering the image on the display. When rendering an image, it was observed that the display blocked other code from running on the Pico until it was done rendering.

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
  caption: [Function to load images onto the display.]
) <listing:displayImage>

To achieve the desired interaction between the display and the NFC reader the function `read_nfc` was modified to call the `display_image` function upon successfully recognizing an NFC card (@listing:NFCDisplay:5). The card's label was then used to determine the corresponding image to be loaded on the display (@listing:NFCDisplay:6).

#figure(
  ```cpy
if card_str in self.card_labels:
    print("Card recognized as:", self.card_labels[card_str])
    self.connection_handler.send_instrument_change(self.card_labels[card_str])
    asyncio.create_task(
      self.display_controller.display_image(
      "/images/" + self.card_labels[card_str] + ".bmp")
  ```,
  caption: [Codesnippet from the function: `def read_nfc(self)` on the Controller.]
) <listing:NFCDisplay>

In the initial circuit design, both the NFC reader and the display were intended to operate on a shared SPI bus (@sec:sprint1Circuitry). However, upon integrating the display, the NFC reader began exhibiting unstable behavior, failing to consistently recognize cards. To resolve this issue, several potential causes were investigated, including the possibility of timing conflicts arising from shared use of the Pico's internal timers. Ultimately, it was decided that the display and NFC reader should be allocated separate SPI busses in a later iteration.

=== Potentiometers and multiplexer <sec:potsSprint2>
To accommodate the requirement of integrating four potentiometers into the circuit, a multiplexer was chosen to address the limitation of available GPIO pins on the Pico.

To verify the functionality of the multiplexer, an initial test circuit separate from the Controller breadboard prototype was constructed using three LEDs. In this setup, the Pico was programmed to send signals to different channels of the multiplexer, thereby activating each LED in succession. 

A second separate test environment was afterwards developed using potentiometers. Here, the approach involved configuring a Pico to read inputs from the various potentiometers by selecting the appropriate input on the multiplexer using its _select_ pins. During this testing phase, it was observed that leaving unused multiplexer pins unconnected led to unstable behavior; the analog readings would fluctuate and interfere with one another. This issue was resolved by grounding the unused pins, which stabilized the readings and ensured proper functionality.

== Host breadboard prototype
The Host was implemented on a breadboard, consisting only of a Pico 2. However, during development and internal testing it was discovered that debugging the wireless connection was difficult as both the Host and Controller would have to be physically connected to a computer to monitor the REPL. To make debugging easier and to promote device feedback (requirement 4, @table:usabilityRequirements) two NeoPixel LED's @adafruit_breadboard-friendly_2025 were added to the Host for displaying the system's current state (@fig:hostBreadboard). The first LED was used for connection states such as when the Host was turning on and when the Controller connected or disconnected to the WiFi hotspot (@listing:handleNewConnectionLed).

#figure(
  image("../images/sprint 2/HostBreadboard.jpg", width: 40%),
  caption: [Host breadboard prototype with two NeoPixel LEDs.],
) <fig:hostBreadboard>

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

The second LED was programmed to display MIDI information. In practice this meant that it would blink according to MIDI clock messages sent by Live to the Host.

// === FØR DETTE MÅ DER IKKE NÆVNES NOGET OM NOTE BESKEDER ELLER CHANGE SOUND BESKEDER ===  
// === FØR DETTE KAN INTET LAVE LYD ===  
== Live setup
In Live a new project was set up with two MIDI tracks. Each track was assigned a different MIDI channel and was given an instrument (@fig:abletonTwoInstrument). The two instruments were drums and piano. These instruments were chosen as they were easily recognizable, very different sounding, and their real counterparts very different looking.

During the configuration of Live, it was decided to not prioritize looping functionality (Requirement 8, @table:usabilityRequirements). This decision was made since Live already implements looping. Therefore it seemed wiser to focus on other aspects of the product as the user would already be able to use looping through Live.

#figure(
  image("../images/sprint 2/Ableton-2Tracks.png", width: 50%),
  caption: [Live 11 setup for playing playing different instruments on different MIDI channels.]
) <fig:abletonTwoInstrument>

== Host MIDI interface <sec:sprint2HostMidiInterface>
During early Host development, two diagrams (@fig:diagramMessageFlow) were drafted to clarify Controller-to-Host interactions. One diagram illustrated how input signals (button presses and potentiometer turns) should be sent to, and processed by, the Host (@fig:DevicePlayingDiagram). Controllers were required only to send a simple message identifying the activated input; all higher-level processing would occur on the Host.

#subpar.grid(
  columns: (auto, auto),
  caption: [Diagrams showing message flow.],
  label: <fig:diagramMessageFlow>,
  align: top,
  figure(image("../images/sprint 2/DevicePlayingDiagram.png", height: 30%),
    caption: [Message flow when using Controller.]), <fig:DevicePlayingDiagram>,
  figure(image("../images/sprint 2/ChangeSoundDiagram.png", height: 30%),
    caption: [Message flow when changing instrument.]), <fig:ChangeSoundDiagram>
)

The Host was designed around three maps: a Controller-to-instrument map (@listing:lookUpTables2Instr:1), an instrument-to-MIDI-channel map (@listing:lookUpTables2Instr:2), and an instrument-specific map of Controller-button to MIDI-note assignments (@listing:lookUpTables2Instr:6), which used the `note_parser` function from the MIDI library #cite(<walters_adafruit_2025>) to convert the name of the notes to the right MIDI number. When a message arrived indicating, for example, that Controller A’s Button 1 was pressed, the Host would determine Controller A’s assigned instrument (@listing:receivedNote:5), select that instrument’s MIDI channel (@listing:receivedNote:6), look up the MIDI note tied to Button 1 for that instrument (@listing:receivedNote:8), and forward a corresponding MIDI message on the correct channel to Live (@listing:receivedNote:9). To change instruments, Controllers sent messages indicating the desired instrument; the Host then updated the Controller-to-instrument map accordingly (@fig:ChangeSoundDiagram). By pre-allocating one channel per instrument, sound changes required no additional latency. Messages simply switched channels, ensuring seamless, low-latency responses as required by the low latency technical requirement (Requirement 9, @table:technicalRequirements). It was noted that use of channels limited the amount of instruments to 16, as that is the limit of the MIDI protocol @levin_how_2024.

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
  caption: [Maps on Host.]
) <listing:lookUpTables2Instr>

The map for converting Controller button-presses to MIDI notes was defined to guarantee harmonic consistency (Requirement 7, @table:usabilityRequirements). Two octaves of the C-major triad were selected so users could access both high and low pitches without additional configuration. To support a future use case where a potentiometer might shift octaves, a pentatonic scale was considered; its five notes per octave offering broader melodic flexibility without risking dissonance #cite(<farrant_what_2020>).

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

The sending of notes themselves was driven by a queue. When a Controller registered a button input, a message with the ID of the button was sent to the Host. This message would undergo the previously mentioned processing before being added to a queue (@listing:receivedNote:9). The way the queue was emptied was quite interesting. When the "Play" button in Live was pressed it would begin sending 24 `TimingClock` messages to the Host per beat. This meant that if Live was set to play at 120 beats per minute the message would be received by the Host $24 dot 120 = 2880$ times a minute. By counting these messages and only emptying the queue, sending the MIDI messages to the Host, every 24 `TimingClock` messages, the Controllers input was quantized to the beat, overlooking potential timing-mishaps by the user (requirement 7, @table:usabilityRequirements). It was however also discovered that this didn't "feel" as nice to use as when the MIDI signals were immediately send to Live and the feedback heard immediately. This was also the case when emptying the queue every half-beat (every 12 `TimingClock` messages). For this reason, this feature was turned off during testing on the target group.

== Fusion 3D Experimentation <sec:sprint2Fusion>
The Controller should be enclosed in a solid chassis. Since 3D printing was available, it was decided to design the enclosure in Fusion 360 and print it using Polylatic Acid (PLA). As none of the team members had significant experience with Computer-Aided Design (CAD) modelling, the process involved considerable experimentation and multiple iterations. 

Using the paper prototype as reference (@sec:paperprototype), the first version of the chassis was created. It featured a flat square base with raised corners and detachable sides, allowing easier access to the internal components during development. This modular design also made it possible to make small adjustments to the design without reprinting the entire structure. The corners were modelled with slits into which the side panels could slide. Holes for magnets were added to later allow a lid to snap into place. Additionally, all sharp edges were rounded to create a more comfortable and polished finish.

The first 3D model (@fig:fus2FirstAttempt) captured the core design, but an issue was quickly identified, as the structure was too thin to provide stability. To address this, the corners were redesigned to be thicker while keeping the same sliding mechanism. The side panels were also adjusted to fit the new corner dimensions. However, this redesign led to reduced internal space. 
To solve this, a slight inward curve was added to the side panels. This preserved structural stability at the corners while reclaiming space in the center of the enclosure. The updated model (@fig:fus2Assembled) was then 3D printed, as shown in @fig:3DFirstPrintedBox.

#subpar.grid(
  columns: (auto, auto, auto),
  caption: [Controller chassis'.],
  label: <fig:fus2>,
  align: top,
  figure(image("../images/Fusion/fus2FirstAttemptBox.png", width: 100%),
    caption: [First attempt at designing Controller box.]), <fig:fus2FirstAttempt>,
  figure(image("../images/Fusion/fus2Assembled.png", width: 95%),
    caption: [Controller chassis after changes.]), <fig:fus2Assembled>,
  figure(image("../images/Fusion/3DFirstBox.jpg", width: 80%),
    caption: [3D printed Controller chassis.]), <fig:3DFirstPrintedBox>
)

== Pixelart for the Display
#figure(
  image("../images/sprint 2/pixel-art.png", height: 20%),
  caption: [Instrument Pixel Art],
) <fig:pixelart>

All visual assets used for the display were created specifically for the project, as the Picos had limited storage capacity @raspberry_pi_raspberry_2024-1 and the chosen display module required the picture format to be in the bitmap (.BMP) format @alexa_davis_what_2025 for proper image rendering.  Using pixel art was considered suitable for the target audience, due to its playful and accessible visual expression (Requirement 4 & 11, @table:usabilityRequirements). For the initial breadboard implementation, an image for each of the instruments was created (@fig:pixelart). 

== Testing <sec:sprint2test>
Prototype evaluation was conducted at the University of Southern Denmark with five participants from the target user group. The breadboard prototype, which utilized WiFi for connectivity, was tested (@fig:sprint2setup). During this evaluation, the display was intentionally disconnected from the main circuit due to observed interference (@sec:Sprint2Display). Additionally, the NFC reader required a manual button press for activation. The participants were all enrolled at Teknologiskolen (@teknologiskolen_om_2025), an extracurricular program focused on technology education for children. Participants' prior exposure to breadboard setups allowed for the testing of the very early prototype without significant participant confusion. The testing procedure comprised of two main phases: A think-aloud phase, where participants freely interacted with the prototype, followed by an unstructured interview. A/B tests were also utilized. Each test session averaged approximately 10 minutes.

In one instance, two participants were present concurrently. They individually completed the think-aloud phase but provided a joint response during the subsequent interview.

#figure(
  image("../images/sprint 2/sprint2-test-setup.png", height: 20%, width: 70%),
  caption: [Test Setup for Sprint 2.],
) <fig:sprint2setup>

None of the participants had received formal musical training, but two reported regularly playing on keyboards at home. All participants expressed curiosity and interest in learning more about music creation. 

While participants generally reported the prototype as easy to navigate, a significant usability issue emerged regarding the NFC reader's requirement for manual activation. Participants frequently forgot to activate it. One participant explicitly voiced frustration when reminded of this functionality, stating: #quote[Is that necessary? [...] It ends up being a negative thing.] (@app:Sprint2Transcriptions).


A/B tests were conducted to inform design decisions. One A/B test focused on button preference for the final prototype rendition. A majority of participants (4/5) preferred NuPhy low-profile mechanical keyboard switches in the MOSS style @nuphy_nuphy_2025 over the buttons on the breadboard implementation (@sec:sprint1MusicalInteraction). While participants were also consulted on potentiometer preferences, this feedback proved largely irrelevant. It was observed that regardless of size, participants found potentiometers unintuitive and awkward to handle due to their small form factor and limited rotational range.

A second A/B test, utilizing the paper prototype, investigated preferred NFC card slot placement. A strong preference for right-hand side placement was observed, which may be attributed to a handedness bias given all participants were right-handed. One participant also suggested a "swiping" interaction, akin to contactless payment options or the Danish public transport payment system, Rejsekort. Related to this, durability concerns were raised regarding the NFC slot, if inappropriate objects were inserted: #quote[Can you put other stuff into it? [...] so that it says kaboom?] (@app:Sprint2Transcriptions). Furthermore, a participant inquired about the device's resilience to drops, specifically regarding component detachment: #quote[But what about switches? What if they fall off if you accidentally drop it from the Eiffel Tower?] (@app:Sprint2Transcriptions).

Participants consistently requested LEDs for visual feedback. One suggested a color-coding scheme to associate with note pitches: #quote[Then you could have different colors, like, for the sounds. So if they were deep sounds, they could be dark blue, and if there were lighter ones, they could be light colors, like spring colors. The dark tones could then be winter colors.] (@app:Sprint2Transcriptions).

Regarding the prototype's power supply, a wired connection was preferred over batteries by participants due to the inconvenience of battery replacement: #quote[Yes, but maybe I think it's a bit easier with a cord, you know. Batteries—you actually have to go out and buy them.] (@app:Sprint2Transcriptions). Furthermore, observations during the test revealed that all participants struggled to create cohesive rhythmic beats. This difficulty was theorized to be a result of WiFi latency, which was noted as a critical area for improvement.

The concept of collaborative play was met with enthusiasm, as all testers expressed positive reactions to the idea of a shared music-experimentation experience. However, one participant raised a valid concern: that simultaneous use of identical instrument sounds could lead to an uncomfortable auditory experience.

Finally, one participant requested that additional instruments be added; #quote[Drums, guitar, piano, you know maybe something diverse? Sjubidu [...] Trumpet [...] Or do you know that instrument from Australia, that tube where you, uh, say weird sounds?] (@app:Sprint2Transcriptions).

/*
Testing was conducted at the University of Southern Denmark, where the prototype was evaluated by five individual participants within the target group. These participants were all enrolled at Teknologiskolen @teknologiskolen_om_2025, an extracurricular activity with the focus of teaching children about technology. This meant they had prior knowledge of breadboard setups, which made it possible to test a very early implementation of the system without causing the target group too much confusion. The testing procedure consisted of a think-aloud part, where testers could experiment using the product while providing feedback. This was followed by an unstructured interview. This adaptability allowed the children to guide parts of the session by posing questions, offering detailed feedback, and requesting additional guidance on the use of the product and its features. On average, each testing session lasted approximately 10 minutes.

In one instance, two participants were present in the room simultaneously; however, they completed the test individually and responded to the predefined questions together afterward. All remaining sessions involved one participant at a time.

#figure(
  image("../images/sprint 2/sprint2-test-setup.png", height: 20%, width: 70%),
  caption: [Test Setup for Sprint 2.],
) <fig:sprint2setup>

All participants demonstrated a clear enjoyment of musical engagement. Two individuals reported prior familiarity with keyboard instruments, noting regular usage at home, while none had received formal music training. Participants without previous experience playing instruments expressed a curiosity and interest in learning. Across the board, testers described the product as intuitive, easy to navigate. No confusion or operational difficulties were reported during interaction with the prototype (@app:Sprint2Transcriptions).

Various A/B tests were conducted. The first one was to determine which switch to use in the final rendition of the product. The choice was between the buttons on the breadboard implementation (@sec:sprint1MusicalInteraction), and Nuphy low-profile mechanical keyboard switches in the MOSS style @nuphy_nuphy_2025. Here, four of the five participants indicated a preference for the keyboard-style switches over those integrated into the breadboard configuration as seen in @fig:sprint2setup.

Another A/B test had the aim of determining the best placement of the hole to put an NFC card into, this part was conducted with the paper prototype. Participants favored the positioning of the hole on the right-hand side of the device. Upon asking, it emerged that all participants were right-handed, raising the possibility of a handedness bias influencing the preference. Additionally, another interaction method was proposed by a participant, which included "swiping" the NFC card along the front panel in the style of contactless payment options, or the contactless danish public transport payment system, Rejsekort @rejsekort_rejsekort_2025.
  
When asked about how to further incorporate visual feedback, all testers responded positively to the idea of incorporating LEDs, some specifying that color-coded placement near the buttons would be beneficial to enhance association with the pitch of notes as described in the following quote: #quote[Then you could have different colors, like, for the sounds. So if they were deep sounds, they could be dark blue, and if there were lighter ones, they could be light colors, like spring colors. The dark tones could then be winter colors.] (translated from Danish to English) (@app:Sprint2Transcriptions).

Durability was briefly addressed by one participant, who raised concerns about the potential for damage if inappropriate objects were inserted into the NFC slot #quote[Can you put other stuff into it? [...] so that it says kaboom?] (translated from Danish to English) (@app:Sprint2Transcriptions) or if the device was to be dropped #quote[But what about switches? What if they fall off if you accidentally drop it from the Eiffel Tower?] (translated from Danish to English) (@app:Sprint2Transcriptions). 

Interaction with potentiometers emerged as an area of concern as participants found them unintuitive and awkward to handle, largely due to their compact physical dimensions and the limited rotational range. Finally, the concept of collaborative play elicited positive reactions, with all testers expressing enthusiasm about a shared music-making experience. However, one participant noted that simultaneous use of identical instrument sounds could lead to an uncomfortable auditory experience.

Finally, one tester showed interest in the power supply options for the product. In response, two possibilities were presented: incorporating batteries or using a wired power connection. The tester indicated a preference for the wired option, as replacing batteries would become an inconvenience. #quote[Yes, but maybe I think it's a bit easier with a cord, you know. Batteries—you actually have to go out and buy them.] (translated from Danish to English) (@app:Sprint2Transcriptions). This was taken into consideration, as testers had difficulty creating beats with the product, which was partly observed to be because of WiFi latency problems.

*/
