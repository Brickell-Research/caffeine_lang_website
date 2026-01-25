A **Blueprint** defines a reusable pattern for a reliability artifact. It starts with:

```
Blueprints for "ArtifactName"
```

This tells Caffeine which artifact from the standard library you're targeting (currently `SLO`).

Each blueprint within the file is declared with a bullet:

```
  * "Blueprint_Name":
    Requires { ... }
    Provides { ... }
```

The `Requires` block declares what parameters service owners must provide. The `Provides` block supplies the artifact's configuration.

> Try changing the blueprint name from `"Availability_SLO"` to something else and watch the output update.
