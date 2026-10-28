#let chapter-outline-entry(it) = context {
  import "info.typ"

  let typeface = info.font.get()
  let font-family = info.font-family.get()
  // Classify by semantic role, not absolute depth: front/back matter
  // chapters stay at level 1 even when main-matter chapters are level 2.

  let el = it.element

  let is-part = el.supplement == [Parte]
  let is-chapter = el.supplement in ([Capítulo], [Anexo])

  if (
    is-part
      or is-chapter
      // TODO: there must be a better way to filter front and back matter unnumbered chapters without depending on its body.
      or el.body == [Resumen]
      or el.body == [Abstracto]
      or el.body == [Resumen ejecutivo]
      or el.body == [Referencias]
  ) {
    set block(spacing: if is-part { 1.5em } else { 1.3em })

    set text(
      font: if is-part { typeface.part.font } else { typeface.chapter.font },
      size: if is-part { 1.5em } else { 1.25em },
      weight: if is-part { 700 } else { 600 },
      tracking: 0.025em,
    )

    link(el.location(), block(grid(
      columns: (auto, 1fr, auto),
      column-gutter: (0em, 0.25em),
      align: (left, left, right + horizon),
      {
        if el.numbering != none {
          if is-part {
            upper(el.supplement)
          } else {
            smallcaps(el.supplement)
          }
          sym.space
        }
        {
          set text(
            number-width: "tabular",
            number-type: "lining",
            stylistic-set: if font-family == "Alegreya" or font-family == "Piazzolla" { 1 } else { () },
          ) if el.supplement != [Anexo]
          it.prefix()
        }
      },
      {
        if el.numbering != none {
          h(0.5em)
        }
        if is-part {
          upper(it.body())
        } else {
          smallcaps(it.body())
        }
      },
      text(
        it.page(),
        number-width: "tabular",
        number-type: "lining",
        stylistic-set: if font-family == "Alegreya" or font-family == "Piazzolla" { 1 } else { () },
      ),
    )))
  } else {
    set text(
      weight: if el.supplement == [Sección] {
        "semibold"
      } else if el.supplement == [Subsección] {
        "medium"
      } else {
        "regular"
      },
      font: if el.supplement == [Sección] {
        typeface.section.font
      } else {
        typeface.text.font
      },
      style: if el.supplement == [Subsubsección] {
        "italic"
      } else {
        "normal"
      },
    )

    link(el.location(), it.indented(
      text(
        number-width: "tabular",
        number-type: "lining",
        it.prefix(),
      ),
      box(
        inset: 0pt,
        outset: 0pt,
        grid(
          columns: (1fr, auto),
          column-gutter: 0.25em,
          align: (left, right + bottom),
          {
            it.body()
            sym.space
            box(width: 1fr, repeat(gap: 0.1em, justify: true)[.])
          },
          text(
            it.page(),
            number-width: "tabular",
            number-type: "lining",
            stylistic-set: if font-family == "Alegreya" or font-family == "Piazzolla" { 1 } else { () },
          ),
        ),
      ),
    ))
  }
}

#let general-outline = context {
  import "info.typ"

  let multi-part = info.multi-part.get()

  show outline.entry: chapter-outline-entry

  outline(
    title: [Índice general],
    depth: if multi-part { 5 } else { 4 },
    target: selector.or(
      ..query(heading).filter(it => it.supplement != [Anexo]).map(it => it.func().where(supplement: it.supplement)),
    ),
    indent: n => if multi-part {
      if n == 0 or n == 1 or n == 2 { 0em } else if n == 3 { 0.5em } else { n * 0.25em }
    } else {
      if n == 0 or n == 1 { 0em } else if n == 2 { 0.5em } else { n * 0.25em }
    },
  )
}

// Genera el índice de tablas si existen.
#let table-outline = context {
  if (counter(figure.where(kind: table)).final().at(0) != 0) {
    outline(title: [Índice de tablas], target: figure.where(kind: table))
  }
}

// Genera el índice de figuras (imágenes) si existen.
#let figure-outline = context {
  if (counter(figure.where(kind: image)).final().at(0) != 0) {
    outline(title: [Índice de figuras], target: figure.where(kind: image))
  }
}

// Genera el índice de listados (código fuente) si existen.
#let listing-outline = context {
  if (counter(figure.where(kind: raw)).final().at(0) != 0) {
    outline(title: [Índice de listados], target: figure.where(kind: raw))
  }
}

// Genera el índice de fórmulas (o expresiones matemáticas) si existen.
#let math-outline = context {
  if (counter(figure.where(kind: math.equation)).final().at(0) != 0) {
    outline(title: [Índice de fórmulas], target: figure.where(kind: math.equation))
  }
}

// Genera el índice de anexos si existen.
#let appendix-outline = context {
  show outline.entry: chapter-outline-entry
  if (query(heading.where(supplement: [Anexo])).len() != 0) {
    outline(
      title: [Índice de anexos],
      target: heading.where(
        supplement: [Anexo],
        level: 1,
        outlined: true,
      ),
    )
  }
}

// Genera todos los índices del documento en su respectivo orden,
#let all-outlines = context {
  import "main-matter.typ": chapter-page
  show outline.entry: set text(number-type: "lining", number-width: "tabular")
  show outline.entry: set block(spacing: 0.75em)
  show outline.entry: set par(leading: 0.65em)

  general-outline
  figure-outline
  table-outline
  math-outline
  listing-outline
  appendix-outline
}

