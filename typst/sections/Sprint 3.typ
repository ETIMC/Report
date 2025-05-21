== Summarize Sprint 2



- Conclude what the test from sprint 2 did for the further development plans.

== What we did for this sprint
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

=== Instruments
- på baggrund af sprint 2 test
- Noget om flere kort (trompet+guitat), lyde dertil, pixelart
  
=== noget om kablet
  
=== Schmatic

=== PCB

==== Design

==== Production

=== Chassis Design

==== CAD design

==== 3D printing
== Testing on the Target Group

*Mechanical Turk, Wizard of Oz test*

The test was conducted at the University of Southern Denmark, where the prototype was evaluated by three individual participants. This test was very informal; a brief introduction was given about the product and the stage it was in. Furthermore, an unstructured interview was conducted. Each testing session lasted approximately 10 minutes.

During this test, the first iteration of the product’s outer shell was completed. Inside the enclosure, a non-functional PCB was installed, featuring pre-drilled holes to accommodate switches and potentiometers, as illustrated in Figure @fig:sprint3setup. Additionally, a screen with a Raspberry Pi Pico mounted directly on its back was placed into the designated cutout. The Pico was connected to a laptop, allowing the display to be updated manually. This setup enabled testers to simulate the experience of selecting an instrument by inserting a card into the prototype.

#figure(
  image("../images/box-v1.jpeg", height: 25%, width: 40%),
  caption: [Test Setup for Sprint 3],
) <fig:sprint3setup>

=== Summarized Feedback
During testing, participants expressed enjoyment while interacting with the product, despite its incomplete functionality. One participant noted that they believed the product would be highly enjoyable once fully operational.

Additionally, two of the participants had prior formal training in music, specifically in drumming and guitar. Their input provided a valuable perspective on whether the product could motivate users to learn a new instrument. While they personally did not feel inclined to pursue a new instrument, they suggested that the product could be especially beneficial for individuals without prior musical experience. They also expressed enthusiasm for the concept of collaborative play and found the interaction engaging to the point of reluctance in ending the session—leaving the room only after “just one more press of a button.”

When asked about the potential addition of LEDs, all participants favored the idea of a light strip encircling the entire box. They also appreciated the all-black design of the product, and the adjusted size was met with unanimous approval.
