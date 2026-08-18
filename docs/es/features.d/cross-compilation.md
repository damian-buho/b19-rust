<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Compilación cruzada a múltiples arquitecturas

- Una sola compilación puede emitir binarios para varias arquitecturas (por defecto amd64, arm64, riscv64) como binarios musl totalmente estáticos.
- Cada objetivo recibe su propia cadena de herramientas cruzada: enlazadores cross-gcc, cabeceras cross-libc y el objetivo musl de `rust-std`.
- Los flags exclusivos del host se eliminan para las arquitecturas que no son el host, de modo que no rompan el paso de enlazado cruzado.

<!-- textlint-enable -->
