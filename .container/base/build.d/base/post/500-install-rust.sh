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