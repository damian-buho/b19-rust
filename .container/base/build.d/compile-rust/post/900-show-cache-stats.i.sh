#!/usr/bin/env bash

  case "${B19_COMPILE_CACHE}" in
    sccache) b19-log info "SCCACHE" "$(_p "stats: %s" "$(sccache --show-stats)")" ;;
    off)     b19-log bad  "BUILD"   "$(_ "Compile cache was disabled, no stats")"  ;;
    ccache)  b19-log bad  "BUILD"   "$(_ "Compile cache was disabled, no stats")"  ;;
  esac
