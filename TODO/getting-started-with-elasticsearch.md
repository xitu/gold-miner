> * 原文地址：[Getting Started](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html#getting-started)
> * 原文作者：[elastic](https://www.elastic.co)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/getting-started-with-elastic.md](https://github.com/xitu/gold-miner/blob/master/TODO/getting-started-with-elastic.md)
> * 译者：[code4j](https://github.com/rpgmakervx)
> * 校对者：[Starriers](https://github.com/Starriers)

# Elasticsearch 简介

Elasticsearch 是一个高可扩展的开源全文搜索分析引擎，可以用它近实时的来存储、搜索和分析大量的数据。通常我们使用它作为底层引擎技术给拥有复杂搜索功能需求的应用提供支持。

以下是 Elasticsearch 的几个适用场景:

- 你经营一家网店，用户可以搜索你出售的商品。此时，你可以用 Elasticsearch 存储全部商品的目录和存货，然后给用户提供搜索和自动提示功能.
- 你想要收集日志或交易数据用于分析趋势、统计数据、概要和异常。此时，你可以使用 Logstash(Elasticsearch/Logstash/Kibana 技术栈的一部分)来收集，聚合，解析数据，然后将其存入 ES。一旦数据在 ES 里了，你就可以用搜索和聚合挖掘任何你感兴趣的数据。
- 你有一个可以让懂行的顾客制定类似“我对这个东西挺感兴趣的，当这个东西的价格在下个月之前降到X块钱了通知我”规则的价格预警平台。此时，你可以抹去卖主的价格，存入ES中，使用逆向搜索能力(Percolator)，根据用户的查询来匹配价格的变动，一旦价格匹配，给用户推送提醒.
- 你有分析和商业策略的需求，想快速的在大数据（有上十亿的记录）里研究，分析，做可视化，特定的询问。此时，你可以用ES存储你的数据，然后用 Kibana(Elasticsearch/Logstash/Kibana 技术栈的一部分)来定制可以让你的重要数据可视化的仪表盘。不仅如此，你可以用ES的聚合功能，根据你的数据作复杂的商业策略查询.

接下来的教程中会指引你从启动 elasticsearch 到基本的操作比如建立索引，查询和数据更改，了解内部机制。最后你将知道它是什么以及它内部的原理。最后你将知道它是什么以及它内部的原理，希望能启发您使用 elasticsearch 构建更复杂的搜索应用或数据挖掘应用.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
