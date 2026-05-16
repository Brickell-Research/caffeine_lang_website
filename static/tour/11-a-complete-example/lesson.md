In order to tie together all the concepts presented here, let's walk through a complete example together! All the code for this example is supplied in the editors below in full.

**Service:** today we will be discussing an authentication service. This is _an exceptionally limited_ auth service, providing only two features:

* **sign-in**: verifies the credentials for a user are correct
* **who am I**: ability to query basic information about a user

What might a user expect of these features?

> Spend a couple minutes brainstorming yourself before continuing. Caffeine is just a tool to codify expectations. Taking sufficient time to discuss with stakeholders, teammates, users, etc. before even opening an IDE is critical! We're just the barista - we serve our customers.

<br>

Here are the user expectations we came up with:

1. a user is able to sign in with valid credentials quickly (within 1 second) and successfully _nearly all the time_ (99.9% of the time). This is a **critical** feature requiring strict constraints. However, as stated, users only login once per session so waiting up to 1 second is fine.
2. a user is able to fetch information about themselves mostly all the time (99% success rate), but it must return quickly (within 250ms). This is an operation users do numerous times per session.

The first step here is to define the measurements. The typical process is:

1. figure out which type of SLO we're working with. For success rate we usually use a `Ratio` and for latency over time we use a `Time Slice`.
2. determine the indicators needed to emulate the user journeys and satisfy the SLO types. This is the `indicators` attribute.
3. for each of the indicators, what attributes do we need? Per attribute, define the template variable within the indicator string and add the attribute to the `requires` block.
4. define the `evaluation` based on (1) and (2).
5. specify the vendor in the `provides` block.
6. consider _DRYing_ up definitions with either extendables or type aliases

Ok, let's walk through this.

**Note:** it's possible that each Caffeine user's vendor instance will be setup differently, so we won't dive too deep into indicator specifics.

First, let's define the structure of each measurement. Here is what the basic outline looks like. We will have two measurements, one for `Auth Success Rate` and one for `Auth Latency`.

```
"Auth Success Rate":
  Requires {}
  Provides {}

"Auth Latency":
  Requires {}
  Provides {}
```

We already did the groundwork for step one by choosing the SLO types, for step two we fill in the indicators.

```
"Auth Success Rate":
  Requires {}
  Provides {
    indicators: {
      valid: "sum:requests{status:valid}",
      total: "sum:requests{}"
    }
  }

"Auth Latency":
  Requires {}
  Provides {
    indicators: {
      latency: "p75:latency{}"
    }
  }
```

Again, there is a lot of thinking and iteration to ensure your indicators (SLIs) properly reflect the user experience you intend to emulate/capture. This topic is beyond the scope of the tour.

For step (3) we want to ensure we're (a) pointing at the right environment and (b) filtering to the correct endpoint. So, we update our indicator strings and requires blocks. For now we'll just type these two attributes as `String` and `String`.

```
"Auth Success Rate":
  Requires {
    env: String,
    endpoint: String
  }
  Provides {
    indicators: {
      valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
      total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
    }
  }

"Auth Latency":
  Requires {
    env: String,
    endpoint: String
  }
  Provides {
    indicators: {
      latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
    }
  }
```

For step (4), we now have all our indicators and know which type of SLO we're working with, so we can declare the `evaluation` within the `provides` block. We'll also complete step (5) too since it's straightforward. For the Time Slice we actually have an extra `require` to add for the `threshold_in_seconds`.

```
"Auth Success Rate":
  Requires {
    env: String,
    endpoint: String
  }
  Provides {
    indicators: {
      valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
      total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
    },
    evaluation: "total / valid",
  }

"Auth Latency":
  Requires {
    env: String,
    endpoint: String,
    threshold_in_seconds: Float
  }
  Provides {
    indicators: {
      latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
    },
    evaluation: "time_slice(latency < $$threshold_in_seconds$$ per 5m)",
  }
```

And we have our measurements fully defined! If unsure, reference the SLO parameter definition in the `SLO Parameters - Service Level Objectives` lesson.

We could stop here, however we'll reduce duplication with a couple extendables.

```
## ==== Extendables ====
_auth_service_common (Requires): { env: String, endpoint: String }

## ==== Measurements ====
"Auth Success Rate" extends [_auth_service_common]:
  Requires {}
  Provides {
    indicators: {
      valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
      total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
    },
    evaluation: "total / valid"
  }

"Auth Latency"  extends [_auth_service_common]:
  Requires { threshold_in_seconds: Float }
  Provides {
    indicators: {
      latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
    },
    evaluation: "time_slice(latency < $$threshold_in_seconds$$ per 5m)"
  }
```

Furthermore, while there are 100s of endpoints (our auth service is huge!!!) we know that there are only a handful of environments. We could specify this refinement type within the extendable, however we'll leverage the type alias so that other, future measurements can make use of it as well.

```
## ==== Type Aliases ====
_env (Type): String { x | x in { "testing", "staging", "production" } }

## ==== Extendables ====
_auth_service_common (Requires): { env: _env, endpoint: String }

## ==== Measurements ====
"Auth Success Rate" extends [_auth_service_common]:
  Requires {}
  Provides {
    indicators: {
      valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
      total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
    },
    evaluation: "total / valid"
  }

"Auth Latency"  extends [_auth_service_common]:
  Requires { threshold_in_seconds: Float }
  Provides {
    indicators: {
      latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
    },
    evaluation: "time_slice(latency < $$threshold_in_seconds$$ per 5m)"
  }
```

With our measurements now complete, we'll move on to expectations. For this example, our team owns all these expectations AND they're all for the same service. Thus, we put these within the same file. Let's setup the structure for our four expectations:

1. Signin Success Rate
2. Signin Latency
3. WhoAmI Success Rate
4. WhoAmI Latency

Note that we can call these whatever we want (and frankly the names here are pretty lackluster).

```
"Signin Success Rate":
  Guarantees __% over __ window as measured by "Auth Success Rate" with: {}

"WhoAmI Success Rate":
  Guarantees __% over __ window as measured by "Auth Success Rate" with: {}

"Signin Latency":
  Guarantees __% over __ window as measured by "Auth Latency" with: {}

"WhoAmI Latency":
  Guarantees __% over __ window as measured by "Auth Latency" with: {}
```

The `Guarantees` clause carries:

* a percentage target (e.g. `99.9%`)
* an `over <duration> window` clause (e.g. `over 30d window`)
* a `as measured by "<MeasurementName>" with: { ... }` tail that names the measurement and supplies its parameters

Each measurement requires:

* an `endpoint` name that is a `String`
* an `env` which is `testing`, `staging`, or `production`

And finally, specific to `Auth Latency` we need the `threshold_in_seconds` which is a Float.

With values according to the expectations of our users we came up with above we get:

```
"Signin Success Rate":
  Guarantees 99.9% over 30d window as measured by "Auth Success Rate" with: {
    endpoint: "sign-in",
    env: "production"
  }

"WhoAmI Success Rate":
  Guarantees 99% over 30d window as measured by "Auth Success Rate" with: {
    endpoint: "who-am-i",
    env: "production"
  }

"Signin Latency":
  Guarantees 99.9% over 30d window as measured by "Auth Latency" with: {
    endpoint: "sign-in",
    env: "production",
    threshold_in_seconds: 1
  }

"WhoAmI Latency":
  # more strict about the latency than the success rate for
  # threshold as well (the % of 5m intervals where the latency
  # is within the threshold_in_seconds)
  Guarantees 99.9% over 30d window as measured by "Auth Latency" with: {
    endpoint: "who-am-i",
    env: "production",
    threshold_in_seconds: 0.25
  }
```

And finally if we want, we can leverage a couple extendables to reduce duplication. Note that `threshold` and `window` are no longer extendable fields — they live in the `Guarantees` clause itself. Extendables only contribute fields to the `with: {...}` blueprint arguments:

```
## ==== Extendables ====
_common_sign_in (Provides): { endpoint: "sign-in", env: "production" }
_common_who_am_i (Provides): { endpoint: "who-am-i", env: "production" }

## ==== Expectations ====
"Signin Success Rate" extends [_common_sign_in]:
  Guarantees 99.9% over 30d window as measured by "Auth Success Rate" with: {}

"WhoAmI Success Rate" extends [_common_who_am_i]:
  Guarantees 99% over 30d window as measured by "Auth Success Rate" with: {}

"Signin Latency" extends [_common_sign_in]:
  Guarantees 99.9% over 30d window as measured by "Auth Latency" with: {
    threshold_in_seconds: 1
  }

"WhoAmI Latency" extends [_common_who_am_i]:
  # more strict about the latency than the success rate for
  # threshold as well (the % of 5m intervals where the latency
  # is within the threshold_in_seconds)
  Guarantees 99.9% over 30d window as measured by "Auth Latency" with: {
    threshold_in_seconds: 0.25
  }
```

And with that, we just need to compile everything, apply it, and we're well on our way to more reliably operating our production systems 🎉. In the name of Caffeine, go find a good ☕️ from your local cafe to celebrate! **You are now officially a Caffeine barista!**
