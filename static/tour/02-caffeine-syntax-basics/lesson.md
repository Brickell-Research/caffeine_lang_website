Before diving into specific concepts, let's cover the basic syntax of Caffeine.

All Caffeine files end with the `.caffeine` file extension. There are two types of files, each with specific file path requirements:

| File                             | Contains                                                                                                                   |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `measurements/VENDOR.caffeine`   | **Measurements** with optional type aliases and/or extendables.                                                              |
| `ORG/TEAM/SERVICE.caffeine`      | **Expectation** with optional extendables. One file per org/team/service combination. As denoted, file path is meaningful. |

Comments in Caffeine are _Ruby like_ and useful for surfacing tacit information about an expectation. The number of leading hashes determines how the comment is treated by codegen:

| Prefix | Meaning                                                                                                                              |
|--------|--------------------------------------------------------------------------------------------------------------------------------------|
| `#`    | Informal inline note. Round-trips through the formatter; ignored by codegen.                                                         |
| `##`   | Section header. Round-trips through the formatter; ignored by codegen.                                                               |
| `###`  | Doc comment. When placed immediately above an `*` SLO entry, the lines are joined and emitted as the Datadog SLO `description`.      |

```
Expectations measured by "api_availability"
  ## Section header — ignored by codegen.
  ### Tracks the checkout flow availability.
  ### Owner: payments team.
  * "checkout":
    Provides { env: "production", threshold: 99.95 }

  # informal note — ignored by codegen
  * "payment":
    Provides { env: "production", threshold: 99.99 }
```

If a runbook URL is also provided, the description and runbook are combined into an HCL heredoc on the generated `datadog_service_level_objective`.

The literals of the language are fairly straightforward, following the cue of many other programming languages.

| Type    | Syntax                        |
|---------|-------------------------------|
| String  | `"double quotes only"`        |
| Integer | `42`                          |
| Float   | `3.14`                        |
| Boolean | `true` or `false`             |
| List    | `[1, 2, 3]`                   |
| Dict    | `{ key: value, key2: value2 }`|

**Indentation:**

Caffeine uses indentation to denote structure.

**Measurements:** `Provides` and `Requires` indented on new lines following the measurement name.
```
"My_Measurement":
  Requires { ... }
  Provides { ... }
```

**Expectations:** single indented bullet list of expectation names beneath the `Expecations` declaration followed by their `Provides` blocks indented twice.
```
Expectations measured by "My_Measurement"
  * "Some Expectation":
    Provides {}
```

There are just a few keywords in the Caffeine language. Here they are along with their significance/meaning:
* `Expectations measured by`: prefaces expectation(s) declaration(s) for a specific measurement
* `Requires`: signifies a requirements block
* `Provides`: signifies a provide block
* `Type`: signifies a type alias

> Continue on to learn about the Caffeine `Type System`.
