#import "@preview/codly:1.3.0": *
#import "@preview/subpar:0.2.2"

= Sprint 3: _Instruments, Cables and Printed Circuit Board_<sec:sprint3>
Based on feedback gathered during testing in Sprint 2 additional instruments were added, and a decision was made upon which switches to use for the product. Decorative LED integration, as wished by testers, was also considered for the product, but was not prioritized. To resolve persistent latency issues, a shift was made from the wireless configuration to a wired solution utilizing Inter-Integrated Circuit (I²C) over USB. These changes led to updates to the circuit design and the creation of a custom PCB design, along with appropriate changes to the 3D-printed chassis.

== More IInstrumentsBased on the breadboard prototype test (@sec:sprint2test), two additional instruments, a trumpet and a guitar, were integrated into the system. In Live, this involved creating two new MIDI tracks, each loaded with a high-quality trumpet or guitar virtual instrument and assigned to its own dedicated MIDI channel. Correspondingly, two new images, one for each instrument, were designed and added to the display (@fig:pixelart2), ensuring users would would receive clear visual feedback whenever they switcheded to one of these instruments. Lastly, two new NFC cards were assigned to each of the instruments.

#subpar.grid(
  columns: (auto, auto),
  caption: [Additional instrument pixelart.],
  label: <fig:pixelart2>,
  align: top,
  figure(image("../images/sprint 3/trumpet.jpg", height: 15%),
    caption: [Pixelart image of trumpet.]), <fig:pixel3>,
  figure(image("../images/sprint 3/guitar.jpg", height: 15%),
    caption: [Pixelart image of guitar.]), <fig:pixel4>,
)

#colbreak()#subpar.grid(
  columns: (auto, auto),
  caption: [Additional instrument pixelart.],
  label: <fig:pixelart2>,
  align: top,
  figure(image("../images/sprint 3/trumpet.jpg", height: 15%),
    caption: [Pixelart image of trumpet.]), <fig:pixel3>,
  figure(image("../images/sprint 3/guitar.jpg", height: 15%),
    caption: [Pixelart image of guitar.]), <fig:pixel4>,
)

#colbreak()
== Lowering LLatency
=== UDP
As discussed in @sec:sprint2WifiProblems, latency, hypothesized to be hypothesized to be primarily caused by TCP, was experienced when playing on the Controller. To improve this, the WiFi system was changed to use UDP instead. Most rewriting consisted of removing TCP sockets (@listing:exchangingSocketsDiff:1) and exchanging them with the addresses of the Controllers (@listing:exchangingSocketsDiff:3). As UDP is not connection-oriented #cite(<kurose_computer_2020>, supplement: [ch. 3.3]), this was necessary for the Host to be able to identify and remember the Controllers that connecteded to it.

This improved the latency a fair bit. However, the latency was still noticeable, which led to a more drastic change being made.

#codly(
  highlighted-lines: ((1, red.lighten(60%)), (2, red.lighten(60%)), (3, green.lighten(60%)), (4, green.lighten(60%))),
)
#figure(
  ```cpy
  -  def _received_heartbeat(self, socket):
  -      self.socket_responses[socket] = 0
  +  def _received_heartbeat(self, addr):
  +      self.socket_responses[addr] = 0
  ```,
  caption: [Example of changing TCP code (red) to UDP code (green) by exchanging sockets for addresses.],
  placement: top,
  placement: top
) <listing:exchangingSocketsDiff>

=== Wired
To completely eliminate the perceived latency, the decision was made to replace the wireless connectivity with wired connectivity. This was not an easy decision to make,, as it directly contradicted the wireless connection technical requirement (Requirement 4, @table:technicalRequirements). Furthermore, it was feared that a tethered connection would limit the users' desire to interact with the product. However, one tester did note, they would rather have it wired than powered by batteries (@sec:sprint2test), and fixing the latency problem was deemed critical as the _feel_ of the product was very important.

The wired solution offered two key advantages that outweighed its drawbacks. First, it removed nearly all latency, delivering an immediate response that felt more natural and expected. Second, it enabled the Controllers to draw power directly from the Host rather than relying on batteries. Lastly, rLas,rmovgti also reduced product maintenance for users for users.

==== Process
For managing the now wired connection, ²C was used. Though SPI had been fastfaster @campbell_basics_2016 it would also have requiredfour pins on each Pico 1 and three pins plus one additional pin for each Controller connected to the Host @campbell_basics_2016-1 whereas I²C only requiredd two pins on each Pico @campbell_basics_2016.

Choosing I²C over SPI also enabled reusing larger parts of the existing codebase. Since it worked by sending frames, which resembled WiFi's HTTP messages that were being used, the code changes on the Host were somewhat minimal. The primary code change was in how the Host found connected Controllers and received messages from them. Finding Controllers was very easily done by calling `self.i2c.scan()`, which returned an array of connected addresses (@listing:hostScanI2C:4). Reading messages from Controllers was very different from reading HTTP messages. Whereas HTTP messages worked by having the Controller send the messages and then having the Host read them when ready, I²C worked by having the Host tell each Controller that it was ready to receive messages from the Controllers (@listing:hostScanI2C:9). Only then, could the Controllers send their messages.

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
  caption: [Host scanning for Controllers and reading from each connected Controller.],
  placement: bottom,
  placement: bottom
) <listing:hostScanI2C>

The Controller code was changed a bit more than the Host's code. This was primarily caused by the previously mentioned fact, that the Controller had to wait for the Host to request messages from it. To accommodate this new way for messages to be transported, a queue was implemented on the Controller side just like it had been on the Host side (@sec:sprint2HostMidiInterface). This queue would hold all messages that were ready to be sent to the Host. Whenever the Host requested a message (@listing:ControllerI2C:2), the Controller would pop an element from the queue (@listing:ControllerI2C:10) and send it (@listing:ControllerI2C:14). Here it was also discovered, it was important that each message had the same size, as the Host needed to know how many incoming bytes to read. It was decided that each message should be 16 bytes. Before sending the message the Controller therefore paddedded all its messages until it wawas 16 bytes (@listing:ControllerI2C:13).

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
  caption: [Controller unloading queue to Host, when Host requests messages.],
  placement: top,
  placement: top
) <listing:ControllerI2C>

During internal testing a second Pico 1 was connected to briefly test, how the Host handled having two Controllers connected. The test went well apart from one problem. The Host coul od not differentiate between the Controllers. After debugging it was discovered that both Controllers had the same I²C address, which was caused by the code being copied from one Controller to the other. After changing this address on the second Controller, the two Controllers were able to communicate flawlessly with the Host without any noticeable latency or delay.

==== Physical interface <sec:sprint3PhysicalInterface>
Standard USB 2.0 Type B to A cables were chosen to physically link the Controllers and Host because they wewere #quote[designed to receive data, power, and control signals from a host device.] @cooper_is_2024. Furthermore, they were both available and affordable during development. They wewere also more robust and easier to plug in than smaller connectors @cooper_decoding_2024, which was believed would heighten the portability and Plug'N'Play usability of the system (Requirement 2 & 6, @table:usabilityRequirements). Most importantly, each cable carries exactly four conductors, and each connector exposes exactly four pins. This meant that two pins could be be reserved for power (+5V and ground), while the two other pins could be reserved for the two required I²C pins: Serial Data Line (SDA) and Serial Clock Line (SCL).

Beyond pin count, USB Type B connectors offereded good mechanical retention and strain relief, helping to prevent accidental disconnections during use. Standard cable lengths (up to 5 meters for USB 2.0) providedd good reach, mitigating some of the flexibility downsides of switching from wireless connectivity. Lastly, by relying on off-the-shelf USB cables rather than custom cables, the design minimizedd part variety, simplifiedd sourcing and replacement, and leveragedd existing technology familiar to users.

== Circuitry
=== SPI Busses
To address the instability of the NFC reader that arose after integrating the display (@sec:Sprint2Display), the display was moved to a separate SPI bus with its own dedicated GPIO pins (@app:schematicSprint3). Following this change, the NFC reader resumed functioning reliably. This strongly suggested that the issue stemmed from the individual CircuitPython drivers for the NFC reader and display not supporting shared use of a single SPI bus.

=== New power solution
With the Controller now linked to the Host via cable, the batteries, MOSFET, and resistor were removed from the Controller’s power circuit on the schematic and replaced with a USB 2.0 Type B connector (@app:schematicSprint3). Of its four pins, two were assigned to power: the connector’s ground pin to the Pico 1’s GND, and its VBUS pin to the Pico 1’s VSYS input,, supplyinging +5V #cite(<raspberry_pi_raspberry_2024-1>). The remaining two pins were designated for I²C (SDA and SCL) and wired to two digital GPIOs on the Pico 1.

On the Host side, the USB 2.0 Type A connector’s ground and I²C pins were wired identically. The VBUS pin, however, was connected directly to the Pico 2’s VBUS output, drawing power from the Host's connected computer’s USB port #cite(<raspberry_pi_raspberry_2024>). This arrangement streamlinedd the power design and ensuredd both devices receivedd stable +5V while sharing a common I²C bus over the same cable.

The new power solution was not without problems. During internal testing,, it was discovered that when both the Host and Controllers were connected to a powered USB hub, other devices connected to the hub would not receive their required power. This was discovered by having the audio of a connected audio interface (NI Komplete Audio 6 @native_instruments_komplete_2025) starting to crackle, when the Host was connected. Furthermore, it was discovered that neither the Host nor any connected Controllers functioned properly when connected to a laptop, unless the laptop was actively being charged.

== PCB <sec:PCBsprint3>
=== Design
To develop a fully functional prototype beyond a breadboard implementation, a PCB was designed. During this process, practical considerations such as the placement of mounting holes for integration within the final chassis were taken into account, which meant that the sizeze of the PCB itself was determined by the size of the chassis. Additionally, due to the use of specific components that lacked readily available footprints, several custom or modified footprints were created as part of the PCB design.

The GitHub repository KiCad-RP-Pico @ncarandini_kicad-rp-pico_20222022 served as the foundation for the Pico footprint. However, since the prototype utilized Pico 1s with WiFi, minor modifications were made to the footprint. This adapted footprint also served as the template for designing the display's footprint, given that the display module shared the same number of pins as the Picoss. Based on the previous test (@sec:sprint2test), it was decided to use the NuPhy switches going forward. Therefore, in addition to the other footprints,, a separate GitHub repository providing various switch footprints @siderakb_key-switchespretty_20252025 was referenced. This footprint was also modified to suit the project's specific needs.

The PCB (@fig:firstattemptpcb & @fig:secondattemptpcb) was initially routed using the _FreeRouting_ tool @noauthor_freeroutingfreerouting_2025, but the generated layout proved impractical for soldering. Since the board was to sit just beneath the chassis lidlid, for space purposes, a two-sided PCBPCB was required: buttons, potentiometers and display on the top, all other components on the bottom. Unfortunately, FreeRouting did not honor these layer constraints, placing several critical traces, including some for button contacts, on the top copper foil where they would interfere with component pads.

To resolve this, the PCB was redesigned and all traces were drawn manually (@fig:thirdattemptpcb), ensuring that top-side copper was reserved exclusively for buttonss, potentiometers and display connections and that all other routing remained on the bottom layer. Lastly, the LEDs on the schematic (@app:schematicSprint3) was omitted from the PCB design, as it was deemed more important getting the core functionality of the Controller working before adding flair despite previous tests highlighting how it could be beneficial (@sec:sprint1test & @sec:sprint2test) despite previous tests highlighting how it could be beneficial (@sec:sprint1test & @sec:sprint2test).

=== Production
Several issues emerged during the PCB production phase, which utilized the cauterisation method, as illustrated in @fig:pcbSprint3. One of the primary setbacks was caused by the automatically enabled printer setting "Fit to Page" (@fig:firstattemptpcb), which unintentionally scaled down the PCB layout. As a result, the printed design no longer matched the actual dimensions needed, rendering the PCB unusable. This led to a misdiagnosis of the problem as an error with the footprints themselves (@fig:secondattemptpcb), prompting unnecessary modifications to the newly designed footprints. These adjustments were later reversed upon the realization that the original footprints had been correct and that the issue stemmed from the incorrect printer setting. However, the root of the problem was first discovered after spending a considerable amount of time drilling all the holes in the PCB.

Once the problem was resolved, a new issue arose due to a change aofof printerss at the available available production facilities at the University of Southern Denmark. The newly installed printer utilized ink incompatible with the PCB fabrication process,, which led to additional delays, as the resulting PCB was not viable for use (@fig:thirdattemptpcb).

#subpar.grid(
  columns: (auto, auto, auto),
  caption: [PCB production..],
  label: <fig:pcbSprint3>,
  align: top,
  figure(image("../images/sprint 3/PCB1.jpg", width: 100%),
    caption: ["Fit to Page" scaling problem.]), <fig:firstattemptpcb>,
  figure(image("../images/sprint 3/PCB2.jpg", width: 95%),
    caption: [Wrong footprint scaling.]), <fig:secondattemptpcb>,
  figure(image("../images/sprint 3/PCB3.jpg", width: 107%),
    caption: [Ink problems.]), <fig:thirdattemptpcb>
)

== Chassis Design <sec:sprint3cad>
=== CAD
Based on the previously 3D printed chassis, the design was iteratively refined, and several additional features were added. 
One of the first additions was the creation of PCB standoffs; ; four cylindrical supports with central threaded screw holes, pacplaced to lign wialign with the mounting holes of the PCB (@fig:fus3nfcStandoffs). Before printing, the placement and alignment of the standoffs were verified in Fusion by inserting a model of the PCB.

A dedicated holder for the NFC reader was designed (@fig:fus3nfcStandoffs). This component included a fixed position for the NFC reareaderr and a dedicated slot for card insertion. A physical boundary, acting as a "stopper", was added inside the slot to prevent the NFC cards from being inserted too far into the chassis, both to protect other internal components and in response to user testing (@sec:sprint2test), where participants expressed curiosity about placing foreign objects into the opening. 

Two new side panels were created as variations of the original design. The first was anan NFC card insertion side panel (@fig:fus3nfcside), which featured a large rectangular opening with smoothed edges to ensure safe use. The second was aa rear side panel, where cutouts were added for both the USB 2.0 Type B connector and the power switch.

Lastly, aa lid was designed to align with the base of the chassis and the component layout on the PCB (@fig:fus3lid). Corresponding cutouts were added for the buttons, display, and potentiometers, ensuring all interactive elements were accessible. Corresponding to the base of the chassis' magnet holes (@sec:sprint2Fusion), holes were also added to the lid design. To improve the surface finish, the lid was _ironed_ using a feature in Bambu Studio @bambu_lab_software_2025. However, the result did not meet expectations and was therefore reconsidered in later iterations.

A simple temporary temporary attachment mechanism for the lid was introduced using small 3D-printed cylinders that fit into the designed magnet holes. This meant that the lid would not slide off the base of the chassis, before magnets were added.
#subpar.grid(
  columns: (auto, auto, auto),
  caption: [Fusion designs.],
  label: <fig:fus3>,
  align: top,
  figure(image("../images/sprint 3/fusNfc+standoff.png", width: 100%),
    caption: [Updated Controller base with standoffs and NFC reader holder.]), <fig:fus3nfcStandoffs>,
  figure(image("../images/sprint 3/fus3Side.png", width: 95%),
    caption: [Side panel design for NFC card insertion.]), <fig:fus3nfcside>,
  figure(image("../images/sprint 3/fus3Lid.png", width: 60%),
    caption: [Lid design.]), <fig:fus3lid>
)
#colbreak()
#subpar.grid(
  columns: (auto, auto, auto),
  caption: [3D-printed elements.],
  label: <fig:fus3screws>,
  align: top,
  figure(image("../images/sprint 3/fus3standoffs.png", width: 100%),
    caption: [Spacers.]), <fig:fusOffsetters>,
  figure(image("../images/sprint 3/3dScrews.jpg", width: 100%),
    caption: [3D printed screws and bolts.]), <fig:3dscrews>,
  figure(image("../images/sprint 3/chassisStandoffs.jpg", width: 70%),
    caption: [Updated Controller base with NFC reader and standoffs.]), <fig:fus3printedchassis>
)
P.Cbe#colbreak().100S1007Cbe
=== 3D Printing
Once the updated 3D models were completed, the components were printed without any any significant issues. The prints came out nicely and mostly fit together as intended. However, during assembly, it became clear that the PCB was positioned too low inside the chassis, because the standoffs were too short, making it hard to interact with the mounted components on the PCB. To fix this, a quick solution was implemented: small spacers were designed and printed (@fig:fusOffsetters). These were placed between the standoffs and the PCB to raise the board slightly. Multiple versions in different sizes were designed and printed to internally test, what would work best.

Next came the challenge of securing the PCB using 3D-printed screws, as metal screws were intentionally avoided to prevent short-circuits and scratching the PCB. A screw generator @koolm_screw_2025 was used to create custom screws (@fig:3dscrews). The first version fit, but its head was too tall, preventing the lid from closing properly. A second version with a smaller head lacked print detail, making it difficult to insert. A third attempt involved splitting the screw into two printable parts, but the result still did not fit properly

Finally, a flat-headed screw was printed, which fit correctly and allowed the lid to close. However, adding the screws introduced a new inconvenience: the screws had to be removed every time the PCB was removed from the chassis. This became frustrating during repeated testing and modifications, and contradicted the design philosophy that the chassis should be modular to make iterating and access to internal components easier (@sec:sprint2Fusion).

To solve this, a new idea was tested: printing the screw without a head, and pairing it with a small plastic bolt to hold the PCBhe PCB in place, which would be easier to remove than the previously printed screws. While the screw screwed into the chassis and correctly held the PCB in place, the bolt did o not fit as intended. In the end, it was decided to simply rest the PCB on top of the standoffs, using only the headless screw for positioning (@fig:fus3printedchassis). Since the lid sat close enough to the PCB, even without bolts, there was no risk of the board shifting during use.
/*
skruer:
1. passede, men hoved for langt op (rød of sølv)
2. ostehoved, passede ikke (rød)
3. delt ostehoved, passede ikke
4. sort lav top, passede, men meget besværlig at skrue (sort)
5. løsning: skrue uden hoved + ide om møtrik (hvid + hvis&sort møtrik)
*/
  
== Testing <sec:sprint3test>
At this stage, the second iteration of the product's outer shell had been completed. Inside, the non-functional PCB with drilled holes (@sec:PCBsprint3) was installed for visual and structural purposes. This PCB had potentiometers and switches attached. The switches had keycaps from a pre-existing set @nuphy_nuphy_2025. This PCB had potentiometers and switches attached. The switches had keycaps from a pre-existing set @nuphy_nuphy_2025. A display, with a Pico 2 mounted directly onto it, was connected to a laptop and fitted into the chassis as well (@fig:test3Turk). This setup allowed manual updates of the display, enabling a Wizard of Oz @nngroup_wizard_2025 or Mechanical Turk @first_principles_product_2025 test. This approach allowed participants to experience the intended interaction of selecting an instrument by inserting an NFC card, despite the system not yet fully working. The breadboard prototype, utilizing  wira wired connectiond connection, was also presented during this session for the benefit of introducing new participants to the product idea, who had not participated in the test during Sprint 2 (@fig:test3BBSetup).

The test was conducted at the University of Southern Denmark and involved three participants from Teknologiskolen @teknologiskolen_om_2025. The test consisted of an A/B test, a  think-aloud section, and unstructured interviews. One tester had participated previously, whereas the two others had not. Each session lasted approximately eight minutes. 

#subpar.grid(
  columns: (auto, auto),
  caption: [Test ssetup for ssprint 3..],
  label: <fig:test3Setup>,
  align: top,
  figure(image("../images/sprint 3/box-v1.jpeg", heghheight: 225%),
    caption: [Mechanical turk test.]), <fig:test3Turk>,
  figure(image(bradboardrint3"../images/sprint 3/breadboardSprint3.jpg", hegtheight: 25%25),
    caption: [Breadboard functionality test.]), <fig:test3BBSetup>,
)

An A/B test was conducted to assess preferences for potentiometer knob sizes. Participants were presented with two different knob options: small and large. This test addressed earlier feedback, as described in @sec:sprint2test, where participants found the bare potentiometers difficult to manipulate. While individual preferences varied, all participants agreed that any knob was preferable to none.

Overall, participants responded positively to the interaction experience during the Wizard of Oz test. One tester remarked #quote[Yes! I could just imagine myself sitting here and jamming!]@app:Sprint3Transcriptions) and another stated: #quote[I think this is very funny!] (@app:Sprint3Transcriptions).

When asked whether the system might motivate them to explore a new musical instrument, two participants, having musical backgrounds playing drums and guitar, responded negatively. However, one participant noted: #quote[Hmm... Especially if you've never played music before, then I think it would be like that.]@app:Sprint3Transcriptions) which suggestss the product could hold great appeal for individuals without prior musical experience.

Participants were also asked if they would use the product in a real-life context, one responded: #quote[Yes, 100 percent!]@app:Sprint3Transcriptions) and another offered a more nuanced perspective: #quote[Yes, but I would probably rather sit and feel the real thing, you know, but it's a good alternative if you just can't afford all those musical instruments.]@app:Sprint3Transcriptions).

In terms of physical interaction, one participant offered constructive criticism regarding the insertion of the NFC card: #quote[[...] But maybe it's a bit loose. It's like, if you don't put it in properly, it can easily slide out. So maybe a slightly narrower opening?]@app:Sprint3criptions).

Furthermore, it was observed th th participants haan easie time fringcohesive bets i contratthe prevou test. Tis supported the notion that the previously used wireless connection's latency was hindering participants.

Furthermore, it was observed that the participants had an easier time forming cohesive beats in contrast to the previous test. This supported the notion that the previously used wireless connection's latency was hindering participants.

