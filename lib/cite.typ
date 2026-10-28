#import "info.typ"

#let to-string(content) = {
  if type(content) == str {
    content
  } else if type(content) == int {
    content
  } else if content.has("text") {
    if type(content.text) == str {
      content.text
    } else {
      to-string(content.text)
    }
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  } else {
    ""
  }
}


#let to-ascii(s) = {
  let accents = (
    "á": "a",
    "é": "e",
    "í": "i",
    "ó": "o",
    "ú": "u",
    "Á": "a",
    "É": "e",
    "Í": "i",
    "Ó": "o",
    "Ú": "u",
    "ñ": "n",
    "Ñ": "n",
    "ü": "u",
    "Ü": "u",
    "ç": "c",
    "Ç": "c",
  )
  let out = lower(str(s))
  for (acc, clean) in accents {
    out = out.replace(acc, clean)
  }
  out.replace(regex("[^a-z0-9]"), "")
}

#let extract-title-keyword(title) = {
  let stopwords = (
    "el",
    "la",
    "los",
    "las",
    "un",
    "una",
    "unos",
    "unas",
    "de",
    "del",
    "al",
    "en",
    "para",
    "por",
    "con",
    "sin",
    "sobre",
    "entre",
    "hacia",
    "este",
    "esta",
    "estos",
    "estas",
    "the",
    "and",
    "for",
    "with",
    "from",
    "into",
  )

  let words = title.split(regex("\s+")).map(w => to-ascii(w)).filter(w => w.len() >= 4 and not stopwords.contains(w))

  if words.len() > 0 { words.at(0) } else { "thesis" }
}

#let normalize-author(raw-name) = {
  let raw = str(raw-name).trim()
  if raw.contains(",") {
    return raw.split(",").map(s => s.trim()).join(", ")
  }

  let s = raw
  let multi-particles = (
    (" de la ", " de~la "),
    (" de los ", " de~los "),
    (" de las ", " de~las "),
    (" do ceu ", " do~ceu "),
    (" Do Ceu ", " Do~Ceu "),
    (" van der ", " van~der "),
  )
  for (orig, bound) in multi-particles {
    s = s.replace(orig, bound)
  }

  s = s.replace(regex("(\b\w+)\s+(de|del|da|di|von|van)\s+(\w+\b)"), "$1~$2~$3")
  s = s.replace(regex("\b(de|del|san|santa|da|di|von|van)\s+(\w+\b)"), "$1~$2")

  let tokens = s.split(regex("\s+")).filter(w => w.len() > 0).map(t => t.replace("~", " "))

  let n = tokens.len()

  if n <= 1 {
    raw
  } else if n == 2 {
    // "Nicole Numberg" -> "Numberg, Nicole"
    tokens.at(1) + ", " + tokens.at(0)
  } else if n == 3 {
    // "Jassiel Ovando Franco" -> "Ovando Franco, Jassiel"
    tokens.slice(1).join(" ") + ", " + tokens.at(0)
  } else {
    // "Ana Lía Rubin de Celis Clouzet" -> "Rubin de Celis Clouzet, Ana Lía"
    tokens.slice(n - 2).join(" ") + ", " + tokens.slice(0, n - 2).join(" ")
  }
}

#let build-bibkey(normalized-author, year, title) = {
  let surnames = normalized-author.split(",").at(0).trim()
  let primary-surname = surnames.split(regex("\s+")).at(0)
  let clean-surname = to-ascii(primary-surname)
  let clean-year = to-ascii(year)
  let title-kw = extract-title-keyword(title)

  clean-surname + clean-year + "-" + title-kw
}


#let format-biblatex(fields: (:), citation-key: "", indent-width: 12) = {
  let pad(str-val, width) = {
    str-val + " " * calc.max(1, width - str-val.len())
  }

  let lines = ("@thesis{" + citation-key + ",",)

  for (field, val) in fields.pairs() {
    if val != none {
      let clean-val = str(to-string(val)).trim()
      if clean-val != "" {
        lines.push("  " + pad(field, indent-width) + "= {" + clean-val + "},")
      }
    }
  }

  lines.push("}")
  lines.join("\n")
}


/// Genera la entrada BibLaTeX de la tesis en formato `.bib`.
/// - author: Nombre en formato "Apellidos, Nombres". Si es none, se normaliza automáticamente.
/// - bibkey: Clave de citación personalizada. Si es none, se genera `apellidoAÑO-palabra`.
#let generate(author: none, bibkey: none) = context {
  let final-author = if author != none {
    author
  } else {
    normalize-author(info.author-name.get())
  }

  let work-title = info.work-title.get()
  let thesis-type = info.thesis-modality.get()

  let raw-date = info.work-date.get()
  let year = if type(raw-date) == datetime {
    str(raw-date.year())
  } else {
    let m = str(raw-date).match(regex("\b(19|20)\d{2}\b"))
    if m != none { m.text } else { str(raw-date) }
  }

  let final-key = if bibkey != none {
    to-ascii(bibkey)
  } else {
    build-bibkey(final-author, year, to-string(work-title))
  }

  let raw-keywords = info.keywords.get()
  let formatted-keywords = if type(raw-keywords) == array {
    raw-keywords.join(", ")
  } else {
    raw-keywords
  }

  let data = (
    author: final-author,
    title: work-title,
    type: thesis-type,
    institution: info.university.get(),
    department: info.faculty.get(),
    location: info.city.get(),
    date: year,
    langid: "spanish",
    language: "spanish",
    abstract: info.work-abstract.get(),
    keywords: formatted-keywords,
    degree: info.degree-level.get() + " en " + info.degree-program.get(),
    pagetotal: info.work-pages.final(),
    supervisor: info.supervisor.get(),
  )

  let biblatex = format-biblatex(
    fields: data,
    citation-key: final-key,
    indent-width: 12,
  )

  return asset("thesis.bib", bytes(biblatex))
}


#let optional-string(value) = {
  if value == none {
    return none
  }

  let result = str(to-string(value)).trim()
  if result == "" { none } else { result }
}

#let insert-optional(dict, key, value) = {
  if value != none {
    dict.insert(key, value)
  }
}

/// Genera la entrada Hayagriva de la tesis en formato `.yml`.
///
/// - author: Autor en formato "Apellidos, Nombres".
/// - citation-key: Clave personalizada de citación.
/// - call-number: Signatura topográfica de la biblioteca.
/// - archive: Biblioteca que conserva la tesis.
/// - archive-location: Localización de la biblioteca.
/// - publisher-short: Abreviatura de la institución editora.
/// - edition: Edición de la obra, si corresponde.
/// - supervisor-role: Rol Hayagriva del supervisor.
#let generate-hayagriva(
  author: none,
  citation-key: none,
  call-number: none,
  archive: none,
  archive-location: none,
  publisher-short: "UPSA",
  edition: none,
  supervisor-role: "director",
) = context {
  let final-author = if author != none {
    optional-string(author)
  } else {
    normalize-author(info.author-name.get())
  }

  let work-title = optional-string(info.work-title.get())
  let thesis-type = optional-string(info.thesis-modality.get())

  let raw-date = info.work-date.get()
  let year = if type(raw-date) == datetime {
    str(raw-date.year())
  } else {
    let m = str(raw-date).match(regex("\b(19|20)\d{2}\b"))
    if m != none { m.text } else { str(raw-date) }
  }

  let final-key = if citation-key != none {
    to-ascii(citation-key)
  } else {
    build-bibkey(final-author, year, work-title)
  }

  let university = optional-string(info.university.get())
  let city = optional-string(info.city.get())
  let supervisor = optional-string(info.supervisor.get())
  let abstract = optional-string(info.work-abstract.get())

  // Publisher's name, including its short form.
  let publisher-name = (
    value: university,
  )

  insert-optional(
    publisher-name,
    "short",
    optional-string(publisher-short),
  )

  let publisher = (
    name: publisher-name,
  )

  insert-optional(publisher, "location", city)

  // Hayagriva thesis metadata.
  let data = (
    type: "thesis",
    title: work-title,
    author: final-author,
    date: int(year),
    language: "es-BO",
    genre: thesis-type,
    organization: university,
    publisher: publisher,
  )

  insert-optional(data, "abstract", abstract)

  let pages = info.work-pages.final()
  if pages != none {
    data.insert("page-total", pages)
  }

  // Library and archival information.
  insert-optional(
    data,
    "call-number",
    optional-string(call-number),
  )

  insert-optional(
    data,
    "archive",
    optional-string(archive),
  )

  insert-optional(
    data,
    "archive-location",
    optional-string(archive-location),
  )

  // Optional edition.
  if edition != none {
    data.insert("edition", edition)
  }

  // Academic supervisor (approximated as an affiliated role).
  if supervisor != none and supervisor-role != none {
    data.insert("affiliated", (
      (
        role: supervisor-role,
        names: supervisor,
      ),
    ))
  }

  // The citation key must be dynamically inserted.
  let entries = (:)
  entries.insert(final-key, data)

  let output = yaml.encode(entries)

  asset("thesis.yaml", output)
}
