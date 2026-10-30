#import "../lib.typ": back-matter, front-matter, main-matter, settings

#show: settings.with(
  author-name: "Nombre Apellido",
  author-email: "estudiante@example.org",
  author-university-id: 2026000000,
  work-title: [Ejemplo mínimo de trabajo de grado],
  supervisor: [Nombre del asesor],
  degree-level: [Licenciatura],
  degree-program: [Ingeniería de Sistemas],
  faculty: [Facultad de Ingeniería],
  faculty-acronym: [FAI],
  modality: [Proyecto de Grado],
  modality-acronym: [PG],
  date: datetime.today().year(),
  abstract: [
    Este documento ilustra la configuración de un trabajo de grado mediante una
    plantilla en Typst. Reúne los datos del trabajo, capítulos, una tabla y citas
    bibliográficas. Los documentos de entrega se generan a partir de los mismos
    metadatos. Es un ejemplo de uso y no presenta una investigación realizada ni
    resultados obtenidos en la Universidad.
  ],
  keywords: ("UPSA", "Typst", "trabajo de grado"),
)

#front-matter(
  problem: [Aplicación consistente de las reglas de presentación del trabajo.],
  objective: [Mostrar el uso básico de la plantilla y sus documentos de entrega.],
)

#show: main-matter

= Introducción <cap-introduccion>

Este ejemplo mínimo permite reconocer los archivos de la plantilla. Para iniciar
un proyecto completo, utilizá el #link("https://github.com/jassielof/upsa-bolivia-thesis-starter")[kit de inicio].
Reemplazá los datos, el resumen y el contenido por los de tu trabajo; confirmá la
estructura con tu asesor.

== Organización del documento

Un capítulo se escribe con `=`, una sección con `==` y una subsección con `===`.
Las partes son opcionales: al activar `multi-part`, se introducen con `part()`;
los capítulos mantienen la misma escritura.

== Citas y referencias

La documentación de Typst explica su sistema de composición y bibliografía
@typst-docs. Las referencias de este ejemplo se encuentran en `referencias.bib`,
en formato BibLaTeX. Cambiá el estilo de citas según los requisitos de tu carrera.

= Desarrollo <cap-desarrollo>

La @tabla-entregables resume dos salidas del ejemplo. Las cubiertas y la referencia
bibliográfica del propio trabajo se generan desde `book.typ` con los mismos datos.

#figure(
  table(
    columns: (1fr, 2fr),
    table.header([Documento], [Propósito]),
    [Informe], [Presentar el contenido principal del trabajo.],
    [Resumen BIME], [Describir el tema central según las instrucciones de entrega.],
  ),
  caption: [Documentos de ejemplo.],
) <tabla-entregables>

Las instrucciones BIME establecen un resumen temático de 250 palabras
@bime-entrega. Verificá que el contenido que uses en un proyecto real cumpla
sus requisitos y los de tu unidad académica.

= Conclusiones

El ejemplo muestra la relación entre la configuración, los capítulos y las
referencias. La presentación definitiva y los documentos exigidos se acuerdan
con la carrera y las entidades receptoras.

#show: back-matter

#bibliography("referencias.bib", style: "ieee")

= Material complementario

Este anexo ilustra la numeración independiente del contenido final. Consultá el
@cap-desarrollo para volver al ejemplo de tabla y al @cap-introduccion para revisar
la configuración del contenido.
