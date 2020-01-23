> * 原文地址：[The Algorithm Is Not The Product](https://towardsdatascience.com/the-algorithm-is-not-the-product-2e0b3740bdfa)
> * 原文作者：[Ori Cohen](https://medium.com/@cohenori)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-algorithm-is-not-the-product.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-algorithm-is-not-the-product.md)
> * 译者：
> * 校对者：

# The Algorithm Is Not The Product

## Why I think data-scientists should learn more about making good products

![A man looking at a whiteboard, [pixabay](https://pixabay.com/photos/startup-whiteboard-room-indoors-3267505/).](https://cdn-images-1.medium.com/max/2000/0*9aCTQ8j7DiGTAZjj.jpg)

One of the first lessons I learned in the industry, is that even though we build highly complex algorithms designed to solve a specific problem, these tools need to be used by a client. Whether internal or external, the client needs a lot more than a finely constructed, packaged, and deployed piece of code.

In other words, the product is more than just an algorithm, it’s a whole system that allows your users to get great value from it. Building a product that has an algorithm at its core is not an easy task, its a collaboration of work between many teams such as product managers, developers, researchers, data engineers, DevOps, ui\ux, etc..

Building a product relies on research methodology, you iteratively hypothesis (based on apriori or posteriori knowledge), measure, deduce insights and tweak the product until it’s you reach product-market-fit. It’s an endless battle against the unknown, where nothing is promised, except the process. The better the process, the better your chances are to get to end up with a good product.

**However, we tend to forget that.**

The following are several points, out of many, that should be emphasized, i.e., situations in which we need to place an importance on the product in addition to data-science considerations.

## The interview

When Interviewing a new data-scientist, we usually ask about past research, algorithms, methodologies and introduce an unseen hands-on research question that the candidate needs to solve.

As hiring managers we should really think about asking product related questions from the DS point-of-view, we should look at home assignments and ask relevant questions about why the candidate made certain data- or algorithmic-decisions in relation to the product. For example, asking about feature engineering choices that relate to the product problem. Decisions such as “why did they choose to include feature X over Y” or “why did they choose process feature Z in a certain manner”.

## The initial model

For many organizations, the first model that should hit production is the simplest algorithm, often described as a “rule-based” model or an ‘80–20’ model. The motivation to put such a basic model before diving into a research period is, usually, to allow developers, DevOps & other teams to create a supportive infrastructure for the new model, the DS will then work on a “real” model to replace the temporary stand-in.

Hearing about this idea from DS candidates or executing it by current DSs is highly important. It shows a deep understanding of an organization needs to be prepared ahead of time. It allows PMs to promote and push relevant tasks in parallel, allows us to be more agile, and it encourages product-understanding from non-product people.

## Model decisions

There are considerations that should be presented by candidates or practiced by your DSs. Training an algorithm with **balance=true**, in order to regularize an imbalanced dataset, is a product decision that should be decided by the data scientists. He should ask the product manager if these classes equally important for the problem at hand, or do we want to perform better in the bigger classes?

These sort of questions are the important questions that we should also ask the candidate during the interview process, immediately after asking him if he can describe all the methods he knows about balancing classes (oversampling, undersampling, loss regularization, synthetic data, etc..).
I also talk about it briefly [here](https://towardsdatascience.com/data-science-recruitment-why-you-may-be-doing-it-wrong-b8e9c7b6dae5).

## Collaboration with PMs

In our data-science (DS) world, we closely work with a product manager (PM) towards that coveted goal. We have many friction points with different teams, but the most important, is the one with the PM, as seen in Figure 1.

![Figure 1: a proposed flow for when working side by side with business and product](https://cdn-images-1.medium.com/max/3010/0*dboBm1rJIqrZ7Sla.png)

Consider a business-product (BP) KPI that needs to be reached or optimized and a data-scientists that needs to find the proper DS-KPI, which serves the BP-KPI to its fullest. This is one of our biggest challenges and is often overlooked by all stakeholders. The following diagram (Figure 1) shows a workflow that allows for iterative research in order to optimize both types of KPIs, allowing collaboration with Business, Product and Data Science.
You can read more about [my method of managing this friction point here](https://towardsdatascience.com/why-business-product-should-always-define-kpis-goals-for-data-science-450404392990).

## Don’t fall in love with your algorithm

We work tediously on perfecting our algorithms, making sure that they optimize properly, however, many times over it happens that someone in the system has changed their mind or didn't research the market properly and the algorithm you built to serve a certain function is not needed or doesn't perform as expected. A common mistake is to push for, try to fix or repurpose the algorithm. However, its probably more advisable to let go and start from scratch with a new algorithm, based on new product requirements. This releases you from previous constraints and is good strategically for your team within the organization.

---

I hope that these ideas will allow professional DSs to explore more about product management when starting a new project or adding new features to a product, to be more agile and hopefully aid the complex relations between business managers, product managers, data scientists, and researchers.

I would like to thank my fellow colleagues, [Natanel Davidovits](https://towardsdatascience.com/@ndor123) and [Sefi Keller](https://medium.com/@sefikeller) for reviewing this post.

---

Dr. Ori Cohen has a Ph.D. in Computer Science with a focus on machine-learning. He is a lead data-science researcher at New Relic TLV, practicing machine and deep learning research in the field of AIOps.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
