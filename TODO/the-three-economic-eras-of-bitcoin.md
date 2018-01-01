> * 原文地址：[The Three Economic Eras of Bitcoin](https://medium.com/@rusty_lightning/the-three-economic-eras-of-bitcoin-d43bf0cf058a)
> * 原文作者：[Rusty Russell](https://medium.com/@rusty_lightning?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-three-economic-eras-of-bitcoin.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-three-economic-eras-of-bitcoin.md)
> * 译者：
> * 校对者：

# The Three Economic Eras of Bitcoin

The way the bitcoin ecosystem will play out is written in the mathematics of its consensus rules; we should all know the three phases it will go through.

#### First Era: Satoshi’s Free Offer (2009–2014)

In the early years of bitcoin, it was obscure and unvaluable. Demand was so tiny you could send any amount for free. There was no real congestion, so software didn’t handle it, nor did business plans: gambling service Satoshidice famously sent a 1-satoshi payment to losing bets, using the infinite-capacity blockchain as a signaling layer. It was all free money.

Bitcoin was a new, barely-understood technology. It was hard enough to comprehend the interactions of its constituent parts, let alone extrapolate to what this would mean in future. Several factors made this worse:

1. The pseudonymity and lack of central authority was deeply attractive to scammers, who became pervasive enough to make the permeation of real information extremely difficult and also lead to widespread distrust.
2. The success of the system brought others who tried to replicate it (often with the main goal of simply generating money) and almost always with minimal understanding of the system._[1]_
3. The early adopters had not only the normal tribalism of an emerging clique, but a concrete financial self-interest in adoption. The resulting boosterism meant it was extremely difficult for any awkward facts to permeate the wider ecosystem.

The result there was surprisingly low awareness that this phase of “free money” was not the natural state of bitcoin. The developers _were_ aware, so added some configurable settings in the reference client to minimize the worst abuses. These rules did not change bitcoin, just the default behavior: they added a minimum fee_[2]_, stopped relaying tiny payments_[3]_, and enhanced the scripting language to reduce the size taken up by unspent outputs_[4]_.

#### Second Era: Satoshi’s Subsidy (We Are Here)

> “Bitcoin is shifting to a new economic policy, with possibly higher fees.”

> — Jeff Garzik [https://medium.com/@jgarzik/bitcoin-is-being-hot-wired-for-settlement-a5beb1df223a](https://medium.com/@jgarzik/bitcoin-is-being-hot-wired-for-settlement-a5beb1df223a)

The bursty statistical nature of block production, combined with the volatile market of bitcoin, began to produce intermittent capacity issues. These had been previously dealt with by code optimizations and tweaking settings by miners; now they became more regular and significant, causing rising awareness that the First Era was at risk.

Inevitably, many people wanted to prolong the free ride. This pressure was exacerbated by software and services unprepared for dynamic fee conditions, and the difficult nature of such fee conditions themselves: reliably guessing what fee would allow a transaction into the next block turned out to be difficult at best, and extremely difficult to present to users_[5]_.

The developers’ general reluctance to support a naive increase stemmed from several factors:

1. Previous increases on the network had driven significant centralization pressure, including a period where over half the network was under control of a single pool._[6]_
2. This would be the first backwards-incompatible change since Bitcoin’s introduction.
3. Providing a “one-off” bump risks moral hazard, as lobbying for expansion is seen as cheaper and easier than engineering improvements.
4. Despite being expected, neither software nor services were preparing for the transition. This may have been because they didn’t really believe the transition would occur._[7]_
5. The developers generally want to follow the community, not lead. Changes which are economically significant or contentious feed a narrative of developer reliance._[8]_
6. Transitions in a large, complex system need to be as gradual as possible to avoid unintended side effects. As the Third Era approaches, the Second Era provides that gradual transition, with time for software and services to gain experience with bitcoin as it will eventually be.

The developers implemented several improvements to address congestion. First among them was wide-ranging and significant optimizations_[9]_ designed to handle the network now running at capacity. Block propagation was improved by a global network of node relays_[11]_ and new strategies for better propagation_[12]_. Fee estimation algorithms became more sophisticated_[13]_, along with restoring the ability to replace transactions (by increasing the fee)_[14]_ and having the recipient boost transactions_[15]_.

Despite centralization fears of larger blocks, an opt-in block expansion_[16]_ was added which will eventually double the network throughput as software is updated to use it. Work is ongoing on packing more transactions into blocks_[17]_, which increases throughput without the centralization risks of block expansion.

It is not surprising that such efforts were seen for what they were: insufficient to maintain the First Era. Bitcoin’s use as a payment network, always awkward due to block time variance, became even harder: a whole class of payments below $20 were no longer viable. Businesses and users established in the First Era began looking longingly at alternate coins still in their own First Era, and also lobbied for relief. A significant mining monopoly had formed at this stage, and it joined these efforts._[18]_

Though these efforts failed, it’s important to note that while some who wanted the First Era to continue considered the Third Era avoidable_[19]_, many just felt it shouldn’t happen _now_. The most convincing argument was that it would harm adoption, which is a major factor for both usefulness and regulatory resistance. Unfortunately this argument never becomes less compelling, and carries all the hazards enumerated above.

It is undeniable that an increase in transaction capacity reduces the eventual burden of fees, and is the main motivation for the growth plans which were implemented in this era._[20]_

#### Third Era: Self Sufficiency (2028? onwards)

> “Once a predetermined number of coins have entered circulation, the incentive can transition entirely to transaction fees and be completely inflation free.”

> — Satoshi Nakamoto, Bitcoin: A Peer-to-Peer Electronic Cash System

Once the “free money” bootstrap phases of bitcoin are complete the system enters the phase of self-sufficiency, where users bear the cost of securing the network against double-spending (currently billions of USD each year_[21]_). This is phased in by halving the block subsidy every four years._[22]_

Current levels suggest fees will be comparable with the subsidy at the 2024 halving, and consistently dominate from 2028 onwards._[23]_

User-facing businesses established in the First Era who flourished into the Second Era will find the Third Era extremely difficult. One large business claims to be responsible for 25% of the bitcoin transactions: in 10 years they would be paying $700M per year to secure the network at current levels_[24]_. Yet no business is telling their investors about this impending cost, nor that they plan on reducing their on-chain percentage_[25]_ nor suggesting that they are depending on significant bitcoin appreciation to offset these costs_[26]_.

Miners will find the Third Era equally difficult. Directly supported by users, they will be in constant tension with them over fee levels, and in danger of having their income squeezed by large businesses or cliques of users. This may lead to further centralization, as miners consolidate under revenue pressure. This centralization may be offset by businesses choosing to invest directly in mining, however._[27]_

#### The Third Era Will Start With Civil War

The mathematics of this situation seem inevitable: The miners and businesses with large transaction volume will both decide to (re)introduce inflation. For the large-volume businesses this will externalize their costs, and for miners it’s simply “free money”. The battle lines will be similar to the early Second Era New York Agreement, but this effort will be more nuanced and far broader, with mainstream arguments such as:

1. The founder was not an economist; Economists recommend inflation around 1% to encourage spending._[28]_
2. The support burden of the network should be shared by the wealthy bitcoin holders, not just those actually using their bitcoin.

The counter-arguments are:

1. The 21 million bitcoin limit was a key reason for bitcoin’s success,
2. The system’s founder made a conscious and deliberate choice for bitcoin to be a store-of-value over subsidizing payments, by eschewing inflation, and
3.  Changing the rules now is stealing from early adopters (notably, but not mainly, the anonymous founder).

The main resistance to this change would come from the developers themselves (who feel this limit is non-negotiable_[30]_) and long-term bitcoin holders. Businesses will be divided: those which cater to the latter (insurers, vaults) will be against the change, and those with high onchain volume (exchanges, wallet providers) will be for it.

Although this crisis is entirely predictable from first principles, and laid in the bedrock of bitcoin, it may yield surprising results. And even if bitcoin’s supply remains capped_[31]_, the drama it can produce is limitless_[32]_.

_Disclosure:_ [_the author holds bitcoin and works for Blockstream._](https://medium.com/@rusty_lightning/disclosure-cryptocurrency-interests-4c2d16c72c9d)

* * *

#### Footnotes, Containing Further Reading

[1] Some of the complexity with building a cryptographic currency are detailed in [https://download.wpsoftware.net/bitcoin/alts.pdf](https://download.wpsoftware.net/bitcoin/alts.pdf)

[2] The default “mintxfee”: the fee below which normal transactions would not be accepted by nodes; this reduced spam from tiny transactions. As a compromise, transactions which were spending old bitcoins were exempt from this (so-called “priority transactions”) as they are by nature a finite resource. [https://en.bitcoin.it/wiki/Transaction_fees#Settings](https://en.bitcoin.it/wiki/Transaction_fees#Settings)

[3] The default “dust limit”: tiny payments below this would not be accepted by nodes; this avoided creating tiny payments which would never be economical to spend in future. It was considered a controversial restriction on Bitcoin, as demonstrated by [https://bitcointalk.org/index.php?topic=196138.0](https://bitcointalk.org/index.php?topic=196138.0). This foreshadows the confusion to be felt later.

[4] Pay-to-script-hash moves the “what do I need to prove to spend this bitcoin?” script to the spender. Before this, the whole network has to remember those exact requirements for spending each coin (which adds up to quite a lot over time). [https://en.bitcoin.it/wiki/Pay_to_script_hash](https://en.bitcoin.it/wiki/Pay_to_script_hash)

[5] The fee depends on the size of the transaction, and not the amount transferred. It’s analogous to a courier charging by weight: sending 1000 pennies is going to be more expensive than sending a $100 bill. That makes engineering sense, but it’s deeply counterintuitive for a user who doesn’t know if they are holding pennies or bills.

[6] The blocksize default limit increased to 750 kilobytes around this time [https://blockchain.info/charts/avg-block-size?timespan=all](https://blockchain.info/charts/avg-block-size?timespan=all). Miners complained of their “orphan rate” increasing: blocks losing the race to extend the blockchain because they took too long to reach the other miners. This problem is less for larger miners, who are more likely to find the next block as well. This seems to be the main force behind Ghash.io’s rise: orphaning will be rarest on the largest pool of miners. [https://www.coindesk.com/bitcoin-mining-detente-ghash-io-51-issue/](https://www.coindesk.com/bitcoin-mining-detente-ghash-io-51-issue/)

[7] As November 2017 neither blockchain.info nor Coinbase (both of which claim large transaction volumes) have adopted Segregated Witness, despite the technology being finalized at the end of 2015.

[8] This trend was begun by the anonymous founder Satoshi Nakamoto leaving the project.

[9] Unfortunately growth has fairly evenly tracked improvements, meaning new nodes don’t synchronize with the network any faster than they did a few years ago_[10]_. [https://bitcoincore.org/en/2017/03/13/performance-optimizations-1/](https://bitcoincore.org/en/2017/03/13/performance-optimizations-1/)

[10] It’s actually difficult to get older nodes to synchronize to the modern network, but with small fixes it’s possible. It takes about 30 seconds per block on a fast machine, however. [https://medium.com/provoost-on-crypto/historical-bitcoin-core-client-performance-c5f16e1f8ccb#874c](https://medium.com/provoost-on-crypto/historical-bitcoin-core-client-performance-c5f16e1f8ccb#874c)

[11] Matt Corallo both releases code to run your own global high-performance relay network, and runs one himself. [http://bitcoinfibre.org/](http://bitcoinfibre.org/)

[12] Since most transactions contained in a block have already been seen, nodes save a lot of bandwidth and time by sending a summary. Average block propagation is now faster than transaction propagation, in fact. [https://bitcoincore.org/en/2016/06/07/compact-blocks-faq/](https://bitcoincore.org/en/2016/06/07/compact-blocks-faq/)

[13] An excellent summary of evolving techniques and challenges: [https://blog.bitgo.com/the-challenges-of-bitcoin-transaction-fee-estimation-e47a64a61c72](https://blog.bitgo.com/the-challenges-of-bitcoin-transaction-fee-estimation-e47a64a61c72)

[14] Bitcoin originally supported upgrading transactions which weren’t in blocks yet using a sequence number, but this was removed as it allowed users to flood the network with transactions. Replace-by-fee restores this ability, but only if the fee increases significantly. [https://bitcoincore.org/en/faq/optin_rbf/](https://bitcoincore.org/en/faq/optin_rbf/)

[15] Instead of just considering the fees paid by a transaction, software also considers the fees paid by any transactions which spend this it, which might make it worth including both in the block: so-called “child-pays-for-parent”. [https://bitcoincore.org/en/faq/optin_rbf/#what-is-child-pays-for-parent-cpfp](https://bitcoincore.org/en/faq/optin_rbf/#what-is-child-pays-for-parent-cpfp)

[16] Segregated Witness moves signatures of transactions which support it to elsewhere in the block. The design counts those signatures (which are not seen by older nodes) as if they were 1/4 of the size; on current transactions patterns this would mean an average block of about 2MB if all users were to use such transactions. [https://bitcoincore.org/en/2016/01/26/segwit-benefits/](https://bitcoincore.org/en/2016/01/26/segwit-benefits/)

[17] While each transaction takes time to validate, even low-end CPUs are now powerful enough: the main capacity constraints are network bandwidth and long-term storage requirements. [https://bitcoincore.org/en/2016/06/24/segwit-next-steps/#schnorr-signatures](https://bitcoincore.org/en/2016/06/24/segwit-next-steps/#schnorr-signatures) and [https://bitcoincore.org/en/2016/06/24/segwit-next-steps/#mast](https://bitcoincore.org/en/2016/06/24/segwit-next-steps/#mast)

[18] The most serious effort was Digital Currency Group’s New York Agreement: [https://medium.com/@DCGco/bitcoin-scaling-agreement-at-consensus-2017-133521fe9a77](https://medium.com/@DCGco/bitcoin-scaling-agreement-at-consensus-2017-133521fe9a77)

[19] The argument that “maybe someone else will pay for it” instead of bitcoin users seems unsupportable by a reality in which Santa Claus does not exist. [https://medium.com/@octskyward/hashing-7d04a887acc8](https://medium.com/@octskyward/hashing-7d04a887acc8)

[20] At current levels, and 1c transaction fees, it would take 1 million transactions per block to support the network, or a 225MB block size (median transaction size). With current block size, it would require $20 transaction fees.

[21] 52,560 blocks per year, 12.5 bitcoin subsidy and 2 bitcoin fee per block, $8000 USD/BTC = 6 billion USD.

[22] The “halvening” happens every 210,000 blocks. Bitcoin was launched with a 50BTC block reward in January 2009, becoming 25BTC in November 2012 and 12.5BTC in July 2016\. You can follow the excitement at [http://www.thehalvening.com/](http://www.thehalvening.com/)

[23] This assumes fee levels of 3 BTC per block, which is slightly higher than the average current levels. That corresponds to about 450 BTC a day on this chart: [https://blockchain.info/charts/transaction-fees?timespan=all#](https://blockchain.info/charts/transaction-fees?timespan=all#)

[24] This assumes only that miners are receiving the same USD income as now, but half is from fees.

[25] The current trend seems to be the opposite: companies raising funds brag about how dominant they are on the network in terms of transactions.

[26] If the bitcoin price rises significantly, then miners may be fine with smaller fees. However, if your business plan relies on a significant bitcoin price increase, wouldn’t investors just buy bitcoin instead of investing in your business?

[27] Given the exposure of bitcoin businesses to extortion by a mining cartel (who could profitably censor their transactions), investing in mining makes sense, as does development of fungibility improvements to make targeting companies more difficult. Neither has yet occurred from large businesses, though.

[28] [https://en.wikipedia.org/wiki/Inflation#Positive](https://en.wikipedia.org/wiki/Inflation#Positive)

[30] [https://en.bitcoin.it/wiki/Prohibited_changes](https://en.bitcoin.it/wiki/Prohibited_changes)

[31] I would oppose such a proposal, too, and believe it would fail. But I’m convinced it will be seriously proposed and adamantly promoted.

[32] Of particular note: if some capacity growth like Pieter Wuille’s 17% growth per-annum is adopted_[33]_, at some point there may be excess capacity again, driving fees to zero and threatening the security of the chain. The developers will presumably propose a soft fork implementing some kind of lower limit in non-busy periods_[34]_, and miners can be anticipated to side with the developers against the short-term users and businesses.

[33] Block size following technological growth [https://gist.github.com/sipa/c65665fc360ca7a176a6](https://gist.github.com/sipa/c65665fc360ca7a176a6)

[34] Such as Mark Friedenbach’s flexcap proposal, which is simplest to implement once the subsidy can be ignored. [https://scalingbitcoin.org/transcript/hongkong2015/a-flexible-limit-trading-subsidy-for-larger-blocks](https://scalingbitcoin.org/transcript/hongkong2015/a-flexible-limit-tra6  ding-subsidy-for-larger-blocks)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
