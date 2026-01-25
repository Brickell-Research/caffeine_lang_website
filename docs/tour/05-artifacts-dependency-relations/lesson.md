**Dependency relations** define how two expectations are correlated with each other. By annotating expectations with this information, we empower the compiler to:
* evaluate whether these relations are sensible (i.e. it is invalid to assert a service will have 99.99% availability if it has a hard dependency on a service with just 99% availability)
* create (and maintain) a dependency map/system diagram
* recommend expectation thresholds (related to the first point — i.e. hard depends on 99.9% availability and is a hard dependency of 99% availability so must be within a minimum of 99% and a maximum of 99.9%)

**Artifact Definition:**

| Attribute | Type                                              | Description                                |
|-----------|---------------------------------------------------|--------------------------------------------|
| relations | `Dict(String { x \| x in { soft, hard } }, List(String))` | Map of dependency type to expectation refs |

**Dependency Types:**

| Type | Description                                                                                                                          |
|------|--------------------------------------------------------------------------------------------------------------------------------------|
| hard | Critical dependency — if it fails, this service fails                                                                                |
| soft | Non-critical dependency — degraded experience but service remains available, typically achieved via retries, service fallbacks, etc. |

**Expectation References:**

Dependencies point to other expectations using a reference syntax: `ORG_DIRECTORY.TEAM_NAME.SERVICE_NAME.EXPECTATION_NAME`

The compiler validates references at compile time and rejects circular dependencies. Furthermore within the specification of blueprints, it must be combined with `SLO` _at this time_.

> The example shows a checkout service with a hard dependency on payments and a soft dependency on recommendations.
