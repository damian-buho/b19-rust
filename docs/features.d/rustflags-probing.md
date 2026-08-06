<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Per-flag RUSTFLAGS probing per architecture

- Each candidate compiler flag is probed against the installed `rustc`; only flags the toolchain accepts are exported.
- This makes images portable across Rust versions and CPU architectures without manual flag maintenance.
- amd64 targets the x86-64-v3 feature set; arm64 targets per-generation Armv8.x extensions.
- Unsupported flags are silently dropped, never cause a build failure.
- Full mechanism, flag files and the per-arch candidate lists: see [dynamic compiler flags](../flags.md).
