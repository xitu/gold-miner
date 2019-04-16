> * 原文地址：[The Three Economic Eras of Bitcoin](https://medium.com/@rusty_lightning/the-three-economic-eras-of-bitcoin-d43bf0cf058a)
> * 原文作者：[Rusty Russell](https://medium.com/@rusty_lightning?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-three-economic-eras-of-bitcoin.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-three-economic-eras-of-bitcoin.md)
> * 译者：[ppp-man](https://github.com/ppp-man)
> * 校对者：[llp0574](https://github.com/llp0574), [SeanW20](https://github.com/SeanW20)

# 比特币的三个经济阶段

比特币生态系统会何去何从其实就写在了其共识规则里的数学知识中。我们都应该知道它将会经历的三个阶段。

第一个阶段：中本聪的免费赠送（2009–2014）

在比特币早期，币的价值模糊且难以衡量。需求小而且你甚至可以免费（主要指矿工费）发送任意数量的币。没有真正的堵塞问题，因此也没有软件和商业计划的需要：广为人知的博彩服务“中本聪骰子”（译者注：SatoshiDice，一种基于区块链技术的博彩游戏）使用无限容量的区块链作为信号层，给赌输的一方发送一聪（比特币最小单位）的比特币。这可都是免费的钱！

比特币曾是陌生又难懂的科技。理解其组成部分的相互作用已经够费力了，揣测其对未来的意义更是困难。有几个因素让这种情况更为糟糕：：

1. 匿名性和缺乏管制吸引了很多骗子。其影响引起许多用户的不信任还有导致真实信息难以渗透。
2. 区块链体系的成功吸引了那些想复制其模式（通常只是为了赚钱），却没有多少相关知识的人。_[1]_
3. 早期用户不仅喜欢结伴成群，而且进入比特币圈子都是被各自的经济利益驱使。由此产生的积极支持意味着任何负面信息都很难渗透到更广的生态系统。

这导致人们错误以为“免费”就是比特币的一个特点。开发者们**曾**清楚这点，因此就有了一些参考设定去减少机制的滥用。这些设定规则并没有改变比特币，而是改变了用户行为：他们添加最低收费_[2]_, 停止转发小额付款_[3]_, 并改进代码来减小未发送交易占用的大小_[4]_。

#### 第二个阶段：中本聪的福利（我们正处于的阶段）

> “比特币的手续费可能更高，并且向新的经济政策转变。”

> — Jeff Garzik [https://medium.com/@jgarzik/bitcoin-is-being-hot-wired-for-settlement-a5beb1df223a](https://medium.com/@jgarzik/bitcoin-is-being-hot-wired-for-settlement-a5beb1df223a)

区块生成的爆发性和比特币市场的不稳定开始逐渐产生容量问题。这些问题曾被挖矿者通过优化代码和调整设定来解决，如今它们变得更为常见和严重，使得人们意识到第一个阶段已经岌岌可危。

不可避免，很多人想延长免手续费的阶段。但没有弹性收费的软件服务，以及苛刻的费用条件本身增加了这个目标的难度，因为要可靠地为用户估算交易加入下一个区块的费用是难中之难。_[5]_

开发者不想支持单纯增加费用通常源于几个因素：

1. 过去的加价增加了中心化的压力，这包括有一段时间过半数的网络是被同一个矿池支配着。_[6]_
2. 这会是比特币有史以来首个向后不兼容的改变。
3. 一次性增加费用冒着不道德的风险，因为对扩张的宣传被认为比改善工程简单且不费钱。
4. 尽管在预料之中，软件和服务却都没有为此转变做准备。也许是因为没有谁觉得这次转变真的会发生。_[7]_
5. 开发者一般希望跟随社区的步伐而不是带领。在经济上具有重大意义或有争议的变化，加大了这种依赖性。_[8]_
6. 大而复杂的系统转变需要尽可能地循序渐进以避免意料外的副作用。第三阶段到来的同时，第二阶段提供的渐变给予了比特币相关的软件和服务足够时间来积累经验，迎接新阶段的来临。

开发者采取几种方式改善堵塞的问题。其中之一是大范围地深度优化_[9]_已满负荷运行的网络。全球网路中的节点分程传递_[11]_和新策略_[12]_改善了区块增长的问题。费用估算算法变得越来越深奥_[13]_，包括通过增加费用取代交易_[14]_和接收者协助交易_[15]_。

尽管害怕大区块会中心化，加入区块的扩张_[16]_会最终使网路流量增加一倍，而软件也为此不停更新。许多努力投入到增加区块的交易量_[17]_以达到增加流量的同时保持去中心化。

毫不意外，这些努力不足以延续第一阶段。比特币作为可支付网络经常因为区块处理不稳定而使时间缓慢所以变得使用困难：$20 以下的交易无法通过。在第一阶段形成的公司和普通用户仍然关注他们在第一阶段的积累同时请求财政帮助。这时一个巨大的挖矿垄断已经形成而且加入寻找的行列。_[18]_

虽然这些尝试失败了，但值得注意的是，当某些希望延续第一阶段的人认为可以避免第三阶段的时候，_[19]_，还有许多人干脆就觉得**现在**不应该发生变化。说服力最强的观点是变化会不利于用户采用，也影响币的有用性和规范性。不幸的是这观点一直很强势而且囊括到上面列举的问题。

毋庸置疑增加交易的负荷量最终减少支付费用的负担，这也是第二阶段发展计划的主要动力。_[20]_

#### 第三阶段：自给自足（2028？以后）

> “当一批特定数量的货币在市场上流通，奖励可以完全用交易费用代替并且实现无通胀。”

> — 中本聪，比特币：一个点对点的电子现金系统

一旦“免费货币”引导的阶段结束，比特币系统进入自给自足的阶段，由用户承担保护系统免于双重支付（每年数十亿美元_[21]_）的费用。通过每四年把区块奖励减半逐渐进入下个阶段。_[22]_

目前的水平表明手续费将在 2024 年和区块奖励相当，并在 2028 年开始高于奖励。_[23]_

成立于第一阶段而在第二阶段蓬勃发展的面向用户的商户会发现第三阶段无比艰难。一个自称处理 25% 交易量的商户需要支付 7 亿美元保障与现在同等级的网路_[24]_。然而没有一个商家告诉他们的投资者这个潜在的费用或需要比特币大幅增值来支付这笔钱_[26]_，也没有谁计划减少他们的份额_[25]_。

矿工也不会觉得第三阶段容易。与用户直接对接的他们会发现这段关系因为费用水平越发紧张，收入空间被大商户和用户群挤压。矿工在收入压力下的一体化也许会导致中心化的加剧，但这中心化也可能因为商户直接投资到挖矿而抵消。_[27]_

#### 第三阶段会以内战开始

这似乎是难以避免的：处理大量交易的矿工和商户会决定（重新）引入通货膨胀。这能为大商户转移成本，对矿工来说则是“无本之财”。论据则跟第二阶段早期的纽约协议相似但更仔细更广泛，主要论据包括：

1. 比特币创始人并不是经济学家，而经济学家建议大约1%的通胀鼓励消费。_[28]_
2. 支撑系统的负担不仅落在使用比特币的用户上，还有大量持有比特币的人身上。

反方论据则有：

1. 两千一百万的比特币数量限额是比特币成功的关键，
2. 系统创始人故意避开通货膨胀把比特币塑造成储存价值的工具而不是辅助的支付方式，而且
3.  现在改变规则等同于从早期用户身上偷窃（尤其但不全是那些匿名创始人）。

主要的阻力来自开发者们自己（认为这个上限是不可商讨的_[30]_）和长期比特币持有者。商户则两极分化：那些支持后者的人（保险，金库）会反对改变，而另外那些处理大量交易的人（交易所，钱包供应商）则会赞同。

尽管这次危机是完全能够根据第一原则预测而且埋藏在比特币的基石中，它仍可能产生意想不到的结果。即使比特币的供应是受限制的_[31]_，其戏剧性却是无穷的_[32]_。

_披露:_ [_作者持有比特币而且为Blockstream工作。_](https://medium.com/@rusty_lightning/disclosure-cryptocurrency-interests-4c2d16c72c9d)

* * *

#### 脚注和额外阅读材料

[1] 关于建立加密货币的复杂性在这里有详细介绍[https://download.wpsoftware.net/bitcoin/alts.pdf](https://download.wpsoftware.net/bitcoin/alts.pdf)

[2] 默认的“mintxfee”：支付该费用以下的交易不会被节点接受；这能减少来自小额交易的垃圾信息。有个例外，花费旧比特币的交易则能豁免这个限制（被称之为“优先交易”）因为它本质上是有限资源。[https://en.bitcoin.it/wiki/Transaction_fees#Settings](https://en.bitcoin.it/wiki/Transaction_fees#Settings)

[3] 默认的“dust limit”：在这限额以下的小额付款不回呗节点接受；这避免产生因经济影响过小而没人使用的小额款项。比特币的这个限制具有争议性并在这里有更多讨论[https://bitcointalk.org/index.php?topic=196138.0](https://bitcointalk.org/index.php?topic=196138.0)。困惑还陆续而来。

[4] Pay-to-script-hash 把“我需要什么证明我花费了这个比特币”这句对白给了花费者。在这之前，整个网络要记得花费每个币的特定的要求（也花费很多时间）。 [https://en.bitcoin.it/wiki/Pay_to_script_hash](https://en.bitcoin.it/wiki/Pay_to_script_hash)

[5] 费用取决于交易的大小而不是交易金额的大小。这类似于根据重量收钱的快递：寄 1000 个一美分将会比寄100美元纸币贵。虽然很有道理，但对于不知道自己拿的是纸币还是硬币的人来说还是不好估计。

[6] 近来区块的默认大小增加到 75 万字节[https://blockchain.info/charts/avg-block-size?timespan=all](https://blockchain.info/charts/avg-block-size?timespan=all)。矿工抱怨他们的“孤儿率”在增加：区块连不上整个区块链因为他们到达其他矿工所需的时间太长。对大的矿工这个问题并不大，而且他们也更可能找到下个区块。这似乎是驱动Ghash.io成长的原因：在最大的矿工群里孤儿率是最低的。[https://www.coindesk.com/bitcoin-mining-detente-ghash-io-51-issue/](https://www.coindesk.com/bitcoin-mining-detente-ghash-io-51-issue/)

[7] 2017 年 11 月，尽管Segregated Witness这项技术早在2015年年底完成，blockchain.info和Coinbase（两个都拥有大交易容量）都没有采用该项技术。

[8] 这个趋势在匿名创始人中本聪离开计划的时候开始。

[9] 不幸的是增长总是跟着优化，意味着新节点于网络同步的速度并不会比前几年快。_[10]_. [https://bitcoincore.org/en/2017/03/13/performance-optimizations-1/](https://bitcoincore.org/en/2017/03/13/performance-optimizations-1/)

[10] 把旧节点同步到新的网络上事实上是困难的，但小修整后还是可以做到的。然而在快的机器上也需要大概30秒处理一个区块。 [https://medium.com/provoost-on-crypto/historical-bitcoin-core-client-performance-c5f16e1f8ccb#874c](https://medium.com/provoost-on-crypto/historical-bitcoin-core-client-performance-c5f16e1f8ccb#874c)

[11] Matt Corallo 同时发布代码让你运行自己的高效中继网络和运行他自己的。 [http://bitcoinfibre.org/](http://bitcoinfibre.org/)

[12] 因为区块里的大部分交易都已经被看见，节点通过发送概要省下许多时间和带宽。事实上，现在平均的区块增长速度比交易增长快。[https://bitcoincore.org/en/2016/06/07/compact-blocks-faq/](https://bitcoincore.org/en/2016/06/07/compact-blocks-faq/)

[13] 一篇关于演变中的技巧和挑战的好概要：[https://blog.bitgo.com/the-challenges-of-bitcoin-transaction-fee-estimation-e47a64a61c72](https://blog.bitgo.com/the-challenges-of-bitcoin-transaction-fee-estimation-e47a64a61c72)

[14] 比特币起初支持用序列码升级还没到达区块的交易，但因为这允许客户交易挤爆网络而被取消。费用替代保留了这个功能，但需要在费用飙升的情况下。[https://bitcoincore.org/en/faq/optin_rbf/](https://bitcoincore.org/en/faq/optin_rbf/)

[15] 软件也在考虑让使用手续费的人承担部分费用而不是单让交易人支付。这样的话把两者划分在同一个区块也许有其价值：所谓的“子还父债”。[https://bitcoincore.org/en/faq/optin_rbf/#what-is-child-pays-for-parent-cpfp](https://bitcoincore.org/en/faq/optin_rbf/#what-is-child-pays-for-parent-cpfp)

[16] 隔离见证把交易签名转移到区块的其他地方。新颖的地方在于该设计中记录签名的个数仿佛这些签名只有四分之一多。如果现有的交易所有人都用这种交易，这意味着区块大小会平均在 2MB 的大小。[https://bitcoincore.org/en/2016/01/26/segwit-benefits/](https://bitcoincore.org/en/2016/01/26/segwit-benefits/)

[17] 虽然每个交易需要时间核对，但低配置的CPU也足以处理这种运算：主要限制是网络带宽还有长期的储存需求。[https://bitcoincore.org/en/2016/06/24/segwit-next-steps/#schnorr-signatures](https://bitcoinco
dff
[18] 数字货币集团（Digital Currency Group）的纽约协议的是通过很大的努力才能达成的。[https://medium.com/@DCGco/bitcoin-scaling-agreement-at-consensus-2017-133521fe9a77](https://medium.com/@DCGco/bitcoin-scaling-agreement-at-consensus-2017-133521fe9a77)

[19] “也许其他人会支付”而不是比特币用户这种说法是站不住脚的，因为这世上没有免费的午餐。[https://medium.com/@octskyward/hashing-7d04a887acc8](https://medium.com/@octskyward/hashing-7d04a887acc8)

[20] 根据现在的水平和 1c 的手续费，要支撑网络的话需要每个区块一百万个交易或是 225MB 的区块大小（中位交易大小）。以现在的区块大小则需要 20 美元交易费用。

[21] 每年 52,560 个区块，12.5 个比特币资助，还有每个区块两个比特币的费用，假设每个比特币八千每月，总共是六十亿美元。

[22] 每 210,000 个区块产生就会发生“折半”。比特币在 2009 年一月开始以 50BTC 作为报酬演变成 2012 年十一月的 25BTC，到再之后 2016 年七月的 12.5 个。你可以浏览下面的链接追踪这兴奋的变化。[http://www.thehalvening.com/](http://www.thehalvening.com/)

[23] 这假定每个区块 3BTC，稍微高于现平均水平，约等于这图表里 450BTC 一天：[https://blockchain.info/charts/transaction-fees?timespan=all#](https://blockchain.info/charts/transaction-fees?timespan=all#)

[24] 这只假设以美元计算矿工的收入与现在一样，其中一半来自手续费。

[25] 现在流行的却是：公司集资吹嘘自己在网络里有多少交易和多少份额。

[26] 如果比特币的价格大幅上升，那么矿工也许能接受小额手续费。然而如果你的公司要依靠比特币升值才能存活，那么投资者为什么不直接投资到比特币上呢？

[27] 在垄断挖矿机构能敲诈比特币商户的前提下（通过筛选交易），投资到挖矿和其分散式扩张能让对手难以针对某一商户。虽然两者仍未发生，但这做法有一定的意义。

[28] [https://en.wikipedia.org/wiki/Inflation#Positive](https://en.wikipedia.org/wiki/Inflation#Positive)

[30] [https://en.bitcoin.it/wiki/Prohibited_changes](https://en.bitcoin.it/wiki/Prohibited_changes)

[31] 我也会反对这种提议并且相信这是不可行的。但我深信有人会提出而且积极宣传。

[32] 特别注意：如果类似 Pieter Wuille 每年 17% 增长被采用了，在某个时刻容量会过剩甚至把费用减少到零而影响链的安全性。开发者理应提议一种在非繁忙时段采用最低收费的软分叉，而且和矿工一同抵抗短期用户和商户。

[33] 区块大小跟随科技进步[https://gist.github.com/sipa/c65665fc360ca7a176a6](https://gist.github.com/sipa/c65665fc360ca7a176a6)

[34] 例如 Mark Friedenbach 的 flexcap 提议，在忽略资助的情况下是最容易实现的。[https://scalingbitcoin.org/transcript/hongkong2015/a-flexible-limit-trading-subsidy-for-larger-blocks](https://scalingbitcoin.org/transcript/hongkong2015/a-flexible-limit-tra6  ding-subsidy-for-larger-blocks)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
