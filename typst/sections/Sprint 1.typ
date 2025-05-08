// 1) Beskriv ideen. Kravspecifikation? Trådløs
// Hardware valg -> Seperat host og computertilstlutning
// 

#figure(
  image("../images/FirstDrawing.png", height: 20%),
  caption: [Initial Drawing of the Idea],
) <fig:firstDrawing>

== Overview
During this sprint, technical and usability requirements were formulated, a paper prototype was produced and experimentation with hardware and microcontrollers were begun.

== Usability and Technical Requirements analysis 
Usability and technical requirements were formulated to streamline and focus product development. By defining these criteria, decisions made later in the process could be evaluated against the core objectives of the product, ensuring consistency and minimizing feature creep. Additionally, explicitly specifying the requirements ensured a uniform understanding of the project’s goals.

=== Usability Requirements
All requirements are listed in @table:usabilityRequirements.
The requirements were developed taking the target group's technical proficiency and prior musical knowledge into consideration. As a result, requirements 7 (Beats and Consistency) and 10 (Prior musical knowledge) were defined to ensure a positive user experience for both children with, and without prior experience playing instruments. Requirement 7 (Beats and Consistency) partly fulfills this by accommodating user timing inconsistencies without negatively affecting the produced music. Furthermore, the palette of playable notes should be predefined to make played music harmonically pleasing; even when used by individuals without any prior music theory knowledge.

Requirement 1 (Cooperative play) was considered highly important, as relevant literature highlights the value of collaborative learning and interaction #text(red)[Newton-dunn 2003 cite.] Requirements 2, 3, 4, 6, and 11 (Portable device, Size, Feedback, Plug'N'Play, and Engaging) were defined to create a streamlined experience using the product for the intended users, both making it easy to use and usable in multiple settings. Requirement 9 (Not intimidating) was defined as the product is intended to facilitate musical exploration and experimentation. Therefore, it was essential that it did not appear daunting or overly complex. Furthermore, it should not closely resemble real instruments, as these themselves can seem complex or intimidating for non-musicians #text(red)[cite here].

Finally, requirement 8 (Looping) regards allowing users to record and later accompany themselves with different sounds, allowing users to create something they can show others, which further fosters an engaging experience #text(red)[cite here].

#figure(
  table(
  columns: (auto, 1fr, 2fr),
  align: start,
  table.header([*Id*], [*Feature*], [*Description*]),
  [1], [Cooperative play], [Multiple users should be able to explore and experiment with music together.],
  [2], [Portable device], [The product should be easy to transport, so that usage is not limited to either home or school.],
  [3], [Size], [Product should have a suitable size for the target group.],
  [4], [Feedback], [Feedback is given when using the product, ensuring intuitivity.],
  [5], [Ambidexterous], [Product should be usable for both left- and right-handed people.],
  [6], [Plug'N'Play], [Product should be easy to set up, use, and pack away.],
  [7], [Beats and Consistency],[Music beat should be consistent and on time, notes should match ensuring everything "sounds good".],
  [8], [Looping],[Small music pieces should be able to be recorded on- and looped directly from the product.],
  [9], [Not intimidating],[Users should not feel intimidated by using the product],
  [10], [Prior musical knowledge],[Should be fun for both children who are well-versed in playing music, and those with no prior knowledge.],
  [11], [Engaging],[Usage should feel engaging.],
  [12], [Cheap], [The devices should be cheap to make it as accessible as possible.]
  
  ),
  caption: [Usability requirements]
) <table:usabilityRequirements>

=== Technical Requirements
All technical requirements can be found in @table:technicalRequirements.
Requirement 1 (Raspberry Pi Pico) was defined to ensure the product was cheap, as requirement 12 (Cheap) in @table:usabilityRequirements also states was important. This was also the reason for choosing the Pico-series over, for example, Arduino MCU's as these are often more expensive. This was especially true taking requirement 4 (Wireless connection) into account as WiFi-enabled Arduino MCU's were much more expensive than Pico 1's or Pico 2's. Wireless connectivity was decided upon to provide some of the flexibility required by requirement 2 in @table:usabilityRequirements.

Directly linked to requirement 1, requirement 2 (Dedicated MIDI Host) was defined to prevent the limited processing power of the microcontrollers from introducing latency that would conflict with requirement 9 (Low Latency) in @table:usabilityRequirements. To address this, a dedicated MIDI host was specified to handle part of the controllers’ functionality externally.
Requirement 3 (Ableton Live) was introduced to further offload sound generation from the microcontrollers to a computer, enabling greater flexibility in sound selection and ensuring higher audio quality. Ableton Live was chosen due to its robust MIDI handling, real-time performance capabilities, and wide adoption in both amateur and professional music production. Although this choice imposes a dependency on a separate computer, limiting the flexibility mentioned in requirement 2 in @table:usabilityRequirements, it was decided that the advantages in terms of sound choice and audio quality outweighed this limitation.
The host acts as the central connector in the system, interfacing between the controllers (Requirement 4: Wireless Connection) and Ableton Live, ensuring smooth communication and coordination across all components.

Requirement 4 (Wireless Connection) was defined as there would be both a host and a controller. These two elements would have to communicate, and therefore, WiFi was the technology of choice. In relation to the prior requirement, it was logical to also include requirement 7 (Low Power Consumption) to ensure that the product would not need wiring. This consideration further informed the inclusion of requirement 8 (Plug and Play), emphasizing that the product should function immediately upon being powered on, without the need for complex configuration.

Both requirement 5 (NFC Reader) and requirement 6 (Screen) were defined in correlation to @table:usabilityRequirements's requirement 4 (Feedback). Requiring an NFC reader for the product's usability was inspired by retro gaming consoles and traditional train stamping tickets (danish: klippekort), and adding a screen would make it easy to display which instrument sounds were currently in use and generally provide feedback to the user.
 
/*
1. Cheaper and available even though it limits performance
2. Since we are limited by performance the controllers shouldn't handle sound generation. Therefore a seperate device, the host, should "combine" the controllers and interface with a computer running ableton live (maybe mention the possibility of not using a computer but then using a Push 3? Is it a competitor?)
3. The maximise flexibility and portability, the controllers should interface wirelessly with the host. This means each controller needs to manage it's own power.
4. To live up to the usability requirement, instrument changing should be implemented using NFC cards. This was inspired by retro gaming consoles and train tickets.
5. To live up to the feedback usability requirement, a screen should be implemented.
6. To live up to the usability requirements of being modular and plug'n'play devices should be battery- or bus-powered.
7. It should just work (usability requirement)
8. (This should perhaps be an earlier requirement) Ableton Live should be used. This was chosen because it was available, and it has many sounds and great MIDI controller interfacing (made for LIVE play)
*/

#figure(
  table(
  columns: (auto, 1fr, 2fr),
  align: start,
  table.header([*Id*], [*Feature*], [*Description*]),
  [1], [Raspberry Pi Pico], [Devices should be based on the Raspberry Pi Pico W MCU.],
  [2], [Dedicated MIDI host], [Host should act as MIDI controller and interface with Ableton Live.],
  [3], [Ableton Live], [Sound should be produced using Ableton Live on a computer.],
  [4], [Wireless connection], [Controllers should interface wirelessly with Host.],
  [5], [NFC reader], [An MFRC522 NFC Reader should be used for changing controllers' instruments.],
  [6], [Display], [A Pimorino Pico Display 2 should relay information and engage users.],
  [7], [Low power consumption], [Controllers should be powered by batteries, and the host should be bus-powered by its connected computer.],
  [8], [Plug'N'Play], [Devices should simply work when turned on, without any tinkering or configurating, and the order of the devices being turned on shouldn't matter.],
  [9], [Low latency], [There should be minimal latency from when a user interacts with a controller to when a sound is produced.],
  ),
  caption: [Technical requirements]
) <table:technicalRequirements>

== Hardware experimentation and exploration

=== MCU

==== Circuitpython

=== Display

=== NFC Reader

=== Musical interaction



== Paper prototype
#figure(
  grid(
    columns: 2,
    gutter: 25pt,
    image("../images/paperprototype1.jpg", height: 25%),
    image("../images/paperprototype2.jpg", height: 25%)),
  caption: [Paper Prototype],
) <fig:paperprototype>


A paper prototype was developed, as shown in @fig:paperprototype, to establish a common understanding within the team regarding the product's physical layout. On the prototype, the blue cardboard cutout represents a display, the red cutouts buttons and the pink cutouts; potentiometers. It also served as a preliminary tool for evaluating usability and interface intuitiveness. The prototype was constructed from multicolored cardboard and assembled using tape. It was produced at a 1:1 scale to accurately represent the dimensions of the intended final product. 

=== Testing
The prototype was tested by a student enrolled in the Game Development and Learning Technology program, allowing for initial feedback on usability. Due to the tester's personal connection to the team, feedback was looked upon with caution to mitigate potential bias. 

The test was conducted at the University of Southern Denmark and involved an unstructured interview, combined with the Think Aloud methodology. An A/B test was also carried out to assess the preferred placement of the NFC reader. This multi-method approach supported a flexible testing environment and allowed exploration of questions not already pre-defined before the test. The session lasted approximately 30 minutes and yielded constructive feedback, while the overall user response remained positive. 

The participant reported limited musical experience, having played piano during childhood but with no current involvement in playing music. Initial confusion was noted when first viewing the prototype; however, after a short briefing, the tester was able to interpret the key interface elements-e.g., identifying the blue rectangle as the screen shown in @fig:paperprototype.

The participant's preliminary expectations included functionality for recording and playback of predefined beats, similar to GarageBand, and the ability to alter pitch, intended humorously to produce annoying sounds. Although the tester was not part of the target demographic, such feedback was interpreted as indicative of an exploratory and motivated interaction approach. During the A/B test, the tester expressed a preference for NFC reader placement on the side of the device. 

Further observations included the importance of tactile feedback and visual indicators such as LEDs. A layout revision was recommended to better support left-handed users, ensuring potentiometer interaction would not obscure the screen. Additional suggestions included the inclusion of a power switch and the use of neutral colors for the device casing.











/*
// GAMMEL
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