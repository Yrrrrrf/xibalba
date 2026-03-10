# XIBALBÁ

> **The Inventory System Engine**
>
> ![Status](https://img.shields.io/badge/Status-Alpha_MVP-green)
> ![Stack](https://img.shields.io/badge/Stack-SvelteKit_|_Deno_|_SurrealDB-blue)
> ![Architecture](https://img.shields.io/badge/Arch-Client_Server-purple)

**Xibalbá** is a project that is being developed to be used in the inventory
system. It leverages a modern, streamlined architecture to deliver
high-performance inventory management and visualization.

## Architecture

Xibalbá implements a modernized **Client-Server Architecture**, using Deno
Workspaces and connecting SvelteKit clients directly to a robust SurrealDB
backend.

![Architecture Diagram](./docs/technical/architecture.md)

## Ecosystem

The repository is a Deno Monorepo split between client apps and shared SDK
packages, backed by a localized database setup.

### **Apps**

Specific client applications tailored for different operational contexts:

- **Agent**: The command center and administrative interface for managing
  inventory and operations. Built via **Vite** and packaged with **Tauri**, it
  leverages SvelteKit SSR/SSG combinations to deploy as a native application for
  Desktop (Windows, macOS, Linux) and Mobile (iOS, Android).
- **Explorer**: The public-facing or user-centric interface for discovering
  inventory.
- **Vision**: The telemetry deck and visualization tool for monitoring system
  health and tracking data in real-time.

### **Shared Packages (SDK)**

- **`@sdk/ui`**: A unified visual language built with Svelte 5, TailwindCSS, and
  DaisyUI. Change the brand once, update every app.
- **`@sdk/core`**: Core utilities, domain logic, and configurations linking the
  applications together.
- **`@sdk/state`**: Centralized state management ensuring synchronized data
  across all application views.

## Philosophy

1. **Streamlined Stack:** Utilizing SurrealDB consolidates the database and API
   layer into a single, highly capable backend infrastructure.
2. **Modular Frontend:** Splitting concerns into localized apps while sharing a
   strong core SDK ensures stability, consistency, and type safety across the
   ecosystem.
3. **Data is Immutable Truth:** The database schema and structure dictate the
   valid states of the UI.

---

_© 2026 Xibalbá Project._
