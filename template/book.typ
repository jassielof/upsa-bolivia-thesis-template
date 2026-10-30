#import "../lib.typ": (
  bime-abstract, book-front-cover, book-spine-cover, generate-biblatex,
)

// Se compila como bundle: el informe configura los metadatos compartidos.
#document("thesis.pdf", include "thesis.typ")

// Revisá el resumen y las dimensiones de las cubiertas antes de la entrega.
#document("abstract.pdf", bime-abstract())
#document("front-cover.pdf", book-front-cover())
#document("spine-cover.pdf", book-spine-cover())

// Referencia BibLaTeX del propio trabajo; no es la bibliografía de fuentes citadas.
#generate-biblatex()
