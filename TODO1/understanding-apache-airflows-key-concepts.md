> * 原文地址：[Understanding Apache Airflow’s key concepts](https://medium.com/@dustinstansbury/understanding-apache-airflows-key-concepts-a96efed52b1a)
> * 原文作者：[Dustin Stansbury](https://medium.com/@dustinstansbury?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-apache-airflows-key-concepts.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-apache-airflows-key-concepts.md)
> * 译者：
> * 校对者：

# 理解 Apache Airflow 的关键概念

## 四部分系列的第三系列

在[Quizlet](https://quizlet.com) 的[寻找最优工作流管理系统](https://medium.com/@dustinstansbury/going-with-the-air-flow-quizlets-hunt-for-the-best-workflow-management-system-around-1ca546f8cc68) 的[第一部分](https://medium.com/@dustinstansbury/going-with-the-flow-part-i-an-introduction-to-workflow-management-systems-19987afcdb5e)和[第二部分](https://medium.com/@dustinstansbury/going-with-the-flow-part-ii-a-workflow-management-system-wish-list-3f97d40e9571)中，我们促进了现代商业实践中对工作流管理系统（WMS）的需求，并提供了一份希望获得的特性以及功能列表，这使得我们最后选择了 [Apache Airflow](https://airflow.incubator.apache.org/) 作为我们的 WMS 选择。这篇文章旨在给好奇的读者提供提供关于 Airflow 的组件和操作的详细概述。我们会通过实现本系列[第一部分](https://medium.com/@dustinstansbury/going-with-the-flow-part-i-an-introduction-to-workflow-management-systems-19987afcdb5e)中介绍的示例工作流（查阅 **图 3.1**）来介绍 Airflow 的关键概念。

![](https://cdn-images-1.medium.com/max/800/1*ytMWtgd5h-1EiGiCe_D3ew.png)

**图 3.1：数据处理工作流的示例.**

Airflow 是一种 WMS，即：它将任务以及它们的依赖看作代码，按照那些计划规范任务执行，并在 worker 进程之间分发需执行的任务。Airflow 提供了一个用于显示当前活动任务和过去任务状态的优秀 UI，并显示有关执行任务的诊断信息，允许用户手动管理任务的执行和状态。

#### 工作流都是 “DAGs”

Airflow 中的工作流是具有方向性依赖的任务集合。具体说明则是 Airflow 使用有向无圈图 —— 或简短的 DAG —— 来表现工作流。图中的每个节点都是一个任务，在任务之间定义边缘依赖（该图强制为无循环的，因此不会出现循环依赖，从而导致无限执行循环）。

**图 3.2** 顶部演示了我们的示例工作流是如何在 Airflow 中变现为 DAG 的。注意在[**图 1.1**](https://medium.com/@dustinstansbury/going-with-the-flow-part-i-an-introduction-to-workflow-management-systems-19987afcdb5e) 中我们的示例工作流任务的执行计划结构与**图 3.2** 中的 DAG 结构相似。

![](https://cdn-images-1.medium.com/max/800/1*N2CWqwBZiulBUwiPprKg4g.png)

**图 3.2 来自 Airflow UI 的屏幕截图，表示示例工作流 DAG。面板顶部**：1 月 25 号 `DagRun` 的图表视图。深绿色节点表示 `TaskInstance` 的“成功”状态。淡绿色描绘了 `TaskInstance` 的“运行”状态。**底部子面板**：`example_workflow` DAG 的树图。Airflow 的主要组件在屏幕截图中高亮显示，包括 Sensor、Operator、任务、`DagRuns` 和 `TaskInstances`。`DagRuns` 在图视中表示为列 —— `DagRun` 在 1 月 25 号用青色表示。图示中的每个方框表示一个 `TaskInstance` —— 1 月 25 号 为 `perform_currency_conversion` 任务的 `TaskInstance`（“运行态”）用蓝色表示。

在高级别中，可以将 DAG 看作是一个包含任务极其依赖，何时以及如何设置那些任务的上下文的容器。每个 DAG 都有一组属性，最重要的是它的 `dag_id`，在所有 DAG 中的唯一标识符，它的 `start_date` 用于说明 DAG 任务被执行的时间，`schedule_interval` 用于说明任务被执行的频率。此外，`dag_id`、`start_date` 和 `schedule_interval`，每个 DAG 都可以使用一组 `default_arguments` 进行初始化。这些默认参数由 DAG 中的所有任务继承。

在下列代码块中，我们在 Airflow 中定义了一个用于实现我们游戏公司示例工作流的 DAG。

```
# 每个工作流/DAG 都必须要有一个唯一的文本标识符
WORKFLOW_DAG_ID = 'example_workflow_dag'

# 开始/结束时间是 datetime 对象
# 这里我们在 2017 年 1 月 1 号开始执行
WORKFLOW_START_DATE = datetime(2017, 1, 1)

# 调度器/重试间隔是 timedelta 对象
# 这里我们每天都执行 DAG 任务
WORKFLOW_SCHEDULE_INTERVAL = timedelta(1)

# 默认参数默认应用于所有任务
# 在 DAG 中
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

# 初始化 DAG
dag = DAG(
    dag_id=WORKFLOW_DAG_ID,
    start_date=WORKFLOW_START_DATE,
    schedule_interval=WORKFLOW_SCHEDULE_INTERVAL,
    default_args=WORKFLOW_DEFAULT_ARGS,
)
```

#### `Operators`、`Sensors` 和 Tasks

尽管 DAG 用于组织并设置执行上下文，但 DAG 不会执行任何实际计算。相反，任务实际上是 Airflow 中我们想要执行“所做工作”的元素。任务有两种特点：它们可以执行一些显示操作，在这种情况下，它们是 **Operator**，或者它们可以暂停执行依赖任务，直到满足某些条件，在这种情况下，它们是 **Sensors**。原则上来说，Operator 可以执行在 Python 中被执行的任何函数。同样，Sensors 可以检查任何进程或者数据结构的状态。

下述代码块显示了如何定义一些（假设的）Operator 和 Sensor 类来实现我们的工作流示例。

```
##################################################
# 自定义 Sensors 示例/ Operators (NoOps) #
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

代码定义了 `BaseSensorOperator` 的子类，即 `ConversionRatesSensor`。这个类实现了所有 `BaseSensorOperator` 对象必需的 `poke` 方法。如果下游任务要继续执行，`poke` 方法必须返回 `True`，否则返回 `False`。在我们的示例中，这个 sensor 将用于决定何时外部 API 的交换率何时可用。

`ExtractAppStoreRevenueOperator` 和 `TransformAppStoreJSONDataOperator` 这两个类都继承自 Airflow 的`BaseOperator` 类，并实现了 `execute` 方法。在我们的示例中，这两个类的 `execute` 方法都从应用程序存储 API 中获取数据，并将它们转换为公司首选的存储格式。注意  `ExtractAppStoreRevenueOperator` 也接受一个自定义参数 `app_store_name`，它告诉类应用程序存储应该从哪里获取请求数据。

注意，Operator 和 Sensor 通常在单独文件中定义，并导入到我们定义 DAG 的同名命名空间中。但我们也可以将这些类定义添加到同一个 DAG 定义的文件中。

形式上，Airflow 定义任务为 Sensor 或 Operator 类实例化。实例化任务需要提供一个唯一的 `task_id` 和 DAG 容器来添加任务（注意：在高于 1.8 的版本中，不再需要 DAG 对象）。下面的代码块显示了如何实例化执行示例工作流所需的所有任务。（注意：我们假设示例中引用的所有 Operator 都是在命名空间中定义或导入的）。

```
########################
# 实例化任务  #
########################

# 实例化任务来提取广告网络收入
extract_ad_revenue = ExtractAdRevenueOperator(
    task_id='extract_ad_revenue',
    dag=dag)

# 动态实例化任务来提取应用程序存储数据
APP_STORES = ['app_store_a', 'app_store_b', 'app_store_c']
app_store_tasks = []
for app_store in APP_STORES:
    task = ExtractAppStoreRevenueOperator(
        task_id='extract_{}_revenue'.format(app_store),
        dag=dag,
        app_store_name=app_store,
        )
    app_store_tasks.append(task)

# 实例化任务来等待转换率、数据均衡
wait_for_conversion_rates = ConversionRatesSensor(
    task_id='wait_for_conversion_rates',
    dag=dag)

# 实例化任务，从 API 中提取转化率
extract_conversion_rates = ExtractConversionRatesOperator(
    task_id='get_conversion_rates',
    dag=dag)

# 实例化任务来转换电子表格数据
transform_spreadsheet_data = TransformAdsSpreadsheetDataOperator(
    task_id='transform_spreadsheet_data',
    dag=dag) 

# 从所有应用程序存储中实例化任务转换 JSON 数据
transform_json_data = TransformAppStoreJSONDataOperator(
    task_id='transform_json_data',
    dag=dag,
    app_store_names=APP_STORES)

# 实例化任务来应用
perform_currency_conversions = CurrencyConversionsOperator(
    task_id='perform_currency_conversions',
    dag=dag)

# 实例化任务来组合所有数据源
combine_revenue_data = CombineDataRevenueDataOperator(
    task_id='combine_revenue_data',
    dag=dag)  

# 实例化任务来检查历史数据是否存在
check_historical_data = CheckHistoricalDataOperator(
    task_id='check_historical_data',
    dag=dag)

# 实例化任务来根据历史数据进行预测
predict_revenue = RevenuePredictionOperator(
    task_id='predict_revenue',
    dag=dag)  
```

此任务实例化代码在与 DAG 定义相同的文件/命名空间中执行。我们可以看到添加任务的代码非常简洁，而且允许通过注解进行内联文档。第 10–19 行展示了在代码中定义工作流的优势之一。我们能够动态地定义三个不同的任务，用于使用 `for` 循环从每个应用程序存储中提取数据。这种方法可能在这个小示例中不会给我们带来太大的好处，但随着应用程序商店数量的增加，好处会日益显著。

#### 定义任务依赖关系

Airflow 的关键优势是定义任务之间依赖关系的简洁性和直观约定。下述代码表明了我们如何为示例工作流定义任务依赖关系图：

```
###############################
# 定义任务依赖关系 #
###############################

# 依赖设置使用 `.set_upstream` 和/或  
# `.set_downstream` 方法
# （in version >=1.8.1，也可以使用
# `extract_ad_revenue << transform_spreadsheet_data` 语法）

transform_spreadsheet_data.set_upstream(extract_ad_revenue)

# 动态定义应用程序存储依赖项
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

同时，此代码在与 DAG 定义相同的文件/命名空间中运行。任务依赖使用 `set_upstream` 和 `set_downstream` operators 来设置（但在高于 1.8 的版本中，使用移位运算符 `<<` 和 `>>` 来更简洁地执行相似操作是可行的）。一个任务还可以同时具有多个依赖（例如，`combine_revenue_data`），或一个也没有（例如，所有的 `extract_*` 任务）。

**图 3.2 的顶部子面板**显示了由上述代码所创建的 Airflow DAG，渲染为 Airflow 的 UI（稍后我们会详细介绍 UI）。 DAG 的依赖结构与在**图 1.1** 显示的我们为我们的示例工作流所提出的执行计划非常相似。当 DAG 被执行时，Airflow 会使用这种依赖结构来自动确定哪些任务可以在任何时间点同时运行（例如，所有的 `extract_*` 任务）。

#### DagRuns 和 TaskInstances

一旦我们定义了 DAG —— 即，我们已经实例化了任务并定义了它们的依赖项 —— 我们就可以基于 DAG 的参数来执行任务。Airflow 中的一个关键概念是 `execution_time`。当 Airflow 调度器正在运行时，它会定义一个用于执行 DAG 相关任务的定期间断的日期计划。执行时间从 DAG `start_date` 开始，并重复每一个 `schedule_interval`。在我们的示例中，调度时间是 `(‘2017–01–01 00:00:00’, ‘2017–01–02 00:00:00’, ...)`。对于每一个 `execution_time`，都会创建 `DagRun` 并在执行时间上下文中进行操作。因此，`DagRun` 只是具有一定执行时间的 DAG（参见 **图 3.2 的底部子面板**）。

所有与 `DagRun` 关联的任务都称为 `TaskInstance`。换句话说，`TaskInstance` 是一个已经实例化而且拥有 `execution_date` 上下文的任务（参见 **图 3.2 的底部子面板**）。`DagRun`s 和 `TaskInstance` 是 Airflow 的核心概念。每个`DagRun` and `TaskInstance` 都与记录其状态的 Airflow 元数据库中的一个条目相关联（例如 “queued”、“running”、“failed”、“skipped”、“up for retry”）。读取和更新这些状态是 Airflow 调度和执行过程的关键。

#### Airflow 的架构

在其核心中，Airflow 是建立在元数据库上的队列系统。数据库存储队列任务的专题，调度器使用这些程序来确定如何将其它任务添加到队列的优先级。此功能由四个主要组件编排。（请参阅**图 3.2 的左子面板**）：

1.  **元数据库**：这个数据库存储有关任务状态的信息。数据库使用在 SQLAlchemy 中实现的抽象层执行更新。该抽象层将 Airflow 剩余组件功能从数据库中干净地分离了出来。
2. **调度器**：调度器是一种使用 DAG 定义结合元数据中的任务状态来决定哪些任务需要被执行以及任务执行优先级的过程。调度器通常作为服务运行。 
3. **执行器**: Excutor 是一个消息列队进程，它被绑定到调度器中，用于确定实际执行每个任务计划的工作进程。有不同类型的执行器，每个执行器都使用一个指定工作进程的类来执行任务。例如，`LocalExecutor` 使用与调度器进程在同一台机器上运行的并行进程执行任务。其他像 `CeleryExecutor` 的执行器使用存在于独立的工作机器集群中的工作进程执行任务。
4. **Workers**: 这些是实际执行任务逻辑的进程，由正在使用的执行器确定。

![](https://cdn-images-1.medium.com/max/800/1*czjWSmrjiRY1goA0emv7IA.png)

**图 3.2：Airflow 的一般架构**。Airflow 的操作建立于存储任务状态和工作流的元数据库之上（即 DAG）。调度器和执行器将任务发送至队列，让 Worker 进程执行。WebServer 运行（经常与调度器在同一台机器上运行）并与数据库通信，在 Web UI 中呈现任务状态和任务执行日志。每个有色框表明每个组件都可以独立于其他组件存在，这取决于部署配置的类型。

#### 调度器操作

首先，Airflow 调度器操作看起来更像是黑魔法而不是逻辑程序。也就是说，如果你发现自己正在调试它的执行，那么了解调度器的工作原理久可以节省大量的时间，为了让读者免于深陷 Airflow 的源代码（尽管我们非常推荐它!）我们用伪代码概述了调度器的基本操作：

```
步骤 0. 从磁盘中加载可用的 DAG 定义（填充 DagBag）

当调度器运行时：
	步骤 1. 调度器使用 DAG 定义来标识并且/或者初始化在元数据的 db 中的任何 DagRuns。
	
	步骤 2. 调度器检查与活动 DagRun 关联的 TaskInstance 的状态，解析 TaskInstance 之间的任何依赖，标识需要被执行的 TaskInstance，然后将它们添加至 worker 队列，将新排列的 TaskInstance 状态更新为数据库中的“排队”状态。
	
	步骤 3. 每个可用的 worker 从队列中取一个 TaskInstance，然后开始执行它，将此 TaskInstance 的数据库记录从“排队”更新为“运行”。
	
	步骤 4.一个 TaskInstance 一旦完成运行，关联的 worker 就会返回到队列并更新数据库中的 TaskInstance 的状态（例如“完成”、“失败”等）。
	
	步骤 5. 调度器根据所有已完成的相关 TaskInstance 的状态更新所有活动
	        DagRuns 的状态（“运行”、“失败”、“完成”）。
	
	步骤 6. 重复步骤 1-5
```

#### Web UI

除了主要的调度和执行组件外，Airflow 还支持包括全功能的 Web UI 组件（参阅**图 3.2** 的一些 UI 示例)，包括：

1. **Webserver**：此过程运行一个简单的 Flask 应用程序，它从元数据库中读取所有任务状态，并让 Web UI 呈现这些状态。 
2. **Web UI**：此组件允许客户端用户查看和编辑元数据库中的任务状态。由于调度器和数据库之间的耦合，Web UI 允许用户操作调度器的行为。
3. **执行日志**：这些日志由 worker 进程编写，存储在磁盘或远程文件存储区（例如 [GCS](https://cloud.google.com/storage) 或 [S3](https://aws.amazon.com/s3)）中。Webserver 访问日志并将其提供给 Web UI。

尽管对于 Airflow 的基本操作来说，这些附加组件都不是必要的，但从功能性角度来说，它们确实使 Airflow 有别于当前的其他工作流管理。 具体来说，UI 和集成执行日志允许用户检查和诊断任务执行，以及查看和操作任务状态。

#### 命令行接口

除了调度程序和 Web UI，Airflow 还通过命令行接口（CLI）提供了健壮性的特性。尤其是，当我们开发 Airflow 时，发现以下的这些命令非常有用： 

*   `airflow test DAG_ID TASK_ID EXECUTION_DATE`。允许用户在不影响元数据库或关注任务依赖的情况下独立运行任务。这个命令很适合独立测试自定义 Operator 类的基本行为。
*   `airflow backfill DAG_ID TASK_ID -s START_DATE -e END_DATE`。在 `START_DATE` 和 `END_DATE` 之间执行历史数据的回填，而不需要运行调度器。当你需要更改现有工作流的一些业务逻辑并需要更新历史数据时，这是很好的。（请注意，回填**不需要**在数据库中创建 `DagRun` 条目，因为它们不是由 `[SchedulerJob](https://github.com/apache/incubator-airflow/blob/master/airflow/jobs.py#L471)` 类运行的）。
*   `airflow clear DAG_ID`。移除 `DAG_ID` 元数据库中的 `TaskInstance` 记录。当你迭代工作流/DAG 功能时，这会很有用。
*   `airflow resetdb`：虽然你通常不想经常运行这个命令，但如果你需要创建一个“干净的板子”，这是非常有帮助的，这种情况载最初设置 Airflow 时可能会出现（注意：这个命令只影响数据库，不删除日志）。

综上所述，我们提供了一些更加抽象的概念，作为 Airflow 的基础。在此系列的[最后部分 installment](https://medium.com/@dustinstansbury/going-with-the-flow-part-iv-airflow-in-practice-a903cbb5626d) 中，我们将讨论在生产中部署 Airflow 时的一些更实际的注意事项。

感谢 [Laura Oppenheimer](https://medium.com/@laura.oppenheimer?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
