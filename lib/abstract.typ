// Resumen analítico especializado requerido por facultad.
#let metadata-abstract(body) = {}

// Abstracto o resumen informativo requerido en la tesis.
#let informative-abstract() = {}

/// Resumen del trabajo requerido para la entrega de trabajos de grado de Universidades Privadas, a pedido de la Biblioteca del Ministerio de Educación. Tiene que ser impreso.
///
/// Ref.:
/// - https://www.minedu.gob.bo/index.php?option=com_content&view=article&id=1666:resolucion-bime&catid=235&Itemid=971.
/// - https://utp.minedu.gob.bo/pdfs/Biblioteca.pdf
#let indicative-abstract(
  name: "Nombre del estudiante",
  degree: [Carrera o grado académico],
  title: [Título del trabajo de grado],
  advisor: [Nombre del tutor o profesor guía],
  modality: [Modalidad de titulación],
  university: [Universidad Privada de Santa Cruz de la Sierra],
  city: [Santa Cruz de la Sierra],
  date: datetime.today().year(),
  body,
) = {
  set document(
    title: title,
    author: name,
  )

  assert(name != none, message: "El nombre del autor es necesario.")
  assert(degree != none, message: "El grado académico (carrera) es necesario.")
  assert(title != none, message: "El título del trabajo de grado es necesario.")
  assert(advisor != none, message: "El nombre del tutor o profesor guía es necesario.")
  assert(modality != none, message: "La modalidad de titulación es necesaria.")
  assert(university != none, message: "El nombre de la universidad es necesario.")
  assert(city != none, message: "El nombre de la ciudad es necesario.")
  assert(date != none, message: "La fecha del trabajo es necesaria.")

  show std.title: set align(center)
  show std.title: set block(spacing: 2em)
  set text(size: 11pt, lang: "es", region: "bo")
  set page(paper: "a4", margin: 1.5in)
  set par(justify: true)
  set terms(separator: [: ])
  line(length: 100%)

  [
    / #upper[Universidad]: #university
    / #upper[Carrera]: #degree
    / #upper[Título]: #title
    / #upper[Modalidad de titulación]: #modality
    / #upper[Nombres y apellidos del autor]: #name
    / #upper[Nombres y apellidos del tutor o prof. guía]: #advisor
    / #upper[Ciudad]: #city
    / #upper[Año del trabajo]: #date
  ]

  line(length: 100%)

  std.title()

  set align(horizon)

  import "@preview/wordometer:0.1.6": total-words, word-count
  show: word-count

  let hard-limit = 250

  word-count(
    total => {
      body

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
