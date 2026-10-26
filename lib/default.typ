#import "@preview/datify:1.0.1": custom-date-format
#let fonts = (
  size: 12pt,
  title: "TeX Gyre Heros",
  body: "TeX Gyre Termes",
  mono: "TeX Gyre Cursor",
  math: "TeX Gyre Termes Math",
)

#let adobe-source-typeface = ()

#let paragraph = (
  spacing: 2em,
  leading: 1.5em,
)

#let institution-info = (
  university: (
    long: [Universidad Privada de Santa Cruz de la Sierra],
    short: [UPSA],
  ),
  faculty: (
    long: none,
    short: none,
  ),
  location: [Santa Cruz de la Sierra, Bolivia],
)

#let degree-info = (
  program: none,
  level: none,
)

#let author-info = (
  name: none,
  id: none,
  email: none,
)

#let advisor-info = (
  name: none,
)

#let graduation-work-info = (
  title: [El título oficial del documento (máximo recomendado de 15 palabras)],
  subtitle: none,
  abstract: none,
  is-plan: false,
  date: custom-date-format(datetime.today(), lang: "es"),
  keywords: ("UPSA", "Licenciatura", "Proyecto de grado"),
  modality: [Proyecto de grado],
  modality-abbr: [PG],
)
