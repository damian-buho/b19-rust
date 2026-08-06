<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

# sccache compile cache

- Every `rustc` invocation is transparently cached by sccache.
- Selected by `B19_COMPILE_CACHE=sccache` (default); can be turned off.
- The cache can live on disk or on a remote Redis backend.
- Cache statistics are logged at the end of every compile stage.
