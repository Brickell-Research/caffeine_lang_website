Blueprints become powerful when you use **string interpolation** to inject parameters into queries.

The syntax is:

```
$parameter_name->field_name$
```

This tells Caffeine to substitute the value of `field_name` from the parameter named `parameter_name` at compile time.

In the example below, the queries use `$service_name->service_name$` to inject the service name into the Datadog query string.

When the expectation provides `service_name: "api-gateway"`, the compiled output will contain the literal string `api-gateway` in the query.

> Try changing the `service_name` value in expectations and observe how it flows into the output.
