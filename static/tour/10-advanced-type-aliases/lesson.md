**Type Aliases** are reusable, named refinement types. They let you define a constrained type once and reference it throughout your blueprints, reducing repetition and ensuring consistency.

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

**Rules:**

- Names must start with an underscore (`_`)
- Must specify kind: `(Type)`
- Must be at top of file (before extendables and blueprints)
- File-scoped only (cannot reference across files)
- Can only alias refinement types (OneOf or InclusiveRange)
- Inlined at compile time (do not appear in JSON output)

**Common Use Cases:**

```
# Environment constraints
_env (Type): String { x | x in { prod, staging, dev } }

# Threshold bounds
_threshold (Type): Float { x | x in ( 0.0..100.0 ) }
```

**Using with Modifiers:**

Type aliases work with modifiers:

```
_env (Type): String { x | x in { prod, staging } }

Blueprints for "SLO"
  * "my_blueprint":
    Requires {
      env: Defaulted(_env, "prod"),
      backup_env: Optional(_env),
      all_envs: List(_env)
    }
```

Try editing the type aliases on the right to see how they constrain values.
