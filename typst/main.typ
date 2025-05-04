#import "template.typ": AcademicTemplate
#show: AcademicTemplate.with(
  title: "Exploring Tangible Interfaces
  in Music Creation",
  course: [University of Southern Denmark],
  authors: (
    (
      name: "David Kirckhoff Foght",
      mail: "dafog22@student.sdu.dk",
    ),
    (
      name: "Rebekka Hakon Troelsen",
      mail: "retro22@student.sdu.dk",
    ),
     (
      name: "Jamie Høj",
      mail: "jahoe22@student.sdu.dk",
    )
  ),

  seperateTitlePage: false,
  useToc: true,
  seperateTocPage: true,
  thesis: true,
  seperateAbstractPage: false,
  firstLineIndentWidth: 0em,
  columnsAmount: 1,
  paragraph-spacing: 1.5em,
  language: "en",
  bibliography-file: "SpilTek.bib",
  appendices-file: "Appendices.typ",
  timespan: "Project Period: 1st of February 2025 to 2nd of June 2025",
  mainSupervisor: (fullName: "Jacob Nielsen", email: "jani@mmmi.sdu.dk"),
  abstract:[]
)

= Acronyms and Terms
#include "Acronyms and Terms.typ"

= Acknowledgements
#include "sections/Acknowledgements.typ"

= Introduction

= Literature Review
#include "sections/Literature review.typ"

= Idea Generation
#include "sections/Idea generation.typ"

= Sprint 1
#include "sections/Sprint 1.typ"

= Sprint 2
#include "sections/Sprint 2.typ"

= Sprint 3
#include "sections/Sprint 3.typ"

= Sprint 4
#include "sections/Sprint 4.typ"

= Evaluation 

= Results

= Discussion
#include "sections/Discussion.typ"

= Conclusion
