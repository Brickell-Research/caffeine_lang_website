#!/bin/bash
# Bundle the Honeycomb OpenTelemetry SDK into a single JS file
set -e

cd "$(dirname "$0")/../honeycomb"
npx esbuild honeycomb.js --bundle --format=iife --outfile=../static/js/honeycomb.js --minify
echo "Honeycomb bundle built successfully."
