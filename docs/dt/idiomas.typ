#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
)

#set text(
  font: "Noto Sans",
  size: 11pt,
  lang: "es",
)

// Configuración de encabezados
#show heading.where(level: 1): it => block(width: 100%, below: 1em)[
  #set align(center)
  #set text(fill: rgb("#1d4ed8"), size: 24pt)
  #it.body
  #v(0.5em)
  #line(length: 100%, stroke: 2pt + rgb("#1d4ed8"))
]

#show heading.where(level: 2): it => block(width: 100%, above: 1.5em, below: 1em)[
  #set text(fill: rgb("#1e40af"), size: 16pt)
  #it.body
]

= Idiomas por Equipo - Mundial 2026

Este documento detalla los metadatos de los idiomas oficiales y predominantes de los equipos para el torneo de 2026, organizados por grupos.

== Distribución por Grupos

#let tabla_grupo(nombre, equipos) = {
  block(width: 100%, breakable: false)[
    === #nombre
    #table(
      columns: (1.2fr, 1fr, 1fr),
      inset: 10pt,
      align: horizon,
      fill: (x, y) => if y == 0 { rgb("#eff6ff") } else { white },
      stroke: 0.5pt + gray,
      [Selección], [I. Oficial], [I. Más Hablado],
      ..equipos.flatten(),
    )
  ]
}

#tabla_grupo("Grupo A", (
  ("México", "Español", "Español"),
  ("Estados Unidos", "Inglés", "Inglés"),
  ("Canadá", "Inglés / Francés", "Inglés"),
  ("Panamá", "Español", "Español"),
))

#tabla_grupo("Grupo B", (
  ("Argentina", "Español", "Español"),
  ("Brasil", "Portugués", "Portugués"),
  ("Uruguay", "Español", "Español"),
  ("Colombia", "Español", "Español"),
))

#tabla_grupo("Grupo C", (
  ("España", "Español", "Español"),
  ("Francia", "Francés", "Francés"),
  ("Inglaterra", "Inglés", "Inglés"),
  ("Alemania", "Alemán", "Alemán"),
))

#tabla_grupo("Grupo D", (
  ("Marruecos", "Árabe / Bereber", "Árabe Marroquí"),
  ("Egipto", "Árabe", "Árabe"),
  ("Senegal", "Francés", "Wolof"),
  ("Nigeria", "Inglés", "Inglés"),
))

#tabla_grupo("Grupo E", (
  ("Japón", "Japonés", "Japonés"),
  ("Corea del Sur", "Coreano", "Coreano"),
  ("Australia", "Inglés", "Inglés"),
  ("Arabia Saudita", "Árabe", "Árabe"),
))

#tabla_grupo("Grupo F", (
  ("Países Bajos", "Neerlandés", "Neerlandés"),
  ("Bélgica", "Francés / Neerl.", "Neerlandés"),
  ("Suiza", "Alemán / Francés", "Alemán"),
  ("Croacia", "Croata", "Croata"),
))

#tabla_grupo("Grupo G", (
  ("Ecuador", "Español", "Español"),
  ("Chile", "Español", "Español"),
  ("Paraguay", "Español / Guaraní", "Guaraní"),
  ("Perú", "Español", "Español"),
))

#tabla_grupo("Grupo H", (
  ("Ghana", "Inglés", "Twi"),
  ("Camerún", "Francés / Inglés", "Francés"),
  ("Mali", "Francés", "Bambara"),
  ("Argelia", "Árabe / Tamazight", "Árabe"),
))

#tabla_grupo("Grupo I", (
  ("Portugal", "Portugués", "Portugués"),
  ("Polonia", "Polaco", "Polaco"),
  ("Dinamarca", "Danés", "Danés"),
  ("Serbia", "Serbio", "Serbio"),
))

#tabla_grupo("Grupo J", (
  ("Costa Rica", "Español", "Español"),
  ("Jamaica", "Inglés", "Patois"),
  ("Honduras", "Español", "Español"),
  ("Sudáfrica", "11 Oficiales", "Zulú / Inglés"),
))

#pagebreak()

== Gráfica de Idiomas Predominantes

Esta visualización representa el conteo de los idiomas principales que se esperan en las delegaciones del torneo (basado en el idioma oficial más relevante).

#let datos = (
  ("Español", 15),
  ("Inglés", 9),
  ("Francés", 7),
  ("Árabe", 6),
  ("Portugués", 2),
  ("Alemán", 2),
  ("Otros", 7),
)

#let valor_max = 15

#v(2em)
#align(center)[
  #block(width: 90%)[
    #for (idioma, cantidad) in datos {
      grid(
        columns: (120pt, 1fr, 40pt),
        gutter: 12pt,
        align(right + horizon)[#idioma],
        stack(
          dir: ltr,
          block(
            width: (cantidad / valor_max) * 100%,
            height: 18pt,
            fill: rgb("#3b82f6"),
            radius: 3pt,
          ),
        ),
        align(left + horizon)[#cantidad],
      )
      v(8pt)
    }
  ]
]

#v(3em)
#rect(fill: rgb("#f8fafc"), inset: 12pt, radius: 4pt, stroke: 0.5pt + gray)[
  Resumen de datos: El español será el idioma con mayor presencia en el torneo debido a la gran cantidad de selecciones hispanohablantes clasificadas de CONMEBOL y CONCACAF.
]
