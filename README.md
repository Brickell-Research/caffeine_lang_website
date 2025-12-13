# caffeine_lang_website

[![Package Version](https://img.shields.io/hexpm/v/caffeine_lang_website)](https://hex.pm/packages/caffeine_lang_website)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/caffeine_lang_website/)

```sh
gleam add caffeine_lang_website@1
```
```gleam
import caffeine_lang_website

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/caffeine_lang_website>.

## Development

```sh
gleam run -m build  # Build the site to ./docs
gleam test          # Run the tests
```

## Updating the Cafe Compiler

To update the Caffeine compiler in the cafe:

```sh
./scripts/update_compiler.sh
```

This fetches the latest version from `../caffeine`, rebuilds the browser bundle, and rebuilds the site.
