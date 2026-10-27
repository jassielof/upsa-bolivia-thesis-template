// TODO: Fix outline if it's not multi-part
#let general-outline = context {
  import "info.typ"

  let typeface = info.font.get()
  let font-family = info.font-family.get()
  let multi-part = info.multi-part.get()
  let chapter-level = if multi-part { 2 } else { 1 }
  let section-level = chapter-level + 1
  let paragraph-level = section-level + 3

  show outline.entry.where(level: 1): set block(spacing: 1.5em) if multi-part
  show outline.entry.where(level: chapter-level): set block(spacing: 1.3em)

  show outline.entry.where(level: 1): set text(
    font: typeface.part.font,
    size: 1.2em,
    weight: 700,
    tracking: 0.05em,
  ) if multi-part

  show outline.entry.where(level: 1): it => if multi-part {
    link(
      it.element.location(),
      it.indented(
        {
          if it.element.numbering != none {
            smallcaps(it.element.supplement)
            sym.space
          }
          it.prefix()
        },
        box(grid(
          columns: (1fr, auto),
          align: (left, right + horizon),
          upper(it.body()), it.page(),
        )),
      ),
    )
  } else {
    link(
      it.element.location(),
      it.indented(
        {
          if it.element.numbering != none {
            smallcaps(it.element.supplement)
            sym.space
          }
          it.prefix()
        },
        box(grid(
          columns: (1fr, auto),
          align: (left, right + horizon),
          smallcaps(it.body()),
          text(
            it.page(),
            number-width: "tabular",
            number-type: "lining",
            stylistic-set: if font-family == "Alegreya" or font-family == "Piazzolla" { 1 } else { () },
          ),
        )),
      ),
    )
  }

  show outline.entry.where(level: chapter-level): set text(
    weight: 600,
    size: 1.1em,
    font: typeface.chapter.font,
    tracking: 0.025em,
  )

  show outline.entry.where(level: section-level): set text(weight: 500)

  show outline.entry.where(level: section-level + 1): set text(style: "italic")

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
  if (query(heading.where(supplement: [Anexo])).len() != 0) {
    outline(title: [Índice de anexos], target: selector(heading.where(supplement: [Anexo])))
  }
}

// Genera todos los índices del documento en su respectivo orden,
#let all-outlines = context {
  show outline: set heading(level: 1)
  show outline.entry: set block(spacing: 0.75em)
  show outline.entry: set par(leading: 0.65em)

  general-outline
  figure-outline
  table-outline
  math-outline
  listing-outline
  appendix-outline
}

