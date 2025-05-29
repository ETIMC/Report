= Sprint 1: _Requirements, Technical Experimentation and Paper Prototyping_
The overall direction of the project was defined by establishing core usability and technical requirements. These were shaped around the target group of 9–12-year-olds, aiming to make the product engaging, intuitive, and accessible regardless of prior musical knowledge. Parallel to this, experimentation was begun with key hardware components, including microcontrollers, buttons, potentiometers, NFC readers, and a display, to evaluate their feasibility and integration. A paper prototype of the Controller was created to visualize the physical layout and test early interaction ideas, helping the team gather feedback and refine the concept before moving into functional prototyping.

== Usability Requirements
All usability requirements are listed in @table:usabilityRequirements.
The requirements were developed taking the target group's technical proficiency and prior musical knowledge into consideration. As a result, requirements 7 (Beats and Consistency) and 10 (Prior musical knowledge) were defined to ensure a positive user experience, heightening competence @ryan_self-determination_2000, for both children with, and without prior experience playing instruments. Requirement 7 partly fulfills this by quantizing user input, fixing timing inconsistencies without negatively affecting the produced music. Furthermore, the palette of playable notes should be predefined to make played music harmonically pleasing; even when used by individuals without any prior music theory knowledge.

Requirement 1 (Cooperative play) was considered highly important, as relevant literature highlights the value of collaborative learning and interaction @newton-dunn_block_2003 @ryan_self-determination_2000. Requirements 2, 3, 6, and 11 (Portable device, Size, Plug'N'Play, and Engaging) were defined to create a good experience using the product for the target group, both making it easy and engaging to use and usable in multiple settings. Requirement 4 (Feedback) was created for making the product feel good and be as intuitive to use as possible #cite(<norman_design_2013>, supplement: [ch. 4]).

Requirement 9 (Not intimidating) was defined as the product is intended to facilitate musical exploration and experimentation. Therefore, it needed not to appear daunting or overly complex, which traditional instruments can be @mesler_when_2017. That is why the Controller's design should avoid close resemblance to traditional instruments. Actions should immediately be apparent and intuitive, without the need for prior knowledge or instruction #cite(<norman_design_2013>, supplement: [ch. 4]), which traditional instruments might not afford. Furthermore, unconventional interfaces can offer unique affordances that align closely with the physical interactions of novice users, fostering a more inviting and exploratory musical experience @dalgleish_cec_nodate, possibly fostering autonomy @ryan_self-determination_2000. This requirement was added despite counteracting the initial idea (@sec:ideaGeneration), of making them resemble real instruments for near-transfer.

Finally, requirement 8 (Looping) regards allowing users to record their experimentations. This would allow users to create something they can show and share with others, enhancing confidence, engagement @byrne_building_2019 and relatedness @ryan_self-determination_2000.

#figure(
  table(
  columns: (auto, 1fr, 2fr),
  align: start,
  table.header([*Id*], [*Feature*], [*Description*]),
  [1], [Cooperative play], [Multiple users should be able to explore and experiment with music together.],
  [2], [Portable device], [The product should be easy to transport, so that usage is not limited to either home or school.],
  [3], [Size], [Product should have a suitable compact size for the target group.],
  [4], [Feedback], [Feedback is given when using the product, making it more intuitive.],
  [5], [Cheap], [The product should be cheap to make it as accessible as possible.],
  [6], [Plug'N'Play], [Product should be easy to set up, use, and pack away.],
  [7], [Beats and Consistency],[Played music should be quantized to ensure it "sounds good" almost independently of the input.],
  [8], [Looping],[Small music pieces should be able to be recorded on- and looped directly from the product.],
  [9], [Not intimidating],[Users should not feel intimidated by using the product.],
  [10], [Prior musical knowledge],[Should be fun for both children who are well-versed in playing music, and those with no prior knowledge.],
  [11], [Engaging],[The product should consistently engage users to continuously use it, promoting interaction.]
  ),
  caption: [Usability requirements],
) <table:usabilityRequirements>

== Technical Requirements
All technical requirements are listed in @table:technicalRequirements. Requirement 1 (MCU) was specified to balance processing power with cost-effectiveness, aligning with usability requirement 5 (@table:usabilityRequirements). Selecting a Microcontroller Unit (MCU) over a full-fledged computer simplifies the device architecture while preserving flexibility, user-friendliness, and affordability. The chosen MCU platform also needed built-in support for wireless communication, per requirement 4 (Wireless Connection).

Directly linked to requirement 1, requirement 2 (Dedicated MIDI Host) was defined to prevent the limited processing power of the MCU's from introducing latency that would conflict with requirement 9 (Low Latency) in @table:technicalRequirements. To address this, a dedicated MIDI _Host_ was specified to handle MIDI functionality separately from the Controller that the user would use to experiment with music. It was decided to use MIDI as it is a widely adopted protocol for transferring messages in music production @noauthor_midiorg_2023.

Requirement 3 (Digital Audio Workstation) was introduced to further offload sound generation from the MCU's to an external Digital Audio Workstation (DAW), drawing inspiration from @chen_humming_2019, enabling greater flexibility in sound selection and ensuring higher audio quality. Live by Ableton @ableton_ableton_2025 was chosen as the DAW of choice due to its robust MIDI handling, real-time performance capabilities, and wide adoption in both amateur and professional music production @noauthor_why_2024. Although this choice imposed a dependency on a separate computer, limiting the flexibility mentioned in requirement 2 (@table:usabilityRequirements), it was decided that the advantages in terms of sound choice and audio quality outweighed this limitation. 

The Host would act as the central connector in the system, interfacing between the Controllers and Live, ensuring smooth communication and coordination across all components (@fig:DeviceRelationsshipsSprint1).

Requirement 4 (Wireless Connection) was defined, since there would both be a Host and multiple Controllers, they would all have to communicate. Among available options, WiFi was selected for its lower end-to-end latency compared to alternatives like Bluetooth #cite(<sharrow_speed_2025>), ensuring that the system could transmit MIDI data rapidly enough as required by requirement 9 (Low latency).

#figure(
  image("../images/sprint 1/DeviceRelationshipsSprint1.png", width: 42%),
  caption: [Diagram illustrating system relationships between devices.]
) <fig:DeviceRelationsshipsSprint1>

Furthermore, requirement 8 (Plug'N'Play) was included to facilitate usability requirement 6 (@table:usabilityRequirements), as the technical aspect of the product should be designed keeping this philosophy in mind. This consideration further informed the inclusion of requirement 7 (Low power consumption), emphasizing that the product should require no additional cables or chargers, functioning immediately upon turning it on.

Both requirement 5 (NFC Reader) and requirement 6 (Display) were defined in correlation to requirement 4 and 11 (feedback and engaging, @table:usabilityRequirements). Requiring an NFC reader was inspired by retro gaming consoles as well as the NFC wooden blocks from #cite(<sabuncuoglu_tangible_2020>, form: "prose"), hopefully leading to the product feeling more tangible and interactive. Adding a display would make it easy to show which instrument's sounds were in use and provide important feedback #cite(<norman_design_2013>, supplement: [ch. 4]) to the user, which was deemed especially important by #cite(<chen_humming_2019>, form: "prose").

The last, and arguably most important, requirement, 10 (Interactive sensors), was required as this was what the user would use to interact and interface with the Controller for experimenting with music. By incorporating an array of sensors, such as buttons and potentiometers drawing inspiration from commercial music hardware @thomann_roland_2025 @native_instruments_native_2025 @teenage_engineering_teenage_2025, it would be ensured that the user's interactions with Controllers were captured and translated into music. This requirement not only is the foundation of the overall user experience, but also solidifies the system's ability to deliver real-time musical interaction.

#figure(
  table(
  columns: (auto, 1fr, 2fr),
  align: start,
  table.header([*Id*], [*Feature*], [*Description*]),
  [1], [MCU], [Each device should be run by an MCU.],
  [2], [Dedicated MIDI host], [Host should act as MIDI controller and interface with Ableton Live.],
  [3], [Digital Audio Workstation], [Sound should be produced using a DAW on a computer.],
  [4], [Wireless connection], [Controllers should interface wirelessly with Host.],
  [5], [NFC reader], [A NFC Reader should be used for changing controllers' instruments.],
  [6], [Display], [A display should relay information and engage users.],
  [7], [Low power consumption], [Controllers should be powered by batteries, and the host should be bus-powered by its connected computer.],
  [8], [Plug'N'Play], [Devices should simply work when turned on, without any tinkering or configurating, and the order of the devices being turned on shouldn't matter.],
  [9], [Low latency], [There should be minimal latency from when a user interacts with a controller to when a sound is produced.],
  [10], [Interactive sensors], [Controllers should have sensors for the user to interact with.]
  ),
  caption: [Technical requirements]
) <table:technicalRequirements>

== Hardware experimentation and exploration

=== MCU
Two MCU families were evaluated for both the controllers and the MIDI host (Requirement 1, @table:technicalRequirements): the Raspberry Pi Pico series and the Arduino Uno series @raspberry_pi_ltd_buy_2025 @arduino_arduino_2025. Both offer WiFi–capable models and provide sufficient general-purpose input/output (GPIO) pins to accommodate the project’s sensors and actuators (buttons, potentiometers, NFC reader, and display). The Arduino platform presented advantages in terms of prior team familiarity, extensive library support, a well-­established first-party IDE and proof of MIDI compatibility @chen_humming_2019. However, its WiFi–enabled variants carry a significant price premium, often costing more than double that of comparable RP2040-based boards @jkollerupdk_raspberry_nodate @ardustoredk_arduino_nodate.

In contrast, the Raspberry Pi Pico series combines very low unit cost with robust performance and library support for both WiFi and MIDI functionality. Although the Pico lacks some of Arduino series’ out-of-the-box shield compatibility and IDE simplicity, its community offers both free documentation, tutorials, and many well-made third-party libraries. This balance of affordability, sufficient processing capacity, and ecosystem support aligned closely with the cost-accessibility requirement (Requirement 5, @table:usabilityRequirements). It was also noted that the Pico series' GPIO pins could output a maximum of 3.3V. This was deemed not being a problem, but was important when choosing other components for the Controller and Host.

Ultimately, the Raspberry Pi Pico series was selected. The more powerful Pico 2 W (Pico 2) was assigned to the host, where heavier computation would be done, and the original Pico W (Pico 1) was chosen for the Controllers to minimize per-unit expense. This configuration preserves overall system performance and flexibility, while ensuring the final devices remain inexpensive.

==== CircuitPython
While exploring the Raspberry Pi Pico ecosystem the CircuitPython programming language @adafruit_circuitpython_nodate was discovered. CircuitPython is based on Python and promises simplicity, quick prototyping and "strong hardware support" @schroeder_what_2024. Furthermore, CircuitPython's creator Adafruit has already created many packages and libraries for everything from interfacing with displays to Bluetooth connectivity, including packages for working with WiFi @noauthor_adafruit_2025 and MIDI @walters_adafruit_2025. While testing, a Pico 2 was successfully programmed to host a WiFi hotspot using the WiFi library. Likewise, a Pico 1 was successfully configured to connect to the Pico 2's hotspot, and they could successfully exchange simple HTTP messages wirelessly. For experimentation purposes, using the MIDI library, the host was successfully configured to act as a MIDI interface, sending notes on multiple channels to an instance of Live running on a USB-connected laptop. 

The primary drawback of CircuitPython was the limitation of only a single central processing unit core being available on the Pico @mlewus_multicore_2021. raising concerns about multitasking performance as the host device would need to manage multiple Controllers and a computer concurrently. Fortunately, the discovery of the _asyncio_ library addressed this limitation @halbert_cooperative_2022 by providing a cooperative multitasking framework, where functions explicitly yield control and later resume after a specified interval, making sure functions do not block each other.

=== Display <sprint1display>
To address the technical requirement (Requirement 6, @table:technicalRequirements) stating the product should incorporate a display, it was researched which would be the best fit. The selected component was the Pico Display Pack 2.0 @pimoroni_pico_2025, which is based on the ST7789 display driver and uses the Serial Peripheral Interface (SPI) protocol for communication. This particular display was chosen for its natural compatibility with the Picos and their 3.3V power output, its compact physical dimensions, and cost-effectiveness, thereby supporting the project's goal of maintaining affordability (Requirement 5, @table:usabilityRequirements).

Initial testing was carried out using example code provided by Adafruit @adafruit_circuitpython_2025. The code was successfully loaded onto a Pico 2 and produced a "Hello World" output on the display (@fig:helloworlddisplay).

#figure(
  image("../images/sprint 1/hello-world-display.jpeg", height: 20%),
  caption: [Initial Display Test],
) <fig:helloworlddisplay>

As the display was originally intended to be mounted directly on top of the Pico, further testing was performed to determine the minimum set of pins required for full display functionality while ignoring the display's integrated buttons and LED. This process was complicated by the absence of a formal datasheet for the display since only a schematic was available @pimoroni_pico_2025, but was ultimately successful.

=== NFC Reader <sprint1nfc>
Compatible with the Pico's 3.3V power output, the _Parallax RFID Reader_ @parallaxcom_rfid_2024 and _RFID RC522 Module_ @arduinotechdk_rfid_2025 were considered for implementing NFC functionality (Requirement 5, @table:technicalRequirements). After brief testing and evaluation, the RC522 was chosen. 

The decision rested on three factors: physical size, cost (Requirements 3 & 5, @table:usabilityRequirements) and it being used in other music-related projects confirming it's reliability @turisc_turiscgrimmboy_2025. The Parallax reader was nearly twice as big as the RC522, making it less suitable for a compact setup. Furthermore, the Parallax reader was significantly more expensive, priced five times higher than the RC522 module @arduinotechdk_rfid_2025 @parallaxcom_rfid_2024.

The RC522 module had an involved setup process, particularly due to the need for SPI communication. Challenges arose in finding appropriate documentation. Most available libraries for both the exact model and NFC readers in general were designed for MicroPython. However, the library `circuitpython-mfrc522` @davis-foster_domdfcodingcircuitpython-mfrc522_2021 offered full support for the necessary NFC functionality and proved to be a workable solution. The trade-off in ease of use was considered acceptable, given the substantial advantages in both size and cost.

Instruments were assigned the two NFC cards included with the reader: one representing a piano and the other a drum kit. The mobile application NFC Tools @wakdev_nfc_2025 was used to find the ISO standard of the cards, in case the project called for extra, and to further explore and understand NFC technology. It was discovered that the cards used the ISO 14443A standard @laurie_iso14443_2015.

This led to a basic breadboard setup where the reader was connected to a Pico and two differently colored LEDs, each assigned an instrument. The code was kept intentionally simple, but was adapted to map the Unique Identifiers (UIDs) of the NFC cards to instrument names (@listing:nfcCardLabels) in a dictionary. 

#figure(
  ```cpy
  card_labels = {
    "80710414E1": "tromme",
    "2ECB5873CE": "klaver",
  }
  ```,
  caption: [Code mapping cards UIDs to labels.]
) <listing:nfcCardLabels>

First of all, when a card was scanned, its UID was compared with the previously scanned card (@listing:nfcCardChangeLED:2) to avoid processing repeated input from the same card. The code worked by scanning a card and matching its UID to an instrument using the predefined dictionary (@listing:nfcCardChangeLED:4 to @listing:nfcCardChangeLED:13), printing a message to the Read-Eval-Print Loop (REPL) indicating which instrument had been selected (@listing:nfcCardChangeLED:6), and activating the Light Emitting Diode (LED) assigned to the instrument (@listing:nfcCardChangeLED:10). Scanning the other card switched the active LED and updated the console output to reflect the newly selected instrument. If the UID did not match any known label, a message was printed indicating that (@listing:nfcCardChangeLED:16), and both LEDs were turned off (@listing:nfcCardChangeLED:17).

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
  image("../images/sprint 1/nfcFirstSetup.jpg", height: 30%),
  caption: [Initial NFC Test.],
) <fig:nfcFirstSetup>

=== Musical interaction <sec:sprint1MusicalInteraction>
The last technical element experimented with during the first sprint was the "interactive sensors" (Requirement 10, @table:technicalRequirements). The chosen sensors were eight buttons and four potentiometers, where each button should play a note, and the potentiometers should be used to experiment with the sounds. Having specifically eight buttons was because it formed a good balance between usability and how music often is split into fours.

Multiple button types where explored. This included both tactile switch buttons @adafruit_tactile_nodate but also force sensitive resistors @adafruit_square_2022 and piezoresistors @kosaka_e-drum_nodate, which would allow the user the play notes with different velocities. Ultimately, however, it was decided to use the tactile switch buttons, to keep the design and development process simple.

Getting buttons to work with the Pico 1's was very easy using Circuitpython's _board_ and _digitalio_ libraries #cite(<noauthor_board_2025>) #cite(<noauthor_basic_2025>). Using these, a GPIO pin on the Pico could be referenced (@listing:buttonsPullUp:1), defined as an input pin (@listing:buttonsPullUp:3), and pulled high to avoid floating values, when the connected button wasn't pressed (@listing:buttonsPullUp:4). The libraries became the backbone of how the Controllers would read user input.

#figure(
  ```cpy
  POT_PIN = board.GP13
  btn = digitalio.DigitalInOut(POT_PIN)
  btn.direction = digitalio.Direction.INPUT
  btn.pull = digitalio.Pull.UP
  ```,
  caption: [Code pulling input-pin GP13 to high.]
) <listing:buttonsPullUp>

Lastly, a sister-library to _digitalio_, _analogio_ was discovered for reading analog inputs @noauthor_analog_2025. It was decided this library was to be used for reading the potentiometers. However, it was noted that the Pico's only had three analog inputs. Therefore, a solution would later have to be found to connect all four potentiometers to the Pico 1s.

== Paper prototype <sec:paperprototype>
#figure(
 image("../images/sprint 1/paperprototype.png", height: 25%),
  caption: [Paper Prototype],
) <fig:paperprototype>

To facilitate a shared understanding of the product's physical layout within the team, a paper prototype was created, as illustrated in @fig:paperprototype. The design incorporated the buttons and potentiometers, selected to balance simplicity and functionality with the physical constraints of the box's size (Requirements 2, 3 & 9, @table:usabilityRequirements).

The prototype was constructed at a 1:1 scale using colored cardboard and adhesive tape to accurately represent the intended dimensions of the final product. Interface components were color-coded: the display was represented by a blue cutout, buttons by red cutouts, and potentiometers by pink cutouts. A hole was also cut on top and in the right side of the prototype, acting as possible insertion holes for the NFC cards. In addition to supporting a shared understanding, the prototype functioned as a tool for assessing usability and interface intuitiveness in the early stages of development.

=== Testing
The prototype was tested by a student enrolled in the Game Development and Learning Technology program at the University of Southern Denmark. This choice was made, as the participant's prior knowledge of paper prototypes would allow for gathering valuable insight on usability #cite(<macklin_games_2016>, supplement: [ch. 11]). Due to the participant's personal relation to the team, feedback was looked upon with caution to mitigate potential bias #cite(<macklin_games_2016>, supplement: [ch. 11]). 

The test was conducted at the University of Southern Denmark and involved an unstructured interview #cite(<sharp_interaction_2019>, supplement: [ch. 8]), combined with the Think Aloud methodology #cite(<sharp_interaction_2019>, supplement: [p. 296]). An A/B test #cite(<sharp_interaction_2019>, supplement: [ch. 2]) was also carried out to assess the preferred side of the box for inserting the NFC cards. This multi-method approach supported a flexible testing environment and allowed exploration of questions not already pre-defined before the test. The session lasted approximately 30 minutes and yielded constructive criticism, while the overall user response remained positive.

The participant had limited musical experience, only having played piano during childhood. When first viewing the prototype, initial confusion regarding the different physical elements was noted. However, after a short briefing, the participant was able to interpret the key interface elements e.g., identifying the blue rectangle as the display shown in @fig:paperprototype.

The participant's preliminary expectations included functionality for recording and playback of predefined beats, similar to _GarageBand_ @apple_garageband_2024, and the ability to alter pitch, intended humorously to produce annoying sounds. Although the participant was not part of the target demographic, such feedback was interpreted as indicative of an exploratory and motivated interaction approach. During the A/B test, the participant expressed a preference for inserting the NFC cards on the right side of the device. 

Further observations indicated the importance of tactile feedback and visual indicators such as LEDs. A layout revision was recommended to better support left-handed users, ensuring potentiometer interaction would not obscure the screen. Additional suggestions included the inclusion of a power switch and the use of neutral colors for the device casing.