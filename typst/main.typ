#import "@preview/wordometer:0.1.4": word-count, total-words, total-characters
#show: word-count.with(exclude: (<no-wc>, figure, heading.where(supplement: [Appendix])))

#import "@preview/codly:1.3.0": *
#show: codly-init.with()
#codly(
  languages: (
    cpy: (name: " CircuitPython", icon: emoji.snake, color: rgb("#652f8e")),
  )
)

#import "@preview/subpar:0.2.2"

#import "template.typ": AcademicTemplate
#show: AcademicTemplate.with(
  title: "Exploring Tangible Interfaces
  in Music Creation",
  course: [Bachelor Project \ BSc (Eng) Game Development and Learning Technology \ University of Southern Denmark
    ],
  authors: (
    (
      name: "David Kirckhoff Foght",
      examNumber: "190401913"
    ),
    (
      name: "Rebekka Hakon Troelsen",
      examNumber: "190401898"
    ),
     (
      name: "Jamie Høj",
      examNumber: "190402437"
    )
  ),

  seperateTitlePage: true,
  useToc: true,
  seperateTocPage: true,
  thesis: true,
  seperateAbstractPage: true,
  firstLineIndentWidth: 0em,
  columnsAmount: 1,
  paragraph-spacing: 1.5em,
  language: "en",
  bibliography-file: "SpilTek.bib",
  appendices-file: "Appendices.typ",
  timespan: "2nd of June 2025",
  mainSupervisor: (fullName: "Jacob Nielsen"),
  characterCount: total-characters,
  titlePageImagePath: "images/frontPageImage.JPG",
  abstract:[
  This bachelor's thesis addresses the challenge of empowering young users to engage with music and cultivate intrinsic motivation through curiosity-driven, playful, and exploratory interactions.

  To tackle this, an iterative, user-centered design methodology was employed, focusing on a target group of children aged 9-12. This involved the design and development of a tangible hardware interface prototype. The system comprises two Controllers and a dedicated Host device. The Controllers integrate NFC card readers, buttons, and potentiometers, allowing users to play harmonically fitting notes and control various effects. These interactions are translated into MIDI messages via the Host device, which connects to a computer running Live by Ableton.
  
  User testing yielded positive results, indicating that the tangible interface was highly intuitive and enjoyable, particularly in collaborative settings. The interface successfully lowered the entry barriers to music creation, fostering a more accessible and engaging experience. In conclusion, this project demonstrates the significant potential of tangible design to promote inclusive and curiosity-driven musical exploration among young individuals.
  #v(80pt)

  #set align(center)
  
  *To learn more about the project please visit:*

  _Video Walkthrough:_
  \
  #text(blue)[#underline[#link("https://drive.google.com/file/d/1H6dUJ6WPt3np7xRLT2iUnK9Qn9W2uAV5/view?usp=sharing")]] <no-wc>
  
  _GitHub Repositories:_
  \
  #text(blue)[#underline[#link("https://github.com/ETIMC")]] <no-wc>
  ]
)

#include "Acronyms and Terms.typ"
<no-wc>

#include "sections/Acknowledgements.typ"
<no-wc>

#colbreak()
#include "sections/Introduction.typ"

#include "sections/State of the Art.typ"

#include "sections/Method & Materials.typ"

#colbreak()
#include "sections/Idea generation.typ"

#colbreak()
#include "sections/Sprint 1.typ"

#include "sections/Sprint 2.typ"

#include "sections/Sprint 3.typ"

#include "sections/Sprint 4.typ"

#include "sections/Sprint 5.typ"

#include "sections/Evaluation.typ"

#include "sections/Results.typ"

#include "sections/Discussion.typ"

#include "sections/Conclusion.typ"