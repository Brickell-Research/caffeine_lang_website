Before diving into specific concepts, let's cover the basic syntax of Caffeine.

**File Types:**

| File                             | Contains                                                                                                               |
|----------------------------------|------------------------------------------------------------------------------------------------------------------------|
| `blueprints.caffeine`            | Blueprints with optional type aliases and/or extendables                                                               |
| `ORG/TEAM/SERVICE.caffeine`      | Expectation with optional exttendables. One file per org/team/service combination. As denoted, file path is meaningful |

**Comments:**

```
# Single-line comments start with a hash
```

**Literals:**

| Type    | Syntax                        |
|---------|-------------------------------|
| String  | `"double quotes only"`        |
| Integer | `42`                          |
| Float   | `3.14`                        |
| Boolean | `true` or `false`             |
| List    | `[1, 2, 3]`                   |
| Dict    | `{ key: value, key2: value2 }`|

**Indentation:**

Caffeine uses indentation to denote structure. Blocks under `*` items must be indented and each name following a `*` must be unique per file:

```
Blueprints for "SLO"
  * "My_Blueprint":
    Requires { ... }
    Provides { ... }
```

**Keywords:**

* `Blueprints for`: prefaces blueprint(s) declaration(s) for one or more artifacts
* `Expectations for`: prefaces expectation(s) declaration(s) for a specific blueprint
* `Requires`: signifies a requirements block
* `Provides`: signifies a provide block
* `Type`: signifies a type alias
