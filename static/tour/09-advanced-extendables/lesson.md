**Extendables** are reusable blocks that enable common `Requires` or `Provides` attributes to be specified once and used many times. They live near the top of files, beneath type aliases and above blueprints/expectations.

**Syntax:**

```
# Declaration
_name (Kind): { field: value, ... }

# Usage
* "blueprint_name" extends [_name1, _name2]:
```

**Two Kinds of Extendables:**

| Kind         | Contains          | Allowed In                      |
|--------------|-------------------|---------------------------------|
| `(Requires)` | Type declarations | Blueprint files only            |
| `(Provides)` | Literal values    | Blueprint and expectation files |

**Rules:**

- Names must start with an underscore (`_`)
- Names must be unique within the file
- File-scoped only (cannot reference across files)
- Can reference type aliases defined in the same file

**In Blueprint Files:**

```
_common_req (Requires): { env: String, window_in_days: Integer }
_base_slo (Provides): { vendor: "datadog" }

Blueprints for "SLO"
  * "api_availability" extends [_base_slo, _common_req]:
    Requires { threshold: Float }
    Provides { value: "numerator / denominator" }
```

**In Expectation Files:**

Expectations can only use `(Provides)` extendables:

```
_defaults (Provides): { env: "production", window_in_days: 30 }
_strict (Provides): { threshold: 99.99, window_in_days: 7 }

Expectations for "api_availability"
  * "critical_service" extends [_defaults, _strict]:
    Provides { status: true }
```

**Merge Order:**

When extending multiple extendables, later ones override earlier ones. In the example above, `_strict` overrides the `window_in_days` from `_defaults`.
