**Dependencies** define how expectations relate to each other. By declaring dependencies, the compiler can:
* validate that dependency thresholds are sensible (e.g., a service can't promise 99.99% availability if it hard-depends on a service with only 99% availability)
* generate and maintain a dependency map / system diagram

Dependencies are declared in the optional `Assumes:` section of an expectation, listing one prose-style line per dependency.

**Dependency Types:**

| Type | Description |
|------|-------------|
| hard | Critical dependency: if it fails, this service fails |
| soft | Non-critical: service continues in a degraded state |

**Syntax:**

Each dependency is its own line. Mix and match `hard` and `soft` as needed:

```
"checkout":
  Assumes:
    hard dependency on "org.team.service.upstream_slo"
    soft dependency on "org.team.service.cache_slo"
  Guarantees 99.9% over 30d window as measured by "api_availability" with: {}
```

**Dependency References:**

Targets use dot-separated paths matching the expectation file structure: `ORG.TEAM.SERVICE.EXPECTATION_NAME`

**Validation:**

The compiler validates dependencies at compile time:
- All referenced targets must exist
- No circular dependency chains
- Hard-dependency threshold ceiling: an expectation's `Guarantees N%` cannot exceed the composite availability of its hard dependencies
- Hard-dependency type alignment: a `time_slice` expectation cannot hard-depend on a `success_rate` (and vice versa)
- Hard-dependency latency monotonicity: a `time_slice` expectation's `below <duration>` cannot be tighter than any of its hard dependencies'

> The example shows an expectation with both hard and soft dependencies declared in an `Assumes:` block.
