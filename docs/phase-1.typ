// ─── IMPORTS ──────────────────────────────────────────────────────────────────
#import "@preview/gentle-clues:1.0.0": *
#import "@preview/cetz:0.3.4": canvas, draw

// ─── DOCUMENTO ────────────────────────────────────────────────────────────────
#set document(title: "Xibalbá — Fase 1: Ideación", author: "Equipo Xibalbá")

// ─── COLORES DEL PROYECTO ─────────────────────────────────────────────────────
#let c-dark = rgb("#0d1b2a")   // azul oscuro marino
#let c-mid = rgb("#1b2a3b")   // azul medio
#let c-accent = rgb("#e63946")   // rojo Xibalbá
#let c-blue = rgb("#457b9d")   // azul turista
#let c-green = rgb("#2d6a4f")   // verde negocio
#let c-gold = rgb("#e9c46a")   // dorado impacto
#let c-muted = luma(100)
#let c-bg-soft = luma(248)
#let c-bg-warm = rgb("#fff8f5")
#let c-rule = luma(210)

// ─── PÁGINA ───────────────────────────────────────────────────────────────────
#set page(
  paper: "a4",
  margin: (top: 2.4cm, bottom: 2.4cm, left: 2.6cm, right: 2.6cm),
  header: [
    #set text(size: 8pt, fill: c-muted)
    #grid(
      columns: (1fr, 1fr),
      align(left)[Xibalbá — Fase 1: Ideación], align(right)[Talent Hackathon 2026 · Genius Arena],
    )
    #line(length: 100%, stroke: 0.5pt + c-rule)
  ],
  footer: [
    #line(length: 100%, stroke: 0.5pt + c-rule)
    #set text(size: 8pt, fill: c-muted)
    #grid(
      columns: (1fr, 1fr),
      align(left)[Track: Fundación Coppel — Cancha Justa], align(right)[Página #context counter(page).display()],
    )
  ],
)

// ─── TIPOGRAFÍA ───────────────────────────────────────────────────────────────
#set text(font: "Libertinus Serif", size: 11pt, lang: "es")
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.8em, spacing: 1.1em)

#show heading.where(level: 1): it => {
  v(1.5em)
  block(width: 100%)[
    #rect(
      fill: c-dark,
      inset: (x: 14pt, y: 8pt),
      radius: 5pt,
      width: 100%,
    )[
      #text(size: 13.5pt, weight: "bold", fill: white)[#it]
    ]
  ]
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.9em)
  grid(
    columns: (4pt, 1fr),
    gutter: 8pt,
    rect(fill: c-accent, width: 4pt, height: 1.1em, radius: 2pt), text(size: 12pt, weight: "bold", fill: c-dark)[#it],
  )
  v(0.25em)
}

// ─── UTILIDADES ───────────────────────────────────────────────────────────────
#let section-rule() = {
  v(0.8em)
  line(length: 100%, stroke: (paint: c-accent, thickness: 0.5pt, dash: "dashed"))
  v(0.4em)
}

#let badge(content, color: c-dark) = rect(
  fill: color.lighten(80%),
  stroke: 0.8pt + color,
  inset: (x: 7pt, y: 3pt),
  radius: 12pt,
)[#text(size: 8pt, fill: color, weight: "bold")[#content]]

#let chip(icon, label) = grid(
  columns: (auto, 1fr),
  gutter: 5pt,
  align(horizon)[#text(size: 11pt)[#icon]], align(horizon)[#text(size: 9.5pt)[#label]],
)

// ─── TABLAS ───────────────────────────────────────────────────────────────────
// Tabla con encabezado coloreado y filas alternadas
#let xtable(cols, header-fill: c-dark, header-color: white, ..cells) = table(
  columns: cols,
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { header-fill } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  ..cells
    .pos()
    .enumerate()
    .map(((i, c)) => if i < cols.len() { text(weight: "bold", fill: header-color)[#c] } else { c })
)

// ═══════════════════════════════════════════════════════════════════════════════
//  PORTADA
// ═══════════════════════════════════════════════════════════════════════════════

#align(center)[
  #v(1.5cm)

  // Ícono decorativo
  #text(size: 48pt)[🏟️]
  #v(0.3cm)

  // Nombre principal — gran presencia
  #block(
    fill: c-dark,
    inset: (x: 32pt, y: 18pt),
    radius: 12pt,
    width: 70%,
  )[
    #text(size: 38pt, weight: "bold", fill: white, tracking: 4pt)[XIBALBÁ]
  ]

  #v(0.5cm)
  #text(size: 13.5pt, fill: c-muted, style: "italic")[
    Plataforma de visibilidad turística para micro y pequeños negocios locales
  ]
  #v(0.1cm)
  #text(size: 12pt, fill: c-accent, weight: "bold")[
    Copa Mundial FIFA 2026 · México
  ]

  #v(0.8cm)
  #line(length: 50%, stroke: 2pt + c-accent)
  #v(0.8cm)

  // Metadata grid
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 10pt,

    rect(fill: c-bg-soft, stroke: 0.8pt + c-rule, inset: 12pt, radius: 8pt)[
      #text(weight: "bold", fill: c-dark)[Track]\
      #v(0.2em)
      #text(size: 9pt, fill: c-muted)[Cancha Justa en el Mundial para los Negocios Turísticos Locales]
    ],

    rect(fill: c-bg-soft, stroke: 0.8pt + c-rule, inset: 12pt, radius: 8pt)[
      #text(weight: "bold", fill: c-dark)[Patrocinador]\
      #v(0.2em)
      #text(size: 9pt, fill: c-muted)[Fundación Coppel \ Coppel Emprende]
    ],

    rect(fill: c-bg-soft, stroke: 0.8pt + c-rule, inset: 12pt, radius: 8pt)[
      #text(weight: "bold", fill: c-dark)[Repositorio]\
      #v(0.2em)
      #text(size: 9pt)[#link("https://github.com/Yrrrrrf/xibalba")[github.com/\ Yrrrrrf/xibalba]]
    ],
  )

  #v(0.7cm)

  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,

    rect(fill: c-bg-warm, stroke: 0.8pt + c-rule, inset: 12pt, radius: 8pt)[
      #text(weight: "bold", fill: c-dark)[Equipo Xibalbá]\
      #v(0.2em)
      #set text(size: 9pt)
      #link("https://github.com/Yrrrrrf")[Fernando Bryan Reza Campos] \
      #link("https://github.com/yoedAlv")[Yoed Eliel Alvarez Jimenez] \
      #link("https://github.com/jjjacob91xlx")[Raul Jacob Albarran Rivas] \
      #link("https://github.com/FernandoRL2311")[Fernando Ramirez Lopez] \
      #link("https://github.com/CyberBleyk")[John Alexander Martinez Garcia]
    ],

    rect(fill: c-bg-warm, stroke: 0.8pt + c-rule, inset: 12pt, radius: 8pt)[
      #text(weight: "bold", fill: c-dark)[Evento]\
      #v(0.2em)
      #text(size: 9pt)[
        Talent Hackathon 2026 \
        Genius Arena · Expo Santa Fe \
        Fecha límite Fase 1: \
        #text(weight: "bold")[19 de marzo de 2026]
      ]
    ],
  )

  #v(1.5cm)
]

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  1. IDENTIFICACIÓN DEL PROBLEMA
// ═══════════════════════════════════════════════════════════════════════════════

= Identificación del Problema

== El problema en una frase

#rect(
  fill: rgb("#fff0f1"),
  stroke: 2pt + c-accent,
  inset: 14pt,
  radius: 8pt,
  width: 100%,
)[
  #align(center)[
    #text(size: 12pt, style: "italic", fill: c-dark)[
      "Los micro y pequeños negocios turísticos mexicanos carecen de visibilidad\
      digital multilingüe, lo que los *excluye de la derrama económica* generada\
      por el flujo masivo de turistas del Mundial FIFA 2026."
    ]
  ]
]

== Contexto: la oportunidad más grande en décadas

La Copa Mundial 2026 se celebra en México por tercera ocasión y representa una\
ventana única e irrepetible:

#table(
  columns: (70%, 30%),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[Dato], text(weight: "bold", fill: white)[Fuente],
  [\$600 M USD de derrama esperada solo en CDMX], [Track oficial — Fundación Coppel 2026],
  [300 000 nuevos empleos proyectados en hospitalidad], [Track oficial — Fundación Coppel 2026],
  [+1 000 000 turistas extranjeros esperados en México], [Track oficial — Fundación Coppel 2026],
  [>90% de empresas turísticas en México son MiPyMEs *sin presencia digital consolidada*], [INEGI — DENUE 2023],
)

#section-rule()

El programa *Ola México* (#link("https://olamexico.org/#iniciativa")[olamexico.org]),
impulsado por Impact Hub CDMX con apoyo de Fundación Coppel y
#link("https://coppelemprende.com")[Coppel Emprende], ya capacitó a estos negocios.
*El eslabón faltante es la visibilidad digital.* Xibalbá lo resuelve.

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  2. USUARIO OBJETIVO Y FLUJO
// ═══════════════════════════════════════════════════════════════════════════════

= Usuario Objetivo y Flujo de Usuario

== Perfiles

#grid(
  columns: (1fr, 1fr),
  gutter: 12pt,
  rect(
    fill: rgb("#e8f4fb"),
    stroke: 1.5pt + c-blue,
    inset: 14pt,
    radius: 8pt,
  )[
    #text(size: 14pt)[🌍] #h(4pt) #text(weight: "bold", fill: c-blue)[Turista (visitante)]\
    #v(0.4em)
    - Extranjero o nacional, no habla español
    - Quiere experiencias locales auténticas
    - Usa su teléfono para todo
    - *Dolor:* No encuentra negocios locales en su idioma
  ],
  rect(
    fill: rgb("#e8f7ee"),
    stroke: 1.5pt + c-green,
    inset: 14pt,
    radius: 8pt,
  )[
    #text(size: 14pt)[🏪] #h(4pt) #text(weight: "bold", fill: c-green)[Negocio local (dueño)]\
    #v(0.4em)
    - Restaurante, hospedaje, artesanía, servicios
    - Participante del programa Ola México
    - Sin presencia digital multilingüe
    - *Dolor:* Sus clientes extranjeros no lo encuentran
  ],
)

#v(1em)
== Diagrama de flujo por perfil

// ─── DIAGRAMA TURISTA ─────────────────────────────────────────────────────────
#grid(
  columns: (1fr, 1fr),
  gutter: 16pt,

  // TURISTA
  block[
    #rect(
      fill: c-blue.lighten(85%),
      stroke: 1pt + c-blue,
      inset: (x: 10pt, y: 8pt),
      radius: 6pt,
      width: 100%,
    )[
      #align(center)[#text(weight: "bold", fill: c-blue)[Flujo del Turista]]
    ]
    #v(0.4em)
    #let turista-step(n, icon, text-content) = {
      grid(
        columns: (28pt, 1fr),
        gutter: 6pt,
        align(top)[
          #rect(
            fill: c-blue,
            inset: 4pt,
            radius: 14pt,
            width: 28pt,
          )[
            #align(center)[#text(size: 8pt, weight: "bold", fill: white)[#n]]
          ]
        ],
        align(top)[
          #rect(
            fill: white,
            stroke: 0.5pt + c-rule,
            inset: 7pt,
            radius: 4pt,
            width: 100%,
          )[
            #text(size: 9pt)[#icon #h(3pt) #text-content]
          ]
        ],
      )
      v(0.3em)
    }
    #turista-step("1", "📱", [Abre Xibalbá — la app detecta su idioma y adapta la UI])
    #turista-step("2", "🗺️", [Busca "tacos cerca de mí" — ve negocios geolocalizados])
    #turista-step("3", "🍽️", [Selecciona un negocio — menú en su idioma + precios en su divisa])
    #turista-step("4", "📍", [Sigue las indicaciones — llega al negocio con confianza])
    #turista-step("5", "⭐", [Consume y deja reseña — el negocio gana visibilidad])
  ],

  // NEGOCIO
  block[
    #rect(
      fill: c-green.lighten(85%),
      stroke: 1pt + c-green,
      inset: (x: 10pt, y: 8pt),
      radius: 6pt,
      width: 100%,
    )[
      #align(center)[#text(weight: "bold", fill: c-green)[Flujo del Negocio]]
    ]
    #v(0.4em)
    #let negocio-step(n, icon, text-content) = {
      grid(
        columns: (28pt, 1fr),
        gutter: 6pt,
        align(top)[
          #rect(
            fill: c-green,
            inset: 4pt,
            radius: 14pt,
            width: 28pt,
          )[
            #align(center)[#text(size: 8pt, weight: "bold", fill: white)[#n]]
          ]
        ],
        align(top)[
          #rect(
            fill: white,
            stroke: 0.5pt + c-rule,
            inset: 7pt,
            radius: 4pt,
            width: 100%,
          )[
            #text(size: 9pt)[#icon #h(3pt) #text-content]
          ]
        ],
      )
      v(0.3em)
    }
    #negocio-step("1", "✍️", [Se registra — flujo guiado en minutos, sin conocimientos técnicos])
    #negocio-step("2", "📸", [Sube fotos, descripción, horarios y servicios])
    #negocio-step("3", "🌐", [Su perfil aparece en +13 idiomas automáticamente])
    #negocio-step("4", "👀", [Turistas lo encuentran en el mapa — visitas reales])
    #negocio-step("5", "📈", [Ve métricas de visitas en su panel — crece su clientela])
  ],
)

#v(0.8em)
== Criterios de éxito

- *Turista:* encuentra y llega a un negocio local en *menos de 3 minutos*
- *Negocio:* se da de alta sin asistencia técnica en *menos de 10 minutos*
- *Ambos:* la experiencia funciona correctamente en *zonas con señal móvil saturada*

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  3. PROPUESTA DE SOLUCIÓN
// ═══════════════════════════════════════════════════════════════════════════════

= Propuesta de Solución

== ¿Qué es Xibalbá?

Xibalbá es una *aplicación multiplataforma* (iOS, Android, Desktop y Web) construida
con una única base de código, que conecta turistas internacionales con micro y pequeños
negocios turísticos mexicanos durante el Mundial FIFA 2026 y más allá.

Su nombre evoca la profundidad de la cultura mesoamericana: *lo que existe bajo la
superficie, esperando ser descubierto.* Igual que los negocios locales que el turismo
masivo suele ignorar.

== Funciones clave

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[Función], text(weight: "bold", fill: white)[Qué gana el usuario],
  [🗺️ Mapa con geolocalización],
  [El turista encuentra negocios cercanos en tiempo real, sin necesidad de buscar en redes],

  [🌐 Multilenguaje — más de 13 idiomas], [Cada turista ve la app en su idioma nativo desde el primer segundo],
  [💱 Precios en divisa local], [Sin sorpresas en caja: el turista ve precios en euros, dólares, yenes…],
  [🎨 Temas visuales por país], [La app "habla" culturalmente al turista con colores y estética de su nación],
  [🏪 Panel del negocio], [El dueño actualiza su perfil sin saber de tecnología],
  [🔒 Autenticación segura], [Protección de datos del negocio con estándar de industria],
  [📊 Métricas de visitas], [El negocio sabe cuántos turistas vieron su perfil esta semana],
)

#section-rule()

== ¿Por qué Xibalbá y no Google Maps?

Google Maps y TripAdvisor están hechos para negocios formalizados con tiempo y recursos
para gestionar su presencia digital. Xibalbá se diseñó *desde cero para MiPyMEs
informales*: registro en minutos, soporte multilingüe automático y optimizado para
redes 3G saturadas durante el Mundial.

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  4. JUSTIFICACIÓN TECNOLÓGICA
// ═══════════════════════════════════════════════════════════════════════════════

= Justificación Tecnológica

== Stack principal

#table(
  columns: (auto, auto, 1fr),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[Componente],
  text(weight: "bold", fill: white)[Tecnología],
  text(weight: "bold", fill: white)[Beneficio concreto],

  [Frontend / UI], [SvelteKit], [Bundle ultra-ligero → carga en 3G saturada. Compila a JS puro sin runtime overhead.],

  [Shell multiplataforma],
  [Tauri (Rust)],
  [Un solo código → iOS + Android + Desktop + Web. Sin mantener 4 proyectos separados.],

  [Backend / API], [Rust (Axum)], [Throughput máximo para picos de tráfico mundialistas. Sin GC, latencia predecible.],

  [Base de datos], [SurrealDB], [Multi-modelo (documento + grafo) para queries de geolocalización sin esquema rígido.],

  [Validaciones],
  [WebAssembly (Rust → WASM)],
  [Mismas reglas en servidor Y cliente — cero inconsistencias, cero duplicación.],

  [Auth], [JWT + Argon2], [Estándar OWASP para hashing. Stateless, seguro y escalable sin fricción.],
)

#v(1em)
== rune-lab: la ventaja de construir sobre hombros propios

#grid(
  columns: (1fr, auto),
  gutter: 0pt,
  align(horizon)[
    *rune-lab* es un toolkit de UI empresarial open-source para *Svelte 5*, construido y mantenido
    por el equipo. Está publicado en NPM y JSR bajo licencia MIT.
  ],
  align(horizon)[
    #h(12pt)
    #rect(
      fill: c-dark,
      inset: (x: 10pt, y: 6pt),
      radius: 6pt,
    )[
      #text(size: 8.5pt, fill: white)[
        #link("https://github.com/Yrrrrrf/rune-lab")[github.com/Yrrrrrf/rune-lab]
      ]
    ]
  ],
)

#v(0.7em)

// ── Descripción arquitectónica ──────────────────────────────────────────────
*Arquitectura interna — monorepo en 3 paquetes:*

#v(0.3em)
#table(
  columns: (auto, auto, 1fr),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 8pt,
  text(weight: "bold", fill: white)[Paquete],
  text(weight: "bold", fill: white)[Versión],
  text(weight: "bold", fill: white)[Qué aporta a Xibalbá],

  [`@internal/core`],
  [`v0.2.3`],
  [Lógica pura TypeScript: manejo de dinero con Dinero.js v2 (11+ divisas ISO 4217), resolver de mensajes i18n, interfaces de persistencia],

  [`@internal/state`],
  [`v0.2.3`],
  [Stores reactivos con Svelte 5 Runes: tema visual, idioma activo, divisa del usuario, sesión, toasts y paleta de comandos — listos para inyectar],

  [`@internal/ui`],
  [`v0.2.3`],
  [Componentes visuales sobre Tailwind v4 + DaisyUI v5: `RuneProvider`, `WorkspaceLayout`, `ThemeSelector`, `LanguageSelector`, `CurrencySelector`, `MoneyDisplay`],
)

#v(0.6em)

*¿Por qué no instalamos librerías equivalentes por separado?*

Con rune-lab obtenemos en *un solo paquete cohesivo* lo que de otra forma requeriría integrar y configurar manualmente al menos 5 dependencias (Paraglide, Dinero.js, DaisyUI, better-auth, hotkeys-js) con sus respectivos adaptadores para Svelte 5. Todo ya está tipado, probado y *listo para producción* — factor crítico dado el tiempo del hackathon.

#text(size: 8.5pt, fill: c-muted)[
  Uso rápido — con menos de 10 líneas la app tiene layout completo, temas, idiomas y divisas:
]

#raw(
  lang: "svelte",
  block: true,
  "<RuneProvider app={{ name: \"Xibalbá\", version: \"1.0.0\" }} persistence={cookieDriver}>\n  <WorkspaceLayout>\n    {#snippet content()} {@render children()} {/snippet}\n  </WorkspaceLayout>\n</RuneProvider>",
)

#v(0.5em)

// ─── DIAGRAMA DE CAPAS DE RUNE-LAB ───────────────────────────────────────────
#align(center)[
  #canvas({
    import draw: *

    let w = 12.0 // ancho total
    let h = 1.1 // altura de cada capa
    let gap = 0.22 // espacio entre capas

    let layers = (
      (
        label: "Componentes UI accesibles y responsivos",
        sublabel: "Botones, cards, formularios, mapas — listos para producción",
        fill: rgb("#e8f4fb"),
        stroke-c: rgb("#457b9d"),
        icon: "🧩",
      ),
      (
        label: "Divisas internacionales — DineroJS",
        sublabel: "Precios en EUR, USD, JPY... sin errores de punto flotante",
        fill: rgb("#fff3e0"),
        stroke-c: rgb("#e07b39"),
        icon: "💱",
      ),
      (
        label: "i18n en tiempo de compilación — Paraglide",
        sublabel: "13 idiomas (ar, de, en, es, fr, hi, it, ja, ko, pt, ru, vi, zh)",
        fill: rgb("#e8f7ee"),
        stroke-c: rgb("#2d6a4f"),
        icon: "🌐",
      ),
      (
        label: "Temas visuales por país participante del Mundial",
        sublabel: "Paletas, tipografías y micro-animaciones por nación — 32 países",
        fill: rgb("#fce8e8"),
        stroke-c: rgb("#e63946"),
        icon: "🎨",
      ),
    )

    let total = layers.len()

    for (i, layer) in layers.enumerate() {
      let y = (total - 1 - i) * (h + gap)

      // Caja principal de la capa
      rect(
        (0, y),
        (w, y + h),
        fill: layer.fill,
        stroke: 1.2pt + layer.stroke-c,
        radius: 0.22,
      )

      // Etiqueta del ícono
      content(
        (0.5, y + h / 2),
        text(size: 16pt)[#layer.icon],
        anchor: "mid",
      )

      // Texto principal
      content(
        (1.3, y + h * 0.63),
        text(size: 9pt, weight: "bold", fill: layer.stroke-c.darken(20%))[#layer.label],
        anchor: "west",
      )

      // Subtexto
      content(
        (1.3, y + h * 0.28),
        text(size: 7.5pt, fill: luma(80))[#layer.sublabel],
        anchor: "west",
      )

      // Número de capa (arriba = más visible para usuario)
      content(
        (w - 0.35, y + h / 2),
        text(size: 8pt, weight: "bold", fill: layer.stroke-c)[Capa #(total - i)],
        anchor: "mid",
      )
    }

    // Etiqueta exterior
    content(
      (w / 2, total * (h + gap) + 0.3),
      text(size: 8.5pt, fill: c-muted, style: "italic")[
        ↑ Capa visible para el usuario final
      ],
      anchor: "mid",
    )

    content(
      (w / 2, -0.3),
      text(size: 8.5pt, fill: c-muted, style: "italic")[
        ↓ Capa base (temas) — todo lo demás la hereda
      ],
      anchor: "mid",
    )
  })
]

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  5. ARQUITECTURA Y FLUJO TÉCNICO
// ═══════════════════════════════════════════════════════════════════════════════

= Arquitectura y Flujo Técnico

== Diagrama de componentes

#align(center)[
  #canvas({
    import draw: *

    // ── Layout constants ──
    let bw = 13.0 // total width
    let layer-h = 1.4 // height of each architecture tier
    let gap = 0.5 // vertical gap between tiers
    let r = 0.25 // corner radius

    // ── Colors ──
    let col-client = rgb("#e8f4fb")
    let col-rune = rgb("#e8f7ee")
    let col-api = rgb("#fce8e8")
    let col-db = rgb("#fff3e0")
    let str-client = rgb("#457b9d")
    let str-rune = rgb("#2d6a4f")
    let str-api = rgb("#e63946")
    let str-db = rgb("#e07b39")

    // ─────────────────────────────────────────────────────────────────────────
    // LAYER 0 — SurrealDB (bottom)
    // ─────────────────────────────────────────────────────────────────────────
    let y0 = 0.0
    rect((0, y0), (bw, y0 + layer-h), fill: col-db, stroke: 1.5pt + str-db, radius: r)
    content((bw / 2, y0 + layer-h * 0.68), text(size: 9.5pt, weight: "bold", fill: str-db)[⚙️ SurrealDB], anchor: "mid")
    content(
      (bw / 2, y0 + layer-h * 0.32),
      text(size: 8pt, fill: luma(60))[users · negocios · categorias · ubicaciones · sesiones],
      anchor: "mid",
    )

    // ─────────────────────────────────────────────────────────────────────────
    // Connector: DB → API
    // ─────────────────────────────────────────────────────────────────────────
    let yc1 = y0 + layer-h
    let yc2 = yc1 + gap
    let cx = bw / 2
    line((cx, yc1), (cx, yc2), stroke: 1.2pt + str-api, mark: (end: ">", scale: 0.55))
    content((cx + 0.25, yc1 + gap / 2), text(size: 7pt, fill: c-muted)[WebSocket / SurrealQL], anchor: "west")

    // ─────────────────────────────────────────────────────────────────────────
    // LAYER 1 — API Server
    // ─────────────────────────────────────────────────────────────────────────
    let y1 = yc2
    rect((0, y1), (bw, y1 + layer-h), fill: col-api, stroke: 1.5pt + str-api, radius: r)
    content(
      (bw / 2, y1 + layer-h * 0.70),
      text(size: 9.5pt, weight: "bold", fill: str-api)[🦀 API Server — Rust + Axum],
      anchor: "mid",
    )
    content(
      (bw / 2, y1 + layer-h * 0.38),
      text(size: 8pt, fill: luma(60))[Auth Routes · Negocios Routes · Geo Routes · JWT Middleware · Argon2],
      anchor: "mid",
    )

    // ─────────────────────────────────────────────────────────────────────────
    // Connector: API → rune-lab/SvelteKit
    // ─────────────────────────────────────────────────────────────────────────
    let yc3 = y1 + layer-h
    let yc4 = yc3 + gap
    line((cx, yc3), (cx, yc4), stroke: 1.2pt + str-client, mark: (end: ">", scale: 0.55))
    content((cx + 0.25, yc3 + gap / 2), text(size: 7pt, fill: c-muted)[HTTPS · REST JSON], anchor: "west")

    // ─────────────────────────────────────────────────────────────────────────
    // LAYER 2 — rune-lab + SvelteKit (SDK)
    // ─────────────────────────────────────────────────────────────────────────
    let y2 = yc4
    rect((0, y2), (bw, y2 + layer-h), fill: col-rune, stroke: 1.5pt + str-rune, radius: r)
    content(
      (bw / 2, y2 + layer-h * 0.70),
      text(size: 9.5pt, weight: "bold", fill: str-rune)[📦 rune-lab + SvelteKit],
      anchor: "mid",
    )
    content(
      (bw / 2, y2 + layer-h * 0.35),
      text(
        size: 8pt,
        fill: luma(60),
      )[sdk/core · sdk/state · sdk/ui · i18n (Paraglide) · WASM validations · Dinero.js],
      anchor: "mid",
    )

    // ─────────────────────────────────────────────────────────────────────────
    // Connector: SDK → Tauri Shell
    // ─────────────────────────────────────────────────────────────────────────
    let yc5 = y2 + layer-h
    let yc6 = yc5 + gap
    line((cx, yc5), (cx, yc6), stroke: 1.2pt + str-client, mark: (end: ">", scale: 0.55))
    content((cx + 0.25, yc5 + gap / 2), text(size: 7pt, fill: c-muted)[SSG build · WebView], anchor: "west")

    // ─────────────────────────────────────────────────────────────────────────
    // LAYER 3 — Tauri Shell (top)
    // ─────────────────────────────────────────────────────────────────────────
    let y3 = yc6
    rect((0, y3), (bw, y3 + layer-h), fill: col-client, stroke: 1.5pt + str-client, radius: r)
    content(
      (bw / 2, y3 + layer-h * 0.68),
      text(size: 9.5pt, weight: "bold", fill: str-client)[🖥️ Tauri Shell — iOS · Android · Desktop · Web],
      anchor: "mid",
    )

    // Tres UIs dentro del Tauri layer
    let ui-gap = 0.5
    let ui-w = (bw - 4 * ui-gap) / 3
    let uy = y3 + layer-h * 0.1
    let uh = layer-h * 0.36

    let uis = (
      ("🌍 UI Turista", ui-gap, str-client),
      ("🏪 UI Negocio", ui-gap + ui-w + ui-gap, str-rune),
      ("🔧 UI Admin", ui-gap + (ui-w + ui-gap) * 2, str-api),
    )
    for (label, x, sc) in uis {
      rect((x, uy), (x + ui-w, uy + uh), fill: white, stroke: 0.8pt + sc.lighten(30%), radius: 0.15)
      content(((x + x + ui-w) / 2, uy + uh / 2), text(size: 8pt, fill: sc)[#label], anchor: "mid")
    }
  })
]

#v(0.6em)
== Flujo principal: turista busca un negocio

+ *Entrada:* Abre la app → rune-lab detecta idioma y aplica tema por país
+ *Geo:* El cliente envía coordenadas a la API (con permiso del usuario)
+ *Query:* La API consulta SurrealDB en radio configurable → retorna negocios con metadatos
+ *Render:* El cliente muestra mapa + perfiles traducidos con precios en divisa local
+ *Log:* Cada visita queda registrada para métricas (sin datos personales sensibles)

== Seguridad y rendimiento

- *Auth:* JWT de corta duración + refresh token · Argon2 para hashing (OWASP)
- *CORS:* Estricto por origen en producción · *Rate limiting:* middleware Axum
- *Offline-ready:* Caché local en Tauri para conectividad intermitente durante el Mundial

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  6. MVP Y VIABILIDAD
// ═══════════════════════════════════════════════════════════════════════════════

= MVP y Viabilidad

== Alcance de la demo

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[Funcionalidad],
  text(weight: "bold", fill: white)[¿En demo?],
  text(weight: "bold", fill: white)[Complejidad],

  [Registro e inicio de sesión de negocio], [✅ Sí], [Media],
  [Mapa con negocios geolocalizados (datos simulados)], [✅ Sí], [Media],
  [Perfil de negocio con fotos y descripción], [✅ Sí], [Baja],
  [Cambio de idioma (≥ 3 idiomas)], [✅ Sí], [Baja (rune-lab)],
  [Temas visuales por país (≥ 3 países)], [✅ Sí], [Baja (rune-lab)],
  [Precios en divisa del turista], [✅ Sí], [Baja (DineroJS)],
  [Panel de administración del negocio], [✅ Sí], [Media],
  [Reseñas y valoraciones], [⏳ Parcial], [Alta],
  [Pagos integrados], [❌ Fuera del MVP], [Muy alta],
  [Notificaciones push], [❌ Fuera del MVP], [Alta],
)

#v(0.6em)
== Estimación de esfuerzo (~52 h totales)

#table(
  columns: (1fr, auto, auto),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[Módulo],
  text(weight: "bold", fill: white)[Horas est.],
  text(weight: "bold", fill: white)[Responsable],

  [Setup infraestructura + Docker], [4h], [DevOps],
  [API: Auth + Negocios + Geo], [12h], [Backend],
  [DB: Schema + Seed data], [4h], [Backend],
  [UI: Vistas turista (mapa + perfil)], [10h], [Frontend],
  [UI: Panel de negocio], [8h], [Frontend],
  [rune-lab: temas + i18n + divisas], [6h], [Frontend],
  [Testing + integración + demo], [8h], [Todo el equipo],
)

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  7. IMPACTO Y SOSTENIBILIDAD
// ═══════════════════════════════════════════════════════════════════════════════

= Impacto y Sostenibilidad

== Modelo de impacto económico

#rect(
  fill: c-dark,
  inset: 18pt,
  radius: 10pt,
  width: 100%,
)[
  #align(center)[
    #text(size: 11pt, fill: c-gold)[*¿Cuánto dinero puede mover Xibalbá por semana?*]
  ]
  #v(0.5em)
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr),
    gutter: 0pt,

    // Bloque 1
    rect(fill: c-mid, inset: 10pt, radius: 6pt)[
      #align(center)[
        #text(size: 20pt)[🏪]
        #v(0.2em)
        #text(weight: "bold", fill: c-gold, size: 15pt)[500]
        #v(0.1em)
        #text(size: 8pt, fill: luma(200))[negocios\regulares]
      ]
    ],

    // Operador
    align(horizon)[
      #h(6pt)
      #text(size: 18pt, fill: c-gold, weight: "bold")[×]
      #h(6pt)
    ],

    // Bloque 2
    rect(fill: c-mid, inset: 10pt, radius: 6pt)[
      #align(center)[
        #text(size: 20pt)[🌍]
        #v(0.2em)
        #text(weight: "bold", fill: c-gold, size: 15pt)[5]
        #v(0.1em)
        #text(size: 8pt, fill: luma(200))[visitas extra\por semana]
      ]
    ],

    align(horizon)[
      #h(6pt)
      #text(size: 18pt, fill: c-gold, weight: "bold")[×]
      #h(6pt)
    ],

    // Bloque 3
    rect(fill: c-mid, inset: 10pt, radius: 6pt)[
      #align(center)[
        #text(size: 20pt)[🍽️]
        #v(0.2em)
        #text(weight: "bold", fill: c-gold, size: 15pt)[\$200]
        #v(0.1em)
        #text(size: 8pt, fill: luma(200))[ticket promedio\en MXN]
      ]
    ],

    align(horizon)[
      #h(6pt)
      #text(size: 18pt, fill: white, weight: "bold")[=]
      #h(6pt)
    ],

    // Resultado
    rect(fill: c-accent, inset: 10pt, radius: 6pt)[
      #align(center)[
        #text(size: 20pt)[💰]
        #v(0.2em)
        #text(weight: "bold", fill: white, size: 13pt)[\$500 000]
        #v(0.1em)
        #text(size: 8pt, fill: white)[MXN / semana\en economía local]
      ]
    ],
  )
  #v(0.4em)
  #align(center)[
    #text(size: 8.5pt, fill: luma(160), style: "italic")[
      Derrama *adicional* hacia negocios que hoy son invisibles para el turismo digital
    ]
  ]
]

#v(0.8em)
== KPIs clave

#table(
  columns: (1fr, auto, 1fr),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[KPI],
  text(weight: "bold", fill: white)[Meta demo],
  text(weight: "bold", fill: white)[Meta post-Mundial],

  [Negocios registrados], [20-30 (simulados)], [500+ reales],
  [Idiomas disponibles], [5], [13+],
  [Países con tema visual], [5], [32 (todos los del Mundial)],
  [Tiempo para encontrar un negocio], [< 3 min], [< 2 min],
  [Negocios con visitas semanales activas], [N/A (demo)], [70% del total],
)

#v(0.6em)
== Sostenibilidad post-hackathon

- *Operación:* Adoptable por Impact Hub CDMX u Ola México como herramienta oficial
- *Escalabilidad:* Rust + SurrealDB soporta crecimiento sin refactoring. Tauri permite publicar en App Store y Play Store sin cambiar código
- *Ecosistema:* Integración potencial con Coppel Emprende (financiamiento), SECTUR (validación oficial), Clip o Conekta (pagos)

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  8. EQUIPO Y ROLES
// ═══════════════════════════════════════════════════════════════════════════════

= Equipo y Roles

#table(
  columns: (auto, auto, 1fr, 1fr),
  stroke: 0.5pt + c-rule,
  fill: (_, row) => if row == 0 { c-dark } else if calc.even(row) { c-bg-soft } else { white },
  inset: 9pt,
  text(weight: "bold", fill: white)[Integrante],
  text(weight: "bold", fill: white)[Rol],
  text(weight: "bold", fill: white)[Responsabilidades],
  text(weight: "bold", fill: white)[Entregables],

  [#link("https://github.com/Yrrrrrf")[Fernando Bryan Reza Campos]],
  [Líder / Full-stack],
  [Integración cliente-servidor, soporte Backend y Frontend, pitch técnico],
  [SDK, integración, documentación, pitch],

  [
    #link("https://github.com/yoedAlv")[Yoed Eliel Alvarez Jimenez]\
    #link("https://github.com/jjjacob91xlx")[Raul Jacob Albarran Rivas]
  ],
  [Frontend / UI],
  [SvelteKit, rune-lab, UX, i18n, divisas, temas],
  [Interfaces turista y negocio con temas y multilenguaje],

  [
    #link("https://github.com/FernandoRL2311")[Fernando Ramirez Lopez]\
    #link("https://github.com/CyberBleyk")[John Alexander Martinez Garcia]
  ],
  [Base de Datos / Backend],
  [API Rust+Axum, SurrealDB, Arquitectura de datos],
  [Schema, consultas, funciones y conexión con cliente],
)

#v(0.6em)
== Forma de trabajo

- *Control de versiones:* Git con ramas por feature — #link("https://github.com/Yrrrrrf/xibalba")[github.com/Yrrrrrf/xibalba]
- *Metodología:* Mini-sprints de 4 horas durante el hackathon presencial
- *Comunicación:* Canal dedicado en Discord + tablero Kanban simple
- *Documentación:* Generada con Typst (este documento) y README en el repositorio

#pagebreak()

// ═══════════════════════════════════════════════════════════════════════════════
//  ANEXOS Y REFERENCIAS
// ═══════════════════════════════════════════════════════════════════════════════

= Anexos y Referencias

- Impact Hub CDMX. (2026). _Ola México — Iniciativa Oficial_. #link("https://olamexico.org/#iniciativa")
- Fundación Coppel. (2026). _Coppel Emprende_. #link("https://coppelemprende.com")
- Genius Arena. (2026). _Track oficial — Fundación Coppel 2026_. #link("https://hackathon.genius-arena.com/hackathon/fundacion-coppel-2026/")
- Genius Arena. (2026). _Challenge Talent Hackathon 2026_. #link("https://app2.genius-arena.com/challenge/23/talent-hackathon-2026")
- Talent Network. (2026). _Talent Land México 2026_. #link("https://www.talent-land.mx")
- Tauri Apps. (2026). _Tauri Framework_. #link("https://tauri.app")
- Svelte. (2026). _SvelteKit_. #link("https://kit.svelte.dev")
- SurrealDB. (2026). _SurrealDB_. #link("https://surrealdb.com")
- inlang. (2026). _Paraglide i18n_. #link("https://inlang.com/m/gerre34r/library-inlang-paraglideJs")
- Dinero.js. (2026). _DineroJS_. #link("https://dinerojs.com")
- Rune-Lab. (2026). _Repositorio del proyecto_. #link("https://github.com/Yrrrrrf/rune-lab")
