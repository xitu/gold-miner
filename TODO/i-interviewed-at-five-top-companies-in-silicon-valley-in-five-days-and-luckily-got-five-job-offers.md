> * 原文地址：[I interviewed at five top companies in Silicon Valley in five days, and luckily got five job offers](https://medium.com/@XiaohanZeng/i-interviewed-at-five-top-companies-in-silicon-valley-in-five-days-and-luckily-got-five-job-offers-25178cf74e0f)
> * 原文作者：[Xiaohan Zeng](https://medium.com/@XiaohanZeng?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/i-interviewed-at-five-top-companies-in-silicon-valley-in-five-days-and-luckily-got-five-job-offers.md](https://github.com/xitu/gold-miner/blob/master/TODO/i-interviewed-at-five-top-companies-in-silicon-valley-in-five-days-and-luckily-got-five-job-offers.md)
> * 译者：[Rambo Zhu](https://github.com/freerambo)
> * 校对者：[hadeswith666](https://github.com/hadeswith666)，[Germxu](https://github.com/Germxu)   


# 我的硅谷之路-五天拿下五家顶级互联网公司 offer

![](https://cdn-images-1.medium.com/max/800/1*4IYF3JVZqF9GnuGzNgkSPA.png)

**从 2017 年 7 月 24 号到 28 号的五天，我面试了 LinkedIn ，Salesforce Einstein ，Google ，Airbnb 和 Facebook ，并拿到了全部五家公司的 offer 。**

这是一段神奇的经历，我很幸运因为我的努力得到了回报。于是我决定写点什么来讲述我是如何准备，面试的过程以及分享我对着五家公司的感受。


* * *


### **如何开始**

我在 Groupon 混了近三年了。 这是我的第一份工作，我一直在和很[牛逼的团队](http://www.builtinchicago.org/2017/07/14/data-science-engineering-Groupon)做着[了不起的项目](https://www.linkedin.com/feed/update/urn:li:activity:6324643825717481472)。
我们团队一直在做很酷的事情，在公司内部很有影响也发表了一些论文等等。
尽管我一直渴望学习更多但我觉得我的学习速率开始下降了。作为一名芝加哥的软件工程师，湾区的那么多伟大的公司总是强有力的诱惑着我。

人生短暂，职业生涯更短。在跟我的老婆交谈并得到她的全力支持后我决定采取行动开始了我职业生涯的第一次跳槽。


### **充分准备**


尽管我一直着迷机器学习的职位，可这些职位在上述五家公司的名称和面试流程有着些微的不同。其中三家的职位是机器学习工程师，Salesforce 是数据工程师，而 Airbnb 职位里则是普通的软件工程师。由此我不得不准备三个不同领域的知识：编码， 机器学习和系统设计。

我还有个全职的工作，这使我总共花费了两三月的时间准备。下面将给出我是如何准备这三个领域的。

#### 编码


尽管我也认同编码面试可能不是最好的方式来评估面试者的技能，但无可争辩的是没有比这更好的方法在短时间内来证明面试者是不是一个好的程序员。
在我看来，想要得到程序员的工作编码测试是不可避免 

我主要使用 LeetCode 和 Geeksforgeeks 来练习。  Hackerrank 和 Lintcode 也是不错的练习工具。
我花了几周的时间过了下常见的数据结构和算法。然后重点关注了我之前不熟悉的领域，最后做了一些常见问题的练习。因为时间所限通常一天我只做两题。


谈谈的一下想法，

1. 多练，这没有什么可说的
2. 尽可能覆盖不同类型的题，每个类型花时间搞透它。不要试图把 Leetcode 上所有题都刷完。我在 Leetcode 上刷了总共差不多 70 题，我觉得做得足够了。在我看来如果 70 道题还不行那只能说明你方法不对，就算刷 700 道题也没用
3. 刷最难的那些题，其余的就简单了
4. 如果一个题卡壳超过两小时，去查看别人的解决方案吧，再多花时间可能不值得的
5. 做出来后，和别人提交的答案对比一下。我就经常震惊于别人家孩子的那些充满智慧且优雅的解决方案，尤其是一行 Python 代码解决的问题娃儿们
6. 用你最熟悉的编程语言答题，并通俗易懂的解释给你的面试官


#### 系统设计

这个领域更多的和实际工作经验相关。许多问题会在系统设计面试中被问到，包括但不限于系统架构，面向对象设计，数据库设计，分布式系统设计，高扩展系统等。

有很多线上资源可以帮助我们练习。大部分时候我是通过阅读关于系统设计以及分布式系统设计面试的文章和一些设计案例的分析。下面我给出一些有用的资源供参考。
 
*   [http://blog.gainlo.co](http://blog.gainlo.co)
*   [http://horicky.blogspot.com](http://horicky.blogspot.com)
*   [https://www.hiredintech.com/classrooms/system-design/lesson/52](https://www.hiredintech.com/classrooms/system-design/lesson/52)
*   [http://www.lecloud.net/tagged/scalability](http://www.lecloud.net/tagged/scalability)
*   [http://tutorials.jenkov.com/software-architecture/index.html](http://tutorials.jenkov.com/software-architecture/index.html)
*   [http://highscalability.com/](http://highscalability.com/)


尽管系统设计面试涵盖很多主题，一些常用的套路可以帮助我们解决这些问题。

1.  首先要弄明白需求，然后在画出高层概要设计，最后列出实现细节。不要没弄清需求而上来就进入细节。
2.  没有完美的系统设计，要正确考虑实际需求

说了这么多，应对系统设计面试最好的方式还是坐下来实际设计一个系统，例如在你的日常工作中不要总做些表面工作，可以试着深入了解使用的工具，框架和第三方类库。
再比如你用 HBase ，与其简单的使用客户端执行些 DDL 和查询操作不如试着去搞懂它的整体架构，读写的流程，HBase 如何保证了强一致性，有哪些主要或细小的封装，系统是如何使用的 LRU 缓存和布隆过滤器来提升效率的。
你甚至可以去比较 HBase 和 Cassandra 在设计上的相同和不同之处。这样当你在被问到设计一个分布式 key-value 存储时，你就可以从容应对了。

许多博客也是好的知识来源如 Hacker Noon 以及一些公司的技术博客，还有很多开源项目的官方文档。
最重要的是保持谦虚和好奇心，像海绵一样吸收一切有用的知识。

#### 机器学习

机器学习面试通常分为两部分：理论和产品设计。

读一些机器学习相关的书籍是很有帮助的，除非你有机器学习研究的经验或者ML课程学的很好。比较经典的书如 《机器学习之路》，《模式识别》和《机器学习》都是非常不错的选择。如果你对特定领域感兴趣可以选择更多该领域的书籍。
 
要确保你懂得那些基本概念，例如偏差方差平衡，过度拟合，梯度下降，L1/L2 正则化，贝叶斯理论，集成学习，协同过滤，降维等。
熟悉常见的公式如贝叶斯方程和流行的推导模型，如逻辑回归和 SVM 。试着去实现以下简单模型如决策树和 K-means 聚类。
如果你放了一些模型在你的简历上，那务必确保你完全懂得并能给出这些模型的优缺点。 

关于机器学习的产品设计，懂得构建一个机器学习产品的一般过程，这里给出了我的做法。

1.  明确我们的目标：预测，推荐，分类和检索等
2.  找到适合的算法：监督 vs. 非监督、分类 vs. 回归、一般线性模型、决策树、神经网络等。并要能够给出选择的理由。
3.  找出可用数据的相关特征
4.  给出模型的性能指标
5.  评价在实际项目应用中如何优化上如模型（可选择的）

这里我想再次强调保持好奇心和持续学习。不要仅仅是调用 Spark MLlib 或者 XGBoost 的 API ，
要试着去弄懂背后的原理。例如为什么随机梯度下降适合于分布式训练，
为什么 XGBoost 与传统的 GBDT 不同，它的损失函数有何特殊之处，为什么它需要计算二阶导数等等。

### 面试流程

从回复 Linkedin 上 HR 的消息和寻求推荐开始。在尝试一次申请某明星创业公司失败后（后文中我会谈到），
我开始了几个月的艰苦准备。在招聘人员的帮助下，我安排了在湾区一周的现场面试。
我周日飞往硅谷，这样我有五天时间和世界上那些最牛的技术公司进行约 30 场面试。
非常幸运地是，我拿到了他们中的五家公司的录用通知。


#### 电话面试

电话面试是这些公司的标配，不同的是面试时长。一些公司如 LInkedin 要一个小时，而 Facebook 和 Airbnb 则是 45 分钟。



专业性是电面关键。因为你只有的有限的时间而且通常只有一次机会。你必须要很快的识别出问题的类型并给出高水平的解决方案。
要确保告诉面试官你的想法和意图，在一开始这可能会降低你的速度，但沟通是面试中最重要的也是最有帮助的。不要背诵你的答案这很容易让面试官看穿。 


对于机器学习岗位有些公司会问 ML 的问题，如果你被面试这些确保你准备好了这些技能点。

为了更好的利用我的时间，我在同一下午安排了三个电话面试，每个间隔一小时。
这样的好处是我一直处于手热的状态，不好的地方是如果第一个没发挥好可能会影响接下来的表现。所以我不推荐大家都这么做。



同时面试多家公司的一个好处会给你带来一定的优势。一次电面以后我就成功的跳过了 Airbnb 和 Salesforce 的第二轮电面因为我已经获得了 LInkedin 和 Facebook 的现场面试


更让人惊喜的是 Google 在得知我下周有四个现场面试后竟然让我跳过了他们的电面直接安排我现场面试。我知道这将使我非常劳累，不过没有人能够拒绝 Google 的现场邀请。

#### 现场面试

**LinkedIn**

![](https://cdn-images-1.medium.com/max/800/1*JjnojejxqDmKWdDvF7JccQ.png)

这是我在 Sunnyvale 的第一个现场面试，这里办公室总是窗明几净人们看起来非常专业。

每轮面一个小时，编码问题中规中矩，但 ML 的问题有点难度。尽管如此，我从 HR 哪里收到的准备资料起到了很大的帮助。直到面试结束，并没有让我太吃惊的问题。
我听说 Linkedin 有着硅谷最好的伙食，如我所察如果不是真的，也差不远了。
 
被微软并购以后，看来 Linkedin 甩掉了财政负担，他们开始甩开膀子做真正酷的事，让人心动的新特征如视频，专业广告等。作为一个关注专业发展的公司，Linkedin 优先增长它的员工。
很多团队如广告和订阅相关的都在扩张，所以抓紧行动如果你想加入。


**Salesforce Einstein**

![](https://cdn-images-1.medium.com/max/800/1*XNUUSjrUo-n7eU5ZOGeHog.png)

明星团队做的明星项目。这是个相当新的团队，感觉像一个创业公司。产品是构建在 Scala Stack 上的， 所以在那里类型安全是实实在在的。Matthew Tovbin 在 Scala Days Chicago 2017，Leah McGuire 在 Spark Summit West 2017 进行过伟大的演讲。 

我的面试是在 Palo Alto 的办公室。 他们团队有很强的文化凝聚力和非常好的工作生活平衡。每个人都对在做的事情充满激情很真正喜欢。四轮面试下来，整体上比其他公司要短，但我多希望我能待得再长一点。面试完后，Matthew 甚至带我到惠普的车库转了一下。 


**Google**

![](https://cdn-images-1.medium.com/max/800/1*VYDw0n3CgPOsrX1j-tchbw.png)


绝对的行业老大，无需多言妇孺皆知的 Google 。但它真的非常非常的大。 花费了我 20 分钟的时间骑车去见我的朋友。 排队点餐的人也很多，对程序员而言这永远是一个美好的地方。


我在 Mountain View 园区众多楼宇中的一座里进行的面试，我不知道具体是哪一个，因为实在是太大了。

我的面试官们看起来很聪明。当他们开始谈论的时候你会发现他们更加聪明。如果和这帮人一起工作那将是多么的愉悦。

Google 的面试我觉得一点特别是对时间复杂度的分析特别重要。确保你真的明白大 O 的涵义。


**Airbnb**

![](https://cdn-images-1.medium.com/max/800/1*Y9tdU5fecN2XIUqE3bC3gA.png)

迅速增长的独角兽企业，有着独特的企业文化和号称湾区最美的办公环境。新产品如餐厅预定，高端细分市场，中国市场的扩张等都预示着公司光明的前景。如果希望快速成长和 pre-IPO 的体验，并能忍受风险，这将是一个完美的选择。


Airbnb 的代码测验有一点特别，因为你将在 IDE 上而不是白板上写，所以你的代码要能够编译并给出正确答案。有些问题确实非常困难。 

他们还有所谓一种跨职能面试。这是 Airbnb 重视公司文化的方式，仅仅技术上优秀并不能保证被录用。两轮跨职能面试让我飞常愉悦。我和面试官进行了轻松的交谈，会话结束后我们都很愉快。 


整体上我觉得 Airbnb 的现场面试是最难的，因为问题很难，时间也很长并且有跨职能的面试。如果你有兴趣，务必了解他们的文化和核心价值。



**Facebook**

![](https://cdn-images-1.medium.com/max/800/1*wgM997D8y7JHguhRESY8pA.png)

和 Google 相比，Facebook 另一个还在快速增长的巨头，小但快节奏。它的产品线垄断了社交网络，并且重点投资了 AI 和 VR ，显然未来 Facebook 有着巨大的增长潜力。和大牛们如 Yann LeCun 和 Yangqing Jia ，这机器学习人士工作的乐土。

我在 20 号楼进行的面试了，那里有楼顶花园和美丽的海景。扎克伯格的办公室也在那里。

我不确定面试官是不是得到指示，但我没有得到明确的提示关于我的答案是否正确。我还是相信公司指示他们不要评价候选者答案的正确性。

前四天的劳碌给我身体带来了影响，中午我开始头疼，我坚持把下午的面试进行完。我觉得自己一点没发挥好。当收到他们给的录用通知时我确实有点小吃惊。

总体上我觉得这里的人相信他们公司的愿景，也都为他们做的事情而骄傲。作为一个市值五千亿美金并且快速增长的公司，Facebook 是开始你职业生涯的理想公司。


### 薪资谈判

这是一个宏大主题，在这我不去谈论。 有兴趣的可以参照[这篇文章](https://medium.freecodecamp.org/how-not-to-bomb-your-offer-negotiation-c46bb9bc7dea)。
                            
一些我认为重要的事：                            

1.  表现要专业
2.  利用你的资源
3.  对项目和团队真正的兴趣
4.  保持耐心和自信
5.  决绝但有礼貌
6.  不要撒谎

### **我失败的面试经历 - Databricks**

![](https://cdn-images-1.medium.com/max/800/1*8ihczqhKMJ_dTZmRvMTAGg.png)

失败是成功之母，当然也包括面试。
在开启上述硅谷面试之旅前，五月份时我面试 Databridck 失败了。

四月的时候， Xiangrui 通过 Linkedin 联系我，问我是否对 Spark MLlib 团队的职位有兴趣， 这让我非常心动。因为 1) 我使用 Spark 热爱 Scala, 2) Databridck 的工程师是最一流的，
3) Spark 彻底改变了整个大数据世界。这是一个不能错过的机会，所以几天后我开始了这次面试。

Databridck 的门槛相当高处理流程也相当的长，包括一次初审问卷表，一次电话面试，一次代码测试和一次现场面试。

我成功的获得了现场面试的邀请，并访问了他们在三藩市市中心的办公地点，在那我们能看到金银岛。

我的面试官是个极具聪明才智又同等谦逊的人。面试过程中我经常感觉被逼到了极限。面试还算进行的顺利直到一轮灾难性的面试，我完全搞砸了因为技能不过硬和准备不充分，最终惨败。
Xiangrui 真的很善解人意，面试结束后陪我走了一段，我非常感谢和他的交谈。

几天以后我收到了拒信。和预想的一样，尽管如此这还是让我沮丧了好几天。虽然错去了在 Databricks 工作的机会，我还是衷心的希望他们能够继续取得更大的影响和成功。


### 一点感想

1.  Life is short. Professional life is shorter. Make the right move at the right time. 人生短暂，职业生涯更短。正确的时间做正确的选择
2.  Interviews are not just interviews. They are a perfect time to network and make friends. 面试不仅仅是面试，更是扩展人脉和交朋友的最佳时机
3.  Always be curious and learn. 始终保持强烈的求知欲
4.  Negotiation is important for job satisfaction. 想获得满意的工作，谈判技巧很重要
5.  Getting the job offer only means you meet the minimum requirements. There are no maximum requirements. Keep getting better. 被录用只是证明你达到了最低要求。人生没有上限，做更好的自己


从五月的第一次面试到最终九月底拿到录用通知，我的第一次跳槽是这么漫长和不易。

这对我真的不容易，因为我需要保证我现在的工作按期完成。连续几个周我都是准备面试到凌晨一点然后第二天早上八点半起来全身心准备一天的工作。
五天面试五家工作非常的有压力和冒险，我不建议大家这样做除非你日程特别赶。但是这样做也确实有一个好处，就是在手握多个 offer 时，你会在谈判的时候更具优势。 

我在这里要感谢我所有的招聘者，感谢他们耐心的帮我安排所有的流程，感谢他们的时间跟我交流并安排面试的机会以及最终给我录用通知。
沁人心扉
最后也是最重要的是，我要感谢我的家庭，感谢他们对我的爱和支持。感谢我的父母，他们一直在关注我迈出的每一步。感谢我亲爱的老婆为我做的一切还有我亲爱的女儿和她暖人心扉的微笑。


也感谢这篇长文的读者们。

你们可在 [LinkedIn](https://www.linkedin.com/in/xiaohanzeng/) 或 [Twitter](https://twitter.com/XiaohanZeng) 上找到我.

Xiaohan Zeng

10/22/17

> 译者更新：作者最终选择了 Airbnb 的 offer ， 并将于 11 月入职。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
