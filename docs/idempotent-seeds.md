<!-- docs/idempotent-seeds.md -->
# Idempotent Seed Practices

Seedbank organizes when seed files run. The Ruby inside each file still decides
whether a second run is safe. Treat every common or production seed as a
repeatable operation: running it twice should leave the same intended records
without duplicates or lost data.

## Choose the right mechanism

- **Reference and bootstrap seeds** create application-required records such as
  roles, plans, or countries. Keep these repeatable and safe in production.
- **Development and demo seeds** create disposable scenarios and sample data.
  Keep them under `db/seeds/development/` or another non-production environment.
- **Test factories** construct isolated test data. Keep them in the test suite;
  production seed tasks should not load factory libraries.
- **Data migrations** transform existing customer or operational data as part of
  a deployment. Use a reviewed, observable migration or one-off operational task,
  not a seed that silently repeats on every `db:seed` run.

## Repeatable Active Record patterns

Use a database-backed natural key or unique index to identify a reference row.
`find_or_create_by!` is suitable when attributes never need reconciliation:

```ruby
Role.find_or_create_by!(name: "administrator")
```

Use `find_or_initialize_by`, assignments, and `save!` when rerunning the seed
should update managed attributes:

```ruby
plan = Plan.find_or_initialize_by(code: "starter")
plan.assign_attributes(name: "Starter", monthly_price_cents: 1_500)
plan.save!
```

Use `upsert_all` for a well-defined bulk reference dataset when callbacks and
validations are intentionally unnecessary. Name the database uniqueness rule so
concurrent runs agree on record identity:

```ruby
Country.upsert_all(
  [
    { iso_code: "CA", name: "Canada" },
    { iso_code: "US", name: "United States" }
  ],
  unique_by: :index_countries_on_iso_code
)
```

Prefer bang methods so invalid reference data stops the seed run. Back application
identity rules with unique database indexes; a read followed by a create is not a
concurrency guarantee by itself.

## Destructive development data

Reset-style seeds can be useful for restoring a known local demo state, but they
must be environment-scoped. Put destructive code under
`db/seeds/development/` (or a similarly disposable environment), verify the
environment explicitly, and never make a common seed delete production data.

```ruby
raise "development seed only" unless Rails.env.development?

DemoAccount.where(seed_key: "onboarding").delete_all
DemoAccount.create!(seed_key: "onboarding", name: "Onboarding Demo")
```

Seed files are arbitrary Ruby. Seedbank cannot statically prove that they are
idempotent or safe, so review production seeds with the same care as application
and deployment code.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
