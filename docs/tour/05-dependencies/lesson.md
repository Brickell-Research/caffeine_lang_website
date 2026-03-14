**Dependencies** define how expectations relate to each other. By declaring dependencies, the compiler can:
* validate that dependency thresholds are sensible (e.g., a service can't promise 99.99% availability if it hard-depends on a service with only 99% availability)
* generate and maintain a dependency map / system diagram

Dependencies are declared via the optional `depends_on` field within an expectation's `Provides` block.

**Dependency Types:**

| Type | Description |
|------|-------------|
| hard | Critical dependency — if it fails, this service fails |
| soft | Non-critical — service continues in a degraded state |

**Syntax:**

Both `hard` and `soft` are optional within `depends_on`. You can specify just one or both:

```
depends_on: { hard: ["org.team.service.expectation_name"] }
depends_on: { soft: ["org.team.service.expectation_name"] }
depends_on: {
  hard: ["org.team.service.dep1"],
  soft: ["org.team.service.dep2"]
}
```

**Dependency References:**

Targets use dot-separated paths matching the expectation file structure: `ORG.TEAM.SERVICE.EXPECTATION_NAME`

**Validation:**

The compiler validates dependencies at compile time:
- All referenced targets must exist
- No circular dependency chains
- Hard dependency threshold ceiling — a service's threshold cannot exceed the composite availability of its hard dependencies

> The example shows an expectation with a dependency declared via `depends_on`.
