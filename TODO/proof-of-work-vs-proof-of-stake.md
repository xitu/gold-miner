> * 原文地址：[Proof of Work vs Proof of Stake: Basic Mining Guide](https://blockgeeks.com/guides/proof-of-work-vs-proof-of-stake/)
> * 原文作者：[Ameer Rosic](https://blockgeeks.com/author/ameerrosic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/proof-of-work-vs-proof-of-stake.md](https://github.com/xitu/gold-miner/blob/master/TODO/proof-of-work-vs-proof-of-stake.md)
> * 译者：[foxxnuaa](https://github.com/foxxnuaa)
> * 校对者：[atuooo](https://github.com/atuooo), [moods445](https://github.com/moods445)

# 工作量证明 vs 权益证明：基本挖矿指南

最近你可能听说过一个想法，该想法将以太坊共识从工作量证明（PoW）转变为所谓的权益证明。

在本文中，我将向您解释工作量证明与权益证明的主要区别。同时，我将向您介绍挖矿的定义，或者通过网络发布新的数字货币的过程。

另外，如果[以太坊](http://blockgeeks.com/guides/what-is-ethereum/)社区决定从“工作量”转变为“权益”，那么挖矿技术会发生什么变化呢？

本文希望成为理解上述问题的基本指南。

![Proof of Work vs Proof of Stake: Basic Mining Guide](http://blockgeeks.com/wp-content/uploads/2017/03/infographics2017-01.png)

## 什么是工作量证明？

首先，让我们从基本定义开始。

工作量证明是一个协议，主要目标是阻止网络攻击，例如分布式拒绝服务攻击（DDoS），DDoS 通过发送大量伪造请求耗尽计算机系统的资源。

工作量证明在[比特币](http://blockgeeks.com/guides/what-is-bitcoin-a-step-by-step-guide/)之前就已经存在，但是中本聪将这种技术应用到他的/她的 - 我们仍然不知道中本聪真实身份 - 数字货币，从而彻底改变了传统交易的方式。

实际上，PoW 的想法最初是由 Cynthia Dwork 和 Moni Naor 于 1993 年发表的，但是“工作量证明”一词是 Markus Jakobsson 和 Ari Juels 在 1999 年发表的一篇文章中创造的。

但是，到目前为止，工作量证明可能是中本聪在 2008 年发布的比特币白皮书背后的最重要的想法，因为它允许自信任和分布式共识。

## 什么是自信任和分布式共识？

自信任和分布式共识意味着，如果您想发送和/或从某人那里接收钱，您不需要信任第三方服务。

当您使用传统的支付方式时，您需要信任第三方来设置您的交易（例如 Visa，Mastercard，PayPal，银行）。他们拥有自己的私人登记簿，储存每个账户的交易历史和余额。

为了更好地解释这种行为，常见的例子是：如果 Alice 给 Bob 发送 $100，受信任的第三方服务会扣除 Alice 的账户，同时增加 Bob 的账户，因此他们都必须信任这个第三方会做正确的事情。

对于[比特币](http://blockgeeks.com/guides/what-is-bitcoin-a-step-by-step-guide/)和其他一些[数字货币](http://blockgeeks.com/guides/what-is-cryptocurrency/)，每个人都有一份账本拷贝（区块链），所以没有人需要信任第三方，因为任何人都可以直接验证所写的信息。

![What is Blockchain Technology? A Step-by-Step Guide For Beginners](http://blockgeeks.com/wp-content/uploads/2016/09/home.jpg)

## 工作量证明和挖矿

进一步来说，工作量证明定义了一种昂贵的计算机运算，也称为挖矿，它需要执行该计算机运算以便在[称为区块链的分布式账本] (http://blockgeeks.com/guides/what-is-blockchain-technology/)上创建一组新的自信任的交易（即区块）。

挖矿有两个目的：

1. 验证交易的合法性，或避免所谓的双重消费；

2. 通过奖励矿工执行之前的任务来创建新的数字货币。

**当您想要进行一笔交易时，幕后会发生这些事情:**

* 交易被打包到所谓的区块中；
* 矿工确认每个区块内的交易是合法的；
* 要做到这一点，矿工需要解决一个称为工作量证明问题的数学难题；
* 奖励给第一位解决每个区块问题的矿工；
* 将已验证的交易存储到公共区块链中

这个“数学难题”有个关键特征：不对称。事实上，这项工作在请求方有一定难度，但是在网络侧很容易校验。这个想法也被称为CPU成本函数，客户难题，计算难题或者 CPU 定价函数。

所有的网络矿工竞争成为第一个找到该数学问题的解决方案的人，而这个问题与候选区块有关，它无法用暴力来解决，所以基本上需要大量的尝试。

当一名矿工最终找到了正确的解决方案的同时，他/她向整个网络宣布，并获得了协议所提供的加密货币奖(奖励)。

从技术角度看，挖掘过程是逆向哈希操作：它确定一个数(nonce)，使区块数据的加密哈希算法的结果小于给定的阈值。

这个被称为难度的阈值决定了挖矿竞争性的性质：增加了网络的计算能力，这个参数越高，创建新区块所需的平均计算量越大。这种方法也增加了区块创造的成本，推动矿工提高其挖矿系统的效率，以维持正向的经济平衡。这个参数大约每 14 天更新一次，每 10 分钟生成一个新块。

工作量证明不仅被比特币区块链使用，而且还被以太坊和其他许多区块链所使用。

工作量证明系统的一些功能因为每个区块链的创建不同而不同，但是现在我不想用太多的技术数据混淆你的概念。

重要的是，现在[以太坊开发者](http://courses.blockgeeks.com/)想要使用新的被称为权益证明的共识系统来扭转局面。

## 什么是权益证明?

权益证明是一种不同的验证交易的方式，并实现了分布式共识。

它仍然是一种算法，其目的与工作量证明是一样的，但是达到目标的过程是完全不同的。

在 2011 年的 bitcointalk 论坛上，首次提出了权益证明，但第一个使用这种方法的数字货币是 2012 年的 Peercoin，还有 ShadowCash, Nxt, BlackCoin, NuShares/NuBits, Qora 和 Nav Coin。

与工作量证明不同的是，工作量证明算法奖励那些解决数学问题以验证交易并创建新的区块的矿工们，对于权益证明，一个新区块的创建者是按照确定的方式选择的，取决于其财富，也被定义为权益。

没有区块奖励。

而且，所有的数字货币都是在一开始就创建的，它们的数量永远不会改变。

这意味着在 PoS 系统中没有区块奖励，因此，矿工们收取交易费用。

事实上，这也就是为什么在 PoS 系统中，矿工们被称为伪造者。

## 为什么以太坊想用 PoS ？

以太坊社区和它的创始人，Vitalik Buterin，打算做一个[硬](http://blockgeeks.com/omg-ethereum-hard-forked/)[分叉](http://blockgeeks.com/omg-ethereum-hard-forked/)，从工作量证明转换到权益证明。

但为什么他们要从一个转向另一个呢？

在基于工作量证明的分布式共识中，矿工们需要大量的能源。一个比特币交易需要消耗[1.57 美国家庭](http://blockgeeks.com/bitcoins-energy-consumption/) 一天 [(2015 年数据](http://blockgeeks.com/bitcoins-energy-consumption/))一样多的电力.

这些能源成本以法定货币支付，导致数字货币价值持续下降。

在最近的研究中，专家们认为，到 2020 年，比特币交易可能会消耗和丹麦一样多的电力。

开发人员非常担心这个问题，因此以太坊社区想要开发一种更绿色、更便宜的分布式共识的权益证明方法。

另外，创建一个新区块的奖励不同：对于工作量证明，矿工们可能无法拥有他/她开采的数字货币。

在权益证明中，伪造者总是那些拥有铸币的人。

## 如何选出伪造者？

如果实现了 Casper（新的权益证明共识协议），那么将存在一个验证池。用户可以加入这个池，以便选为伪造者。这个过程可以通过一个函数调用 Casper 合约，同时[发送 Ether ](http://blockgeeks.com/guides/digital-wallet-guide/) —  或者驱动以太坊网络的以太币。

* * *

> **![What is Blockchain Technology? A step-by-step guide than anyone can understand](http://blockgeeks.com/wp-content/uploads/2016/09/Vitalik-Buterin.png)**
> 
> **“一段时间后，你就会自动了解，”维塔利克·布特林在 Reddit 上的一篇文章中解释道。**

* * *

“验证池本身不会引入任何优先级方案；任何人都可以在任意一轮加入，而不用考虑其他参与者的数量”他继续说道。

每个验证者的奖励将是“大约 2 - 15%”，但他还不太确定。

此外，Buterin 认为，有效验证者（或伪造者）的数量不会有任何限制。但是，当有太多的验证者时，它会通过降低收益率进行调节；当有太少的验证者时，它会提高奖励。

## 更安全的系统？

任何计算机系统都想摆脱黑客攻击的可能性，特别是在服务与金钱有关的时候，尤其如此。

那么，主要的问题是：权益证明比工作量证明更安全?

专家们对此很担心，社区里也有一些怀疑论者。

由于技术和经济上的限制，在使用工作量证明系统时，危险分子被淘汰。

事实上，编程攻击 PoW 网络是非常昂贵的，而且需要的钱比你能偷的要多得多。

相反，潜在的 PoS 算法必须尽可能的防攻击，因为如果没有特别的惩罚措施，基于权益证明的网络可能更容易被攻击。

为了解决这个问题，Buterin 创建了 Casper 协议，设计了一个算法，在某些情况下当一个失效的验证者丢失它们的存储时，该算法仍然可以使用验证者集合。

他解释道：“在 Casper 中，经济终结是通过要求验证者提交存款来参与，并在协议确定他们以某种方式违反了某些规则(‘苛刻的条件’)的情况下减去他们的存款来完成的。”

苛刻的条件指的是用户不应违反上述情况或者法律。

### 结论

由于 PoS 系统验证者不需要使用他们的计算能力，因为唯一影响他们机会的因素是他们的持币总数和当前网络的复杂性。

因此，从 PoW 切换到 PoS，未来可能会带来以下好处:

1. 节约能源；

2. 当攻击变得更加昂贵时，网络会变得更加安全：如果黑客想要购买总数 51% 的货币，市场就会通过快速的价格升值来应对。

这样，CASPER 将成为一个依赖于经济共识系统的安全存款协议。新区块创建时，节点(或验证者)必须支付一个安全存款，以作为共识的一部分。Casper 协议将通过对安全存款的控制来确定验证者接收到的具体奖励金额。

如果一个验证者创建了一个“无效”区块，它的安全存款和作为网络共识一部分的特权将被删除。

换句话说，Casper 的安全系统是建立在类似于赌博的基础上的。在基于 PoS 的系统中，押注是根据共识规则，将对验证者和验证者下注的每个链进行奖励。

因此，Casper 基于这样一个想法，即验证者会根据其他人的下注进行下注，并留下能够加速共识的积极反馈。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
