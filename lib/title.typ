#let uni-logo = image(
  "../assets/images/upsa-logo-green.svg",
  width: 50%,
  alt: "Logo de la Universidad Privada de Santa Cruz de la Sierra",
)

// Art. 136: Carátula o tapa interna.
//
// En la carátula o tapa interna se debe colocar lo mismo que en la tapa (portada externa) con la sola adición de: "{modalidad de grado} para optar al grado de {grado} en {carrera}".
#let title-page(is-front-cover: false) = context {
  import "info.typ"

  let typeface = info.font.get()
  let author = info.author-name.get()
  let faculty = info.faculty.get()
  let major = info.degree-program.get()
  let is-proposal = info.proposal.get()
  let degree-level = info.degree-level.get()
  let modality = info.thesis-modality.get()
  let year = info.work-date.get()
  let work-title = info.work-title.get()
  let author-id = info.author-uni-id.get()
  let supervisor = info.supervisor.get()
  let city = info.city.get()

  set text(weight: "bold", size: typeface.text.size + (1.5 / 12) * 1em, font: typeface.title.font)
  set page(margin: 1in) if is-front-cover

  set align(center)

  uni-logo
  v(1fr)
  faculty
  parbreak()
  major
  v(1fr)

  if is-proposal {
    [Plan de trabajo de graduación]
    v(1fr)
  }

  if modality != none {
    [Modalidad de graduación]
    parbreak()
    modality
    v(1fr)
  }

  rect(
    radius: 20%,
    inset: 10pt,
    text(font: typeface.title.font, weight: "semibold", size: 1.1em)[_«#work-title»_],
  )

  if not is-front-cover {
    v(1fr)
    [
      #modality para optar por el grado de \
      «#degree-level en #major»
    ]
  }

  v(1fr)

  author

  if author-id != none and not is-front-cover [
    #parbreak()
    Reg.: #author-id
  ]

  v(1fr)

  if supervisor != none {
    supervisor
    parbreak()
  }

  city
  parbreak()
  repr(year)
  if not is-front-cover {
    pagebreak(to: "odd", weak: true)
  }
}

