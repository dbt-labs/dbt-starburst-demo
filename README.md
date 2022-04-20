## dbt + Trino: TPC-H demo

Presented at [Cinco de Trino](https://www.starburst.io/info/cinco-de-trino/)!

Inspired by:
- [matt-winkler/demo-snowflake-tpch](https://github.com/matt-winkler/demo-snowflake-tpch)
- [dbt-labs/databricks_dbt_demo_project](https://github.com/dbt-labs/databricks_dbt_demo_project)

### Initial setup

What you'll need:

- `tpch` catalog, giving you access to the standard TPC-H source dataset
- `analytics` catalog, in which to save your transformed datasets (dbt models)
- Compute resource with access to both of those catalogs

I used Starburst Galaxy to get up & running quickly. I was able to configure the TPC-H "source" catalog, my analytical "target" catalog (S3 + Starburst Galaxy metastore), and use the free "sample" cluster with access to both:
- https://docs.starburst.io/starburst-galaxy/catalogs/tpch.html
- https://docs.starburst.io/starburst-galaxy/catalogs/s3.html

Relevant docs if using self-hosted Trino:
- https://trino.io/docs/current/connector/tpch.html
- https://trino.io/docs/current/connector/hive-s3.html

### Getting started

1. Clone this GitHub repo to your local machine: `git clone https://github.com/dbt-labs/trino-dbt-tpch-demo.git`

2. Install the `dbt-trino` adapter plugin, which allows you to use dbt together with Trino / Starburst Galaxy. You may want to do this inside a Python virtual environment.

```
pip install dbt-trino
```

3. Copy `sample.profiles.yml` to the root of your machine, `~/dbt/profiles.yml`. (Why? This file will contain your `password` for connecting to Trino/Starburst, so you don't want it checked into `git`.)

```
$ cp ./sample.profiles.yml ~/.dbt/profiles.yml
```

4. Open the file, and update the fields denoted by `<>` with your own user, password, cluster, etc.

5. Verify that you can connect to Trino / Starburst Galaxy. (If your Galaxy cluster is stopped, it may take a few moments for it to resume.)
```
dbt debug
```

6. Install dbt packages ([`dbt_utils`](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)) for use in the project:
```
dbt deps
```

7. Try running dbt:
```
dbt run
dbt test
dbt build
```

8. Generate and view documentation:
```
dbt docs generate
dbt docs serve
```

9. You may find you want to do things like...
    - Fix a failing test
    - Reenable models with more complex transformations: [`models/marts/aggregates`](models/marts/aggregates) and [`all_months`](models/utils/all_months)
    - Write some models of your own!

## More on dbt

- Read the [introduction](https://docs.getdbt.com/docs/introduction/) and [viewpoint](https://docs.getdbt.com/docs/about/viewpoint/)
- Be part of the conversation in the [dbt Community Slack](http://community.getdbt.com/)

## More on dbt + Trino

Watch recordings from past Trino community broadcasts:
- https://trino.io/episodes/21.html
- https://trino.io/episodes/30.html
