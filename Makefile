# M6E MAKEFILE T2

-include .makefile/m6e/initialize.mk
-include .makefile/rust/initialize.mk

export B19_UBUNTU_SERIES=noble

all: .makefile/m6e/initialize.mk
	$(MAKE) pipeline

.makefile/m6e/initialize.mk:
	git submodule update --init --recursive
	$(MAKE) bootstrap
