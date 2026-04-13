
ARG B19_COMPILE_CACHE=sccache
ARG B19_COMPILE_CACHE_REDIS
ARG B19_GROUP=rust
ARG B19_UBUNTU_SERIES=questing
ARG B19_UBUNTU_VERSION=0
ARG B19_USER="${B19_GROUP}"
ARG SOURCE_DOCKER_REGISTRY=registry.example.com

FROM ${SOURCE_DOCKER_REGISTRY}/b19/ubuntu/${B19_UBUNTU_SERIES}:${B19_UBUNTU_VERSION} AS b19-rust

ARG B19_COMPILE_CACHE
ARG B19_COMPILE_CACHE_REDIS
ARG B19_GROUP
ARG B19_VERBOSITY
ARG B19_USER
ARG LANG
ARG M6E_AI=N
ARG M6E_APT_CACHE_HOST
ARG M6E_APT_CACHE_PORT
ARG M6E_NEAR_CACHE_HOST
ARG M6E_NAMESPACE
ARG M6E_PROJECT
ARG M6E_VERSION
ARG TARGETARCH

ENV B19_BUILD_PROC_RATIO=0.8                            \
    B19_COMPILE_CACHE=${B19_COMPILE_CACHE}              \
    B19_COMPILE_CACHE_PATH=/compile-cache               \
    B19_COMPILE_CACHE_REDIS=${B19_COMPILE_CACHE_REDIS}  \
    B19_GROUP=${B19_GROUP}                              \
    B19_USER=${B19_USER}                                \
    CARGO_HOME=${B19_HOME}/.cargo                       \
    CARGO_INCREMENTAL=0                                 \
    CARGO_INSTALL_ROOT="${B19_BIN_PATH}"                \
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse


WORKDIR ${B19_HOME}

USER root

COPY --chown=${B19_UID}:${B19_GID} .container/base/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                 \
    --mount=type=cache,target=${B19_COMPILE_CACHE_PATH},sharing=private \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=private      \
    --mount=type=cache,target=${CARGO_HOME},sharing=private             \
    --mount=type=cache,target=/var/cache/apt,sharing=private            \
    --mount=type=cache,target=/var/lib/apt,sharing=private              \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                          \
    build-stage base

USER ${B19_USER}

COPY --chown=${B19_UID}:${B19_GID} .container/user/ /

RUN --mount=type=bind,from=fetch,source=.,target=/fetch                                               \
    --mount=type=cache,target=${B19_DOWNLOAD_PATH},sharing=private,uid=${B19_UID},gid=${B19_GID}      \
    --mount=type=cache,target=${B19_COMPILE_CACHE_PATH},sharing=private,uid=${B19_UID},gid=${B19_GID} \
    --mount=type=tmpfs,target=${B19_TEMP_PATH}                                                        \
    build-stage user

# ENTRYPOINT ["entrypoint.d"] is inherited
# HEALTHCHECK CMD ["healthcheck.d"] is inherited
# Don't use CMD ["sleep", "infinity"] here