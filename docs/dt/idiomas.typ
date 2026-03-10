#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
)

#set text(
  font: "Noto Sans",
  size: 10pt,
  lang: "es",
)

// Configuración estilística de encabezados
#show heading.where(level: 1): it => block(width: 100%, below: 1.5em)[
  #set align(center)
  #set text(fill: rgb("#0f172a"), size: 22pt, weight: "bold")
  #it.body
  #v(0.5em)
  #line(length: 100%, stroke: 2.5pt + rgb("#3b82f6"))
]

#show heading.where(level: 2): it => block(width: 100%, above: 2em, below: 1em)[
  #set text(fill: rgb("#1e3a8a"), size: 16pt, weight: "bold")
  #it.body
]

#show heading.where(level: 3): it => block(width: 100%, above: 1.5em, below: 0.75em)[
  #set text(fill: rgb("#2563eb"), size: 13pt, weight: "semibold")
  #it.body
]

= Perfil Sociolingüístico - Mundial 2026

Este documento detalla los metadatos de los idiomas oficiales y las lenguas vernáculas predominantes de los equipos para el torneo de 2026, organizados según la configuración de los 12 grupos oficiales del sorteo.

== 1. Distribución Demográfica por Grupos Oficiales

#let tabla_grupo(nombre, equipos) = {
  block(width: 100%, breakable: false)[
    #text(weight: "bold", size: 11pt)[#nombre]
    #v(0.5em)
    #table(
      columns: (1fr, 1.2fr, 1.2fr),
      gutter: 3pt,
      stroke: none,
      fill: (x, y) => if y == 0 { rgb("#f1f5f9") } else if calc.even(y) { rgb("#f8fafc") },
      inset: 6pt,
      [*Selección*], [*Idioma Oficial*], [*Idioma Vernáculo*],
      ..equipos.flatten(),
    )
  ]
}

#grid(
  columns: (1fr, 1fr),
  gutter: 15pt,
  tabla_grupo("Grupo A", (
    ("México 🇲🇽", "Español (De facto)", "Español"),
    ("Sudáfrica 🇿🇦", "12 Idiomas Oficiales", "Zulú / Inglés"),
    ("Corea del Sur 🇰🇷", "Coreano", "Coreano"),
    ("UEFA Playoff D 🇪🇺", "Varía según ganador", "Varía"),
  )),
  tabla_grupo("Grupo B", (
    ("Canadá 🇨🇦", "Inglés / Francés", "Inglés"),
    ("UEFA Playoff A 🇪🇺", "Varía según ganador", "Varía"),
    ("Qatar 🇶🇦", "Árabe", "Árabe / Inglés"),
    ("Suiza 🇨🇭", "4 Idiomas Oficiales", "Alemán Suizo"),
  )),
)

#v(1em)
#grid(
  columns: (1fr, 1fr),
  gutter: 15pt,
  tabla_grupo("Grupo C", (
    ("Brasil 🇧🇷", "Portugués", "Portugués"),
    ("Marruecos 🇲🇦", "Árabe / Bereber", "Darija (Árabe)"),
    ("Haití 🇭🇹", "Francés / Criollo Hait.", "Criollo Haitiano"),
    ("Escocia 🏴󠁧󠁢󠁳󠁣󠁴󠁿", "Inglés / Gaélico", "Inglés / Scots"),
  )),
  tabla_grupo("Grupo D", (
    ("Estados Unidos 🇺🇸", "Ninguno (Inglés)", "Inglés / Español"),
    ("Paraguay 🇵🇾", "Español / Guaraní", "Guaraní / Jopara"),
    ("Australia 🇦🇺", "Ninguno (Inglés)", "Inglés"),
    ("UEFA Playoff C 🇪🇺", "Varía según ganador", "Varía"),
  )),
)

#v(1em)
#grid(
  columns: (1fr, 1fr),
  gutter: 15pt,
  tabla_grupo("Grupo E", (
    ("Alemania 🇩🇪", "Alemán", "Alemán"),
    ("Curazao 🇨🇼", "Neerl./Papiam./Ing.", "Papiamento"),
    ("Costa de Marfil 🇨🇮", "Francés", "Dioula / Francés"),
    ("Ecuador 🇪🇨", "Español (Co-Quechua)", "Español"),
  )),
  tabla_grupo("Grupo F", (
    ("Países Bajos 🇳🇱", "Neerlandés", "Neerlandés"),
    ("Japón 🇯🇵", "Japonés (De facto)", "Japonés"),
    ("UEFA Playoff B 🇪🇺", "Varía según ganador", "Varía"),
    ("Túnez 🇹🇳", "Árabe", "Árabe Tunecino"),
  )),
)

#v(1em)
#grid(
  columns: (1fr, 1fr),
  gutter: 15pt,
  tabla_grupo("Grupo G", (
    ("Bélgica 🇧🇪", "Neerl./Fran./Alem.", "Neerlandés (Flamenco)"),
    ("Egipto 🇪🇬", "Árabe", "Árabe Egipcio"),
    ("Irán 🇮🇷", "Persa (Farsi)", "Persa"),
    ("Nueva Zelanda 🇳🇿", "Inglés / Maorí / LS", "Inglés"),
  )),
  tabla_grupo("Grupo H", (
    ("España 🇪🇸", "Español", "Español"),
    ("Cabo Verde 🇨🇻", "Portugués", "Kriolu"),
    ("Arabia Saudita 🇸🇦", "Árabe", "Árabe Peninsular"),
    ("Uruguay 🇺🇾", "Español", "Español"),
  )),
)

#pagebreak()

#grid(
  columns: (1fr, 1fr),
  gutter: 15pt,
  tabla_grupo("Grupo I", (
    ("Francia 🇫🇷", "Francés", "Francés"),
    ("Senegal 🇸🇳", "Francés", "Wolof"),
    ("Playoff IC 2 🌍", "Varía según ganador", "Varía"),
    ("Noruega 🇳🇴", "Noruego", "Noruego"),
  )),
  tabla_grupo("Grupo J", (
    ("Argentina 🇦🇷", "Español", "Español"),
    ("Argelia 🇩🇿", "Árabe / Tamazight", "Árabe Argelino (Darja)"),
    ("Austria 🇦🇹", "Alemán", "Alemán (Bávaro)"),
    ("Jordania 🇯🇴", "Árabe", "Árabe Levantino"),
  )),
)

#v(1em)
#grid(
  columns: (1fr, 1fr),
  gutter: 15pt,
  tabla_grupo("Grupo K", (
    ("Portugal 🇵🇹", "Portugués", "Portugués"),
    ("Playoff IC 1 🌍", "Varía según ganador", "Varía"),
    ("Uzbekistán 🇺🇿", "Uzbeko", "Uzbeko / Ruso"),
    ("Colombia 🇨🇴", "Español", "Español"),
  )),
  tabla_grupo("Grupo L", (
    ("Inglaterra 🏴󠁧󠁢󠁥󠁮󠁧󠁿", "Inglés (De facto)", "Inglés"),
    ("Croacia 🇭🇷", "Croata", "Croata"),
    ("Ghana 🇬🇭", "Inglés", "Akan (Twi)"),
    ("Panamá 🇵🇦", "Español", "Español"),
  )),
)

#v(2em)

== 2. Dicotomía Sociolingüística: Oficialidad frente a Realidad Vernácula

En una vasta proporción de las naciones clasificadas, el idioma instaurado en la constitución diverge radicalmente de la lengua materna o franca utilizada por la población.

- *Diglosia en el Magreb*: En Marruecos, Argelia y Túnez, el Árabe Moderno Estándar funge como idioma oficial, pero los ciudadanos se comunican en dialectos locales (Darija/Darja) y lenguas bereberes (Tamazight) ininteligibles con el estándar.
- *Bilingüismo Asimétrico Latinoamericano*: Paraguay sostiene al español y al guaraní como oficiales, pero el Guaraní y su alternancia de código (Jopara) dominan la intimidad de los hogares (77% de compresión nacional).
- *África Subsahariana y las Lenguas Vehiculares*: En naciones como Senegal, Costa de Marfil y Ghana, las lenguas imperiales (francés e inglés) operan exoglósicamente en la administración, mientras el Wolof, Dioula y Akan actúan como auténticas lenguas francas endoglósicas.
- *Reivindicación Criolla*: Las naciones insulares de Haití, Curazao y Cabo Verde evidencian el desplazamiento de los léxicos imperiales a favor de lenguas criollas de profunda identidad nacional (Criollo Haitiano, Papiamento, Kriolu).

#v(2em)

== 3. Gráfica Analítica: Macrofamilias Lingüísticas Vernáculas

Esta visualización paramétrica cuantifica la proyección de las raíces de los idiomas vernáculos y lenguas francas que dominarán las delegaciones e interacciones del torneo, integrando las 42 naciones ya confirmadas y proyectando las 6 plazas de repechaje.

#let datos_idiomas = (
  ("Español e Híbridos", 10, rgb("#3b82f6")),
  ("Inglés y Variantes", 9, rgb("#10b981")),
  ("Dialectos Árabes", 6, rgb("#f59e0b")),
  ("Francés y Criollos", 5, rgb("#8b5cf6")),
  ("Lenguas Germánicas", 5, rgb("#ec4899")),
  ("Portugués / Criollos", 4, rgb("#14b8a6")),
  ("Lenguas Africanas", 4, rgb("#f43f5e")),
  ("Otras Familias", 5, rgb("#64748b")),
)

#let max_equipos = 10

#align(center)[
  #block(width: 95%, stroke: 0.5pt + rgb("#e2e8f0"), inset: 15pt, radius: 5pt, fill: rgb("#f8fafc"))[
    #grid(
      columns: (130pt, 1fr, 30pt),
      gutter: 12pt,
      ..for (idioma, cantidad, color) in datos_idiomas {
        (
          align(right + horizon)[#text(size: 9pt, weight: "medium")[#idioma]],
          align(left + horizon)[
            #block(
              width: (cantidad / max_equipos) * 100%,
              height: 16pt,
              fill: color,
              radius: 3pt,
            )
          ],
          align(left + horizon)[#text(size: 10pt, weight: "bold")[#cantidad]],
        )
      }
    )
    #v(1em)
    #line(length: 100%, stroke: 0.5pt + gray)
    #align(left)[
      #text(
        size: 8.5pt,
        fill: gray,
      )[*Metodología:* Los datos representan el idioma de uso diario predominante (vernáculo) o la lengua franca mayoritaria de la delegación nacional, superando en prioridad a los idiomas meramente constitucionales pero de uso minoritario.]
    ]
  ]
]
