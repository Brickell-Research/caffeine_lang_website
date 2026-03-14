Before diving into specific concepts, let's cover the basic syntax of Caffeine.

All Caffeine files end with the `.caffeine` file extension. There are two types of files, each with specific file path requirements:

| File                             | Contains                                                                                                                   |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `measurements.caffeine`            | **Measurements** with optional type aliases and/or extendables.                                                              |
| `ORG/TEAM/SERVICE.caffeine`      | **Expectation** with optional extendables. One file per org/team/service combination. As denoted, file path is meaningful. |

Comments in Caffeine are _Ruby like_ and useful for surfacing tacit information about an expectation.

```
# Single-line comments start with a hash
```

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

Caffeine uses indentation to denote structure. Blocks under `*` items must be indented and each name following a `*` must be unique per file. Furthermore, each block following the `*` line must be twice indented.

```
Measurements
  "My_Measurement":
    Requires { ... }
    Provides { ... }
```

There are just a few keywords in the Caffeine language. Here they are along with their significance/meaning:
* `Measurements`: prefaces measurement(s) declaration(s) for one or more SLO parameters
* `Expectations measured by`: prefaces expectation(s) declaration(s) for a specific measurement
* `Requires`: signifies a requirements block
* `Provides`: signifies a provide block
* `Type`: signifies a type alias

> Continue on to learn about the Caffeine `Type System`.
