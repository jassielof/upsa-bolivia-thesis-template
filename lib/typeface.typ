#let ibm-plex = (
  text: (
    font: "IBM Plex Serif",
    weight: 450,
    size: 10pt,
  ),
  display: "IBM Plex Sans",
  math: (
    font: "IBM Plex Math",
    weight: 450,
  ),
  mono: (
    font: "IBM Plex Mono",
    weight: 450,
    size: 9.5pt,
  ),
)

#let new-computer-modern = (
  text: (
    font: "New Computer Modern",
    size: 11pt,
  ),
  display: "New Computer Modern Sans",
  math: (
    font: "New Computer Modern Math",
    size: 11pt,
  ),
  mono: (
    font: "New Computer Modern Mono",
    size: 10pt,
  ),
)
#let tex-gyre = ()

#let reforma = (
  text: (
    font: "Reforma 1918",
    size: 11pt,
  ),
  display: "Reforma 2018",
  math: (
    font: "TeX Gyre Pagella Math",
    size: 11pt,
  ),
  mono: (
    font: "IBM Plex Mono",
    weight: 450,
    size: 9.5pt,
  ),
)

#let adobe-source = (
  text: (
    font: "Source Serif 4",
    size: 10pt,
  ),
  display: "Source Sans 3",
  math: (
    font: "STIX Two Math",
    size: 11pt,
  ),
  mono: (
    font: "Source Code Pro",
    size: 9.5pt,
  ),
)

#let inter = (
  text: (
    font: "Inter",
    stylistic-set: (3, 2),
    size: 10pt,
    discretionary-ligatures: true,
  ),
  display: "Inter",
  math: (
    font: "Fira Math",
    size: 10pt,
  ),
  mono: (
    font: ("Consolas", "Inconsolata", "Inconsolata EX", "Inconsolata LGC"),
    size: 10pt,
  ),
)

#let alegreya = (
  text: (
    font: "Alegreya",
    size: 11pt,
  ),
  display: "Alegreya Sans",
  math: (
    font: "TeX Gyre Pagella Math",
    size: 11pt,
  ),
  mono: (
    font: "IBM Plex Mono",
    size: 9.5pt,
  ),
)

#let piazzolla = (
  text: (
    font: "Piazzolla",
    size: 11pt,
  ),
  display: "Piazzolla",
  math: (
    font: "TeX Gyre Schola Math",
    size: 11pt,
  ),
  mono: (
    font: "IBM Plex Mono",
    size: 9.5pt,
  ),
)

#let andada = (
  text: (
    font: "Andada Pro",
    size: 11pt,
  ),
  display: "Andada Pro",
  math: (
    font: "TeX Gyre Bonum Math",
    size: 11pt,
  ),
  mono: (
    font: "IBM Plex Mono",
    size: 9.5pt,
  ),
)

#let default = reforma
#let typefaces = (
  "Reforma": reforma,
  "Adobe Source": adobe-source,
  "Alegreya": alegreya,
  "Piazzolla": piazzolla,
  "Andada": andada,
  "IBM Plex": ibm-plex,
  "New Computer Modern": new-computer-modern,
  "Inter": inter,
)
#let extra = (
  ..typefaces,
  "Inter": inter,
)

#let get(name) = extra.at(name, default: reforma)
