<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Крос-компіляція на кілька архітектур

- Одне збирання може видавати бінарники для кількох архітектур (типово amd64, arm64, riscv64) як повністю статичні musl-бінарники.
- Кожна ціль отримує власний крос-ланцюжок: лінкери cross-gcc, заголовки cross-libc і musl-ціль `rust-std`.
- Прапорці, специфічні для хоста, зрізаються для нехостових архітектур, щоб не ламати крок крос-лінкування.

<!-- textlint-enable -->
