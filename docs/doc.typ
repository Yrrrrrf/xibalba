#set document(title: "Xibalbá - Entrega Final", author: "Equipo Xibalbá")
#set page(
  paper: "a4",
  margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm),
)

// --- COLORES ---
#let c-dark = rgb("#0d1b2a")
#let c-accent = rgb("#e63946")
#let c-muted = luma(100)
#let c-gold = rgb("#e9c46a")

#set text(font: "Libertinus Serif", size: 11pt)
#show heading: set text(fill: c-dark)

// --- PÁGINA 1: IDENTIDAD Y ACCESO ---
#align(center)[
  #v(2cm)
  #rect(fill: c-dark, inset: 20pt, radius: 10pt)[
    #text(size: 40pt, weight: "bold", fill: white, tracking: 4pt)[XIBALBÁ]
  ]
  #v(0.5cm)
  #text(size: 14pt, fill: c-accent, weight: "bold")[Cancha Justa para el Comercio Local - Mundial 2026]

  #v(1cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 15pt,
    rect(fill: luma(245), inset: 10pt, radius: 5pt, width: 100%)[
      #text(weight: "bold")[Demo Live]\
      #text(size: 8pt)[#link("http://3.141.197.76:4173")]
    ],
    rect(fill: luma(245), inset: 10pt, radius: 5pt, width: 100%)[
      #text(weight: "bold")[Presentación]\
      #text(size: 8pt)[#link("https://v0-xibalba-presentation-creation.vercel.app/")]
    ],
    rect(fill: luma(245), inset: 10pt, radius: 5pt, width: 100%)[
      #text(weight: "bold")[Repositorio]\
      #text(size: 8pt)[#link("https://github.com/Yrrrrrf/xibalba")]
    ],
  )
]

#v(1cm)
== 01. Visión General (The Overview)

*Xibalbá* es una infraestructura digital de visibilidad diseñada para el Mundial FIFA 2026. Su objetivo es democratizar la derrama económica de *600 millones de USD* esperada en México, conectando a micro-negocios locales con el flujo masivo de turistas internacionales.

#v(0.5cm)
#rect(stroke: 1pt + c-accent, inset: 15pt, radius: 5pt, fill: rgb("#fff5f5"))[
  #text(weight: "bold", fill: c-accent)[El Problema de la Invisibilidad:] \
  Actualmente, el 90% de las MiPyMEs turísticas son invisibles para el extranjero. El turista termina en grandes cadenas porque el comercio local no aparece en su idioma o mapa. Xibalbá rompe esta barrera.
]

#v(1fr)
#align(right)[#text(size: 9pt, fill: c-muted)[Xibalbá | Fase 2-3 | Talent Hackathon 2026]]

#pagebreak()

// --- PÁGINA 2: MAIN FEATURES ---
== 02. Funcionalidades Core (Main Features)

#v(0.5cm)
#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  block[
    *🌐 Motor Multilingüe Nativo* \
    Traducción automática a *13+ idiomas* (Japonés, Árabe, Alemán, etc.). Las traducciones están optimizadas para carga instantánea en zonas de estadios con señal saturada.
  ],
  block[
    *💱 Engine de Divisas ISO* \
    Integración con Dinero.js. El turista visualiza precios en su moneda nativa con conversión real. Elimina la fricción psicológica de la compra.
  ],

  block[
    *📍 Geo-Descubrimiento* \
    Búsqueda geoespacial por radio de proximidad. Prioriza negocios locales verificados sobre franquicias, impulsando la cultura local.
  ],
  block[
    *🏪 Onboarding Express* \
    Panel diseñado para dueños de negocios sin conocimientos técnicos. Registro en *menos de 10 minutos* para generar un perfil profesional.
  ],
)

#v(1cm)
#rect(fill: c-dark, inset: 15pt, radius: 8pt, width: 100%)[
  #text(fill: white, weight: "bold")[Adaptación Cultural Dinámica:] \
  La aplicación detecta el origen del turista y adapta automáticamente el **tema visual** (colores y tipografía). Un turista japonés verá una interfaz adaptada a su estética nacional.
]

#pagebreak()

// --- PÁGINA 3: STACK ---
== 03. Especificaciones Técnicas (The Stack)

#v(0.5cm)
#table(
  columns: (auto, 1fr),
  stroke: none,
  fill: (x, y) => if calc.even(y) { luma(245) } else { white },
  inset: 10pt,
  [*Capa*], [*Tecnología y Justificación*],
  [Backend], [**Rust (Axum):** Máximo rendimiento y seguridad de memoria para manejar miles de peticiones simultáneas.],
  [Frontend],
  [**Svelte 5 (Runes):** El bundle más ligero del mercado. Carga crítica en < 2s en redes móviles saturadas.],

  [Base de Datos], [**SurrealDB:** Multi-modelo. Combina Grafo (recomendaciones) y Geoespacial en un solo motor.],
  [Arquitectura], [**Tauri:** Una sola base de código para Web, iOS y Android. Despliegue ágil y robusto.],
  [Validaciones], [**WASM:** Lógica de dominio compartida entre cliente y servidor mediante WebAssembly.],
)

#v(1cm)
=== Arquitectura de Datos
El sistema utiliza un **SDK propio (rune-lab)** que estandariza la conexión con el servidor. La arquitectura de "Separación Estricta" permite que el frontend sea una SPA estática, haciéndola resiliente a caídas.

#v(0.5cm)
#align(center)[
  #rect(fill: luma(240), stroke: 1pt + gray, radius: 5pt, inset: 10pt)[
    *SurrealDB* $arrow.l.r$ *Rust Engine* $arrow.l.r$ *Svelte UI*
  ]
]

#pagebreak()

// --- PÁGINA 4: IMPACTO ---
== 04. Impacto Económico y Sostenibilidad

#v(1cm)
#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  rect(fill: c-dark, inset: 15pt, radius: 10pt)[
    #text(fill: c-gold, size: 18pt, weight: "bold")[\$500,000 MXN] \
    #text(
      fill: white,
      size: 8pt,
    )[Derrama semanal adicional estimada hacia negocios locales invisibles (500 comercios / 5 visitas extra).]
  ],
  rect(fill: c-accent, inset: 15pt, radius: 10pt)[
    #text(fill: white, size: 18pt, weight: "bold")[100% Inclusión] \
    #text(fill: white, size: 8pt)[Diseño accesible para usuarios con baja alfabetización tecnológica y brecha digital.]
  ],
)

#v(1cm)
=== Sostenibilidad Post-Hackathon
1. **Integración de Pagos:** Conexión con Clip/Conekta para cerrar el ciclo de venta.
2. **Dashboard de Impacto:** Entrega de métricas a Fundación Coppel sobre consumo.
3. **Escalabilidad:** Arquitectura en Rust lista para escalar a nivel nacional.

#v(3cm)
#line(length: 100%, stroke: 0.5pt + gray)
#v(0.2cm)
#grid(
  columns: (1fr, 1fr),
  [
    *Equipo Xibalbá* \
    Fernando Bryan Reza C. \
    Yoed Eliel Alvarez J. \
    Raul Jacob Albarran R. \
    Fernando Ramirez L. \
    John Alexander Martinez G.
  ],
  align(right)[
    *Talent Hackathon 2026* \
    Track: Cancha Justa \
    Genius Arena
  ],
)
