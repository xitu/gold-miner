> * 原文地址：[Data Science for Startups: Introduction](https://towardsdatascience.com/data-science-for-startups-introduction-80d022a18aec)
> * 原文作者：[Ben Weber](https://towardsdatascience.com/@bgweber?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-science-for-startups-introduction.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-science-for-startups-introduction.md)
> * 译者：
> * 校对者：

# Data Science for Startups: Introduction

![](https://cdn-images-1.medium.com/max/1600/1*z0AJeiYe_9qltVgp2g7zkw.jpeg)

Source: rawpixel at pixabay.com

I recently changed industries and joined a startup company where I’m responsible for building up a data science discipline. While we already had a solid data pipeline in place when I joined, we didn’t have processes in place for reproducible analysis, scaling up models, and performing experiments. The goal of this series of blog posts is to provide an overview of how to build a data science platform from scratch for a startup, providing real examples using Google Cloud Platform (GCP) that readers can try out themselves.

This series is intended for data scientists and analysts that want to move beyond the model training stage, and build data pipelines and data products that can be impactful for an organization. However, it could also be useful for other disciplines that want a better understanding of how to work with data scientists to run experiments and build data products. It is intended for readers with programming experience, and will include code examples primarily in R and Java.

#### Why Data Science?

One of the first questions to ask when hiring a data scientist for your startup is  
_how will data science improve our product_? At [Windfall Data](https://angel.co/windfall-data), our product is data, and therefore the goal of data science aligns well with the goal of the company, to build the most accurate model for estimating net worth. At other organizations, such as a mobile gaming company, the answer may not be so direct, and data science may be more useful for understanding how to run the business rather than improve products. However, in these early stages it’s usually beneficial to start collecting data about customer behavior, so that you can improve products in the future.

Some of the benefits of using data science at a start up are:

1.  Identifying key business metrics to track and forecast
2.  Building predictive models of customer behavior
3.  Running experiments to test product changes
4.  Building data products that enable new product features

Many organizations get stuck on the first two or three steps, and do not utilize the full potential of data science. The goal of this series of blog posts is to show how managed services can be used for small teams to move beyond data pipelines for just calculating run-the-business metrics, and transition to an organization where data science provides key input for product development.

#### Series Overview

Here are the topics I am planning to cover for this blog series. As I write new sections, I may add or move around sections. Please provide comments at the end of this posts if there are other topics that you feel should be covered.

1.  **Introduction (this post):** Provides  motivation for using data science at a startup and provides an overview of the content covered in this series of posts. Similar posts include [functions of data science](https://towardsdatascience.com/functions-of-data-science-4afd5341a659), [scaling data science](https://medium.com/windfalldata/scaling-data-science-at-windfall-55f5f23698e1) and [my FinTech journey](https://towardsdatascience.com/from-games-to-fintech-my-ds-journey-b7169f08b6ad).
2.  [**Tracking Data:**](https://towardsdatascience.com/data-science-for-startups-tracking-data-4087b66952a1) Discusses the motivation for capturing data from applications and web pages, proposes different methods for collecting tracking data, introduces concerns such as privacy and fraud, and presents an example with Google PubSub.
3.  [**Data pipelines:**](https://medium.com/@bgweber/data-science-for-startups-data-pipelines-786f6746a59a) Presents different approaches for collecting data for use by an analytics and data science team, discusses approaches with flat files, databases, and data lakes, and presents an implementation using PubSub, DataFlow, and BigQuery. Similar posts include [a scalable analytics pipeline](https://towardsdatascience.com/a-simple-and-scalable-analytics-pipeline-53720b1dbd35) and [the evolution of game analytics platforms](https://towardsdatascience.com/evolution-of-game-analytics-platforms-4b9efcb4a093).
4.  [**Business Intelligence:**](https://towardsdatascience.com/data-science-for-startups-business-intelligence-f4a2ba728e75) Identifies common practices for ETLs, automated reports/dashboards and calculating run-the-business metrics and KPIs. Presents an example with R Shiny and Data Studio.
5.  [**Exploratory Analysis**](https://towardsdatascience.com/data-science-for-startups-exploratory-data-analysis-70ac1815ddec)**:** Covers common analyses used for digging into data such as building histograms and cumulative distribution functions, correlation analysis, and feature importance for linear models. Presents an example analysis with the [Natality](https://cloud.google.com/bigquery/sample-tables) public data set. Similar posts include [clustering the top 1%](https://medium.freecodecamp.org/clustering-the-top-1-asset-analysis-in-r-6c529b382b42) and [10 years of data science visualizations](https://towardsdatascience.com/10-years-of-data-science-visualizations-af1dd8e443a7).
6.  [**Predictive Modeling**](https://medium.com/@bgweber/data-science-for-startups-predictive-modeling-ec88ba8350e9)**:** Discusses approaches for supervised and unsupervised learning, and presents churn and cross-promotion predictive models, and methods for evaluating offline model performance.
7.  [**Model Production**](https://medium.com/@bgweber/data-science-for-startups-model-production-b14a29b2f920)**:** Shows how to scale up offline models to score millions of records, and discusses batch and online approaches for model deployment. Similar posts include [Productizing Data Science at Twitch](https://blog.twitch.tv/productizing-data-science-at-twitch-67a643fd8c44), and [Producizting Models with DataFlow](https://towardsdatascience.com/productizing-ml-models-with-dataflow-99a224ce9f19).
8.  **Experimentation:** Provides an introduction to A/B testing for products, discusses how to set up an experimentation framework for running experiments, and presents an example analysis with R and bootstrapping. Similar posts include [A/B testing with staged rollouts](https://blog.twitch.tv/a-b-testing-using-googles-staged-rollouts-ea860727f8b2).
9.  **Recommendation Systems:** Introduces the basics of recommendation systems and provides an example of scaling up a recommender for a production system. Similar posts include [prototyping a recommender](https://towardsdatascience.com/prototyping-a-recommendation-system-8e4dd4a50675).
10.  **Deep Learning:** Provides a light introduction to data science problems that are best addressed with deep learning, such as flagging chat messages as offensive. Provides examples of prototyping models with the R interface to [Keras](https://keras.rstudio.com/), and productizing with the R interface to [CloudML](https://tensorflow.rstudio.com/tools/cloudml/articles/getting_started.html).

The series is also available as a book in [web](https://bgweber.github.io/) and [print](https://www.amazon.com/dp/1983057975) formats.

#### Tooling

Throughout the series, I’ll be presenting code examples built on Google Cloud Platform. I choose this cloud option, because GCP provides a number of managed services that make it possible for small teams to build data pipelines, productize predictive models, and utilize deep learning. It’s also possible to sign up for a free trial with GCP and get $300 in credits. This should cover most of the topics presented in this series, but it will quickly expire if your goal is to dive into deep learning on the cloud.

For programming languages, I’ll be using R for scripting and Java for production, as well as SQL for working with data in BigQuery. I’ll also present other tools such as Shiny. Some experience with R and Java is recommended, since I won’t be covering the basics of these languages.

* * *

[Ben Weber](https://www.linkedin.com/in/ben-weber-3b87482/) is a data scientist in the gaming industry with experience at Electronic Arts, Microsoft Studios, Daybreak Games, and Twitch. He also worked as the first data scientist at a FinTech startup.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
