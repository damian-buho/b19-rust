<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Кеш збирання sccache

- Кожен виклик `rustc` прозоро кешується через sccache.
- Обирається через `B19_COMPILE_CACHE=sccache` (типово); можна вимкнути.
- Кеш може жити на диску або на віддаленому Redis-бекенді.
- Статистика кешу записується в журнал наприкінці кожного етапу компіляції.

<!-- textlint-enable -->
