# M6E MAKEFILE T1

-include .makefile/m6e/initialize.mk
-include .makefile/rust/initialize.mk

SOURCE_DOCKER_REGISTRY		?= registry.example.com
DESTINATION_DOCKER_REGISTRY	?= registry.example.com

NAMESPACE	?= b19
PROJECT		?= rust

all: .makefile/m6e/initialize.mk
	$(MAKE) pipeline

.makefile/m6e/initialize.mk:
	@git submodule update --init --recursive
	@$(MAKE) bootstrap

-include 	.makefile/m6e/docker.mk
-include 	.makefile/m6e/compose.mk
include 	.makefile/project/*.mk