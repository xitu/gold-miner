
  > * 原文地址：[An Overview of the Logging Ecosystem in 2017](https://blog.codeship.com/an-overview-of-the-logging-ecosystem-in-2017/)
  > * 原文作者：[Matthew Setter](https://blog.codeship.com/author/matthewsetter/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/an-overview-of-the-logging-ecosystem-in-2017.md](https://github.com/xitu/gold-miner/blob/master/TODO/an-overview-of-the-logging-ecosystem-in-2017.md)
  > * 译者：[TanJianCheng](https://github.com/TanNingMeng)
  > * 校对者：[tmpbook ](https://github.com/tmpbook) [Yuuoniy](https://github.com/Yuuoniy)

  # 2017年日志生态系统概述

  日志功能，对于现代计算机来说是基本的组件。它可以帮助开发者调试应用程序，系统管理员和开发运营人员修复服务器中断的原因。因此，日志记录提供了解决问题的信息和上下文环境是至关重要的，无论是在（问题）发生时还是从历史上下文中排查问题。

但像计算中的任何东西一样，日志的状态从未停滞不前。现有的概念会过时然后被新的概念所替换，而其他的一些想法则变成永恒 - 有时会持续好几年。同样的模式也适用于工具和服务，无论是商业还是开源，线上服务或者线下服务。

所以现在我们处于什么位置？现在流行的趋势，工具和哲学是什么？为什么它们流行？很好，我们将通过日志生态的三个元素去探究在2017年年中日志行业处于什么位置。

我会具体地讨论以下几个值得注意的地方：

- 哲学
- 最佳方案
- 服务和工具选项

在我们进入正题之前，我先清楚地说明：我首先将我自己立足于一名开发人员的角度，其次是系统管理员和运营。所以，我的观点和文中我作出的选择是有根据地得出结论。请记住这一点。

[“目前日志流行的趋势，工具和文化是什么和它们流行的原因是什么？” 来自 @settermjd ](https://twitter.com/share?text=%22What+logging+trends%2C+tools%2C+and+philosophies+currently+hold+sway+and+why%3F%22+via+%40settermjd&amp;url=https://blog.codeship.com/an-overview-of-the-logging-ecosystem-in-2017/)

我们可以开始啦。

## 日志系统的哲学

我想说的第一部分是日志原理。在这里，我会说明两个哲学：日志存储和日志文化。

### 日志记录应该存在哪里和如何被保存？

日志文件是应该直接保存在你组织内部自己管理的服务呢？还是你使用像 Loggly 这样的 SaaS，或者存储数据到其它第三方工具 [稍后我们会介绍](#service-and-tool-options) 之一？

按照我的理解，最主要的区别是安全性和数据的敏感性的问题。你的组织里有什么数据是处于私有状态的？

如果真的有，你最好自己去研究一种解决方案来记录日志，例如 [Apache Kafka](https://kafka.apache.org)，或者 [一个易伸缩 (formerly ELK) 堆](https://www.elastic.co/webinars/introduction-elk-stack) 。如果你的数据不是特别的敏感的话，像 **Loggly**，**Graylog**，**SumoLogic**，和 **ElasticSearch** 这样的商业托管解决方案可能是一种更好的选择。

另外一种似乎热门的谈论 [在 Hacker News](https://news.ycombinator.com/item?id=12682566) 认为是日志效率问题。具体谈论的是，我们是否努力建立和管理内部的日志解决方案，像基于堆栈的实现方式来提高效率？或者说托管给现成的厂商服务会更有效率？

从来没有一个明确，万全的答案来回答这样的问题。我一直认为最统一的解释就是『看情况而定』。任何组织和应用都是独一无二的。对于一个问题有效的解决方案不一定适用于另外一个。一个人可能拥有许多资源和经验可以用于分配任务。但另外一个人不一定有。

所以在2017年，日志数据如何被存储这个问题仍然是在日志生态系统当中的关键问题。

### sidecar 应用

这是一个被称为 **sidecar应用** 的崭新（至少对于我来说）概念。如果你以前没有听说过，那么告诉你它是与部署容器类应用相关的，同样地它非常适合基于容器的部署。

[Garland Kan 在 Loggly](https://www.loggly.com/blog/how-to-implement-logging-in-docker-with-a-sidecar-approach/) 中把 sidercar 简洁地描述为:

> 将一个应用程序容器和日志容器进行结合的理念。

[他们通过这种方式描述它](https://www.voxxed.com/blog/2015/01/use-container-sidecar-microservices/) ，Voxxed　提供了更加详细的解释：

> 一个　sidecar　应用是被部署在每一个已经开发或者部署服务器/集群实例的微服务的旁边。它是概念上依附着"父母"服务，就像三轮摩托车的边座位依附着三轮摩托车一样 - 因此而得名。sidecar作为第二进程和你的程序一起运行并通过暴露类似 REST 的 API 接口(如 HTTP 的 REST )来提供‘平台基础设施功能’。

在日志的上下文环境中，一个额外的容器被加载进了堆空间，同时堆空间是日志应用存储的地方以及可以转发日志记录到像 LogEntries 和 Splunk 外部服务。从我的理解，虽然 sidecar 能适合较小的应用程序，但是比较困难去有效地测量。总的来说，这是非常有趣的概念。

### 日志的文化

现在让我们看看文化 - 一个具有主动性，非常重要的方面。直接点说，让我印象深刻 [来自 Stackify](https://stackify.com/java-logging-best-practices/) 的一个引用，他是这么说：

> …我们已经建立了一个『日志文化』…

我发现这是近年来最好的发展之一，因为没有一个支持的文化，想法和概念的话，它有可能只是暂时兴起。在过去的几年，当我们测试在时候，我认为我们都接触过。一开始社区文化总是起很大的作用。但是如果没有适当的文化支持，当其他方面的压力和最后的期限开始堆积的时候，它很快将会被淘汰。

在这篇文章，Stackify 继续说：

> [日志的文化]开始完成这些目标：
>
> 记录所有的东西。尽可能地多记录一些有关联性的，有上下文信息的日志记录。更加的智能化而不是更复杂。巩固和聚集我们的日志记录到一个中心区域，开放给所有开发者和便于提取。而且，分析异常的日志信息找到新的途径，主动去优化产品。

这段话有一些很优秀的观点，其中两个比较特别的看法值得去了解。

#### 尽可能多记录日志

与前几年我所看到的和所经历的相反，这个表达在于多记录日志，至少 -- 这些信息都是有连续性的。这个说法与 [Sumologic 在 2017 年 4 月](https://www.sumologic.com/blog/log-management-analysis/best-practices-creating-custom-logs-diving-deeper/)写的日志所说的紧密相连：

> 你的日志记录就应该像是在讲一个故事。

对于我来说，这种做法是非常有意思而且可以让你看到结果的发展。

当我不确定我们是否应该记录下它们的理由，我们拥有越多（具有上下文联系）信息，对我们处理那些突发的问题就会越有利。

#### 保存在一个中心区域，对所有开发者都开放

每个人都可以集中使用这些日志信息，是另外一个令人振奋的发展，甚至看见愈发的强大。

当信息被保存在一个中心区域，它可以更容易发挥作用。每个人都可以去访问它 - **查看它** - 这样做提高了确定日志内容的责任，以及更快的解决问题的需要。如果信息被隐藏起来，那么问题更容易被掩盖或者被埋葬。

我愿意相信当这两个理念被实现（尽可能多记录和记录在中心位置），那么我们的应用的质量会提高和故障会减少，这样会极大满足用户和开发体验。

[![Sign up](https://resources.codeship.com/hubfs/hub_generated/resized/522f8e9a-4760-42a2-9e7d-21780dfaae2b.png)](https://resources.codeship.com/cs/c/?cta_guid=f9c07177-11c7-44f5-962e-71116a8292a2&placement_guid=964db6a6-69da-4366-afea-b129019aff07&portal_id=1169977&redirect_url=APefjpHK7AUB26fFkV8T6f8w3pa2iXgimx-OwWa0mv7vwuQ9Qn1_WPEopcBxEtxv0oUL4iy6kF57zx0LDmnef1BcqOe0zK9fp7xsE9o4rtHSF8IpBjkJg5SO678peKfJbWgDYpBuPX6GFmTlTZLDhCtdckQ9d2qMT7TAEW2hnqdESN05DqKsxc8pgJzg0g3Mf6ac2ljX6IzrTulkhymu9tJBlcsHgy9TpouYzPpk1cOQhGuZKm_lKXmZDN6GEo2LoUfh-F6AEH5DIEmtUlFcKWLPXWEmwPn0-kPZWSU43p9vnIMZQvFDDArTfWVn3ZbCMyggZCGYSOvgCPFqTvnFGsfYegiJlO5BjA&hsutk=a15127591b468cb7fa682b9b9d7434c5&canon=https%3A%2F%2Fblog.codeship.com%2Fan-overview-of-the-logging-ecosystem-in-2017%2F&click=fbdaa4a3-14b1-4d61-8363-9bab2cc5db38&utm_referrer=https%3A%2F%2Fblog.codeship.com%2Fan-overview-of-the-logging-ecosystem-in-2017%2F&__hstc=209244109.a15127591b468cb7fa682b9b9d7434c5.1503571579504.1503571579504.1503571579504.1&__hssc=209244109.2.1503571579514&__hsfp=3027766740)

## 最佳方案

现在我想考虑今年我从学习中得出的最佳方案中的一个重点问题：我们创作日志内容是偏向于可读性或利于高效解析?

似乎人类更擅长于处理没有逻辑，没有组合或者没有拥有标准格式的数据，计算机却不能。相反，人类不擅长处理大量的数据但是计算机却可以。所以，我们面临着一个挑战：我们创建日志是在以人为优，便于大众工作还是以有利于电脑程序处理为优先条件，其次是使之具有可读性？

我发现，除非你只记录少量的信息，否则我们最好专注于处理效率之上，尽可能考虑执行环境而不是可读性。

但是一个有效率，内容丰富的日志目录应该是怎么样的？ [Dan Reichart（从 SumoLogic）提供了](https://www.sumologic.com/blog/log-management-analysis/best-practices-creating-custom-logs-diving-even-deeper/)，一个虚构的机票预订服务，作为一个例子：

    2017-04-1009:50:32-0700-dan12345-10.0.24.123-GET- /checkout/flights/ -credit.payments.io-Success-2-241.98

简而言之，入口的每一个元素都被 " - " 分隔开,排序后得到以下结果：

 1. 日志时间戳
 2. 购物者的用户名
 3. 用户的IP地址
 4. 请求的方法
 5. 请求的资源
 6. 请求的网管或者路径
 7. 请求的状态
 8. 机票购买数量
 9. 机票合计

如果我们仅有这些信息，那么我们只能知道部分的故事。但是如果通过保存所有的信息，而这些信息可以很好的被压缩存储，那么我们处于一个我们得到解决问题所需信息的位置。这些日志记录是简洁的，具有可读性，像讲述一个故事和遵从一个标准，可预测的模式。还有其他的表达方式，这只是其中之一。

## 服务 & 工具的选项

现在，让我们通过观察一些目前提供日志服务市场的厂商来完成这个课题。这些当中是托管的Saas和自我托管的解决方案的混合。其中一些令人注意，目前越来越强大的厂商已经存在好些时候了。它们包括以下公司像 **Loggly**，**Graylog**，**Splunk**，**ElasticSearch**， **LogEntries**， **Logz.io**，**LogStash**，**SumoLogic**，和 **Retrace** 。

虽然它们都有具有像搜索和分析，主动检测，创建结构化和非结构化数据，自定义解析规则，和实时指示界面等特征，但是他们还在创建自己的核心功能，并扩展它们产品和特征集。

它们的定价模式也有很大的不同，包括免费的选择版本，价格在90美元左右的标准计划和高达200美元的企业套餐。

但在2017年，商业化不会是唯一的选择。一些开源工具也逐渐成熟起来。事实上，Linux基金会第三季度的 [开放云报告指南](http://go.linuxfoundation.org/l/6342/2016-10-31/3krbjr) 中有两个比较引人注意：[Fluentd](http://www.fluentd.org) 统一日志层的数据收集器，和 [LogStash](https://www.elastic.co/products/logstash)，服务端数据处理管道。其他值得考虑的开源工具是 [syslog-ng](https://syslog-ng.org/)， [LOGalyze](http://www.logalyze.com/)，和 [Apache Flume](https://cwiki.apache.org/confluence/display/FLUME/Home)。

鉴于此，取决于你的经验，需求和预算，今年你的选择是非常充足的。未来将会有大量的选项可以让你选择到最符合你的需求的开源工具。

## 结论

我们总结了在2017关于日志系统大体上几个关键的因素。

我们了解过了目前的哲理，例如日志记录应该存在哪里以及如何被存储，和 sidercar 应用的概念。我们讨论过了在一个组织内日志记录的文化对于日志记录的成功是多么重要。还有更多上下文的日志记录是如何比少的要更好。最后我们了解了几个市场上关键厂商。


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
