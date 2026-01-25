A _service level objective_ is conceptually simple: a metric emulating a user experience (_sli or service level indicator_) over a window of time from which we assert will succeed above some threshold.

The key to a good metric is how well it emulates a user experience, to what degree it is trustworthy, and if it can be defined in a binary way (i.e. a request is good or bad).

There are a lot of good resources on SLOs:
* [David Rensin's Less Risk Through Greater Humanity](https://www.youtube.com/watch?v=0zqBlRW_6jA)
* [The SLO Book](https://www.alex-hidalgo.com/the-slo-book)
* [SLOs, the Google SRE Book](https://sre.google/sre-book/service-level-objectives/)

And all (or at least most) serious/modern observability tools today support them. Furthermore, many vendors support leveraging Terraform to create/maintain/modify these SLOs.

At time of writing Caffeine just supports generating [Terraform](https://www.hashicorp.com/en/pricing?tab=terrafor) for the [Datadog](https://docs.datadoghq.com/service_management/service_level_objectives/) vendor.

**Artifact Definition:**

| Attribute      | Type                                                 | Description                                   |
|----------------|------------------------------------------------------|-----------------------------------------------|
| queries        | `Dict(String, String)`                               | Named queries for the SLI calculation         |
| threshold      | `Float { x \| x in (0.0 .. 100.0) }`                 | Target percentage (e.g., 99.9)                |
| value          | `String`                                             | CQL expression combining queries              |
| vendor         | `String { x \| x in { datadog } }`                   | Observability platform                        |
| window_in_days | `Defaulted(Integer, 30) { x \| x in { 7, 30, 90 } }` | Rolling window for measurement                |

**CQL (Caffeine Query Language):**

The `value` field uses CQL to define how queries combine into an SLI. Two common patterns:

| Pattern    | Syntax                                  | Use Case                              |
|------------|-----------------------------------------|---------------------------------------|
| Ratio      | `good / total`                          | Availability (successful / all)       |
| Time Slice | `time_slice(query < threshold per 5m)`  | Latency (% of intervals under target) |

Ratio divides named queries (definied within the `queries` dictionary) (e.g., `numerator / denominator`). Time slice measures what percentage of time intervals meet a condition (again leveraging values from the `queries` dictionary). Ratio is useful for things that can be counted, i.e. good requests over total requests. Time slices are useful for asserting the latency for some service stays within some threshold.

> The example shows a basic availability SLO. On the right hand side we have the output which is valid Terraform representing the specified SLO for the Datadog vendor.
