One of the core benefits of Caffeine is the assistance of the compiler afforded by user defined types, limiting the domain of parameter inputs.

Caffeine's type system consists of the following.

**Primitives:** the basic types most programmers are already familiar with.

| Type    | Description                                        | Example          |
|---------|----------------------------------------------------|------------------|
| Boolean | True or false                                      | `true`           |
| Integer | Whole numbers                                      | `123`            |
| Float   | Decimal numbers                                    | `12.34`          |
| String  | Any collection of characters between double quotes | `"Hello World!"` |

**Collections:** container types for grouping values.

| Type | Description                                                                                            | Example                       |
|------|--------------------------------------------------------------------------------------------------------|-------------------------------|
| List | An ordered sequence defined as `List(T)` where T is a primitive or collection                          | `List(String)`                |
| Dict | A key-value map defined as `Dict(K, V)` where K is a primitive and V is a primitive or collection      | `Dict(String, List(Integer))` |

**Modifiers:** modifier types enable specification of extra behavior along with the type.

| Type      | Description                                                             | Example                       |
|-----------|-------------------------------------------------------------------------|-------------------------------|
| Defaulted | A type with a default value if none is provided                         | `Defaulted(String, "cheese")` |
| Optional  | A type where the value may be left unspecified                          | `Optional(Integer)`           |

**Refinements:** refinement types are primitives with a proposition (a.k.a. further constraints).

| Type           | Description                                          | Example                                      |
|----------------|------------------------------------------------------|----------------------------------------------|
| OneOf          | Value must be one of a finite set                    | `String { x | x in { "a", "b", "c" } }`     |
| InclusiveRange | Value must be within a numeric range (inclusive)     | `Float { x | x in ( 0.0..100.0 ) }`         |

> Try changing `service_name: "hello-world"` to `service_name: 10` in the expectations to see a type error. Also don't get too hung up on what Expectations or Blueprints are. We will explain in lessons to come!
