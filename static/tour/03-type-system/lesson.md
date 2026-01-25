Caffeine has a simple but strict type system. The `Requires` block uses type annotations:

```
Requires {
  service_name: String,
  environment: String,
  threshold: Float,
  window_in_days: Integer
}
```

Available types:

- `String` — text values
- `Float` — decimal numbers
- `Integer` — whole numbers
- `Boolean` — true or false

The compiler enforces these at compile time. If an expectation provides a String where an Integer is required, you get a clear error.

> Try changing `threshold: 99.9` to `threshold: "high"` in the expectations to see a type error.
