**Dependency relations** define how two expectations are correlated with each other. By annotating expectations with this information, we empower the compiler to:
* evaluate whether these relations are sensible (i.e. it is invalid to assert a service will have 99.99% availability if it has a hard dependency on a service with just 99% availability)
* enforce hard dependency threshold constraints (i.e. the compiler rejects configurations where a service expects 99.99% availability but hard depends on a service with only 99% availability)
* create (and maintain) a dependency map/system diagram

**Artifact Definition:**

| Attribute | Type                                                      | Description                                |
|-----------|-----------------------------------------------------------|--------------------------------------------|
| relations | `Dict(String { x \| x in { soft, hard } }, List(String))` | Map of dependency type to expectation refs |

**Dependency Types:**

| Type | Description                                                                                                                                      |
|------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| hard | Critical dependency. If it fails, this service fails.                                                                                            |
| soft | Non-critical dependency. Results in a degraded experience but service remains available, typically achieved via retries, service fallbacks, etc. |

**Expectation References:**

Within the `relations` map, an expectation references another expectation using the following syntax (mirroring the file path): `ORG_DIRECTORY.TEAM_NAME.SERVICE_NAME.EXPECTATION_NAME`

The compiler validates references at compile time and rejects circular dependencies. Furthermore within the specification of blueprints, it must be combined with `SLO` _at this time_.
