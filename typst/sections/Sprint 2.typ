During sprint 1 the team planned and began the prototyping of the product. Design choices where made which included that the system would consist of a host device, and one or more controller devices communicating via wifi. Capabilities of making the controller modular, such as experimentation with an NFC reader for deciding the instrument played, and a display visualizing the choice was initiated during the prior sprint. The team also created a paper prototype where a test was held to gather feedback that could then be taken into consideration #text(red)[highlight which parts we used during this sprint to guide the development!]. The sprint successfully established that the components were usable in stand-alone implementations.

== Focus of Sprint 2
For this sprint the team wanted to interconnect the individual components into a functional breadboard prototype. This for example meant that choosing an instrument using an NFC card would trigger the screen to display a picture of the selected instrument, and change the sounds played through Ableton.


== Controller input -> Host -> Audio
== Setup on Breadboard
- Interconnecting different elements of the project together.
  - Display.
  - Host.
  - NFC reader.
    - Many problems
      - Code from sprint 1, did not work, when implemented on the breadboard with the other components...
    - Tested and tried different code examples, but RFID reader could not properbly do it
      - Maybe because overbelastning?
    - Implemented on "clean" breadboard (away from other components) 
      - Found new library from https://github.com/domdfcoding/circuitpython-mfrc522
        - Made it easier
        - Simple code - push button to read card
          - Importent line! 'rfid.init()' which reinitialize the RFID module
            - Does not work properly without that line!
          - Initializes the RFID reader (MFRC522) by setting up the necessary pins for SPI communication (SCK, MOSI, MISO, RESET, and Chip Select)
          - Button to trigger trying to read (button pressed = active low = reading)
            - Code sends request to check if there is a card
              - Presented card - retrieves the cards UID (uniques identifier)
              - Converts the UID into a hex string, so it can be compared with the card_label
                - If cards UID matches, print result
            - After reading card (whether it was known or unknown), the code reinitializes the RFID reader to prepare for the next read. This ensures that the system remains stable and can read cards correctly over time
- Setup buttons on breadboard.
- Potentially put on potentiometers, and figure out functionality.
- Tested multiplexer in its own circuit with three LED's, which worked! (to test its functionality)
== Finishing the Schematic
== Continuous experimentation with NFC reader and screen
== Fusion 3D Experimentation
- Design chassis (sketches first)
- First button/pad designs
- Possibly potentiometer handles
== Testing on the Target Group
The test was conducted at the University of Southern Denmark, where the prototype was evaluated by five individual participants. All participants fell within the age range of the intended target group. The testing procedure consisted of a think-aloud part, where testers could experiment using the product while providing feedback. This was followed by an unstructured interview. These methods were selected for their adaptability, which proved particularly beneficial given that the participants were children. This flexibility allowed the children to guide parts of the session by posing questions, offering detailed feedback, or requesting additional guidance on the use of the product and its features. On average, each testing session lasted approximately 10 minutes.

Before the test took place, the team developed a set of standardized questions that were posed to all participants. This approach ensured consistency and allowed specific areas of interest to be thoroughly explored and assessed.

In one instance, two participants were present in the room simultaneously; however, they completed the test individually and responded to the predefined questions together afterward. All remaining sessions involved one participant at a time.

During the test, the main focus points were: 
1. Testing the breadboard implementation and getting feedback on usability as seen in @fig:sprint2setup.
2. Testing which buttons were preferred by the testers.
3. Showcasing the paper-prototype and getting feedback on colorschemes and dimensions.

#figure(
  image("../images/sprint2-test-setup.png", height: 20%, width: 70%),
  caption: [Test Setup for Sprint 2],
) <fig:sprint2setup>

*Summarized Feedback:*

All participants expressed an enjoyment of playing music. Two noted that they regularly played on keyboards at home. None of the testers had received formal instruction through a music school or similar program. Those without prior experience playing an instrument showed a clear interest in learning. Additionally, all testers found the product intuitive and easy to use, with no reports of confusion or difficulty. Universally, the product was described as fun and engaging.

*Specific Feedback Points:*

1 SWITCHES
- Five out of six testers expressed a preference for the keyboard switches over the switches used on the breadboard. 
2 VISUAL FEEDBACK
- All testers responded positively to the idea of incorporating LEDs in different colors. 
- One tester suggested dark colors (Winter colors) for lower notes and lighter (Spring colors) for higher notes if the LEDs were placed by the buttons. 
3 NFC READER PLACEMENT AND INTERACTION
- All testers preferred inserting the NFC card on the right-hand side of the product. Upon further inquiry, it was revealed that all participants were right-handed, suggesting this preference may be due to handedness bias.
- Alternative suggestions included:
  - Swiping the card along the front of the product to trigger instrument changes.
  - Simply placing the card on top of the device to activate a new instrument.
4 POTENTIOMETERS
- All testers found the potentiometers somewhat confusing and challenging to use.
- The difficulty stemmed from their small size and limited range of rotation due to a built-in stopper, which restricted the degree of movement.
5 DURABILITY CONCERNS
- One tester expressed concern about the potential for the device to be damaged if objects other than the NFC card were inserted.
- The same tester also mentioned worrying about the product being easily damaged if dropped.
6 COLLABORATIVE PLAY
- All testers expressed enthusiasm about playing music with others.
- However, one tester raised a concern that if all users played the same instrument simultaneously, it might become irritating. They suggested that using different instruments would make the experience more enjoyable.


