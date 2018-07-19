> * 原文地址：[Python & Big Data: Airflow & Jupyter Notebook with Hadoop 3, Spark & Presto](http://tech.marksblogg.com/python-big-data-airflow-jupyter-notebook-hadoop-3-hive-presto.html)
> * 原文作者：[Mark Litwintschik](http://tech.marksblogg.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/python-big-data-airflow-jupyter-notebook-hadoop-3-hive-presto.md](https://github.com/xitu/gold-miner/blob/master/TODO1/python-big-data-airflow-jupyter-notebook-hadoop-3-hive-presto.md)
> * 译者：
> * 校对者：

# Python & Big Data: Airflow & Jupyter Notebook with Hadoop 3, Spark & Presto

Python has made itself a language du jour in the data science, machine learning and deep learning worlds over the past few years. Along with SQL you can get through most workloads with just these two programming and query languages. SQL is great in that it's both written as you'd give instructions in English and that it's declarative meaning the user only asks for what they want rather than how they want their query executed. This allows the underlying query engines to optimise queries without needing changes to SQL queries themselves. Python is great in that it brings a huge number of high quality libraries and is easy to use.

Job Orchestration is the act of taking routine tasks and automating them. In years past this was often done with CRON jobs. For the last few years more and more businesses have begun using systems like [Apache Airflow](https://airflow.apache.org/) and [Spotify's Luigi](https://luigi.readthedocs.io/en/stable/) to create more robust systems. These tools can monitor jobs, record their outcomes and re-run jobs in the event of failures. For anyone interested I've written up a blog post that includes Airflow's back story in my blog titled [Building a Data Pipeline with Airflow](airflow-postgres-redis-forex.html).

Notebooks as a tool for data exploration and visualisation have also become very popular in the data space in the past few years. Tools like [Jupyter Notebook](http://jupyter.org/) and [Apache Zeppelin](https://zeppelin.apache.org/) have aimed to fill this need. Notebooks not only show you the results of analysis, they show the code and queries that produced those results. This can help spot oversights and help analysts reproduce one another's work.

Airflow and Jupyter Notebook work well together as you can automatically feed in new data into your data lake with Airflow that data scientists can then analyse using Jupyter Notebook.

In this blog post I'll take a single-node Hadoop installation, get Jupyter Notebook running and show how to create an Airflow job that can take a weather data feed, store it on HDFS, convert it into ORC format and then export it into a Microsoft Excel-formatted spreadsheet.

The machine I'm using has an Intel Core i5-4670K CPU clocked at 3.40 GHz, 12 GB of RAM and 200 GB of SSD-based storage capacity. I'll be using a fresh installation of Ubuntu 16.04.2 LTS with a single-node Hadoop installation built off the instructions in my [Hadoop 3 Single-Node Install Guide](hadoop-3-single-node-install-guide.html) blog post.

## Installing Dependencies

The following will install the Ubuntu-based dependencies. The git package will be used to fetch the weather dataset from GitHub and the remaining three packages are Python itself, a Python package installer and Python environment isolation toolkit.

```
$ sudo apt install \
    git \
    python \
    python-pip \
    virtualenv
```

Airflow will be relying on RabbitMQ to help keep track of its jobs. The following installs Erlang, the language RabbitMQ is written in.

```
$ echo "deb http://binaries.erlang-solutions.com/debian xenial contrib" | \
    sudo tee /etc/apt/sources.list.d/erlang.list
$ wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | \
    sudo apt-key add -
$ sudo apt update
$ sudo apt install esl-erlang
```

The following will install RabbitMQ.

```
$ echo "deb https://dl.bintray.com/rabbitmq/debian xenial main" | \
    sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list
$ wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | \
    sudo apt-key add -
$ sudo apt update
$ sudo apt install rabbitmq-server
```

The following will install the Python-based dependencies and applications used in this blog post.

```
$ virtualenv .notebooks
$ source .notebooks/bin/activate
$ pip install \
    apache-airflow \
    celery \
    cryptography \
    jupyter \
    jupyterthemes \
    pyhive \
    requests \
    xlsxwriter
```

## Configuring Jupyter Notebook

I'll create a folder for Jupyter to store its configuration and then set a password for the server. If a password isn't set you'll be given a lengthy URL with a key to access the Jupyter Web UI. The key changes each time you launch Jupyter Notebook.

```
$ mkdir -p ~/.jupyter/
$ jupyter notebook password
```

Jupyter Notebook supports user interface themes. The following command will set the theme to the [Chesterish](https://github.com/dunovank/jupyter-themes/blob/master/screens/chesterish_code_headers.png) theme.

```
$ jt -t chesterish
```

The following will list the themes that are currently installed. The built-in themes have [screen shots](https://github.com/dunovank/jupyter-themes/tree/master/screens) located on GitHub.

```
$ jt -l
```

To return to the default theme run the following command.

```
$ jt -r
```

## Query Spark from a Jupyter Notebook

First make sure you have Hive's Metastore, Spark's Master & Slaves Services and Presto's Server up and running. The following are the commands that launch their services.

```
$ hive --service metastore &
$ sudo /opt/presto/bin/launcher start
$ sudo /opt/spark/sbin/start-master.sh
$ sudo /opt/spark/sbin/start-slaves.sh
```

The following will launch Jupyter Notebook so that you can interact with PySpark, a Python-based programming interface for Spark.

```
$ PYSPARK_DRIVER_PYTHON=ipython \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook
        --no-browser
        --ip=0.0.0.0
        --NotebookApp.iopub_data_rate_limit=100000000" \
    pyspark \
    --master spark://ubuntu:7077
```

Note the master URL above contains ubuntu as the hostname. This hostname is what the Spark Master Server has binded to. If you cannot connect to Spark check the Spark Master Server's logs for the hostname it has chosen to bind to as it won't accept connections addressing other hostnames. This can be confusing as often you'd expect hostnames like localhost would just work regardless.

With the Jupyter Notebook services launched the following will open the Web UI.

```
$ open http://localhost:8888/
```

You'll be prompted to enter the password you set for Jupyter Notebook. Once you've entered it in the top right you can create new notebooks from the drop down. The two notebook types of interest are Python and Terminal. Terminal gives you shell access using the UNIX account you launched Jupyter Notebook with. Below I'm working with a Python Notebook.

Once you've launched a Python notebook paste the following code into a cell and it will query data via Spark. Adjust the query to work with a dataset you've created on your installation.

```
cab_types = sqlContext.sql("""
 SELECT cab_type, COUNT(*)
 FROM trips_orc
 GROUP BY cab_type
""")

cab_types.take(2)
```

This is what the output of the above query looks like. There was only a single record with two fields returned.

```
[Row(cab_type=u'yellow', count(1)=20000000)]
```

## Query Presto from a Jupyter Notebook

In the same notebook used to query Spark you can also query Presto. Presto might outperform Spark in certain queries so it's handy that you can switch between the two in the same notebook. In the example below I'm using Dropbox's [PyHive](https://github.com/dropbox/PyHive) library to query Presto.

```
from pyhive import presto

cursor = presto.connect('0.0.0.0').cursor()
cursor.execute('SELECT * FROM trips_orc LIMIT 10')
cursor.fetchall()
```

The following is a truncated output from the above query.

```
[(451221840,
  u'CMT',
  u'2011-08-23 21:03:34.000',
  u'2011-08-23 21:21:49.000',
  u'N',
  1,
  -74.004655,
  40.742162,
  -73.973489,
  40.792922,
...
```

If you're interested in producing charts of data in Jupyter Notebook then have a look at the [Visualising Data with Jupyter Notebook in SQLite](sqlite3-tutorial-and-guide.html#visualising-data-with-jupyter-notebooks) blog post as it has several plotting examples using SQL that will work with both Spark and Presto.

## Airflow Up & Running

The following will create a ~/airflow folder, setup a SQLite 3 database used to store Airflow's state and configuration set via the Web UI, upgrade the configuration schema and create a folder for the Python-based jobs code Airflow will run.

```
$ cd ~
$ airflow initdb
$ airflow upgradedb
$ mkdir -p ~/airflow/dags
```

By default Presto's Web UI, Spark's Web UI and Airflow's Web UI all use TCP port 8080. If you launch Presto after Spark then Presto will fail to start. If you start Spark after Presto then Presto will launch on 8080 and the Spark Master Server will take 8081 and keep trying higher ports until it finds one that is free. Spark will then pick an even higher port number for the Spark Worker Web UI. This overlap normally isn't an issue as in a production setting these services would normally live on separate machines.

With TCP ports 8080 - 8082 taken in this installation I'm launching Airflow's Web UI on port 8083.

```
$ airflow webserver --port=8083 &
```

I often use one of the following command to see which networking ports are being used.

```
$ sudo lsof -OnP | grep LISTEN
$ netstat -tuplen
$ ss -lntu
```

Airflow's default configuration of the Celery broker and results backend both expect to use MySQL by default. The following will change this to use RabbitMQ instead.

```
$ vi ~/airflow/airflow.cfg
```

Locate and edit the following settings.

```
broker_url = amqp://airflow:airflow@localhost:5672/airflow

celery_result_backend = amqp://airflow:airflow@localhost:5672/airflow
```

The above uses airflow for both the username and the password to connect to RabbitMQ. Feel free to pick your own credentials.

The following will configure the above credentials so they can access the airflow vhost in RabbitMQ.

```
$ sudo rabbitmqctl add_vhost airflow
$ sudo rabbitmqctl add_user airflow airflow
$ sudo rabbitmqctl set_user_tags airflow administrator
$ sudo rabbitmqctl set_permissions -p airflow airflow ".*" ".*" ".*"
```

## Connecting Airflow to Presto

The following will open the Airflow Web UI.

```
$ open http://localhost:8083/
```

Once you have the Airflow Web UI open click on the "Admin" navigation menu at the top and select "Connections". You'll see a long list of default database connections. Click to edit the Presto connection. The following changes will be required for Airflow to connect to Presto.

*   Change the schema from hive to default.
*   Change the port from 3400 to 8080.

Save those changes and then click on the "Data Profiling" navigation menu at the top and select "Ad Hoc Query". Select "presto_default" from the drop down above the query box and you should be able to execute SQL code that will execute via Presto. The following is an example query I ran against a dataset I had imported in my installation.

```
SELECT count(*)
FROM trips_orc;
```

## Downloading the Weather Dataset

An [Airflow DAG](https://airflow.apache.org/concepts.html) can be thought of as a job that runs when you schedule it to do so. In the example below I'll take weather data provided by [FiveThirtyEight's](http://fivethirtyeight.com/) [data repository](https://github.com/fivethirtyeight/data) on GitHub, import it into HDFS, convert it from CSV to ORC and export it from Presto into Microsoft Excel format.

The following will clone FiveThirtyEight's data repo into a local folder called data.

```
$ git clone \
    https://github.com/fivethirtyeight/data.git \
    ~/data
```

I will then launch Hive and create two tables. One representing the CSV format of the dataset and a second, a Presto- and Spark-friendly ORC-format of the dataset.

```
$ hive
```

```
CREATE EXTERNAL TABLE weather_csv (
    date_                 DATE,
    actual_mean_temp      SMALLINT,
    actual_min_temp       SMALLINT,
    actual_max_temp       SMALLINT,
    average_min_temp      SMALLINT,
    average_max_temp      SMALLINT,
    record_min_temp       SMALLINT,
    record_max_temp       SMALLINT,
    record_min_temp_year  INT,
    record_max_temp_year  INT,
    actual_precipitation  DECIMAL(18,14),
    average_precipitation DECIMAL(18,14),
    record_precipitation  DECIMAL(18,14)
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  LOCATION '/weather_csv/';

CREATE EXTERNAL TABLE weather_orc (
    date_                 DATE,
    actual_mean_temp      SMALLINT,
    actual_min_temp       SMALLINT,
    actual_max_temp       SMALLINT,
    average_min_temp      SMALLINT,
    average_max_temp      SMALLINT,
    record_min_temp       SMALLINT,
    record_max_temp       SMALLINT,
    record_min_temp_year  INT,
    record_max_temp_year  INT,
    actual_precipitation  DOUBLE,
    average_precipitation DOUBLE,
    record_precipitation  DOUBLE
) STORED AS orc
  LOCATION '/weather_orc/';
```

## Creating an Airflow DAG

The Python code below is an Airflow job (also known as a [DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph)). Every 30 minutes it will perform the following actions.

*   Clear out any existing data in the /weather_csv/ folder on HDFS.
*   Copy CSV files from the ~/data folder into the /weather_csv/ folder on HDFS.
*   Convert the CSV data on HDFS into ORC format using Hive.
*   Export the ORC-formatted data using Presto into Microsoft Excel 2013 format.

There is one location where I refer to the CSV's location with the full path of /home/mark/data/us-weather-history/*.csv in the Python code below. Change the mark portion to the name of your UNIX account.

```
$ vi ~/airflow/dags/weather.py
```

```
from datetime import timedelta

import airflow
from   airflow.hooks.presto_hook         import PrestoHook
from   airflow.operators.bash_operator   import BashOperator
from   airflow.operators.python_operator import PythonOperator
import numpy  as np
import pandas as pd


default_args = {
    'owner':            'airflow',
    'depends_on_past':  False,
    'start_date':       airflow.utils.dates.days_ago(0),
    'email':            ['airflow@example.com'],
    'email_on_failure': True,
    'email_on_retry':   False,
    'retries':          3,
    'retry_delay':      timedelta(minutes=15),
}

dag = airflow.DAG('weather',
                  default_args=default_args,
                  description='Copy weather data to HDFS & dump to Excel',
                  schedule_interval=timedelta(minutes=30))

cmd = "hdfs dfs -rm /weather_csv/*.csv || true"
remove_csvs_task = BashOperator(task_id='remove_csvs',
                                bash_command=cmd,
                                dag=dag)

cmd = """hdfs dfs -copyFromLocal \
            /home/mark/data/us-weather-history/*.csv \
            /weather_csv/"""
csv_to_hdfs_task = BashOperator(task_id='csv_to_hdfs',
                                bash_command=cmd,
                                dag=dag)

cmd = """echo \"INSERT INTO weather_orc
                SELECT * FROM weather_csv;\" | \
            hive"""
csv_to_orc_task = BashOperator(task_id='csv_to_orc',
                               bash_command=cmd,
                               dag=dag)


def presto_to_excel(**context):
    column_names = [
        "date",
        "actual_mean_temp",
        "actual_min_temp",
        "actual_max_temp",
        "average_min_temp",
        "average_max_temp",
        "record_min_temp",
        "record_max_temp",
        "record_min_temp_year",
        "record_max_temp_year",
        "actual_precipitation",
        "average_precipitation",
        "record_precipitation"
    ]

    sql = """SELECT *
             FROM weather_orc
             LIMIT 20"""

    ph = PrestoHook(catalog='hive',
                    schema='default',
                    port=8080)
    data = ph.get_records(sql)

    df = pd.DataFrame(np.array(data).reshape(20, 13),
                      columns=column_names)

    writer = pd.ExcelWriter('weather.xlsx',
                            engine='xlsxwriter')
    df.to_excel(writer, sheet_name='Sheet1')
    writer.save()

    return True

presto_to_excel_task = PythonOperator(task_id='presto_to_excel',
                                      provide_context=True,
                                      python_callable=presto_to_excel,
                                      dag=dag)

remove_csvs_task >> csv_to_hdfs_task >> csv_to_orc_task >> presto_to_excel_task

if __name__ == "__main__":
    dag.cli()
```

With that code in place open Airflow's Web UI and switch the on/off toggle next to the "weather" DAG at the bottom of the homepage to "on".

The scheduler will create a list of jobs for workers to execute. The following will launch both Airflow's scheduler service and one worker which will complete any scheduled jobs.

```
$ airflow scheduler &
$ airflow worker &
```

Thank you for taking the time to read this post. I offer consulting, architecture and hands-on development services to clients in North America & Europe. If you'd like to discuss how my offerings can help your business please contact me via [LinkedIn](https://uk.linkedin.com/in/marklitwintschik/).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
