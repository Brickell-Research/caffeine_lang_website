A **measurement** is a common, partially specified abstraction over one or more SLO parameters. It may `provide` for the `requires` from one or more SLO parameters it inherits from and then specify some `requires` of its own. Its purpose is to fulfill the subset of SLO parameters specific to measuring an SLO, i.e. the `indicators` (or queries) and the `evaluation` (or how the queries are evalutated).

It may **not** override any `requires` from its inherited SLO parameters, nor specify `provides` for its own `requires` or `requires` that don't exist.

**Basic Syntax:**

```
"Measurement_Name":
  Requires { <params_expectations_must_provide> }
  Provides { <values_this_measurement_fulfills> }
```

**Note:** `Requires` must come before `Provides` in measurements. The compiler enforces this ordering.

**Blocks:**

| Block      | Contains    | Purpose                                              |
|------------|-------------|------------------------------------------------------|
| `Requires` | Types only  | Parameters that expectations must provide values for |
| `Provides` | Values only | Fulfilled values that all expectations inherit       |

**Template Variables:**

Use `$$var$$` syntax in indicator strings for value interpolation:

| Syntax               | Meaning        | Example Output   |
|----------------------|----------------|------------------|
| `$$var$$`            | Raw value      | `production`     |
| `$$header->var$$`    | Key-value pair | `env:production` |
| `$$header->var:not$$`| Negated pair   | `!status:true`   |

This is how the compiler leverages the parameters it collects to interpolate into the indicators for the final SLO parameter output.

> In the example below, notice how both `service_name` and `excluded_service_name` are leveraged within both indicators and the value specified by the expectation is interpolated in the output.