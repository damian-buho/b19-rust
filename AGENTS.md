<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# b19/rust

Docker image built on [b19/Ubuntu](../ubuntu/AGENTS.md)

Rust toolchain image. Used as builder for minijinja, gleam, nginx (acme module), and rust-tools (d9t).

## Key facts

- Base: `b19/ubuntu/noble` (hardcoded — not resolute)
- Installed from upstream installer (not rustup, not apt)
- Variants: `gnu`, `musl` (axis: `B19_RUST_LIBC`)
- Image name: `b19/rust-{libc}`
- Pinned version: check `.container/base/deps/rust/version.deps`

## What it provides

- `CARGO_INSTALL_ROOT="/usr/local"` (system-wide binaries)
- `CARGO_INCREMENTAL=0`, `CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse`
- sccache via `RUSTC_WRAPPER`; intercepts `rustc`
- RUSTFLAGS probed per-flag per arch (17 CPU feature flags on amd64)
- `install-from-cargo` tool — reads `cargo.deps` dep file, calls `cargo install --locked`
- `build-rust-from-deps` tool — reads `build.cargo.deps`, cross-builds for all arches in `B19_RUST_CROSS_TARGETS`

## sccache deletes environment variables

sccache drops `SOURCE_DATE_EPOCH`, `PWD`, `HOSTNAME`, `LD_PRELOAD`, `DESTDIR`,
`CARGO_MAKEFLAGS` and the `RPM_*` names from the environment it gives to
`rustc`. The denylist is in sccache `src/cmdline.rs`: such names would poison a
cache key that many machines share. A crate that expands
`env!("SOURCE_DATE_EPOCH")` therefore fails to compile, although the build stage
exports the variable. Compile that one call without sccache —
`env --unset=RUSTC_WRAPPER cargo install …` — and the rest of the image keeps
its cache.

## musl variant

Sets `config.toml` default build target to `{arch}-unknown-linux-musl`. All `cargo build` in downstream stages produce musl binaries without extra flags.

## Cross-compilation

The musl variant supports cross-compilation to `amd64`, `arm64`, and `riscv64` from a single builder, mirroring `b19/go`'s `CGO_ENABLED=0` pattern:

- `B19_RUST_CROSS_TARGETS="amd64 arm64 riscv64"` — arches to cross-build
- `B19_RUST_CROSS_VARIANT="musl"` — target libc (hardcoded for now)
- Installs `rust-std` for all musl targets + cross-gcc linkers (`gcc-aarch64-linux-gnu`, `gcc-riscv64-linux-gnu`)
- Produces fully static musl binaries — no libc dependency at runtime
- `build.cargo.deps` dep file triggers cross-build via `build-rust-from-deps`, outputting `<binary>.<arch>` files

## Inheritable hooks

`compile-rust/` hooks are `.i.` — downstream `compile-rust` stages inherit: `setup-build` (RUSTFLAGS probe, job count), `install-from-cargo`, `build-rust-from-deps`, lineage reading, sccache stats.

## Documentation

- [Available make targets](@docs/MAKEFILE.md)
- [Dynamic compiler flags and probing](@docs/flags.md)
