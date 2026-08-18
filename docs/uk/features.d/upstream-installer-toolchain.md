<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Інструментальний ланцюжок Rust з upstream-інсталятора

- Rust встановлюється з офіційного upstream-тарбола, а не з rustup чи apt.
- Версія зафіксована; URL-адреса та хеш для кожної архітектури розв’язуються під час збирання.
- Cargo перезбирається з crates.io для хостового триплета, тож постачаний cargo — це поточна збірка crates.io.

<!-- textlint-enable -->
