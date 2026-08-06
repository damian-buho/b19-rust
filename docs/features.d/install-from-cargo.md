<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Declarative cargo install from a dep list

- List the crates to install in one dep file; each is installed `--locked`.
- Downstream images inherit the same declarative install with no extra wiring.
