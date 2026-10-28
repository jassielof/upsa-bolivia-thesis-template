#let chapter-outline-entry(it) = context {
  import "info.typ"

  let typeface = info.font.get()
  let font-family = info.font-family.get()
  // Classify by semantic role, not absolute depth: front/back matter
  // chapters stay at level 1 even when main-matter chapters are level 2.

  let el = it.element

  let is-part = el.supplement == [Parte]
  let is-chapter = el.supplement in ([Capítulo], [Anexo])

  if is-part or is-chapter {
    set block(spacing: if is-part { 1.5em } else { 1.3em })

    set text(
      font: if is-part { typeface.text.font } else { typeface.display },
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
        typeface.display
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
      // Native inline layout keeps the prefix and first body line on the
      // same baseline, independently of the font's metrics.
      it.inner(),
    ))
  }
}

#let general-outline = context {
  import "info.typ"

  let multi-part = info.multi-part.get()

  show outline.entry: chapter-outline-entry

  let target = heading.where(outlined: true)
  let appendices = query(heading.where(level: 1, supplement: [Anexo]))
  if appendices.len() > 0 {
    target = target.before(appendices.first().location(), inclusive: false)
  }

  outline(
    title: [Índice general],
    depth: if multi-part { 5 } else { 4 },
    target: target,
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
  let appendices = query(heading.where(level: 1, supplement: [Anexo]))
  if appendices.len() > 0 {
    outline(
      title: [Índice de anexos],
      depth: 4,
      target: heading.where(outlined: true).after(
        appendices.first().location(), inclusive: true,
      ),
      indent: n => if n <= 1 { 0em } else if n == 2 { 0.5em } else { n * 0.25em },
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

