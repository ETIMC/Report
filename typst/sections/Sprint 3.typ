#import "@preview/codly:1.3.0": *

Introduction to sprint 3
- Naevn nye switches blev valgt

/*
- Conclude what the test from sprint 2 did for the further development plans.

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
*/

== More instruments
Based on the breadboard prototype tests (@sec:sprint2test), two additional instruments, a trumpet and a guitar, were integrated into the system. In Ableton Live 11, this involved creating two new MIDI tracks, each loaded with a high-quality trumpet or guitar virtual instrument and assigned to its own dedicated MIDI channel. Correspondingly, the controller’s instrument-selection UI was updated: two new images (one for the trumpet, one for the guitar) were designed and added to the display, ensuring users receive clear visual feedback whenever they switch to one of these instruments. Lastly, two new NFC cards were assigned to each of the instruments.


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
For managing the now wired connection, I²C was used. Though SPI had been quicker @campbell_basics_2016 it would also have required another SPI bus on the Pico 1's which was not possible after allocating the NFC reader and the display an SPI bus each. Furthermore, this would require four pins on each Pico 1 and three pins plus one pin for each controller on the host @campbell_basics_2016-1 whereas I²C only requires two pins on each Pico @campbell_basics_2016.

Choosing I²C over SPI also enabled reusing larger parts of the existing codebase. Since it works by sending frames, which resembles WiFi's HTTP messages that were currently being used, the code changes on the Host were somewhat minimal. The primary code change was in how the host found connected Controllers and read from them. Finding hosts was very easily done by calling `self.i2c.scan()`, which returned an array of connected addresses (@listing:hostScanI2C:4). Reading messages from the host was also very easily though also very different than reading HTTP messages. Whereas HTTP messages worked by having the Controller send the messages and then having the Host read them when ready, I²C worked by making the Host tell each controller that it was ready to receive messages from the Controllers (@listing:hostScanI2C:9). Only then, could the Controllers send their messages.

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
        align(left, box(width: 120pt)[Wait until Host requests message.])
      )
    ),
    (
      start: 9,
      end:  11,
      content: block(
        width: 20em,
        align(left, box(width: 110pt)[Pop one element from queue.])
      )
    ),
    (
      start: 12,
      end:  13,
      content: block(
        width: 20em,
        align(left, box(width: 110pt)[Pad the message to 16 bytes, and send it to the Host.])
      )
    ),
  ),
  annotation-format: none
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

During internal testing a second Pico 1 was connected to briefly test, how the Host handled having two Controllers connected. The test went well apart from one problem. The host couldn't differentiate between the Controllers. After debugging it was discovered that since the Controller code was simply copied from the first Pico 1 to the other one, they had the same I²C address set. After changing this address on the second Pico, the two Picos were able to communicate flawlessly with the Host without any noticeable latency or delay.

==== Physical interface <sec:sprint3PhysicalInterface>
Standard USB 2.0 Type B to USB 2.0 Type A cables were chosen to physically link the Controllers and Host because they strike an ideal balance between availability, affordability, robustness, and electrical simplicity. These cables are more robust and easier to plug in than smaller connectors, which was believed would highten the portability and plug'N'play usability of the system (Requirement 3 & 7, @table:usabilityRequirements). Most importantly, each cable carries exactly four conductors, and each connector exposes exactly four pins. This meant that two pins could reserved for power (+5V and ground), while the two other pins could be reserved for the two required I²C pins: SDA and SCL.

Beyond pin count, USB Type B connectors offer good mechanical retention and strain relief, helping to prevent accidental disconnections during use. Standard cable lengths (up to 5 meters for USB 2.0) provide good reach, mitigating some of the flexibility downsides of switching from wireless connectivity. Lastly, by relying on off-the-shelf USB cables rather than custom cables, the design minimizes part variety, simplifies sourcing and replacement, and leverages existing technology, possibly familiar to users.

== Circuitry
=== SPI Busses
To address the instability of the NFC reader that arose after integrating the display (@sec:Sprint2Display), the display was moved to a separate SPI bus with its own dedicated GPIO pins. Following this change, the NFC reader resumed functioning reliably. This strongly suggested that the issue stemmed from the individual CircuitPython drivers for the NFC reader and display not supporting shared use of a single SPI bus. By isolating them onto separate buses, any conflicts were avoided, confirming this as the likely cause of the instability.

=== New power solution
With the Controllers now linked to the Host via cable, the onboard battery, MOSFET, and resistor were removed from the Controller’s power circuit on the schematic and replaced with a USB 2.0 Type B connector. Of its four pins, two were assigned to power: the connector’s ground pin was tied to the Pico 1’s GND, and its VBUS pin was routed to the Pico 1’s VSYS input to supply +5 V #cite(<raspberry_pi_raspberry_2024-1>). The remaining two pins were designated for I²C (SDA and SCL) and wired to two digital GPIOs on the Pico 1.

On the Host side, the USB 2.0 Type A connector’s ground and I²C pins were wired identically. The VBUS pin, however, was connected directly to the Pico 2’s VBUS output, drawing power from the connected computer’s USB port #cite(<raspberry_pi_raspberry_2024>) like the Host. This arrangement streamlines the power design and ensures both devices receive stable +5 V while sharing a common I²C bus over the same cable.

The new power solution was not without problems however. During internal testing it was discovered that when the host, and now therefore also the controllers, were connected to a powered USB hub, other devices to the hub would not receive their required power. This was discovered by having a the audio of a connected audio interface starting to crackle, when the Host was connected. Furthermore, it was discovered that neither the Host or any connected Controllers would function properly when connected to a laptop, unless the laptop was actively being charged. However, as long as the laptop was being charged, everything worked fine.

During internal testing of the new USB-powered setup, two power-related issues emerged. First, when the Host—and by extension its Controllers—were plugged into a powered USB hub, downstream devices on that hub began to lose power, evidenced by crackling audio from a connected audio interface. Second, when connected directly to a laptop’s USB ports, neither the Host nor any attached Controllers would operate correctly unless the laptop itself was also connected to its charger. On battery power alone, the laptop’s USB ports were unable to supply sufficient current, causing the devices to malfunction. Once the laptop was charging, its USB ports delivered adequate power and all components worked reliably.

== PCB <sec:PCBsprint3>
=== Design
To develop a fully functional prototype beyond a breadboard implementation, a custom PCB was designed. During this process, practical considerations such as the placement of mounting holes for integration within the final chassis were taken into account. Additionally, due to the use of specific components that lacked readily available footprints, several custom or modified footprints were created as part of the PCB design.

The GitHub repository KiCad-RP-Pico @ncarandini_kicad-rp-pico_nodate served as the foundation for the Pico footprint. However, since the prototype utilized Pico 2 boards, minor modifications were made to the original footprint, including the removal of several unnecessary pin-holes. This adapted footprint also served as the template for designing the display's footprint, given that the display module shared the same number of pins as the Pico. In addition, a separate GitHub repository providing various switch footprints @siderakb_key-switchespretty_nodate was referenced for the switch components. This footprint was also modified to suit the project's specific needs.

The PCB was initially routed using the _FreeRouting_ tool #cite(<noauthor_freeroutingfreerouting_2025>), but the generated layout proved impractical for soldering. Because the board was to sit just beneath the chassis surface, for space purposes, a two-sided design was required: buttons and display on the top, all other components on the bottom. Unfortunately, FreeRouting did not honor these layer constraints, placing several critical traces, including some for button contacts, on the top copper foil where they would interfere with component pads.

To resolve this, the PCB was redesigned and all traces were drawn manually, ensuring that top-side copper was reserved exclusively for button and display connections and that all other routing remained on the bottom layer.

=== Production
Several issues emerged during the PCB production phase, as illustrated in @fig:PCBMistakes. One of the primary setbacks was caused by the automatically enabled printer setting "Fit to Page", which unintentionally scaled down the PCB layout. As a result, the printed design no longer matched the actual dimensions needed, rendering the PCB unusable. This led to a misdiagnosis of the problem as an error with the footprints themselves, prompting unnecessary modifications to the newly designed footprints. These adjustments were later reversed upon the realization that the original footprints had been correct and that the issue stemmed from the incorrect printer setting. However, the root of the problem was first discovered after spending a considerable amount of time drilling all the holes in the PCB.

Once the problem was resolved, a new issue arose due to the change in the printer at the production facilities. The newly installed printer utilized ink incompatible with the PCB fabrication process which led to additional delays, as the resulting PCB was not viable for use.

#figure(
  image("../images/sprint 3/pcb-mistakes.jpeg", height: 25%, width: 100%),
  caption: [*Left*: "Fit to Page" scaling problems. *Middle*: Wrong footprint scaling. *Right*: Ink Problems.],
) <fig:PCBMistakes>

== Chassis Design

=== CAD design
Based on the previously 3D printed chassis (#text(red)[reference til sprint2 fusion]), several features were added and refined through iterative design. 
One of the first additions was the creation of the PCB standoffs—four cylindrical supports with central screw holes, aligned to match the mounting holes of the PCB. Before printing, the placement and alignment of the standoffs were verified in Fusion by inserting a model of the PCB to ensure proper fit.

A dedicated NFC reader holder was also designed. This component included a fixed position for the NFC module and a dedicated slot for card insertion. A stop point was added inside the slot to prevent the cards from being inserted too far into the chassis, both to protect other internal components and in response to user testing from Sprint 2 (#text(red)[kilde]), where children expressed curiosity about placing objects into the opening. Additionally, holes were included in the NFC holder for an LDR sensor and an LED.

Two new side panels were created as variations of the original design. The first was the NFC side panel, which featured a large rectangular opening with smoothed edges to ensure safe use. The second was the rear side panel, where cutouts were added for both a USB-B connector and a physical on/off switch.

Lastly, the lid was designed to align with the base of the chassis and the component layout on the PCB. Corresponding cutouts were added for the buttons, display, and potentiometers, ensuring all interactive elements were accessible. To improve the surface finish, the lid was “ironed” using a feature in Bambu Studio. However, the result did not meet expectations and was therefore reconsidered in later iterations.

Since the lid was initially only placed on top of the chassis, a simple attachment mechanism was introduced using small 3D-printed cylinders. These were inserted into the corner holes of the chassis, and aligned with the lid's holes.

=== 3D printing
Once the updated 3D models were completed, the components were printed without significant issues. The prints came out nicely and mostly fit together as intended. However, during assembly, it became clear that the PCB was positioned too low inside the chassis, making it hard to interact with the mounted components on the PCB, because the standoffs were too short. To fix this, a quick solution was implemented: small offset spacers were designed and printed. These were placed between the standoffs and the PCB to raise the board slightly. 

Next came the challenge of securing the PCB using 3D-printed screws, as metal screws were intentionally avoided to prevent short-circuiting(#text(red)[evt flere grunde]). A screw generator #text(red)[kilde] was used to create custom screws for printing. The first version fit, but its head was too tall, preventing the lid from closing properly. A second version with a smaller head lacked print detail, making it difficult to insert. A third attempt involved splitting the screw into two printable parts, but the result still did not fit properly

Finally, a flat-headed screw was printed, which fit correctly and allowed the lid to close. However, this introduced a new inconvenience: the screws had to be removed every time the enclosure was opened. This became frustrating during repeated testing and modifications.

To solve this, a new idea was tested: printing the screw without a head, and pairing it with a small plastic bolt to hold it in place. While the screw worked, the bolt didn’t fit as intended. In the end, it was decided to simply rest the PCB on top of the standoffs, using a screw inserted through the middle purely for positioning. Because the lid sat close enough to the PCB, there was no risk of the board shifting during use, and this minimal solution proved effective.
/*
skruer:
1. passede, men hoved for langt op (rød of sølv)
2. ostehoved, passede ikke (rød)
3. delt ostehoved, passede ikke
4. sort lav top, passede, men meget besværlig at skrue (sort)
5. løsning: skrue uden hoved + ide om møtrik (hvid + hvis&sort møtrik)
*/
== Testing
The test was conducted at the University of Southern Denmark and involved three participants from Teknologiskolen @teknologiskolen_om_2025. Each session lasted approximately eight minutes.

At this stage, the first iteration of the product's outer shell had been completed. Inside, a non-functional PCB was installed for visual and structural purposes as shown in @fig:sprint3setup. A display, with a Pico 2 mounted directly onto it, was connected to a laptop and fitted into the chassis as well. This setup allowed manual updates of the display, enabling a Wizard of Oz @nngroup_wizard_2025 or Mechanical Turk @first_principles_product_2025 test. This approach allowed participants to experience the intended interaction of selecting an instrument by inserting an NFC card, despite the system not yet fully working. A breadboard prototype was also presented during this session for the benefit of introducing new participants to the product idea, who had not participated in the test during Sprint 2.

Testing combined A/B testing and unstructured interviews to gather useful feedback.

#figure(
  image("../images/sprint 3/box-v1.jpeg", height: 25%, width: 40%),
  caption: [Test Setup for Sprint 3],
) <fig:sprint3setup>

An A/B test was conducted to assess perferences for potentiometer knob sizes. Participants were presented with three different "topper" options: small, medium, and large. This test addressed earlier feedback, as described in @sec:sprint2test, where participants found the bare potentiometers difficult to manipulate. While individual preferences varied, all participants agreed that any topper was preferable to none.

Overall, participants responded positively to the interaction experience during the Wizard of Oz test. One tester remarked #quote[Yes! I could just imagine myself sitting here and jamming!] #text(red)[cite appendices] and another stated: #quote[I think this is very funny!] #text(red)[cite appendices].

When asked whether the system might motivate them to explore a new musical instrument, the participants, having musical backgrounds playing drums and guitar, responded negatively. However, one participant noted: #quote[Hmm... Especially if you've never played music before, then I think it would be like that.] #text(red)[cite appendices] which suggest the product could hold great appeal for individuals without prior musical experience.

Participants were also asked if they would use the product in a real-life context, one responded: #quote[Yes, 100 percent!] #text(red)[cite appendices] and another offered a more nuanced perspective: #quote[Yes, but I would probably rather sit and feel the real thing, you know, but it's a good alternative if you just can't afford all those musical instruments.] #text(red)[cite appendices].

In terms of physical interaction, one participant offered constructive criticism regarding the insertion of the NFC card: #quote[[...] But maybe it's a bit loose. It's like, if you don't put it in properly, it can easily slide out. So maybe a slightly narrower opening?] #text(red)[cite appendices].