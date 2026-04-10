# b19/rust — Features

> Inherits all features from [b19/ubuntu](../ubuntu/FEATURES.md): structured logging, safe execution, download caching, secrets, signal handling, health checks, entrypoint hooks, i18n, and more.
> Features below are what this image adds on top.

______________________________________________________________________

## Rust Toolchain (upstream installer, not APT)

- Rust is installed from the official upstream `.tar.xz` distribution, not the Ubuntu APT package.
- The version is pinned in `.container/base/deps/rust/version.txt`.
- The tarball is downloaded via `b19-fetch` with per-arch URL and SHA-512 hash verification.
- Both amd64 (`x86_64-unknown-linux-gnu`) and arm64 (`aarch64-unknown-linux-gnu`) tarballs are supported.
- The installer runs with `--without=rust-docs,rust-docs-json-preview` to keep image size down.
- With this image you don't have to: manage the upstream installer, hash verification, or arch-specific URL selection yourself.
- Customization: pin a specific release by editing `.container/base/deps/rust/version.txt`; supply per-arch SHA-512 hashes in `.container/base/deps/rust/{arch}.sha512`; override the download source via `SOURCE_DOCKER_REGISTRY` (used by `b19-fetch` cache tier).

______________________________________________________________________

## sccache Compiler Cache

- sccache is downloaded from the upstream musl-static release and installed to `/usr/local/bin/sccache`; `RUSTC_WRAPPER=/usr/local/bin/sccache` is set as an `ENV` so Cargo transparently routes all `rustc` invocations through sccache
- `SCCACHE_DIR=/sccache` is set; both build stages (`base` and `user`) mount `/sccache` as a BuildKit cache volume (`--mount=type=cache,sharing=private`), so the cache persists across builds without entering image layers
- After each compile stage, `sccache --show-stats` is logged via the `.i.` stats hook so cache hit rates are visible in build output
- With this image you don't have to: install sccache, set `RUSTC_WRAPPER`, wire up cache mounts, or add post-build stats logging
- Customization: override `RUSTC_WRAPPER` to an empty string to disable sccache for a specific build; override `SCCACHE_DIR` to redirect the cache

______________________________________________________________________

## Build Toolchain (gcc, make, pkg-config)

- APT packages `build-essential` and `pkg-config` are installed unconditionally.
- `build-essential` satisfies the C linker dependency that `cargo` requires for crates with native code (`cc`, `openssl-sys`, etc.).
- `pkg-config` is available for crates that probe system libraries at compile time.
- With this image you don't have to: add `build-essential` or `pkg-config` manually in every downstream Dockerfile that compiles crates with native dependencies.
- Customization: no env vars control this feature; additional system libraries can be added via `.container/base/deps/base/apt.*.txt` in child images.

______________________________________________________________________

## Cargo Environment Defaults

- `CARGO_HOME` is set to `${B19_HOME}/.cargo` so the registry cache and installed binaries live under the application user's home directory.
- `CARGO_INSTALL_ROOT` is set to `${B19_HOME}` so `cargo install` places binaries directly in `${B19_HOME}/bin`.
- `CARGO_INCREMENTAL=0` disables incremental compilation, which is not useful in Docker builds.
- `CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse` enables the sparse registry protocol, which is significantly faster for cold registry fetches.
- All variables are set as `ENV` in the Dockerfile and apply to every derived image automatically.
- With this image you don't have to: configure `CARGO_HOME`, `CARGO_INSTALL_ROOT`, `CARGO_INCREMENTAL`, or `CARGO_REGISTRIES_CRATES_IO_PROTOCOL` in every downstream Dockerfile.
- Customization: override any of these at build time with `--build-arg` or at runtime with `ENV`/`-e`; accepted values — `CARGO_INCREMENTAL`: `0` or `1`; `CARGO_REGISTRIES_CRATES_IO_PROTOCOL`: `sparse` or `git`; `CARGO_HOME` and `CARGO_INSTALL_ROOT`: any writable path.

______________________________________________________________________

## Compile-stage Setup Hook (`setup-build`)

- The `setup-build` script is copied into the image and called as a pre-hook in any downstream `compile-rust` build stage.
- It computes `CARGO_BUILD_JOBS` as `floor(nproc × B19_BUILD_PROC_RATIO)` (default ratio 0.8), scaling parallelism with available CPUs without saturating them.
- It probes every `RUSTFLAGS` entry from `flags.d/*.txt` individually against a dummy `fn main() {}` program.
- Only flags accepted by `rustc` are exported; unsupported flags are discarded silently.
- With this image you don't have to: compute CPU-scaled job counts or probe RUSTFLAGS compatibility manually in each downstream build stage.
- Customization: `B19_BUILD_PROC_RATIO` (float, default `0.8`) controls the CPU fraction used for `CARGO_BUILD_JOBS`; add or remove flags by editing `.container/base/flags/.rustflags/<arch>/flags.d/*.txt` in child images.

______________________________________________________________________

## Arch-specific RUSTFLAGS Probing

- Flag files in `.container/base/flags/.rustflags/<arch>/flags.d/` define desired compiler flags per architecture.
- For amd64: covers the mold linker, symbol stripping, and the full x86-64-v3 ISA feature set (17 individual features: SSE through AVX2, BMI1/2, FMA, etc.).
- For arm64: covers the mold linker, symbol stripping, and Armv8.x extensions (crc, lse, rdm, dotprod, lse2).
- Each flag is probed independently at build time by `setup-build` and dropped silently if unsupported.
- This makes the image portable across VMs, emulators, and hardware that does not implement all extensions.
- With this image you don't have to: maintain or probe per-arch RUSTFLAGS sets yourself.
- Customization: add, remove, or replace flags by placing `.txt` files under `.container/base/flags/.rustflags/amd64/flags.d/` or `.container/base/flags/.rustflags/arm64/flags.d/` in child images; each line is one flag and is probed independently at build time.

______________________________________________________________________

## Declarative Cargo Package Installation (`install-from-cargo`)

- The `install-from-cargo` script reads `/deps/cargo.txt` during the user build stage.
- It calls `cargo install --locked` for each package listed in the file.
- Child images declare binaries to install by placing a `cargo.txt` file in `.container/user/deps/user/` (or another stage directory).
- The script is idempotent: if the file is absent it logs a warning and exits cleanly.
- The installed Cargo cache is intentionally not cleaned after installation to preserve BuildKit layer reuse.
- With this image you don't have to: write explicit `cargo install` loops in every downstream Dockerfile.
- Customization: declare packages in `.container/user/deps/user/cargo.txt` (one `name[@version]` per line) in child images; the `STAGE` env var selects which deps directory is read (default `user`).

______________________________________________________________________

## Lineage Recording

- The user post-hook `990-write-lineage.sh` calls `write-lineage "b19/rust" "${M6E_UPSTREAM_VERSION}"` to record the exact Rust version into the image's lineage file.
- The lineage file is available at runtime and consumed by the `make read-lineage` target.
- Operators can determine the exact toolchain version baked into an image without inspecting environment variables or running `rustc --version`.
- With this image you don't have to: add a lineage recording step explicitly in every downstream image.
- Customization: no env vars control lineage recording; the recorded version is whatever `M6E_UPSTREAM_VERSION` resolves to at build time (set by the makefile from `.container/base/deps/rust/version.txt`).

______________________________________________________________________
