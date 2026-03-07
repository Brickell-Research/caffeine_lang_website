**Extendables** are reusable blocks that enable common `requires` or `provides` attributes to be specified once and used many times. They live near the top of files, beneath type aliases and above blueprints/expectations - this is not just a recommendation, it is asserted by the compiler. Extendables are useful for defining common patterns and deduplicating blueprint and expectation definitions. 

As we like to say [_"caffeinate but stay dry!"_](https://www.reddit.com/r/barista/comments/2gl8wu/are_any_of_you_fans_of_dry_cappuccinos_why_do/)

**Syntax:**

```
# Declaration
_name (Kind): { field: value, ... }

# Usage
* "blueprint_name" extends [_name1, _name2]:
```

**Two Kinds of Extendables:**

| Kind         | Contains          | Allowed In                      |
| ------------ | ----------------- | ------------------------------- |
| `(Requires)` | Type declarations | Blueprint files only            |
| `(Provides)` | Literal values    | Blueprint and expectation files |

**Rules:**

- Names must start with an underscore (`_`)
- Names must be unique within the file
- File-scoped only (cannot reference across files)
- Can reference type aliases defined in the same file (_see next section to learn more about type aliases_)

**In Blueprint Files:**

```
_common_req (Requires): { env: String, window_in_days: Integer }
_base_slo (Provides): { vendor: "datadog" }

Blueprints for "SLO"
  * "api_availability" extends [_base_slo, _common_req]:
    Requires { threshold: Float }
    Provides { evaluation: "numerator / denominator" }
```

Within the compiler, this then would be interpreted as:

```
Blueprints for "SLO"
  * "api_availability":
    Requires { threshold: Float, env: String, window_in_days: Integer }
    Provides { evaluation: "numerator / denominator", vendor: "datadog" }
```

**In Expectation Files:**

Expectations can only use `(Provides)` extendables:

```
_defaults (Provides): { env: "production", window_in_days: 30 }
_strict (Provides): { threshold: 99.99%, window_in_days: 7 }

Expectations for "api_availability"
  * "critical_service" extends [_defaults, _strict]:
    Provides { status: true }
```

Within the compiler, this then would be interpreted as:

```
Expectations for "api_availability"
  * "critical_service":
    Provides { 
      status: true,
       env: "production",
       window_in_days: 30,
       threshold: 99.99%,
       window_in_days: 7
    }
```

> See if you can clean up the expectations below. _I like my cappuccino dry!_
