#import "@preview/codly:1.3.0": *
#import "@preview/subpar:0.2.2"

overview

== CAD Design

Based on user testing, the NFC side of the chassis was redesigned with a narrower opening. During printing, however, support structures were generated inside the opening, which proved difficult to remove. Despite this, the smaller opening was retained for further testing, as previous testers had found the original size too large and had asked if unrelated objects could be inserted.

Additionally, potentiometer toppers were designed and developed based on earlier feedback. The initial designs were inspired by (VIDEO), but adjusted to match the specific dimensions of the potentiometers and holes in the lid. Several versions were modeled and printed. The first prototype was a simple cap designed to fit directly onto the potentiometer shaft (IMAGE), used to verify fit and tolerances.

Thereafter, experimentation with how the bottom of the potentiometer topper should be begun. It was made to make toppers that went into the hole of the lid, so the PCB could not be seen (IMAGE). This was a good idea in theory, but it was very hard to turn. A new modified version of this was printed (IMAGE) and seemed to work. There were also printed two slightly different toppers with a flat facet (IMAGE 2 pots), which purpose were to lay on top of the lid, but still covering the holes for the PCB. Since all of the potentiometers toppers fitted and work, just had a different feeling, it was decided to test them on the target group, to get their thoughts about them.

As all designs fit mechanically and differed mainly in tactile feedback and ergonomics, it was decided to include them in testing with the target group to gather user preferences.

== Potentiometer MIDI
The functionality of the potentiometers was handled in much different way than the buttons. Since they were all plugged in to a multiplexer, each potentiometer could only be read, when the three "select" pins on the multiplexer were set to the right binary values.

The select pins were defined as digital pins using _digitalio_, as they did not require specific analog signals (@listing:sprint4Pot:9). However, the multiplexer output pin was set as an analog input port on the Pico 1's using _analogio_ (@listing:sprint4Pot:7).

The reading of the potentiometers themselves worked by continuously iterating through and array of the multiplexer settings for each potentiometer, setting the multiplexer to let that potentiometers signal through (@listing:sprint4Pot:18). This signal was then read and processed before continuing to the next setting.

The processing of the signals consisted of sampling the potentiometer multiple times (@listing:sprint4Pot:23) and getting the average read 16-bit value from the samples (@listing:sprint4Pot:26). This was required as the potentiometers seemed to produced slightly fluctuating values. Afterwards, the averaged 16 bit number would be mapped to a range of 0-127 (@listing:sprint4Pot:27), as this is the range MIDI works in. Lastly, it would be checked if this value was different than the potentiometer's last value (@listing:sprint4Pot:28), and if it was, it would be forwarded to the Host in a special message consisting of the id of the potentiometer and its value (@listing:sprint4Pot:30). On the Host side, this message would be received and processed much like button presses. The main difference is that, instead of sending MIDI notes messages to Ableton Live 11, it would send _control change_ messages, which, in Ableton Live 11, can be configured to adjust a wide variety of settings; including instrument sound modifications.

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

== Button and Debouncing algorithm
Though it worked fine having each button checked serially by iterating through an array (@sec:sprint2Buttons), a better solution was implemented. This was done by creating a special function, `click_watcher` (@listing:sprint4Click: 1), with the sole purpose of checking whether a single button had been pressed. When initializing the buttons (@listing:sprint4Click:11), a task would be created for and assigned to each button. This meant that button handling became theoretically parallel instead of serial.

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

A software debouncing routine was introduced by maintaining a dictionary that maps each button to its most recent activation time (@listing:sprint4Click:14). On each button press, the code reads the current time, computes the interval since the last recorded press of that button, and compares this against a predefined debounce threshold (@listing:sprint4Click:6). Only if the elapsed time exceeds that threshold is the event treated as a genuine button press, preventing a single physical actuation from registering as multiple clicks due to contact chatter #cite(<wright_what_2022>).

The debounce interval was determined empirically using an oscilloscope to capture the button’s voltage waveform (@fig:sprint4Oscilloscope). During repeated actuations, the longest bounce period observed was approximately 1.5 ms. A 0.5 ms safety margin was added to set the debounce threshold at 2 ms (@listing:sprint4Click:16). This value comfortably outlasts any measured bounce while remaining brief enough to preserve responsive play.

#subpar.grid(
  columns: (auto, auto),
  caption: [Analyzing bounce of switches.],
  label: <fig:sprint4Oscilloscope>,
  align: top,
  figure(image("../images/sprint 4/Oscilloscope1.jpg", width: 100%),
    caption: [First attempt at designing controller box.]), <fig:oscilloscope1>,
  figure(image("../images/sprint 4/Oscilloscope2.jpg", width: 100%),
    caption: [Controller chassis after changes.]), <fig:oscilloscope2>
)

== Automatic card detection

To enable automatic NFC card detection, instead of having to push the button, it was decided to add a sensor-based trigger to the NFC base. Since light-dependent resistors (LDRs) were available they were selected for this purpose due to their  relative simplicity and previous integration experience.

The idea behind the detection mechanism was placing a red LED at the bottom of the NFC base and placing the LDR through a small hole from the top side of the base. When no card was present, the LED light would pass unobstructed to the LDR. However, when a card was inserted, it would block the light, causing the LDR's resistance to change. This shift in light intensity could then be detected in software, triggering the system to initiate an NFC card scan automatically.

Before the setup of the LDR and the LED, a lot of calculations were made. Both to figure out which resistors should be used and to detect the reading values of the LDR inside the box, when it was just connected to a breadboard. This part was easy, but when connected to the PCB, it caused problems.

- schematic


== PCB 
Later, the production facility reverted to the previous printer configuration instead of the faulty one described in @sec:PCBsprint3, allowing for a successfully fabricated PCB. During the soldering phase, several technical challenges were encountered. These included difficulties related to manual hole drilling, which affected the alignment and stability of mounted components. Additionally, this phase involved working with VIAs for the first time, which proved particularly challenging due to poor solder adhesion, leading to fragile connections. Further inspection of the assembled PCB revealed several design errors as well. These required "hacks" to establish the necessary connections and restore full functionality.

Molex connectors were used to connect all off-board components—such as the USB port and power switch to the PCB. They were used because they provide secure and quick-release capability, simplifying assembly and maintenance. Although the NFC reader was originally planned to use a similar connector, it proved more practical to connect a pin-header to it's pins and solder flexible wires between the header and the PCB. This approach still allows the reader to be unplugged for removing the PCB without disturbing the rest of the wiring.

=== Multiplexer, potentiometers and LDR <potsprint4>
An unrelated issue arose concerning the functionality of the potentiometers when mounted in conjunction with other components, specifically an LED and a light-dependent resistor (LDR) which were intended to detect if a NFC card was inserted into the chassis. In this configuration, neither the potentiometers nor the LDR functioned as intended. The potentiometer readings had floating values, and the LDR failed to detect any significant changes in light levels. Given that these components were all connected through the multiplexer of the system, it was hypothesized that the root cause of the malfunction might have been inadequate grounding of the multiplexer's unused input channels– which was found to be essential for proper functionality as described in @sec:potsSprint2.

=== Ordering PCBs
To support cooperative experimentation and play (Requirement 1, @table:usabilityRequirements), a second Controller, and thus a new PCB, was required. Having experienced the pitfalls of manual board fabrication, the team elected to professionally manufacture the design through JLCPCB, a service chosen for its reputability and competitive pricing #cite(<jlcpcbcom_pcb_2025>). During the order review, both JLCPCB’s automated checks and the team’s own inspections uncovered several design issues: missing solder masks, incorrectly routed traces, and a misplaced footprint, which were promptly corrected prior to production.

Beyond simply offloading board etching, professional fabrication brought several practical advantages. First, the PCBs could be made double-sided with silkscreen on both faces, providing clear labels for component placement and orientation and greatly simplifying assembly. Second, JLCPCB handled all hole drilling and via formation, eliminating the most labor-intensive steps from the workflow. Finally, the boards arrived with a factory-applied thin flux layer, which improved solderability and joint quality.

== Decorations for the Chassis
Previous user testing #text(red)[reference specific test] indicated that the target group preferred a more playful and engaging design, expressing interest in additional visual elements such as LEDs and the use of vibrant colors. Participants also requested clearer labeling on the chassis to provide immediate feedback regarding the function of the various switches and potentiometers.

Initially, to improve upon engagement (Requirement 11, @table:usabilityRequirements), the design plan involved decorating the chassis using vinyl stickers. However, testing this approach on a non-functional 3D-printed lid revealed that the results were unsatisfactory. Despite this, vector graphics were created for the purpose of generating vinyl stickers (@fig:topDesign), as the cutting equipment required vector-based file formats. These graphics were developed using the software Inkscape @inkscape_inkscape_2025. The vector artwork was later repurposed and integrated directly into the final 3D-printed lid design in order to enhance visual appeal.

#figure(
  rect(image("../images/sprint 4/top-design.svg", height: 30%), radius: 2mm),
  caption: [Lid Design in SVG format.],
) <fig:topDesign>

== Testing
The third round of user testing was conducted at Rosengårdskolen and involved four individual participants from the 5th grade. Each session lasted approximately seven and a half minutes.

During this test, a functional prototype was presented (@fig:sprint4setup). However, as previously discussed in @potsprint4, issues with the PCB configuration prevented the potentiometers from functioning correctly during this session. The test employed A/B testing, Think Aloud methodology, and unstructured interviews.

#figure(
  image("../images/sprint 4/sprint4test.png", height: 25%, width: 100%),
  caption: [Test Setup for Sprint 4],
) <fig:sprint4setup>

Two participants reported having prior formal music training. One played the transverse flute and another the guitar; the remaining two had no previous musical experience.

When asked whether it was difficult to create a rhythm using the product, one participant responded: #quote[Yes, a little, because you do not really know where the buttons are and the sounds.] (Translated from Danish to English) (@app:Sprint4Transcriptions), upon further prompting, the participant elaborated that the switch-sensitivity was a problem #quote[You know, they are quite fast if you keep pressing it.] (Translated from Danish to English) (@app:Sprint4Transcriptions). Another participant noted: #quote[Yes, yes, you do have to remember what sounds comes out of with buttons.] (Translated from Danish to English) (@app:Sprint4Transcriptions). To address this usability challenge, one participant suggested: #quote[Yes! It could be nice if it said what sounds come out of these buttons.] (Translated from Danish to English) (@app:Sprint4Transcriptions).

Participants responded positively to the functionality of the display. One stated: #quote[It is fun! And it is kind of fascinating that the picture is displayed when you put a card in.] (Translated from Danish to English) (@app:Sprint4Transcriptions). However, constructive criticism was provided regarding the physical design. One participant remarked that the potentiometers obstructed the display: #quote[These could be lowered a little because they hide almost all of the display.] (Translated from Danish to English) (@app:Sprint4Transcriptions).


An A/B test was conducted using different side panel designs featuring varying slit widths for NFC card insertion. It became clear that one version was too narrow, as multiple participants reported difficulty inserting the cards with ease. 

When asked whether the product would be more enjoyable as a shared experience, all participants expressed a preference for using it collaboratively. Lastly, interest in the potential commercialization of the product was expressed with one participant asking: #quote[Is it like so, that you would put it out?] (Translated from Danish to English) (@app:Sprint4Transcriptions).