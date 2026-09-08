# SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
#
# SPDX-License-Identifier: MIT

ARG B19_COMPILE_CACHE=sccache
ARG B19_RUST_LIBC=gnu
ARG B19_UBUNTU_BASE_IMAGE=registry.invalid/b19/ubuntu/resolute:latest

FROM ${B19_UBUNTU_BASE_IMAGE} AS b19-rust

ARG B19_COMPILE_CACHE
ARG B19_RUST_LIBC
ARG B19_COLOR
ARG B19_FETCH_DOCKER_CACHE
ARG B19_FETCH_LOCAL_CACHE
ARG B19_OFFGRID_MODE
ARG B19_VERBOSITY
ARG LANG=""
ARG M6E_AI=N
ARG M6E_APT_CACHE_HOST=""
ARG M6E_APT_CACHE_PORT=""
ARG M6E_NAMESPACE
ARG M6E_NEAR_CACHE_HOST=""
ARG M6E_PROJECT
ARG M6E_VERSION
ARG TARGETARCH

ENV B19_BUILD_PROC_RATIO=0.8                                  \
    B19_COMPILE_CACHE=${B19_COMPILE_CACHE}                    \
    B19_COMPILE_CACHE_PATH=/compile-cache                     \
    B19_RUST_CROSS_TARGETS="amd64 arm64 riscv64"              \
    B19_RUST_CROSS_VARIANT="musl"                             \
    B19_RUST_LIBC=${B19_RUST_LIBC}                            \
    B19_RUST_RISCV64_TARGET_CPU="generic-rv64"                \
    B19_RUST_RISCV64_TARGET_FEATURES="+m,+a,+f,+d,+c,+zicsr,+zifencei" \
    CARGO_BUILD_BUILD_DIR=${XDG_CACHE_HOME}/.cargo-build      \
    CARGO_HOME=${B19_HOME}/.cargo                             \
    CARGO_INCREMENTAL=0                                       \
    CARGO_INSTALL_ROOT="/usr/local"                           \
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse                \
    M6E_PROJECT="${M6E_PROJECT}-${B19_RUST_LIBC}"


WORKDIR ${B19_HOME}

USER 0

COPY --chown=${B19_UID}:${B19_GID} .container/base/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                                         \
    --mount=type=cache,id=apt-cache-${B19_UBUNTU_SERIES}-${TARGETARCH},target=/var/cache/apt,sharing=shared      \
    --mount=type=cache,id=apt-lists-${B19_UBUNTU_SERIES}-${TARGETARCH},target=/var/lib/apt,sharing=shared        \
    --mount=type=cache,id=cargo-build-${B19_RUST_LIBC},target=${XDG_CACHE_HOME}/.cargo-build,sharing=locked     \
    --mount=type=cache,id=cargo-home-${B19_RUST_LIBC},target=${CARGO_HOME},sharing=locked                       \
    --mount=type=cache,target=${B19_COMPILE_CACHE_PATH},sharing=shared                                          \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared,uid=${B19_UID},gid=${B19_GID}                 \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                                  \
    build-stage base

# hadolint ignore=DL3066 # B19_UID comes from the root
USER ${B19_UID}

COPY --chown=${B19_UID}:${B19_GID} .container/user/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                                   \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=shared,uid=${B19_UID},gid=${B19_GID}           \
    --mount=type=cache,target=${B19_COMPILE_CACHE_PATH},sharing=shared,uid=${B19_UID},gid=${B19_GID}      \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                            \
    build-stage user

# ENTRYPOINT ["entrypoint.d"] is inherited
# HEALTHCHECK CMD ["healthcheck.d"] is inherited
# Don't use CMD ["sleep", "infinity"] here
