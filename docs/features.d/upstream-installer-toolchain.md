<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Rust toolchain from the upstream installer

- Rust is installed from the official upstream tarball, not from rustup or apt.
- The version is pinned; per-arch URL and hash are resolved at build time.
- Cargo is rebuilt from crates.io for the host triple, so the shipped cargo is the current crates.io build.
