# M6E MAKEFILE T1

-include .makefile/m6e/initialize.mk
-include .makefile/rust/initialize.mk

all: .makefile/m6e/initialize.mk
	$(MAKE) pipeline

.makefile/m6e/initialize.mk:
	git submodule update --init --recursive
	$(MAKE) bootstrap

-include 	.makefile/m6e/docker.mk
-include 	.makefile/m6e/compose.mk
include 	.makefile/project/*.mk