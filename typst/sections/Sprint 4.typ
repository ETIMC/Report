== PCB
Later, the production facility reverted to the previous printer configuration instead of the faulty one described @sec:PCBsprint3, allowing for a successfully fabricated PCB. During the soldering phase, several technical challenges were encountered. These included difficulties related to manual hole drilling, which affected the alignment and stability of mounted components. Additionally, this phase involved working with VIAs for the first time, which proved particularly challenging due to poor solder adhesion, leading to fragile connections. Further inspection of the assembled PCB revealed several design errors as well. These required "hacks" to establish the necessary connections and restore full functionality.

=== Multiplexer
An unrelated issue arose concerning the functionality of the potentiometers when mounted in conjunction with other components, specifically an LED and a light-dependent resistor (LDR) which were intended to detect if a NFC card was inserted into the chassis. In this configuration, neither the potentiometers nor the LDR functioned as inteded. The potentiometer readings had floating values, and the LDR failed to detect any significant changes in light levels. Given that these components were all connected through the multiplexer of the system, it was hypothesized that the root cause of the malfunction might have been inadequate grounding of the multiplexer's unused input channels– which was found to be essential for proper functionality as described in @sec:potsSprint2.

== Decorations for the Chassis
Previous user testing #text(red)[reference specific test] indicated that the target group preferred a more playful and engaging design, expressing interest in additional visual elements such as LEDs and the use of vibrant colors. Participants also requested clearer labeling on the chassis to provide immediate feedback regarding the function of the various switches and potentiometers.

Initially, to improve upon engagement (Requirement 11, @table:usabilityRequirements), the design plan involved decorating the chassis using vinyl stickers. However, testing this approach on a non-functional 3D-printed lid revealed that the results were unsatisfactory. Despite this, vector graphics were created for the purpose of generating vinyl stickers (@fig:topDesign), as the cutting equipment required vector-based file formats. These graphics were developed using the software Inkscape @inkscape_inkscape_2025 The vector artwork was later repurposed and integrated directly into the final 3D-printed lid design in order to enhance visual appeal.


#figure(
  image("../images/top-design.svg", height: 30%),
  caption: [Lid Design in SVG format.],
) <fig:topDesign>



== Testing