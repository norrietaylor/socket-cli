#!/bin/sh
set -e

# The release tarball is the native `pnpm` binary plus the `dist/` payload
# (node-gyp, bundled JS) it resolves relative to its own path.
install -d "$OUTPUT_DIR/usr/bin" "$OUTPUT_DIR/usr/libexec/pnpm"
cp -R pnpm dist "$OUTPUT_DIR/usr/libexec/pnpm/"
chmod +x "$OUTPUT_DIR/usr/libexec/pnpm/pnpm"
ln -s ../libexec/pnpm/pnpm "$OUTPUT_DIR/usr/bin/pnpm"
cat > "$OUTPUT_DIR/usr/bin/pnpx" <<'SH'
#!/bin/sh
exec /usr/libexec/pnpm/pnpm dlx "$@"
SH
chmod +x "$OUTPUT_DIR/usr/bin/pnpx"
