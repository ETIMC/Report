#import "@preview/codly:1.3.0": *

== Summarize Sprint 2

- Conclude what the test from sprint 2 did for the further development plans.

== What we did this sprint
- Further experimentation with Multiplexer functionality
  - To get a stable connection each A-pin on the multiplexer not in use must be set to ground, otherwise the values on the potentiometers will float A LOT and interfere with each other.
- Further work on Fusion implementation
  - Added Support implementation for the PCB to stay in place.
  - Added NFC holder
  - Added NFC-card holder/stopper.
  - Added hole for on/off button.
  - Added hole for USB-B port. 
  - Added hole for NFC-card insertion.
- PCB production
  - Created, modified, and imported footprints for the display, switches, and Pico. 
  - Finished footprint configuration in KiCad (with the help of autorouter thingy), first time working with VIAs.  
  - Problem with printer, making it seem like items (pico and screen) didn´t fit and then fit, but did not fit on pcb
  - Produced PCB.
  - Drilled holes
  - Soldered
  - Tested
- 3D printed Fusion implementation
  - First draft of lid (NOT FINISHED DESIGN, NO TIME WAH)
  - Updated base (lower walls.)
  - Four walls.
  - Modular for easy reach of things.
  - Screws.
- Planned testing.
  - Conducted testing

== Multiplexer experimentation

== NFC Reader and Display SPI solution

== More instruments
- på baggrund af sprint 2 test
- Noget om flere kort (trompet+guitat), lyde dertil, pixelart

== Lowering latency
=== UDP
As discuss in @sec:sprint2WifiProblems, latency, primarily caused by TCP, was experienced when playing on the Controller. To improve this, the WiFi system was changed to use UDP instead.
This was mostly a simple process. Most rewriting consisted of removing TCP sockets (@listing:exchangingSocketsDiff:1) and exchanging them with the addresses of the controllers (@listing:exchangingSocketsDiff:3). As UDP is not connection-oriented, this was necessary for the host to be able to identify and remember the controllers that connect to it.

This improved the latency a fair bit. Sadly, however, the latency was still noticeable, which lead to a more drastic change being made.

#codly(
  highlighted-lines: ((1, red.lighten(60%)), (2, red.lighten(60%)), (3, green.lighten(60%)), (4, green.lighten(60%))),
)
#figure(
  ```cpy
  - def _received_heartbeat(self, socket):
  -      self.socket_responses[socket] = 0
  +  def _received_heartbeat(self, addr):
  +      self.socket_responses[addr] = 0
  ```,
  caption: [Example of changing TCP code (red) to UDP code (green) by exchanging sockets for addresses.]
) <listing:exchangingSocketsDiff>

=== Wired

- To minimize latency, we shifted to a wired connection
- This is in violation of multiple requirements, but it was considered worth it
  - Big fear latency would discourage children from playing, as it didn't feel good
  - Real music instruments are instant. Our product should be as close to that as possible
  - Allowed remove batteries. More plug'n' play?
- Steps to do it
  - First, choose communication protocol. I2C was chosen.
    - Low pin amount requirements
  - Implemented on a breadboard
    - Important to quickly do this to test before wasting too much time with this idea
    - It worked great, and the code was changed
  - How should they physically be connected?
    - USB Type B
      - Exactly four pins
      
== Schematic

== PCB

=== Design

=== Production

== Chassis Design

=== CAD design

=== 3D printing

== Testing on the Target Group
The test took place at the University of Southern Denmark, where the prototype was evaluated by three participants. Each test took approximately 8 minutes.

During this test, the first iterations of the product's outer shell was completed, inside a non-functional PCB was installed as seen in @fig:sprint3setup. Additionally, a display with a Pico 2 mounted directly on it was connected to a laptop, allowing the display to be updated manually. This made it possible to conduct a Mechanical Turk/Wizard of Os test #text(red)[cite], where testers were able to simulate the experience of selecting an instrument by inserting an NFC card into the prototype.

Furthermore, during this test A/B, Think Aloud, and unstructured interview methodologies were used. 

#figure(
  image("../images/box-v1.jpeg", height: 25%, width: 40%),
  caption: [Test Setup for Sprint 3],
) <fig:sprint3setup>

