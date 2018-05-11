> * 原文地址：[Bitcoin in BigQuery: blockchain analytics on public data](https://cloud.google.com/blog/big-data/2018/02/bitcoin-in-bigquery-blockchain-analytics-on-public-data)
> * 原文作者：[Allen Day](https://cloud.google.com/blog/big-data/2018/02/bitcoin-in-bigquery-blockchain-analytics-on-public-data)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/bitcoin-in-bigquery-blockchain-analytics-on-public-data.md](https://github.com/xitu/gold-miner/blob/master/TODO1/bitcoin-in-bigquery-blockchain-analytics-on-public-data.md)
> * 译者：
> * 校对者：

# Bitcoin in BigQuery: blockchain analytics on public data

By Allen Day, Cloud Developer Advocate and Colin Bookman, Cloud Customer Engineer.

Cryptocurrencies have captured the imagination of technologists, financiers, and economists. Perhaps even more intriguing are the long-term, diverse applications of the blockchain. By increasing transparency of cryptocurrency systems, the contained data becomes more accessible and useful. 

The Bitcoin blockchain data are now available for exploration with BigQuery. All historical data are in the [bigquery-public-data:bitcoin_blockchain](https://bigquery.cloud.google.com/dataset/bigquery-public-data:bitcoin_blockchain) dataset, which updates every 10 minutes.

We hope that by making the data more transparent, users of the data can gain a deeper understanding of how cryptocurrency systems function and how they might best be used for the benefit of society.

### Interesting Queries and Analyses

Below, we show a number of interesting queries and visualizations based on the Bitcoin dataset.  Our analyses focus on two popular topics:

*   network fundamentals (block difficulty)
*   transaction visualization (first goods purchase)

### Aggregate blockchain network statistics

Bitcoin network properties provide a basis for fundamental valuation of the network. For example, the total number of Bitcoins sent per day and the total number of Bitcoin recipients per day indicate economic activity on-network, and are related to Bitcoin’s value per [Metcalfe’s Law](https://en.wikipedia.org/wiki/Metcalfe%27s_law), the conjecture that the value of a network is proportional to the square of the number of users.

This interactive chart shows the number of Bitcoins transacted per day across the network over time:

![](https://i.loli.net/2018/05/08/5af11cc39681c.png)

This interactive chart shows the number of recipient addresses per day over time:

![](https://i.loli.net/2018/05/08/5af11cc391749.png)

See below for a valuation metric developed from first principles for blockchain networks, the Network Value to Transactions Ratio, or [NVT Ratio](http://charts.woobull.com/bitcoin-nvt-ratio/). This chart show the daily NVT Ratio over time:

![](https://i.loli.net/2018/05/08/5af11cc393d81.png)

Other properties of the Bitcoin network, such as the difficulty parameter of the Bitcoin mining algorithm, may also be of fundamental economic importance. The following chart shows the relationship of Bitcoin mining difficulty vs. search volume for “Bitcoin”.

![](https://i.loli.net/2018/05/08/5af11cc38c4cc.png)

### Transaction visualization

One consequence of using electronic currency to conduct commerce is that it becomes possible to record transactions publicly with perfect fidelity.  On May 17, 2010, the first known exchange of Bitcoin for goods took place. [Laszlo Hanyecz](https://en.bitcoin.it/wiki/Laszlo_Hanyecz) purchased two pizzas for 10,000 BTC, and the transaction from address [1XPT…rvH4](https://blockchain.info/address/1XPTgDRhN8RFnzniWCddobD9iKZatrvH4) to address [17Sk…xFyQ](https://blockchain.info/address/17SkEw2md5avVNyYgj6RiXuQKNwkXaxFyQ) is recorded in the blockchain with transaction ID [a107…d48d](https://blockchain.info/tx/a1075db55d416d3ca199f55b6084e2115b9345e16c5cf302fc80e9d5fbf5d48d). We produced a data visualization of input transfers to Hanyecz’s address preceding the pizza purchase by up to 4 degrees. Here’s the [code](https://www.kaggle.com/mrisdal/visualizing-the-10k-btc-pizza-transaction-network?utm_medium=partner&utm_source=cloud&utm_campaign=big+data+blog+bitcoin) we used to generate a plot like the one below. Hanyecz’s payment address is depicted as a red circle while other addresses are blue circles. Arrowheads indicate direction of Bitcoin flow preceding the pizza purchase transaction. Stroke width is approximately proportional to the amount of Bitcoin moving between addresses.

![](https://cloud.google.com/blog/big-data/2018/02/images/6736684411518976/bitcoin-bq-1.png)

### Blockchain exploration and anomaly detection

In the Bitcoin blockchain there exists a transaction which was added to two blocks. This shouldn’t be possible. The anomalous transaction can be uncovered with this query:

```
#standardSQL
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

_How did this happen?_ Bitcoin was first built with [BerkeleyDB](https://en.wikipedia.org/wiki/Berkeley_DB), which can handle non-unique keys. After [Satoshi Nakamoto](https://en.wikipedia.org/wiki/Satoshi_Nakamoto) left the Bitcoin project, a new development team replaced [BerkeleyDB](https://en.wikipedia.org/wiki/Berkeley_DB) with [LevelDB](http://leveldb.org). [LevelDB](http://leveldb.org) cannot handle unique keys, causing the developers to modify the [Bitcoin source code](https://github.com/bitcoin/bitcoin) by implementing Bitcoin Improvement Proposal [BIP_0030](https://github.com/bitcoin/bips/blob/master/bip-0030.mediawiki).

Even though it’s no longer possible for a transaction to exist in multiple blocks, there are still a few older transactions where this happened.

### Why is it useful to have Bitcoin Blockchain Data accessible on Google Cloud?

Blockchains in general provide a solution for communication and coordination amongst peers in low-trust environments. Use cases are emerging in the financial services, supply chain, media, and other highly digitized industries. The Bitcoin blockchain in particular aims to remedy financial industry flaws, as documented in the [Bitcoin genesis block](https://en.bitcoin.it/wiki/Genesis_block) by [Satoshi Nakamoto](https://en.bitcoin.it/wiki/Satoshi_Nakamoto).

Bitcoin can be described as an immutable distributed ledger, and while it provides [OLTP](https://en.wikipedia.org/wiki/Online_transaction_processing) capabilities (atomic transactions, data durability), it has very limited [OLAP](https://en.wikipedia.org/wiki/Online_analytical_processing) (analytics) capability for regularly required short time-scale reporting on specific or aggregated money flows stored in the ledger. Inability to easily build reports from the blockchain can reduce transparency and increase the difficulty of price discovery of [BTC-USD](https://www.google.com/search?q=btc+usd), as well as other fundamental metrics of valuation such as the [NVT Ratio](http://charts.woobull.com/bitcoin-nvt-ratio/).

In contrast, BigQuery has strong OLAP capabilities. We built a software system on Google Cloud that:

1.  performs a real-time extraction of data from the Bitcoin blockchain ledger
2.  stores the data to [BigQuery](https://cloud.google.com/bigquery) and de-normalizes it to make exploration easier
3.  derives insights from the extracted data with [Data Studio](https://datastudio.google.com/c/org/UTgoe29uR0C3F1FBAYBSww/reporting/1G8yte8g3daDEw5EKOvbxPQudv92PZcPP/page/nExM/edit)

The [Bitcoin Blockchain data is also available via Kaggle](https://www.kaggle.com/bigquery/bitcoin-blockchain?utm_medium=partner&utm_source=cloud&utm_campaign=big+data+blog+bitcoin). You can query the live data in Kernels, Kaggle’s no charge in-browser coding environment, using the BigQuery Python client library. Fork [this example kernel](https://www.kaggle.com/mrisdal/visualizing-daily-bitcoin-recipients?utm_medium=partner&utm_source=cloud&utm_campaign=big+data+blog+bitcoin) to experiment with your own copy of the Python code.

### BigQuery Public Dataset

All Bitcoin blockchain data are loaded in bulk to two BigQuery tables, blocks_raw and transactions. These tables contain fresh data, as they are appended as new blocks are broadcast to the Bitcoin network.

### Acknowledgements

We’d like to thank our colleagues across Google for making this blog post possible. Thank you [Minhaz Kazi](https://twitter.com/_mkazi_) (Data Studio Developer Advocate), [Megan Risdal](https://twitter.com/MeganRisdal) (Kaggle Data Scientist), [Sohier Dane](https://github.com/sohierdane) (Kaggle Data Scientist), and [Hatem Nawar](https://twitter.com/hnawar) (Cloud Customer Engineer)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
