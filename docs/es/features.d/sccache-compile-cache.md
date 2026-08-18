<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Caché de compilación sccache

- Cada invocación de `rustc` se cachea de forma transparente mediante sccache.
- Seleccionado con `B19_COMPILE_CACHE=sccache` (por defecto); puede desactivarse.
- La caché puede vivir en disco o en un backend Redis remoto.
- Las estadísticas de caché se registran al final de cada etapa de compilación.

<!-- textlint-enable -->
