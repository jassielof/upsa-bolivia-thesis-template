#import "main-matter.typ": chapter-counter

// TODO: Fix appendices numbering.
/// Prepara el documento para las páginas finales, incluyendo anexos, glosario, etc.
#let back-matter(body) = context {
  import "info.typ"

  let is-proposal = info.proposal.get()
  let font-family = info.font-family.get()
  let typeface = info.font.get()
  let multi-part = info.multi-part.get()

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

  show heading.where(level: 2): set heading(supplement: [Anexo]) if multi-part
  set heading(supplement: [Anexo], numbering: "A.a.") if not multi-part

  show bibliography: set heading(
    level: if multi-part { 2 } else { 1 },
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
  ) if multi-part

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
  ) if not multi-part

  if not multi-part {
    counter(heading).update(0)
  }

  chapter-counter.update(0)

  body

  context { info.work-pages.update(here().page()) }
}
