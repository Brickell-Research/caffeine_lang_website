.PHONY: build serve clean deps build-watch

# Build the static site
build: deps
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
