#!/usr/bin/env bash


  cd "${B19_TEMP_PATH}" || exit

  eval "$(b19-resolve-dep rust "${TARGETARCH}")"

  b19-fetch "RUST" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

  b19-run "RUST" "$(_p "Extract %s" "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}")" \
    tar --extract                     \
        --strip-components=1          \
        --file                        \
        "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}";

  b19-run "RUST" "$(_ "Install")"   \
    ./install.sh --without=rust-docs,rust-docs-json-preview

  #FIXME Should be a separate hook
  # Install musl target stdlib and configure default build target
  if [ "${B19_RUST_LIBC}" = "musl" ]; then
    eval "$(b19-resolve-dep rust-std-musl "${TARGETARCH}")"

    b19-fetch "RUST-STD-MUSL" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

    b19-run "RUST-STD-MUSL" "$(_p "Extract %s" "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}")" \
      tar --extract                     \
          --strip-components=1          \
          --file                        \
          "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}";

    b19-run "RUST-STD-MUSL" "$(_ "Install musl target")" \
      ./install.sh --without=rust-docs,rust-docs-json-preview

    # Set default cargo build target to musl
    _arch="${TARGETARCH}"
    case "${_arch}" in
      amd64) _arch=x86_64 ;;
      arm64) _arch=aarch64 ;;
    esac
    mkdir -p "${CARGO_HOME}"
    printf '[build]\ntarget = "%s-unknown-linux-musl"\n' "${_arch}" \
      > "${CARGO_HOME}/config.toml"
  fi
