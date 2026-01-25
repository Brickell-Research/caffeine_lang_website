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

The first step here is to define the blueprints for the `SLO` artifact. The typical process is:

1. figure out which type of SLO we're working with. For success rate we usually use a `Ratio` and for latency over time we use a `Time Slice`.
2. determine the queries needed to emulate the user journeys and satisfy the SLO types. This is the `queries` attribute.
3. for each of the queries, what attributes do we need? Per attribute, define the template variable within the query string and add the attribute to the `requires` block.
4. define the `value` based on (1) and (2).
5. for now we only have `datadog` as a vendor, so specify the vendor in the `provides` block.
6. consider _DRYing_ up definitions with either extendables or type aliases

Ok, let's walk through this.

**Note:** even though we only support one vendor, it's possible that each Caffeine user's Datadog instance will be setup differently, so we won't dive too deep into query specifics.

First, let's define the structure of each blueprint. Here is what the basic outline looks like. We will have two blueprints, one for `Auth Success Rate` and one for `Auth Latency`.

```
Blueprints for "SLO"
  * "Auth Success Rate":
    Requires {}
    Provides {}
  * "Auth Latency":
    Requires {}
    Provides {}
```

We already did the groundwork for step one by choosing the SLO types, for step two we fill in the queries.

```
Blueprints for "SLO"
  * "Auth Success Rate":
    Requires {}
    Provides {
      queries: {
        valid: "sum:requests{status:valid}",
        total: "sum:requests{}"
      }
    }
  * "Auth Latency":
    Requires {}
    Provides {
      queries: {
        latency: "p75:latency{}"
      }
    }
```

Again, there is a lot of thinking and iteration to ensure your queries (SLIs) properly reflect the user experience you intend to emulate/capture. This topic is beyond the scope of the tour.

For step (3) we want to ensure we're (a) pointing at the right environment and (b) filtering to the correct endpoint. So, we update our query strings and requires blocks. For now we'll just type these two attributes as `String` and `String`.

```
Blueprints for "SLO"
  * "Auth Success Rate":
    Requires {
      env: String,
      endpoint: String
    }
    Provides {
      queries: {
        valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
        total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
      }
    }
  * "Auth Latency":
    Requires {
      env: String,
      endpoint: String
    }
    Provides {
      queries: {
        latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
      }
    }
```

For step (4), we now have all our queries and know which type of SLO we're working with, so we can declare the `value` within the `provides` block. We'll also complete step (5) too since it's straightforward. For the Time Slice we actually have an extra `require` to add for the `threshold_in_seconds`.

```
Blueprints for "SLO"
  * "Auth Success Rate":
    Requires {
      env: String,
      endpoint: String
    }
    Provides {
      queries: {
        valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
        total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
      },
      value: "valid / total",
      vendor: "datadog"
    }
  * "Auth Latency":
    Requires {
      env: String,
      endpoint: String,
      threshold_in_seconds: Float
    }
    Provides {
      queries: {
        latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
      },
      value: "time_slice(latency < $$threshold_in_seconds$$ per 5m)",
      vendor: "datadog"
    }
```

And we have our blueprints fully defined! If unsure, reference the artifact definition in the `Artifacts - Service Level Objectives` lesson.

We could stop here, however we'll reduce duplication with a couple extendables.

```
## ==== Extendables ====
_datadog (Provides): { vendor: "datadog" }
_auth_service_common (Requires): { env: String, endpoint: String }

## ==== Blueprints ====
Blueprints for "SLO"
  * "Auth Success Rate" extends [_datadog, _auth_service_common]:
    Requires {}
    Provides {
      queries: {
        valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
        total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
      },
      value: "valid / total"
    }
  * "Auth Latency"  extends [_datadog, _auth_service_common]:
    Requires { threshold_in_seconds: Float }
    Provides {
      queries: {
        latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
      },
      value: "time_slice(latency < $$threshold_in_seconds$$ per 5m)"
    }
```

Furthermore, while there are 100s of endpoints (our auth service is huge!!!) we know that there are only a handful of environments. We could specify this refinement type within the extendable, however we'll leverage the type alias so that other, future blueprints can make use of it as well.

```
## ==== Type Aliases ====
_env (Type): String { x | x in { "testing", "staging", "production" } }

## ==== Extendables ====
_datadog (Provides): { vendor: "datadog" }
_auth_service_common (Requires): { env: _env, endpoint: String }

## ==== Blueprints ====
Blueprints for "SLO"
  * "Auth Success Rate" extends [_datadog, _auth_service_common]:
    Requires {}
    Provides {
      queries: {
        valid: "sum:requests{status:valid, $$environment->env$$, $$endpoint->endpoint$$}",
        total: "sum:requests{$$environment->env$$, $$endpoint->endpoint$$}"
      },
      value: "valid / total"
    }
  * "Auth Latency"  extends [_datadog, _auth_service_common]:
    Requires { threshold_in_seconds: Float }
    Provides {
      queries: {
        latency: "p75:latency{$$environment->env$$, $$endpoint->endpoint$$}"
      },
      value: "time_slice(latency < $$threshold_in_seconds$$ per 5m)"
    }
```

With our blueprints now complete, we'll move on to expectations. For this example, our team owns all these expectations AND they're all for the same service. Thus, we put these within the same file. Let's setup the structure for our four expectations:

1. Signin Success Rate
2. Signin Latency
3. WhoAmI Success Rate
4. WhoAmI Latency

Note that we can call these whatever we want (and frankly the names here are pretty lackluster).

```
Expectations for "Auth Success Rate"
* "Signin Success Rate":
  Provides {}
* "WhoAmI Success Rate"
  Provides {}

Expectations for "Auth Latency"
* "Signin Latency"
  Provides {}
* "WhoAmI Latency"
  Provides {}
```

So if you recall, there are two `SLO` artifact specific `provides` we need to satisfy:

* a `window_in_days` which is an `Integer` of 7, 30, or 90 (_seem odd?_ well, yes. These are specific to a Datadog restriction and will likely be lifted in the future.)
* a `threshold` which is a `Float` between 0.0 and 100.0

Furthermore, each blueprint requires:

* an `endpoint` name that is a `String`
* an `env` which is `testing`, `staging`, or `production`

And finally, specific to `Auth Latency` we need the `threshold_in_seconds` which is a Float.

With values according to the expectations of our users we came up with above we get:

```
Expectations for "Auth Success Rate"
* "Signin Success Rate":
  Provides {
    window_in_days: 30,
    threshold: 99.9,
    endpoint: "sign-in",
    env: "production"
  }
* "WhoAmI Success Rate":
  Provides {
    window_in_days: 30,
    threshold: 99,
    endpoint: "who-am-i",
    env: "production"
  }

Expectations for "Auth Latency"
* "Signin Latency":
  Provides {
    window_in_days: 30,
    threshold: 99.9,
    endpoint: "sign-in",
    env: "production",
    threshold_in_seconds: 1
  }
* "WhoAmI Latency":
  Provides {
    window_in_days: 30,
    # more strict about the latency than the success rate for
    # threshold as well (the % of 5m intervals where the latency
    # is within the threshold_in_seconds)
    threshold: 99.9,
    endpoint: "who-am-i",
    env: "production",
    threshold_in_seconds: 0.25
  }
```

And finally if we want, we can leverage a couple extendables to reduce duplication.


```
## ==== Extendables ====
_common_sign_in (Provides): { endpoint: "sign-in",  env: "production" }
_common_who_am_i (Provides): { endpoint: "who-am-i",  env: "production" }
# optionally we can even observe 30 days is a good
# window_in_days for all expectations in this file
_common_basic (Provides): { window_in_days: 30 }

## ==== Expectations ====
Expectations for "Auth Success Rate"
* "Signin Success Rate" extends [_common_basic, _common_sign_in]:
  Provides {
    threshold: 99.9
  }
* "WhoAmI Success Rate" extends [_common_basic, _common_who_am_i]:
  Provides {
    threshold: 99
  }

Expectations for "Auth Latency"
* "Signin Latency" extends [_common_basic, _common_sign_in]:
  Provides {
    threshold: 99.9,
    threshold_in_seconds: 1
  }
* "WhoAmI Latency" extends [_common_basic, _common_who_am_i]:
  Provides {
    # more strict about the latency than the success rate for
    # threshold as well (the % of 5m intervals where the latency
    # is within the threshold_in_seconds)
    threshold: 99.9,
    threshold_in_seconds: 0.25
  }
```

And with that, we just need to compile everything, apply it, and we're well on our way to more reliably operating our production systems 🎉. In the name of Caffeine, go find a good ☕️ from your local cafe to celebrate! **You are now officially a Caffeine barista!**
