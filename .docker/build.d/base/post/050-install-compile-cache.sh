#!/usr/bin/env bash

  if [ "${B19_COMPILE_CACHE}" = "off" ]; then
    b19-log warn "BUILD" "$(_ "Compile cache: off")"
    return
  fi

  if [ "${B19_COMPILE_CACHE}" = "ccache" ]; then
    b19-log bad "BUILD" "$(_ "ccache does not support Rust, disabling compile cache")"
    return
  fi

  cd "${B19_TEMP_PATH}" || exit

  eval "$(b19-resolve-dep sccache "${TARGETARCH}")"

  b19-fetch "SCCACHE" "${M6E_UPSTREAM__URL}" "${M6E_UPSTREAM__FILE}" "${M6E_UPSTREAM__HASH}"

  b19-run "SCCACHE" "$(_p "Extract %s" "${M6E_UPSTREAM__FILE}")" \
    tar --extract                     \
        --strip-components=1          \
        --file                        \
        "${B19_TEMP_PATH}/${M6E_UPSTREAM__FILE}"

  b19-run "SCCACHE" "$(_ "Install sccache")" \
    install -m 0755 sccache /usr/local/bin/sccache
