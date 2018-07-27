> * 原文地址：[Bitcoin in BigQuery: blockchain analytics on public data](https://cloud.google.com/blog/big-data/2018/02/bitcoin-in-bigquery-blockchain-analytics-on-public-data)
> * 原文作者：[Allen Day](https://cloud.google.com/blog/big-data/2018/02/bitcoin-in-bigquery-blockchain-analytics-on-public-data)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/bitcoin-in-bigquery-blockchain-analytics-on-public-data.md](https://github.com/xitu/gold-miner/blob/master/TODO1/bitcoin-in-bigquery-blockchain-analytics-on-public-data.md)
> * 译者：[LeopPro](https://github.com/LeopPro)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH) [SergeyChang](https://github.com/SergeyChang)

# BigQuery 中的比特币：使用公共数据分析区块链

云主导开发者 Allen Day、云服务开发者 Colin Bookman。

加密货币已经吸引了技术专家、金融家和经济学家的想象力。或许更有趣的是长期多样化的区块链应用。通过提高加密货币系统的透明度，其所包含的数据变得越来越易于访问和使用。

现在比特币区块链数据可以通过 BigQuery 探索。所有的历史数据都在 [bigquery-公共数据：比特币区块链](https://bigquery.cloud.google.com/dataset/bigquery-public-data:bitcoin_blockchain)数据集中，该数据集每 10 分钟更新一次。

我们希望通过使数据更加透明化，使数据用户可以对加密货币系统运作有一个更深刻的理解，以及如何更好的利用他们造福社会。

### 有趣的查询和分析

下面，我们将根据比特币数据集展示一些有趣的查询和可视化数据。我们将着眼分析以下两个热门话题：

*   网络基础（块困难度）
*   交易可视化（第一次易物交易）

### 区块链网络统计信息汇总

比特币网络参数为基本的网络分析提供了基础。例如，比特币日发送总数以及比特币日接收总数表明网络中的经济活动，并且这和比特币的均价有关，根据[梅特卡夫定律](https://zh.wikipedia.org/wiki/%E6%A2%85%E7%89%B9%E5%8D%A1%E5%A4%AB%E5%AE%9A%E5%BE%8B)推测，一个网络的价值与其用户数的平方成正比。

下图显示了比特币网络日交易量趋势：

![](https://i.loli.net/2018/05/08/5af11cc39681c.png)

下图显示了比特币地址日接收量趋势：

![](https://i.loli.net/2018/05/08/5af11cc391749.png)

以下根据根据区块链网络的第一原则，网络价值与交易比或 [NVT 比](http://charts.woobull.com/bitcoin-nvt-ratio/)制定的评估指标。该图表显示了随时间的每日 NVT 比率：

![](https://i.loli.net/2018/05/08/5af11cc393d81.png)

例如比特币挖矿算法困难度等其他的比特币参数，也可能具有基本的经济重要性。下图显示了比特币挖矿困难度与“比特币”搜索量的关系。

![](https://i.loli.net/2018/05/08/5af11cc38c4cc.png)

> 译者注：以上 4 个实时数据图可以在 [Google 数据洞察](https://datastudio.google.com/reporting/1G8yte8g3daDEw5EKOvbxPQudv92PZcPP)中查看。

### 交易可视化

使用电子货币进行交易的一个后果是交易记录公开且完备。据信，第一次用比特币购买物品是在 2010 年 5 月 17 日。[Laszlo Hanyecz](https://en.bitcoin.it/wiki/Laszlo_Hanyecz) 花了 10,000 BTC 买了两个批萨，从地址 [1XPT…rvH4](https://blockchain.info/address/1XPTgDRhN8RFnzniWCddobD9iKZatrvH4) 到地址 [17Sk…xFyQ](https://blockchain.info/address/17SkEw2md5avVNyYgj6RiXuQKNwkXaxFyQ) 的交易记录在交易 ID 为 [a107…d48d](https://blockchain.info/tx/a1075db55d416d3ca199f55b6084e2115b9345e16c5cf302fc80e9d5fbf5d48d) 的区块链中。我们对 Hanyecz 地址购买批萨之前的 4 层比特币转移数据进行了可视化分析。我们用这段[代码](https://www.kaggle.com/mrisdal/visualizing-the-10k-btc-pizza-transaction-network?utm_medium=partner&utm_source=cloud&utm_campaign=big+data+blog+bitcoin)生成了下图。Hanyecz 的付款地址为红色圆圈，而其他地址为蓝色圆圈。箭头表示披萨购买交易之前比特币流动的方向。笔画宽度大致与地址间比特币移动量成正比。

![](https://cloud.google.com/blog/big-data/2018/02/images/6736684411518976/bitcoin-bq-1.png)

### 区块链勘探和异常检测

在比特币区块链中，存在被添加到两个区块的交易。这不应该发生。这个查询可以发现这种异常交易：

```
# 标准 SQL
SELECT
  *
FROM (
  SELECT
    transaction_id,
    COUNT(transaction_id) AS dup_transaction_count
  FROM
    `bigquery-public-data.bitcoin_blockchain.transactions`
  GROUP BY
    transaction_id)
WHERE
  dup_transaction_count > 1
```

**怎么会发生这种事情？** 比特币最初构建于 [BerkeleyDB](https://zh.wikipedia.org/wiki/Berkeley_DB)，它可以处理非唯一键。后来[中本聪](https://zh.wikipedia.org/wiki/%E4%B8%AD%E6%9C%AC%E8%81%AA)离开了比特币项目组，新的开发团队使用 [LevelDB](http://leveldb.org) 替代了 [BerkeleyDB](https://zh.wikipedia.org/wiki/Berkeley_DB)。然而 [LevelDB](http://leveldb.org) 无法处理唯一键，这使得开发者根据比特币改善提案 [BIP_0030](https://github.com/bitcoin/bips/blob/master/bip-0030.mediawiki) 修改 [比特币源代码](https://github.com/bitcoin/bitcoin)。

尽管交易不再可能存在与多个块中，但仍然有一些过往的交易存在这个问题。

### 为什么 Google Cloud 上比特币区块链数据不可不看？

区块链一般为低信任环境中的平等节点之间的沟通和协调提供解决方案。在金融服务，供应链，媒体和其他高度数字化行业中，区块链正在崭露头角。比特币区块链旨在弥补金融业的缺陷，如[中本聪](https://en.bitcoin.it/wiki/Satoshi_Nakamoto)写的 [Bitcoin genesis block](https://en.bitcoin.it/wiki/Genesis_block)。

比特币可以被描述为一个不可变的分布式账本，虽然它提供了 [OLTP](https://en.wikipedia.org/wiki/Online_transaction_processing) 功能（原子交易，数据持久性），但它对于定期存储的具体或汇总资金流进行短周期报告的 [OLAP](https://en.wikipedia.org/wiki/Online_analytical_processing) （分析）能力非常有限。难以轻易地从区块链构建报告可能会降低透明度并增加 [BTC-USD](https://www.google.com/search?q=btc+usd) 价格分析的难度以及 [NVT 比](http://charts.woobull.com/bitcoin-nvt-ratio/)等其他基本评估指标。

相比之下，BigQuery 具有强大的 OLAP 功能。, 我们在 Google Cloud 上构建了一个软件系统：

1.  从比特币区块链账中实时提取数据
2.  将数据存储到 [BigQuery](https://cloud.google.com/bigquery) 并将其解除规范化，以便更轻松地进行探索
3.  使用 [Data Studio](https://datastudio.google.com/c/org/UTgoe29uR0C3F1FBAYBSww/reporting/1G8yte8g3daDEw5EKOvbxPQudv92PZcPP/page/nExM/edit) 从数据中导出分析报告

比特币区块链数据也可以通过 [Kaggle](https://www.kaggle.com/bigquery/bitcoin-blockchain?utm_medium=partner&utm_source=cloud&utm_campaign=big+data+blog+bitcoin) 获取。你可以使用 BigQuery Python 客户端库查询 Kernel（Kaggle 的免费浏览器内开发环境） 中的实时数据。你可以 fork 一份[这个实例 kernel](https://www.kaggle.com/mrisdal/visualizing-daily-bitcoin-recipients?utm_medium=partner&utm_source=cloud&utm_campaign=big+data+blog+bitcoin) 并用你自己的 Python 代码副本来进行试验。

### BigQuery 公共数据集

所有比特币区块链数据都批量加载到两个 BigQuery 表：blocks_raw 和 transactions。新块被广播到比特币网络时被追加到表中，因此这些表中的数据是最新的。

### 鸣谢

我们想感谢尽心尽力发表这篇博文的 Google 同事们。感谢 [Minhaz Kazi](https://twitter.com/_mkazi_)（Data Studio 主导开发者），[Megan Risdal](https://twitter.com/MeganRisdal)（Kaggle 数据科学家），[Sohier Dane](https://github.com/sohierdane)（Kaggle数据科学家）和[Hatem Nawar](https://twitter.com/hnawar)（云服务工程师）


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
