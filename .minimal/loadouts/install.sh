#!/bin/sh
# Install this repo's Minimal developer loadouts. Run on the host, not in a
# session: loadouts are read by `min` from the host config dir.
#
#   sh .minimal/loadouts/install.sh          install (refuses to overwrite a changed file)
#   sh .minimal/loadouts/install.sh --force  overwrite
set -eu
src=$(cd "$(dirname "$0")" && pwd)
dest="${XDG_CONFIG_HOME:-$HOME/.config}/minimal/loadouts"
force=${1:-}
mkdir -p "$dest"
for f in "$src"/*.toml; do
  name=$(basename "$f")
  if [ -e "$dest/$name" ] && ! cmp -s "$f" "$dest/$name" && [ "$force" != "--force" ]; then
    echo "skip $name: $dest/$name differs (re-run with --force to overwrite)" >&2
    continue
  fi
  cp "$f" "$dest/$name"
  echo "installed $dest/$name"
done
echo "Activate: min session activate --loadout socket-fleet"
