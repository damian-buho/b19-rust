# Makefile Targets

## Bootstrap

### `check-is-compose-plugin-installed`

Check if Compose Plugin is installed

> Source: m6e/compose/commands.mk

### `check-is-docker-installed`

Check if Docker is installed

> Source: m6e/container.mk

### `check-docker-version`

Check Docker Engine version

> Source: m6e/container.mk

### `check-buildah-installed`

Check if buildah is installed

> Source: m6e/container/backends/buildah.mk

### `check-is-buildx-plugin-installed`

Check if BuildX Plugin is installed

> Source: m6e/container/backends/buildx.mk

### `check-binfmt`

Check if QEMU binfmt support is available for cross-arch builds

> Source: m6e/container/backends/buildx.mk

### `check`

Run all system requirement checks

> Source: m6e/core/080-check.mk

### `check-yq-version`

Check if yq v4 (mikefarah) is installed

> Source: m6e/core/080-check.mk

### `check-jq-installed`

Check if jq is installed

> Source: m6e/core/080-check.mk

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

### `dc-down`

Stop and remove Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-down-v`

Stop and remove Docker Compose services and volumes

> Source: m6e/compose/commands.mk

### `dc-logs`

View logs of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-logs-f`

Follow logs of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-ps`

List Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-restart`

Restart Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-start`

Start stopped Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-stop`

Stop running Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-top`

Display the running processes of Docker Compose services

> Source: m6e/compose/commands.mk

### `dc-up`

Bring up Docker Compose services (foreground)

> Source: m6e/compose/commands.mk

### `dc-up-d`

Bring up Docker Compose services (detached)

> Source: m6e/compose/commands.mk

### `w-dc-ps`

Watch a list of Docker Compose services

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

## Build

### `build`

Build docker image (dispatches to configured backend)

> Source: m6e/container/010-build.mk

### `build-nc`

Build docker image without cache

> Source: m6e/container/010-build.mk

### `build-push`

Build and push image to registry

> Source: m6e/container/010-build.mk

### `ensure-ssh-agent`

Ensure that ssh-agent is running

> Source: m6e/container/080-ssh-agent.mk

### `build-with-buildah`

Build with buildah + project.yaml

> *Internal target*

> Source: m6e/container/backends/buildah.mk

### `build-push-with-buildah`

Build with buildah and push to registry

> *Internal target*

> Source: m6e/container/backends/buildah.mk

### `build-with-buildah-nc`

Build with buildah without cache

> *Internal target*

> Source: m6e/container/backends/buildah.mk

### `build-with-buildx`

Build with BuildX (cached)

> *Internal target*

> Source: m6e/container/backends/buildx.mk

### `build-with-buildx-nc`

Build with BuildX (no cache)

> *Internal target*

> Source: m6e/container/backends/buildx.mk

### `build-push-with-buildx`

Build with BuildX and push to registry

> *Internal target*

> Source: m6e/container/backends/buildx.mk

## Container

### `read-lineage`

Get the lineage of the Docker container

> Source: m6e/container/020-container.mk

### `read-health`

Read the health status of the Docker container

> Source: m6e/container/020-container.mk

### `healthcheck.d`

Check the healthcheck of the Docker container

> Source: m6e/container/020-container.mk

### `test.d`

Run tests in the Docker container

> Source: m6e/container/020-container.mk

### `report.d`

Generate a report from the Docker container

> Source: m6e/container/020-container.mk

### `exec-shell`

Open a shell in the running Docker container

> Source: m6e/container/020-container.mk

### `run-shell`

Open a shell in the new Docker container

> Source: m6e/container/020-container.mk

### `inspect`

Inspect the Docker container

> Source: m6e/container/020-container.mk

## Fetch

### `fetch`

Pre-download all external dependencies

> Source: m6e/container/040-fetch.mk

### `fetch-clean`

Remove pre-downloaded files

> Source: m6e/container/040-fetch.mk

## I18N

### `i18n-extract`

Extract translatable strings into .pot template

> Source: m6e/container/050-i18n.mk

### `i18n-init-LANG`

Initialize new language (usage: make i18n-init-LANG LANG=uk)

> Source: m6e/container/050-i18n.mk

### `i18n-update`

Update .po files from .pot template

> Source: m6e/container/050-i18n.mk

### `i18n-compile`

Compile .po files into .mo binaries

> Source: m6e/container/050-i18n.mk

### `i18n-stats`

Show translation statistics per language

> Source: m6e/container/050-i18n.mk

## Image

### `get-history`

Get $(M6E_CONTAINER_RUNTIME) history of image

> Source: m6e/container/060-image.mk

### `inspect-image`

Call inspect on docker image

> Source: m6e/container/060-image.mk

### `docker-image-remove`

Remove the locally built Docker image

> Source: m6e/container/060-image.mk

### `docker-image-list`

List local Docker images matching this project

> Source: m6e/container/060-image.mk

## Network

### `check-docker-network`

Ensure the Docker network exists

> Source: m6e/container/070-network.mk

### `remove-docker-network`

Remove the Docker network

> Source: m6e/container/070-network.mk

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

## Workflow

### `clean`

Shut down all containers and remove volumes

> Source: m6e/workflow/clean.mk

### `test`

Run all registered test targets

> Source: m6e/workflow/test.mk
