> * 原文地址：[Python & Big Data: Airflow & Jupyter Notebook with Hadoop 3, Spark & Presto](http://tech.marksblogg.com/python-big-data-airflow-jupyter-notebook-hadoop-3-hive-presto.html)
> * 原文作者：[Mark Litwintschik](http://tech.marksblogg.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/python-big-data-airflow-jupyter-notebook-hadoop-3-hive-presto.md](https://github.com/xitu/gold-miner/blob/master/TODO1/python-big-data-airflow-jupyter-notebook-hadoop-3-hive-presto.md)
> * 译者：[cf020031308](https://github.com/cf020031308)
> * 校对者：[yqian1991](https://github.com/yqian1991)

# Python 与大数据：Airflow、 Jupyter Notebook 与 Hadoop 3、Spark、Presto

最近几年里，Python 已成为数据科学、机器学习和深度学习领域的一门流行的编程语言。只需再配上查询语言 SQL 即可完成大多数工作。SQL 很棒，用英语即可发出指令，且只需指示想要什么，而无需关心具体如何查询。这使得底层的查询引擎可以不改变 SQL 查询就能对其进行优化。Python 也很棒，它有大量高质量的库，本身也易于使用。

作业编排是执行日常任务并使其自动化的行为。在过去，这通常是通过 CRON 作业完成的。而在最近几年，越来越多的企业开始使用 [Apache Airflow](https://airflow.apache.org/) 和 [Spotify 的 Luigi](https://luigi.readthedocs.io/en/stable/) 等创建更强大的系统。这些工具可以监控作业、记录结果并在发生故障时重新运行作业。如果您有兴趣，我曾写过一篇博客文章，其中包括 Airflow 的背景故事，题为[《使用 Airflow 构建数据管道》](http://tech.marksblogg.com/airflow-postgres-redis-forex.html)。

作为数据探索和可视化工具的 Notebooks 在过去几年中也在数据领域变得非常流行。像 [Jupyter Notebook](http://jupyter.org/) 和 [Apache Zeppelin](https://zeppelin.apache.org/) 这样的工具旨在满足这一需求。Notebooks 不仅向您显示分析结果，还显示产生这些结果的代码和查询。这有利于发现疏忽并可帮助分析师重现彼此的工作。

Airflow 和 Jupyter Notebook 可以很好地协同工作，您可以使用 Airflow 自动将新数据输入数据库，然后数据科学家可以使用 Jupyter Notebook 进行分析。

在这篇博文中，我将安装一个单节点的 Hadoop，让 Jupyter Notebook 运行并展示如何创建一个 Airflow 作业，它可以获取天气数据源，将其存储在 HDFS 上，再转换为 ORC 格式，最后导出到 Microsoft Excel 格式的电子表格中。

我正在使用的机器有一个主频为 3.40 GHz 的 Intel Core i5-4670K CPU、12 GB 的 RAM 和 200 GB 的 SSD。我将使用全新安装的 Ubuntu 16.04.2 LTS，并根据我的博客文章[《Hadoop 3：单节点安装指南》](http://tech.marksblogg.com/hadoop-3-single-node-install-guide.html) 中的说明构建安装单节点 Hadoop。

## 安装依赖项

接下来将安装 Ubuntu 上的依赖项。 git 包将用于从 GitHub 获取天气数据集，其余三个包是 Python 本身、Python 包安装程序和 Python 环境隔离工具包。

```
$ sudo apt install \
    git \
    python \
    python-pip \
    virtualenv
```

Airflow 将依靠 RabbitMQ 的帮助来跟踪其作业。下面安装 Erlang，这是编写 RabbitMQ 的语言。

```
$ echo "deb http://binaries.erlang-solutions.com/debian xenial contrib" | \
    sudo tee /etc/apt/sources.list.d/erlang.list
$ wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | \
    sudo apt-key add -
$ sudo apt update
$ sudo apt install esl-erlang
```

下面安装 RabbitMQ。

```
$ echo "deb https://dl.bintray.com/rabbitmq/debian xenial main" | \
    sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list
$ wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | \
    sudo apt-key add -
$ sudo apt update
$ sudo apt install rabbitmq-server
```

下面将安装此博文中使用的 Python 上的依赖项和应用程序。

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

## 配置 Jupyter Notebook

我将为 Jupyter 创建一个文件夹来存储其配置，然后为服务器设置密码。如果不设置密码，您就会获得一个冗长的 URL，其中包含用于访问 Jupyter 网页界面的密钥。每次启动 Jupyter Notebook 时，密钥都会更新。

```
$ mkdir -p ~/.jupyter/
$ jupyter notebook password
```

Jupyter Notebook 支持用户界面主题。以下命令将主题设置为 [Chesterish](https://github.com/dunovank/jupyter-themes/blob/master/screens/chesterish_code_headers.png)。

```
$ jt -t chesterish
```

下面命令列出当前安装的主题。内置的主题在 GitHub上都有[屏幕截图](https://github.com/dunovank/jupyter-themes/tree/master/screens)。

```
$ jt -l
```

要返回默认主题，请运行以下命令。

```
$ jt -r
```

## 通过 Jupyter Notebook 查询 Spark

首先确保您运行着 Hive 的 Metastore、Spark 的 Master ＆ Slaves 服务，以及 Presto 的服务端。以下是启动这些服务的命令。

```
$ hive --service metastore &
$ sudo /opt/presto/bin/launcher start
$ sudo /opt/spark/sbin/start-master.sh
$ sudo /opt/spark/sbin/start-slaves.sh
```

下面将启动 Jupyter Notebook，以便您可以与 PySpark 进行交互，PySpark 是 Spark 的基于 Python 的编程接口。

```
$ PYSPARK_DRIVER_PYTHON=ipython \
    PYSPARK_DRIVER_PYTHON_OPTS="notebook
        --no-browser
        --ip=0.0.0.0
        --NotebookApp.iopub_data_rate_limit=100000000" \
    pyspark \
    --master spark://ubuntu:7077
```

请注意，上面的 master 的 URL 以 ubuntu 为主机名。此主机名是 Spark Master 服务端绑定的主机名。如果无法连接到 Spark，请检查 Spark Master 服务端的日志，查找它已选择绑定的主机名，因为它不接受寻址其他主机名的连接。这可能会令人困惑，因为您通常会期望像 localhost 这样的主机名无论如何都能正常工作。

运行 Jupyter Notebook 服务后，用下面命令打开网页界面。

```
$ open http://localhost:8888/
```

系统将提示您输入为 Jupyter Notebook 设置的密码。在右上角输入后，您可以从下拉列表中创建新的笔记本。我们感兴趣的两种笔记本类型是 Python 和终端。终端笔记本使用您启动 Jupyter Notebook 的 UNIX 帐户为您提供 shell 访问权限。而我将使用的是 Python 笔记本。

启动 Python 笔记本后，将以下代码粘贴到单元格中，它将通过 Spark 查询数据。调整查询以使用您在安装中创建的数据集。

```
cab_types = sqlContext.sql("""
 SELECT cab_type, COUNT(*)
 FROM trips_orc
 GROUP BY cab_type
""")

cab_types.take(2)
```

这就是上面查询的输出结果。只返回了一条记录，包括两个字段。

```
[Row(cab_type=u'yellow', count(1)=20000000)]
```

## 通过 Jupyter Notebook 查询 Presto

在前面用来查询 Spark 的笔记本中，也可以查询 Presto。某些 Presto 查询的性能可能超过 Spark，趁手的是这两者可以在同一个笔记本中进行切换。在下面的示例中，我使用 Dropbox 的 [PyHive](https://github.com/dropbox/PyHive)  库来查询 Presto。

```
from pyhive import presto

cursor = presto.connect('0.0.0.0').cursor()
cursor.execute('SELECT * FROM trips_orc LIMIT 10')
cursor.fetchall()
```

这是上述查询的部分输出。

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

如果您想在 Jupyter Notebook 中生成数据图表，可以看看[《在 Jupyter Notebook 中使用 SQLite 可视化数据》](http://tech.marksblogg.com/sqlite3-tutorial-and-guide.html#visualising-data-with-jupyter-notebooks)这篇博文，因为它有几个使用 SQL 的绘图示例，可以与 Spark 和 Presto 一起使用。

## 启动 Airflow

下面将创建一个 ~/airflow 文件夹，设置一个用于存储在网页界面上设置的 Airflow 的状态和配置集的 SQLite 3 数据库，升级配置模式并为 Airflow 将要运行的 Python 作业代码创建一个文件夹。

```
$ cd ~
$ airflow initdb
$ airflow upgradedb
$ mkdir -p ~/airflow/dags
```

默认情况下，Presto、Spark 和 Airflow 的网页界面都使用 TCP 8080 端口。如果您先启动了 Spark，Presto 就将无法启动。但如果您是在 Presto 之后启动 Spark，那么 Presto 将在 8080 上启动，而 Spark Master 服务端则会使用 8081，如果仍被占用，会继续尝试更高端口，直到它找到一个空闲的端口。之后， Spark 将为 Spark Worker 的网页界面选择更高的端口号。这种重叠通常不是问题，因为在生产设置中这些服务通常存在于不同的机器上。

因为此安装中使用了 8080 - 8082 的 TCP 端口，我将在端口 8083 上启动 Airflow 的网页界面。

```
$ airflow webserver --port=8083 &
```

我经常使用以下命令之一来查看正在使用的网络端口。

```
$ sudo lsof -OnP | grep LISTEN
$ netstat -tuplen
$ ss -lntu
```

Airflow 的 Celery 代理和作业结果的存储都默认使用 MySQL。这里改为使用 RabbitMQ。

```
$ vi ~/airflow/airflow.cfg
```

找到并编辑以下设置。

```
broker_url = amqp://airflow:airflow@localhost:5672/airflow

celery_result_backend = amqp://airflow:airflow@localhost:5672/airflow
```

上面使用了 airflow 作为用户名和密码连接到 RabbitMQ。账号密码可以随意自定。

下面将为 RabbitMQ 配置上述账号密码，以便它能访问 Airflow 虚拟主机。

```
$ sudo rabbitmqctl add_vhost airflow
$ sudo rabbitmqctl add_user airflow airflow
$ sudo rabbitmqctl set_user_tags airflow administrator
$ sudo rabbitmqctl set_permissions -p airflow airflow ".*" ".*" ".*"
```

## 将 Airflow 连接到 Presto

下面将打开 Airflow 网页界面。

```
$ open http://localhost:8083/
```

打开 Airflow 网页界面后，单击顶部的 “Admin” 导航菜单，然后选择 “Connections”。您将看到一长串默认数据库连接。单击以编辑 Presto 连接。 Airflow 连接到 Presto 需要进行以下更改。

*   将 schema 从 hive 改为 default。
*   将端口从 3400 改为 8080。

保存这些更改，然后单击顶部的 “Data Profiling” 导航菜单，选择 “Ad Hoc Query”。从查询框上方的下拉列表中选择 “presto_default”，您就应该可以通过 Presto 执行 SQL 代码了。下面是针对我在安装中导入的数据集运行的示例查询。

```
SELECT count(*)
FROM trips_orc;
```

## 下载天气数据集

可以将 [Airflow DAG](https://airflow.apache.org/concepts.html) 视为定时执行的作业。在下面的示例中，我将在 GitHub 上获取 [FiveThirtyEight](http://fivethirtyeight.com/) [数据仓库](https://github.com/fivethirtyeight/data)提供的天气数据，将其导入 HDFS，将其从 CSV 转换为 ORC 并将其从 Presto 导出为 Microsoft Excel 格式。

以下内容将 FiveThirtyEight 的数据存储克隆到名为 data 的本地文件夹中。

```
$ git clone \
    https://github.com/fivethirtyeight/data.git \
    ~/data
```

然后我将启动 Hive 并创建两个表。一个存数据集的 CSV 格式，另一个存数据集的 Presto 和 Spark 友好的 ORC 格式。

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

## 创建 Airflow DAG

下面的 Python 代码是 Airflow 作业（也称为[DAG](https://en.wikipedia.org/wiki/Directed_acyclic_graph)）。每隔 30 分钟，它将执行以下操作。

*   清除 HDFS上 /weather_csv/ 文件夹中的任何现有数据。
*   将 ~/data 文件夹中的 CSV 文件复制到 HDFS 上的 /weather_csv/ 文件夹中。
*   使用 Hive 将 HDFS 上的 CSV 数据转换为 ORC 格式。
*   使用 Presto 将 ORC 格式的数据导出为 Microsoft Excel 2013 格式。

在下面的 Python 代码中有一个指向 CSV 的位置，完整路径为 /home/mark/data/us-weather-history/*.csv，请将其中的 “mark” 更换为您自己的 UNIX 用户名。

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
                  description='将天气数据复制到 HDFS 并导出为 Excel',
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

使用该代码打开 Airflow 的网页界面并将主页底部的 “weather” DAG 旁边的开关切换为 “on”。

调度程序将创建一个作业列表交给 workers 去执行。以下内容将启动 Airflow 的调度程序服务和一个将完成所有预定作业的 worker。

```
$ airflow scheduler &
$ airflow worker &
```

感谢您抽出宝贵时间阅读这篇文章。我为北美和欧洲的客户提供咨询、架构和实际开发服务。如果您有意探讨我的产品将如何帮助您的业务，请通过 [LinkedIn](https://uk.linkedin.com/in/marklitwintschik/) 与我联系。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
