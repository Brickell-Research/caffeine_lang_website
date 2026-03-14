An **expectation** is the instantiation or "complete providing for" the combined requirements of its measurement and its measurement's SLO parameters. It only has a `provides` block and _must_ specify the totality of all `requires` from the chain it inherits.

It may not override any `provides` from its inherited SLO parameters, nor specify `provides` for `requires` that don't exist.

**Basic Syntax:**

```
Expectations measured by "<MeasurementName>"
  "<expectation_name>":
    Provides { <all_required_values> }
```

**File Location:**

Expectation files follow a meaningful path structure:
- Path: `expectations/ORG/TEAM/SERVICE.caffeine`
- Example: `expectations/acme/payments/checkout.caffeine`

This path becomes part of the expectation's identity and is used in cross-file references. Furthermore, SLO parameters will append tags which can then be used to filter and partition `SLOs` within the vendor's UI:

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
