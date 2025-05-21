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
To completely eliminate the perceived latency, the decision was made to replace the wireless connectivity with wired connectivity. This was not an easy decision to make as it directly contradicted the Wireless connection technical requirement (Requirement 4, @table:technicalRequirements). Furthermore, there was fear that a tethered connection would limit the users' desired modes of interaction. However, the latency reduction was deemed critical, as there was fear that users would be discouraged from using the product, if it didn't "feel" good enough to use, so the change was made.

The wired solution offered two key advantages that outweighed its drawbacks. First, it removed nearly all latency, delivering an immediate response that felt more natural and expected. Second, it enabled the controllers to draw power directly from the host rather than relying on onboard batteries. Removing batteries not only lightened the controllers portability (Requirement 2, @table:usabilityRequirements), but also reduced product maintenance.

==== Process
For managing the now wired connection, $I^2C$ was used. Though SPI had been quicker @campbell_basics_2016 it would also have required another SPI bus on the Pico 1's which was not possible after allocating the NFC reader and the display an SPI bus each. Furthermore, this would require four pins on each Pico 1 and three pins plus one pin for each controller on the host @campbell_basics_2016-1 whereas $I^2C$ only requires two pins on each Pico @campbell_basics_2016.

Choosing $I^2C$ over SPI also enabled reusing larger parts of the existing codebase. Since it works by sending frames, which resembles WiFi's HTTP messages that were currently being used, the code changes on the Host were somewhat minimal. The primary code change was in how the host found connected Controllers and read from them. Finding hosts was very easily done by calling `self.i2c.scan()`, which returned an array of connected addresses (@listing:hostScanI2C:4). Reading messages from the host was also very easily though also very different than reading HTTP messages. Whereas HTTP messages worked by having the Controller send the messages and then having the Host read them when ready, $I^2C$ worked by making the Host tell each controller that it was ready to receive messages from the Controllers (@listing:hostScanI2C:9). Only then, could the Controllers send their messages.

A lot of the earlier code was also refactored, splitting it into multiple files (`connection_handler.py`, `midi_handler.py` etc.), making sure each file only concerned itself with one part of the codebase. This made it easier to maintain and extend.

#codly(skips: ((6, 3), ))
#figure(
  ```cpy
  current_time = time.monotonic()
  if current_time - self.last_scan_time >= SCAN_INTERVAL:
      self.last_scan_time = current_time
      self.addresses = self.i2c.scan()
  for controller in self.addresses:
          self.i2c.readfrom_into(controller, buf)
  ```,
  caption: [Host scanning for Controllers (4) and reading from each connected Controller (9).]
) <listing:hostScanI2C>

The controller code was changed a bit more than the Host's code. This was primarily caused by the previously mentioned fact, that the Controller had to wait for the Host to request messages from it. To accommodate this new way for messages to be transported, a queue was implemented on the Controller side just like it had been on the Host side (@sec:sprint2HostMidiInterface). This queue would hold all messages that were ready to be sent to the Host. Whenever the Host then requested a message (@listing:ControllerI2C:2), the Controller would pop an element from the queue (@listing:ControllerI2C:10) and send it (@listing:ControllerI2C:14). Here it was also discovered, it was important that each message had the same size, as the Host needed to know how many incoming bytes to read. It was decided that each message should be 16 bytes. Before sending the message the Controller therefore pads all its messages until it is 16 bytes (@listing:ControllerI2C:13).

#codly(
  annotations: (
    (
      start: 2,
      end:  5,
      content: block(
        width: 22em,
        align(left, box(width: 100pt)[Wait until Host requests message.])
      )
    ),
    (
      start: 9,
      end:  11,
      content: block(
        width: 20em,
        align(left, box(width: 100pt)[Pop one element from queue.])
      )
    ),
    (
      start: 12,
      end:  13,
      content: block(
        width: 20em,
        align(left, box(width: 100pt)[Pad the message and send it to the Host.])
      )
    ),
  )
)
#figure(
  ```cpy
  while True:
      req = device.request()
      if not req:
          await asyncio.sleep(0.001)
          continue
      with req:
          if req.is_read:
              payload = DONE_MESSAGE
              if not self.queue.empty():
                  payload = self.queue.get()
              data = payload
              padding = b"\x00" * (16 - len(data))
              req.write(data + padding)
      await asyncio.sleep(0.001)
  ```,
  caption: [Controller unloading queue to Host (10), when Host requests messages (2).]
) <listing:ControllerI2C>

During internal testing a second Pico 1 was connected to briefly test, how the Host handled having two Controllers connected. The test went well apart from one problem. The host couldn't differentiate between the Controllers. After debugging it was discovered that since the Controller code was simply copied from the first Pico 1 to the other one, they had the same $I^2C$ address set. After changing this address on the second Pico, the two Picos were able to communicate flawlessly with the Host without any noticeable latency or delay.

=== Physical interface

  - How should they physically be connected?
    - USB Type B
      - Exactly four pins
      
== Schematic
- Her skal den nye strømløsning nok nævnes (via USB. Brug Pico datasheet igen)
- David kan også skrive om, at Pico'erne trak for meget strøm

== PCB
=== Design
To develop a fully functional prototype beyond a breadboard implementation, a custom PCB was designed. During this process, practical considerations such as the placement of mounting holes for integration within the final chassis were taken into account. Additionally, due to the use of specific components that lacked readily available footprints, several custom or modified footprints were created as part of the PCB design.

The GitHub repository KiCad-RP-Pico @ncarandini_kicad-rp-pico_nodate served as the foundation for the Pico footprint. However, since the prototype utilized Pico 2 boards, minor modifications were made to the original footprint, including the removal of several unnecessary pin-holes. This adapted footprint also served as the template for designing the display's footprint, given that the display module shared the same number of pins as the Pico. In addition, a separate GitHub repository providing various switch footprints @siderakb_key-switchespretty_nodate was referenced for the switch components. This footprint was also modified to suit the project's specific needs.

=== Production
Several issues emerged during the PCB production phase, as illustrated in @fig:PCBMistakes. One of the primary setbacks was caused by the printer setting "Fit to Page", which unintentionally scaled down the PCB layout. As a result, the printed design no longer matched the actual dimensions needed, rendering the PCB unusable. This led to a misdiagnosis of the problem as an error with the footprints themselves, prompting unnecessary modifications to the newly designed footprints. These adjustments were later reversed upon the realization that the original footprints had been correct and that the issue stemmed from the incorrect printer setting.

Once this problem was resolved, a second issue arose due to the change in the printer at the production facilities. The newly installed printer utilized ink, which was incompatible with the PCB fabrication process and led to additional delays, as the resulting PCB was not viable for use.

#figure(
  image("../images/pcb-mistakes.jpeg", height: 25%, width: 100%),
  caption: [*Left*: "Fit to Page" scaling problems. *Middle*: Wrong footprint scaling. *Right*: Ink Problems.],
) <fig:PCBMistakes>

Later, the production facility reverted to the previous printer configuration, allowing for a successfully fabricated PCB. During the soldering phase, several technical challenges were encountered. These included difficulties related to manual hole drilling, which affected the alignment and stability of mounted components. Additionally, this phase involved working with VIAs for the first time, which proved particularly challenging due to poor solder adhesion, leading to fragile connections. Further inspection of the assembled PCB revealed several design errors as well. These required "hacks" to establish the necessary connections and restore full functionality.

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

