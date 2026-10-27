// Shared by the general and appendix outlines.
#let chapter-outline-entry(it) = context {
  import "info.typ"
  let typeface = info.font.get()
  // Classify by semantic role, not absolute depth: front/back matter
  // chapters stay at level 1 even when main-matter chapters are level 2.
  let el = it.element
  let is-part = el.supplement == [Parte]
  let is-chapter = el.supplement in ([Capítulo], [Anexo])
  if is-part or is-chapter {
    set block(spacing: if is-part { 1.5em } else { 1.3em })
    set text(
      font: if is-part { typeface.part.font } else { typeface.chapter.font },
      size: if is-part { 1.2em } else { 1.1em },
      weight: if is-part { 700 } else { 600 },
      tracking: 0.025em,
    )
    link(el.location(), block(grid(
      columns: (auto, 1fr, auto), column-gutter: 0.5em,
      align: (left, left, right + horizon),
      {
        if el.numbering != none {
          smallcaps(el.supplement)
          sym.space
        }
        it.prefix()
      },
      if is-part { upper(it.body()) } else { smallcaps(it.body()) },
      text(it.page(), number-width: "tabular", number-type: "lining"),
    )))
  } else {
    it
  }

}

#let general-outline = context {
  import "info.typ"

  let multi-part = info.multi-part.get()

  show outline.entry: chapter-outline-entry

  outline(
    title: [Índice general],
    depth: if multi-part { 5 } else { 4 },
    indent: n => if multi-part {
      if n == 0 or n == 1 or n == 2 { 0em } else if n == 3 { 0.75em } else { n * 0.5em }
    } else {
      if n == 0 or n == 1 { 0em } else if n == 2 { 0.75em } else { n * 0.5em }
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
    outline(title: [Índice de anexos], target: heading.where(
      supplement: [Anexo], level: 1, outlined: true,
    ))
  }
}

// Genera todos los índices del documento en su respectivo orden,
#let all-outlines = context {
  import "main-matter.typ": chapter-page
  show heading.where(level: 1): it => smallcaps(chapter-page(it))
  show outline: set heading(level: 1)
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

