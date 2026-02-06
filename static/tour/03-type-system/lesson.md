One of the core benefits of Caffeine is that user-provided type annotations enable the compiler to catch errors by constraining parameter inputs. Thus, baristas are empowered to _programmatically_ guide consumers towards more semantically correct inputs - a [pit of success](https://blog.codinghorror.com/falling-into-the-pit-of-success/).

Caffeine's type system consists of the following.

**Primitives:** the basic types most programmers are already familiar with.

| Type    | Description                                        | Example          |
|---------|----------------------------------------------------|------------------|
| Boolean | True or false                                      | `true`           |
| Integer | Whole numbers                                      | `123`            |
| Float   | Decimal numbers                                    | `12.34`          |
| String  | Any collection of characters between double quotes | `"Hello World!"` |
| URL     | A String starting with http:// or https://         | `"https://example.com"` |

**Collections:** types for grouping values.

| Type | Description                                                                                            | Example                       |
|------|--------------------------------------------------------------------------------------------------------|-------------------------------|
| List | An ordered sequence defined as `List(T)` where T is a primitive or collection                          | `List(String)`                |
| Dict | A key-value map defined as `Dict(K, V)` where K is a primitive and V is a primitive or collection      | `Dict(String, List(Integer))` |

**Modifiers:** types for specifying extra behavior along with the type.

| Type      | Description                                                             | Example                       |
|-----------|-------------------------------------------------------------------------|-------------------------------|
| Defaulted | A type with a default value if none is provided                         | `Defaulted(String, "cheese")` |
| Optional  | A type where the value may be left unspecified                          | `Optional(Integer)`           |

**Structured:** a type for defining structured groups of typed fields.

| Type   | Description                                                  | Example                                          |
|--------|--------------------------------------------------------------|--------------------------------------------------|
| Record | A group of named, typed fields                               | `{ numerator: String, denominator: String }`     |

Records let you define structured parameters where each field has its own type. Fields can use any type, including other records for nesting. They are especially useful for grouping related parameters like query indicators.

**Refinements:** more complex types for attaching a proposition (a.k.a. further constraints) to the type.

| Type           | Description                                          | Example                                       |
|----------------|------------------------------------------------------|-----------------------------------------------|
| OneOf          | Value must be one of a finite set                    | `String { x \| x in { "a", "b", "c" } }`      |
| InclusiveRange | Value must be within a numeric range (inclusive)     | `Float { x \| x in ( 0.0..100.0 ) }`          |

> Try changing `service_name: "hello-world"` to `service_name: 10` within the **expectation** file below to see a type error. Don't get too hung up on what Expectations or Blueprints are. We will explain in lessons to come!

<br>

**Bonus:** if you chose to install the compiler locally, you can run the `caffeine types` command to get an overview of currently supported types. Here is what it looks like as of `v4.2.2`:

```bash
> ✗ caffeine types
Type System Reference
=====================

PrimitiveTypes: "Base value types for simple data"

  Boolean: "True or false"
    syntax: Boolean
    e.g. true, false
  String: "Any text between double quotes"
    syntax: String
    e.g. "hello", "my-service"
  Integer: "Whole numbers"
    syntax: Integer
    e.g. 42, 0, -10
  Float: "Decimal numbers"
    syntax: Float
    e.g. 3.14, 99.9, 0.0
  URL: "A valid URL starting with http:// or https://"
    syntax: URL
    e.g. "https://example.com"

CollectionTypes: "Container types for grouping values"

  List: "An ordered sequence where each element shares the same type"
    syntax: List(T)
    e.g. List(String), List(Integer)
  Dict: "A key-value map with typed keys and values"
    syntax: Dict(K, V)
    e.g. Dict(String, String), Dict(String, Integer)

StructuredTypes: "Named fields with typed values"

  Record: "A group of named, typed fields"
    syntax: { field: T, ... }
    e.g. { numerator: String, denominator: String }

ModifierTypes: "Wrappers that change how values are handled"

  Optional: "A type where the value may be left unspecified"
    syntax: Optional(T)
    e.g. Optional(String), Optional(Integer)
  Defaulted: "A type with a default value if none is provided"
    syntax: Defaulted(T, default)
    e.g. Defaulted(Integer, 30), Defaulted(String, "prod")

RefinementTypes: "Constraints that restrict allowed values"

  OneOf: "Value must be one of a finite set"
    syntax: T { x | x in { val1, val2, ... } }
    e.g. String { x | x in { datadog, prometheus } }
  InclusiveRange: "Value must be within a numeric range (inclusive)"
    syntax: T { x | x in ( low..high ) }
    e.g. Integer { x | x in ( 0..100 ) }
```