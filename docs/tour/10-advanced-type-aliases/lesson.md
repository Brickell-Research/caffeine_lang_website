**Type Aliases** are reusable, named types (_at this time, they specifically must be refinement types - a decision of the core team which is open for discussion_). They let you define a constrained type once and reference it throughout your blueprints, reducing repetition and ensuring consistency.

**Syntax:**

```
# Declaration (must be at top of file)
_name (Type): <refinement_type>

# Usage
field: _name
field: Optional(_name)
field: Defaulted(_name, default_value)
field: List(_name)
field: Dict(_name, String)
```

Type aliases can be used in `requires` blocks, both within an extendable or within a blueprint definition:

```
# Type Aliases
_env (Type): String { x | x in { prod, staging } }

# Extendables
_common (Provides) { excluded_env: Optional(_env) }

# Blueprints
Blueprints for "SLO"
  * "my_blueprint" extends [_common]:
    Requires {
      env: Defaulted(_env, "prod"),
      backup_env: Optional(_env),
      all_envs: List(_env)
    }
```

**Rules:**

- Names must start with an underscore (`_`)
- Must specify kind: `(Type)`
- Must be at top of file (before extendables and blueprints)
- File-scoped only (cannot reference across files)
- Can only alias refinement types (OneOf or InclusiveRange)

Two of the most common use cases thus far are a type describing environments and a type for a well-known set of service names.

```
# Environments
_env (Type): String { x | x in { "prod", "staging", "dev" } }

# Service names
_service (Type): String { x | x in { "authentication", "backend", "frontend", "database" } }
```
