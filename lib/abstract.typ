#import "info.typ"

/// Resumen analítico especializado requerido por facultad.
#let faculty(
  problem: none,
  objective: none,
  content-index: none,
) = context {
  let major = info.degree-program.get()
  let supervisor = info.supervisor.get()
  let keywords = info.keywords.get()
  let email = info.author-email.get()
  let author = info.author-name.get()
  let work-title = info.work-title.get()
  let year = info.work-date.get()

  set heading(numbering: none, outlined: false)
  show outline: set heading(numbering: none, outlined: false, level: 2)

  heading(level: 1)[Abstracto]

  table(
    align: (left + horizon, left),
    columns: 2,
    stroke: 1pt,
    [*Título*], work-title,
    [*Autor*], author,
  )

  set heading(level: 2)

  if problem != none {
    heading[Problemática]
    problem
  }

  if objective != none {
    heading[Objetivo]
    objective
  }

  show outline.entry: set block(spacing: 0.75em)
  content-index

  table(
    columns: (auto, 1fr),
    stroke: 1pt,
    align: (left + horizon, left),
    ..if major != none {
      ([Carrera], major)
    },
    ..if supervisor != none {
      ([Guía], supervisor)
    },
    ..if keywords != none {
      ([Palabras clave], keywords)
    },
    ..if email != none {
      ([Correo electrónico], email)
    },
    ..if year != none {
      ([Año], repr(year))
    },
  )
}

// Abstracto o resumen informativo requerido en la tesis.
#let chapter() = {}

/// Resumen del trabajo requerido para la entrega de trabajos de grado de Universidades Privadas, a pedido de la Biblioteca del Ministerio de Educación. Tiene que ser impreso.
///
/// Ref.:
/// - https://www.minedu.gob.bo/index.php?option=com_content&view=article&id=1666:resolucion-bime&catid=235&Itemid=971.
/// - https://utp.minedu.gob.bo/pdfs/Biblioteca.pdf
#let bime() = context {
  let author = info.author-name.get()
  let work-title = info.work-title.get()
  let year = info.work-date.get()
  let city = info.city.get()
  let modality = info.thesis-modality.get()
  let supervisor = info.supervisor.get()
  let abstract = info.work-abstract.get()
  let university = info.university.get()
  let degree = info.degree-program.get()

  set document(
    title: work-title,
    author: author,
    description: abstract,
  )

  show std.title: set align(center)
  show std.title: set block(spacing: 2em)
  show std.title: set text(size: 16pt)
  set text(size: 10pt, lang: "es", region: "bo", hyphenate: false)
  set page(paper: "a4", margin: 1.5in)
  set par(justify: true)
  set terms(separator: [: ])
  line(length: 100%)

  [
    / #upper[Universidad]: #university
    / #upper[Carrera]: #degree
    / #upper[Título]: #work-title
    / #upper[Modalidad de titulación]: #modality
    / #upper[Nombres y apellidos del autor]: #author
    / #upper[Nombres y apellidos del tutor o prof. guía]: #supervisor
    / #upper[Ciudad]: #city
    / #upper[Año del trabajo]: #year
  ]

  line(length: 100%)

  std.title()

  import "@preview/wordometer:0.1.6": total-words, word-count
  show: word-count
  set text(hyphenate: true, size: 11pt)
  let hard-limit = 250

  word-count(
    total => {
      abstract

      assert(
        total.words <= hard-limit,
        message: "El abstracto no debe exceder las "
          + str(hard-limit)
          + " palabras. Actualmente tiene "
          + str(total.words)
          + " palabras.",
      )
    },
  )
}
