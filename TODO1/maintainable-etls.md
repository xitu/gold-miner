> * 原文地址：[Maintainable ETLs: Tips for Making Your Pipelines Easier to Support and Extend](https://multithreaded.stitchfix.com/blog/2019/05/21/maintainable-etls/)
> * 原文作者：[CHRIS MORADI](https://multithreaded.stitchfix.com/blog/2019/05/21/maintainable-etls/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/maintainable-etls.md](https://github.com/xitu/gold-miner/blob/master/TODO1/maintainable-etls.md)
> * 译者：
> * 校对者：

# Maintainable ETLs: Tips for Making Your Pipelines Easier to Support and Extend

![modularized code example](https://multithreaded.stitchfix.com/assets/posts/2019-05-21-maintainable-etls/maintainable-etls-code-animation.gif)

Core to any data science project is…wait for it…data! Preparing data in a reliable and reproducible way is a fundamental part of the process. If you’re training a model, calculating analytics, or just combining data from multiple sources and loading them into another system, you’ll need to build a data processing or ETL[1](#f1) pipeline.

At Stitch Fix, we practice [full-stack data science](https://multithreaded.stitchfix.com/blog/2019/03/11/FullStackDS-Generalists/). This means that we as data scientists are responsible for taking a project from ideation through production and maintenance. We are [driven by our curiosity](https://multithreaded.stitchfix.com/blog/2019/01/18/fostering-innovation-in-data-science/) and like to move quickly even though our work is often interconnected. The problems we work on are challenging, so the solutions can be complex, but we don’t want to introduce complexity where’s it’s not needed. Because we must support our work in production, our small teams share the responsibility of being on-call and help support each other’s pipelines. This allows us to do important things, like take vacation. This summer, my wife and I are heading to Italy to take the honeymoon we meant to take years ago. The last thing I want to think about while I’m there is whether my teammates are struggling to support and understand the pipelines that I wrote.

Let’s also acknowledge that data science is a dynamic field, so colleagues move on to new initiatives, teams, or opportunities outside of the company. While a data pipeline may be built by one data scientist, it is often supported and modified by several data scientists over its lifetime. Like many data science groups, we come from a variety of educational backgrounds and unfortunately, we’re not all “unicorns”—experts in software engineering, statistics, and machine learning.

While our Algorithms group does have a large, amazing team of data platform engineers, [they do not and will not write ETLs](https://multithreaded.stitchfix.com/blog/2016/03/16/engineers-shouldnt-write-etl/) to support the work of data scientists. Instead, they focus their efforts on building easy-to-use, robust, and reliable tools that enable the data scientists to quickly build ETLs, train and score models, and create performant APIs without having to worry about the infrastructure.

Over the years, I’ve found a few key practices that help make my ETLs easier to understand, maintain, and extend. In this post, we’ll look at the benefits of:

1. Building a chain of simple tasks.
2. Using a workflow management tool.
3. Leveraging SQL where possible.
4. Implementing data quality checks.

Before we get into details, I want to recognize that there’s no single set of best practices for building ETL pipelines. The focus of this post is on data science environments where two things hold true: the cast of supporting characters is evolving and diverse, and development and exploration are prioritized over ironclad reliability and performance.

## Building a Chain of Simple Tasks

The first step in making ETLs easier to understand and maintain is to follow basic software engineering practices and break large and complex computations into discrete, easy-to-digest tasks with a specific purpose. Analogously, we should break a large ETL pipeline into smaller tasks. This offers many benefits:

1. Easier to understand each task: Tasks that are only a few lines of code are easier to review, so it’s easier to absorb any nuances in the processing.

2. Easier to understand the overall processing chain: When tasks have a well-defined purpose and are named appropriately, reviewers can focus on the higher-level building blocks and how they fit together while ignoring the details of each block.

3. Easier to validate: If we need to make changes to a task, we only need to validate the output of that task and make sure that we’re adhering to any “contracts” we have with the users/callers of this task (e.g., column names and data types of the resulting table match the pre-revision format).

4. Increased modularity: If the tasks are built with some flexibility, they can be reused in other contexts. This reduces the overall amount of code needed, thereby reducing the amount of code that needs to be validated and maintained.

5. Insight into intermediate results: If we store the results of each operation, we will have an easier time debugging our pipeline when there are errors. We can peer into each stage and more easily locate where mistakes are made.

6. Increased reliability of the pipeline: We’ll discuss workflow tools soon, but breaking our pipeline into tasks makes it easier to automatically re-run tasks if a temporary failure occurs.

We can see the benefits of splitting up a pipeline into smaller tasks by looking at a simple example. At Stitch Fix, we may want to know what proportion of items sent to our customers are “high-priced” items. To start, suppose we have defined a table that stores the thresholds. Keep in mind that the thresholds will differ by client segments (kids vs. women) and item type (socks vs. pants).

Since this calculation is fairly simple, we could use a single query for the entire pipeline:

```
WITH added_threshold as (
  SELECT
    items.item_price,
    thresh.high_price_threshold
  FROM shipped_items as items
  LEFT JOIN thresholds as thresh
    ON items.client_segment = thresh.client_segment
      AND items.item_category = thresh.item_category
), flagged_hp_items as (
  SELECT
    CASE
      WHEN item_price >= high_price_threshold THEN 1
      ELSE 0
    END as high_price_flag
  FROM added_threshold
) SELECT
    SUM(high_price_flag) as total_high_price_items,
    AVG(high_price_flag) as proportion_high_priced
  FROM flagged_hp_items
```

  
This first attempt is actually fairly decent. It’s already been modularized through the use of common table expressions (CTEs) or WITH blocks. Each block serves a specific purpose, they are short and easy to absorb, and the aliases (e.g., `added_threshold`) provide enough context so that a reviewer can remember what’s done in the block.

Another positive aspect is that thresholds are stored in a separate table. We could’ve hard-coded each threshold in the query using a very large CASE statement, but this would’ve rapidly become incomprehensible to the reviewer. It also would have been harder to maintain because anytime we’d want to update a threshold, we’d have to change this query as well as any other query that used the same logic.

While this query is a good start, we can improve on the implementation. The biggest deficiency is that we don’t have easy access to any of the intermediate results: the whole calculation is done in one action. You may wonder, why would I want to look at intermediate results? Intermediate results allow you to debug on the fly, gain an opportunity to implement data quality checks, and may prove to be reusable in other queries.

For example, suppose the business added a new category of items—e.g., bonnets. We started selling the bonnets, but we forgot to update the thresholds table. In this case, we’re going to miss high-priced bonnets in our aggregate metrics. Since we used a LEFT JOIN, the rows won’t be dropped due to the join, but the value of `high_price_threshold` will be NULL. In the next stage, all of the bonnet rows will have zeros for the `high_price_flag` which will carry into our final calculations of `total_high_price_items` and `proportion_high_priced`.

If we break this large, single query into multiple queries and write the results of each stage separately, we make this pipeline more maintainable. If we store the output of the initial stage to a separate table, we can easily check that we’re not missing any thresholds. All we’ll need to do is query this table and select rows where the `high_price_threshold` is NULL. If we get any rows back, we’re missing one or more thresholds. We’ll cover this type of run-time validation of the data later in the post.

This modularized implementation is also easier to modify. Suppose instead of considering any item we’ve ever shipped, we decide that we only want to count high-priced items that were sent in the last 3 months. With the original query, we’d make the changes to the first stage and then look at final totals and hope that those are correct. By saving the first stage separately, we could add a new column that has the shipped date. We could then modify our query and verify that the shipped date in the resulting table all fall within the date ranges we expect. We could also save our new version to another location and perform a “data diff” to make sure we’re dropping the right rows.

This last example leads to one of the greatest benefits of splitting this query into separate stages: We can reuse our queries and our data to support different use cases. Suppose one team wants the high-priced item metrics for the last 3 months, but another team needs it for only the last week. We can modify the first stage’s query to support these and write the output of each version to separate tables. If we dynamically specify the source table for the later stage queries[2](#f2), the same queries will support both use cases. This pattern can be extended to other use cases as well: teams with different threshold values, final metrics broken down by client segment and item category vs. rolled up.

There are some tradeoffs we’re making by creating a staged pipeline. The biggest of these is in the runtime performance, especially when we’re processing large datasets. Reading and writing data off disk is relatively expensive, and with each processing stage, we’re reading in the output of the prior stage and writing out the results. One big advantage that Spark offers over the older MapReduce paradigm is that temporary results can be cached in memory on the worker nodes (executors). Spark’s Catalyst engine also optimizes the execution plan for SQL queries and DataFrame transformations, but it can’t optimize across a read/write boundary. The second major limitation of these staged pipelines is that they make it much more difficult to create automated integration tests, which involve testing the results of multiple stages of computation.

With Spark, there are ways around these deficiencies. If I have to perform several small transformations and I want the option to save the intermediate steps, I’ll create a supervisor script that performs the transformations and writes out the intermediate tables only if a command-line flag is set[3](#f3). When I’m developing and debugging changes, I can use the flag to produce the data I need to validate that the new calculations are correct. Once I’m confident in my changes, I can turn off the flag to skip writing the intermediate data.

## Use a Workflow Management Tool

Enormous productivity gains are enabled through the use of a reliable workflow management and scheduling engine. Some common examples include [Airflow](https://airflow.apache.org/), [Oozie](https://oozie.apache.org/), [Luigi](https://github.com/spotify/luigi), and [Pinball](https://github.com/pinterest/pinball). This recommendation will take time and expertise to set up; it is not something that an individual data scientist will likely be responsible for managing. At Stitch Fix, we’ve developed our own proprietary tool that is maintained by our platform team, and it allows data scientists to create, run, and monitor our own workflows.

Workflow tools make it easy to define a directed acyclic graph (DAG) of computation where each child task is dependent on the successful completion of any parent tasks. They typically provide the ability to specify a schedule for running the workflow, wait on external data dependencies before the workflow kicks off, retry failed tasks, resume execution at the point of failure, create alerts when failures occur, and run tasks that are not interdependent in parallel. Combined, these features enable users to build complex processing chains that are reliable, performant, and easier to maintain.

## Leverage SQL Where Possible

This is perhaps the most controversial recommendation that I’ll make. Even within Stitch Fix, there are many data scientists that would argue against SQL and instead advocate using a general-purpose programming language. I was personally a member of this camp up until very recently. On the practical side, SQL can be very hard to test—particularly through automated testing. If you come from a software engineering background, the challenges with testing might feel like reason enough to avoid SQL. There’s also an emotional trap regarding SQL that I’ve fallen into in the past: “SQL is less technical and less professional; **real** data scientists should code.”

The primary benefit of SQL is that it’s understood by all data professionals: data scientists, data engineers, analytics engineers, data analysts, DB admins, and many business analysts. This is a large user base that can help build, review, debug, and maintain SQL data pipelines. While [Stitch Fix doesn’t have many of these data roles](https://multithreaded.stitchfix.com/blog/2019/03/11/FullStackDS-Generalists/), SQL is the common language among our group of diverse data scientists. As a result, leveraging SQL reduces the need for specialized roles on teams where people with strong CS backgrounds create the pipelines for the whole team and are unable to equitably share support responsibilities.

By writing transformations as SQL queries, we can also enable scalability and some level of portability. With the proper SQL engine, the same query can be used to process a hundred rows of data and then be run against terabytes. If we wrote the same transformations using an in-memory processing package such as Pandas, we’d run the risk of exceeding our processing power as the business or project scales. Everything runs fine until the day when the dataset is too large to fit in memory, and then things fail. If the job is in production, this can lead to a mad rush to rewrite things to get them back up and running.

Because of the large overlap in SQL dialects, we have some level of portability from one SQL engine to another. At Stitch Fix, we use Presto for adhoc queries and Spark for our production pipelines. When I’m building a new ETL, I generally use Presto to understand how the data are structured and build out parts of the transformations. Once these parts are in place, the same queries almost always run, unaltered, on Spark[4](#f4). If I were to switch to Spark’s DataFrame API, I would need to completely rewrite my query. The portability benefits apply in the reverse direction as well. If there’s an issue with a production job, I can re-run the same query and add filters and limits to pull a subset of the data back for visual inspection.

Of course, we can’t do everything in SQL. You’re not going to use it to train a machine learning model, and there are a lot of other cases where a SQL implementation would be overly complicated even if it is possible. For these tasks, you should definitely use a general-purpose programming language. If you’re following the key recommendation and breaking your work up into small chunks of work, these complex tasks will be limited in scope and easier to understand. Where possible, I try to isolate complex logic at the end of a chain of simple preparation stages, such as: joining different data sources, filtering, and creating flag columns. This makes it easy to verify the data going into the final, complex stage and may even simplify some of that logic. Generally, I’ve deemphasized automated testing in the rest of this post, but jobs where there’s complex logic are the best place to focus your efforts in providing good test coverage.

## Implement Data Quality Checks

Automated unit tests are enormously beneficial when we have complicated logic to validate, but for relatively simple transformations that are part of a staged pipeline, we can often manually validate each stage. When it comes to ETL pipelines, automated tests provide mixed benefits because they don’t cover one of the biggest sources of errors: failures upstream of our pipeline that result in old or incorrect data in our initial dependencies.

One common source of error is to fail to ensure that our source data has been updated before starting our pipeline. For example, suppose we rely on a data source that is updated once a day, and our pipeline starts running before it’s been updated. This means that we’re either using old data (calculated the prior day) or even a mixture of old and current data. This type of error can be challenging to identify and resolve because the upstream data source may finish updating shortly after we’ve ingested the old version of the data.

Failures upstream may also cause bad data in our source data: miscalculation of fields, changing schema, and/or a higher frequency of missing values. In a dynamic and interconnected environment, which is very much the kind of environment we're operating in at Stitch Fix, it’s not uncommon to build off a data source created by another team and for those sources to change unexpectedly. Unit tests typically will not flag these failures, but they can be uncovered through run-time validation—sometimes referred to as data quality checks. We can write separate ETL tasks that will automatically perform checks and raise errors if our data don’t meet the standards we’re expecting. A simple example was referred to above with the missing high-priced bonnets threshold. We can query the combined shipped items and high-priced thresholds table and look for rows where the threshold is missing. If we find any rows, we can alert the maintainers. This same idea can be extended to more complicated checks: calculating the fraction that is null, the mean, standard deviation, maximum, or minimum values.

In the case of higher than expected missing values for a particular column, we’d first need to define what’s expected, which might be done by looking at the proportion missing for every day of the last month. We could then define a threshold at which we trigger an alert. This idea can be extended to other data quality checks (e.g., the mean value falls within a range), and we can tune these thresholds to make our alerting more or less sensitive.

## A Work In Progress

In this post, we’ve gone over several practical steps that can make your ETLs easier to maintain, extend, and support in production. These benefits extend to your teammates as well as your future selves. While we can take pride in well-constructed pipelines, writing ETLs is not why we got into data science. Instead, these are a fundamental part of the work that allows us to achieve something bigger: building new models, deriving new insights for the business, or delivering new features through our APIs. Poorly constructed pipelines not only take time away from the team, they create an obstacle to innovation.

At my last job, I learned the hard way that **inaccessible** pipelines can prevent a project from being maintained or extended. I was part of an innovation lab that was spearheading the use of big data tools to tackle various problems in the organization. My first project was to build a pipeline to identify merchants where credit card numbers were being stolen. I built out a solution that used Spark, and the resulting system was highly successful at identifying new fraud activity. However, once I passed this off to the credit card division to support and extend, the problems started. I broke every best practice I’ve listed here in writing the pipeline: it contained a single job that performed many complicated tasks, it was written in Spark which was new to the company at the time, it relied on cron for scheduling and didn’t send alerts when failures occurred, and it didn’t have any data quality checks to ensure that the source data were up-to-date and correct. Due to these deficiencies, there were extended periods of time when the pipeline didn’t run. Despite an extensive roadmap for adding improvements, very few of these could be implemented because the code was hard to understand and extend. Eventually, the whole pipeline was rewritten in a way that could be more easily maintained.

Just like the data science project that your ETL is feeding, your pipeline will never truly be complete and should be seen as being perpetually in flux. With each change you make comes the opportunity to make small improvements: increase the readability, remove unused data sources and logic, or simplify or break up complex tasks. None of these recommendations are groundbreaking, but it requires discipline to follow them consistently. Much like lion taming, when pipelines are small, they are relatively easy to keep under control. However, as they grow, they become more unwieldy and prone to sudden unexpected and chaotic behavior. In the end, you either need to start fresh and follow better practices or risk losing your head[5](#f5).

* * *

## Footnotes

[[1]↩](#back-1) Abbreviation for Extract, Transform, and Load.

[[2]↩](#back-2) The easiest way to do this is with a simple string replace or string interpolation, but you can achieve more flexibility with template processing libraries like Jinja2.

[[3]↩](#back-3) For Python, libraries like [Click](https://click.palletsprojects.com/en/7.x/), [Fire](https://google.github.io/python-fire/guide/), or even [argparse](https://docs.python.org/3/howto/argparse.html) from the standard library can make defining these command-line flags easy.

[[4]↩](#back-4) Some operations such as manipulating dates and extracting fields from JSON require modifying the queries, but these changes are minimal.

[[5]↩](#back-5) No lions or data scientists were hurt in the making of the blog post.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
