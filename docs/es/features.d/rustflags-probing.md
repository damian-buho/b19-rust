<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Sondeo de RUSTFLAGS por flag y por arquitectura

- Cada flag candidato se sondea contra el `rustc` instalado; solo se exportan los flags que acepta la cadena de herramientas.
- Esto hace las imágenes portables entre versiones de Rust y arquitecturas de CPU sin mantener flags a mano.
- amd64 apunta al conjunto de funciones x86-64-v3; arm64 apunta a las extensiones Armv8.x por generación.
- Los flags no soportados se descartan silenciosamente y nunca provocan un fallo de compilación.
- Mecanismo completo, archivos de flags y listas de candidatos por arquitectura: ver [flags dinámicos del compilador](../flags.md).

<!-- textlint-enable -->
