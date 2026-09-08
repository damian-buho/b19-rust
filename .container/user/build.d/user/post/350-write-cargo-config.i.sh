#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  # shellcheck source=/dev/null
  . b19-i18n

  # Write ${CARGO_HOME}/config.toml in the USER stage, where CARGO_HOME is NOT
  # a --mount=type=cache target (the base stage at Dockerfile:48 shadows it, so
  # a write there is ephemeral and never ships in the image layer). We are
  # trying to make the build-target + cross-linker config survive into the
  # final image so cargo picks it up at runtime without a manual --target.

  _arch_to_rust_triple() {
    case "${1}" in
      amd64)   printf "x86_64-unknown-linux-%s"   "${2}" ;;
      arm64)   printf "aarch64-unknown-linux-%s"  "${2}" ;;
      riscv64) printf "riscv64gc-unknown-linux-%s" "${2}" ;;
    esac
  }

  _arch_to_cross_gcc() {
    case "${1}" in
      amd64)   printf "" ;;
      arm64)   printf "aarch64-linux-gnu-gcc" ;;
      riscv64) printf "riscv64-linux-gnu-gcc" ;;
    esac
  }

  mkdir -p "${CARGO_HOME}"

  if [ "${B19_RUST_LIBC}" = "musl" ]; then
    HOST_TRIPLE="$(_arch_to_rust_triple "${TARGETARCH}" "musl")"
    printf '%s\n' '[build]' "target = \"${HOST_TRIPLE}\""      \
      > "${CARGO_HOME}/config.toml"

    CROSS_VARIANT="${B19_RUST_CROSS_VARIANT:-musl}"
    for CROSS_ARCH in ${B19_RUST_CROSS_TARGETS:-}; do
      [ "${CROSS_ARCH}" = "${TARGETARCH}" ] && continue
      CROSS_TRIPLE="$(_arch_to_rust_triple "${CROSS_ARCH}" "${CROSS_VARIANT}")"
      CROSS_GCC="$(_arch_to_cross_gcc "${CROSS_ARCH}")"
      if [ -n "${CROSS_GCC}" ]; then
        printf '\n[target.%s]\nlinker = "%s"\n' "${CROSS_TRIPLE}" "${CROSS_GCC}"      \
          >> "${CARGO_HOME}/config.toml"
        b19-log good "RUSTCROSS" "$(_p "Configured linker for %s: %s" "${CROSS_TRIPLE}" "${CROSS_GCC}")"
        if [ "${CROSS_ARCH}" = "riscv64" ]; then
          # Mirror build-rust-from-deps baseline so cargo build also emits
          # portable code for RISE C910 (RV64IMAFDC_Zicsr_Zifencei).
          if [ -n "${B19_RUST_RISCV64_RUSTFLAGS:-}" ]; then
            _RISCV_RUSTFLAGS="${B19_RUST_RISCV64_RUSTFLAGS}"
          else
            _RISCV_CPU="${B19_RUST_RISCV64_TARGET_CPU:-generic-rv64}"
            _RISCV_FEATURES="${B19_RUST_RISCV64_TARGET_FEATURES:-+m,+a,+f,+d,+c,+zicsr,+zifencei}"
            _RISCV_RUSTFLAGS="-C target-cpu=${_RISCV_CPU} -C target-feature=${_RISCV_FEATURES}"
          fi
          _RUSTFLAGS_ARGS="${_RISCV_RUSTFLAGS} -C link-arg=-lm -C target-feature=+crt-static"
          _RUSTFLAGS_TOML=""
          # shellcheck disable=SC2086
          for _arg in ${_RUSTFLAGS_ARGS}; do
            if [ -z "${_RUSTFLAGS_TOML}" ]; then
              _RUSTFLAGS_TOML="\"${_arg}\""
            else
              _RUSTFLAGS_TOML="${_RUSTFLAGS_TOML}, \"${_arg}\""
            fi
          done
          printf 'rustflags = [%s]\n' "${_RUSTFLAGS_TOML}" >> "${CARGO_HOME}/config.toml"
          b19-log good "RUSTCROSS" "$(_p "Configured rustflags for %s: %s" "${CROSS_TRIPLE}" "${_RUSTFLAGS_ARGS}")"
        fi
      fi
    done
  else
    rm -f "${CARGO_HOME}/config.toml"
  fi
