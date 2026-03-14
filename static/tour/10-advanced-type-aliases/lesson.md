**Type Aliases** are reusable, named types. They let you define a constrained type once and reference it throughout your measurements, reducing repetition and ensuring consistency.

**Syntax:**

```
# Declaration (must be at top of file)
_name (Type): <refinement_type_or_record>

# Usage
field: _name
field: Optional(_name)
field: Defaulted(_name, default_value)
field: List(_name)
field: Dict(_name, String)
```

Type aliases can be used in `requires` blocks, both within an extendable or within a measurement definition:

```
# Type Aliases
_env (Type): String { x | x in { prod, staging } }
_indicators (Type): { numerator: String, denominator: String }

# Extendables
_common (Provides): { excluded_env: Optional(_env) }

# Measurements
Measurements
  "my_measurement" extends [_common]:
    Requires {
      env: Defaulted(_env, "prod"),
      backup_env: Optional(_env),
      all_envs: List(_env),
      indicators: _indicators
    }
```

**Rules:**

- Names must start with an underscore (`_`)
- Must specify kind: `(Type)`
- Must be at top of file (before extendables and measurements)
- File-scoped only (cannot reference across files)
- Can alias refinement types (OneOf or InclusiveRange) or record types

Common use cases include constraining environments, service name sets, and reusable record structures.

```
# Environments
_env (Type): String { x | x in { "prod", "staging", "dev" } }

# Service names
_service (Type): String { x | x in { "authentication", "backend", "frontend", "database" } }

# Reusable record structures
_indicators (Type): { numerator: String, denominator: String }
```
