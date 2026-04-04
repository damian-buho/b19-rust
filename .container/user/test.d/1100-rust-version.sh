#!/usr/bin/env bash

  EXPECTED_VERSION=$(cat "/deps/rust/version.txt") || exit 1
  ACTUAL_VERSION=$(rustc --version | grep -oP '[0-9]+\.[0-9]+\.[0-9]+')

  [ "${EXPECTED_VERSION}" != "${ACTUAL_VERSION}" ] && exit 1 || exit 0
