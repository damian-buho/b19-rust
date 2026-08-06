#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  case "${B19_COMPILE_CACHE:-sccache}" in
    sccache) b19-log info "SCCACHE" "$(_p "stats: %s" "$(sccache --show-stats)")" ;;
    off)     b19-log bad  "BUILD"   "$(_p "Compile cache was disabled (%s), no stats" "${B19_COMPILE_CACHE}")"  ;;
    ccache)  b19-log bad  "BUILD"   "$(_p "ccache is not supported for Rust (%s), no stats" "${B19_COMPILE_CACHE}")"  ;;
  esac
