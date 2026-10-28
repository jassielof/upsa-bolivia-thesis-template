#import "cite.typ": to-string

// Apply the same logical hierarchy at each matter's heading offset.
#let heading-supplements(body, offset: 0, appendix: false) = {
  show heading.where(level: offset + 1): set heading(
    supplement: if appendix { [Anexo] } else { [Capítulo] },
  )
  show heading.where(level: offset + 2): set heading(supplement: [Sección])
  show heading.where(level: offset + 3): set heading(supplement: [Subsección])
  show heading.where(level: offset + 4): set heading(supplement: [Subsubsección])
  show heading.where(level: offset + 5): set heading(supplement: [Párrafo])
  show heading.where(level: offset + 6): set heading(supplement: [Subpárrafo])
  body
}

// Show-set styling follows each matter's offset without replacing headings.
#let heading-styles(body, offset: 0) = context {
  import "info.typ"
  let typeface = info.font.get()
  show heading: set text(weight: "bold", style: "normal")
  show heading.where(level: offset + 1): set text(font: typeface.display)
  show heading.where(level: offset + 2): set align(center)
  show heading.where(level: offset + 4): set text(weight: "bold", style: "italic")
  show heading.where(level: offset + 6): set text(weight: "bold", style: "italic")
  // Match the matter's resolved levels before supplements are assigned.
  show heading
    .where(level: offset + 5)
    .or(
      heading.where(level: offset + 6),
    ): it => box[#it.body.]
  body
}

#let chapter-page(it, alignment: left) = context {
  // Art. 143: Inicio y conclusión del capítulo
  // Se recomienda que cada capítulo comience en hoja aparte y que cada uno de ellos incluya un párrafo introductorio que presente su organización e indique al lector cuál es el objetivo específico del mismo.
  // Igualmente, al terminar cada capítulo es aconsejable redactar un párrafo que contenga un pequeño resumen de lo tratado e indique además la relación del capítulo que termina con el que empieza a continuación.
  pagebreak(weak: true)
  set par(justify: false, leading: 1.25em - 0.75em)
  set align(alignment)
  // Keep the complete heading together and attached to the following content.
  block(width: 100%, breakable: false, sticky: true, {
    set text(tracking: 0.05em, number-type: "lining", number-width: "tabular")

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
      inset: (y: 1.5em, x: 0.5em),
      spacing: 2em,
      text(
        size: 2em,
        it.body,
      ),
    )
  })
}

#let part-page(it) = context {
  import "info.typ"
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
      font: typeface.text.font,
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
  let multi-part = info.multi-part.get()
  let chapter-level = if multi-part { 2 } else { 1 }

  set page(
    numbering: "1",
    header: context hydra(
      chapter-level,
      display: (
        _,
        it,
      ) => text(
        font: typeface.display,
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
  show figure.caption: set text(font: typeface.text.font)
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
          linebreak()
          text(style: "normal", it.attribution)
        }
      ]
    }
  }

  // Art. 144: Encabezamientos
  // Todo escrito deberá incluir encabezados para destacar los subtemas de la investigación. Para ello se deberá considerar un espacio adicional antes y después de cada encabezado. Se podrá remarcar los encabezados con negrillas, en cuyo caso solo se necesita un espacio antes del encabezado.
  // Existen encabezados principales y secundarios, los cuales deberán estar escritos y ubicados apropiadamente, según una escala jerárquica sistemática durante todo el desarrollo del texto. Para señalar los encabezados podrá utilizarse el sistema decimal o alfanumérico.
  // Markup depth stays independent of the optional part level.
  set heading(offset: chapter-level - 1, numbering: (..args) => {
    let pos = args.pos().slice(chapter-level - 1)
    if pos.len() == 1 {
      numbering("1", ..pos)
    } else if pos.len() <= 4 {
      numbering("1.1.", ..pos)
    }
  })

  show heading: set text(
    size: typeface.text.size,
    number-type: "lining",
    number-width: "tabular",
  )
  show heading: set block(spacing: 1.5em)

  show: heading-supplements.with(offset: chapter-level - 1)

  show: heading-styles.with(offset: chapter-level - 1)

  // Match markup depth directly: supplements are assigned by show-set rules
  // and are not available yet when a show-rule selector is matched.
  show heading.where(depth: 1): it => {
    if it.supplement == [Parte] {
      part-page(it)
    } else {
      smallcaps(chapter-page(it))
    }
  }

  show figure.where(kind: raw): set figure(placement: none)
  show figure.where(kind: raw): set block(breakable: true, sticky: false)
  show figure.where(kind: raw): set raw(block: true)
  show figure.where(kind: raw): set align(left)

  // La numeración de páginas no es correlativa entre romana y arábiga, por lo que se reinicia el contador de páginas al cambiar a la numeración arábiga.
  counter(heading).update(0)
  counter(page).update(1)

  body
}

#let part(body) = context {
  import "info.typ"

  assert(info.multi-part.get(), message: "El documento no está configurado para múltiples partes.")

  // A part advances the outer counter, but preserves the continuous chapter
  // number. The native heading counter remains the sole numbering source.
  let previous = counter(heading).get()
  heading(level: 1, offset: 0, numbering: "I", body, supplement: [Parte])
  counter(heading).update((previous.first() + 1, previous.at(1, default: 0)))
  pagebreak(weak: true)
}
