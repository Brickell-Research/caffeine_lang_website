Sometimes you need to declare an expectation for a service you don't directly measure, i.e. a third-party dependency or an external SLA. These are **Unmeasured Expectations**.

Unmeasured Expectations have no measurement backing. They don't generate Terraform resources, but they do participate in the dependency graph (and thus show up in certain artifacts, i.e. a mermaid diagram). This makes them useful for:
* representing third-party SLAs (e.g., "our cloud provider guarantees 99.95% uptime")
* declaring expectations for external services that other expectations depend on
* completing the dependency picture without requiring query instrumentation

**Syntax:**

```
Unmeasured Expectations
  * "provider_uptime":
    Provides { threshold: 99.95%, window_in_days: 30 }
```

Only `threshold`, `window_in_days`, and `depends_on` are permitted in an unmeasured expectation's `Provides` block. No `indicators`, `evaluation`, or measurement-specific parameters are allowed.

**Mixing with Measured Expectations:**

A single file can contain both:

```
Expectations measured by "api_availability"
  * "checkout_availability":
    Provides {
      threshold: 99.9%,
      env: "production",
      depends_on: { hard: ["acme.infra.cloud.provider_uptime"] }
    }

Unmeasured Expectations
  * "provider_uptime":
    Provides { threshold: 99.95%, window_in_days: 30 }
```

Here, `checkout_availability` declares a hard dependency on `provider_uptime`. The unmeasured expectation establishes the third-party SLA target so the compiler can validate the threshold constraint holds.

> This lesson doesn't have an interactive example since unmeasured expectations don't produce Terraform output.
