An **expectation** is the instantiation or complete providing for the combined requirements of its blueprint and its blueprint's artifacts. It only has a `Provides` block and _must_ specify the totality of all `Requires` from the chain it inherits.

It may not override any `Provides` from its inherited artifacts, nor specify `Provides` for `Requires` that don't exist.

**Basic Syntax:**

```
Expectations for "<BlueprintName>"
  * "<expectation_name>":
    Provides { <all_required_values> }
```

**File Location:**

Expectation files follow a meaningful path structure:
- Path: `expectations/ORG/TEAM/SERVICE.caffeine`
- Example: `expectations/acme/payments/checkout.caffeine`

This path becomes part of the expectation's identity and is used in cross-file references.

**Validation:**

The compiler validates expectations at compile time:
- All required parameters must be provided
- Values must match the types declared in the blueprint
- Expectation references must point to valid targets
- Circular dependencies are rejected

