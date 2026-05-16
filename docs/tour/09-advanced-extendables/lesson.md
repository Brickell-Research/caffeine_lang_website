**Extendables** are reusable blocks that enable common `requires` or `provides` attributes to be specified once and used many times. They live near the top of files, beneath type aliases and above measurements/expectations - this is not just a recommendation, it is asserted by the compiler. Extendables are useful for defining common patterns and deduplicating measurement and expectation definitions. 

As we like to say [_"caffeinate but stay dry!"_](https://www.reddit.com/r/barista/comments/2gl8wu/are_any_of_you_fans_of_dry_cappuccinos_why_do/)

**Syntax:**

```
# Declaration
_name (Kind): { field: value, ... }

# Usage
"measurement_name" extends [_name1, _name2]:
```

**Two Kinds of Extendables:**

| Kind         | Contains          | Allowed In                      |
| ------------ | ----------------- | ------------------------------- |
| `(Requires)` | Type declarations | Measurement files only            |
| `(Provides)` | Literal values    | Measurement and expectation files |

**Rules:**

- Names must start with an underscore (`_`)
- Names must be unique within the file
- File-scoped only (cannot reference across files)
- Can reference type aliases defined in the same file (_see next section to learn more about type aliases_)

**In Measurement Files:**

```
_common_req (Requires): { env: String, window_in_days: Integer }

"api_availability" extends [_common_req]:
  Requires { threshold: Float }
  Provides { evaluation: "numerator / denominator" }
```

Within the compiler, this then would be interpreted as:

```
"api_availability":
  Requires { threshold: Float, env: String, window_in_days: Integer }
  Provides { evaluation: "numerator / denominator" }
```

**In Expectation Files:**

Expectations can only use `(Provides)` extendables. The merged fields land in the expectation's `with: {...}` args:

```
_defaults (Provides): { env: "production" }
_owner (Provides): { service_owner: "platform-team" }

"critical_service" extends [_defaults, _owner]:
  Guarantees 99.99% over 7d window as measured by "api_availability" with: {
    status: true
  }
```

Within the compiler, this is equivalent to:

```
"critical_service":
  Guarantees 99.99% over 7d window as measured by "api_availability" with: {
    status: true,
    env: "production",
    service_owner: "platform-team"
  }
```

Threshold (`99.99%`) and window (`7d`) live in the `Guarantees` clause itself — they're not extendable fields anymore. Use extendables to share blueprint-parameter values across expectations.

> See if you can clean up the expectations below. _I like my cappuccino dry!_
