Every SLO in Caffeine is defined through a set of parameters. When you write a measurement, you specify the query structure and evaluation logic. When you write an expectation, you fill in the remaining values like the target threshold and observation window.

Here are the parameters that make up an SLO:

| Parameter      | Type                                                  | Description                                   |
|----------------|-------------------------------------------------------|-----------------------------------------------|
| indicators     | `Dict(String, String)`                                | Named SLI measurement expressions             |
| evaluation     | `String`                                              | CQL expression combining indicators           |
| threshold      | `Percentage`                                          | Target percentage (e.g., 99.9%)               |
| window_in_days | `Defaulted(Integer { 1..90 }, 30)`                    | Rolling window for measurement (default 30)   |
| tags           | `Optional(Dict(String, String))`                      | Optional tags to append to the SLO            |
| runbook        | `Optional(URL)`                                       | Optional runbook URL for the SLO description  |
| depends_on     | `Optional({ hard: List(String), soft: List(String) })`| Optional dependency declarations              |

In practice, a measurement typically provides the `indicators` and `evaluation` (the query structure), while the expectation provides the `threshold` and optionally overrides `window_in_days`.

The vendor (Datadog, Dynatrace, Honeycomb, or New Relic) is determined by the measurement filename (e.g., `datadog.caffeine`, `honeycomb.caffeine`). At this time, only Datadog is supported.

**Evaluation Expressions**

The `evaluation` field defines how indicators combine into an SLI. Two patterns are supported:

| Pattern    | Syntax                                  | Use Case                              |
|------------|-----------------------------------------|---------------------------------------|
| Ratio      | `good / total`                          | Availability (successful / all)       |
| Time Slice | `time_slice(query < threshold per 5m)`  | Latency (% of intervals under target) |

More complex arithmetic is also supported:
* `(total - bad) / total`
* `time_slice((event_a_latency + event_b_latency) < threshold per 5m)`

**Best Practices**

Measurements define the `indicators` and `evaluation`, locking in the query structure. Expectations then provide the remaining values (`threshold`, `window_in_days`, and any measurement-specific parameters). This separation keeps query logic centralized while letting each service set its own targets.

> The example shows a basic availability SLO with a ratio-based evaluation.
