#import "@preview/codly:1.3.0": *
#import "@preview/subpar:0.2.2"

== CAD Design

Based on user testing, the NFC side of the chassis was redesigned with a narrower opening. During printing, however, support structures were generated inside the opening, which proved difficult to remove. Despite this, the smaller opening was retained for further testing, as previous testers had found the original size too large and had asked if unrelated objects could be inserted.

Additionally, potentiometer toppers were designed and developed based on earlier feedback. The initial designs were inspired by (VIDEO), but adjusted to match the specific dimensions of the potentiometers and the holes in the lid. Several versions were modeled and printed. The first prototype was a simple cap designed to fit directly onto the potentiometer shaft (IMAGE), used to verify fit and tolerances.

Thereafter, experimentation with how the bottom of the potentiometer topper should be begun. It was made to make toppers that went into the hole of the lid, so the PCB could not be seen (IMAGE). This was a good idea in theory, but it was very hard to turn. A new modified version of this was printed (IMAGE) and seemed to work. There were also printed two slightly different toppers with a flat facet (IMAGE 2 pots), which purpose were to lay on top of the lid, but still covering the holes for the PCB. Since all of the potentiometers toppers fitted and work, just had a different feeling, it was decided to test them on the target group, to get their thoughts about them.

As all designs fit mechanically and differed mainly in tactile feedback and ergonomics, it was decided to include them in testing with the target group to gather user preferences.

== Potentiometer MIDI

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
schematic

== PCB
Later, the production facility reverted to the previous printer configuration instead of the faulty one described in @sec:PCBsprint3, allowing for a successfully fabricated PCB. During the soldering phase, several technical challenges were encountered. These included difficulties related to manual hole drilling, which affected the alignment and stability of mounted components. Additionally, this phase involved working with VIAs for the first time, which proved particularly challenging due to poor solder adhesion, leading to fragile connections. Further inspection of the assembled PCB revealed several design errors as well. These required "hacks" to establish the necessary connections and restore full functionality.

- molex

=== Multiplexer, potentiometers and LDR
An unrelated issue arose concerning the functionality of the potentiometers when mounted in conjunction with other components, specifically an LED and a light-dependent resistor (LDR) which were intended to detect if a NFC card was inserted into the chassis. In this configuration, neither the potentiometers nor the LDR functioned as intended. The potentiometer readings had floating values, and the LDR failed to detect any significant changes in light levels. Given that these components were all connected through the multiplexer of the system, it was hypothesized that the root cause of the malfunction might have been inadequate grounding of the multiplexer's unused input channels– which was found to be essential for proper functionality as described in @sec:potsSprint2.

=== Ordering PCBs


== Decorations for the Chassis
Previous user testing #text(red)[reference specific test] indicated that the target group preferred a more playful and engaging design, expressing interest in additional visual elements such as LEDs and the use of vibrant colors. Participants also requested clearer labeling on the chassis to provide immediate feedback regarding the function of the various switches and potentiometers.

Initially, to improve upon engagement (Requirement 11, @table:usabilityRequirements), the design plan involved decorating the chassis using vinyl stickers. However, testing this approach on a non-functional 3D-printed lid revealed that the results were unsatisfactory. Despite this, vector graphics were created for the purpose of generating vinyl stickers (@fig:topDesign), as the cutting equipment required vector-based file formats. These graphics were developed using the software Inkscape @inkscape_inkscape_2025 The vector artwork was later repurposed and integrated directly into the final 3D-printed lid design in order to enhance visual appeal.


#figure(
  rect(image("../images/sprint 4/top-design.svg", height: 30%), radius: 2mm),
  caption: [Lid Design in SVG format.],
) <fig:topDesign>


== Testing
The third round of user testing was conducted at Rosengårdskolen and involved four individual participants from the 5th grade. Each session lasted approximately seven and a half minutes.

During this test, a functional prototype was presented (@fig:sprint4setup). However, as previously discussed in #text(red)[reference section yippie], issues with the PCB configuration prevented the potentiometers from functioning correctly during this session. The test employed A/B testing, Think Aloud methodology, and unstructured interviews.

#figure(
  image("../images/sprint 4/sprint4test.png", height: 25%, width: 100%),
  caption: [Test Setup for Sprint 4],
) <fig:sprint4setup>

Two participants reported having prior formal music training. One played the flute and another the guitar; the remaining two had no previous musical experience.

When asked whether it was difficult to create a rhythm using the product, one participant responded: #quote[Yes, a little, because you do not really know where the buttons are and the sounds.] (Translated from Danish to English) #text(red)[appendices reference], upon further prompting, the participant elaborated that the switch-sensitivity was a problem #quote[You know, they are quite fast if you keep pressing it.] (Translated from Danish to English) #text(red)[appendices reference]. Another participant noted: #quote[Yes, yes, you do have to remember what sounds comes out of with buttons.] (Translated from Danish to English) #text(red)[appendices reference] To address this usability challenge, one participant suggested: #quote[Yes! It could be nice if it said what sounds come out of these buttons.] (Translated from Danish to English) #text(red)[appendices reference].

Participants responded positively to the functionality of the display. One stated: #quote[It is fun! And it is kind of fascinating that the picture is displayed when you put a card in.] (Translated from Danish to English) #text(red)[appendices reference]. However, constructive criticism was provided regarding the physical design. One participant remarked that the potentiometers obstructed the display: #quote[These could be lowered a little because they hide almost all of the display.] (Translated from Danish to English) #text(red)[appendices reference].


An A/B test was conducted using different side panel designs featuring varying slit widths for NFC card insertion. It became clear that one version was too narrow, as multiple participants reported difficulty inserting the cards with ease. 

When asked whether the product would be more enjoyable as a shared experience, all participants expressed a preference for using it collaboratively.

Lastly, interest in the potential commercialization of the product was expressed with one participant asking: #quote[Is it like so, that you would put it out?] (Translated from Danish to English) #text(red)[appendices reference].