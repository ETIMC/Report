= Discussion
Despite developing a functional prototype that enabled testing with the target group, several aspects of the project could have been improved to gain a more accurate understanding of the product's potential to foster engagement and musical interest within this group (Requirement 11, @table:usabilityRequirements).

During development, minor issues emerged, such as the selected display's long loading time when rendering new images. This delay temporarily disabled the rest of the Controller's functionality. Opting for a different display could have mitigated this problem and contributed to a smoother Plug'N'Play experience (Requirement 6, @table:usabilityRequirements & Requirement 8,  @table:technicalRequirements). Additionally, some hardware features remained underdeveloped; for example, the automatic NFC card detection. This functionality could have freed all buttons on the Controller to focus exclusively on sound interaction making the product more intuitive (Requirement 4,  @table:usabilityRequirements).

While a redesigned lid added a playful and less intimidating appearance (Requirement 9, @table:usabilityRequirements) that was well-recieved, the prototype overall lacked sufficient user feedback mechanisms. Enhancements such as expanding the display's functionality to show real-time feedback from buttons and potentiometers could have significantly improved usability. An alternative solution considered was priting labels directly onto the lid, but this proved challenging due to the need for the text to align with different instruments. Similarly, incorporating more visual cues directly on the NFC cards, rather than relying solely on printed text-labels, would have been beneficial.

Although the prototype was tested and useful feedback was collected, the evaluation methods used were, in retrospect, not optimal. Time constraints limited how long each participants could engage with the product, which may have influenced the quality of interview responses. More insightful data might have been obtained if users had been allowed to explore the product independently or with a peer in a distraction-free environment. Another valuable approach could have been lending the prototype to users for an extended period to observe long-term engagement. However, the project's limited duration made this infeasible.

One one the key usability goals was to ensure the product remained cost-effective (Requirement 5, @table:usabilityRequirements), therefore alternatives to Live _Suite_ edition could have been used. Options such as GarageBand or Live _Intro_ edition, which offer sufficient functionality at a lower cost, could have been explored further. Moreover, integrating an internal computer and built-in speakers into the prototype, rather than relying on a MCU, the Host and a computer for full functionality, could have simplified the setup and improved portability (Requirement 2, @table:usabilityRequirements).

Lastly, a more robust method of securing the lid to the chassis was desired. Magnets were considered but proved impractical, as the were too strong and failed to stay in place with glue.

/*

- Hvad fik vi lavet, virkede det i det stadie det er i?
  - Displayet blokerede alt andet, lang loading tid
  - LEDer kunne være tilføjet
  - NFC knap, skulle gerne være automatisk
  - Flere NFC kort 
    - Design på kortene
  - Bedre labeling af funktionaliteterne af produktet, knapper og potentiometerne
    - Generelt bedre feedback på hele produktet til brugeren
    - Bedre potentiometer effekter, noget hvor man virkelig kan høre forskellen
- Kritiske overfor test metoder
- Afhængighed af computer med ABLETON LIVE
  - Kunne andre DAWs bruges?
  - Ableton Live Intro er egentlig okay billigt (bliver ofte inkl. gratis med musikudstyr)
    - Strømproblemer? Trækker systemet for meget strøm?
      - Ekstern strømforsyning?
  - Forbindes til garageband på iPads? Chromebooks?
  - Intern computer i stedet for MCU? Højtalere?
- Magnetløsning var lårt fordi de var for stærke, og kassen ikke er printet på egen 3D printer woomp woomp
- Visuel løsning til at vise instrumenterne på nfc kortene direkte, evt. med vinyl løsningen





- Andet program end ableton live (gratis????)
- It is worth noting that while the _Suite_ version of Live has been used during development and testing, the _Intro_ version should be sufficient, since it supports up to 16 tracks and full MIDI capabilities @ableton_buy_nodate.
- soldering sucked big balls i swear to god i wanted to kill myself

*/