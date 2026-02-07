The first artifact supported by Caffeine is an **SLO** (_service level objective_). An SLO sets a reliability target for a user-facing metric (an _SLI_, or _service level indicator_) measured over a defined time window. For example, "99.9% of requests succeed over 30 days."

In order to limit the scope of the tour, we will not go into the who, what, why, and how of SLOs. There are a lot of good resources online:
* [SLOs, the Google SRE Book](https://sre.google/sre-book/service-level-objectives/)
* [David Rensin's Less Risk Through Greater Humanity](https://www.youtube.com/watch?v=0zqBlRW_6jA)
* [The SLO Book - must purchase, but if interested in going deep, 10/10 reccomend!](https://www.alex-hidalgo.com/the-slo-book)

All (or at least most) serious/modern observability tools today support SLOs within their platform. Furthermore, many vendors support leveraging [Terraform](https://developer.hashicorp.com/terraform) to create/maintain/modify these SLOs.

Caffeine supports generating Terraform for the [Datadog](https://docs.datadoghq.com/service_management/service_level_objectives/), [Dynatrace](https://docs.dynatrace.com/docs/observe/service-level-objectives), [Honeycomb](https://www.honeycomb.io/blog/slo-as-code-with-terraform), and [New Relic](https://docs.newrelic.com/docs/service-level-management/intro-slm/) vendors.

**Artifact Definition:**

| Attribute      | Type                                                 | Description                                   |
|----------------|------------------------------------------------------|-----------------------------------------------|
| indicators     | `Dict(String, String)`                               | Named SLI measurement expressions             |
| evaluation     | `String`                                             | CQL/Derived Column expression combining indicators           |
| threshold      | `Float { x \| x in (0.0 .. 100.0) }`                 | Target percentage (e.g., 99.9)                |
| vendor         | `String { x \| x in { datadog, dynatrace, honeycomb, newrelic } }`        | Observability platform                        |
| window_in_days | `Defaulted(Integer, 30)`                              | Rolling window for measurement                |
| tags           | `Optional(Dict(String, String))`                      | Optional tags to append to the SLO            |
| runbook        | `Optional(URL)`                                       | Optional runbook URL for the SLO description  |

**Datadog: CQL (Caffeine Query Language)**

For Datadog, the `evaluation` field uses CQL to define how indicators combine into an SLI. Two supported patterns:

| Pattern    | Syntax                                  | Use Case                              |
|------------|-----------------------------------------|---------------------------------------|
| Ratio      | `good / total`                          | Availability (valid successful / all) |
| Time Slice | `time_slice(query < threshold per 5m)`  | Latency (% of intervals under target) |

Ratio divides named indicators (defined within the `indicators` dictionary) (e.g., `numerator / denominator`). Time slice measures what percentage of time intervals meet a condition (again leveraging values from the `indicators` dictionary). Ratio is useful for things that can be counted, i.e. good requests over total requests. Time slices are useful for asserting the latency for some service stays within some threshold.

For these expressions, more complex arithmetic is supported. A couple examples:
* `(total - bad) / total`
* `time_slice((event_a_latency + event_b_latency) < threshold per 5m)`

**Dynatrace: Metric Expressions**

For Dynatrace, indicators are metric selector expressions (e.g., `builtin:service.requestCount.server:splitBy()`). The `evaluation` field uses CQL to combine indicators, just like Datadog.

**Honeycomb: Derived Column Expressions**

For Honeycomb, the model is simpler. You provide a single indicator whose value is a boolean derived column expression (e.g., `HEATMAP(duration_ms)`). The `evaluation` field is almost always the name of the single indicator you specify here.

**New Relic: NRQL Indicators**

For New Relic, indicators are NRQL expressions — an event type with an optional `WHERE` filter (e.g., `"Transaction WHERE appName = 'payments'"`). The `evaluation` field must be `good / valid`, where each name refers to an indicator mapping to the corresponding events block in the generated Terraform resource. New Relic only supports rolling windows of 1, 7, or 28 days.

**Best Practices**

_In Caffeine it is best practice_ to partially define the SLO within a blueprint. Specifically, blueprints typically define the `indicators`, the `evaluation`, and the `vendor`.

> The example shows a basic availability SLO. On the right hand side we have the output which is valid Terraform representing the specified SLO for the Datadog vendor.
