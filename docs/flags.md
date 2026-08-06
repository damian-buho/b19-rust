<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# Dynamic Compiler Flags

`b19/rust` probes each `RUSTFLAGS` entry at build time and exports only those
accepted by the installed `rustc`. This makes images portable across Rust
toolchain versions and CPU architectures without manual flag maintenance.

## How it works

During any build stage that includes `compile-rust`, the pre-hook
`.container/build.d/compile-rust/pre/100-setup-build.i.sh` sources `setup-build`,
which performs two steps:

1. **Job count** — reads `B19_BUILD_PROC_RATIO`, multiplies by `nproc`, exports
    `CARGO_BUILD_JOBS=<N>` (minimum 1).

1. **RUSTFLAGS probing** — concatenates all `flags.d/*.flags` files through
    `decomment`, then compiles a minimal `fn main() {}` with each flag individually via `RUSTFLAGS="<FLAG>" rustc dummy.rs -o /tmp/dummy-out`. Accepted flags are written to `all.txt`; rejected ones are logged as `BAD`. The surviving set is joined with spaces and exported as `RUSTFLAGS`.

Both variables are exported into the shell environment so every subsequent
`cargo` invocation in the same build stage inherits them. `CARGO_BUILD_JOBS` is
not set as a static `ENV` in the Dockerfile — it is computed fresh on each build.

## Flag files

Flag files live in `.container/base/flags/` and are `COPY`'d into the image:

```text
.container/base/flags/
└── .rustflags/
    ├── amd64/flags.d/
    │   ├── 010-linker.flags    # -C link-arg=-fuse-ld=mold
    │   ├── 020-strip.flags     # -C strip=symbols
    │   └── 040-features.flags  # x86-64-v3 ISA feature set (probed individually)
    └── arm64/flags.d/
        ├── 010-linker.flags    # -C link-arg=-fuse-ld=mold
        ├── 020-strip.flags     # -C strip=symbols
        └── 030-features.flags  # Armv8.x extensions (probed individually)
```

File format: one flag per line; `#` introduces a comment (stripped by
`decomment`). empty lines are ignored.

```text
-C target-feature=+avx2             # AVX2 (x86-64-v3)
-C link-arg=-fuse-ld=mold           # Use mold linker (faster; filtered if mold absent)
```

Files are processed in alphabetical order, so the numeric prefix controls
evaluation order. Linker flags are probed first (`010-`) so mold is present when
later flags are tested.

### amd64 — x86-64-v3 feature set

`040-features.flags` lists the 17 individual ISA features that together define the
x86-64-v3 microarchitecture level: the v1 baseline (sse, sse2), v2 additions
(sse3, ssse3, sse4.1, sse4.2, popcnt, cmpxchg16b), and v3 additions (avx, avx2,
bmi1, bmi2, f16c, fma, lzcnt, movbe, xsave).

Each feature is probed independently. On a host where some v3 features are
absent (VM, emulator, older CPU), the prober silently drops them.

There is no `-C target-cpu=x86-64-v3` entry — using individual feature flags
gives finer granularity and avoids all-or-nothing rejection by `rustc`.

### arm64 — per-generation Armv8.x features

aarch64 has no equivalent versioned baseline. `030-features.flags` lists features
by Armv8 generation (crc at 8.0, lse/rdm at 8.1, dotprod at 8.2, lse2 at 8.4).
Unsupported ones are silently dropped at probe time, making the image portable
across Graviton, Ampere, and Apple Silicon builds.

There is no `-C target-cpu=` entry for arm64 — hardware diversity makes a single
CPU name counterproductive.

## Adding a flag

Add a line to the relevant `flags.d/*.flags` file. If `rustc` rejects the flag,
`setup-build` will log it as not supported and skip it — no build breakage.

## Customising in a downstream image

A downstream `FROM b19/rust` image can override flag files by placing replacement
files in `.container/base/flags/.rustflags/<arch>/flags.d/` and re-running `COPY .container/ /`before the `compile-rust` stage.

## Variables exported

| Variable           | Set by      | Description                         |
| ------------------ | ----------- | ----------------------------------- |
| `RUSTFLAGS`        | setup-build | Accepted rustc flags (space-joined) |
| `CARGO_BUILD_JOBS` | setup-build | Job count based on nproc × ratio    |
