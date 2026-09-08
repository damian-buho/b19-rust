#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT


  cd "${B19_TEMP_PATH}" || exit

  eval "$(b19-resolve-dep rust "${TARGETARCH}")"

  b19-fetch "RUST" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

  b19-run "RUST" "$(_p "Extract %s" "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}")" --     \
    tar --extract                                                                     \
        --file "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}"                               \
        --strip-components 1                                                          \
        --use-compress-program pixz

  b19-run "RUST" "$(_ "Install")" --      \
    ./install.sh --without=rust-docs,rust-docs-json-preview

  _arch_to_rust_triple() {
    case "${1}" in
      amd64)   printf "x86_64-unknown-linux-%s"   "${2}" ;;
      arm64)   printf "aarch64-unknown-linux-%s"   "${2}" ;;
      riscv64) printf "riscv64gc-unknown-linux-%s"  "${2}" ;;
    esac
  }

  if [ "${B19_RUST_LIBC}" = "musl" ]; then
    eval "$(b19-resolve-dep rust-std-musl "${TARGETARCH}")"

    b19-fetch "RUST-STD-MUSL" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

    b19-run "RUST-STD-MUSL" "$(_p "Extract %s" "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}")" --      \
      tar --extract                                                                               \
          --file "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}"                                         \
          --strip-components 1                                                                    \
          --use-compress-program pixz

    b19-run "RUST-STD-MUSL" "$(_ "Install musl target")" --     \
      ./install.sh --without=rust-docs,rust-docs-json-preview

    # rust-src: std sources for the riscv64 -Z build-std rebuild in build-rust-from-deps
    eval "$(b19-resolve-dep rust-src)"

    b19-fetch "RUST-SRC" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

    b19-run "RUST-SRC" "$(_p "Extract %s" "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}")" --      \
      tar --extract                                                                         \
          --file "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}"                                   \
          --strip-components 1                                                              \
          --use-compress-program pixz

    b19-run "RUST-SRC" "$(_ "Install rust-src")" --     \
      ./install.sh

    # Install rust-std for cross-compilation targets (non-host arches)
    CROSS_VARIANT="${B19_RUST_CROSS_VARIANT:-musl}"
    CROSS_TARGETS="${B19_RUST_CROSS_TARGETS:-}"

    for CROSS_ARCH in ${CROSS_TARGETS}; do
      # Skip the host architecture — already installed above
      [ "${CROSS_ARCH}" = "${TARGETARCH}" ] && continue

      CROSS_TRIPLE="$(_arch_to_rust_triple "${CROSS_ARCH}" "${CROSS_VARIANT}")"
      CROSS_DEP_NAME="rust-std-${CROSS_VARIANT}"

      eval "$(b19-resolve-dep "${CROSS_DEP_NAME}" "${CROSS_ARCH}")"

      b19-fetch "RUSTCROSS" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

      b19-run "RUSTCROSS" "$(_p "Extract %s" "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}")" --      \
        tar --extract                                                                           \
            --file "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}"                                     \
            --strip-components 1                                                                \
            --use-compress-program pixz

      b19-run "RUSTCROSS" "$(_p "Install cross-target %s" "${CROSS_TRIPLE}")" --      \
        ./install.sh --without=rust-docs,rust-docs-json-preview
    done
  fi
  # config.toml is written in the user stage (user/post/350-write-cargo-config.i.sh)
  # where CARGO_HOME is not a cache mount — a write here would be ephemeral.
