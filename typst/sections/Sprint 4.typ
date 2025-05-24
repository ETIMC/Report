== CAD Design

Based on the test, the NFC side was changed to have a narrower opening. However, when printed, there was printed support in the opening. This was very hard to remove, and when used with the NFC card, the opening was found to be too small. So modifications for a slightly bigger hole were made and printed.

There were also designed potentiometers toppers, based on the earlier tests.  They were made with (#text(red)[kilde video pots]) in mind, but changed to fit the potentiometers and chassis. Many different options were modeled and printed.

pots

== Potentiometer MIDI

== Button and Debouncing algorithm


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
  image("../images/top-design.svg", height: 30%),
  caption: [Lid Design in SVG format.],
) <fig:topDesign>


== Testing
The third round of user testing was conducted at Rosengårdskolen and involved four individual participants from the 5th grade. Each session lasted approximately seven and a half minutes.

During this test, a functional prototype was presented (@fig:sprint4setup). However, as previously discussed in #text(red)[reference section yippie], issues with the PCB configuration prevented the potentiometers from functioning correctly during this session. The test employed A/B testing, Think Aloud methodology, and unstructured interviews.

#figure(
  image("../images/sprint4test.png", height: 25%, width: 100%),
  caption: [Test Setup for Sprint 4],
) <fig:sprint4setup>

Two participants reported having prior formal music training. One played the flute and another the guitar; the remaining two had no previous musical experience.

When asked whether it was difficult to create a rhythm using the product, one participant responded: #quote[Yes, a little, because you do not really know where the buttons are and the sounds.] (Translated from Danish to English) #text(red)[appendices reference], upon further prompting, the participant elaborated that the switch-sensitivity was a problem #quote[You know, they are quite fast if you keep pressing it.] (Translated from Danish to English) #text(red)[appendices reference]. Another participant noted: #quote[Yes, yes, you do have to remember what sounds comes out of with buttons.] (Translated from Danish to English) #text(red)[appendices reference] To address this usability challenge, one participant suggested: #quote[Yes! It could be nice if it said what sounds come out of these buttons.] (Translated from Danish to English) #text(red)[appendices reference].

Participants responded positively to the functionality of the display. One stated: #quote[It is fun! And it is kind of fascinating that the picture is displayed when you put a card in.] (Translated from Danish to English) #text(red)[appendices reference]. However, constructive criticism was provided regarding the physical design. One participant remarked that the potentiometers obstructed the display: #quote[These could be lowered a little because they hide almost all of the display.] (Translated from Danish to English) #text(red)[appendices reference].


An A/B test was conducted using different side panel designs featuring varying slit widths for NFC card insertion. It became clear that one version was too narrow, as multiple participants reported difficulty inserting the cards with ease. 

When asked whether the product would be more enjoyable as a shared experience, all participants expressed a preference for using it collaboratively.

Lastly, interest in the potential commercialization of the product was expressed with one participant asking: #quote[Is it like so, that you would put it out?] (Translated from Danish to English) #text(red)[appendices reference].