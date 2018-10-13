> * 原文地址：[Every single Machine Learning course on the internet, ranked by your reviews](https://medium.freecodecamp.org/every-single-machine-learning-course-on-the-internet-ranked-by-your-reviews-3c4a7b8026c0)
> * 原文作者：[David Venturi](https://medium.freecodecamp.org/@davidventuri?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/every-single-machine-learning-course-on-the-internet-ranked-by-your-reviews.md](https://github.com/xitu/gold-miner/blob/master/TODO1/every-single-machine-learning-course-on-the-internet-ranked-by-your-reviews.md)
> * 译者：[davelet](https://github.com/davelet)
> * 校对者：

# 基于评论的机器学习在线课程排名

![](https://cdn-images-1.medium.com/max/2000/1*vBLkfW8S-ZqHb8TmNEW1XA.jpeg)

_Kaboompics 的_[_木头人_](https://www.pexels.com/photo/wooden-robot-6069/)

一年半以前，我退出了加拿大最好的计算机科学课程之一，开始使用线上资源创建我自己的[数据科学研究生课程](https://medium.com/@davidventuri/i-dropped-out-of-school-to-create-my-own-data-science-master-s-here-s-my-curriculum-1b400dcee412#.5fwwphdqd)。我意识到只要通过edX、Coursera 和 Udacity 就能学到所有我需要的东西，而且学习得更快更高效，学费还比大学低！

现在我马上就完成了！我学习了很多数据科学相关的课程而且评估了更多课程的部分内容。我知道了如何选择，也知道了什么技能对于打算成为数据分析家或者数据科学家的学员是必需的。所以我之前开始创建一个评论驱动的用于推荐数据科学领域内各学科最好课程的指导。

在本系列的第一篇指导中我给刚入门的数据科学家们先推荐一些[编码课程](https://medium.freecodecamp.com/if-you-want-to-learn-data-science-start-with-one-of-these-programming-classes-fb694ffe780c#.42hhzxopw)，然后是[概率统计课程](https://medium.freecodecamp.com/if-you-want-to-learn-data-science-take-a-few-of-these-statistics-classes-9bbabab098b9#.p7pac546r)，然后是[数据科学概论](https://medium.freecodecamp.com/i-ranked-all-the-best-data-science-intro-courses-based-on-thousands-of-data-points-db5dc7e3eb8e)，还有[数据可视化](https://medium.freecodecamp.com/an-overview-of-every-data-visualization-course-on-the-internet-9ccf24ea9c9b)。

### 欢迎来到机器学习

我为了这篇指导花费了十几个小时尝试找出截至到 2017 年 5 月的所有在线课程，根据它们的简介和评论抽取关键信息并计算评分。**我最终的目标本来是找出最好的三门课程呈现出来以飨读者。**

为了实现这个目标，我特意到开源社区 Class Central，它的数据库中有数以千计的课程评分和留言。

![](https://cdn-images-1.medium.com/max/1000/1*u1dxHyShejSN3cgXGFQIAA.png)

_Class Central 的_[_主页_](https://www.class-central.com/).

自从 2011 年起，[Class Central](https://www.class-central.com/) 的创始人 [Dhawal Shah](https://medium.com/@dhawalhs) 就一直无可争议的是最贴近在线课程的研究者。Dhawal 个人也帮我一起收集了这个资源列表。

### 我们如何甄选课程

每一门课程都必须满足如下三条准则：

1.  **必须包含大量的机器学习内容**。原则上机器学习应该是首要主题。注意，只涉及深度学习的课程应该被排除，后面会详述。
2.  **必须按需或每隔几个月提供一次。**
3.  **必须是可交互的在线课程，不能使用书本或只读性质的指南**。尽管那些也是学习的途径，但是这里只关注课程。完全的视频教程（也就是说没有测验或课后作业等）也要排除。

我相信我们已经包含了所有符合上述准则值得关注的的课程。鉴于我们从 [Udemy](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14494&RD_PARM1=https%253A%252F%252Fwww.udemy.com%252F) 上面收集了几百门课程，我们只选择其中留言最多、评分最高的课程。

不过由于精力有限，一定还是有可能我们会忽略掉某课程的。如果你发现我们漏掉了一门好课程，请在评论区留言让我们知道。

### 我们如何评估课程

我们从 Class Central 以及其他点评网站汇集了每门课程的平均评分，以此来计算它们的加权平均分。我们阅读了文字评论，通过那些课程反馈来补充分数。

我们根据三个因素进行了教学大纲的主观判断:

1.  **对机器学习工作流程的解释程度**。课程是否描绘了成功运行一个 ML 工程的必要步骤？ 有关典型工作流程的含义，请参阅下一节。
2.  **对机器学习技术和算法的覆盖程度**。 是否涉及了各种技术（例如回归、分类、聚类等）和相关算法（比如分类算法：朴素贝叶斯、决策树、支持向量机等），还是只简单挑选了几个？我们优先考虑的课程覆盖得更多，而不是仅仅介绍梗概。
3.  **对通用数据科学和机器学习工具的使用程度**。课程教学上是否使用了流行的编程语言，比如 Python、R 或 Scala？对这些语言的流行类库使用如何？这些当然不是必需的但是是有用的，所以对这些课程我们略有偏好。

### 什么是机器学习？工作流程如何？

一个流行的定义起源于 1959 年 [Arthur Samuel](https://en.wikipedia.org/wiki/Arthur_Samuel "Arthur Samuel") 的说法： in 1959: 机器学习是计算机科学的一个分支，能够“_让计算机自主学习而无需显式编程_”。实践中，这意味着开发的计算机程序可以根据数据进行预测。就像人类可以根据经验学习一样，计算机也可以。对于计算机，数据 = 经验。


机器学习工作流程是执行机器学习项目所需的过程。尽管单个项目可能不同，但是绝大多数工作流程都需要这么几个通用任务：问题评估，数据探索，数据预处理，模型训练、测试、部署，等等。下面你会看到这些核心步骤有用的的可视化展示：

![](https://cdn-images-1.medium.com/max/1000/1*KzmIUYPmxgEHhXX7SlbP4w.jpeg)

[UpX Academy](https://upxacademy.com/introduction-machine-learning/) 提供的典型机器学习工作流程核心步骤

理想的课程能够介绍完整的过程并提供交互式的例子、课后作业、小测试，学员们能自己体验到每个任务。

### 这些课程包含了深度学习吗？

首先咱们来定义一下深度学习。简洁点的定义是：

> “深度学习是机器学习的一个分支，关注的是受大脑结构和功能启发的人工神经网络算法。”

> — Jason Brownlee，来自[掌握机器学习](http://machinelearningmastery.com/what-is-deep-learning/)

可能你希望这样，我们的课程正好有一些包含了深度学习的内容。但我是没有选择那些只包含深度学习的课程的。如果你就是对深度学习感兴趣，我们建议你学习一下下面的[文章](https://medium.freecodecamp.com/dive-into-deep-learning-with-these-23-online-courses-bf247d289cc0)：

* [在线 12 课深入理解深度学习：每天都有关于深度学习如何改变我们周围世界的头条。几个例子：](https://medium.freecodecamp.com/dive-into-deep-learning-with-these-23-online-courses-bf247d289cc0 "https://medium.freecodecamp.com/dive-into-deep-learning-with-these-23-online-courses-bf247d289cc0")

列表里面我最推荐的 TOP 3 是：

*   [**使用 TensorFlow 编写深度学习创意应用**](https://www.class-central.com/mooc/6679/kadenze-creative-applications-of-deep-learning-with-tensorflow)， _Kadenze_
*   [**用于机器学习的神经网络**](https://www.class-central.com/mooc/398/coursera-neural-networks-for-machine-learning)， _多伦多大学 (Geoffrey Hinton执教) 发布于 Coursera_
*   [**深度学习 A-Z™：手把手教你写人工神经网络**](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fdeeplearning%2F)， _Kirill Eremenko，Hadelin de Ponteves 和 SuperDataScience Team 发布于 Udemy_

### 推荐的先决条件

下面列出的一些课程要求学员有编程、微积分、线性代数和统计学经验。鉴于机器学习是一门高级学科，这些先决条件是可以理解的。

有些科目不懂？好消息！其中一些经验可以通过我们在头两篇关于“数据科学生涯指导”的推荐文章（[编程](https://medium.freecodecamp.com/if-you-want-to-learn-data-science-start-with-one-of-these-programming-classes-fb694ffe780c#.ld31z08y5), [统计学](https://medium.freecodecamp.com/if-you-want-to-learn-data-science-take-a-few-of-these-statistics-classes-9bbabab098b9)）中学习到。下面的几个顶级课程还提供了简单的微积分和线性代数复习，并着重突出了与那些不太熟悉的机器学习最相关的方面。

### 我们甄选的最佳机器学习课程是……

*   [机器学习](https://www.class-central.com/mooc/835/coursera-machine-learning)，斯坦福大学发布于 Coursera

斯坦福大学发布在 Coursera 的[机器学习](https://www.class-central.com/mooc/835/coursera-machine-learning)在评分、评论和大纲匹配上是目前最明确的赢家。课程由著名的 Andrew Ng 讲授，他是 Google 大脑的创始人，[百度](https://en.wikipedia.org/wiki/Baidu)的前首席科学家。这是引发 Coursera 成立的课程。它通过 422 条评论得到 4.7 星的加权平均得分。

这门课程发布于 2011 年，涵盖了机器学习工作流程的所有方面。尽管它比自身基于的最初的斯坦福大学课程范围小了一点，依然成功包含了大量的技术和算法。预估的时间线是 7 周，包扩两周的神经网络和深度学习。课程还提供了免费版和收费版两种选择。

Ng 是一位有活力而又温柔的导师，而且经验丰富。他激励自信，尤其是在分享实际实施技巧和常见陷阱警告的时候。他帮助学员复习线性代数并强调与机器学习最相关的微积分知识。


评估是自动的，通过每节课后的多项选择测验和编程作业完成。这些作业（一共有八次）可以使用 MATLAB 或 Octave 完成，后者是 MATLAB 的一个开源版本。Ng 常解释他对语言的选择：

> 以前我总是尝试使用各种不同的语言讲授机器学习，包括 C++、Java、Python、NumPy，当然还有 Octave，等等。在我教了十年机器学习之后我发现使用 Octave 做为编程环境会让你学得最快。

尽管 Python 和 R 在 2017 年有着[上升的人气](http://blog.codeeval.com/codeevalblog/2016/2/2/most-popular-coding-languages-of-2016)，似乎更引人注目，评论家们注意到那不应该阻止你学习这门课。

一些着名评论家注意到以下内容：

> 作为 MOOC 世界中长期以来的知名课程，斯坦福大学的机器学习确实是这一主题的权威介绍。该课程广泛涵盖了机器学习的所有主要领域。Ng 教授在每个部分之前都有激励性的讨论和例子。

> Andrew Ng 是一位有天赋的老师，能够以相当直观清晰的方式解释复杂主题，包括概念后面的数学原理。强烈推荐！

> 我看这门课的唯一问题是，它是否为其他课程设置了太高的期望值。

![](https://cdn-images-1.medium.com/max/800/1*viCB-ayFFQi-4Fs_NYLVVQ.png)

* YouTube 视频链接：https://youtu.be/e0WKJLovaZg

Andrew Ng 的 [机器学习](https://www.class-central.com/mooc/835/coursera-machine-learning)课程预览视频。

### 一门由杰出教授讲授的常春藤大学课程

*   [机器学习](https://www.class-central.com/mooc/7231/edx-machine-learning) （哥伦比亚大学发布于 edX ）

哥伦比亚大学的[机器学习](https://www.class-central.com/mooc/7231/edx-machine-learning)是他们发布在 edX 上的《人工智能微硕士》（ Artificial Intelligence MicroMasters ）课程的一个相当新的部分（_译者注：《微硕士》课程是由 edX 推出的一系列在线研究生课程，可以用来学习职业发展的独立技能或从各自大学获得研究生同等学力证书，相当于一个完整硕士学位的学期_）。 尽管它太新了还没有太多的评论，但是已有的评论却异常给力。授课教授 John Paisley 以杰出、授课简杰、聪明而闻名。这门课程通过它的10条评论加权平均得分 4.8 星。

这门课程覆盖了机器学习工作流程的全部方面，而且在算法上比上面的斯坦福课程还多。哥伦比亚的课程是更加高阶的入门课程，评论中有提到说学员需要很熟悉我们前面推荐的先决条件：微积分、线性代数、统计学、概率论和编程。

它的毕业评估由 11 次测验、4 次编程作业和期末考试组成。学员们可自行选择 Python、Octave 或 MATLAB 完成作业。课程的总预计时长是 12 周，每周 8 到 10 课时。 它是免费的，不过具有经过验证的学历证书可供购买。

下面是一些上面提到的高质量[评论](https://www.coursetalk.com/providers/edx/courses/machine-learning-5)：

> 在当学生的这些年，我经历了各种教授：不够杰出的教授、自身杰出但是授课能力一般的教授、杰出而又擅长授课的教授。Paisley 博士就属于第三种。

> 这门课太棒了！老师的语言太精准了，在我看来这也是这门课最突出的亮点之一。课程质量很高，PPT 也超棒。

> Paisley 博士和他的导师都是机器学习之父迈克尔·乔丹的学生。 Paisley 博士因为授课清晰成为哥伦比亚大学最好的 ML 教授。这个学期有将近 240 个学生选他的课，这个数字是哥伦比亚大学所有讲授机器学习的教授中最大的。

![](https://cdn-images-1.medium.com/max/800/1*q4Qa-kxC6MXFwct_9635ug.png)

* YouTube 视频链接：https://youtu.be/mANw77caYSI

哥伦比亚大学发布于 edX 的《微硕士》课程预览视频。[机器学习](https://www.class-central.com/mooc/7231/edx-machine-learning)课程简介开始于大约 1:00。

### 来自工业专家的 Python 和 R 实用简介

*   [机器学习 A-Z™：手把手教你用 Python 和 R 实战数据科学](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fmachinelearning%2F) （Kirill Eremenko，Hadelin de Ponteves 和 SuperDataScience Team 发布于 Udemy）

发布于 Udemy 的[机器学习 A-Z™](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fmachinelearning%2F) 是一门同时介绍了 Python 和 R 的无孔不入般详细的课程。这是罕见的，其他任何顶级课程也不会有这种评价。它的评论数是在我们推荐课程中最高的，高达 8119 条，得到 4.5 星的加权平均得分。

它覆盖了全部的机器学习工作流程，还通过 40.5 小时的按需视频教程提供了数量近乎荒谬（好的那种）的算法讲解。这门课比上面两门课更实用，数学要求也低。每个部分都以 Eremenko 的“直觉”视频开始，视频中总结了将被讲授的概念中的重要理论。然后 de Ponteves 会通过一些分开的视频讲述如何通过 Python 和 R 实现出来。

一个“加分项”是这门课程包含了 Python 和 R 的代码模版供学员下载以便在他们自己的项目中使用。课程也提供了测验和家庭作业挑战，不过不是这门课程的有理得分点。

Eremenko 和 SuperDataScience team 最受学员爱戴的是他们有能力“把复杂的事情搞简单”。此外，这门课程先决条件的要求也“只是一些高中数学”，所以对于被斯坦福和哥伦比亚课程难倒的学员可能是较好的选择。

一些突出的评论者[强调了](https://www.udemy.com/machinelearning/#reviews)以下内容：

> 这门课是专业出品，音质棒极了，释义也特别简洁清晰。你财力和时间的投资绝对有难以估量的回报。

> 在一门课中同时用两种语言学习简直太壮观了.

> Kirill 是 Udemy 上绝对最好的老师之一（如果不是在网上），我推荐他讲的所有课程。这门课有丰富的内容，丰富到爆！

![](https://cdn-images-1.medium.com/max/800/1*gl_KL2hhIkodQpznSzu8ZA.png)

* YouTube 视频链接：https://youtu.be/JbuYJTbmYEk

[机器学习 A-Z™](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fmachinelearning%2F)的预览视频。

### 比拼

Our #1 pick had a weighted average rating of 4.7 out of 5 stars over 422 reviews. Let’s look at the other alternatives, sorted by descending rating. A reminder that deep learning-only courses are not included in this guide — you can find those [here](https://medium.freecodecamp.com/dive-into-deep-learning-with-these-23-online-courses-bf247d289cc0).

[The Analytics Edge](https://www.class-central.com/mooc/1623/edx-the-analytics-edge) (Massachusetts Institute of Technology/edX): More focused on analytics in general, though it does cover several machine learning topics. Uses R. Strong narrative that leverages familiar real-world examples. Challenging. Ten to fifteen hours per week over twelve weeks. Free with a verified certificate available for purchase. It has a 4.9-star weighted average rating over 214 reviews.

* YouTube 视频链接：https://youtu.be/1BMSOBCe07k

The promo video for the fantastic MIT course on edx, [The Analytics Edge](https://www.class-central.com/mooc/1623/edx-the-analytics-edge).

[Python for Data Science and Machine Learning Bootcamp](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fpython-for-data-science-and-machine-learning-bootcamp%2F) (Jose Portilla/Udemy): Has large chunks of machine learning content, but covers the whole data science process. More of a very detailed intro to Python. Amazing course, though not ideal for the scope of this guide. 21.5 hours of on-demand video. Cost varies depending on Udemy discounts, which are frequent. It has a 4.6-star weighted average rating over 3316 reviews.

[Data Science and Machine Learning Bootcamp with R](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fdata-science-and-machine-learning-bootcamp-with-r%2F) (Jose Portilla/Udemy): The comments for Portilla’s above course apply here as well, except for R. 17.5 hours of on-demand video. Cost varies depending on Udemy discounts, which are frequent. It has a 4.6-star weighted average rating over 1317 reviews.

[Machine Learning Series](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fuser%2Flazy-programmer%2F) (Lazy Programmer Inc./Udemy): Taught by a data scientist/big data engineer/full stack software engineer with an impressive resume, Lazy Programmer currently has a series of 16 machine learning-focused courses on Udemy. In total, the courses have 5000+ ratings and almost all of them have 4.6 stars. A useful course ordering is provided in each individual course’s description. Uses Python. Cost varies depending on Udemy discounts, which are frequent.

[Machine Learning](https://www.class-central.com/mooc/1020/udacity-machine-learning) (Georgia Tech/Udacity): A compilation of what was three separate courses: Supervised, Unsupervised and Reinforcement Learning. Part of Udacity’s Machine Learning Engineer Nanodegree and Georgia Tech’s Online Master’s Degree (OMS). Bite-sized videos, as is Udacity’s style. Friendly professors. Estimated timeline of four months. Free. It has a 4.56-star weighted average rating over 9 reviews.

[Implementing Predictive Analytics with Spark in Azure HDInsight](https://www.class-central.com/mooc/4151/edx-implementing-predictive-analytics-with-spark-in-azure-hdinsight) (Microsoft/edX): Introduces the core concepts of machine learning and a variety of algorithms. Leverages several big data-friendly tools, including Apache Spark, Scala, and Hadoop. Uses both Python and R. Four hours per week over six weeks. Free with a verified certificate available for purchase. It has a 4.5-star weighted average rating over 6 reviews.

[Data Science and Machine Learning with Python — Hands On!](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fdata-science-and-machine-learning-with-python-hands-on%2F) (Frank Kane/Udemy): Uses Python. Kane has nine years of experience at Amazon and IMDb. Nine hours of on-demand video. Cost varies depending on Udemy discounts, which are frequent. It has a 4.5-star weighted average rating over 4139 reviews.

[Scala and Spark for Big Data and Machine Learning](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fscala-and-spark-for-big-data-and-machine-learning%2F) (Jose Portilla/Udemy): “Big data” focus, specifically on implementation in Scala and Spark. Ten hours of on-demand video. Cost varies depending on Udemy discounts, which are frequent. It has a 4.5-star weighted average rating over 607 reviews.

[Machine Learning Engineer Nanodegree](https://www.class-central.com/certificate/machine-learning-engineer-nanodegree--nd009) (Udacity): Udacity’s flagship Machine Learning program, which features a best-in-class project review system and career support. The program is a compilation of several individual Udacity courses, which are free. Co-created by Kaggle. Estimated timeline of six months. Currently costs $199 USD per month with a 50% tuition refund available for those who graduate within 12 months. It has a 4.5-star weighted average rating over 2 reviews.

[Learning From Data (Introductory Machine Learning)](https://www.class-central.com/mooc/1240/edx-learning-from-data-introductory-machine-learning) (California Institute of Technology/edX): Enrollment is currently closed on edX, but is also available via CalTech’s independent platform (see below). It has a 4.49-star weighted average rating over 42 reviews.

* YouTube 视频链接：https://youtu.be/KlP0DpiM7Lw

The intro video for Caltech and Yaser Abu-Mostafa’s [Learning From Data](https://www.class-central.com/mooc/366/learning-from-data-introductory-machine-learning-course).

[Learning From Data (Introductory Machine Learning)](https://www.class-central.com/mooc/366/learning-from-data-introductory-machine-learning-course) (Yaser Abu-Mostafa/California Institute of Technology): “A real Caltech course, not a watered-down version.” Reviews note it is excellent for understanding machine learning theory. The professor, Yaser Abu-Mostafa, is popular among students and also wrote the textbook upon which this course is based. Videos are taped lectures (with lectures slides picture-in-picture) uploaded to YouTube. Homework assignments are .pdf files. The course experience for online students isn’t as polished as the top three recommendations. It has a 4.43-star weighted average rating over 7 reviews.

[Mining Massive Datasets](https://www.class-central.com/mooc/2406/stanford-openedx-mining-massive-datasets) (Stanford University): Machine learning with a focus on “big data.” Introduces modern distributed file systems and MapReduce. Ten hours per week over seven weeks. Free. It has a 4.4-star weighted average rating over 30 reviews.

[AWS Machine Learning: A Complete Guide With Python](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Faws-machine-learning-a-complete-guide-with-python%2F) (Chandra Lingam/Udemy): A unique focus on cloud-based machine learning and specifically Amazon Web Services. Uses Python. Nine hours of on-demand video. Cost varies depending on Udemy discounts, which are frequent. It has a 4.4-star weighted average rating over 62 reviews.

[Introduction to Machine Learning & Face Detection in Python](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Fintroduction-to-machine-learning-in-python%2F) (Holczer Balazs/Udemy): Uses Python. Eight hours of on-demand video. Cost varies depending on Udemy discounts, which are frequent. It has a 4.4-star weighted average rating over 162 reviews.

[StatLearning: Statistical Learning](https://www.class-central.com/mooc/1579/stanford-openedx-statlearning-statistical-learning) (Stanford University): Based on the excellent textbook, “[An Introduction to Statistical Learning, with Applications in R](https://www.amazon.com/Introduction-Statistical-Learning-Applications-Statistics-ebook/dp/B01IBM7790)” and taught by the professors who wrote it. Reviewers note that the MOOC isn’t as good as the book, citing “thin” exercises and mediocre videos. Five hours per week over nine weeks. Free. It has a 4.35-star weighted average rating over 84 reviews.

[Machine Learning Specialization](https://www.class-central.com/certificate/machine-learning-specialization) (University of Washington/Coursera): Great courses, but last two classes (including the capstone project) were canceled. Reviewers note that this series is more digestable (read: easier for those without strong technical backgrounds) than other top machine learning courses (e.g. Stanford’s or Caltech’s). Be aware that the series is incomplete with recommender systems, deep learning, and a summary missing. Free and paid options available. It has a 4.31-star weighted average rating over 80 reviews.

![](https://cdn-images-1.medium.com/max/1000/1*fgFqV9nyUKHi7txzgKcW4w.png)

The University of Washington teaches the [Machine Learning Specialization](https://www.class-central.com/certificate/machine-learning-specialization) on Coursera.

[From 0 to 1: Machine Learning, NLP & Python-Cut to the Chase](https://click.linksynergy.com/fs-bin/click?id=SAyYsTvLiGQ&subid=&offerid=323058.1&type=10&u1=medium-career-guide-machine-learning&tmpid=14538&RD_PARM1=https%3A%2F%2Fwww.udemy.com%2Ffrom-0-1-machine-learning%2F) (Loony Corn/Udemy): “A down-to-earth, shy but confident take on machine learning techniques.” Taught by four-person team with decades of industry experience together. Uses Python. Cost varies depending on Udemy discounts, which are frequent. It has a 4.2-star weighted average rating over 494 reviews.

[Principles of Machine Learning](https://www.class-central.com/mooc/6511/edx-principles-of-machine-learning) (Microsoft/edX): Uses R, Python, and Microsoft Azure Machine Learning. Part of the Microsoft Professional Program Certificate in Data Science. Three to four hours per week over six weeks. Free with a verified certificate available for purchase. It has a 4.09-star weighted average rating over 11 reviews.

[Big Data: Statistical Inference and Machine Learning](https://www.class-central.com/mooc/5421/futurelearn-big-data-statistical-inference-and-machine-learning) (Queensland University of Technology/FutureLearn): A nice, brief exploratory machine learning course with a focus on big data. Covers a few tools like R, H2O Flow, and WEKA. Only three weeks in duration at a recommended two hours per week, but one reviewer noted that six hours per week would be more appropriate. Free and paid options available. It has a 4-star weighted average rating over 4 reviews.

[Genomic Data Science and Clustering](https://www.class-central.com/mooc/3556/coursera-genomic-data-science-and-clustering-bioinformatics-v) (Bioinformatics V) (University of California, San Diego/Coursera): For those interested in the intersection of computer science and biology and how it represents an important frontier in modern science. Focuses on clustering and dimensionality reduction. Part of UCSD’s Bioinformatics Specialization. Free and paid options available. It has a 4-star weighted average rating over 3 reviews.

[Intro to Machine Learning](https://www.class-central.com/mooc/2996/udacity-intro-to-machine-learning) (Udacity): Prioritizes topic breadth and practical tools (in Python) over depth and theory. The instructors, Sebastian Thrun and Katie Malone, make this class so fun. Consists of bite-sized videos and quizzes followed by a mini-project for each lesson. Currently part of Udacity’s Data Analyst Nanodegree. Estimated timeline of ten weeks. Free. It has a 3.95-star weighted average rating over 19 reviews.

* YouTube 视频链接：https://youtu.be/lL16AQItG1g

An intro video for Udacity’s [Intro to Machine Learning](https://www.class-central.com/mooc/2996/udacity-intro-to-machine-learning) with Sebastian Thrun and Katie Malone.

[Machine Learning for Data Analysis](https://www.class-central.com/mooc/4354/coursera-machine-learning-for-data-analysis) (Wesleyan University/Coursera): A brief intro machine learning and a few select algorithms. Covers decision trees, random forests, lasso regression, and k-means clustering. Part of Wesleyan’s Data Analysis and Interpretation Specialization. Estimated timeline of four weeks. Free and paid options available. It has a 3.6-star weighted average rating over 5 reviews.

[Programming with Python for Data Science](https://www.class-central.com/mooc/6471/edx-programming-with-python-for-data-science) (Microsoft/edX): Produced by Microsoft in partnership with Coding Dojo. Uses Python. Eight hours per week over six weeks. Free and paid options available. It has a 3.46-star weighted average rating over 37 reviews.

[Machine Learning for Trading](https://www.class-central.com/mooc/1026/udacity-machine-learning-for-trading) (Georgia Tech/Udacity): Focuses on applying probabilistic machine learning approaches to trading decisions. Uses Python. Part of Udacity’s Machine Learning Engineer Nanodegree and Georgia Tech’s Online Master’s Degree (OMS). Estimated timeline of four months. Free. It has a 3.29-star weighted average rating over 14 reviews.

[Practical Machine Learning](https://www.class-central.com/mooc/1719/coursera-practical-machine-learning) (Johns Hopkins University/Coursera): A brief, practical introduction to a number of machine learning algorithms. Several one/two-star reviews expressing a variety of concerns. Part of JHU’s Data Science Specialization. Four to nine hours per week over four weeks. Free and paid options available. It has a 3.11-star weighted average rating over 37 reviews.

[Machine Learning for Data Science and Analytics](https://www.class-central.com/mooc/4912/edx-machine-learning-for-data-science-and-analytics) (Columbia University/edX): Introduces a wide range of machine learning topics. Some passionate negative reviews with concerns including content choices, a lack of programming assignments, and uninspiring presentation. Seven to ten hours per week over five weeks. Free with a verified certificate available for purchase. It has a 2.74-star weighted average rating over 36 reviews.

[Recommender Systems Specialization](https://www.coursera.org/specializations/recommender-systems) (University of Minnesota/Coursera): Strong focus one specific type of machine learning — recommender systems. A four course specialization plus a capstone project, which is a case study. Taught using LensKit (an open-source toolkit for recommender systems). Free and paid options available. It has a 2-star weighted average rating over 2 reviews.

[Machine Learning With Big Data](https://www.class-central.com/mooc/4238/coursera-machine-learning-with-big-data) (University of California, San Diego/Coursera): Terrible reviews that highlight poor instruction and evaluation. Some noted it took them mere hours to complete the whole course. Part of UCSD’s Big Data Specialization. Free and paid options available. It has a 1.86-star weighted average rating over 14 reviews.

[Practical Predictive Analytics: Models and Methods](https://www.class-central.com/mooc/4341/coursera-practical-predictive-analytics-models-and-methods) (University of Washington/Coursera): A brief intro to core machine learning concepts. One reviewer noted that there was a lack of quizzes and that the assignments were not challenging. Part of UW’s Data Science at Scale Specialization. Six to eight hours per week over four weeks. Free and paid options available. It has a 1.75-star weighted average rating over 4 reviews.

The following courses had one or no reviews as of May 2017.

[Machine Learning for Musicians and Artists](https://www.class-central.com/mooc/3768/kadenze-machine-learning-for-musicians-and-artists) (Goldsmiths, University of London/Kadenze): Unique. Students learn algorithms, software tools, and machine learning best practices to make sense of human gesture, musical audio, and other real-time data. Seven sessions in length. Audit (free) and premium ($10 USD per month) options available. It has one 5-star review.

* YouTube 视频链接：https://youtu.be/pSnRmBt0pXI

The promo video for Goldsmiths, University of London’s [Machine Learning for Musicians and Artists](https://www.class-central.com/mooc/3768/kadenze-machine-learning-for-musicians-and-artists) on Kadenze.

[Applied Machine Learning in Python](https://www.class-central.com/mooc/6673/coursera-applied-machine-learning-in-python) (University of Michigan/Coursera): Taught using Python and the scikit learn toolkit. Part of the Applied Data Science with Python Specialization. Scheduled to start May 29th. Free and paid options available.

[Applied Machine Learning](https://www.class-central.com/mooc/6406/edx-applied-machine-learning) (Microsoft/edX): Taught using various tools, including Python, R, and Microsoft Azure Machine Learning (note: Microsoft produces the course). Includes hands-on labs to reinforce the lecture content. Three to four hours per week over six weeks. Free with a verified certificate available for purchase.

[Machine Learning with Python](https://bigdatauniversity.com/courses/machine-learning-with-python/) (Big Data University): Taught using Python. Targeted towards beginners. Estimated completion time of four hours. Big Data University is affiliated with IBM. Free.

[Machine Learning with Apache SystemML](https://bigdatauniversity.com/courses/machine-learning-apache-systemml/) (Big Data University): Taught using Apache SystemML, which is a declarative style language designed for large-scale machine learning. Estimated completion time of eight hours. Big Data University is affiliated with IBM. Free.

[Machine Learning for Data Science](https://www.class-central.com/mooc/8216/edx-machine-learning-for-data-science) (University of California, San Diego/edX): Doesn’t launch until January 2018. Programming examples and assignments are in Python, using Jupyter notebooks. Eight hours per week over ten weeks. Free with a verified certificate available for purchase.

[Introduction to Analytics Modeling](https://www.class-central.com/mooc/8217/edx-introduction-to-analytics-modeling) (Georgia Tech/edX): The course advertises R as its primary programming tool. Five to ten hours per week over ten weeks. Free with a verified certificate available for purchase.

[Predictive Analytics: Gaining Insights from Big Data](https://www.class-central.com/mooc/7645/futurelearn-predictive-analytics-gaining-insights-from-big-data) (Queensland University of Technology/FutureLearn): Brief overview of a few algorithms. Uses Hewlett Packard Enterprise’s Vertica Analytics platform as an applied tool. Start date to be announced. Two hours per week over four weeks. Free with a Certificate of Achievement available for purchase.

[Introducción al Machine Learning](https://miriadax.net/web/introduccion-al-machine-learning) (Universitas Telefónica/Miríada X): Taught in Spanish. An introduction to machine learning that covers supervised and unsupervised learning. A total of twenty estimated hours over four weeks.

[Machine Learning Path Step](https://www.dataquest.io/path-step/machine-learning) (Dataquest): Taught in Python using Dataquest’s interactive in-browser platform. Multiple guided projects and a “plus” project where you build your own machine learning system using your own data. Subscription required.

* * *

The following six courses are offered by [DataCamp](https://www.datacamp.com/courses/topic:machine_learning?tap_a=5644-dce66f&tap_s=93618-a68c98). DataCamp’s hybrid teaching style leverages video and text-based instruction with lots of examples through an in-browser code editor. A subscription is required for full access to each course.

![](https://cdn-images-1.medium.com/max/1000/1*eRUPgszpDHzEUpvXhFMeUg.png)

[DataCamp](https://www.datacamp.com/courses/topic:machine_learning?tap_a=5644-dce66f&tap_s=93618-a68c98) offers several machine learning courses.

[Introduction to Machine Learning](https://www.datacamp.com/courses/introduction-to-machine-learning-with-r?tap_a=5644-dce66f&tap_s=93618-a68c98) (DataCamp): Covers classification, regression, and clustering algorithms. Uses R. Fifteen videos and 81 exercises with an estimated timeline of six hours.

[Supervised Learning with scikit-learn](https://www.datacamp.com/courses/supervised-learning-with-scikit-learn?tap_a=5644-dce66f&tap_s=93618-a68c98) (DataCamp): Uses Python and scikit-learn. Covers classification and regression algorithms. Seventeen videos and 54 exercises with an estimated timeline of four hours.

[Unsupervised Learning in R](https://www.datacamp.com/courses/unsupervised-learning-in-r?tap_a=5644-dce66f&tap_s=93618-a68c98) (DataCamp): Provides a basic introduction to clustering and dimensionality reduction in R. Sixteen videos and 49 exercises with an estimated timeline of four hours.

[Machine Learning Toolbox](https://www.datacamp.com/courses/machine-learning-toolbox?tap_a=5644-dce66f&tap_s=93618-a68c98) (DataCamp): Teaches the “big ideas” in machine learning. Uses R. 24 videos and 88 exercises with an estimated timeline of four hours.

[Machine Learning with the Experts: School Budgets](https://www.datacamp.com/courses/machine-learning-with-the-experts-school-budgets?tap_a=5644-dce66f&tap_s=93618-a68c98) (DataCamp): A case study from a machine learning competition on DrivenData. Involves building a model to automatically classify items in a school’s budget. DataCamp’s “Supervised Learning with scikit-learn” is a prerequisite. Fifteen videos and 51 exercises with an estimated timeline of four hours.

[Unsupervised Learning in Python](https://www.datacamp.com/courses/unsupervised-learning-in-python?tap_a=5644-dce66f&tap_s=93618-a68c98) (DataCamp): Covers a variety of unsupervised learning algorithms using Python, scikit-learn, and scipy. The course ends with students building a recommender system to recommend popular musical artists. Thirteen videos and 52 exercises with an estimated timeline of four hours.

* * *

[Machine Learning](http://www.cs.cmu.edu/~ninamf/courses/601sp15/index.html) (Tom Mitchell/Carnegie Mellon University): Carnegie Mellon’s graduate introductory machine learning course. A prerequisite to their second graduate level course, “Statistical Machine Learning.” Taped university lectures with practice problems, homework assignments, and a midterm (all with solutions) posted online. A [2011 version](http://www.cs.cmu.edu/~tom/10701_sp11/) of the course also exists. CMU is one of the best graduate schools for studying machine learning and has a whole department dedicated to ML. Free.

[Statistical Machine Learning](https://www.class-central.com/mooc/8509/statistical-machine-learning) (Larry Wasserman/Carnegie Mellon University): Likely the most advanced course in this guide. A follow-up to Carnegie Mellon’s Machine Learning course. Taped university lectures with practice problems, homework assignments, and a midterm (all with solutions) posted online. Free.

![](https://cdn-images-1.medium.com/max/1000/1*umqMeqC5Ch-kR1i4hPBTrw.png)

CMU is one of the best grad schools for studying machine learning. [Machine Learning](http://www.cs.cmu.edu/~ninamf/courses/601sp15/index.html) and [Statistical Machine Learning](https://www.class-central.com/mooc/8509/statistical-machine-learning) are available online for free.

[Undergraduate Machine Learning](http://www.cs.ubc.ca/~nando/340-2012/index.php) (Nando de Freitas/University of British Columbia): An undergraduate machine learning course. Lectures are filmed and put on YouTube with the slides posted on the course website. The course assignments are posted as well (no solutions, though). de Freitas is now a full-time professor at the University of Oxford and receives praise for his teaching abilities in various forums. Graduate version available (see below).

[Machine Learning](http://www.cs.ubc.ca/~nando/540-2013/lectures.html) (Nando de Freitas/University of British Columbia): A graduate machine learning course. The comments in de Freitas’ undergraduate course (above) apply here as well.

### Wrapping it Up

This is the fifth of a six-piece series that covers the best online courses for launching yourself into the data science field. We covered programming in the [first article](https://medium.freecodecamp.com/if-you-want-to-learn-data-science-start-with-one-of-these-programming-classes-fb694ffe780c#.fhrn45v3c), statistics and probability in the [second article](https://medium.freecodecamp.com/if-you-want-to-learn-data-science-take-a-few-of-these-statistics-classes-9bbabab098b9#.p7pac546r), intros to data science in the [third article](https://medium.freecodecamp.com/i-ranked-all-the-best-data-science-intro-courses-based-on-thousands-of-data-points-db5dc7e3eb8e), and data visualization in the [fourth](https://medium.freecodecamp.com/an-overview-of-every-data-visualization-course-on-the-internet-9ccf24ea9c9b).

* [**I ranked every Intro to Data Science course on the internet, based on thousands of data points**: A year ago, I dropped out of one of the best computer science programs in Canada.](https://medium.freecodecamp.com/i-ranked-all-the-best-data-science-intro-courses-based-on-thousands-of-data-points-db5dc7e3eb8e "https://medium.freecodecamp.com/i-ranked-all-the-best-data-science-intro-courses-based-on-thousands-of-data-points-db5dc7e3eb8e")

The final piece will be a summary of those articles, plus the best online courses for other key topics such as data wrangling, databases, and even software engineering.

If you’re looking for a complete list of Data Science online courses, you can find them on Class Central’s [Data Science and Big Data](https://www.class-central.com/subject/data-science) subject page.

If you enjoyed reading this, check out some of [Class Central](https://www.class-central.com/)’s other pieces:

* [**Here are 250 Ivy League courses you can take online right now for free**: 250 MOOCs from Brown, Columbia, Cornell, Dartmouth, Harvard, Penn, Princeton, and Yale.](https://medium.freecodecamp.com/ivy-league-free-online-courses-a0d7ae675869 "https://medium.freecodecamp.com/ivy-league-free-online-courses-a0d7ae675869")

* [**The 50 best free online university courses according to data**: When I launched Class Central back in November 2011, there were around 18 or so free online courses, and almost all of…](https://medium.freecodecamp.com/the-data-dont-lie-here-are-the-50-best-free-online-university-courses-of-all-time-b2d9a64edfac "https://medium.freecodecamp.com/the-data-dont-lie-here-are-the-50-best-free-online-university-courses-of-all-time-b2d9a64edfac")

If you have suggestions for courses I missed, let me know in the responses!

If you found this helpful, click the 💚 so more people will see it here on Medium.

_This is a condensed version of my_ [_original article_](https://www.class-central.com/report/best-machine-learning-courses/) _published on Class Central, where I’ve included detailed course syllabi._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
