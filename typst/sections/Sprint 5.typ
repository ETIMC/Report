== CAD Design
=== Controller
During user testing, participants noted that the potentiometers felt too tall. However, the toppers with a flat facet were preferred for their ergonomics and appearance. As a result, the potentiometers on the PCB were replaced with lower-profile versions, and the toppers were redesigned accordingly to match the new dimensions and reprinted (IMAGE).

To support cooperative play in the upcoming test session—aligning with Cooperative Play (Requirement 1, @table:usabilityRequirements)—a second chassis was needed. Prior use of the original chassis revealed several design limitations, which were addressed before printing the new version. Notably, the standoffs were redesigned to be taller and to include integrated screws, removing the need for inserting separate 3D-printed screws. This also eliminated the need for external offsetters, as the new standoffs provided the correct height.

The NFC base was also adjusted. The hole for the LDR was enlarged slightly and shifted toward the edge to prevent it from obstructing the NFC card insertion area.

However after printed, it was discovered that earlier changes to the NFC side panel—from a wide opening in Sprint 3(REF) to a narrower one in Sprint 4(REF)—unintentionally affected the internal geometry of the NFC base. Specifically, the lowered position of the NFC card slot caused unsupported filament to sag during printing, interfering with card insertion. To resolve this, the NFC base was revised to provide sufficient internal clearance, and the chassis was reprinted without further issues.
Although these changes technically meant the first controller chassis was outdated, it still functioned well with minor adaptations. Reprinting it was considered unnecessary and a waste of filament.

The NFC side panel underwent another revision. Feedback from testers indicated that the narrow slot introduced in Sprint 4 (REF) was difficult to use, because of the height and remaining support problems.  In response, the slot was slightly widened, and the edges were rounded to help guide the NFC card during insertion.

When printing the side panels, both the new NFC side for the first chassis, and all the ones for the new chassis (NFC panel, two plain sides, and the back panel) they were oriented flat rather than upright. This eliminated the need for support material inside the NFC slot, improving usability. However, this approach resulted in support material being added to the bottom edge that connects to the chassis, making assembly slightly more difficult.

The last step was to improve visual cohesion and aesthetics, a pre-designed button cap (LINK) compatible with the existing switches was found and printed. Additionally, the lid design introduced in Sprint 4(REF) was added to the lid and printed. These final changes gave the chassis a cleaner finish and a more playful, cohesive appearance.

=== Host
To improve usability and support the Plug’n’Play requirement (Requirement 6, @table:usabilityRequirements), a dedicated enclosure was designed for the Host. The box was tailored to fit the breadboard setup, with one side featuring four cutouts for USB-A ports and another with an opening for the cable connected to the Pico. The lid was designed to sit flush inside the enclosure and included a cutout to allow visibility of the internal LEDs.

To make the enclosure both informative and visually engaging, descriptive text was added around the LED cutout, highlighting the box’s purpose in a playful way. Although the print was not completed in time for user testing, it was printed shortly afterward (Figure).

== Additional instruments
To further extend the Controller's musical palette, new instruments were added, so that a total of 11 instruments were available. These were first assigned their MIDI channels (@table:11Instruments), and afterwards added to Ableton Live, each instrument getting their own MIDI track (@fig:sprint5Ableton11Instruments).

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
  caption: [Ableton Live 11 setup for playing a total of 11 different instrument on different MIDI channels. \ The rightmost 12th MIDI channel was for internal testing and not present during external testing.]
) <fig:sprint5Ableton11Instruments>

New NFC cards were sourced, so that each instrument could be assigned their own NFC card as the previous four instruments had. Unfortunately, upon testing them internally, the newly sourced NFC cards were incompatible with both the NFC reader and NFC tools mobile app. It was concluded that the new cards operated on a different frequency than the originally used ones. To accommodate this during the test, as other NFC cards were not available, paper was constructed with the available instruments, which would be presented to testers (@fig:11InstrumentsCard). The testers would then just have to say which of the new instruments, they would like to play, whereafter a team member, would configure Ableton Live 11, so that their controller was assigned to the correct MIDI channel. This was an imperfect solution but successfully resulted in the new instruments being tested.

#figure(
  image("../images/sprint 5/11InstrumentsPaperCard.jpg", width: 25%),
  caption: [Paper showing available instruments not on NFC cards.]
) <fig:11InstrumentsCard>

== PCB Production
Initially, the plan was to solder only a single additional PCB for use in a forthcoming test focused on collaborative interaction. Once the professionally manufactured PCBs arrived, one was quickly assembled with the necessary components. Unlike the earlier prototype, this iteration did not require manual drilling of holes or soldering of VIAs, as these steps had been completed during fabrication by the supplier, making for a more streamlined experience with soldering and alignment of components. It also meant that testing of the individual components' functionalities was easily achieved, and it was discovered that the potentiometers worked as intended on this rendition of the PCBs.

However, given that a previous test had been conducted using the faulty PCB where the potentiometer functionality did not work, and upon realizing how efficiently the new PCBs could be assembled, the team unanimously decided to prepare a second board in time for the next test. This decision was made to ensure a consistent and equitable user experience across all participants, avoiding a scenario in which some would interact with a fully functional system while others were limited by hardware shortcomings, while also allowing for testing of the potentiometers' functionalities.

During the assembly of both PCBs, feedback gathered during the test from the prior was immediately incorporated. Specifically, smaller potentiometers were selected to address concerns of obstructing the view of the display (@fig:finalpcbs).

#figure(
  image("../images/sprint 5/2pcbssoldered.jpg", height: 30%),
  caption: [Final rendition of soldered PCBs],
) <fig:finalpcbs>

== Testing
The last round of user testing was conducted at Rosengårdskolen and involved six individual participants from the 5th grade here, three had participated in the test during Sprint 4. Each session lasted approximately seven and a half minutes.

During this test, two functional controllers were presented alongside a print detailing extra instruments that could be played, but were not configured to an NFC card (@fig:sprint5setup). This allowed for two participants to be present in the room at the same time. Furthermore, it raised the opportunity of testing the proposed idea of a collaborative experience, enhancing the user experience. The test employed Think Aloud methodology and unstructured interviews.

#figure(
  image("../images/sprint 5/sprint5test.png", height: 30%),
  caption: [Test Setup for Sprint 5],
) <fig:sprint5setup>

Participants that had also participated before, said that the product was more fun to use than last since there were more things to try out; including the expanded range of instruments and the potentiometers being functional.

Participants responded positively to the added design to the top of the chassis, saying it was interesting and afforded interaction opposed to the prior all-black design.

One tester showed interest in learning to play the Cello after trying the product, which was seen as a sign of high engagement.

Additionally, it was both observed and voiced by participants that in order to fully enjoy the collaborative experience, chemistry between the participants was key. Here, two pairs of testers did not seem to be friends, and one pair did. This yielded completely different results in the answers from the participants. Some participants elaborated that they had each been doing their own thing with the product, but with more coordination between participants, it could be fun.

The pair who were deemed to be friends said the collaborative experience was very fun.