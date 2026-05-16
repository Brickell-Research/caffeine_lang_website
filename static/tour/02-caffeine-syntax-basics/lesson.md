Before diving into specific concepts, let's cover the basic syntax of Caffeine.

All Caffeine files end with the `.caffeine` file extension. There are two types of files, each with specific file path requirements:

| File                           | Contains                                                                                                                   |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `measurements/VENDOR.caffeine` | **Measurements** with optional type aliases and/or extendables.                                                            |
| `ORG/TEAM/SERVICE.caffeine`    | **Expectation** with optional extendables. One file per org/team/service combination. As denoted, file path is meaningful. |

Comments in Caffeine are _Ruby like_ and useful for surfacing tacit information about an expectation. The number of leading hashes determines how the comment is treated by codegen:

| Prefix | Meaning                                                                                                                         |
| ------ | ------------------------------------------------------------------------------------------------------------------------------- |
| `#`    | Informal inline note.                                                                                                           |
| `##`   | Section header.                                                                                                                 |
| `###`  | Doc comment. When placed immediately above an `*` SLO entry, the lines are joined and emitted as the Datadog SLO `description`. |

If a runbook URL is also provided, the description and runbook are combined into a single doc in the generated artifact.

The literals of the language are fairly straightforward, following the cue of many other programming languages.

| Type    | Syntax                         |
| ------- | ------------------------------ |
| String  | `"double quotes only"`         |
| Integer | `42`                           |
| Float   | `3.14`                         |
| Boolean | `true` or `false`              |
| List    | `[1, 2, 3]`                    |
| Dict    | `{ key: value, key2: value2 }` |

**Indentation:**

Caffeine uses indentation to denote structure.

**Measurements:** `Provides` and `Requires` indented on new lines following the measurement name.
```
"My_Measurement":
  Requires { ... }
  Provides { ... }
```

**Expectations:** each expectation stands alone with its own quoted name. The body has an optional `Assumes:` section (dependencies) and a required `Guarantees N% over <duration> window [as measured by "M" with: {...}]` clause.
```
"Some Expectation":
  Guarantees 99.9% over 30d window as measured by "My_Measurement" with: {}
```

The Caffeine language uses these keywords:
* `Guarantees`: introduces the SLO target clause
* `over` / `window`: bracket the rolling window duration on a Guarantees clause
* `as measured by`: links an expectation to its measurement
* `with`: introduces the parameter struct for the measurement
* `Assumes`: starts the dependency section
* `hard dependency on` / `soft dependency on`: declare a dependency line inside `Assumes`
* `below`: optional latency clause on a `time_slice` Guarantees
* `Requires`: signifies the measurement parameter block
* `Provides`: signifies a measurement provide block
* `Type`: signifies a type alias
* `success_rate` / `time_slice`: optional declared expectation type on a measurement header

> Continue on to learn about the Caffeine `Type System`.
