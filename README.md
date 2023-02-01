# dbt + Trino: Starburst Galaxy covid demo

Inspired by the [Cinco de Trino](https://github.com/dbt-labs/trino-dbt-tpch-demo) repo by [@jtcohen6](https://github.com/jtcohen6)!

There's a non-insignificant amount of setup work. The entire value prop of Trino and Galaxy is to be able to grab and transform data regardless of where it is. To demo this, you have to create at least one place for data to be and put data into it. Then you must set up a Galaxy account and give it access to the external data stores as well as where output data will be stored. The silver lining is that you only have to do this once, ever!

For the data source setup required for this tutorial, please see [INFRA_SETUP.MD](INFRA_SETUP.MD).

## What you'll need:

- A [Starburst Galaxy account](https://galaxy.starburst.io/login). This is the easiest way to get up and running with trino to see the power of trino + dbt.
- [AWS account to connect a catalog to S3](https://aws.amazon.com/free/?trk=78b916d7-7c94-4cab-98d9-0ce5e648dd5f&sc_channel=ps&s_kwcid=AL!4422!3!432339156165!e!!g!!aws%20account&ef_id=Cj0KCQjw166aBhDEARIsAMEyZh7cYVINX-G3ywOmeYJnSpMoRRr7xdxRScvE5qp5HqnDG0uTfIL_KFkaAtAGEALw_wcB:G:s&s_kwcid=AL!4422!3!432339156165!e!!g!!aws%20account&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all). AWS will act as a source and a target catalog in this example.
- Any snowflake login. [Sign up for a free account.](https://signup.snowflake.com/?utm_cta=trial-en-www-homepage-top-right-nav-ss-evg&_ga=2.209834001.529576585.1665973777-1488128661.1660321489) You don't need need snowflake for the demo, it would just require you to alter some models yourself.

Why are we using so many data sources? Well, for this data lakehouse tutorial we will take you through all the steps of creating a reporting structure, including the steps to get your sources into your land layer in S3. Starburst Galaxy's superpower with dbt is being able to federate data from multiple different sources into one dbt repository. Showing multiple sources helps demonstrate this use case in addition to the data lakehouse use case. If you are interested in only using S3, you can run all the `TPCH` and `AWS` models without having to create a snowflake login. The snowflake section will fail, but the rest should complete.

You will also need:

- A dbt installation of your choosing. I used a virtual environment on my M1 mac because that was the most recommended. I'll add the steps below in this readme. Review the other [dbt core installation information](https://docs.getdbt.com/dbt-cli/install/overview) to pick what works best for you.

### Tutorial Information

The goal of this tutorial is to showcase the power of dbt + Starburst Galaxy together. This tutorial aims to demonstrate both superpowers.

1. Query federation across multiple data sources - dbt specializes as a transform tool and can only be utilized after the data is landed in a storage solution. Starburst Galaxy fixes that by allowing you to query your data from multiple sources.
2. Data Lakehouse analytics - In this lab, we are going to build our lakehouse reporting structure in S3 and use slightly different naming conventions from the traditional Land, Structure, and Consume layer to accomodate for dbt standards. Land = Stage, Structure = Intermediate, Consume = Aggregate. For more information about the Starburst data lakehouse, visit this [blog](https://www.starburst.io/blog/part-2-of-current-data-patterns-blog-series-data-lakehouse/).

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
