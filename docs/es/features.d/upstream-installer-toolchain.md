<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Cadena de herramientas Rust desde el instalador upstream

- Rust se instala desde el tarball oficial upstream, no desde rustup ni apt.
- La versión está fijada; la URL y el hash por arquitectura se resuelven en tiempo de compilación.
- Cargo se recompila desde crates.io para el triple del host, de modo que el cargo incluido es la compilación actual de crates.io.

<!-- textlint-enable -->
