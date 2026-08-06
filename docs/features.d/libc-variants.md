<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# GNU and musl libc variants

- Two build variants are selected by the `B19_RUST_LIBC` axis: `gnu` and `musl`; the image is published as `b19/rust-{libc}`.
- The `musl` variant sets musl as the default compile target, so every downstream `cargo build` emits static musl binaries with no extra flags.
