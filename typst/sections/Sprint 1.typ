// 1) Beskriv ideen. Kravspecifikation? Trådløs
// Hardware valg -> Seperat host og computertilstlutning
// 
== Overview
During this sprint, technical and usability requirements were formulated, a paper prototype was produced and experimentation with hardware and microcontrollers were begun.

Usability and technical requirements were formulated to streamline and focus product development. By defining these criteria, decisions made later in the process could be evaluated against the core objectives of the product, ensuring consistency and minimizing feature creep. Additionally, explicitly specifying the requirements ensured a uniform understanding of the project’s goals.

== Usability Requirements
All usability requirements are listed in @table:usabilityRequirements.
The requirements were developed taking the target group's technical proficiency and prior musical knowledge into consideration. As a result, requirements 7 (Beats and Consistency) and 10 (Prior musical knowledge) were defined to ensure a positive user experience for both children with, and without prior experience playing instruments. Requirement 7 (Beats and Consistency) partly fulfills this by accommodating user timing inconsistencies without negatively affecting the produced music. Furthermore, the palette of playable notes should be predefined to make played music harmonically pleasing; even when used by individuals without any prior music theory knowledge.

Requirement 1 (Cooperative play) was considered highly important, as relevant literature highlights the value of collaborative learning and interaction #cite(<newton-dunn_block_2003>) Requirements 2, 3, 4, 6, and 11 (Portable device, Size, Feedback, Plug'N'Play, and Engaging) were defined to create a streamlined experience using the product for the intended users, both making it easy to use and usable in multiple settings. Requirement 9 (Not intimidating) was defined as the product is intended to facilitate musical exploration and experimentation. Therefore, it was essential that it did not appear daunting or overly complex. Furthermore, it should not closely resemble real instruments, as these themselves can seem complex or intimidating for non-musicians #text(red)[cite here].

Finally, requirement 8 (Looping) regards allowing users to record and later accompany themselves with different sounds, allowing users to create something they can show others, which further fosters an engaging experience #text(red)[cite here].

#figure(
  table(
  columns: (auto, 1fr, 2fr),
  align: start,
  table.header([*Id*], [*Feature*], [*Description*]),
  [1], [Cooperative play], [Multiple users should be able to explore and experiment with music together.],
  [2], [Portable device], [The product should be easy to transport, so that usage is not limited to either home or school.],
  [3], [Size], [Product should have a suitable compact size for the target group.],
  [4], [Feedback], [Feedback is given when using the product, ensuring intuitivity.],
  [5], [Ambidextrous], [Product should be usable for both left- and right-handed people.],
  [6], [Plug'N'Play], [Product should be easy to set up, use, and pack away.],
  [7], [Beats and Consistency],[Music beat should be consistent and on time, notes should match ensuring everything "sounds good".],
  [8], [Looping],[Small music pieces should be able to be recorded on- and looped directly from the product.],
  [9], [Not intimidating],[Users should not feel intimidated by using the product.],
  [10], [Prior musical knowledge],[Should be fun for both children who are well-versed in playing music, and those with no prior knowledge.],
  [11], [Engaging],[Users should feel engaged.],
  [12], [Cheap], [The product should be cheap to make it as accessible as possible.]
  
  ),
  caption: [Usability requirements]
) <table:usabilityRequirements>

== Technical Requirements
All technical requirements can be found in @table:technicalRequirements.

Requirement 1 (MCU) was specified to balance processing power with cost-effectiveness, aligning with requirement 12 (Cheap) in @table:usabilityRequirements. Selecting a microcontroller over a full-fledged computer simplifies the device architecture while preserving flexibility, user-friendliness, and affordability. The chosen MCU platform also needed built-in support for wireless communication, per requirement 4 (Wireless Connection).

Wireless connectivity was adopted to satisfy the mobility and ease-of-setup goals of Requirement 2 in @table:usabilityRequirements. Among available options, WiFi was selected for its lower end-to-end latency compared to alternatives like Bluetooth #cite(<sharrow_speed_2025>), ensuring that the system could transmit MIDI data rapidly enough to meet the low-latency requirement 9.

Directly linked to requirement 1, requirement 2 (Dedicated MIDI Host) was defined to prevent the limited processing power of the MCU's from introducing latency that would conflict with requirement 9 (Low Latency) in @table:technicalRequirements. To address this, a dedicated MIDI _host_ was specified to handle MIDI functionality separately from the _controller_ that the user would use to experiment with music.
Requirement 3 (Ableton Live) was introduced to further offload sound generation from the MCU's to a computer, enabling greater flexibility in sound selection and ensuring higher audio quality. Ableton Live was chosen due to its robust MIDI handling, real-time performance capabilities, and wide adoption in both amateur and professional music production. Although this choice imposes a dependency on a separate computer, limiting the flexibility mentioned in requirement 2 in @table:usabilityRequirements, it was decided that the advantages in terms of sound choice and audio quality outweighed this limitation. It is worth noting that while the _Suite_ version of Ableton Live has been used during development and testing, the "Lite" version should be sufficient, since it supports up to 16 tracks and full MIDI capabilities @ableton_buy_nodate.
The host acts as the central connector in the system, interfacing between the controllers and Ableton Live, ensuring smooth communication and coordination across all components. (@fig:DeviceRelationsshipsSprint1)

#figure(
  image("../images/sprint 1/DeviceRelationshipsSprint1.png", width: 75%),
  caption: [Diagram illustrating system relationships between devices.]
) <fig:DeviceRelationsshipsSprint1>

Requirement 4 (Wireless Connection) was defined as since there would both be a host and multiple controllers, they would all have to communicate. WiFi was therefore chosen as the data communication protocol of choice since it provides a lot of physical flexibility. In relation to the prior requirement, it was logical to also include requirement 7 (Low Power Consumption) to ensure that the product would not need wiring. This consideration further informed the inclusion of requirement 8 (Plug and Play), emphasizing that the product should function immediately upon being powered on, without the need for complex configuration.

Both requirement 5 (NFC Reader) and requirement 6 (Screen) were defined in correlation to @table:usabilityRequirements's requirement 4 (Feedback). Requiring an NFC reader for the product's usability was inspired by retro gaming consoles and traditional train stamping tickets (danish: klippekort), and adding a screen would make it easy to display which instrument sounds were currently in use and generally provide feedback to the user.

The last, and arguably most important, requirement, 10 (Interactive sensors), was required as this would be what the user would use the interface, interact and interface with music.

Requirement 10 (Interactive Sensors) was specified to define the user’s primary means of engaging with the system and experimenting with music. By mandating a suite of responsive sensors—such as buttons, and—the design ensures that the user's interaction is reliably captured and translated into expressive musical output. This cornerstone requirement not only shapes the overall user experience, but also underpins the system’s ability to deliver intuitive, real-time interaction with sound.

#figure(
  table(
  columns: (auto, 1fr, 2fr),
  align: start,
  table.header([*Id*], [*Feature*], [*Description*]),
  [1], [MCU], [Each device should be run by an MCU.],
  [2], [Dedicated MIDI host], [Host should act as MIDI controller and interface with Ableton Live.],
  [3], [Ableton Live], [Sound should be produced using Ableton Live on a computer.],
  [4], [Wireless connection], [Controllers should interface wirelessly with Host.],
  [5], [NFC reader], [A NFC Reader should be used for changing controllers' instruments.],
  [6], [Display], [A Pimorino Pico Display 2 should relay information and engage users.],
  [7], [Low power consumption], [Controllers should be powered by batteries, and the host should be bus-powered by its connected computer.],
  [8], [Plug'N'Play], [Devices should simply work when turned on, without any tinkering or configurating, and the order of the devices being turned on shouldn't matter.],
  [9], [Low latency], [There should be minimal latency from when a user interacts with a controller to when a sound is produced.],
  [10], [Interactive sensors], [Controllers should have sensors for the user to interact with.]
  ),
  caption: [Technical requirements]
) <table:technicalRequirements>

== Hardware experimentation and exploration

=== MCU
Two microcontroller families were evaluated for both the controllers and the MIDI host: the Raspberry Pi Pico series and the Arduino Uno series. Both offer WiFi–capable models and provide sufficient GPIO pins to accommodate the project’s sensors and actuators (buttons, potentiometers, NFC reader, and display). The Arduino platform presented advantages in terms of prior team familiarity, extensive library support, and a well-­established first-party IDE. However, its WiFi–enabled variants carry a significant price premium, often costing more than double that of comparable RP2040-based boards #cite(<jkollerupdk_raspberry_nodate>) #cite(<ardustoredk_arduino_nodate>).

In contrast, the Raspberry Pi Pico series combines very low unit cost with robust performance and library support for both WiFi and MIDI functionality. Although the Pico lacks some of Arduino’s out-of-the-box shield compatibility and IDE simplicity, its community offers both free documentation, tutorials, and many well-made third-party libraries. This balance of affordability, sufficient processing capacity, and ecosystem support aligned closely with the cost-accessibility requirement (Requirement 12, @table:usabilityRequirements). It was also noted that the Pico series' GPIO pins could output a maximum of 3.3V. This was deemed not being a problem, but was important when choosing other components for the Controller and Host.

Ultimately, the Raspberry Pi Pico series was selected. The more powerful Pico 2 W was assigned to the host, where heavier computation would be done, and the original Pico W was chosen for the controllers to minimize per-unit expense. This configuration preserves overall system performance and flexibility, while ensuring the final devices remain inexpensive.

==== Circuitpython
While exploring the Raspberry Pi Pico ecosystem the Circuitpython programming language #cite(<adafruit_circuitpython_nodate>) was discovered. Circuitpython is based on Python and promises simplicity, quick prototyping and _"strong hardware support"_ #cite(<schroeder_what_2024>). Furthermore, Circuitpython's creator Adafruit has already created many packages and libraries for everything from interfacing with displays to Bluetooth connectivity, including packages for working with WiFi #cite(<noauthor_adafruit_2025>) and MIDI #cite(<walters_adafruit_2025>). While testing a Pico 2 was successfully made to host a WiFi hotspot using the beforementioned library. Likewise, a Pico 1 was successfully configured to connect to the Pico 2's hotspot, and they could successfully exchange simple wireless messages. For experimentation purposes, using the beforementioned MIDI library, the host was successfully configured to act as a MIDI interface, sending MIDI notes on multiple MIDI channels to an instance of Ableton Live running on a USB-connected laptop. 

The primary drawback of CircuitPython was its confinement of the Pico’s execution to a single CPU core, raising concerns about multitasking performance as the host device needed to manage multiple controllers and a computer concurrently. Fortunately, the discovery of the _asyncio_ library addressed this limitation #cite(<halbert_cooperative_2022>). By providing a cooperative multitasking framework—where functions explicitly yield control and later resume after a specified interval.

This cooperative multitasking model formed the foundation of both the host and controller codebase architectures. During development yielding points were inserted at key stages (e.g., WiFi polling, MIDI message processing, and input scanning), ensuring that network communication, MIDI I/O, and user-input handling all progressed smoothly without blocking each other.

Based on the theoretical capabilities and personal experimentations with Circuitpython, it was decided that the project should be developed using it.

=== Display
To address usability requirements 4 (Feedback), 11 (Engaging), and 12 (Cheap) as listed in @table:usabilityRequirements, a display was incorporated into the design. The selected component was the Pico Display Pack 2.0 @pimoroni_pico_2025, which is based on the ST7789 display driver and uses the SPI protocol for communication. This particular display was chosen for its compatibility with the Picos used in the project, its compact physical dimensions, and cost-effectiveness, thereby supporting the project's goal of maintaining affordability.

Initial testing was carried out using example code provided by Adafruit for the display @adafruit_circuitpython_2025. The code was successfully loaded onto a Pico 2 and produced a "Hello World" output directly on the display itself (@fig:helloworlddisplay).

#figure(
  image("../images/sprint 1/hello-world-display.jpeg", height: 20%),
  caption: [Initial Display Test],
) <fig:helloworlddisplay>

As the display was originally intended to be mounted directly on top of the Pico, further testing was performed to determine the minimum set of pins required for full functionality, as not all pins in the final rendition of the product would be available for the display. This process was complicated by the absence of a formal datasheet for the display; only a schematic was available (@pimoroni_pico_2025), which made pin identification more challenging.

=== NFC Reader

Both the Parallax RFID Reader (\#28140) @parallaxcom_rfid_2024 and the RC522 module @arduinotechdk_rfid_2019 were considered for implementing NFC functionality. After brief testing and evaluation, the RC522 was chosen.

The decision primarily rested on two factors: physical size and cost. The Parallax reader measured nearly twice the size of the RC522, which made it less suitable for a compact controller setup (see Requirement 3, @table:usabilityRequirements). Given the limited inner space of the controller, the RC522’s smaller form was a better fit.

In terms of cost, the Parallax reader was significantly more expensive, priced around \$25–\$30 USD #text(red)[kilde], whereas the RC522 was available for under \$5 USD #text(red)[kilde]. As cost-efficiency was a central design criterion (see Requirement 12, @table:usabilityRequirements), selecting a module that was almost six times cheaper than its competitor aligned better with the project's goals.

Although the RC522 required a slightly more involved setup process, particularly due to the need for SPI communication and manual initialization in CircuitPython, some challenges arose in finding appropriate documentation. Most available libraries for both this exact model and NFC readers in general were designed for MicroPython. However, the library `mfrc522` offered full support for the necessary NFC functionality and proved to be a workable solution. The trade-off in ease of use was considered acceptable, given the substantial advantages in both size and cost.
  
Two NFC cards included with the reader were assigned as instruments: one representing a piano and the other a drumset. This led to a basic breadboard setup where the reader was connected to a Pico and two differently colored LEDs. The code was kept intentionally simple, but was adapted to store the labels of the NFC cards as instrument names (@listing:nfcCardLabels). 

// Implementet with library from https://github.com/domdfcoding/circuitpython-mfrc522
//     - Difficult to get working
//     - Not much "reel" documentation
//       - Most libraries have (already) been "translated" from micropython

#figure(
  ```cpy
  card_labels = {
    "80710414E1": "tromme",
    "2ECB5873CE": "klaver",
  }
  ```,
  caption: [Code mapping cards UIDs to labels.]
) <listing:nfcCardLabels>

The code was also modified to depend on which card was read (@listing:nfcCardChangeLED). First of all, when a card was scanned, its UID was compared with the previously scanned card (@listing:nfcCardChangeLED:2) to avoid processing repeated input from the same card. different and matched one of the defined labels—such as the drum card (@listing:nfcCardChangeLED:8)—the corresponding LED was activated (@listing:nfcCardChangeLED:9), and a message was printed to the console indicating which instrument had been selected (@listing:nfcCardChangeLED:6). Scanning the other card switched the active LED and updated the console output to reflect the newly selected instrument. If the UID did not match any known label, a message was printed indicating that the card was unrecognized (@listing:nfcCardChangeLED:16) and both LEDs was turned off (@listing:nfcCardChangeLED:17)(#text(red)[+18]).

#figure(
  ```cpy
  # Check if the UID is one of our known cards
  if (uid != last_uid) or (current_time - last_seen > 2):
    print("UID detected:", card_str)
    card_type = card_labels.get(card_str, None)
    if card_type:
        print("Card identified as:", card_type)
        # Perform actions based on card type
        if card_type == "tromme":
            yellow.value = False
            red.value = True
        elif card_type == "klaver":
            yellow.value = True
            red.value = False
  else:
      # No card detected; reset previous card and clear LEDs.
      print("Unknown card detected with UID:", card_str)
      yellow.value = False
      red.value = False
  # Store the detected card UID
  last_uid = uid
  ```,
  caption: [Code depending on which NFC card is read.]
) <listing:nfcCardChangeLED>


#figure(
  image("../images/sprint 1/nfcFirstSetup.jpg", height: 20%),
  caption: [Initial NFC Test],
) <fig:nfcFirstSetup>

=== Musical interaction <sec:sprint1MusicalInteraction>
The last technical elements experimented with during the first sprint was the "interactive sensors" (Requirement 10, @table:technicalRequirements). The chosen sensors were eight buttons and four potentiometers, where each button should play a note, and the potentiometers should be used to experiment with the sounds. The reason for making it eight buttons was that it formed a good balance between usability and size, while also fitting perfectly with how music is often split into fours.

Multiple button types where explored. This included both classic switch buttons but also force sensitive resistors @adafruit_square_2022 and piezoresistors @kosaka_e-drum_nodate, which would allow the user the play notes with different velocities. Ultimately, however, it was decided to use switch buttons, to keep the design and development process simple.

Getting buttons to work with the Pico 1's where very easy using Circuitpython's _board_ and _digitalio_ libraries #cite(<noauthor_board_2025>) #cite(<noauthor_basic_2025>). Using these a GPIO pin on the Pico 1 could easily be referenced (@listing:buttonsPullUp:1), the pin could easily be defined as an input pin (@listing:buttonsPullUp:3), and the pin could finally easily be pulled high to avoid floating values, when the connected button wasn't pressed (@listing:buttonsPullUp:4). The libraries became the backbone of how the controllers would read user input. It was, however, also noted, that button debouncing #cite(<wright_what_2022>) would probably be required in the future depending on the final buttons used.

#figure(
  ```cpy
  POT_PIN = board.GP13
  btn = digitalio.DigitalInOut(POT_PIN)
  btn.direction = digitalio.Direction.INPUT
  btn.pull = digitalio.Pull.UP
  ```,
  caption: [Code pulling input-pin GP13 to high.]
) <listing:buttonsPullUp>

Lastly, a sister-library to _digitalio_, _analogio_ was discovered for reading analog inputs @noauthor_analog_2025. It was decided this library was to be used for reading the potentiometers. However, it was noted that the Pico's only had three analog inputs. Therefore, a solution would later have to be found to connect all four potentiometers to the Pico's.

== Paper prototype
#figure(
 image("../images/sprint 1/paperprototype.png", height: 25%),
  caption: [Paper Prototype],
) <fig:paperprototype>

To facilitate a shared understanding of the product's physical layout within the team, a paper prototype was created, as illustrated in @fig:paperprototype. The initial design was influenced by the layout of drum pads #text(red)[cite], which is reflected in the arrangement of components on the prototype. The design incorporated eight buttons and four potentiometers, selected to balance simplicity and functionality with the physical constraints of the box's size. These choices were informed by the usability requirements in @table:usabilityRequirements, specifically requirements 2 (Portability), 3 (Size), and 9 (Intimidating). Furthermore, the overall dimensions were also in part decided by the availability of a Bambu Lab A1 Mini #text(red)[cite] for further prototyping, which limited the footprint to approximately 18cm x 18cm x 18cm.

The prototype was constructed at a 1:1 scale using multicolored cardboard and adhesive tape to accurately represent the intended dimensions of the final product. Interface components were color-coded: the display was represented by a blue cutout, buttons by red cutouts, and potentiometers by pink cutouts. In addition to supporting a shared understanding, the prototype functioned as a tool for assessing usability and interface intuitiveness in the early stages of development.


=== Testing
The prototype was tested by a student enrolled in the Game Development and Learning Technology program at the University of Southern Denmark, allowing for initial feedback on usability. Due to the tester's personal connection to the team, feedback was looked upon with caution to mitigate potential bias. 

The test was conducted at the University of Southern Denmark and involved an unstructured interview, combined with the Think Aloud methodology. An A/B test was also carried out to assess the preferred placement of the NFC reader. This multi-method approach supported a flexible testing environment and allowed exploration of questions not already pre-defined before the test. The session lasted approximately 30 minutes and yielded constructive criticism, while the overall user response remained positive. 

The participant reported limited musical experience, having played piano during childhood but with no current involvement in playing music. Initial confusion was noted when first viewing the prototype; however, after a short briefing, the tester was able to interpret the key interface elements-e.g., identifying the blue rectangle as the screen shown in @fig:paperprototype.

The participant's preliminary expectations included functionality for recording and playback of predefined beats, similar to GarageBand, and the ability to alter pitch, intended humorously to produce annoying sounds. Although the tester was not part of the target demographic, such feedback was interpreted as indicative of an exploratory and motivated interaction approach. During the A/B test, the tester expressed a preference for NFC reader placement on the side of the device. 

Further observations included the importance of tactile feedback and visual indicators such as LEDs. A layout revision was recommended to better support left-handed users, ensuring potentiometer interaction would not obscure the screen. Additional suggestions included the inclusion of a power switch and the use of neutral colors for the device casing.


/*
// GAMMEL

// == Davids notes
// - Circuitpython made integrating with many devices easy
//   - Limited Pico to using only one core, which created concerns regarding multitasking
// - Wifi problems with CYW43 chip
//   - Cleanup function was made to resolve this. Didn't resolve anything lol
//   - Ended up being caused by the soft reboots. Hard reboots solved the problem
// - I.fh.t. Mohis test, skulle padsne være mere som garageband?
// - Asyncio
//   - Easy to implement
//   - Difficult to add error handling
// - Latency, når wifi enhed forbindes
// - LED's were setup in different functions. Would be refactored later
// - Problems with device sometimes not recieving MIDI clock signal
// - MIDI and LED put into their own classes and files

// == Rebekka's notes
// - NFC
//   - Implementet with library from https://github.com/domdfcoding/circuitpython-mfrc522
//     - Difficult to get working
//     - Not much "reel" documentation
//       - Most libraries have (already) been "translated" from micropython
//   - Working 
//     - With card labels
//     - With 2 LEDs for either detected card(1 LED lighted up) or no card (no light in LEDs)
    

// == Jamie's notes
// - Adafruit DisplayIO
//   - Example class for the specific display (ST7789)
// - The schematic was difficult to read, which led to difficulties finding out which pins were necessary.
// - No datasheet making it difficult to figure out what the screen can do, or how to set it up.

== Overview
For this sprint, the team began by thoroughly outlining and planning the product, which would consist of at least two separate hardware devices working together.

=== Host Device
The first device, referred to as the host, would be connected to a computer running Ableton Live via USB. Its role would be to function as a MIDI controller, handling the sending of MIDI messages and managing the timing of the MIDI clock. The host would be powered solely by USB and would feature a few strategically placed LEDs for easy status monitoring and troubleshooting. Ableton Live was chosen due to its extensive sound library and its suitability for live music performance, making it an ideal platform for the intended musical experimentation.

=== Controller Device(s)
The other devices, known as the controllers, would serve as the interactive modules for the children. Each device would feature eight buttons, allowing the children to play their chosen instrument. Selection of the instrument would be achieved by inserting an NFC card into the controller—a design that would enable the kids to swap instruments on the fly. Additionally, the controller could integrate other sensors, such as gyroscopes to adjust pitch or manipulate other variables, fostering an even more dynamic sound exploration experience.

The controllers would also have a  built-in screen for displaying images, videos, or animations—drawing inspiration from products like those from Teenage Engineering—to further engage the users. Several potentiometers would also be included, giving the children the ability to tweak and experiment with their chosen sound.

=== Wireless Communication and Hardware choices
It was decided that the host and the controllers should communicate wirelessly to minimize latency. The host would create a dedicated WiFi hotspot to which the controllers would connect-a deliberate decision to avoid the latency or complexity that might be introduced by Bluetooth or MQTT protocols.

The brains of both devices would be based on Raspberry Pi Pico microcontrollers. The host would employ a Raspberry Pi Pico 2 WH, chosen for its enhanced processing power, while the controllers would use standard Raspberry Pi Pico WH units. This selection would ensure the flexibility to combine both wireless communication and wired components effectively.

For the MCU's firmware, it was decided to use Adafruit's Circuitpython instead of the built in MicroPython. This decision was made as Adafruit seemed to to have created multiple helpful libraries for circuitpython, such as a MIDI- and a WiFi-library, and since that circuitpython seemed to be simpler to develop in than MicroPython.
=== Early internal testing
Early tests involved sending MIDI signals from the Pico to a computer running Ableton Live 11 Suite using Adafruit’s MIDI library. These tests demonstrated that the Host-Pico could transmit MIDI signals across multiple channels, laying the groundwork for each controller playing its distinct instrument simultaneously. Additionally, the successful establishment of a hotspot on one Pico—allowing another Pico to connect via Adafruit's WiFi library suggested the feasibility of the wireless communication setup envisioned for the product.

#text(red)[
  Mangler:
- Tættere sammenkobling mellem beskrivelsen i idégenereringen og min beskrivelse ovenfor
- Noget om NFC læseren
]

#colbreak()
== Paper Prototype
During this sprint, a paper prototype was developed, as illustrated in @fig:paperprototype. The primary objective was to establish a shared understanding among team members when it came to the product's form factor. Additionally, the prototype served as a tool for evaluating the usability of the design, as well as how intuitive it was.


The paper prototype was constructed using differently colored cardboard cutouts, which where then assembled using tape. To accurately represent the intended dimensions of the final product the prototype was created at a 1:1 scale. Lastly, the paper prototype was tested by a student from the Game Development and Learning technology program, as their familiarity with paper prototypes aligned with that of the team.


#figure(
  grid(
    columns: 2,
    gutter: 25pt,
    image("../images/paperprototype1.jpg", height: 30%),
    image("../images/paperprototype2.jpg", height: 30%)),
  caption: [Paper Prototype],
) <fig:paperprototype>


== Testing the Paper Prototype 
The team tested the paper prototype on a student from the Game Development and Learning Technology education, as it allowed the team to gather information on the usability of the paper prototype. However, the team would have to be critical of the feedback gathered as the tester was a friend of the group.  #text(red)[Sharp og Maklin]

The test took place at the University of Southern Denmark and consisted of an unstructured interview #text(red)[preece], and utilized the "think aloud"-methodology, doing so allowed for a relaxed atmosphere and the flexibility of asking questions that the team has not initially thought to ask. The test took roughly 30 minutes. The feedback from the test highlighted various important aspects of the product that, the team would maybe have to refine, but it was overall positive.
=== Preliminary questions 
Starting the test, the team led with a question of "what is your prior knowledge of music, and playing it?" where the tester answered they had some knowledge from playing the piano at a young age, but they were currently not pursuing playing music themselves. When first looking at the paper prototype with no prior knowledge of its intended use, the tester felt slightly confused but not intimidated. After a short briefing of the concept the tester understood instantly.
=== Expectations from the product
The tester expected each button to play a pre-defined beat such as those found in GarageBand #text(red)[reference on this badboy], and also wanted to set the pitch of the product somewhere the sounds would end up being annoying. Despite not being in the target group the team saw this as a sign of wanting to experiment with the limits of the product.
=== Using the product 
The tester intuitively knew what the different elements were on the paper prototype. For example the blue rectangle representing the screen was recognized due to the color choice. an A/B test was conducted with the tester of where the NFC card placement would be better. The tester provided feedback that placement on the side of the product box @fig:paperprototype would be ideal. Despite being a paper prototype power on/off buttons were requested.
=== Design language
The tester highlighted that tactile feedback would be important, as well as lighting. The tester was pleasantly surprised that the size was in a one-to-one scale, but recommended a revision of the layout as left-handed people would cover up the screen while using the potentiometers. Lastly, the tester recommended that the case for the product be a neutral color if lighting would be added.

== Initial Circuit Diagram
To ensure the team was on the same page on how the components would eventually work together a circuit diagram was created that showed the final implementation.

== Experimenting with the Hardware Setup
For this sprint, the team opted to experiment with the different hardware elements needed for the project as a whole. Instead of implementing everything together, each team member was delegated a component of expertise. This meant that the development of the different aspects of the project could take place in parallel with each other. During the weekly meetings the team briefed each other of the the evolvements of the experimentation.

As described in #text(red)[section Wireless Communication and Hardware Choices] each member developed software using Adafruit's Circuitpython. This was possible as the individual components were compatible with various libraries, documentation, and examples allowing for quick testing of individual components' abilities. However, despite Circuitpython making integration with many devices easy, it also limited the Raspberry Pi Picos' power, as only one core was now available for development– this could potentially lead to problems regarding multitasking.

=== Wifi Experimentation
During the experimentation for the wifi setup, a software implementation was created using Circuitpython. Initially, the software had problems due to the CYW43 chip and an attempt at using a clean-up function was made to resolve it. This was not the actual cause of the problem, which was later found to be due to the soft reboots made on the Pico when saving the software– therefore switching to hard reboots resolved the issues found.

For the specific implementation during this sprint, functionality was spread out into individual functions, for example, the LED's functionality. Later during the sprint, the implementations were spread out into individual scripts connected in a 'main'. Furthermore, Asyncio was utilized which proved easy to implement but made error-handling difficult. 

#text(red)[possibly add old code implementations, ay?]

The finished setup of the wifi allowed for experimentation with sending MIDI signals utilizing it. This experimentation showed that latency could potentially become a problem and that the signals were not always received properly in Ableton.

=== NFC Experimentation
The team opted to use a MFRC522 NFC reader for the project. Initially, it was difficult to find documentation on the NFC component, though libraries for the software implementation were available in various places. These were often translation of MicroPython libraries. The team opted to use a library found on GitHub provided by a user of the name domdfcoding #text(red)[(kilde:https://github.com/domdfcoding/circuitpython-mfrc522)]. 

The initial implementation for the NFC reader consisted of a script that would print either "TROMME" or "KLAVER" in the console, as well as changing which LED in the circuit would light up depending on which NFC card was presented to the reader.

=== Display Experimentation
To experiment with the integration of a screen the team opted to use the Pico Display Pack 2.0 #text(red)[Kilde]. During experimentation with the screen, it was first easy to set up using Adafruit's example software for the display type #text(red)[kilde], in this case a ST7789, that the Pico Display Pack 2.0 is. The example code was plug-and-play and displayed the text 'Hello World' on the display. It utilized the DisplayIO library.

#figure(
  image("../images/hello-world-display.jpeg", height: 20%),
  caption: [Initial Display Test],
) <fig:helloworlddisplay>

However, for the implementation needed for the final product the team needed to find out which pins on the display, which originally was created to have a pico sit directly in it, were necessary for the functionality. This proved difficult as no datasheet existed for the device only a schematic with terms the team had not previously seen before. Therefore a significant amount of time was used to figure this out.

*/