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

#let helvetica = (
  text: (
    font: "Helvetica",
    size: 10pt,
  ),
  display: "Helvetica",
  math: (
    font: "Lete Sans Math",
    size: 10pt,
  ),
  mono: (
    font: "Courier Prime",
    size: 9.5pt,
  ),
)

#let helvetica-neue = (
  text: (
    font: "Helvetica Neue",
    size: 10pt,
  ),
  display: "Helvetica Neue",
  math: (
    font: "Lete Sans Math",
    size: 10pt,
  ),
  mono: (
    font: ("Inconsolata", "Inconsolata EX", "Inconsolata LGC"),
    size: 9pt,
  ),
)

#let times-new-roman = (
  text: (
    font: "Times New Roman",
    size: 11pt,
  ),
  display: "Times New Roman",
  math: (
    font: "TeX Gyre Termes Math",
    size: 11pt,
  ),
  mono: (
    font: ("Courier Prime", "TeX Gyre Cursor", "Courier New", "Courier"),
    size: 9.5pt,
  ),
)

#let termes = (
  text: (
    font: "TeX Gyre Termes",
    size: 11pt,
  ),
  display: "TeX Gyre Termes",
  math: (
    font: "TeX Gyre Termes Math",
    size: 11pt,
  ),
  mono: (
    font: ("Courier Prime", "TeX Gyre Cursor"),
    size: 9.5pt,
  ),
)

#let heros = (
  text: (
    font: "TeX Gyre Heros",
    size: 11pt,
  ),
  display: "TeX Gyre Heros",
  math: (
    font: "Lete Sans Math",
    size: 11pt,
  ),
  mono: (
    font: ("Inconsolata", "Inconsolata EX", "Inconsolata LGC"),
    size: 9pt,
  ),
)

#let arial = (
  text: (
    font: "Arial",
    size: 10pt,
  ),
  display: "Arial",
  math: (
    font: "Luciole Math",
    size: 9.5pt,
  ),
  mono: (
    font: ("Inconsolata", "Inconsolata EX", "Inconsolata LGC"),
    size: 9pt,
  ),
)

#let default = reforma

#let typefaces = (
  "Reforma": reforma,
  "Termes": termes,
  "Arial": arial,
  "Helvetica": helvetica,
  "Heros": heros,
  "Helvetica Neue": helvetica-neue,
  "Times New Roman": times-new-roman,
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
