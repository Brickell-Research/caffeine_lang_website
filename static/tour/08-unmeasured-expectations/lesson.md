Sometimes you need to declare an expectation for a service you don't directly measure.

An expectation with no `as measured by ... with: ...` clause is **unmeasured**. It has no measurement backing, doesn't generate Terraform resources, but participates in the dependency graph. This makes them useful for:
* representing third-party SLAs (e.g., "our cloud provider guarantees 99.95% uptime")
* declaring expectations for external services that other expectations depend on
* completing the dependency picture without requiring query instrumentation

**Syntax:**

```
"provider_uptime":
  Guarantees 99.95% over 30d window
```

An unmeasured expectation carries only the `Guarantees` clause (threshold + window) and an optional `Assumes:` section. There's no `with: {...}` because there's no measurement to parameterize.

**Mixing with Measured Expectations:**

A single file can contain both. Measured expectations name their measurement via `as measured by`; unmeasured ones simply omit that tail:

```
"checkout_availability":
  Assumes:
    hard dependency on "acme.infra.cloud.provider_uptime"
  Guarantees 99.9% over 30d window as measured by "api_availability" with: {
    env: "production"
  }

"provider_uptime":
  Guarantees 99.95% over 30d window
```

Here, `checkout_availability` declares a hard dependency on `provider_uptime`. The unmeasured expectation establishes the third-party SLA target so the compiler can validate the threshold constraint holds.

> This lesson doesn't have an interactive example since unmeasured expectations don't produce Terraform output.
