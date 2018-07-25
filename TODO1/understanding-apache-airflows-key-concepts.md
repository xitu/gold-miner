> * 原文地址：[Understanding Apache Airflow’s key concepts](https://medium.com/@dustinstansbury/understanding-apache-airflows-key-concepts-a96efed52b1a)
> * 原文作者：[Dustin Stansbury](https://medium.com/@dustinstansbury?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-apache-airflows-key-concepts.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-apache-airflows-key-concepts.md)
> * 译者：
> * 校对者：

# Understanding Apache Airflow’s key concepts

## Part Three of a Four-part Series

In [Part I](https://medium.com/@dustinstansbury/going-with-the-flow-part-i-an-introduction-to-workflow-management-systems-19987afcdb5e) and [Part II](https://medium.com/@dustinstansbury/going-with-the-flow-part-ii-a-workflow-management-system-wish-list-3f97d40e9571) of [Quizlet’s](https://quizlet.com) [Hunt for the Best Workflow Management System Around](https://medium.com/@dustinstansbury/going-with-the-air-flow-quizlets-hunt-for-the-best-workflow-management-system-around-1ca546f8cc68), we motivated the need for workflow management systems (WMS) in modern business practices, and provided a wish list of features and functions that led us to choose [Apache Airflow](https://airflow.incubator.apache.org/) as our WMS of choice. This post aims to give the curious reader a detailed overview of Airflow’s components and operation. We’ll cover Airflow’s key concepts by implementing the example workflow introduced in [Part I](https://medium.com/@dustinstansbury/going-with-the-flow-part-i-an-introduction-to-workflow-management-systems-19987afcdb5e) of the series (see **Figure 3.1**).

![](https://cdn-images-1.medium.com/max/800/1*ytMWtgd5h-1EiGiCe_D3ew.png)

**Figure 3.1: An example data processing workflow.**

Airflow is a WMS that defines tasks and and their dependencies as code, executes those tasks on a regular schedule, and distributes task execution across worker processes. Airflow offers an excellent UI that displays the states of currently active and past tasks, shows diagnostic information about task execution, and allows the user to manually manage the execution and state of tasks.

#### Workflows are “DAGs”

Workflows in Airflow are collections of tasks that have directional dependencies. Specifically, Airflow uses directed acyclic graphs — or DAG for short — to represent a workflow. Each node in the graph is a task, and edges define dependencies amongst tasks (The graph is enforced to be acyclic so that there are no circular dependencies that can cause infinite execution loops).

The top of **Figure 3.2** demonstrates how our example workflow is represented in Airflow as a DAG. Notice the similarity in the structure of the execution plan for our example workflow tasks in [**Figure 1.1**](https://medium.com/@dustinstansbury/going-with-the-flow-part-i-an-introduction-to-workflow-management-systems-19987afcdb5e) and the structure of the DAG in **Figure 3.2**.

![](https://cdn-images-1.medium.com/max/800/1*N2CWqwBZiulBUwiPprKg4g.png)

**Figure 3.2 Screenshots from the Airflow UI, Representing the example workflow DAG. Top Subpanel**: The Graph View of the `DagRun` for Jan. 25th. Dark green nodes indicate `TaskInstance`s with “success” states. The light green node depicts a `TaskInstance` in the “running” state. **Bottom Subpanel**: The Tree View of the `example_workflow` DAG. The main components of Airflow are highlighted in screen shot, including Sensors, Operators, Tasks, `DagRuns`, and `TaskInstances`. `DagRuns` are represented as columns in the graph view — the `DagRun` for Jan. 25th is outlined in cyan. Each square in the graph view represents a `TaskInstance` — the `TaskInstance` for the (“running”) `perform_currency_conversion` task on Jan. 25th is outlined in blue.

At a high level, a DAG can be thought of as a container that holds tasks and their dependencies, and sets the context for when and how those tasks should be executed. Each DAG has a set of properties, most important of which are its `dag_id`, a unique identifier amongst all DAGs, its `start_date`, the point in time at which the DAG’s tasks are to begin executing, and the `schedule_interval`, or how often the tasks are to be executed. In addition to the `dag_id`, `start_date`, and `schedule_interval`, each DAG can be initialized with a set of `default_arguments`. These default arguments are inherited by all tasks in the DAG.

In the code block below, we define a DAG that implements our gaming company example workflow in Airflow.

```
# each Workflow/DAG must have a unique text identifier
WORKFLOW_DAG_ID = 'example_workflow_dag'

# start/end times are datetime objects
# here we start execution on Jan 1st, 2017
WORKFLOW_START_DATE = datetime(2017, 1, 1)

# schedule/retry intervals are timedelta objects
# here we execute the DAGs tasks every day
WORKFLOW_SCHEDULE_INTERVAL = timedelta(1)

# default arguments are applied by default to all tasks 
# in the DAG
WORKFLOW_DEFAULT_ARGS = {
    'owner': 'example',
    'depends_on_past': False,
    'start_date': WORKFLOW_START_DATE,
    'email': ['example@example_company.com'],
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 5,
    'retry_delay': timedelta(minutes=5)
}

# initialize the DAG
dag = DAG(
    dag_id=WORKFLOW_DAG_ID,
    start_date=WORKFLOW_START_DATE,
    schedule_interval=WORKFLOW_SCHEDULE_INTERVAL,
    default_args=WORKFLOW_DEFAULT_ARGS,
)
```

#### `Operators`, `Sensors`, and Tasks

Although the DAG is used to organize tasks and set their execution context, DAGs do not perform any actual computation. Instead, tasks are the element of Airflow that actually “do the work” we want performed. Tasks can have two flavors: they can either execute some explicit operation, in which case they are an **Operator**, or they can pause the execution of dependent tasks until some criterion has been met, in which case they are a **Sensor**. In principle, Operators can perform any function that can be executed in Python. Similarly, Sensors can check the state of any process or data structure.

The code block below shows how we would define some (hypothetical) Operator and Sensor classes to implement our example workflow.

```
##################################################
# Examples of Custom Sensors / Operators (NoOps) #
##################################################

class ConversionRatesSensor(BaseSensorOperator):
    """
    An example of a custom Sensor. Custom Sensors generally overload
    the `poke` method inherited from `BaseSensorOperator`
    """
    def __init__(self, *args, **kwargs):
        super(ConversionRatesSensor, self).__init__(*args, **kwargs)

    def poke(self, context):
        print 'poking {}'.__str__()
        
        # poke functions should return a boolean
        return check_conversion_rates_api_for_valid_data(context)

class ExtractAppStoreRevenueOperator(BaseOperator):
    """
    An example of a custom Operator that takes non-default 
    BaseOperator arguments. 
    
    Extracts data for a particular app store identified by 
    `app_store_name`.
    """
    def __init__(self, app_store_name, *args, **kwargs):
        self.app_store_name = app_store_name
        super(ExtractAppStoreRevenueOperator, self).__init__(*args, **kwargs)

    def execute(self, context):
        print 'executing {}'.__str__()
        
        # pull data from specific app store
        json_revenue_data = extract_app_store_data(self.app_store_name, context)
        
        # upload app store json data to filestore, can use context variable for 
        # date-specific storage metadata
        upload_appstore_json_data(json_revenue_data, self.app_store_name, context)

class TransformAppStoreJSONDataOperator(BaseOperator):
    """
    An example of a custom Operator that takes non-default 
    BaseOperator arguments.
    
    Extracts, transforms, and loads data for an array of app stores 
    identified by `app_store_names`.
    """
    def __init__(self, app_store_names, *args, **kwargs):
        self.app_store_names = app_store_names
        super(TransformJSONDataOperator, self).__init__(*args, **kwargs)

    def execute(self, context):
        print 'executing {}'.__str__()
        
        # load all app store data from filestores. context variable can be used to retrieve
        # particular date-specific data artifacts
        all_app_stores_extracted_data = []
        for app_store in self.app_store_names:
            all_app_stores_extracted_data.append(extract_app_store_data(app_store, context))
        
        # combine all app store data, transform to proper format, and upload to filestore 
        all_app_stores_json_data = combine_json_data(all_app_stores_extracted_data)
        app_stores_transformed_data = transform_json_data(all_app_stores_json_data)
        upload_data(app_stores_transformed_data, context)
```

The code defines a subclass of `BaseSensorOperator`, the `ConversionRatesSensor`. This class implements a `poke` method, which is required for all `BaseSensorOperator` objects. The `poke` method must return `True` if the downstream tasks are to continue and `False` otherwise. In our example, this sensor would be used to determine when exchange rates from the external API have become available.

The two classes, `ExtractAppStoreRevenueOperator` and `TransformAppStoreJSONDataOperator` are inherited from Airflow’s `BaseOperator` class and implement an `execute` method. In our example, these two classes’ `execute` methods pull data from the app store APIs, and transform them into the company’s preferred storage format. Notice that the `ExtractAppStoreRevenueOperator` also takes a custom parameter, `app_store_name`,which tells the class the app store from which to request data.

Note that generally Operators and Sensors are defined in separate files and imported into the same namespace we define the DAG. However, we could have added these class definitions to the same DAG-definition file as well.

Formally, Airflow defines a task as an instantiations of either the Sensor or Operator classes. Instantiating a task requires providing a unique `task_id` and DAG container in which to add the task (Note: in versions ≥ 1.8, there is no longer a DAG object requirement). The code block below shows how we would instantiate all the tasks needed to perform our example workflow. (Note: We assume that all Operators that are being referenced in our examples have been defined in or imported into our namespace).

```
########################
# Instantiating Tasks  #
########################

# instantiate the task to extract ad network revenue
extract_ad_revenue = ExtractAdRevenueOperator(
    task_id='extract_ad_revenue',
    dag=dag)

# dynamically instantiate tasks to extract app store data
APP_STORES = ['app_store_a', 'app_store_b', 'app_store_c']
app_store_tasks = []
for app_store in APP_STORES:
    task = ExtractAppStoreRevenueOperator(
        task_id='extract_{}_revenue'.format(app_store),
        dag=dag,
        app_store_name=app_store,
        )
    app_store_tasks.append(task)

# instantiate task to wait for conversion rates data avaibility
wait_for_conversion_rates = ConversionRatesSensor(
    task_id='wait_for_conversion_rates',
    dag=dag)

# instantiate task to extract conversion rates from API
extract_conversion_rates = ExtractConversionRatesOperator(
    task_id='get_conversion_rates',
    dag=dag)

# instantiate task to transform Spreadsheet data
transform_spreadsheet_data = TransformAdsSpreadsheetDataOperator(
    task_id='transform_spreadsheet_data',
    dag=dag) 

# instantiate task transform JSON data from all app stores
transform_json_data = TransformAppStoreJSONDataOperator(
    task_id='transform_json_data',
    dag=dag,
    app_store_names=APP_STORES)

# instantiate task to apply currency exchange rates
perform_currency_conversions = CurrencyConversionsOperator(
    task_id='perform_currency_conversions',
    dag=dag)

# instantiate task to combine all data sources
combine_revenue_data = CombineDataRevenueDataOperator(
    task_id='combine_revenue_data',
    dag=dag)  

# instantiate task to check that historical data exists
check_historical_data = CheckHistoricalDataOperator(
    task_id='check_historical_data',
    dag=dag)

# instantiate task to make predictions from historical data
predict_revenue = RevenuePredictionOperator(
    task_id='predict_revenue',
    dag=dag)  
```

This task instantiation code is executed in the same file/namespace as the DAG definition. We can see that the code for adding tasks is concise and allows for in-line documentation via comments. Lines 10–19 demonstrate one of the strengths of defining workflows in code. We are able to dynamically define three separate tasks for extracting data from each of the app stores using a `for` loop. Though this approach may not buy us much in this small example, the benefits are huge as the number of app stores increases.

#### Defining Task Dependencies

A key strength of Airflow is the concise and intuitive conventions for defining dependencies among tasks. The code below shows how we would define the task dependency graph for our example workflow:

```
###############################
# Defining Tasks Dependencies #
###############################

# dependencies are set using the `.set_upstream` and/or 
# `.set_downstream` methods
# (in version >=1.8.1, can also use the
# `extract_ad_revenue << transform_spreadsheet_data` syntax)

transform_spreadsheet_data.set_upstream(extract_ad_revenue)

# dynamically define app store dependencies
for task in app_store_tasks:
    transform_json_data.set_upstream(task)

extract_conversion_rates.set_upstream(wait_for_conversion_rates)

perform_currency_conversions.set_upstream(transform_json_data)
perform_currency_conversions.set_upstream(extract_conversion_rates)

combine_revenue_data.set_upstream(transform_spreadsheet_data)
combine_revenue_data.set_upstream(perform_currency_conversions)

check_historical_data.set_upstream(combine_revenue_data)

predict_revenue.set_upstream(check_historical_data) 
```

Again, this code is run in the same file/namespace as the DAG definition. Task dependencies are set using the `set_upstream` and `set_downstream` operators (Though, in version ≥ 1.8, it’s also possible to use the bitshift operators `<<` and `>>` to perform the same operations more concisely). A task can have multiple dependencies (e.g. `combine_revenue_data`), or none at all (e.g. all `extract_*` tasks).

The **Top Subpanel of Figure 3.2** shows the Airflow DAG created by the above code, as rendered by Airflow’s UI (we’ll soon get to the UI in more detail). The DAG has a dependency structure that is very similar the execution plan we came up with for our example workflow shown in **Figure 1.1**. When the DAG is being executed, Airflow will also use this dependency structure to automagically figure out which tasks can be run simultaneously at any point in time (e.g. all the `extract_*` tasks).

#### DagRuns and TaskInstances

Once we’ve defined a DAG — i.e. we’ve instantiated tasks and defined their dependencies — we can then execute the tasks based on the parameters of the DAG. A key concept in Airflow is that of an `execution_time`. When the Airflow scheduler is running, it will define a regularly-spaced schedule of dates for which to execute a DAG’s associated tasks. The execution times begin at the DAG’s `start_date` and repeat every `schedule_interval`. For our example the scheduled execution times would be `(‘2017–01–01 00:00:00’, ‘2017–01–02 00:00:00’, ...)`. For each `execution_time`, a `DagRun` is created and operates under the context of that execution time. Thus a `DagRun` is simply a DAG with some execution time (see the **Bottom Subpanel of Figure 3.2**).

All the tasks associated with a `DagRun` are referred to as `TaskInstance`s. In other words a `TaskInstance` is a task that has been instantiated and has an `execution_date` context (see **Bottom Subpanel of Figure 3.2**). `DagRun`s and `TaskInstance`s are central concepts in Airflow. Each `DagRun` and `TaskInstance` is associated with an entry in Airflow’s metadata database that logs their state (e.g. “queued”, “running”, “failed”, “skipped”, “up for retry”). Reading and updating these states is key for Airflow’s scheduling and execution processes.

#### Airflow’s Architecture

At its core, Airflow is simply a queuing system built on top of a metadata database. The database stores the state of queued tasks and a scheduler uses these states to prioritize how other tasks are added to the queue. This functionality is orchestrated by four primary components (refer to the **Left Subpanel of Figure 3.2**):

1.  **Metadata Database**: this database stores information regarding the state of tasks. Database updates are performed using an abstraction layer implemented in SQLAlchemy. This abstraction layer cleanly separates the function of the remaining components of Airflow from the database.  
2. **Scheduler**: The Scheduler is a process that uses DAG definitions in conjunction with the state of tasks in the metadata database to decide which tasks need to be executed, as well as their execution priority. The Scheduler is generally run as a service.  
3. **Executor**: The Executor is a message queuing process that is tightly bound to the Scheduler and determines the worker processes that actually execute each scheduled task. There are different types of Executors, each of which uses a specific class of worker processes to execute tasks. For example, the `LocalExecutor` executes tasks with parallel processes that run on the same machine as the Scheduler process. Other Executors, like the `CeleryExecutor` execute tasks using worker processes that exist on a separate cluster of worker machines.  
4. **Workers**: These are the processes that actually execute the logic of tasks, and are determined by the Executor being used.

![](https://cdn-images-1.medium.com/max/800/1*czjWSmrjiRY1goA0emv7IA.png)

**Figure 3.2: Airflow’s General Architecture.** Airflow’s operation is built atop a Metadata Database which stores the state of tasks and workflows (i.e. DAGs). The Scheduler and Executor send tasks to a queue for Worker processes to perform. The Webserver runs (often-times running on the same machine as the Scheduler) and communicates with the database to render task state and Task Execution Logs in the Web UI. Each colored box indicates that each component can exist in isolation from the other components, depending on the type of deployment configuration.

#### Scheduler Operation

At first, the operation of Airflow’s scheduler can seem more like black magic than a logical computer program. That said, understanding the workings of the scheduler can save you a ton of time if you ever find yourself debugging its execution. To save the reader from having to dig through Airflow’s source code (though we DO highly recommend it!), we outline the basic operation of the scheduler in pseudo-code:

```
Step 0. Load available DAG definitions from disk (fill DagBag)

While the scheduler is running:
	Step 1. The scheduler uses the DAG definitions to 
	        identify and/or initialize any DagRuns in the
	        metadata db.
	
	Step 2. The scheduler checks the states of the 
	        TaskInstances associated with active DagRuns, 
		resolves any dependencies amongst TaskInstances, 
		identifies TaskInstances that need to be executed, 
		and adds them to a worker queue, updating the status 
		of newly-queued TaskInstances to "queued" in the
		datbase.
	
	Step 3. Each available worker pulls a TaskInstance from 
		the queue and starts executing it, updating the 
	        database record for the TaskInstance from "queued" 
	        to "running".
	
	Step 4. Once a TaskInstance is finished running, the 
	        associated worker reports back to the queue 
	        and updates the status for the TaskInstance 
	        in the database (e.g. "finished", "failed", 
	        etc.)
	
	Step 5. The scheduler updates the states of all active 
	        DagRuns ("running", "failed", "finished") according 
	        to the states of all completed associated 
	        TaskInstances.
	
	Step 6. Repeat Steps 1-5
```

#### Web UI

In addition to the primary scheduling and execution components, Airflow also includes components that support a full-featured Web UI (refer to **Figure 3.2** for some UI examples), including:

1. **Webserver**: This process runs a simple Flask application which reads the state of all tasks from the metadata database and renders these states for the Web UI.  
2. **Web UI**: This component allows a client-side user to view and edit the state of tasks in the metadata database. Because of the coupling between the Scheduler and the database, the Web UI allows users to manipulate the behavior of the scheduler.  
3. **Execution Logs**: These logs are written by the worker processes and stored either on disk or a remote file store (e.g. [GCS](https://cloud.google.com/storage) or [S3](https://aws.amazon.com/s3)). The Webserver accesses the logs and makes them available to the Web UI.

Though these additional components are not necessary to the basic operation of Airflow, they offer functionally that really sets Airflow apart from other current workflow managers. Specifically the UI and integrated execution logs allows users to inspect and diagnose task execution, as well as view and manipulate task state.

#### Command Line Interface

In addition to the Scheduler and Web UI, Airflow offers robust functionality through a command line interface (CLI). In particular, we found the following commands to be helpful when developing Airflow:

*   `airflow test DAG_ID TASK_ID EXECUTION_DATE`. Allows the user to run a task in isolation, without affecting the metadata database, or being concerned about task dependencies. This command is great for testing basic behavior of custom Operator classes in isolation.
*   `airflow backfill DAG_ID TASK_ID -s START_DATE -e END_DATE`. Performs backfills of historical data between `START_DATE` and `END_DATE` without the need to run the scheduler. This is great when you need to change some business logic of a currently-existing workflow and need to update historical data. (Note that backfills **do not** create `DagRun` entries in the database, as they are not run by the `[SchedulerJob](https://github.com/apache/incubator-airflow/blob/master/airflow/jobs.py#L471)` class).
*   `airflow clear DAG_ID`. Removes `TaskInstance` records in the metadata database for the `DAG_ID`. This can be useful when you’re iterating on the functionality of a workflow/DAG.
*   `airflow resetdb`: though you generally do not want to run this command often, it can be very helpful if you ever need to create a “clean slate,” a situation that may arise when setting up Airflow initially (Note: this command only affects the database, and does not remove logs).

Above, we provided an outline of some of the more abstract concepts underlying Airflow’s operation. In the [Final installment](https://medium.com/@dustinstansbury/going-with-the-flow-part-iv-airflow-in-practice-a903cbb5626d) of our series, we’ll touch on some of the more practical considerations when deploying Airflow in production.

Thanks to [Laura Oppenheimer](https://medium.com/@laura.oppenheimer?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
