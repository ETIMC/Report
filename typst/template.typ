#let AcademicTemplate(
  // Report title
  title: [Report Title],
  titleFontSize: 24pt,

  // Course name
  course: none,
  
  // Student authors.
  // You must specify name.
  // You can specify: student mail, exam number
  authors: (),

  timespan: none,

  // Group name
  groupName: none,

  // Word count
  wordCount: none,

  // Font
  font: "STIX Two Text",
  fontSize: 10pt,

  // Page
  paperSize: "a4",
  columnsAmount: 2,
  firstLineIndentWidth: 1em,
  language: "da",
  region: "dk",
  paragraph-spacing: 1.5em,
  
  // Title page
  seperateTitlePage: false,

  // Toc
  useToc: false,
  seperateTocPage: false,
  
  // Bibliography
  bibliography-file: none,
  
  // Appendices
  appendices-file: none,

  // Is Thesis?
  thesis: false,
  mainSupervisor: none,
  coSupervisor: none,

  // Abstract
  abstract: none,
  seperateAbstractPage: false,
  seperateAbstractColumn: false,
  index-terms: (),
  
  // Report content
  body
) = {

  // Document metadata
  set document(title: title, author: authors.map(author => author.name))
  set par(first-line-indent: 1em)
  // Set body font
  set text(font: font, size: fontSize, lang: language, region: region)

  // Configure page
  set page(
    paper: paperSize,
    margin: if paperSize == "a4" {
      if columnsAmount > 1 {
        (x: 13mm, top: 19mm, bottom: 43mm)
      } else {
        (x: 20mm, top: 19mm, bottom: 43mm)
      }     
    } else {
      (
        x: (50pt / 216mm) * 100%,
        top: (55pt / 279mm) * 100%,
        bottom: (64pt / 279mm) * 100%,
      )
    },
    columns: 1,
    numbering: "1 / 1",
  )

  // Numbering of headings
  set heading(numbering: "I.A.1.")

  show heading.where(level: 1): head => {
    set heading(
    supplement: [Chapter]
  )
  }
  
  show heading: it => context{
      let levels = counter(heading).at(here())
      let deepest = if levels != () { levels.last() } else { 1 }
  
      set text(10pt, weight: 400)
      
      // Appendices title (special heading)
      if it.body == [Appendices] {
        set text(12pt)
        show: smallcaps
        set align(center)
        it.body
      }

      // Appendix content headings
      else if it.supplement == [Appendix] {
        set align(center)
        v(10pt, weak: true)
        numbering("A.", deepest)
        h(7pt, weak: true)
        it.body
      }
      
       // Level 1: Chapter style
       else if it.level == 1 {
         set text(12pt)
         show: smallcaps
         set align(left)
         v(25pt, weak: true)
         if it.numbering != none {
          numbering("I.", deepest)
          h(7pt, weak: true)
         }
         it.body
         v(13.75pt, weak: true)
      }
      
      // Level 2: Run-in section italic
      else if it.level == 2 {
        set par(first-line-indent: 0em)
        set align(left)
        set text(style: "italic")
        v(10pt, weak: true)
        if it.numbering != none {
          numbering("A.", deepest)
          h(7pt, weak: true)
        }
        it.body
        v(10pt, weak: true)
      }
      
      // Level 3+: Different run-ins
      else {
        h(1em)
        if it.level == 3 {
          numbering("1)", deepest)
          [ ]
        }
        it.body
        [: ]
      }
    }

    // Add margin to figures
    //set figure(placement: auto) // Change this to have image autoposition themselves (at either top or bottom)
    show figure: set block(spacing: 1.5em)
    set figure(
      placement: auto
    )

    show ref: it => {
      text(black)[#underline[#it]]
    }
    

  // Numbering and spacing of math
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 1.5em)

  // Configure appearance of equation references
  show ref: it => {
    if it.element != none and it.element.func() == math.equation {
      // Override equation references.
      link(it.element.location(), numbering(
        it.element.numbering,
        ..counter(math.equation).at(it.element.location())
      ))
    } else {
      // Other references as usual.
      it
    }
  }

  // Lists
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)
  
  // Content
  
  // Title
  set align(center)
  block(text(titleFontSize)[#title])

  // Course name
  if(course != none) {
    text(titleFontSize/3)[#course]
  }

  // Timespan working on the project
  if(timespan != none) {
    linebreak()
    text(titleFontSize/3)[#timespan]
  }

  // Authors
  for i in range(calc.ceil(authors.len() / 3)) { // Calculate and create rows
    let end = calc.min((i+1) * 3, authors.len()) // Calculate index of last author for current line
    let is-last = authors.len() == end // Boolean regarding if the line should only contain one author
    let slice = authors.slice(i * 3, end) // Get subset of authors containing authors for current line
    grid(
      columns: slice.len() * (1fr,),
      gutter: 12pt,
      ..slice.map(author => align(center, {
        text(11pt, author.name)
        if "examNumber" in author [
          \ #text(10pt, author.examNumber)
        ]
        if "deptName" in author [
          \ #text(10pt, style: "italic", author.deptName)
        ]
        if "organization" in author [
          \ #text(10pt, style: "italic", author.organization)
        ]
        if "mail" in author [
          \ #text(10pt, author.mail)
        ]
      }))
    )
    if not is-last {
      v(16pt, weak: true)
    }
  }

  // If thesis: Supervisors
  if thesis {
    if (coSupervisor == none){
      grid(
          columns: 1,
          gutter: 5cm,
          align(center, {
            text(10pt, [Main Supervisor])
            linebreak()
            text(12pt, mainSupervisor.fullName)
            //linebreak()
            //text(10pt, mainSupervisor.email)
          })
      )
    } else {
      grid(
        columns: 2,
        gutter: 5cm,
        align(center, {
          text(10pt, [Main Supervisor])
          linebreak()
          text(12pt, mainSupervisor.fullName)
          linebreak()
          text(10pt, mainSupervisor.email)
        }),
        align(center, {
          text(10pt, [Co-Supervisor])
          linebreak()
          text(12pt, coSupervisor.fullName)
          linebreak()
          text(10pt, coSupervisor.email)
        })
      )
    }
  }
  
  // Group name
  v(1cm, weak: true)
  
  if seperateTitlePage {
    pagebreak()
  }

  let abstractSection() = {
    if abstract != none [
      #set text(weight: 700)
      #h(1em) _Abstract_---#abstract
  
      #if index-terms != () [
        #h(1em)_Index terms_---#index-terms.join(", ")
      ]
      #v(2pt)
    ]
  }
  
  if seperateAbstractPage {
      abstractSection()
      pagebreak()
  }
  
 set align(left)
  show: columns.with(columnsAmount, gutter: 12pt)
  set par(justify: true, first-line-indent: firstLineIndentWidth)
    set par(spacing: paragraph-spacing)// Space between paragraphs
  if (seperateAbstractColumn and seperateAbstractPage != true){
      abstractSection()
      colbreak()
  } else if (seperateAbstractColumn != true and seperateAbstractPage != true){
    abstractSection()
  }

  if useToc {
    if seperateTocPage {
      
    }
      set par(first-line-indent: 0pt)

      show outline.entry.where(
        level: 1
      ): it => {
        v(10pt, weak: true)
        strong(it)
      }
      outline(
        title: [Table of Contents],
        indent: auto,
        depth: 2,
        target: heading.where(supplement: [Chapter]).or(heading.where(supplement: [Section]))
      )
      
      set par(first-line-indent: firstLineIndentWidth)
  
      if seperateTocPage {
        colbreak()
      } else {
        v(20pt)
      }
    }

  body

  // Display bibliography.
  if bibliography-file != none {
    colbreak()
    show bibliography: set text(8pt)
    bibliography(bibliography-file, title: "References", style: "apa")
  }

  // Appendix
  if appendices-file != none {
  colbreak()
  heading("Appendices", numbering: none)
  
  counter(heading).update(0)

  set heading(
    supplement: [Appendix],
    numbering: "A"
  )
  
  include(appendices-file)
  }
  
  outline(
    target: heading.where(supplement: [Appendix]),
    title: [Appendices],
    indent: auto
  )
}