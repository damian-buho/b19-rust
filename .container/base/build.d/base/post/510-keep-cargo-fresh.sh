#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT


  HOST_TRIPLE="$(rustc -vV | sed -n 's/host: //p')"
  PKG_CONFIG_ALLOW_CROSS=1 b19-run "RUST" "$(_ "Upgrade cargo from crates.io")" --      \
    cargo install cargo --force --target "${HOST_TRIPLE}"
