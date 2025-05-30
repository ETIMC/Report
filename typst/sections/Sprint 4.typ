#import "@preview/codly:1.3.0": *
#import "@preview/subpar:0.2.2"

= Sprint 4: _Knobs, Debouncing and NFC Card Detection_ <sec:sprint4>
Feedback from testing (@sec:sprint3test) informed the choice of redesigning the NFC card slot to prevent the NFC cards from sliding out, custom potentiometer knobs were also designed. Furthermore automatic card detection was developed to alleviate the pain point testers had remembering to press the button to activate card detection. A switch debouncing algorithm was created for improved interaction with the system, and professionally manufactured PCBs were ordered to replace an earlier hand-made version, to resolve several issues.

== CAD <sec:sprint4Cad>
User testing, showed that the NFC cards easily fell out of the NFC card insertion hole (@sec:sprint3test), and that the initial design unintentionally allowed for foreign objects to be inserted, which was a concern voiced both by a test participant (@sec:sprint2test) and by #cite(<chen_humming_2019>, form: "prose"). To fix this, the NFC side of the chassis was redesigned with a narrower opening. During printing, however, support structures were generated inside the opening, which proved difficult to remove. Despite this, the smaller opening was retained for further testing.

Additionally, potentiometer knobs were designed and developed based on earlier feedback (@sec:sprint3test). The initial designs were inspired by @bluefinbima_creating_2021, but adjusted to match the specific dimensions of the potentiometers and holes in the lid. Several versions were modeled and printed. The first version was a simple knob designed to fit directly onto the potentiometer shaft (@fig:fus4pot1), and was used to verify fit and tolerances.

Thereafter, experimentation figuring out how to make the knobs better and potentiometers more robust begun. Initially, the design involved the knob to be inserted under the lid of the chassis so that the PCB would not be visible; this idea was good in theory but did not work in practice as turning the knob became near impossible as it was pressed against the lid (@fig:fus4pot2). A new modified version of this specific knob with more clearance, was created, printed, and seemed to work (@fig:fus4pot3). Furthermore, two additional knobs were printed with bases that rested on top of the lid (@fig:fus4pot4), while still retaining the functionality of hiding the PCB. Since the printed knobs all worked, it was decided to later test, which knob was favored by the target group.

#subpar.grid(
  columns: (1fr, 1fr, 1fr, 2fr),
  caption: [Potentiometer knobs.],
  label: <fig:fus4>,
  align: top,
  figure(image("../images/sprint 4/pottop1.png", width: 37%),
    caption: [Knob for only the shaft.]), <fig:fus4pot1>,
  figure(image("../images/sprint 4/pottop2.png", width: 40%),
    caption: [Knob for under lid.]), <fig:fus4pot2>,
  figure(image("../images/sprint 4/pottop3.png", width: 40%),
    caption: [Redesigned knob for under the lid.]), <fig:fus4pot3>,
  figure(image("../images/sprint 4/pottop4.png", width: 65%),
    caption: [Knobs resting on top of lid.]), <fig:fus4pot4>
)

== Potentiometer MIDI
The functionality of the potentiometers was handled in a much different way than the buttons (@sec:sprint2Buttons). Since they were all plugged into a multiplexer, each potentiometer could only be read, when the three _select_ pins on the multiplexer were set to the right binary values @texas_instruments_high-speed_2004.

#codly(
  annotations: (
    (
      start: 2,
      end:  2,
      content: block(
        width: 15em,
        align(left, box(width: 120pt)[Configure binary select values.])
      )
    ),
    (
      start: 7,
      end:  10,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Initialize analog input and digital select pins.])
      )
    ),
    (
      start: 15,
      end:  16,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Map 16-bit read value to MIDI range.])
      )
    ),
    (
      start: 18,
      end:  21,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Iterate over predefined binary select values.])
      )
    ),
    (
      start: 23,
      end:  26,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Sample each potentiometer multiple times.])
      )
    ),
    (
      start: 28,
      end:  30,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Forward potentiometer value to Host if it is different to last check.])
      )
    ),
  ),
  annotation-format: none
)
#figure(
  ```cpy
  
  POT_SELECT_VALUES = [(0, 0, 0), (0, 0, 1), (0, 1, 0), (0, 1, 1)]
  
  def init_potentiometers(self):
    self.last_pot_values = [0, 0, 0, 0]
    self.pot_select_objects = []
    self.pot_input_object = analogio.AnalogIn(MPLEX_INPUT_PIN)
    for pin in POT_SELECT_PINS:
      select_pin = digitalio.DigitalInOut(pin)
      select_pin.direction = digitalio.Direction.OUTPUT
      self.pot_select_objects.append(select_pin)
    asyncio.create_task(self.read_potentiometers())

    async def read_potentiometers(self):
      def map_value(raw):
        return int(((65535 - raw) / 65535) * 127)
      while True:
        for idx, setup in enumerate(POT_SELECT_VALUES):
          self.pot_select_objects[0].value = setup[0]
          self.pot_select_objects[1].value = setup[1]
          self.pot_select_objects[2].value = setup[2]
          samples = []
          for _ in range(NUM_SAMPLES):
            samples.append(self.pot_input_object.value)
            await asyncio.sleep(0.0005)
          avg_value = sum(samples) / NUM_SAMPLES
          mapped_value = map_value(avg_value)
          if math.fabs(mapped_value - self.last_pot_values[idx]) > 1:
            self.last_pot_values[idx] = mapped_value
            self.connection_handler.send_potentiometer(idx, mapped_value)
          await asyncio.sleep(0.001)
  ```,
  caption: [Methods on Controller for handling of potentiometers.]
) <listing:sprint4Pot>

The select pins were defined as digital pins using _digitalio_, as they did not require specific analog signals (@listing:sprint4Pot:9). However, the multiplexer output pin was set as an analog input port on the Pico 1's using _analogio_ (@listing:sprint4Pot:7).

Reading the potentiometer values worked by continuously iterating through an array containing the binary multiplexer settings for each potentiometer, setting the multiplexer to let a specific potentiometer's signal through one at a time (@listing:sprint4Pot:18).

The processing of the signals consisted of sampling the voltage from the potentiometers multiple times (@listing:sprint4Pot:23) and calculating the average 16-bit value read for each potentiometer from the samples (@listing:sprint4Pot:26). This was required as the potentiometers seemed to produce slightly fluctuating values. Afterwards, the averaged 16-bit number would be mapped to a range of 0-127 (@listing:sprint4Pot:27), as this is the range MIDI works in @wreglesworth_why_nodate. Lastly, it would be checked if this value was different than the potentiometer's last value (@listing:sprint4Pot:28), and if it was, it would be forwarded to the Host in a special message consisting of the ID of the potentiometer and its value (@listing:sprint4Pot:30). On the Host side, this message would be received and processed much like button presses (@sec:sprint2HostMidiInterface). The main difference is that, instead of sending MIDI note messages to Live, it would send _control change_ messages, which, in Live, could be configured to adjust a wide variety of settings; including instrument sound modifications. In the end, it was decided the four potentiometers should control the instrument's volume, delay, reverb and an amp effect.


== Button and Debouncing algorithm
A refined solution was implemented for handling button input and debouncing. A special task, `click_watcher` (@listing:sprint4Click:1) was created with the sole purpose of checking whether a single button had been pressed. When initializing the buttons (@listing:sprint4Click:11), a `click_watcher`-task would be created for and assigned to each button. This meant that button handling became theoretically parallel instead of serial.

#codly(
  annotations: (
    (
      start: 1,
      end:  10,
      content: block(
        width: 10em,
        align(left, box(width: 110pt)[Checks for \ button press.])
      )
    ),
    (
      start: 15,
      end:  16,
      content: block(
        width: 10em,
        align(left, box(width: 120pt)[Debounce array and \ interval in seconds.])
      )
    ),
    (
      start: 18,
      end:  25,
      content: block(
        width: 11em,
        align(left, box(width: 110pt)[Initialize buttons.])
      )
    ),
  ),
  annotation-format: none
)
#figure(
  ```cpy
  async def click_watcher(self, button, index):
        while True:
            current_value = button.value
            if current_value == False and self.button_states[index] == True:
                current_time = time.monotonic()
                if current_time - self.debounce_timers[index] >= self.debounce_interval:
                    self.connection_handler.send_note(index)
                    self.debounce_timers[index] = current_time
            self.button_states[index] = current_value
            await asyncio.sleep(0.001)

    def init_buttons(self):
        self.buttons = []
        self.button_states = []
        self.debounce_timers = [0] * len(BTN_PINS)
        self.debounce_interval = 0.002
        idx = 0
        for pin in BTN_PINS:
            btn = digitalio.DigitalInOut(pin)
            btn.direction = digitalio.Direction.INPUT
            btn.pull = digitalio.Pull.UP
            self.buttons.append(btn)
            self.button_states.append(True)
            asyncio.create_task(self.click_watcher(btn, idx))
            idx += 1
  ```,
  caption: [New `click_watcher(btn, idx)`, button initialization and debouncing.],
) <listing:sprint4Click>

A software debouncing routine was introduced by maintaining a dictionary that maps each button to its most recent activation time (@listing:sprint4Click:14). On each button press, the code reads the current time, computes the interval since the last recorded press of that button, and compares this against a predefined debounce threshold (@listing:sprint4Click:6). Only if the elapsed time exceeds that threshold is the event treated as a genuine button press, preventing a single physical actuation from registering as multiple clicks due to contact chatter @wright_what_2022.

The debounce interval was determined empirically using an oscilloscope to capture the button’s voltage waveform (@fig:sprint4Oscilloscope). During repeated actuations, the longest bounce period observed was approximately 1.5 ms. A 0.5 ms safety margin was added to set the debounce threshold at 2 ms (@listing:sprint4Click:16). This value comfortably outlasts any measured bounce while remaining brief enough to preserve responsive play.

#subpar.grid(
  columns: (auto, auto),
  caption: [Analyzing bounce of switches.],
  label: <fig:sprint4Oscilloscope>,
  align: top,
  figure(image("../images/sprint 4/Oscilloscope1.jpg", width: 100%),
    caption: [Testing and analyzing button's voltage waveform.]), <fig:oscilloscope1>,
  figure(image("../images/sprint 4/Oscilloscope2.jpg", width: 100%),
    caption: [Close-up of oscilloscope during debounce-analysis.]), <fig:oscilloscope2>
)

== Automatic card detection
To enable automatic NFC card detection, instead of having to push a button, it was decided to add a sensor-based trigger to the NFC reading mechanism. Since light-dependent resistors (LDR) were available they were selected for this purpose due to their relative simplicity and familiarity @arduinotechdk_lys_2025.

The idea behind the detection mechanism was placing a LED at the bottom of the holder for the NFC reader and placing the LDR through a small hole from the top side of the holder. When no card was present, the LED light would pass unobstructed to the LDR. However, when a card was inserted, it would block the light, causing the LDR's resistance to change. This shift in light intensity could then be detected in software, triggering the system to initiate an NFC card scan automatically.

To use the resistor as a sensor, a voltage divider using the LDR and another resistor were added to the schematic (@app:schematicSprint4). To determine the size of the resistor added to ensure proper functionality of the LDR and LED, calculations were made in an isolated test environment (@app:automaticCardDetection). While doing the calculations it was observed that the theoretical values were not exactly equal to the measured values. This was reasoned by the measured LDR resistances possibly not being completely accurate due to a volatile test environment. 

== PCB 
The printer was exchanged for a functioning model at the production facility (@sec:PCBsprint3), allowing for the fabrication of a functioning PCB.

During the soldering phase, several technical challenges were encountered. These included difficulties related to manual hole drilling, which affected the alignment and stability of mounted components. Additionally, this phase involved manually soldering vias, which proved particularly challenging due to poor solder adhesion, leading to fragile connections. Further inspection of the assembled PCB revealed several design errors. Fixing these required "hacks", such as soldering across traces and soldering wires directly on the PCB (@fig:PcbHack). 

#figure(
  image("../images/sprint 4/pcb4solderedtop.jpg", width: 50%),
  caption: ["Hacking" produced PCB by soldering external wire directly on it.]
) <fig:PcbHack>

Molex @molex_creating_2025 connectors were used to connect all off-board components, such as the USB port and power switch, to the PCB (@fig:molexConnectors). They were used because they provide secure and quick-release capability, simplifying assembly, disassembly and maintenance of the product. Although the NFC reader was originally planned to use a similar connector, it proved more practical to connect a pin-header @sullins_connector_solutions_100_nodate to it's pins and solder flexible wires between the header and the PCB (@fig:nfcHeader). This approach still allows the reader to be unplugged for removing the PCB without disturbing the rest of the wiring.

#subpar.grid(
  columns: (auto, auto),
  caption: [Internal connectors of Controller.],
  label: <fig:sprint4Molex>,
  align: top,
  figure(image("../images/sprint 4/molex4power.jpg", height: 15%),
    caption: [Molex connection for power button.]), <fig:molexConnectors>,
  figure(image("../images/sprint 4/molex4nfc.jpg", height: 15%),
    caption: [NFC pinheader connection.]), <fig:nfcHeader>
)

=== Multiplexer, potentiometers and LDR <potsprint4>
An unrelated issue arose concerning the functionality of the potentiometers when mounted in conjunction with other components, specifically the LDR. In this configuration, neither the potentiometers nor the LDR functioned as intended. The potentiometer readings had floating values, and the LDR failed to detect any significant changes in light levels. Given that these components were all connected through the multiplexer of the system, it was hypothesized that the root cause of the malfunction might have been inadequate grounding of the multiplexer's unused input channels– which was found to be essential for proper functionality as described in @sec:potsSprint2.

=== Ordering PCBs
To support cooperative experimentation and play (Requirement 1, @table:usabilityRequirements), a second Controller, and thus a new PCB, was required. Having experienced the pitfalls of manual PCB fabrication (@sec:PCBsprint3), the team chose to have the PCB professionally manufactured through JLCPCB @jlcpcbcom_pcb_2025, a service chosen for its reputability and competitive pricing. Reviewing the PCB order, both engineers at JLCPCB and the team’s own inspections uncovered several design issues: missing solder masks, incorrectly routed traces, and a misplaced footprint, which were promptly corrected prior to production.

Beyond simply offloading board etching, professional fabrication brought several practical advantages. First, the PCBs was made double-sided with a silkscreen layer on both faces, providing clear labels for component placement and orientation and greatly simplifying assembly. Second, JLCPCB handled all hole drilling and via formation, eliminating the most labor-intensive steps from the workflow. Finally, the boards had a thin factory-applied flux layer, which improved solderability and joint quality.

== Decorations for the Chassis <sec:decorations>
Previous user testing indicated that the target group preferred a more playful and engaging design, expressing interest in additional visual elements such as LEDs and the use of vibrant colors (@sec:sprint2test,). Participants had also requested clearer labeling on the chassis to provide immediate feedback regarding the function of the various switches and potentiometers.

To improve engagement (Requirement 11, @table:usabilityRequirements), a design plan was formulated, involving decorating the chassis using vinyl stickers. However, testing this approach on a 3D-printed lid yielded unsatisfactory results (@fig:vinyl). Concurrently, vector graphics were created for the purpose of generating vinyl stickers (@fig:topDesign), as the cutting equipment required vector-based file formats. These graphics were developed using the software Inkscape @inkscape_inkscape_2025. 

#subpar.grid(
  columns: (auto, auto),
  caption: [Lid Designs.],
  label: <fig:designTop>,
  align: top,
  gutter: 30pt,
  figure(image("../images/sprint 4/vinyl.jpg", height: 31%),
    caption: [Lid with vinyl.]), <fig:vinyl>,
  figure(rect(image("../images/sprint 4/top-design.svg", height: 30%), radius: 1mm),
    caption: [Lid Design in SVG format.]), <fig:topDesign>
)

== Testing <sec:test4>
The fourth round of user testing consisted of observing how participants interacted with a functional assembled Controller (@fig:sprint4TestSetup). However, as previously discussed in @potsprint4, issues with the multiplexer prevented the potentiometers and the automatic NFC reader sensor from working correctly. To make the NFC reader work, one of the interactive buttons was reconfigured to manually activate it. The potentiometers were disabled. The test was conducted at Rosengårdskolen @rosengardskolen_velkommen_nodate and involved four individual participants from the 5th grade. Each session lasted approximately seven minutes. A/B testing, think-aloud methodology, and unstructured interviews were employed.

#subpar.grid(
  columns: (auto, auto),
  caption: [Test setup for sprint 4.],
  label: <fig:sprint4setup>,
  align: top,
  gutter: 30pt,
  figure(image("../images/sprint 4/test4setup.jpg", height: 30%),
    caption: [Full Test Setup.]), <fig:sprint4TestSetup>,
  figure(image("../images/sprint 4/test4pots.jpg", height: 30%),
    caption: [Knob A/B test.]), <fig:sprint4TestKnobs>
)

Two participants reported having prior formal music training. One played the transverse flute and another the guitar; the remaining two had no previous musical experience.

When asked whether it was difficult to create a rhythm using the product, one participant responded: #quote[Yes, a little, because you do not really know where the buttons are and the sounds.] (@app:Sprint4Transcriptions), upon further prompting, the participant elaborated that the switch-sensitivity was a problem #quote[You know, they are quite fast if you keep pressing it.] (@app:Sprint4Transcriptions). Another participant noted: #quote[Yes, yes, you do have to remember what sounds comes out of which buttons.] (@app:Sprint4Transcriptions). To address this usability challenge, one participant suggested: #quote[Yes! It could be nice if it said what sounds come out of these buttons.] (@app:Sprint4Transcriptions).

Participants responded positively to the functionality of the display. One stated: #quote[It is fun! And it is kind of fascinating that the picture is displayed when you put a card in.] (@app:Sprint4Transcriptions). However, constructive criticism was provided regarding the physical design. One participant remarked that the potentiometers obstructed the display: #quote[These could be lowered a little because they hide almost all of the display.] (@app:Sprint4Transcriptions).

Two A/B tests were conducted. One using different side panel designs featuring varying slit widths for NFC card insertion. It became clear that one version was too narrow, as multiple participants reported difficulty inserting the cards. Furthermore, it was observed that participants did not find it intuitive to insert the NFC cards into the chassis.

The second A/B test had participants evaluate the different potentiometer knobs (@sec:sprint4Cad). The test showed that the participants liked the knobs resting on top of the lid the most (@fig:sprint4TestKnobs) because of its ergonomics and appearance (@app:Sprint4Transcriptions).

When asked whether the product would be more enjoyable as a shared experience, all participants expressed a preference for using it collaboratively. Lastly, interest in the potential commercialization of the product was expressed with one participant asking: #quote[Is it like so, that you would put it out?]  (@app:Sprint4Transcriptions).