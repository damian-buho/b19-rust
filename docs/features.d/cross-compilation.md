<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Cross-compilation to multiple architectures

- One build can emit binaries for several architectures (default amd64, arm64, riscv64) as fully static musl binaries.
- Each target gets its own cross toolchain: cross-gcc linkers, cross-libc headers and the musl `rust-std` target.
- Host-only flags are stripped for non-host arches so they do not break the cross link step.
