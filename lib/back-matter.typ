/// Prepara el documento para las páginas finales, incluyendo anexos, glosario, etc.
#let back-matter(body) = context {
  import "info.typ"

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

  import "csl-styles.typ": apa
  set bibliography(style: apa, full: false, title: [Referencias])

  show bibliography: set par(
    first-line-indent: 0in,
    hanging-indent: 0.5in,
  )

  // Back matter is outside the part hierarchy. Appendices restart at A.
  set heading(
    offset: 0,
    numbering: (..args) => {
      let pos = args.pos()
      if pos.len() == 1 { numbering("A", ..pos) } else if pos.len() <= 4 { numbering("A.a.1.", ..pos) }
    },
  )

  // TODO: Only the chapter-level heading supplement should change to "Anexo", the rest should remain as inherited from the main matter.
  show heading.where(level: 1): set heading(supplement: [Anexo])

  // TODO: The bibliography should have a chapter style adn remain bookmarked as well as outlined but remain unnumbered.
  show bibliography: set heading(
    level: 1,
    offset: 0,
    numbering: none,
    outlined: true,
    bookmarked: true,
  )
  counter(heading).update(0)

  body

  context { info.work-pages.update(here().page()) }
}
