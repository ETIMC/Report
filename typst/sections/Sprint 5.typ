== CAD Design
=== Controller
- Potentiometer
- Lid with sprint 4 design
- Ny bund inkl. ny standoffs og NFC modifikationer (stoerrelse og LDR/LED)
  - Ny sider (især NFC side) printet på andet led = svært at sætte fast


There was then made a new side, with the same opening, but with more rounded edges. When it was printed, it was printed on the side and therefore did not need to print support inside the hole. The side was more difficult to get placed in the box, because of the way it was printed.
  
- Knapper

=== Host
- Host-kasse

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

== Testing
The last round of user testing was conducted at Rosengårdskolen and involved six individual participants from the 5th grade here, three had participated in the test during Sprint 4. Each session lasted approximately seven and a half minutes.

During this test, a functional prototype was presented (@fig:sprint4setup). However, as previously discussed in #text(red)[reference section yippie], issues with the PCB configuration prevented the potentiometers from functioning correctly during this session. The test employed A/B testing, Think Aloud methodology, and unstructured interviews.

#figure(
  image("../images/sprint 5/sprint5test.png", height: 30%),
  caption: [Test Setup for Sprint 5],
) <fig:sprint5setup>
- Læg vægt på der er to controllers til i den her test!