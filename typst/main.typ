#import "@preview/wordometer:0.1.4": word-count, total-words, total-characters
#show: word-count.with(exclude: (<no-wc>, figure))

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
Ej, du! Hør lige her! Det her projekt, det er sgu da for fedt! Vi har lavet sådan en dims, man kan røre ved, så man kan lave musik. Ikke sådan noget kedeligt noget, men noget der er lige til at gå til, så man kan sidde og hygge sig med det og finde ud af, hvad der sker. Vi har lavet det i flere omgange, og vi har haft ungerne til at prøve det, så vi er sikre på, det virker, som det skal.

Vi har fået lavet to af de her "spille-bøtter" og så en "hoved-bøtte". Spille-bøtterne har otte knapper, fire dreje-knapper, en dims der kan læse sådan nogle kort med instrumenter på, og så en lille skærm, der viser, hvad du spiller. Det hele kører på sådan en lille computer, der hedder en Raspberry Pi Pico W. Når du trykker på knapperne, sender den bare nogle signaler videre til hoved-bøtten, som så sender det videre til Ableton Live, der laver lyden. Og det hele er pakket ind i en 3D-printet kasse, der kan skilles ad, hvis der skal rodes med indmaden.

Vi har testet det her af med ungerne, og de synes, det er skide sjovt! Især når de er flere om det. Der var lige lidt bøvl med skærmen, der var lidt langsom, og dreje-knapperne var lidt svære at finde ud af for nogen, men alt i alt, så er det noget, der kan få folk til at kaste sig over musikken, uden at det bliver for besværligt. Så det er sgu et godt stykke arbejde, vi har fået lavet her, det er det!
]
)

#include "Acronyms and Terms.typ"
<no-wc>

#include "sections/Acknowledgements.typ"
<no-wc>

#colbreak()
#include "sections/Introduction.typ"

#include "sections/State of the Art.typ"

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