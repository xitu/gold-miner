> * 原文地址：[Predicting your app’s monetization future](https://medium.com/googleplaydev/predicting-your-apps-monetization-future-27180e82ae34)
> * 原文作者：[Ignacio Monereo](https://medium.com/@ignacio.monereo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/predicting-your-apps-monetization-future.md](https://github.com/xitu/gold-miner/blob/master/TODO/predicting-your-apps-monetization-future.md)
> * 译者：
> * 校对者：

# Predicting your app’s monetization future

## Post 1 of 2: Introducing predictive analytics and the calculation of customer lifetime value

We would all like a magic crystal ball, one that reveals how our app will perform in the future: how many users it will attract and how much revenue it will generate. Unfortunately, there is no such crystal ball. But, the good news is that there are techniques that allow you to gain useful insights into your app’s future performance, techniques that can help in creating a sensible, effective acquisition strategy.

This is the first of two posts I’ve written to explore **lifetime value** (**LTV**). In this post, I’m going to introduce predictive analytics, suggest a simple formula for calculating LTV, and explain how you can get a value you can use for planning.

In the [second post](https://medium.com/googleplaydev/predicting-your-apps-future-65b741999e0e), I’ll examine how the simple formula can be applied to five popular app monetization strategies, while also offering some insights from developers about how to optimize each of these monetization strategies.

### Predictive analytics

If you want to understand how your app might perform in the future, you can gain insight by looking at historical data collected from users. Extracting insights from this data, using various statistical techniques, is the domain of predictive analytics.

Predictive models are used in many areas of business, as they help answer critical business management questions: how many paying users will we have next year? What is the expected number of transactions next year? When will users churn from our service?

These models have been studied extensively in the offline world. And thanks to the digital revolution, we’re seeing an increase in their popularity driven by the improved ability to collect, organize, and distribute user data.

In the mobile apps world, game developers are some of the most advanced users of these techniques, because their use has had a positive impact on the monetization of their apps.

#### Approach, from empirical to mathematical models

Methods for predicting how many customers you’ll have and how much they’ll buy in the future can vary widely. The two extremes are:

* Simple models based on professional experience or benchmarking. For example, a company hires an external consultant to advise on sales projections for the next year, based on the consultant’s knowledge of the market and sector.
* Complex mathematical models, such as the Pareto/NBD model (see [Counting Your Customers: Who Are They and What Will They Do Next?](http://www.jstor.org/stable/2631608?seq=1#page_scan_tab_contents) by David C. Schmittlein, Donald G. Morrison, and Richard Colombo) or the BG/NBD Model (see [“Counting Your Customers” the Easy Way: An Alternative to the Pareto/NBD Model](http://brucehardie.com/papers/bgnbd_2004-04-20.pdf) by Peter S. Fader, Bruce G. S. Hardie, and Ka Lok Lee). These models take multiple variables into account, including recency (last purchase) and frequency or number of orders over a given period, to calculate the probability of a customer buying again.

For the mathematical modeling approach, there are online resources that can help with the calculations, such as the one described in [Implementing the BG/NBD Model for Customer Base Analysis in Excel](http://www.brucehardie.com/notes/004/) by Bruce G. S. Hardie.

#### Data and tools for analysis

One of the main drivers for the development of predictive analysis techniques is the increase in the use of analytical tools. Strong analytical tools allow us to collect, organize, and cluster data efficiently and share it rapidly with key stakeholders and decision makers.

Some of the most important app metrics are:

* **User acquisition data**: number of installs, number of uninstalls, and acquisition sources.
* **Engagement data**: retention of users (at 1, 7, 28, 90, 180, and 365 days after download).
* **Monetization data**: number of users who have purchased, recency of last purchase, frequency of transactions, total value of purchases, churn ratio, and new versus repeat customers.

The importance of these variables will depend on the metric being calculated, as well as factors such as:

* **Nature of the app**: Engagement and use will vary considerably among different app types.
* **Business model**: Depending on the chosen business model certain metrics might have a greater impact. For example, subscription businesses usually care a lot about their subscribers’ renewal moment.
* **Method used**: Some methods will require certain data to build future predictions. For example, use of BG/NBD requires frequency and recency data.

It’s important to emphasize that a strong analytical tool — such as [Google Analytics for Firebase](https://firebase.google.com/features/analytics) for in-app analytics or the [Google Play Console](https://play.google.com/apps/publish/) for monetization — will be able to collect this information accurately and promptly, but also will enable the rapid treatment and sharing of this information. This is key to acting quickly in a dynamic environment, such as the digital ecosystem.

#### Context

Predictive analytics relies heavily on historical data about users and customers. Although this is a good starting point, don’t ignore external information that could affect future predictions. This might include the stage of company development, technology trends, and the macroeconomic environment.

Particularly when calculating lifetime value for apps, it can be useful to adjust some metrics based on contextual factors, such as the nature of the transaction and the contractual obligations. For example, a retail app might have to decide between considering active paying users as those that bought something in the last month and those that did so in the last year.

There are several different frameworks that can help identify these contextual factors. Among them, I find the one suggested in [Probability Models for Customer-Base Analysis](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.180.2024&rep=rep1&type=pdf) by Peter S. Fader and Bruce G. S. Hardie useful.

Fader and Hardie’s model differentiates customer behavior based on whether there is a contractual relationship between the company and the customer, and whether transactions are continuous or discrete. Take this example based on the model:

![](https://cdn-images-1.medium.com/max/800/1*-tQUKX6mG08lKHaJFscAVQ.png)

In the top left corner are companies without a contractual relationship with their consumers that generate a continuous flow of transactions. A concrete example is an e-commerce app, where the consumer makes transactions on a recurrent basis but can leave and churn at any time.

In the bottom right corner is the opposing example: the company has a contractual relationship with its customer for a term and transactions occur at specific times. A concrete example is a life insurance policy where a customer buys at a certain time, for example when they find their first job, and the policy is valid for a period: the duration of the premium payments.

### Lifetime value

One of the most popular predictive analytics metrics is the user lifetime value (LTV), an estimate of the economic value of a user during their entire life in a business. Well known in the offline world, this metric has become widely used by app and game businesses.

LTV is useful as it offers an understanding of the potential revenue per user. This, in turn, helps determine how much to spend on customer acquisition and analysis of which channels, platforms, and user segments are the most profitable.

However, before discussing the calculation, there are some common LTV pitfalls that need to be avoided. So, don’t:

* Use LTV as an objective and apply resources to optimize and maximize it. Consider it simply as a tool, LTV will improve as a result of actions to grow other metrics such as engagement, retention, and monetization.
* Create overly optimistic LTV using inappropriate assumptions. For example, a startup might overestimate the average revenues per user, inflating the LTV as a result, and therefore may spend more than would be advisable on acquiring users.
* Allow the Cost of acquiring a customer (CAC) to exceed LTV. Although many factors should be considered (stage of the company: launch versus mature, type of relationship: contractual versus non-contractual) an industry rule of thumb is that CAC should not exceed the Net LTV of an app. However, many businesses employ an LTV to CAC ratio of 3:1 (CAC will never exceed 33% of the Net LTV).
* Consider a high LTV to be a competitive advantage. In a fast-moving sector, such as technology, it’s very common to find examples of apps that monetize incredibly well and have high LTVs but are losing market share or presence quickly, as technology becomes obsolete and users move towards newer, more appealing products.

#### Calculating LTV

There are several ways to calculate LTV for apps and games. These methods vary depending on the complexity of the business model, the available data, and the accuracy required.

As a starting point let’s use the following, simplified formula:

> LTV (for a given period) = Lifetime x ARPU

Now, let’s examine the three variables in detail:

**a. LTV period**

Most developers calculate LTV for 180 days, 1 year, 2 years, or 5 years. The factors used to decide on the LTV period might include the average user lifetime or the business model chosen.

As an example, imagine a developer with an in-app purchase model and an average user lifetime of 15 months. In this case, LTV for 2 years would be higher than that for 1 year. However, the 1-year LTV is a more conservative approach, as the average lifetime is higher (15 months) than the period selected (12 months).

Selection of the LTV period should consider:

* **Business nature**_,_ or more specifically the lifecycle of the app. To illustrate, compare a seasonal app (such as one providing information about the Olympics) to an SaaS app (say something like a Project management app). A seasonal app might be relevant during a short period only, so it will not make sense to calculate a long-term LTV. Whereas the SaaS app should remain relevant long-term, and so a longer LTV period can be used.
* **Business model** where, for example, returns might be higher for certain monetization models (notably subscriptions) and increase in the long term if monetization is incentivized correctly (negative churn), justifying a longer LTV period. For example, telco companies have traditionally invested heavily in user acquisition, even subsidizing hardware, expecting long lifetime cycles.
* **Stage of the company**, for example, early compared to mature stages. Early stage companies, because they are relying on the development of a technology or because they do not have historical data, will often select longer and more optimistic periods over which to calculate LTV. On the other hand, a mature company with a technology that is quickly becoming obsolete might want to choose shorter LTV periods.

**b. Lifetime**

Lifetime is directly correlated to both engagement and retention. Both concepts are intimately related, as engagement will help to increase the retention of users, in turn, increasing the likelihood they can be monetized. App developers usually calculate lifetime based on app retention.

Taking a simple approach to estimate retention, let’s define a user’s “churn” moment within an app as where that user hasn’t opened the app in the last month. The average period until a user stops using the app for at least 1 month could then be calculated.

A more sophisticated way to calculate lifetime would be using survival curves models: a system of decreasing equations based on historical use data (one curve per user or user cohort). The integral or average retention per segment could then be calculated, and the equation solved for a certain period.

Take the example below. After calculating the integral of all users, the probability of a user remaining active after 180 days is only 23%. Therefore, the lifetime of an average user for 180 days would be 180 x 23%, approximately 41 days.

![](https://cdn-images-1.medium.com/max/800/1*F6OH2IvQnhHXpX5AMVRo7w.png)

It’s important to note that lifetime is always expressed in the same time units as the LTV period. For example, LTV over 180 days will deliver an expected lifetime of 41 days, not months or years.

**c. ARPU or average revenue per user**

How complex ARPU is to calculate will depend on the business model. It will be more straightforward in an SaaS business and more complex for hybrid models (where various business models such as subscriptions and advertising are combined).

A way to calculate ARPU would be to divide the total revenues for a period by the active users in that period. For example, average daily revenues of 10,000 USD divided by average daily active users of 25,000 would be equal to 0.4 USD/day.

I can now calculate the LTV for this example app. The lifetime for 180 days was approximately 41 days (23%) and ARPU 0.4 USD/day. Therefore:

**LTV for 180 days = 41 days x 0.4 USD/day = 16.4 USD per user.**

#### Improving LTV calculations

There are several techniques that can be combined with this simple LTV equation to improve its usefulness, these include:

* **Discount Revenue cash flows**. When the lifetime exceeds 1 year, consider discounting the future cash flows by taking an inflation rate (r) or the cost of funds (for example, working average capital cost rate — weighted average cost of capital) into consideration. For example, assuming a lifetime of n years, the discount formula could be expressed in the following way:

> LTV = Revs Year 1 + Revs Year 2 x 1/ (1+ r) + … + Revs Year n x 1 / (1+ r )^(n-1)

* **Calculate Net LTV**_._ By calculating the average Variable Contribution (VC) per user, and replacing the ARPU in the formula the Net LTV can be calculated. To estimate the VC, deduct the total variable costs from the total revenues. Variable costs will be those costs generated every time a new user is added to the app (such as marketing costs assigned to every new user). The formula would be as follows:

> Net LTV = Lifetime x VC

Whereby:

> VC = (Total Revenues — Total variable costs) in the period / average number of users in the period

It’s also important to note that savvy developers will usually segment customers depending on the level of VC and calculate LTV for different cohorts of customers. As is the case in many businesses, app developers will observe that a few users bring most revenue and profits.

The VC often changes over the life of a user, as variable costs tend to decline as a percentage of revenues. To illustrate, take a new user who has recently subscribed to a software service and needs more customer support during the onboarding process, then compare to an experienced customer who no longer requires support.

### Conclusion

Predictive analytics provides a practical way to gain insight into the future of your app: its customers and revenue. Among the many approaches to predictive analytics, Lifetime Value (LTV) is perhaps the one that has gained recent popularity among app developers. It can be relatively simple to calculate and provides a useful measure that can be applied to planning customer acquisition.

Now you have an appreciation of LTV, in my [second article](https://medium.com/googleplaydev/predicting-your-apps-future-65b741999e0e), I’ll examine how the LTV formula from this post can be applied to five popular app monetization strategies. At the same time, I’ll also offer some insights from developers about how to optimize each of these monetization strategies.

* * *

#### What do you think?

Do you have questions or thoughts on predictive analytics and LTV? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
