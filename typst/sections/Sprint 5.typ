= Sprint 5

// OVERVIEW 

== CAD Design
=== Controller
During testing, the participants preferred the knobs resting on top of the lid (@sec:test4). Furthermore, one participant noted that the currently used potentiometers obstructed the display. As a result, the potentiometers on the PCB were replaced with lower-profile versions, and the knobs were redesigned accordingly to match the new dimensions.

To support cooperative play in the upcoming test session, aligning with Cooperative Play (Requirement 1, @table:usabilityRequirements), a second chassis was needed. Prior use of the original chassis revealed several design limitations, which were addressed before printing the new version. Notably, the standoffs were redesigned to be taller and to include integrated threaded cylinders for mounting the PCB, removing the need for separate 3D-printed screws and spacers.

After printing the second chassis, it was discovered that earlier changes to the NFC side panel from a wide opening (@sec:sprint3cad) to a narrower one (@sec:sprint4Cad), unintentionally affected the internal geometry of the NFC reader holder. Specifically, it caused unsupported filament to sag during printing, interfering with card insertion. To resolve this, the NFC reader holder was revised to provide sufficient internal clearance, and the chassis was reprinted without further issues.

The NFC side panel also underwent another revision. Observations during the test (@sec:test4) indicated that the narrow NFC card insertion hole was difficult to use, because of its height and remaining support problems. In response, the hole was slightly widened, and the edges were rounded to help guide the NFC card during insertion.

New side panels were printed, which included a full set for the new chassis as well as a new NFC reader side for the old chassis. Unlike earlier prints, these were printed laying down flat inside the 3D printer. This eliminated the need for support material inside the NFC card insertion hole resolving earlier problems. However, this approach also resulted in support material being added to the "slit/slide" mechanisms of the sides making assembly of the entire chassis slightly more difficult. 

The last step was to improve visual cohesion and aesthetics, pre-designed button keycaps @luca_mechanical_2025 compatible with the used switches was found and printed. Additionally, the lid design (@sec:decorations) was added to the lid and printed @fig:3dchassis. These final changes gave the chassis a cleaner finish and a more playful, cohesive and engaging appearance (Requirement 11, @table:usabilityRequirements).

#figure(
  image("../images/sprint 5/sprint5chassis.JPG", height: 30%),
  caption: [One of the finished 3D printed Controllers.]
) <fig:3dchassis>

=== Host
To improve usability and support the Plug’n’Play requirement (Requirement 6, @table:usabilityRequirements), a dedicated enclosure was designed for the Host. The box was tailored to fit the breadboard setup, with one side featuring four cutouts for USB-A ports and another with an opening for the cable connected to the Pico 2. The lid was designed to sit flush inside the enclosure and included a cutout to allow visibility of the internal LEDs.

To make the enclosure both informative and visually engaging, descriptive text was added around the LED cutout, highlighting the box’s purpose in a playful way. Although the print was not completed in time for user testing, it was printed shortly afterward @fig:3dhost.

#figure(
  image("../images/sprint 5/3dhost.jpg", height: 30%),
  caption: [3D printed enclosure for the Host.]
) <fig:3dhost>

== Additional instruments
To further extend the Controller's musical palette, new instruments were added, so that a total of 11 instruments were available. These were first assigned their MIDI channels (@table:11Instruments), and afterwards added to Live, each instrument getting their own MIDI track (@fig:sprint5Ableton11Instruments).

#figure(
  table(
  columns: (auto, auto),
  align: start,
  table.header([*Instrument*], [*MIDI Channel*]),
  [Drums], [1],
  [Piano],[2],
  [Guitar],[3],
  [Trumpet],[4],
  [Synthesizer],[5],
  [Electric Piano],[6],
  [Bass],[7],
  [Cello],[8],
  [Violin],[9],
  [Flute],[10],
  [Electric Guitar],[11]
  ),
  caption: [All 11 available instruments and their respective MIDI channels.]
) <table:11Instruments>

#figure(
  image("../images/sprint 5/Ableton-11Tracks.png", width: 75%),
  caption: [Live setup for playing a total of 11 different instrument on different MIDI channels. \ The rightmost 12th MIDI channel was for internal testing and not present during external testing.]
) <fig:sprint5Ableton11Instruments>

New NFC cards were sourced, so that each instrument could be assigned their own NFC card as the previous four instruments had. Unfortunately, upon testing them internally, the newly sourced NFC cards were incompatible with both the NFC reader and NFC tools mobile app. It was concluded that the new cards operated on a different frequency than the originally used ones. To accommodate this during the test, as only the original NFC cards were available, a piece of paper was constructed with the available instruments labeled upon it, which would be presented to testers (@fig:11InstrumentsCard). The testers would then have to say which of the new instruments, they would like to play, whereafter a team member, would configure Live, so that their controller was assigned to the correct MIDI channel. This was an imperfect solution but successfully resulted in the new instruments being tested.

#figure(
  image("../images/sprint 5/11InstrumentsPaperCard.jpg", width: 25%),
  caption: [Paper showing available instruments not on NFC cards.]
) <fig:11InstrumentsCard>

== PCB Production
Initially, the plan was to solder only a single additional PCB for use in a forthcoming test focused on collaborative interaction. Once the professionally manufactured PCBs arrived, one was quickly assembled with the necessary components. Due to the quick assembly time, testing of the functionality of the potentiometers was conducted which yielded positive results; the potentiometers worked as intended on this rendition of the PCB.

However, given that a previous test had been conducted using the faulty PCB where the potentiometer functionality did not work, and upon realizing how efficiently the new PCBs could be assembled, the team unanimously decided to prepare a second board in time for the next test to replace the faulty PCB. This decision was made to ensure a consistent and equitable user experience for all participants, avoiding a scenario in which some would interact with a fully functional system while others were limited by hardware shortcomings.

During the assembly of both PCBs, feedback gathered during the test from the prior was incorporated. Specifically, smaller potentiometers were selected to address concerns of obstructing the view of the display (@fig:finalpcbs).

#figure(
  image("../images/sprint 5/2pcbssoldered.jpg", height: 30%),
  caption: [Final rendition of soldered PCBs],
) <fig:finalpcbs>

== Testing
The last round of user testing was conducted at Rosengårdskolen and involved six individual participants from the 5th grade. Three had participated in the test during Sprint 4. Each session lasted approximately twelve minutes.

During the test, two functional controllers were presented alongside paper detailing extra instruments that could be played, but were not configured to NFC cards (@fig:sprint5setup). This allowed for two participants to be present in the room at the same time. Furthermore, it raised the opportunity of testing the proposed idea of a collaborative experience, enhancing the user experience. The test employed Think Aloud methodology and unstructured interviews.

#figure(
  image("../images/sprint 5/sprint5test.png", height: 30%),
  caption: [Test Setup for Sprint 5],
) <fig:sprint5setup>

All participants responded positively to the experience of trying the product, consistently describing it as enjoyable. It was observed that selecting an instrument via the NFC card posed no difficulties for users during this test either.

Althrough the collaborative element of the test was heavily influenced by the chemistry between participants, all reported that they preferred using the product together rather than individually. One participant noted #quote[Hmm.. Yeaaah.. It is like, it can be nice to sit with it yourself, but it sounded a little better when you do it together and find a good rhythm.] (translated from Danish to English) (@app:Sprint5Transcriptions)

When asked about the display's loading time, one pair confirmed that they noticed it but did not find it disruptive. Overall, the display received positive feedback with one participant stating: #quote[It is very cool. It is also very nice that you know which instrument it is.] (translated from Danish to English) (@app:Sprint5Transcriptions).

Reactions to the potentiometer functionality were mixed. Some participants were unsure of their purpose, expressing that they did not perceive a difference in sound output. One remarked #quote[I could not really hear a difference in any of it.] (translated from Danish to English) (@app:Sprint5Transcriptions). This was possibly attributed to a limitation in the test setup: only certain instruments (those with corresponding NFC cards) had potentiometer functionality enabled, which was not communicated properly to participants. Furthermore, the potentiometer with the most perceivable function, adjusting volume, was disabled after the first test due to it causing system issues.

The updated design of the top chassis also received positive remarks. Participants found it more engaging compared to the previous, all-black design, with one stating that it invited interaction. However, suggestions were made to incorporate more vibrant colors: #quote[Yes, a little. But maybe if it had a little more color instead of just black, white, and gray.] (translated from Danish to English) (@app:Sprint5Transcriptions).

Several participants expressed a desire for more switches and additional functionalities, including the ability for sounds to play as long as a button was held down.

Notably, one participant reported being inspired to learn the cello after the experience, an indication of high engagement. Although this sentiment was not shared by all, the plug-N-play nature of the NFC interaction was widely appreciated. One participant commented: #quote[It was very fun. Because you do not have to write all kinds of things, you just need to insert it, and then it works.] (translated from Danish to English) (@app:Sprint5Transcriptions). Finally, one pair of participants were excited about the idea of being able to buy the product as well.
