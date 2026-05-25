#!/usr/bin/env bash
#
# Deploy the generated shulker-preview packs into the local Minecraft install:
#   - "Resource Pack" + "Dark Theme" zips -> resourcepacks/
#   - "Data Pack" zip                     -> saves/<world>/datapacks/
#
# Copies (does not move) so the repo keeps its committed zips. Re-run after
# regenerating with script.py to refresh the in-game copies.
#
# Usage:
#   ./deploy-packs.sh [version] [world]
#     version  pack version folder to deploy from   (default: 26.1)
#     world    save folder for the data pack         (default: "Block Dump")
#
set -euo pipefail

VERSION="${1:-26.1}"
WORLD="${2:-Block Dump}"

# Resolve the repo's <version>/ directory relative to this script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../$VERSION"

MC="$HOME/Library/Application Support/minecraft"
RESOURCEPACKS="$MC/resourcepacks"
DATAPACKS="$MC/saves/$WORLD/datapacks"

fail() { echo "ERROR: $*" >&2; exit 1; }

[ -d "$SRC" ]           || fail "pack source not found: $SRC"
[ -d "$RESOURCEPACKS" ] || fail "resourcepacks folder not found: $RESOURCEPACKS"
[ -d "$DATAPACKS" ]     || fail "world datapacks folder not found: $DATAPACKS (is the world name right?)"

# Locate the three zips by their stable name fragments (version-agnostic).
resource_zip="$(find "$SRC" -maxdepth 1 -name '*Resource Pack*.zip' | head -1)"
dark_zip="$(find "$SRC" -maxdepth 1 -name '*Dark Theme*.zip' | head -1)"
data_zip="$(find "$SRC" -maxdepth 1 -name '*Data Pack*.zip' | head -1)"

[ -n "$resource_zip" ] || fail "no Resource Pack zip in $SRC (run script.py first)"
[ -n "$data_zip" ]     || fail "no Data Pack zip in $SRC (run script.py first)"

cp "$resource_zip" "$RESOURCEPACKS/"
echo "resourcepack -> $RESOURCEPACKS/$(basename "$resource_zip")"

if [ -n "$dark_zip" ]; then
   cp "$dark_zip" "$RESOURCEPACKS/"
   echo "dark theme   -> $RESOURCEPACKS/$(basename "$dark_zip")"
fi

cp "$data_zip" "$DATAPACKS/"
echo "datapack     -> $DATAPACKS/$(basename "$data_zip")"

echo
echo "Done. In-game: select the resource pack in Options, and run /datapack list (or /reload) in \"$WORLD\"."
