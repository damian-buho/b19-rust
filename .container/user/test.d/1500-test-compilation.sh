#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  set -eou pipefail

  # shellcheck source=/dev/null
  . b19-i18n

  TESTDIR=$(mktemp -d)
  trap 'rm -rf "${TESTDIR}"' EXIT

  # rustc direct
  RUST_VERSION=$(rustc --version | grep -oP '[0-9]+(?:\.[0-9]+)+')
  cat > "${TESTDIR}/hello.rs" << 'EOF'
fn main() {
    println!("ok");
}
EOF
  rustc -o "${TESTDIR}/hello_rustc" "${TESTDIR}/hello.rs"
  "${TESTDIR}/hello_rustc"
  b19-log good "RUST" "$(_p "rustc-%s compile test passed" "${RUST_VERSION}")"

  # cargo new + build + run
  CARGO_VERSION=$(cargo --version | grep -oP '[0-9]+(?:\.[0-9]+)+')
  cargo new --name hello_cargo "${TESTDIR}/hello_cargo"
  cargo build --manifest-path "${TESTDIR}/hello_cargo/Cargo.toml"
  # Run via cargo, not a hardcoded target/debug path: the musl variant sets a
  # build target in config.toml, so the artifact lands under target/<triple>/debug.
  cargo run --manifest-path "${TESTDIR}/hello_cargo/Cargo.toml" --quiet
  b19-log good "RUST" "$(_p "cargo-%s build test passed" "${CARGO_VERSION}")"
