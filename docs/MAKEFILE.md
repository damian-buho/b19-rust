# Makefile Targets

## CI

### `lint`

Run all linters (continues on failure, exits non-zero if any failed)

> Source: m6e/ci/lint.mk

### `check-outdated`

Check all outdated dependencies (continues on failure, exits non-zero if any failed)

> Source: m6e/ci/outdated.mk

## Bootstrap

### `check-is-compose-plugin-installed`

Check if Compose Plugin is installed

> Source: m6e/compose/commands.mk

### `check-is-old-compose-installed`

Check for old docker-compose

> Source: m6e/compose/commands.mk

### `check`

Run all system requirement checks

> *Internal target*

> Source: m6e/core/200-check.mk

### `check-is-docker-installed`

Check if Docker is installed

> Source: m6e/docker.mk

### `check-docker-version`

Check Docker Engine version

> Source: m6e/docker.mk

### `check-is-buildx-plugin-installed`

Check if BuildX Plugin is installed

> Source: m6e/docker/build.mk

### `check-binfmt`

Check if QEMU binfmt support is available for cross-arch builds

> Source: m6e/docker/build.mk

### `check-buildah-installed`

Check if buildah is installed

> Source: m6e/docker/buildah.mk

### `check-yq-installed`

Check if yq is installed

> Source: m6e/docker/buildah.mk

### `check-jq-installed`

Check if jq is installed

> Source: m6e/docker/buildah.mk

### `bootstrap`

First-run actions

> Source: m6e/workflow/bootstrap.mk

### `custom-bootstrap-script`

Run bootstrap.sh if it exists

> Source: m6e/workflow/bootstrap.mk

## Compose

### `dc-config`

Show config Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-up`

Bring up Docker Compose services (foreground)

> Source: m6e/compose/commands.mk

### `dc-up-d`

Bring up Docker Compose services (detached)

> Source: m6e/compose/commands.mk

### `dc-down`

Stop and remove Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-down-v`

Stop and remove Docker Compose services and volumes

> Source: m6e/compose/commands.mk

### `dc-ps`

List Docker Compose services

> Source: m6e/compose/commands.mk

### `w-dc-ps`

Watch a list of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-top`

Display the running processes of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-start`

Start stopped Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-stop`

Stop running Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-logs`

View logs of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-logs-f`

Follow logs of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-restart`

Restart Docker Compose services

> Source: m6e/compose/commands.mk

### `clean`

Shut down all containers and remove volumes

> Source: m6e/compose/commands.mk

### `pipeline`

Run the pipeline (clean + build + test + clean)

> Source: m6e/compose/pipeline.mk

### `pipeline-nc`

Run the pipeline without cache

> Source: m6e/compose/pipeline.mk

### `dev`

Development mode (build + up with logs)

> Source: m6e/compose/pipeline.mk

### `dev-nc`

Development mode without cache

> Source: m6e/compose/pipeline.mk

## Container

### `get-history`

Get docker history of image

> Source: m6e/docker/analyze.mk

### `inspect-image`

Call inspect on docker image

> Source: m6e/docker/analyze.mk

### `read-lineage`

Get the lineage of the Docker container

> Source: m6e/docker/container.mk

### `read-health`

Read the health status of the Docker container

> Source: m6e/docker/container.mk

### `healthcheck.d`

Check the healthcheck of the Docker container

> Source: m6e/docker/container.mk

### `test.d`

Run tests in the Docker container

> Source: m6e/docker/container.mk

### `report.d`

Generate a report from the Docker container

> Source: m6e/docker/container.mk

### `exec-shell`

Open a shell in the running Docker container

> Source: m6e/docker/container.mk

### `run-shell`

Open a shell in the new Docker container

> Source: m6e/docker/container.mk

### `inspect`

Inspect the Docker container

> Source: m6e/docker/container.mk

## Build

### `build-with-cache`

Build docker image with caching

> Source: m6e/docker/build.mk

### `build-no-cache`

Build docker image without caching

> Source: m6e/docker/build.mk

### `build`

Alias for build-with-cache

> Source: m6e/docker/build.mk

### `build-nc`

Alias for build-no-cache

> Source: m6e/docker/build.mk

### `buildah-build`

Build image using buildah + project.yaml

> Source: m6e/docker/buildah.mk

### `buildah-push`

Build image using buildah and push

> Source: m6e/docker/buildah.mk

### `buildah-build-nc`

Build image using buildah without cache

> Source: m6e/docker/buildah.mk

### `ensure-ssh-agent`

Ensure that ssh-agent is running

> Source: m6e/docker/ssh-agent.mk

## Fetch

### `fetch`

Pre-download all external dependencies

> Source: m6e/docker/fetch.mk

### `fetch-clean`

Remove pre-downloaded files

> Source: m6e/docker/fetch.mk

## I18N

### `i18n-extract`

Extract translatable strings into .pot template

> Source: m6e/docker/i18n.mk

### `i18n-init-LANG`

Initialize new language (usage: make i18n-init-LANG LANG=uk)

> Source: m6e/docker/i18n.mk

### `i18n-update`

Update .po files from .pot template

> Source: m6e/docker/i18n.mk

### `i18n-compile`

Compile .po files into .mo binaries

> Source: m6e/docker/i18n.mk

### `i18n-stats`

Show translation statistics per language

> Source: m6e/docker/i18n.mk

## Network

### `check-docker-network`

Ensure the Docker network exists

> Source: m6e/docker/network.mk

### `remove-docker-network`

Remove the Docker network

> Source: m6e/docker/network.mk

## Image

### `docker-image-remove`

Remove the locally built Docker image

> Source: m6e/docker/remove.mk

### `docker-image-list`

List local Docker images matching this project

> Source: m6e/docker/remove.mk

## Git

### `git-optimize`

Optimize the repository by running all cleanup and optimization tasks

> Source: m6e/git/git.mk

### `git-reflog-clean`

Clean up reflog

> Source: m6e/git/git.mk

### `git-disk-usage`

Disk usage of the repository

> Source: m6e/git/git.mk

### `git-fetch-prune-all`

Fetch and prune stale branches from all remotes

> Source: m6e/git/git.mk

### `git-fetch-prune`

Fetch and prune stale remote branches

> Source: m6e/git/git.mk

### `git-push-force-all`

Force push all branches to all remotes

> Source: m6e/git/git.mk

### `git-gc`

Garbage collection (includes pruning unreachable objects)

> Source: m6e/git/git.mk

### `git-list-remotes`

List all remotes and their URLs

> Source: m6e/git/git.mk

### `git-pack-refs`

Pack refs for efficiency

> Source: m6e/git/git.mk

### `git-push-current`

Push the current branch to all remotes

> Source: m6e/git/git.mk

### `git-push-all`

Push to all remotes

> Source: m6e/git/git.mk

### `git-rebuild-repo`

Rebuild repository (export/import)

> Source: m6e/git/git.mk

### `git-clean-ignored`

Remove all ignored files

> Source: m6e/git/git.mk

### `git-remove-merged`

Remove all merged local branches

> Source: m6e/git/git.mk

### `git-prune-tags`

Remove local tags not present on any remote

> Source: m6e/git/git.mk

### `git-clean-untracked`

Remove untracked files and directories

> Source: m6e/git/git.mk

### `git-repack`

Repack loose objects into packs

> Source: m6e/git/git.mk

### `git-reset-current`

Reset local branch to match its remote counterpart

> Source: m6e/git/git.mk

### `git-stats`

Show repository statistics

> Source: m6e/git/git.mk

### `git-verify`

Verify repository integrity

> Source: m6e/git/git.mk

### `git-pull-all`

Pull from all remotes

> Source: m6e/git/git.mk

### `git-submodules-pull-all`

Pull all git submodules

> Source: m6e/git/git.mk

## Help

### `help`

Show categorized help for all targets

> Source: m6e/meta/help.mk

### `m6e-generate-docs`

Generate markdown documentation

> Source: m6e/meta/help.mk

### `m6e-commit-docs`

Commit markdown documentation

> Source: m6e/meta/help.mk

### `did-you-know`

Show random tips from hints/

> *Internal target*

> Source: m6e/meta/help.mk

### `did-you-know`

Show random tips from hints/

> *Internal target*

> Source: m6e/meta/help.mk

## Meta

### `m6e-update`

Update global makefile

> Source: m6e/meta/m6e.mk

### `m6e-commit`

Commit global makefile

> Source: m6e/meta/m6e.mk

### `m6e-update-and-commit`

Update and commit global makefile

> *Internal target*

> Source: m6e/meta/m6e.mk
