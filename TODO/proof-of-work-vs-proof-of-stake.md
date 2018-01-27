> * 原文地址：[Proof of Work vs Proof of Stake: Basic Mining Guide](https://blockgeeks.com/guides/proof-of-work-vs-proof-of-stake/)
> * 原文作者：[Ameer Rosic](https://blockgeeks.com/author/ameerrosic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/proof-of-work-vs-proof-of-stake.md](https://github.com/xitu/gold-miner/blob/master/TODO/proof-of-work-vs-proof-of-stake.md)
> * 译者：
> * 校对者：

Recently you might have heard about the idea to move from an Ethereum consensus based on the Proof of Work (PoW) system to one based on the so-called Proof of Stake.

In this article, I will explain to you the main differences between Proof of Work vs Proof of Stake and I will provide you a definition of mining, or the process new digital currencies are released through the network.

Also, what will change regarding mining techniques if the [Ethereum](http://blockgeeks.com/guides/what-is-ethereum/) community decides to do the transition from “work” to “stake”?

This article wants to be a basic guide to understanding the problem above.

![Proof of Work vs Proof of Stake: Basic Mining Guide](http://blockgeeks.com/wp-content/uploads/2017/03/infographics2017-01.png)

## What is the Proof of work?

First of all, let’s start with basic definitions.

Proof of work is a protocol that has the main goal of deterring cyber-attacks such as a distributed denial-of-service attack (DDoS) which has the purpose of exhausting the resources of a computer system by sending multiple fake requests.

The Proof of work concept existed even before [bitcoin](http://blockgeeks.com/guides/what-is-bitcoin-a-step-by-step-guide/), but Satoshi Nakamoto applied this technique to his/her – we still don’t know who Nakamoto really is – digital currency revolutionizing the way traditional transactions are set.

In fact, PoW idea was originally published by Cynthia Dwork and Moni Naor back in 1993, but the term “proof of work” was coined by Markus Jakobsson and Ari Juels in a document published in 1999.

But, returning to date, Proof of work is maybe the biggest idea behind the Nakamoto’s Bitcoin white paper – published back in 2008 – because it allows trustless and distributed consensus.

## What’s trustless and distributed consensus?

A trustless and distributed consensus system means that if you want to send and/or receive money from someone you don’t need to trust in third-party services.

When you use traditional methods of payment, you need to trust in a third party to set your transaction (e.g. Visa, Mastercard, PayPal, banks). They keep their own private register which stores transactions history and balances of each account.

The common example to better explain this behavior is the following: if Alice sent Bob $100, the trusted third-party service would debit Alice’s account and credit Bob’s one, so they both have to trust this third-party is to going do the right thing.

With [bitcoin](http://blockgeeks.com/guides/what-is-bitcoin-a-step-by-step-guide/) and a few other [digital currencies](http://blockgeeks.com/guides/what-is-cryptocurrency/), everyone has a copy of the ledger (blockchain), so no one has to trust in third parties, because anyone can directly verify the information written.

![What is Blockchain Technology? A Step-by-Step Guide For Beginners](http://blockgeeks.com/wp-content/uploads/2016/09/home.jpg)

## Proof of work and mining

Going deeper, proof of work is a requirement to define an expensive computer calculation, also called mining, that needs to be performed in order to create a new group of trustless transactions (the so-called block) on a [distributed ledger called blockchain](http://blockgeeks.com/guides/what-is-blockchain-technology/).

Mining serves as two purposes:

1. To verify the legitimacy of a transaction, or avoiding the so-called double-spending;

2. To create new digital currencies by rewarding miners for performing the previous task.

**When you want to set a transaction this is what happens behind the scenes:**

* Transactions are bundled together into what we call a block;
* Miners verify that transactions within each block are legitimate;
* To do so, miners should solve a mathematical puzzle known as proof-of-work problem;
* A reward is given to the first miner who solves each blocks problem;
* Verified transactions are stored in the public blockchain

This “mathematical puzzle” has a key feature: asymmetry. The work, in fact, must be moderately hard on the requester side but easy to check for the network. This idea is also known as a CPU cost function, client puzzle, computational puzzle or CPU pricing function.

All the network miners compete to be the first to find a solution for the mathematical problem that concerns the candidate block, a problem that cannot be solved in other ways than through brute force so that essentially requires a huge number of attempts.

When a miner finally finds the right solution, he/she announces it to the whole network at the same time, receiving a cryptocurrency prize (the reward) provided by the protocol.

From a technical point of view, mining process is an operation of inverse hashing: it determines a number (nonce), so the cryptographic hash algorithm of block data results in less than a given threshold.

This threshold, called difficulty, is what determines the competitive nature of mining: more computing power is added to the network, the higher this parameter increases, increasing also the average number of calculations needed to create a new block. This method also increases the cost of the block creation, pushing miners to improve the efficiency of their mining systems to maintain a positive economic balance. This parameter update should occur approximately every 14 days, and a new block is generated every 10 minutes.

Proof of work is not only used by the bitcoin blockchain but also by ethereum and many other blockchains.

Some functions of the proof of work system are different because created specifically for each blockchain, but now I don’t want to confuse your ideas with too technical data.

The important thing you need to understand is that now [Ethereum developers](http://courses.blockgeeks.com/) want to turn the tables, using a new consensus system called proof of stake.

## What is a proof of stake?

Proof of stake is a different way to validate transactions based and achieve the distributed consensus.

It is still an algorithm, and the purpose is the same of the proof of work, but the process to reach the goal is quite different.

Proof of stake first idea was suggested on the bitcointalk forum back in 2011, but the first digital currency to use this method was Peercoin in 2012, together with ShadowCash, Nxt, BlackCoin, NuShares/NuBits, Qora and Nav Coin.

Unlike the proof-of-Work, where the algorithm rewards miners who solve mathematical problems with the goal of validating transactions and creating new blocks, with the proof of stake, the creator of a new block is chosen in a deterministic way, depending on its wealth, also defined as stake.

No block reward.

Also, all the digital currencies are previously created in the beginning, and their number never changes.

This means that in the PoS system there is no block reward, so, the miners take the transaction fees.

This is why, in fact, in this PoS system miners are called forgers, instead.

## Why Ethereum wants to use PoS?

The Ethereum community and its creator, Vitalik Buterin, are planning to do a [hard](http://blockgeeks.com/omg-ethereum-hard-forked/) [fork](http://blockgeeks.com/omg-ethereum-hard-forked/) to make a transition from proof of work to proof of stake.

But why they want to switch from one to the other?

In a distributed consensus-based on the proof of Work, miners need a lot of energy. One Bitcoin transaction required the same amount of electricity as powering [1.57 American households](http://blockgeeks.com/bitcoins-energy-consumption/) for one day [(data from 2015](http://blockgeeks.com/bitcoins-energy-consumption/)).

And these energy costs are paid with fiat currencies, leading to a constant downward pressure on the digital currency value.

In a recent research, experts argued that bitcoin transactions may consume as much electricity as Denmark by 2020.

Developers are pretty worried about this problem, and the Ethereum community wants to exploit the proof of stake method for a more greener and cheaper distributed form of consensus.

Also, rewards for the creation of a new block are different: with Proof-of-Work, the miner may potentially own none of the digital currency he/she is mining.

In Proof-of-Stake, forgers are always those who own the coins minted.

## How are forgers selected?

If Casper (the new proof of stake consensus protocol) will be implemented, there will exist a validator pool. Users can join this pool to be selected as the forger. This process will be available through a function of calling the Casper contract and [sending Ether](http://blockgeeks.com/guides/digital-wallet-guide/) – or the coin who powers the Ethereum network – together with it.

* * *

> **![What is Blockchain Technology? A step-by-step guide than anyone can understand](http://blockgeeks.com/wp-content/uploads/2016/09/Vitalik-Buterin.png)**
> 
> **“You automatically get inducted after some time,” explained Vitalik Buterin himself on a post shared on Reddit.**

* * *

“There is no priority scheme for getting inducted into the validator pool itself; anyone can join in any round they want, irrespective of the number of other joiners,” he continued.

The reward of each validator will be “somewhere around 2-15%, ” but he is not sure yet.

Also, Buterin argued that there will be no imposed limit on the number of active validators (or forgers), but it will be regulated economically by cutting the interest rate if there are too many validators and increasing the reward if there are too few.

## A safer system?

Any computer system wants to be free from the possibility of hacker attacks, especially if the service is related to money.

So, the main problem is: proof of stake is safer than proof of work?

Experts are worried about it, and there are several skeptics in the community.

Using a Proof-of-Work system, bad actors are cut out thanks to technological and economic disincentives.

In fact, programming an attack to a PoW network is very expensive, and you would need more money than you can be able to steal.

Instead, the underlying PoS algorithm must be as bulletproof as possible because, without especially penalties, a proof of stake-based network could be cheaper to attack.

To solve this issue, Buterin created the Casper protocol, designing an algorithm that can use the set some circumstances under which a bad validator might lose their deposit.

He explained: “Economic finality is accomplished in Casper by requiring validators to submit deposits to participate, and taking away their deposits if the protocol determines that they acted in some way that violates some set of rules (‘slashing conditions’).”

Slashing conditions refer to the circumstances above or laws that a user is not supposed to break.

## Conclusion

Thanks to a PoS system validators do not have to use their computing power because the only factors that influence their chances are the total number of their own coins and current complexity of the network.

So this possible future switch from PoW to PoS may provide the following benefits:

1. Energy savings;

2. A safer network as attacks become more expensive: if a hacker would like to buy 51% of the total number of coins, the market reacts by fast price appreciation.

This way, CASPER will be a security deposit protocol that relies on an economic consensus system. Nodes (or the validators) must pay a security deposit in order to be part of the consensus thanks to the new blocks creation. Casper protocol will determine the specific amount of rewards received by the validators thanks to its control over security deposits.

If one validator creates an “invalid” block, his security deposit will be deleted, as well as his privilege to be part of the network consensus.

In other words, the Casper security system is based on something like bets. In a PoS-based system, bets are the transactions that, according to the consensus rules, will reward their validator with a money prize together with each chain that the validator has bet on.

So, Casper is based on the idea that validators will bet according to the others’ bets and leave positive feedbacks that are able accelerates consensus.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
