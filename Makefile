.PHONY: build serve clean deps build-watch fetch-version

# Fetch latest Caffeine version from GitHub
fetch-version:
	./scripts/fetch_version.sh

# Build the static site
build: deps fetch-version
	gleam run -m build

# Serve the site locally
serve: build
	gleam run -m serve

# Watch for changes and rebuild (requires: brew install fswatch)
build-watch:
	@echo "Watching for changes... (Ctrl+C to stop)"
	@fswatch -o src/ static/ content/ posts/ documentation/ stdlib/ | xargs -n1 -I{} make build

# Clean build artifacts
clean:
	rm -rf build
	rm -rf priv/*.html
	rm -rf priv/blog
	rm -rf priv/about
