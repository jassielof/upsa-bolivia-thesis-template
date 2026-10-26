#import "../lib.typ": bime-abstract, book-front-cover, book-spine-cover, settings

#document(
  "thesis.pdf",
  include "/documents/thesis/TFG.typ",
)

// Resumen del tema para el formulario de defensa: máximo 250 palabras, una plana, distinto del abstract del informe. Por consigna no menciona capítulos, antecedentes, justificación, objetivos ni conclusiones: solo de qué se trata el trabajo.
#document("abstract.pdf", bime-abstract())

#document("front-cover.pdf", book-front-cover())

#document("spine-cover.pdf", book-spine-cover())
