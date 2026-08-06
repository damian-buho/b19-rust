#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

  set -eou pipefail

  EXPECTED_VERSION=$(decomment < "/deps/rust/version.deps") || exit 1
  ACTUAL_VERSION=$(get-rust-version)

  [ "${EXPECTED_VERSION}" != "${ACTUAL_VERSION}" ] && exit 1 || exit 0
