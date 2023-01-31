# Initial Infrastructure

### Initial setup

What you'll need:

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

### Getting Started with AWS

1. Sign up for an [AWS
   account](https://www.google.com/search?q=aws+free+account&oq=AWS+free+account&aqs=chrome.0.69i59j0i512l5j69i60l2.3577j0j4&sourceid=chrome&ie=UTF-8).
2. Create a S3 bucket in the Ohio region (us-east-2). You must specify this
   region because this is where the COVID-19
   public data lake exists. Use all the defaults.
3. Create an AWS access key that will be used as the Starburst Galaxy
   [Authentication method for connecting to S3](https://docs.starburst.io/starburst-galaxy/security/external-aws.html)
   - Go to the IAM Management Console
   - Select *Users*
   - Select *Add Users*
   - Provide a Descriptive User Name like ```<username>-aws-dbt```
   - Select AWS Credential Type: *Access key - Programmatic access*
   - Set Permissions: *Attach existing policies directly*
   - Add the following policy: *AmazonS3FullAccess*
4. Finish creating the access key with the rest of the defaults, and then save
   your AWS Access Key and Secret Access Key.

### Getting Started with Starburst Galaxy

#### Create the source AWS catalog in Starburst Galaxy

1. Sign up for a [Starburst
   Galaxy](https://www.starburst.io/platform/starburst-galaxy/) free trial.

2. Set up Starburst Galaxy and configure the S3 catalog to access your S3 bucket.

a. Navigate to the *Catalogs* tab. Click *Configure a Catalog*. Create an S3 Catalog.

- Catalog name: ```dbt_aws_source```
- Add a relevant description
- Authenticate to S3 through the AWS Access Key/Secret created earlier
- Metastore configuration: *"I don't have a metastore"*
- Default directory name: ```source```
- Enable *Allow creating external tables*
- Enable *Allow writing to external tables*
- Select default table format: *Hive*
- Hit *Skip* the *Set Permissions* page

More information on [connecting to S3](https://docs.starburst.io/starburst-galaxy/catalogs/s3.html).

#### Create a Cluster in Starburst Galaxy

A cluster in Starburst Galaxy provides the resources necessary to run queries
against your catalogs. You can access the catalog data exposed by running
clusters in the Query Editor.

- Click *Create a new cluster*
- Enter cluster name: ```dbt-aws```
- Also select the ```tpch``` cluster
- Cluster size: *Free*
- Cluster type: *Standard*
- Catalogs: ```dbt_aws_source``` (select the catalog previously created)
- Cloud provider region: *US East (Ohio)* aka *us-east-2*

#### Create the target AWS catalog in Starburst Galaxy

1. Configure a new S3 catalog to access your S3 bucket. This is optional, dependent on if you want your structure and consume tables in Iceberg format.

a. Navigate to the *Catalogs* tab. Click *Configure a Catalog*.
b. Create an S3 Catalog.

- Catalog name: ```dbt_aws_tgt```
- Add a relevant description
- Authenticate to S3 through the AWS Access Key/Secret created earlier
- Metastore configuration: *"I don't have a metastore"*
- Default directory name: ```target```
- Enable *Allow creating external tables*
- Enable *Allow writing to external tables*
- Select default table format: *Iceberg*
- Hit *Skip* the *Set Permissions* page
- Add this to the existing cluster ```dbt-aws```

#### Create a Snowflake catalog

Follow the [instructions to create and configure your Snowflake catalog](https://docs.starburst.io/starburst-galaxy/catalogs/snowflake.html). Give your catalog a descriptive name such as ```dbt-snow```. I made a snowflake account for the purpose of this demo and I didn't need to sign up for any legalities. Connect your catalog to the ```dbt-aws``` cluster. Once you log into snowflake (in the account admin role), navigate to the Marketplace tab on the left hand side. Search for the Free [COVID-19 Epidemiological Data](https://www.snowflake.com/datasets/starschema-covid-19-epidemiological-data/). Then click Open. Connect to the COVID19 database.

Note: You may need to update permissions if you do not have access to the account admin role.

```
grant import share on account to DEMOROLE;
grant create database on account to role DEMOROLE;
```

At this point, you should have at least 3 catalogs configured to your cluster. If you want to use Iceberg, you should have 4.

#### Create your AWS source tables

Since tpch is a sample catalog, and the COVID19.PUBLIC data from snowflake will automatically sync, the only source you need to create is the AWS table from the COVID-19 data lake.

1. Follow the [Starburst Galaxy data lake tutorial](https://docs.starburst.io/starburst-galaxy/tutorials/query-data-lake.html) to create the enigma_jhu table using the existing cluster and catalog you created.
2. Configure role-based access control - you need to add the COVID19 data lake and the bucket you created for this tutorial.

- `s3://covid19-lake/*`
- `s3://dbt-aws-<username>/*`

3. Create a schema in the source location you created earlier.

 ```
create schema aws_covid_data_lake with (location='s3://dbt-aws-<username>/');
```

4. Create the enigma_jhu table

```
CREATE TABLE enigma_jhu (
   fips VARCHAR,
   admin2 VARCHAR,
   province_state VARCHAR,
   country_region VARCHAR,
   last_update VARCHAR,
   latitude DOUBLE,
   longitude DOUBLE,
   confirmed INTEGER,
   deaths INTEGER,
   recovered INTEGER,
   active INTEGER,
   combined_key VARCHAR
)
WITH (
   format = 'json',
   EXTERNAL_LOCATION = 's3://covid19-lake/enigma-jhu/json/')
;
```

You should now be able to see all your sources within your cluster.
