#!/usr/bin/env bash

  case "${B19_COMPILE_CACHE}" in
    sccache) b19-log info "SCCACHE" "$(_p "stats: %s" "$(sccache --show-stats)")" ;;
    off)     b19-log bad  "BUILD"   "$(_p "Compile cache was disabled (%s), no stats" "${B19_COMPILE_CACHE}")"  ;;
    ccache)  b19-log bad  "BUILD"   "$(_p "Compile cache was disabled (%s), no stats" "${B19_COMPILE_CACHE}")"  ;;
  esac
