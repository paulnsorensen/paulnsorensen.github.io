#!/usr/bin/env sh
# Vendor @cheeselord/design's stylesheets and fonts into this repo.
#
# This site is served by GitHub Pages straight from the branch: no build step,
# no node_modules at serve time. So the package's files are committed here, and
# this script is the only thing allowed to write them. Run it, commit the diff.
#
#   ./scripts/sync-design.sh            # re-vendor the pinned version
#   ./scripts/sync-design.sh 0.5.0      # move the pin and re-vendor
#
# The pin lives in styles/vendor/.design-version. CI runs this with no argument
# and fails if the working tree changes, which is what makes a stale vendored
# copy a build failure instead of a silent divergence.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
pin="$root/styles/vendor/.design-version"

version=${1:-}
if [ -z "$version" ]; then
  [ -f "$pin" ] || { echo "no version pinned at $pin, and none given" >&2; exit 1; }
  version=$(tr -d ' \n' < "$pin")
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

echo "vendoring @cheeselord/design@$version"
tarball=$(cd "$work" && npm pack "@cheeselord/design@$version" --silent)
tar -xzf "$work/$tarball" -C "$work"
pkg="$work/package"

[ -d "$pkg/dist/styles" ] || { echo "$version has no dist/styles" >&2; exit 1; }

# dist/styles/*.css reference fonts as ../../assets/fonts/*, so mirroring the
# package layout at styles/vendor/ resolves them to this repo's own assets/fonts.
rm -rf "$root/styles/vendor"
mkdir -p "$root/styles/vendor"
cp -R "$pkg/dist/styles/." "$root/styles/vendor/"
mkdir -p "$root/assets/fonts"
cp -R "$pkg/assets/fonts/." "$root/assets/fonts/"
cp "$pkg/LICENSE" "$root/styles/vendor/LICENSE"
[ -f "$pkg/NOTICE" ] && cp "$pkg/NOTICE" "$root/styles/vendor/NOTICE"

printf '%s\n' "$version" > "$pin"
echo "vendored $(find "$root/styles/vendor" -name '*.css' | wc -l | tr -d ' ') stylesheets at $version"
