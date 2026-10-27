#let chapter-counter = counter("chapter")

#let chapter-page(it) = context {
  import "info.typ"

  let typeface = info.font.get()
  let font-family = info.font-family.get()
  if it.numbering != none and it.outlined == true {
    chapter-counter.step()
  }
  // Art. 143: Inicio y conclusión del capítulo
  // Se recomienda que cada capítulo comience en hoja aparte y que cada uno de ellos incluya un párrafo introductorio que presente su organización e indique al lector cuál es el objetivo específico del mismo.
  // Igualmente, al terminar cada capítulo es aconsejable redactar un párrafo que contenga un pequeño resumen de lo tratado e indique además la relación del capítulo que termina con el que empieza a continuación.
  pagebreak(weak: true)
  set par(justify: false, leading: 1.25em - 0.75em)
  set align(right)
  set block(sticky: false)
  set text(tracking: 0.05em)

  if it.numbering != none and it.outlined == true [
    #set text(
      size: 2.5em,
      fill: gray.darken(40%),
    )
    #it.supplement
    #text(
      size: 1.25em,
      counter(heading).display(it.numbering),
    )
  ]

  block(
    width: 100%,
    stroke: (y: 1pt),
    inset: 1.5em,
    spacing: 2em,
    text(
      size: 2em,
      it.body,
    ),
  )
}

#let part-page(it) = context {
  import "lib/info.typ"
  pagebreak(weak: true)
  set par(justify: false)
  set page(numbering: none, header: none)
  let typeface = info.font.get()

  set align(center)

  v(0.5fr)

  text(
    size: 1.5em,
    weight: 500,
    tracking: 0.05em,
    upper(it.supplement),
  )

  v(1em)

  if it.numbering != none and it.outlined == true {
    text(
      ..typeface.part,
      size: 3.5em,
      weight: "black",
    )[#counter(heading).display(it.numbering)]

    v(1em)
  }

  text(
    size: 2.5em,
    weight: "bold",
    tracking: 0.1em,
    upper(it.body),
  )

  v(1fr)
}



/// Prepara el documento para el contenido principal.
#let main-matter(body) = context {
  import "@preview/hydra:0.6.3": hydra
  import "info.typ"

  let typeface = info.font.get()
  let font-family = info.font-family.get()
  let multi-part = info.multi-part.get()
  let chapter-level = if multi-part { 2 } else { 1 }
  let section-level = chapter-level + 1
  let paragraph-level = section-level + 3

  set page(
    numbering: "1",
    header: context hydra(
      2,
      display: (
        _,
        it,
      ) => text(
        font: typeface.chapter.font,
        tracking: 0.2em,
        fill: gray.darken(40%),
        weight: "bold",
        upper(it.body),
      ),
    ),
  )

  set text(
    lang: "es",
    region: "bo",
    ..typeface.text,
  )

  set par(
    leading: 1.25em,
    spacing: 1.5em,
    justify: true,
    justification-limits: (
      spacing: (min: 75%, max: 130%),
      tracking: (min: -0.008em, max: 0.015em),
    ),
    first-line-indent: (
      amount: 0in,
      all: true,
    ),
  )

  set math.equation(
    numbering: "(1)",
    supplement: [Fórmula],
  )

  show math.equation: set text(font: typeface.math.font)

  set figure.caption(separator: parbreak(), position: top)
  show figure: set align(left)
  show figure.where(kind: image): set block(breakable: false, sticky: true)
  show figure.where(kind: table): set block(breakable: true, sticky: false)
  show table: set text(size: typeface.text.size - (1 / 6 * 1em))
  show table: set par(
    spacing: 1.5em - 0.5em,
    leading: 1.25em - 0.25em,
  )
  show raw: set text(font: typeface.mono.font, size: typeface.text.size - (1 / 12 * 1em))
  show figure.where(kind: math.equation): set figure(supplement: [Fórmula])
  set figure(
    gap: 1.25em,
    placement: none,
  )

  show figure.caption: set align(left)
  show figure.caption: set text(font: typeface.caption.font)
  show figure.caption: set par(first-line-indent: 0em)
  show figure.caption: it => {
    strong[#it.supplement #context it.counter.display(it.numbering)]
    it.separator
    emph(it.body)
  }

  show quote.where(block: true): set block(spacing: 1.5em)
  show quote: set text(style: "italic")

  // TODO: Move this as an APA quote function and use wordometer
  show quote: it => {
    let quote-text-words = to-string(it.body).split(regex("\\s+")).filter(word => word != "").len()

    if quote-text-words < 40 {
      ["#it.body" ]

      if (type(it.attribution) == label) {
        cite(it.attribution)
      } else if (
        type(it.attribution) == str or type(it.attribution) == content
      ) {
        it.attribution
      }
    } else {
      block(inset: (left: 0.5in))[
        #set par(first-line-indent: 0.5in)
        #it.body
        #if (type(it.attribution) == label) {
          cite(it.attribution)
        } else if (type(it.attribution) == str or type(it.attribution) == content) {
          it.attribution
        }
      ]
    }
  }

  // Art. 144: Encabezamientos
  // Todo escrito deberá incluir encabezados para destacar los subtemas de la investigación. Para ello se deberá considerar un espacio adicional antes y después de cada encabezado. Se podrá remarcar los encabezados con negrillas, en cuyo caso solo se necesita un espacio antes del encabezado.
  // Existen encabezados principales y secundarios, los cuales deberán estar escritos y ubicados apropiadamente, según una escala jerárquica sistemática durante todo el desarrollo del texto. Para señalar los encabezados podrá utilizarse el sistema decimal o alfanumérico.
  set heading(
    numbering: (..args) => {
      set text(
        stylistic-set: if font-family == "Alegreya" or font-family == "Piazzolla" { 1 } else { () },
        number-type: "lining",
        number-width: "tabular",
      )

      if multi-part {
        if args.pos().len() == 1 {
          // Level 1: Roman numerals for Parts.
          numbering("I", ..args)
        } else if args.pos().len() == 2 {
          // Level 2: Use the chapter state counter and increment it.
          // chapter-counter.display("I")
          numbering("I", chapter-counter.get().first())
        } else if args.pos().len() == 3 or args.pos().len() == 4 or args.pos().len() == 5 {
          // Level 3+: Use the chapter number followed by the position within that chapter.
          numbering(
            "1.1.",
            // ..chapter-counter.get(),
            ..args.pos().slice(2),
          )
        } else {
          // For the rest of headings, no
          none
        }
      } else {
        if args.pos().len() == 1 {
          // Level 1: Use the chapter state counter and increment it.
          numbering("I", chapter-counter.get().first())
        } else if args.pos().len() == 2 or args.pos().len() == 3 or args.pos().len() == 4 {
          // Level 2+: Use the chapter number followed by the position within that chapter.
          numbering(
            "1.1.",
            // ..chapter-counter.get(),
            ..args.pos().slice(1),
          )
        } else {
          // For the rest of headings, no
          none
        }
      }
    },
  )

  show heading: set text(size: typeface.text.size)
  show heading: set block(spacing: 1.5em)

  show heading.where(level: chapter-level): set text(
    font: typeface.chapter.font,
  )

  show heading.where(level: chapter-level): set heading(
    supplement: [Capítulo],
  )
  show heading.where(level: 1): set heading(
    supplement: if multi-part [Parte] else [Capítulo],
  )

  show heading.where(level: 2): set heading(
    supplement: if multi-part [Capítulo] else [Sección],
  )

  show heading.where(level: 1): it => if multi-part {
    part-page(it)
  } else {
    chapter-page(it)
  }

  show heading.where(level: 2): it => if multi-part {
    chapter-page(it)
  } else {
    it
  }

  show heading.where(level: chapter-level): smallcaps
  show heading.where(level: section-level): set align(center)
  show heading.where(level: section-level + 2): set text(weight: "bold")
  show heading.where(level: section-level + 3): set text(style: "italic")
  show heading.where(level: paragraph-level): it => box[#it.body.]
  show heading.where(level: paragraph-level + 1): it => box(emph[#it.body.])

  show figure.where(kind: raw): set figure(placement: none)
  show figure.where(kind: raw): set block(breakable: true, sticky: false)
  show figure.where(kind: raw): set raw(block: true)
  show figure.where(kind: raw): set align(left)

  // La numeración de páginas no es correlativa entre romana y arábiga, por lo que se reinicia el contador de páginas al cambiar a la numeración arábiga.
  counter(page).update(1)

  body
}
