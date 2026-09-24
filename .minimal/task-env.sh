# Sourced by every task in .minimal/minimal.toml.
#
# A task runs in a throwaway copy of the tree, so each one hydrates and
# installs from scratch. /state persists per state_key: keeping HOME and the
# pnpm store there makes a warm run take seconds. The pnpm store holds the
# global virtual store (enableGlobalVirtualStore) that node_modules links
# into. A task's own $HOME does not exist and cannot be created, and fleet
# scripts write ~/.socket.
export HOME=/state/home
export pnpm_config_store_dir=/state/data/pnpm-store
# Tasks never commit; skip the fleet git hooks.
export HUSKY=0
# Hydrate the untracked fleet payload (scripts/fleet/**) from ghcr.io, then
# install. This is the same path CI takes (.github/actions/fleet/install).
node scripts/repo/bootstrap/prepare.mts --pipeline >/tmp/prepare.log 2>&1 \
  || { cat /tmp/prepare.log; exit 1; }
