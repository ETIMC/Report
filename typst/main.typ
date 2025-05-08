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
  timespan: "2nd of June 2025",
  mainSupervisor: (fullName: "Jacob Nielsen"),
  abstract:[Word Count: IDK YET]
)

#import "@preview/wordometer:0.1.4": word-count, total-words, total-characters
#show: word-count.with(exclude: (<no-wc>))
Total word count: #total-words \
Total character count: #total-characters

#cite(<aleksandra_acker_relationship_2015>, supplement: "p. 63-67")
= Acronyms and Terms
#include "Acronyms and Terms.typ"
<no-wc>

= Acknowledgements
#include "sections/Acknowledgements.typ"
<no-wc>

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
