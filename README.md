# Plantilla Typst para trabajos de grado de la UPSA

Plantilla reutilizable para la elaboración de trabajos finales de grado de la Universidad Privada de Santa Cruz de la Sierra (UPSA), desarrollada con [Typst](https://typst.app/).

El proyecto busca facilitar la aplicación consistente de los requisitos de presentación académica mediante estilos y componentes reutilizables, reduciendo la necesidad de realizar ajustes manuales durante la redacción.

> [!IMPORTANT]
> Este proyecto es una iniciativa independiente y no constituye una plantilla oficialmente aprobada por la UPSA. Su utilización debe ajustarse al Reglamento de Graduación vigente y a las indicaciones de la unidad académica correspondiente.

## Comenzar

Para elaborar un trabajo académico a partir de un proyecto de ejemplo, se recomienda utilizar el [kit de inicio para trabajos de grado](https://github.com/jassielof/upsa-bolivia-thesis-starter).

El kit incluye documentos de ejemplo, recursos gráficos, instrucciones de compilación, tareas automatizadas y una configuración de trabajo orientada a estudiantes.

Este repositorio contiene la implementación de la plantilla y está dirigido principalmente a quienes necesitan comprender, configurar o mantener sus estilos y componentes.

## Ejemplo mínimo incluido

La carpeta `template/` conserva tres archivos:

- `thesis.typ`: datos del trabajo, páginas preliminares, capítulos, una tabla, citas y un anexo.
- `referencias.bib`: bibliografía de ejemplo en formato BibLaTeX.
- `book.typ`: generación conjunta del informe, el resumen BIME, la cubierta, el lomo y la referencia BibLaTeX del propio trabajo.

Este ejemplo permite probar la biblioteca. El [kit de inicio](https://github.com/jassielof/upsa-bolivia-thesis-starter) sigue siendo la base recomendada para un trabajo real: contiene una estructura más completa, recursos y automatización. El ejemplo mínimo no utiliza Taskfile.

Desde la raíz de este repositorio, con Typst 0.15.1 o posterior:

```sh
typst compile --root . --pdf-standard a-2a,ua-1 template/thesis.typ
typst compile --root . --features bundle --format bundle --pdf-standard a-2a,ua-1 template/book.typ template/book
```

La primera orden genera `template/thesis.pdf`. La segunda crea `template/book/` con `thesis.pdf`, `abstract.pdf`, `front-cover.pdf`, `spine-cover.pdf` y `thesis.bib`. Este último contiene la referencia del propio trabajo; `referencias.bib` contiene sus fuentes citadas.

El ejemplo selecciona `typeface: "Termes"`: requiere TeX Gyre Termes, TeX Gyre Termes Math y TeX Gyre Cursor. Instalá las fuentes o agregá `--font-path /ruta/a/fuentes` a las órdenes. En Ubuntu 24.04 se encuentran en los paquetes `fonts-texgyre` y `fonts-texgyre-math`. La plantilla no duplica la colección de fuentes del kit de inicio.

Para probar partes sin cambiar los capítulos:

```sh
typst compile --root . --input multi-part=true --pdf-standard a-2a,ua-1 template/thesis.typ template/thesis-parts.pdf
```

## Documentos contemplados

La implementación se ha desarrollado principalmente alrededor de las necesidades de los proyectos de grado de Ingeniería.

Los documentos contemplados por el kit de inicio incluyen:

- **Trabajo de grado:** manuscrito principal utilizado para presentar el proyecto desarrollado.
- **Plan de trabajo:** documento de planificación y propuesta, correspondiente a la etapa inicial del proyecto.
- **Estudio de factibilidad:** documento cuya estructura se basa en el modelo utilizado en determinadas carreras de Ingeniería Industrial.
- **Resumen:** documento complementario de síntesis del trabajo.
- **Cubierta y lomo:** recursos para la presentación física de los ejemplares.
- **Currículum:** documento complementario cuando corresponde a los requisitos de entrega.

La aplicabilidad de cada documento depende de la modalidad de graduación y de los requisitos de la carrera.

### Estructura académica

Los ejemplos iniciales se basan en experiencias concretas de proyectos de grado:

- El estudio de factibilidad utiliza como referencia la estructura de catorce capítulos asociada al material del Ing. Juan Carlos Paz Parada.
- El proyecto de grado de Sistemas se organizó mediante partes relacionadas con hitos de la metodología ICONIX.
- El plan de proyecto representa la etapa de formulación y planificación del trabajo.

Estas estructuras son ejemplos de aplicación, no modelos obligatorios para todas las carreras.

La organización predeterminada es por capítulos: `=` siempre inicia un capítulo y `==` una sección. Para agrupar capítulos en partes, importa `part`, activa `multi-part: true` en `settings` y llama explícitamente a `#part[Título de la parte]` dentro de `main-matter`. Los capítulos continúan numerándose entre partes; no es necesario cambiar los encabezamientos del contenido.

Las páginas preliminares y la bibliografía conservan el estilo de capítulo. `back-matter` vuelve al nivel superior y reinicia los anexos en A, B, C; sus secciones se numeran A.a., A.b., etc. El índice general incluye las partes y los capítulos, y el índice de anexos enumera solamente los anexos. `part()` requiere que `multi-part` esté activado.

## Tipografía

La selección tipográfica es uno de los principales aspectos de la plantilla sujetos a evaluación institucional.

El Reglamento de Graduación menciona familias como Times New Roman, Arial y Helvetica. Sin embargo, su disponibilidad y sus condiciones de distribución pueden variar según el sistema operativo, el entorno de trabajo y la licencia correspondiente.

La plantilla propone incorporar conjuntos tipográficos completos y redistribuibles para mejorar la portabilidad entre Windows, macOS, Linux y el editor web de Typst.

### Conjunto inicial: TeX Gyre

| Función | Familia | Referencia tipográfica |
|---|---|---|
| Texto principal | [TeX Gyre Termes](https://www.gust.org.pl/projects/e-foundry/tex-gyre/termes) | Diseño similar a Times |
| Títulos | [TeX Gyre Heros](https://www.gust.org.pl/projects/e-foundry/tex-gyre/heros) | Diseño similar a Helvetica |
| Código | [TeX Gyre Cursor](https://www.gust.org.pl/projects/e-foundry/tex-gyre/cursor) | Diseño monoespaciado |
| Matemáticas | [TeX Gyre Termes Math](https://www.gust.org.pl/projects/e-foundry/tg-math) | Complemento matemático de Termes |

Este conjunto permite cubrir los principales usos tipográficos de un documento académico sin depender exclusivamente de fuentes instaladas en el sistema.

> [!NOTE]
> TeX Gyre constituye la propuesta técnica inicial. Su semejanza visual con las fuentes mencionadas por la UPSA no implica equivalencia normativa ni autorización institucional para sustituirlas.

### Posibles conjuntos adicionales

Las siguientes familias podrían evaluarse en futuras versiones:

- [IBM Plex](https://github.com/IBM/plex): Serif, Sans, Mono y Math.
- [Adobe Source](https://github.com/adobe-fonts): Source Serif, Source Sans y Source Code; requiere elegir una fuente matemática complementaria.
- [Libertinus](https://github.com/alerque/libertinus): Serif, Sans, Mono y Math.
- [Reforma](https://www.pampatype.com/reforma): familia tipográfica desarrollada para la Universidad Nacional de Córdoba.
- [Alegreya](https://fonts.google.com/specimen/Alegreya) y [Alegreya Sans](https://fonts.google.com/specimen/Alegreya+Sans).
- [Montserrat](https://fonts.google.com/specimen/Montserrat).
- [EB Garamond](https://fonts.google.com/specimen/EB+Garamond).

Estas familias no deben considerarse automáticamente compatibles entre sí ni equivalentes en términos de tamaño, métricas, cobertura de caracteres y funciones OpenType.

La compatibilidad con versalitas, cursivas, negritas, matemáticas y otros recursos tipográficos debe comprobarse para cada combinación y versión de los archivos.

### Licencias

Las familias propuestas pueden distribuirse bajo licencias diferentes, como la SIL Open Font License, la GUST Font License u otras condiciones específicas.

Antes de incluir una fuente en el kit es necesario comprobar:

1. La licencia correspondiente a los archivos utilizados.
2. Las condiciones de redistribución.
3. Los avisos de copyright y atribución requeridos.
4. La disponibilidad de los estilos y caracteres necesarios.
5. Su funcionamiento con las versiones de Typst utilizadas por el proyecto.

No debe suponerse que una fuente es redistribuible simplemente porque esté instalada en un sistema operativo o disponible gratuitamente para uso individual.

Las licencias y avisos correspondientes a las fuentes distribuidas deben acompañar a sus archivos.

## Configuración y estilos

La plantilla centraliza reglas para la presentación de documentos académicos y permite reutilizar configuraciones comunes.

Sus principales ámbitos de aplicación incluyen:

- Jerarquía y numeración de encabezados.
- Presentación de texto y párrafos.
- Figuras, tablas y referencias internas.
- Portadas y elementos institucionales.
- Expresiones matemáticas y contenido monoespaciado.
- Citas y referencias bibliográficas.
- Organización de capítulos y, cuando corresponda, partes.

Los parámetros concretos, sus valores admitidos y sus valores predeterminados deben consultarse en la implementación de la plantilla.

La implementación ofrece conjuntos tipográficos enumerados mediante `typeface` y partes opcionales mediante `multi-part`. Las familias disponibles y sus valores se consultan en `lib/typeface.typ`; su disponibilidad técnica no implica aprobación institucional.

## Citas y bibliografía

Typst permite gestionar fuentes bibliográficas y aplicar estilos de citación mediante CSL (Citation Style Language).

El estilo utilizado debe responder a los requisitos vigentes de la carrera o de la unidad académica correspondiente.

APA puede utilizarse como configuración general, mientras que otros sistemas, como IEEE, ACM o ASCE, pueden resultar pertinentes según la disciplina y las autorizaciones académicas aplicables.

La selección de un estilo de citas y referencias no implica que todo el documento adopte automáticamente el formato editorial completo de dicho estilo.

## Accesibilidad y documentos PDF

La plantilla busca favorecer la generación de documentos PDF estructurados y accesibles mediante el uso apropiado de encabezados, figuras, tablas, referencias y otros elementos semánticos.

Typst dispone de funciones de exportación y comprobación relacionadas con estándares como PDF/UA y PDF/A.

Sin embargo, la accesibilidad de un documento también depende de su contenido y de las decisiones de autoría, incluidas:

- La jerarquía correcta de encabezados.
- Las descripciones alternativas de imágenes cuando sean necesarias.
- El orden lógico de lectura.
- La identificación apropiada de tablas y otros elementos.
- La correcta utilización de caracteres y expresiones matemáticas.

Una compilación exitosa no garantiza por sí sola la accesibilidad integral del documento.

Para más información, consultá la [guía oficial de accesibilidad de Typst](https://typst.app/docs/guides/accessibility/).

## Uso y mantenimiento

La plantilla se utiliza dentro del kit de inicio mediante los archivos y rutas definidos por el proyecto.

Para un entorno de trabajo reproducible es recomendable:

- Utilizar una versión conocida del compilador Typst.
- Conservar las versiones de las fuentes y sus licencias.
- Mantener disponibles los recursos externos.
- Comprobar el funcionamiento de las dependencias.
- Verificar los documentos generados después de modificar estilos o actualizar el compilador.

Los cambios en la plantilla pueden afectar a documentos existentes, por lo que deben probarse mediante ejemplos representativos antes de su distribución.

## Estado institucional

La plantilla y el kit de inicio están disponibles para evaluación académica.

Las principales cuestiones pendientes son:

- La aceptación de familias tipográficas alternativas a las mencionadas en el Reglamento de Graduación.
- La comprobación académica de las opciones de capítulos y partes ya implementadas.
- La comprobación del funcionamiento en diferentes entornos.
- La recopilación de observaciones de estudiantes y docentes.
- La eventual evaluación de mejoras adicionales de presentación académica.

La propuesta no requiere sustituir los procesadores de texto utilizados actualmente por la Universidad ni modificar de inmediato sus normas de presentación.

## Documentación

- [Kit de inicio para trabajos de grado](https://github.com/jassielof/upsa-bolivia-thesis-starter)
- [Documentación oficial de Typst](https://typst.app/docs/)
- [Traducción no oficial de Typst al español](https://jassielof.github.io/typst/)

## Licencia

La implementación de esta plantilla se distribuye bajo la **Apache License 2.0**, conforme a los archivos de licencia del repositorio.

Esta licencia no se extiende automáticamente a:

- Los documentos académicos creados por los estudiantes.
- Las fuentes tipográficas incluidas o utilizadas.
- Los recursos de terceros sujetos a licencias independientes.
- Los signos distintivos y el logotipo de la Universidad Privada de Santa Cruz de la Sierra.

Cada recurso conserva sus condiciones de uso y distribución correspondientes.
