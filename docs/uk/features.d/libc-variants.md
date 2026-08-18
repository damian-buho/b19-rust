<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Варіанти libc: GNU і musl

- Два варіанти збирання обираються віссю `B19_RUST_LIBC`: `gnu` і `musl`; образ публікується як `b19/rust-{libc}`.
- Варіант `musl` робить musl типовою ціллю компіляції, тож кожен похідний `cargo build` видає статичні musl-бінарники без додаткових прапорців.

<!-- textlint-enable -->
