# XIBALBÁ

> **Motor de Sistema de Inventario**
>
> ![Status](https://img.shields.io/badge/Status-Alpha_MVP-green)
> ![Stack](https://img.shields.io/badge/Stack-SvelteKit_|_Deno_|_Rust_|_SurrealDB-blue)
> ![Plataformas](https://img.shields.io/badge/Plataformas-Web_|_Escritorio_|_Móvil-purple)

**Xibalbá** es un motor integral para la gestión de inventarios multiplataforma
diseñado para ofrecer una experiencia rápida, segura y altamente escalable. Fue
concebido desde cero para funcionar de manera nativa y fluida en la web,
escritorio y dispositivos móviles.

## ¿Qué puede hacer Xibalbá?

El ecosistema de Xibalbá abarca diferentes perspectivas y necesidades operativas
de inventario y comercialización:

- **Gestión y Control B2B:** Actúa como el centro de mando administrativo.
  Facilita las altas, bajas y modificaciones de recursos, el rastreo de
  movimientos, generación de reportes en PDF y creación de etiquetas para
  distribución.
- **Exploración Pública B2C:** Interface orientada a la vista pública. Los
  usuarios finales pueden navegar por perfiles comerciales e identificar
  disponibilidades a través de potentes buscadores y mapas geolocalizados
  interactivos.
- **Visión y Telemetría Avanzada:** Un entorno dedicado a monitorear la salud
  global del sistema en tiempo real y desplegar reconstrucciones virtuales 3D de
  áreas y capacidades físicas del inventario.

## Arquitectura de Alto Nivel

Para respaldar su potencia en cualquier dispositivo, Xibalbá implementa una
estricta separación de responsabilidades cliente-servidor, que confía en
herramientas de última generación:

- **Cliente Universal:** Interfaz de usuario rica y reactiva cimentada en
  **Svelte 5** sobre un entorno de trabajo **Deno**. Empaquetada con **Tauri**,
  la aplicación web se transforma instantáneamente en binarios nativos sin
  comprometer la velocidad ni la consistencia del diseño.
- **Motor en Rust:** La validación lógica, manipulación de reportes y servidor
  HTTP central están potenciados por **Rust**, lo que brinda máxima fiabilidad.
  Este núcleo se compila parcialmente a _WebAssembly (WASM)_ para sincronizar
  automáticamente el comportamiento con el navegador.
- **SurrealDB:** Actúa como la única fuente de la verdad del sistema; una
  solución avanzada que colapsa la gestión relacional, documental espacial y de
  grafos en un clúster unificado.

> 🛠️ **¿Buscas el funcionamiento interno?** Para conocer las normativas de
> código, directorios, manejo de estados, inyección de dependencias web y
> detalles profundos sobre nuestro setup técnico, consulta el documento de
> [Arquitectura Técnica](./docs/technical/architecture.md).


## Licencia

Este proyecto se distribuye bajo la licencia [Apache 2.0](./LICENSE).

---

_© 2026 Proyecto Xibalbá_
