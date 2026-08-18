<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Variantes de libc GNU y musl

- Dos variantes de compilación seleccionadas por el eje `B19_RUST_LIBC`: `gnu` y `musl`; la imagen se publica como `b19/rust-{libc}`.
- La variante `musl` fija musl como objetivo de compilación por defecto, de modo que cada `cargo build` derivado emite binarios musl estáticos sin flags extra.

<!-- textlint-enable -->
