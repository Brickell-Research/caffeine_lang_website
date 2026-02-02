A **blueprint** is a common, partially specified abstraction over one or more artifacts. It may `provide` for the `requires` from one or more artifacts it inherits from and then specify some `requires` of its own.

It may **not** override any `requires` from its inherited artifacts, nor specify `provides` for its own `requires` or `requires` that don't exist.

**Basic Syntax:**

```
Blueprints for "<ArtifactName>"
  * "<blueprint_name>":
    Requires { <params_expectations_must_provide> }
    Provides { <values_this_blueprint_fulfills> }
```

**Note:** `Requires` must come before `Provides` in blueprints. The compiler enforces this ordering.

**Blocks:**

| Block      | Contains    | Purpose                                              |
|------------|-------------|------------------------------------------------------|
| `Requires` | Types only  | Parameters that expectations must provide values for |
| `Provides` | Values only | Fulfilled values that all expectations inherit       |

**Multi-Artifact Blueprints:**

A blueprint can implement multiple artifacts using `+`. Parameters from all artifacts are merged:

```
Blueprints for "SLO" + "DependencyRelations"
  * "tracked_slo":
    Requires { ... }  # Params from both artifacts
    Provides { ... }  # Values for both artifacts
```

As stated in the `DependencyRelations` lesson, this is _the only way_ to leverage `DependencyRelations` artifacts at this time.

**Template Variables:**

Use `$$var$$` syntax in indicator strings for value interpolation:

| Syntax             | Meaning        | Example Output   |
|--------------------|----------------|------------------|
| `$$var$$`          | Raw value      | `production`     |
| `$$var->attr$$`    | Key-value pair | `env:production` |
| `$$var->attr:not$$`| Negated pair   | `!status:true`   |

This is how the compiler leverages the parameters it collects to interpolate into the indicators for the final artifact output.

> In the example below, notice how both `service_name` and `excluded_service_name` are leveraged within both indicators and the value specified by the expectation is interpolated in the output.