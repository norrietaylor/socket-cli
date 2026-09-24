#!/bin/sh
# One-time session setup: run `sh .minimal/session-setup.sh` after attaching.
# The socket-fleet loadout (.minimal/loadouts/) runs it on activation. It is
# not a project hook because tasks compose project session hooks too.
set -e
cd /workbench
# The fleet git hooks (.git-hooks/_shared/resolve-node.sh) exit 1 unless the
# wheelhouse pnpm launcher exists. Here pnpm comes from the pnpm12 package.
mkdir -p "$HOME/.socket/_wheelhouse/bin"
ln -sf /usr/bin/pnpm "$HOME/.socket/_wheelhouse/bin/pnpm"
# Hydrate the untracked fleet payload (scripts/fleet/**) from ghcr.io and
# install, the way CI does (.github/actions/fleet/install).
node scripts/repo/bootstrap/prepare.mts --pipeline
