# dbt + Trino: Starburst Galaxy covid demo

## Initial Intrastructure Work

Inspired by the [Cinco de Trino](https://github.com/dbt-labs/trino-dbt-tpch-demo) repo by [@jtcohen6](https://github.com/jtcohen6)!

There's a non-insignificant amount of setup work. The entire value prop of Trino and Galaxy is to be able to grab and transform data regardless of where it is. To demo this, you have to create at least one place for data to be and put data into it. Then you msut set up a Galaxy account and give it access to the external data stores as well as where output data will be stored. The silver lining is that you only have to do this once, ever!

For the data source setup required for this tutorial, please see [INFRA_SETUP.MD](INFRA_SETUP.MD).

## The demo itself

### Installing dbt in your local environment

1. Install the `dbt-trino` adapter plugin, which allows you to use dbt together with Trino / Starburst Galaxy. You may want to do this inside a Python virtual environment. Below I list the steps I took to create my virtual environment.

```sh
python3 -m venv dbt-env
```

```sh
source dbt-env/bin/activate
```

```sh
pip install --upgrade pip wheel setuptools
```

```sh
pip install dbt-trino
```

Make sure you are up to date on your versions.

```sh
dbt --version
```

Other helpful links to getting started with setting up your virtual environment:

- [Install with pip](https://docs.getdbt.com/docs/get-started/pip-install) dbt instructions
- [Starburst documentation](https://docs.starburst.io/data-consumer/clients/dbt.html) which dives into more detail about the process described above
- [Python download](https://www.python.org/downloads/)

### Getting Started with this repository

1. Clone this GitHub repo to your local machine: `git clone https://github.com/monimiller/dbt-galaxy-covid-demo.git`

2. Copy `sample.profiles.yml` to the root of your machine, `~/dbt/profiles.yml`. (Why? This file will contain your `password` for connecting to Trino/Starburst, so you don't want it checked into `git`.)

```
cp ./sample.profiles.yml ~/.dbt/profiles.yml
```

4. Open the file, and update the fields denoted by `<>` with your own user, password, cluster, etc. Specify dbt_aws_tgt as your catalog if you want Iceberg tables. If not, use dbt_aws_source. You can keep the sample schema.

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

## More on Starburst Galaxy

- Get started with the query federation tutorial!
- Get started with the data lake analytics tutorial!

## More on dbt + Trino

Watch recordings from past Trino community broadcasts:

- <https://trino.io/episodes/21.html>
- <https://trino.io/episodes/30.html>
