An **expectation** is the instantiation or "complete providing for" the combined requirements of its measurement and its measurement's SLO parameters. It declares a `Guarantees ...` clause that carries the threshold, window, and (optionally) a reference to the measurement plus its parameter values via `with: {...}`. An optional `Assumes:` section declares dependencies.

The expectation _must_ specify the totality of all `Requires` from the chain it inherits, may not override any field from an inherited extendable, and may not introduce parameters that the measurement doesn't declare.

**Basic Syntax:**

```
"<expectation_name>":
  Guarantees <threshold>% over <window> window as measured by "<MeasurementName>" with: {
    <all_required_values>
  }
```

For expectations with no backing measurement (e.g. third-party SLAs), omit the `as measured by ... with: ...` tail:

```
"<expectation_name>":
  Guarantees 99.95% over 30d window
```

To declare dependencies between expectations:

```
"<expectation_name>":
  Assumes:
    hard dependency on "org.team.service.upstream_slo"
    soft dependency on "org.team.service.cache_slo"
  Guarantees 99.9% over 30d window as measured by "M" with: {}
```

**File Location:**

Expectation files follow a meaningful path structure:
- Path: `expectations/ORG/TEAM/SERVICE.caffeine`
- Example: `expectations/acme/payments/checkout.caffeine`

This path becomes part of the expectation's identity and is used in cross-file references. Furthermore SLO parameters may surface some of this information. As an example, Caffeine will append tags which can then be used to filter and partition `SLOs` within the vendor's UI:

```
# for the above filepath
tags = [
  "org: Acme",
  "team: payments",
  "service: checkout"
]
```

**Validation:**

The compiler validates expectations at compile time:
- All required parameters must be provided
- Values must match the types declared in the measurement
- Expectation references must point to valid targets
- Circular dependencies are rejected
- Expectation names must be unique within a file

> Try removing the `service_name: "hello-world"` line and notice the compilation error.
