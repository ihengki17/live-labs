# Build end-to-end streaming data pipelines fast

Welcome to HappyFeet store - Where Every Step Matters! In this workshop, we harness the power of customer data, clickstreams, and order information to identify customers who spend minimal time on our website. Our goal is to launch a targeted marketing campaign that re-engages these customers, ensuring that every second they spend on our website is worthwhile. Join us in this journey to provide a personalized and memorable shopping experience at HappyFeet, where style, comfort, and exceptional customer service converge.

<div align="center"> 
  <img src="images/update_diagram.png" width =100% heigth=100%>
</div>

---

# Requirements

In order to successfully complete this demo you need to install few tools before getting started.

- If you don't have a Confluent Cloud account, sign up for a free trial [here](https://www.confluent.io/confluent-cloud/tryfree).
- If you don't have a Imply Polaris account, sign up for a free trial
    [here](https://bit.ly/3XCK1fY)
- Install Confluent Cloud CLI by following the instructions [here](https://docs.confluent.io/confluent-cli/current/install.html).
- Download and Install Terraform [here](https://developer.hashicorp.com/terraform/downloads?ajs_aid=837a4ee4-253b-4b3d-bf11-952575792ad1&product_intent=terraform)

  > **Note:** This demo was built and validate on a Mac (x86).

## Setup

1. This demo uses Terraform and bash scripting to create and teardown infrastructure and resources.

1. Clone and enter this repository.

   ```bash
   git clone https://github.com/confluentinc/live-labs.git
   cd DIMT2024-ID
   ```

1. Create an `.accounts` file by running the following command.

   ```bash
   echo "CONFLUENT_CLOUD_EMAIL=add_your_email\nCONFLUENT_CLOUD_PASSWORD=add_your_password\nexport TF_VAR_confluent_cloud_api_key=\"add_your_api_key\"\nexport TF_VAR_confluent_cloud_api_secret=\"add_your_api_secret\"\nexport 
   ```

   > **Note:** This repo ignores `.accounts` file

### Confluent Cloud

Create Confluent Cloud API keys by following [this](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/guides/sample-project#create-a-cloud-api-key) guide.

> **Note:** This is different than Kafka cluster API keys.

### Update the accounts file

Update the `.accounts` file for the following variables with your credentials.

```bash
 CONFLUENT_CLOUD_EMAIL=<replace>
 CONFLUENT_CLOUD_PASSWORD=<replace>
 export TF_VAR_confluent_cloud_api_key="<replace>"
 export TF_VAR_confluent_cloud_api_secret="<replace>"
```

### Create a local environment file

1. Navigate to the `confluent` directory of the project and run `create_env.sh` script. This bash script copies the content of `.accounts` file into a new file called `.env` and append additional variables to it.

   ```bash
   cd DIMT2024-ID/confluent
   ./create_env.sh
   ```

1. Source `.env` file.

   ```bash
   source ../.env
   ```

   > **Note:** if you don't source `.env` file you'll be prompted to manually provide the values through command line when running Terraform commands.

### Build your cloud infrastructure

<details>
    <summary><b>Terraform</b></summary>
1. Navigate to the repo's terraform directory.

   ```bash
   cd DIMT2024-ID/terraform
   ```

1. Initialize Terraform within the directory.
   ```bash
   terraform init
   ```
1. Create the Terraform plan.
   ```bash
   terraform plan
   ```
1. Apply the plan to create the infrastructure. You can run `terraform apply -auto-approve` to bypass the approval prompt.

   ```bash
   terraform apply
   ```

   > **Note:** Read the `main.tf` configuration file [to see what will be created](./terraform/main.tf).

1. Write the output of `terraform` to a JSON file. The `setup.sh` script will parse the JSON file to update the `.env` file.

   ```bash
   terraform output -json > ../resources.json
   ```

1. Run the `setup.sh` script.
   ```bash
   cd DIMT2024-ID/confluent
   ./setup.sh
   ```
1. This script achieves the following:

   - Creates an API key pair that will be used in connectors' configuration files for authentication purposes.
   - Updates the `.env` file to replace the remaining variables with the newly generated values.

1. Source `.env` file.

   ```bash
   source ../.env
   ```
</details>
<br>

<details>
    <summary><b>Cloud Console UI</b></summary>
1. Log into [Confluent Cloud](https://confluent.cloud) and enter your email and password.

<div align="center" padding=25px>
    <img src="images/login.png" width=50% height=50%>
</div>

2. If you are logging in for the first time, you will see a self-guided wizard that walks you through spinning up a cluster. Please minimize this as you will walk through those steps in this workshop. 

3. Click **+ Add Environment**. Specify an **Environment Name** and Click **Create**. 

>**Note:** There is a *default* environment ready in your account upon account creation. You can use this *default* environment for the purpose of this workshop if you do not wish to create an additional environment.

<div align="center" padding=25px>
    <img src="images/environment.png" width=50% height=50%>
</div>

4. Select **Essentials** for Stream Governance Packages, click **Begin configuration**.

<div align="center" padding=25px>
    <img src="images/stream-governance-1.png" width=50% height=50%>
</div>

5. Select **AWS Singapore Region** for Stream Governance Essentials, click **Continue**.

6. Now that you have an environment, click **Create Cluster**. 

> **Note:** Confluent Cloud clusters are available in 3 types: Basic, Standard, and Dedicated. Basic is intended for development use cases so you will use that for the workshop. Basic clusters only support single zone availability. Standard and Dedicated clusters are intended for production use and support Multi-zone deployments. If you are interested in learning more about the different types of clusters and their associated features and limits, refer to this [documentation](https://docs.confluent.io/current/cloud/clusters/cluster-types.html).

7. Chose the **Basic** cluster type. 

<div align="center" padding=25px>
    <img src="images/cluster-type.png" width=50% height=50%>
</div>

8. Click **Begin Configuration**. 
9. Choose your preferred Cloud Provider (AWS, GCP, or Azure) on **Singapore Region**. 
10. Specify a **Cluster Name**. For the purpose of this lab, any name will work here. 

<div align="center" padding=25px>
    <img src="images/create-cluster.png" width=50% height=50%>
</div>

11. View the associated *Configuration & Cost*, *Usage Limits*, and *Uptime SLA* information before launching. 
12. Click **Launch Cluster**. 

13. On the navigation menu, select **Flink** and click **Create Compute Pool**.

<div align="center" padding=25px>
    <img src="images/create-flink-pool-1.png" width=50% height=50%>
</div>

14. Select **Singapore Region** on the same Cloud Service Provider as your Confluent Cluster and then **Continue**.
<div align="center" padding=25px>
    <img src="images/create-flink-pool-2.png" width=50% height=50%>
</div>

15. Name you Pool Name and set the capacity units (CFUs) to **5**. Click **Finish**.

<div align="center" padding=25px>
    <img src="images/create-flink-pool-3.png" width=50% height=50%>
</div>

> **Note:** The capacity of a compute pool is measured in CFUs. Compute pools expand and shrink automatically based on the resources required by the statements using them. A compute pool without any running statements scale down to zero. The maximum size of a compute pool is configured during creation. 

16. Flink Compute pools will be ready shortly. You can click **Open SQL workspace** when the pool is ready to use.

<div align="center" padding=25px>
    <img src="images/create-flink-pool-4.png" width=50% height=50%>
</div>

17. Change your workspace name by clicking **settings button**. Click **Save changes** after you update the workspace name.

<div align="center" padding=25px>
    <img src="images/flink-workspace-1.png" width=50% height=50%>
</div>

18. Set the default Catalog as your environment name.

<div align="center" padding=25px>
    <img src="images/flink-workspace-2.png" width=50% height=50%>
</div>

19. Set the default Database as your cluster name.

<div align="center" padding=25px>
    <img src="images/flink-workspace-3.png" width=50% height=50%>
</div>
</details>
<br>

# Demo

## Configure Source Connectors

Confluent offers 120+ pre-built [connectors](https://www.confluent.io/product/confluent-connectors/), enabling you to modernize your entire data architecture even faster. These connectors also provide you peace-of-mind with enterprise-grade security, reliability, compatibility, and support.

### Automated Connector Configuration File Creation

You can use Confluent Cloud CLI to submit all the source connectors automatically.

Run a script that uses your `.env` file to generate real connector configuration json files from the example files located in the `confluent` folder.

```bash
cd DIMT2024-ID/confluent
./create_connector_files.sh
./create_connectors.sh
```

### Produce Sample Data

You can create the connector either through CLI or Confluent Cloud web UI.

<details>
    <summary><b>CLI</b></summary>

1. Log into your Confluent account in the CLI.

   ```bash
   confluent login --save
   ```

1. Use your environment and your cluster.

   ```bash
   confluent environment list
   confluent environment use <your_env_id>
   confluent kafka cluster list
   confluent kafka cluster use <your_cluster_id>
   ```

1. Run the following commands to create Datagen source connectors.

   ```bash
   cd DIMT2024-ID/confluent
   confluent connect cluster create --config-file actual_datagen_clickstream.json
   confluent connect cluster create --config-file actual_datagen_shoe_customers.json
   confluent connect cluster create --config-file actual_datagen_shoe_orders.json
   confluent connect cluster create --config-file actual_datagen_shoes.json
   ```

</details>
<br>

<details>
    <summary><b>Confluent Cloud Web UI</b></summary>

1. Log into Confluent Cloud by navigating to confluent.io and click on the **Login** on the top right corner.
2. Step into **Data_In_Motion_Tour** environment or your existing environment.
3. Step into **dimt_kafka_cluster** or your new created cluster.

##You could skip to step number 12 if you've build the environment using Terraform

4. On the same navigation menu, select **Topics** and click **Create Topic**. 
5. Enter **clickstream** as the topic name, **1** as the number of partitions, and then click **Create with defaults**.
5. Repeat the previous step and create a second topic name **customers** and **1** as the number of partitions.
6. Repeat the previous step and create a second topic name **orders** and **1** as the number of partitions.
7. Repeat the previous step and create a second topic name **shoes** and **1** as the number of partitions.
8. Click **API Keys** on the navigation menu. 
9. Click **Create Key** in order to create your first API Key. If you have an existing API Key select **+ Add Key** to create another API Key.

<div align="center" padding=25px>
    <img src="images/create-apikey.png" width=75% height=75%>
</div>

10. Select **Global Access** and then click **Next**. 
11. Copy or save your API Key and Secret somewhere. You will need these later on in the lab, you will not be able to view the secret again once you close this dialogue. 

12. On the navigation menu, select **Connectors** and then **+ Add connector**.
13. In the search bar search for **Sample Data** and select the **Sample Data** which is a fully-managed connector.
14. Create the connector that will send data to **clickstream**. From the Confluent Cloud UI, click on the **Connectors** tab on the navigation menu. Click on the **Datagen Source** icon.

<div align="center" padding=25px>
    <img src="images/connectors.png" width=75% height=75%>
</div>

15. Enter the following configuration details. The remaining fields can be left blank.

<div align="center">

| setting                            | value                        |
|------------------------------------|------------------------------|
| name                               | DatagenSourceConnector_clickstream   | 
| api key                            | [*from step 8* ]             |
| api secret                         | [*from step 8* ]             |
| topic                              | clickstream                  |
| output message format              | AVRO                         |
| quickstart                         | SHOE_CLICKSTREAM             |
| max interval between messages (ms) | 1000                         |
| tasks                              | 1                            |
</div>

<div align="center" padding=25px>
    <img src="images/datagen-1.png" width=75% height=75%>
    <img src="images/datagen-2.png" width=75% height=75%>
</div>

16. Click on **Show advanced configurations** and complete the necessary fields and click **Continue**.

<div align="center" padding=25px>
    <img src="images/datagen-3.png" width=75% height=75%>
</div>
   
17. Before launching the connector, you should see something similar to the following. If everything looks similar, select **Launch**. 

18. Repeat the same step to create another 3 connectors with this configuration.

<div align="center">

| setting                            | value                        |
|------------------------------------|------------------------------|
| name                               | DatagenSourceConnector_shoe_customers   | 
| api key                            | [*from step 8* ]             |
| api secret                         | [*from step 8* ]             |
| topic                              | customers                    |
| output message format              | AVRO                         |
| quickstart                         | SHOE_CUSTOMERS               |
| max interval between messages (ms) | 1000                         |
| tasks                              | 1                            |
</div>

<div align="center">

| setting                            | value                        |
|------------------------------------|------------------------------|
| name                               | DatagenSourceConnector_shoe_orders   | 
| api key                            | [*from step 8* ]             |
| api secret                         | [*from step 8* ]             |
| topic                              | orders                       |
| output message format              | AVRO                         |
| quickstart                         | SHOE_ORDERS                  |
| max interval between messages (ms) | 1000                         |
| tasks                              | 1                            |
</div>

<div align="center">

| setting                            | value                        |
|------------------------------------|------------------------------|
| name                               | DatagenSourceConnector_shoes   | 
| api key                            | [*from step 8* ]             |
| api secret                         | [*from step 8* ]             |
| topic                              | shoes                        |
| output message format              | AVRO                         |
| quickstart                         | SHOES                        |
| max interval between messages (ms) | 1000                         |
| tasks                              | 1                            |
</div>

</details>
<br>

Once all connectors are fully provisioned, check for and troubleshoot any failures that occur. Properly configured, each connector begins reading data automatically.

## Process and Enrich Data Streams with Flink SQL

Now that you have data flowing through Confluent, you can now easily build stream processing applications using Flink SQL. You are able to continuously transform, enrich, join, and aggregate your data using SQL syntax. You can gain value from your data directly from Confluent in real-time. Also, Confluent Cloud for Flink provides a truly cloud-native experience for Flink. You don’t need to know about or interact with Flink clusters, state backends, checkpointing, and all of the other aspects that are usually involved when operating a production-ready Flink deployment.

If you’re interested in learning more about Flink, you can take the Apache Flink 101 course on Confluent Developer [website](https://developer.confluent.io/courses/apache-flink/intro/).

1.  Log into Confluent Cloud web UI, then click on **Data_In_Motion_Tour** environment.
1.  Click on **Flink (preview)** and then **Open SQL workspace**.
1.  On the top right corner of your workspace select **Data_In_Motion_Tour** as the catalog and **dimt_kafka_cluster** as your database.

    > **Note:** Refer to the [docs](https://docs.confluent.io/cloud/current/flink/index.html#metadata-mapping-between-ak-cluster-topics-schemas-and-af) to understand the mapping between Kafka and Flink.

1.  On the left-hand side under **Navigator** menu, click the arrow to expand the **Data_In_Motion_Tour** Kafka environment, and expand the **dimt_kafka_cluster** to see existing Kafka topics.

1.  You will use the code editor to query existing Flink tables (Kafka topics) and to write new queries.

1.  To write a new query, click on the **+** icon to create a new cell.

    > **Note:** For your convenience, all Flink queries are availble in the [flink.sql](./confluent/flink.sql) file.

1.  See how `orders` table was created
    ```sql
    SHOW CREATE TABLE orders;
    ```
1.  Explore the `orders` table

    ```sql
    SELECT * FROM orders;
    ```

1.  Create a table to count the unique purchases per minute. In a real world scenario an hourly window is probably more appropriate, but for the purpose of this lab we'll use minute.

    ```sql
    CREATE TABLE sales_per_minute (
        window_start TIMESTAMP(3),
        window_end   TIMESTAMP(3),
        nr_of_orders BIGINT
    );
    ```

1.  Confluent Cloud introduces the concept of system columns. You will use the `SYSTEM` column `$rowtime` for `DESCRIPTOR` parameter when performing windowed aggregations with Flink SQL in Confluent Cloud. Otherwise you can define your own `WATERMARK` [strategy](https://docs.confluent.io/cloud/current/flink/concepts/timely-stream-processing.html#time-and-watermarks-in-af) when creating new tables. [Tumbling windows](https://docs.confluent.io/cloud/current/flink/reference/queries/window-tvf.html#tumble) is a table-valued function (TVF) for dividing data into non-overlapping, fixed-size windows. This is useful when you want to analyze data in discrete time intervals. Now you can materialize number of unique purchase per minute in the newly created topic.

    ```sql
    INSERT INTO sales_per_minute
        SELECT window_start, window_end, COUNT(DISTINCT order_id) as nr_of_orders
        FROM TABLE(
            TUMBLE(TABLE orders, DESCRIPTOR(`$rowtime`), INTERVAL '1' MINUTE))
        GROUP BY window_start, window_end;
    ```

1.  Query the `sales_per_minute` table and review the data

    ```sql
    SELECT * FROM sales_per_minute;
    ```

1.  Let's see how many records we have in the `shoes` table with the `id = '3586de8a-10a3-4997-96bf-9e08a3a7fb82'`. The connector generates random events which results in duplicated `id`. Since there are more than 1 records, you need to deduplicate the table.

    ```sql
    SELECT * FROM shoes WHERE id = '3586de8a-10a3-4997-96bf-9e08a3a7fb82';
    ```

1.  [Deduplication](https://docs.confluent.io/cloud/current/flink/reference/queries/deduplication.html) removes duplicate rows over a set of columns, keeping only the first or last row. Flink SQL uses the `ROW_NUMBER()` function to remove duplicates, similar to its usage in [Top-N Queries](https://docs.confluent.io/cloud/current/flink/reference/queries/topn.html#flink-sql-top-n). Deduplication is a special case of the Top-N query, in which `N` is `1` and row order is by processing time or event time. In some cases, an upstream ETL job isn’t end-to-end exactly-once, which may cause duplicate records in the sink, in case of failover. Duplicate records affect the correctness of downstream analytical jobs, like `SUM` and `COUNT`, so deduplication is required before further analysis can continue.

    ```sql
    SELECT id, name, brand
    FROM (
        SELECT *,
            ROW_NUMBER() OVER (PARTITION BY id ORDER BY $rowtime DESC) AS row_num
        FROM `shoes`)
    WHERE row_num = 1
    ```

    Let's take a look at different parts of the above query:

    - `ROW_NUMBER()` starting at one, this assigns a unique, sequential number to each row
    - `PARTITION BY` specifies how to partition the data for deduplication. This should be the column(s) which will only have one row per value after deduplication. In this case it's column `id`
    - `ORDER BY` orders by the provided column and it’s required to be a time attribute. The time attribute column can be processing time (system time of the machine running the Flink job) or event time. By default `ORDER BY` puts rows in ascending (`ASC`) order. By using `ASC` order you’ll keep the first row. Should you want to keep the last row you should use `ORDER BY <time_attribute> DESC`. Refer to [this](https://developer.confluent.io/tutorials/finding-distinct-events/flinksql.html) tutorial to learn more deduplication with Flink SQL.

1.  Since the output of the transient query looks right, the next step is to make the query persistent. This looks exactly like the transient query, except you first create a new table and then execute an `INSERT INTO` statement to populate the table. The `INSERT INTO` statement returns to the CLI prompt right away, having created a persistent stream processing program running in the Flink cluster, continuously processing input records and updating the resulting `deduplicated_shoes` table. A primary key constraint is a hint for Flink SQL to leverage for optimizations which specifies that a column or a set of columns in a table or a view are unique and they do not contain null. No columns in a primary key can be nullable. A primary key uniquely identifies a row in a table.

    ```sql
    CREATE TABLE deduplicated_shoes(
        id STRING,
        brand STRING,
        name STRING,
        sale_price INT,
        rating DOUBLE,
        PRIMARY KEY (id) NOT ENFORCED
    );

    INSERT INTO deduplicated_shoes(
        SELECT id, brand, name, sale_price, rating
        FROM (
            SELECT *,
                ROW_NUMBER() OVER (PARTITION BY id ORDER BY $rowtime DESC) AS row_num
            FROM `shoes`)
        WHERE row_num = 1
    );
    ```

1.  Now that you have `deduplicated_shoes` table you can join it with `clickstream`.

    ```sql
    SELECT
        c.`$rowtime`,
        c.product_id,
        s.name,
        s.brand
    FROM
        clickstream c
        INNER JOIN deduplicated_shoes s ON c.product_id = s.id;
    ```

1.  Create a table to find all users with average view time of less then 30 seconds. You'll achieve this by using Pattern Recognition. Refer to the [doc](https://docs.confluent.io/cloud/current/flink/reference/queries/match_recognize.html) for detailed information about Pattern Recoginition and how `MATCH_RECOGNIZE` works.

    ```sql
    CREATE TABLE inactive_users(
        user_id STRING,
        start_tstamp TIMESTAMP(3),
        end_tstamp TIMESTAMP(3),
        avgViewTime INT
    );

    INSERT INTO inactive_users
    SELECT *
    FROM clickstream
        MATCH_RECOGNIZE (
            PARTITION BY user_id
            ORDER BY `$rowtime`
            MEASURES
                FIRST(A.`$rowtime`) AS start_tstamp,
                LAST(A.`$rowtime`) AS end_tstamp,
                AVG(A.view_time) AS avgViewTime
            ONE ROW PER MATCH
            AFTER MATCH SKIP PAST LAST ROW
            PATTERN (A+ B)
            DEFINE
                A AS AVG(A.view_time) < 30
        ) MR;
    ```

1.  Now that you have a table of users who spend less than 30 seconds on the website, you can join it with `customers` table to retrive their contact information. Then you can stream this data in real time to MongoDB Atlas database where your marketing department can use this data to build a new campaign.
    ```sql
    CREATE TABLE inactive_customers_enriched(
        user_id STRING,
        avgViewTime INT,
        first_name STRING,
        last_name STRING,
        email STRING
    );
    INSERT INTO inactive_customers_enriched
    	SELECT
    		u.user_id,
    		u.avgViewTime,
    		c.first_name,
    		c.last_name,
    		c.email
    	FROM
    		inactive_users u
    		INNER JOIN customers c ON u.user_id = c.id;
    ```

---

## Connect Imply Polaris to Confluent Cloud

You can create the connection from Confluent Cloud to Imply Polaris using the connector on Kafka Ingestion on Imply Polaris.

1. Sign-in to Imply Polaris using your own organization domain and credentials
https://id.imply.io/auth/

<div align="center" padding=25px>
    <img src="images/signinpolaris-1.png" width=75% height=75%>
    <img src="images/signinpolaris.png" width=75% height=75%>
</div>

2. Create Connector from Confluent Cloud into Imply (Job)

<div align="center" padding=25px>
    <img src="images/cc-imply-1.png" width=75% height=75%>
</div>

3. Create a new table for the DIMT

<div align="center" padding=25px>
    <img src="images/cc-imply-2.png" width=75% height=75%>
</div>

4. Create the Connection for Confluent Cloud

<div align="center" padding=25px>
    <img src="images/cc-imply-3.png" width=75% height=75%>
</div>

5. Fill all the columns using your Confluent Cloud environment and Credentials and click create connection then you could proceed by click **next** on the right top

<div align="center" padding=25px>
    <img src="images/cc-imply-4.png" width=75% height=75%>
</div>

6. Now we need to create connection over our stream governance to parsing the schemas or structure to Imply Table.

<div align="center" padding=25px>
    <img src="images/cc-imply-5.png" width=75% height=75%>
    <img src="images/cc-imply-6.png" width=75% height=75%>
    <img src="images/cc-imply-7.png" width=75% height=75%>
</div>

click **continue** if you see the data has been shown on the table.

7. Click **start ingestion** and we will see in a minute that our table will be ingested by the data from Confluent Cloud

<div align="center" padding=25px>
    <img src="images/cc-imply-8.png" width=75% height=75%>
    <img src="images/cc-imply-9.png" width=75% height=75%>
</div>


---

## CONGRATULATIONS

Congratulations on building your streaming data pipelines in Confluent Cloud! Your complete pipeline should resemble the following one.

   <div align="center"> 
      <img src="images/stream_lineage.png">
   </div>

---

# Teardown

1. Run the following command to delete all connectors

   ```bash
   cd DIMT2024-ID/confluent
   ./teardown_connectors.sh
   ```

1. Run the following command to delete all resources created by Terraform
   ```bash
   cd DIMT2024-ID/terraform
   terraform destroy -auto-approve
   ```

# Resources

1. Flink SQL [docs](https://docs.confluent.io/cloud/current/flink/index.html)
1. Apache Flink 101 developer [course](https://developer.confluent.io/courses/apache-flink/intro/)
1. Building Apache Flink applications in Java developer [course](https://developer.confluent.io/courses/flink-java/overview/)
1. Confluent Cloud - Flink SQL shoe store workshop GitHub [repo](https://github.com/griga23/shoe-store)
1. Stream Processing Simplified blog [series](https://www.confluent.io/blog/apache-flink-for-stream-processing/)
1. Experience serverless stream processing with Confluent Cloud for Apache Flink [webinar](https://www.confluent.io/resources/online-talk/apache-flink-on-confluent-cloud/)
