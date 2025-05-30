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
  abstract:[Word Count: #total-words. Character Count: #total-characters \
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

#include "sections/Idea generation.typ"

#include "sections/Sprint 1.typ"

#include "sections/Sprint 2.typ"

#include "sections/Sprint 3.typ"

#include "sections/Sprint 4.typ"

#include "sections/Sprint 5.typ"

#include "sections/Evaluation.typ"

#include "sections/Results.typ"

#include "sections/Discussion.typ"

#include "sections/Conclusion.typ"