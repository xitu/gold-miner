> * 原文地址：[Airflow: a workflow management platform](https://medium.com/airbnb-engineering/airflow-a-workflow-management-platform-46318b977fd8)
> * 原文作者：[Maxime Beauchemin](https://medium.com/@maximebeauchemin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/airflow-a-workflow-management-platform.md](https://github.com/xitu/gold-miner/blob/master/TODO1/airflow-a-workflow-management-platform.md)
> * 译者：
> * 校对者：

# Airflow: a workflow management platform

By [Maxime Beauchemin](https://medium.com/@maximebeauchemin)

![](https://cdn-images-1.medium.com/max/800/0*277Imf2r7ouTXOVy.png)

**Airbnb** is a fast growing, data informed company. Our data teams and data volume are growing quickly, and accordingly, so does the complexity of the challenges we take on. Our growing workforce of data engineers, data scientists and analysts are using **Airflow**, a platform we built to allow us to move fast, keep our momentum as we author, monitor and retrofit **data pipelines**.

Today, we are proud to announce that we are **open sourcing** and **sharing Airflow**, our workflow management platform.

[https://github.com/airbnb/airflow](https://github.com/airbnb/airflow)

* * *

### DAGs are blooming

As people who work with data begin to automate their processes, they inevitably write batch jobs. These jobs need to run on a schedule, typically have a set of dependencies on other existing datasets, and have other jobs that depend on them. Throw a few data workers together for even a short amount of time and quickly you have a growing complex graph of computation batch jobs. Now if you consider a fast-paced, medium-sized data team for a few years on an evolving data infrastructure and you have a massively complex network of computation jobs on your hands. This complexity can become a significant burden for the data teams to manage, or even comprehend.

These networks of jobs are typically **DAGs** (**directed acyclic graphs**) and have the following properties:

*   **Scheduled:** each job should run at a certain scheduled interval
*   **Mission critical:** if some of the jobs aren’t running, we are in trouble
*   **Evolving:** as the company and the data team matures, so does the data processing
*   **Heterogenous:** the stack for modern analytics is changing quickly, and most companies run multiple systems that need to be glued together

### Every company has one (or many)

**Workflow management** has become such a common need that most companies have multiple ways of creating and scheduling jobs internally. There’s always the good old cron scheduler to get started, and many vendor packages ship with scheduling capabilities. The next step forward is to have scripts call other scripts, and that can work for a short period of time. Eventually simple frameworks emerge to solve problems like storing the status of jobs and dependencies.

Typically these solutions **grow reactively** as a response to the increasing need to schedule individual jobs, and usually because current incarnation of the system doesn’t allow for simple scaling. Also note that people who write data pipelines typically are not software engineers, and their mission and competencies are centered around processing and analyzing data, not building workflow management systems.

Considering that internally grown workflow management systems are often at least one generation behind the company’s need, the **friction** around authoring, scheduling and troubleshooting jobs creates massive inefficiencies and frustrations that divert data workers off of their productive path.

### Airflow

After reviewing the open source solutions, and leveraging Airbnb employees’ insight about systems they had used in the past, we came to the conclusion that there wasn’t anything in the market that met our current and future needs. We decided to build a modern system to solve this problem properly. As the project progressed in development, we realized that we had an amazing opportunity to give back to the open source community that we rely so heavily upon. Therefore, we have decided to open source the project under the Apache license.

Here are some of the processes fueled by Airflow at Airbnb:

*   **Data warehousing:** cleanse, organize, data quality check, and publish data into our growing data warehouse
*   **Growth analytics:** compute metrics around guest and host engagement as well as growth accounting
*   **Experimentation:** compute our A/B testing experimentation frameworks logic and aggregates
*   **Email targeting:** apply rules to target and engage our users through email campaigns
*   **Sessionization:** compute clickstream and time spent datasets
*   **Search:** compute search ranking related metrics
*   **Data infrastructure maintenance:** database scrapes, folder cleanup, applying data retention policies, …

### Architecture

Much like English is the language of business, Python has firmly established itself as the language of data. Airflow is written in pythonesque Python from the ground up. The code base is extensible, documented, consistent, linted and has broad unit test coverage.

Pipeline authoring is also done in Python, which means dynamic pipeline generation from configuration files or any other source of metadata comes naturally. “**Configuration as code**” is a principle we stand by for this purpose. While yaml or json job configuration would allow for any language to be used to generate Airflow pipelines, we felt that some fluidity gets lost in the translation. Being able to introspect code (ipython!, IDEs) subclass, meta-program and use import libraries to help write pipelines adds tremendous value. Note that it is still possible to author jobs in any language or markup, as long as you write Python that interprets these configurations.

While you can get up and running with Airflow in just a few commands, the complete architecture has the following components:

*   The **job definitions**, in source control.
*   A rich **CLI** (command line interface) to test, run, backfill, describe and clear parts of your DAGs.
*   A **web application**, to explore your DAGs definition, their dependencies, progress, metadata and logs. The web server is packaged with Airflow and is built on top of the Flask Python web framework.
*   A **metadata repository**, typically a MySQL or Postgres database that Airflow uses to keep track of task job statuses and other persistent information.
*   An array of **workers**, running the jobs task instances in a distributed fashion.
*   **Scheduler** processes, that fire up the task instances that are ready to run.

### Extensibility

While Airflow comes fully loaded with ways to interact with commonly used systems like Hive, Presto, MySQL, HDFS, Postgres and S3, and allow you to trigger arbitrary scripts, the base modules have been designed to be extended very easily.

**Hooks** are defined as external systems abstraction and share a homogenous interface. Hooks use a centralized vault that abstracts host/port/login/password information and exposes methods to interact with these system.

**Operators** leverage hooks to generate a certain type of task that become nodes in workflows when instantiated. All operators derive from BaseOperator and inherit a rich set of attributes and methods. There are 3 main types of operators:

*   Operators that performs an **action**, or tells another system to perform an action
*   **Transfer** operators move data from a system to another
*   **Sensors** are a certain type of operators that will keep running until a certain criteria is met

**Executors** implement an interface that allow Airflow components (CLI, scheduler, web server) to run jobs jobs remotely. Airflow currently ships with a SequentialExecutor (for testing purposes), a threaded LocalExecutor, and a CeleryExecutor that leverages [Celery](http://www.celeryproject.org/), an excellent asynchronous task queue based on distributed message passing. We are also planning on sharing a YarnExecutor in the near future.

### A Shiny UI

While Airflow exposes a rich [command line interface](http://pythonhosted.org/airflow/cli.html), the best way to monitor and interact with workflows is through the web user interface. You can easily visualize your pipelines dependencies, see how they progress, get easy access to logs, view the related code, trigger tasks, fix false positives/negatives, analyze where time is spent as well as getting a comprehensive view on at what time of the day different tasks usually finish. The UI is also a place where some administrative functions are exposed: managing connections, pools and pausing progress on specific DAGs.

![](https://cdn-images-1.medium.com/max/400/1*nbwR8O-CDH67fkHrXVDvYw.png)

![](https://cdn-images-1.medium.com/max/400/1*0Mask8UZw_aCsd_7JM2Rjw.png)

![](https://cdn-images-1.medium.com/max/400/1*JNOJotSnC3t0TIQC8gYcsg.png)

![](https://cdn-images-1.medium.com/max/600/1*qqOg_8bMS_MzDgWSbgdtOw.png)

![](https://cdn-images-1.medium.com/max/400/1*rNaZuJ2168jvUYiEkdu1ww.png)

![](https://cdn-images-1.medium.com/max/400/1*ojItdtSC6etsUWOZIK8trw.png)

To put a cherry on top of this, the UI serves a [Data Profiling](http://pythonhosted.org/airflow/profiling.html) section that allows users to run SQL queries against the registered connections, browse through the result sets, as well as offering a way to create and share simple charts. The charting application is a mashup of [Highcharts](http://www.highcharts.com/), the [Flask Admin](https://flask-admin.readthedocs.org/en/v1.0.9/)‘s CRUD interface and Airflow’s [hooks](http://pythonhosted.org/airflow/code.html#module-airflow.hooks) and [macros](http://pythonhosted.org/airflow/code.html#macros) libraries. URL parameters can be passed through to the SQL in your chart, and Airflow macros are available via [Jinja templating](http://jinja.pocoo.org/). With these features, queries, result sets and charts can be easily created and shared by Airflow users.

![](https://cdn-images-1.medium.com/max/400/1*8SD5x-62kLVzZ9SSfAXKCg.png)

![](https://cdn-images-1.medium.com/max/400/1*2L-uvEnYDvf5FG3eMuknuQ.png)

![](https://cdn-images-1.medium.com/max/400/1*EbUXRyeS65GZTXbCPWrF7w.png)

### A Catalyst

As a result of using Airflow, the productivity and enthusiasm of people working with data has been multiplied at Airbnb. Authoring pipeline has accelerated and the amount of time monitoring and troubleshooting is reduced significantly. More importantly, this platform allows people to execute at a higher level of abstraction, creating reusable building blocks as well as computation frameworks and services.

### Enough Said!

We’ve made it extremely easy to take a test drive of Airflow while powering through an enlightening tutorial. Rewarding results are a few shell commands away. Check out the [quick start](http://pythonhosted.org/airflow/start.html) and [tutorial](http://pythonhosted.org/airflow/tutorial.html) sections of the [Airflow documentation](http://pythonhosted.org/airflow/), you should be able to have your an Airflow web application loaded with interactive examples in just a few minutes!

[https://github.com/airbnb/airflow](https://github.com/airbnb/airflow)

![](https://cdn-images-1.medium.com/max/800/1*YsUOrWx3mRxZZljtc9xZyw.png)

#### Check out all of our open source projects over at [airbnb.io](http://airbnb.io) and follow us on Twitter: [@AirbnbEng](https://twitter.com/AirbnbEng) + [@AirbnbData](https://twitter.com/AirbnbData)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
