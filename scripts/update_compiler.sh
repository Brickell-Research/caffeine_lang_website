#!/bin/bash
# Update the Caffeine compiler bundle for the website

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CAFFEINE_REPO="${CAFFEINE_REPO:-$PROJECT_DIR/../caffeine}"

echo "Updating Caffeine compiler for website..."

# 1. Fetch and update version
echo "Fetching version..."
VERSION=$("$SCRIPT_DIR/fetch_version.sh")
echo "  Version: $VERSION"

# 2. Build browser bundle
echo "Building browser bundle..."
cd "$CAFFEINE_REPO"
./scripts/bundle-browser.sh

# 3. Copy bundle to website
echo "Copying bundle to website..."
cp "$CAFFEINE_REPO/dist/caffeine-browser.js" "$PROJECT_DIR/static/js/"

# 4. Rebuild website
echo "Rebuilding website..."
cd "$PROJECT_DIR"
gleam run -m build

echo ""
echo "Done! Caffeine $VERSION is now available in the playground."
