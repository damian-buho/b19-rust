# M6E MAKEFILE T2

export B19_RUST_LIBC    ?= gnu

M6E_CONTAINER_NAME = $(subst /,-,${NAMESPACE})-${PROJECT}-$(B19_RUST_LIBC)
M6E_IMAGE_BASENAME = ${NAMESPACE}/${PROJECT}-$(B19_RUST_LIBC)

M6E_DOCKER_BUILDX_OPTIONS += --build-arg B19_RUST_LIBC

AXIS_NAME   := B19_RUST_LIBC
AXIS_VALUES := gnu musl

-include .makefile/m6e/initialize.mk
-include .makefile/rust/initialize.mk

all: .makefile/m6e/initialize.mk
	$(MAKE) pipeline-all

.makefile/m6e/initialize.mk:
	git submodule update --init --recursive
	$(MAKE) bootstrap
