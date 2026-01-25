**Artifacts** are defined within the **Caffeine** compiler. They specify required inputs via an attribute name, attribute type pair. I.E. a param for `queries` with the type of a `Dict` of key and value typed `String` would look like:

```json
queries: Dict(String, String)
```

These then, upon compilation, generate an artifact which might be `.terraform` files for _service level objectives, a pdf of a system diagram, or something else.

> continue reading to learn more about the specific artifacts currently supported by Caffeine

<br>

## Current Artifacts

To see the latest catalog of available artifacts along with their definitions, use the `artifacts` command locally with the caffeine cli.

_Don't yet have the cli?_ Install via homebrew:

```bash
brew tap Brickell-Research/caffeine

brew install caffeine_lang
```

And then verify:

```bash
caffeine version
```

Finally, to see the latest supported artifacts type:

```bash
caffeine artifacts
```

At time of writing you will see:
```bash
Artifact Catalog
================

SLO
  "A Service Level Objective that monitors a metric query against a threshold over a rolling window."

  queries
    type: Dict(String, String)
    required
  threshold
    type: Float { x | x in ( 0.0..100.0 ) }
    required
  value
    type: String
    required
  vendor
    type: String { x | x in { datadog } }
    required
  window_in_days
    type: Defaulted(Integer, 30) { x | x in { 30, 7, 90 } }
    default: 30

DependencyRelations
  "Declares soft and hard dependencies between services for dependency mapping."

  relations
    type: Dict(String { x | x in { hard, soft } }, List(String))
    required
```
