#import "lib/info.typ": print-layout as print-layout-state
#import "lib/book.typ": front-cover as book-front-cover, spine-cover as book-spine-cover
#import "lib/biblatex.typ": generate as get-biblatex
#import "lib/abstract.typ": bime as bime-abstract
#import "lib/csl-styles.typ"

// Define la configuración general de la plantilla.
#let settings(
  /// Nombre del estudiante autor del trabajo de grado.
  author-name: none,
  /// Correo electrónico del estudiante autor del trabajo de grado.
  author-email: none,
  /// Número de registro del estudiante autor del trabajo de grado.
  author-university-id: none,
  /// Afiliación factultativa institucional.
  faculty: none,
  /// Acroónimo de la facultad.
  faculty-acronym: none,
  /// Nivel del grado académico a optar.
  degree-level: none,
  /// Programa académico (carrera o especialidad) del grado a optar.
  degree-program: none,
  /// Nombre del/os asesor/es o guía/s del trabajo de grado.
  supervisor: none,
  /// Título del trabajo de grado.
  work-title: none,
  /// Abstracto o resumen del trabajo de grado.
  abstract: none,
  /// Fecha de presentación del trabajo de grado.
  date: none,
  /// Palabras clave del trabajo de grado.
  keywords: none,
  /// Modalidad del trabajo de grado (por ejemplo: Proyecto de Grado, Tesis, Trabajo Dirigido, etc.)
  modality: none,
  /// Abreviatura de la modalidad del trabajo de grado (por ejemplo: PG, TL, TD, etc.)
  modality-acronym: none,
  /// El tipo de letra a usar.
  typeface: "Reforma",
  /// El formato de impresión del documento.
  ///
  /// - "screen" para PDF (márgenes simétricos).
  /// - "duplex" para impresión a doble cara.
  /// - "simplex" para impresión a una cara.
  print-layout: "screen",
  /// El tamaño de papel a usar. Por defecto es "us-letter" (carta), pero puede ser cambiado a "a4" (A4) si se desea.
  paper-size: "us-letter",
  /// Si el documento necesita ser dividido en partes (por ejemplo, tesis de doctorado), en lugar de solo capítulos.
  multi-part: false,
  /// Tomos o volúmenes del trabajo de grado, si aplica. Por defecto es "none".
  volumes: none,
  body,
) = context {
  import "lib/info.typ"

  info.supervisor.update(supervisor)
  info.degree-program.update(degree-program)
  info.degree-level.update(degree-level)
  assert(
    abstract != none,
    message: "El resumen o abstracto del trabajo de grado (abstract) es obligatorio.",
  )
  info.work-abstract.update(abstract)

  assert(
    faculty != none,
    message: "La facultad (faculty) es obligatoria.",
  )
  info.faculty.update(faculty)

  assert(
    faculty-acronym != none,
    message: "El acrónimo de la facultad (faculty-acronym) es obligatorio.",
  )
  info.faculty-short.update(faculty-acronym)

  assert(
    modality != none,
    message: "La modalidad del trabajo de grado (modality) es obligatoria.",
  )
  info.thesis-modality.update(modality)

  assert(
    modality-acronym != none,
    message: "El acrónimo de la modalidad del trabajo de grado (modality-acronym) es obligatorio.",
  )
  info.thesis-modality-short.update(modality-acronym)

  info.multi-part.update(multi-part)
  info.work-date.update(date)
  info.volumes.update(volumes)

  let paper-sizes = ("us-letter", "a4")
  assert(
    paper-size in paper-sizes,
    message: "El tamaño de papel (paper-size) debe ser uno de los siguientes: "
      + paper-sizes.join(", ", last: " o ")
      + ".",
  )
  info.paper-size.update(paper-size)

  let typeface-options = (
    "New Computer Modern",
    "IBM Plex",
    "Reforma",
    "Alegreya",
    "Adobe Source",
    "TeX Gyre",
    "Andada",
    "Piazzolla",
  )
  assert(
    typeface in typeface-options,
    message: "El tipo de letra (typeface) debe ser uno de los siguientes: "
      + typeface-options.join(", ", last: " o ")
      + ".",
  )

  import "lib/typeface.typ": get as get-font
  info.font.update(get-font(typeface))
  info.font-family.update(typeface)

  let print-layout-options = ("screen", "duplex", "simplex")
  let print-layout = print-layout-state.final()
  assert(
    print-layout in print-layout-options,
    message: "El formato de impresión (print-layout) debe ser: " + print-layout-options.join(", ", last: " o ") + ".",
  )
  print-layout-state.update(print-layout)

  assert(
    author-name != none,
    message: "El nombre del autor (author-name) es obligatorio.",
  )
  assert(
    type(author-name) == str,
    message: "El nombre del autor (author-name) debe ser un texto (str), no: " + repr(type(author-name)) + ".",
  )
  info.author-name.update(author-name)

  assert(
    author-email != none,
    message: "El correo electrónico del autor (author-email) es obligatorio.",
  )
  info.author-email.update(author-email)

  assert(
    author-university-id != none,
    message: "El número de registro del autor (author-university-id) es obligatorio.",
  )
  info.author-uni-id.update(author-university-id)

  assert(
    work-title != none,
    message: "El título del trabajo de grado (work-title) es obligatorio.",
  )
  info.work-title.update(work-title)

  info.keywords.update(keywords)

  set document(
    title: work-title,
    description: abstract,
    author: author-name,
    keywords: keywords,
  )

  set page(
    // Art. 142: Márgenes
    // Los márgenes serán 4 cm para el izquierdo, y 2.5 cm para el resto (incluye la numeración de página [por defecto en Typst])
    margin: if print-layout == "screen" and target() == "paged" {
      1in
    } else {
      (
        ..if print-layout == "duplex" { (inside: 4cm) } else { (left: 4cm) },
        rest: 1in,
      )
    },
    // Art. 137: Tipo de hoja
    // El tipo de hoja será papel bond blanco, de 75 g, tamaño carta (us-letter) en posición vertical.
    paper: paper-size,
    // Art. 138: Numeración
    // La numeración de las páginas será arábiga correlativa, sin límites, en la esquina inferior derecha, para el desarrollo del trabajo; y romana con minúscula para la presentación, prólogo e índice/s.
    number-align: bottom + right,
  )

  body
}

#let general-outline = context {
  import "lib/info.typ"
  let typeface = info.font.get()

  show outline.entry.where(level: 1): set block(spacing: 1.5em)
  show outline.entry.where(level: 2): set block(spacing: 1.3em)
  show outline.entry.where(level: 1): set text(
    font: typeface.title.font,
    size: 1.2em,
    weight: 700,
    tracking: 0.05em,
  )
  show outline.entry.where(level: 1): it => link(
    it.element.location(),
    it.indented(
      {
        upper(it.element.supplement)
        sym.space
        it.prefix()
      },
      box(grid(
        columns: (1fr, auto),
        align: (left, right + horizon),
        upper(it.body()), it.page(),
      )),
    ),
  )
  show outline.entry.where(level: 2): set text(
    weight: 600,
    size: 1.1em,
    font: typeface.title.font,
    tracking: 0.025em,
  )
  show outline.entry.where(level: 2): it => link(
    it.element.location(),
    it.indented(
      {
        smallcaps(it.element.supplement)
        sym.space
        it.prefix()
      },
      box(grid(
        columns: (1fr, auto),
        align: (left, right + horizon),
        smallcaps(it.body()), it.page(),
      )),
    ),
  )
  show outline.entry.where(level: 3): set text(weight: 500)
  show outline.entry.where(level: 4): set text(style: "italic")
  outline(
    title: [Índice General],
    depth: 5, // Incluye partes, capítulos, secciones, subsecciones y subsubsecciones. Párrafos y demás se omiten.
    indent: n => {
      if n == 0 or n == 1 or n == 2 { 0em } else if n == 3 { 0.75em } else { n * 0.5em }
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

// Genera la página de agradecimientos del documento, si aplica.
#let acknowledgements-page(body) = {
  if body == none {
    return
  }

  body
}

// Genera la página dedicatoria del documento, si aplica.
//
// Se recomienda que la dedicatoria sea breve y concisa (1 página).
#let dedication-page(body) = {
  if body == none {
    return
  }

  body
}

#let chapter-counter = counter("chapter")

#let chapter-page(it) = context {
  import "lib/info.typ"

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

// Genera las páginas preliminares del documento, incluyendo carátula, índices, abstracto, etc.
#let front-matter(
  problem: none,
  objective: none,
  executive-summary: none,
  dedication: none,
  abstract-content: outline(
    target: heading.where(
      outlined: true,
      supplement: [Capítulo],
    ),
    indent: 0em,
    title: [Contenido],
  ),
  acknowledgements: none,
) = context {
  import "lib/info.typ"
  import "lib/abstract.typ"
  import "lib/title.typ": title-page

  title-page()

  let typeface = info.font.get()
  let font-family = info.font-family.get()

  set text(
    ..typeface.text,
    lang: "es",
    region: "bo",
  )

  show heading: set text(size: typeface.text.size)
  show heading: set block(spacing: 1.5em)

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

  show table: set text(size: typeface.text.size - (1 / 6 * 1em), hyphenate: true)
  show table: set par(
    spacing: 1.5em - 0.5em,
    leading: 1.25em - 0.25em,
    justify: true,
  )

  dedication-page(dedication)
  acknowledgements-page(acknowledgements)

  counter(page).update(1)
  set page(numbering: "i", footer: context {
    set text(stylistic-set: 1) if font-family == "Alegreya" or font-family == "Piazzolla"
    set align(right)
    lower(counter(page).display("i"))
  })

  show heading.where(level: 1): set heading(
    supplement: [Capítulo],
  )

  show heading.where(level: 1): it => chapter-page(it)
  show heading.where(level: 1): smallcaps
  show heading.where(level: 2): set align(center)

  abstract.faculty(
    problem: problem,
    objective: objective,
    content-index: abstract-content,
  )

  {
    set heading(numbering: none)

    if info.work-abstract.get() != none {
      pagebreak(weak: true)
      heading[Resumen]
      info.work-abstract.get()
    }

    if executive-summary != none {
      pagebreak(weak: true)
      heading[Resumen ejecutivo]
      executive-summary
    }
  }

  all-outlines
}

/// Prepara el documento para el contenido principal.
#let main-matter(body) = context {
  import "@preview/hydra:0.6.3": hydra
  import "lib/info.typ"

  let typeface = info.font.get()
  let font-family = info.font-family.get()
  let multi-part = info.multi-part.get()
  let chapter-level = if multi-part { 2 } else { 1 }
  let section-level = chapter-level + 1

  set page(
    numbering: "1",
    header: context hydra(
      2,
      display: (
        _,
        it,
      ) => text(
        font: typeface.title.font,
        tracking: 0.2em,
        fill: gray.darken(40%),
        weight: "bold",
        upper(it.body),
      ),
    ),
  )

  set text(
    size: typeface.text.size,
    font: typeface.text.font,
    lang: "es",
    region: "bo",
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
    },
  )

  show heading: set text(size: typeface.section.size, font: typeface.section.font)
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

  // TODO: Add support for multi-part thesis, as it's usualy for thesis to just be multi-chapter, but not multi-part, so they must default to multi-chapter, with a boolean parameter to toggle multi-part thesis, converting first level headings to parts and second to chapters.
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

  show heading.where(level: section-level): smallcaps
  show heading.where(level: section-level + 1): set align(center)
  show heading.where(level: section-level + 3): emph
  show heading.where(level: section-level + 4): it => [#it.body.]
  show heading.where(level: section-level + 5): it => [_#it.body._]

  show figure.where(kind: raw): set figure(placement: none)
  show figure.where(kind: raw): set block(breakable: true, sticky: false)
  show figure.where(kind: raw): set raw(block: true)
  show figure.where(kind: raw): set align(left)

  // La numeración de páginas no es correlativa entre romana y arábiga, por lo que se reinicia el contador de páginas al cambiar a la numeración arábiga.
  counter(page).update(1)

  body
}

// Prepara el documento para las páginas finales, incluyendo anexos, glosario, etc.
#let back-matter(body) = context {
  import "lib/info.typ"
  let is-proposal = info.proposal.get()

  // Art 147: Citas y notas
  // Las citas y notas bibliográficas deberán ceñirse al estilo de referenciación bibliográfica establecido por la Facultad.
  show bibliography: bib-it => {
    show block: block-it => context {
      // if it body is auto or styled()
      if block-it.body == auto or block-it.body.func() == text(fill: red)[].func() {
        block-it
        // if its body isn't sequence(), for example: pdf-marker-tag
      } else if block-it.body.func() != [].func() {
        par(block-it.body)
      } else {
        par(block-it.body)
      }
    }

    bib-it
  }

  set bibliography(style: "apa", full: false, title: [Referencias])

  show bibliography: set par(
    first-line-indent: 0in,
    hanging-indent: 0.5in,
  )

  show heading.where(level: 2): set heading(supplement: [Anexo]) if is-proposal == false
  set heading(supplement: [Anexo], numbering: "A.a.") if is-proposal == true

  show bibliography: set heading(
    level: if is-proposal == true { 3 } else { 2 },
    numbering: none,
    outlined: false,
    bookmarked: true,
    supplement: [Capítulo],
  )

  set heading(
    numbering: (..args) => {
      let pos = args.pos()
      if pos.len() == 1 {
        numbering("I", ..pos)
      } else if pos.len() == 2 {
        numbering("A", chapter-counter.get().first())
      } else {
        numbering("a.1.", ..pos.slice(2))
      }
    },
  ) if is-proposal == false

  set heading(
    numbering: (..args) => {
      let pos = args.pos()
      if pos.len() == 1 {
        numbering("I", ..pos)
      } else if pos.len() == 2 {
        numbering("A", chapter-counter.get().first())
      } else {
        numbering("A.a.1.", ..pos.slice(2))
      }
    },
  ) if is-proposal == true

  if is-proposal == true {
    counter(heading).update(0)
  }

  chapter-counter.update(0)

  body
}

// Artículos irrelevantes o sin efecto directo a la planilla.
// Art. 140: Encuadernación
// La encuadernación será: En cartón duro, color blanco, y la tapa se plastificará para proteger las letras y/o la hoja con el contenido de la cubierta o tapa.
// Art. 145: Estilo de redacción
// El estilo de redacción será impersonal, evitando utilizar la primera persona.
// Se recomienda: usar el estilo científico (directo y preciso), evitar la verbosidad y palabras rebuscadas, no distraer el mensaje con términos ambiguos e imprecisos, redactar párrafos breves, evitando un excesivo número de oraciones subordinadas, las que hacen perder la idea central, emplear las frases para demostrar y argumentar (no para decorar ni persuadir), y elaborar una lista de aquellos términos poco comunes que necesiten una definición particular dentro del contexto de la investigación. Este glosario de términos deberá ir al final del trabajo y debe estar indicado en el índice del contenido.
// Art. 146: Tiempo de los verbos
// La redacción del trabajo deberá hacerse utilizando el tiempo presente, a excepción del capítulo de "Método", que podrá escribirse en pretérito (pasado). Una vez decidido el tiempo verbal a utilizar, no se modificará el mismo en párrafos subsiguientes
