#!/bin/bash
# Bundle the CodeMirror-based Caffeine editor into a single ES module
set -e

cd "$(dirname "$0")/../editor"
npx esbuild caffeine-editor.js --bundle --format=esm --outfile=../static/js/caffeine-editor.js --minify
echo "Editor bundle built successfully."
