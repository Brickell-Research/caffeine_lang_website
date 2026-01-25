The first artifact supported by Caffeine is an **SLO** (_service level objective_). An SLO sets a reliability target for a user-facing metric (an _SLI_, or _service level indicator_) measured over a defined time window. For example, “99.9% of requests succeed over 30 days.”

In order to limit the scope of the tour, we will not go into the who, what, why, and how of SLOs. There are a lot of good resources online:
* [SLOs, the Google SRE Book](https://sre.google/sre-book/service-level-objectives/)
* [David Rensin's Less Risk Through Greater Humanity](https://www.youtube.com/watch?v=0zqBlRW_6jA)
* [The SLO Book - must purchase, but if interested in going deep, 10/10 reccomend!](https://www.alex-hidalgo.com/the-slo-book)

All (or at least most) serious/modern observability tools today support SLOs within their platform. Furthermore, many vendors support leveraging [Terraform](https://developer.hashicorp.com/terraform) to create/maintain/modify these SLOs.

At time of writing Caffeine just supports generating Terraform for the [Datadog](https://docs.datadoghq.com/service_management/service_level_objectives/) vendor.

**Artifact Definition:**

| Attribute      | Type                                                 | Description                                   |
|----------------|------------------------------------------------------|-----------------------------------------------|
| queries        | `Dict(String, String)`                               | Named queries for the SLI calculation         |
| threshold      | `Float { x \| x in (0.0 .. 100.0) }`                 | Target percentage (e.g., 99.9)                |
| value          | `String`                                             | CQL expression combining queries              |
| vendor         | `String { x \| x in { datadog } }`                   | Observability platform                        |
| window_in_days | `Defaulted(Integer, 30) { x \| x in { 7, 30, 90 } }` | Rolling window for measurement                |

**CQL (Caffeine Query Language):**

The `value` field uses CQL to define how queries combine into an SLI. Two supported patterns:

| Pattern    | Syntax                                  | Use Case                              |
|------------|-----------------------------------------|---------------------------------------|
| Ratio      | `good / total`                          | Availability (valid successful / all) |
| Time Slice | `time_slice(query < threshold per 5m)`  | Latency (% of intervals under target) |

Ratio divides named queries (defined within the `queries` dictionary) (e.g., `numerator / denominator`). Time slice measures what percentage of time intervals meet a condition (again leveraging values from the `queries` dictionary). Ratio is useful for things that can be counted, i.e. good requests over total requests. Time slices are useful for asserting the latency for some service stays within some threshold.

For these expressions, more complex arithmetic is supported. A couple examples:
* `(total - bad) / total`
* `time_slice((event_a_latency + event_b_latency) < threshold per 5m)`

_In Caffeine it is best practice_ to partially define the SLO within a blueprint. Specifically, blueprints typically define the `queries`, the `value`, and the `vendor`. 

> The example shows a basic availability SLO. On the right hand side we have the output which is valid Terraform representing the specified SLO for the Datadog vendor.
