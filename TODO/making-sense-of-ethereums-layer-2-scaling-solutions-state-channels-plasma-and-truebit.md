> * 原文地址：[Making Sense of Ethereum’s Layer 2 Scaling Solutions: State Channels, Plasma, and Truebit](https://medium.com/l4-media/making-sense-of-ethereums-layer-2-scaling-solutions-state-channels-plasma-and-truebit-22cb40dcc2f4)
> * 原文作者：[Josh Stark](https://medium.com/@jjmstark?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/making-sense-of-ethereums-layer-2-scaling-solutions-state-channels-plasma-and-truebit.md](https://github.com/xitu/gold-miner/blob/master/TODO/making-sense-of-ethereums-layer-2-scaling-solutions-state-channels-plasma-and-truebit.md)
> * 译者：JohnJiangLA
> * 校对者：

# 带你了解以太坊第2层扩容方案：State Channels、Plasma 和 Truebit

![](https://cdn-images-1.medium.com/max/800/1*XTjr9JD25uUluY_QVQ_RaA.jpeg)

宾夕法尼亚州 Tunkhannock 地区铁路高架桥（[cc](https://www.flickr.com/photos/library_of_congress/5715531287)）。古罗马的建筑理念在新时代的使用。

对于以太坊来说 [2018 是基础建设的一年](https://twitter.com/L4ventures/status/953041925241757697)。今年会是对它早期采用技术进行网络负载考验的一年，版本更新主要关注用于扩展以太坊的技术。

**以太坊至今仍处于成长初期。**现今，它还不是安全或者可扩展的(https://twitter.com/VladZamfir/status/838006311598030848)。技术人员能够很清楚的认识到这一点。但是在去年，ICO 驱动的炒作已经开始夸大目前的网络能力。构建一个安全，易于使用的分散式互联网，受约于一套通用经济规范并被无数人使用，以太坊和 web3 提出的这一美好承诺就在眼前，但[只有在建立关键基础设施之后才能够实现](https://twitter.com/granthummer/status/957353619736559616)。

致力于构建这种基础架构和扩展以太坊性能的项目通常被称为**扩展方案（scaling solutions）**。这些项目有不同的形式，并且通常相互兼容或互补。

在这篇长帖中，我想要深入讲解**一**种扩展方案：**“off-chain” 或 “第二层（layer 2）” 方案。**

*   **第一**，我们会概略的讨论下以太坊（以及所有公用的区块链）的扩展难题。
*   **第二**，我们将介绍解决扩展挑战的不同方法，区分 “layer 1” 和 “layer 2” 解决方案。
*   **第三**，我们会深入了解第二层（layer 2）解决方案并详细解释它是怎样运作的，我们会谈及 [**state channels**](https://medium.com/l4-media/generalized-state-channels-on-ethereum-de0357f5fb44)**, P**[**lasma**](http://plasma.io/)**, 和** [**Truebit**](http://truebit.io)。

**本文的重点是向读者提供对于第二层（layer 2）解决方案工作原理全面彻底的概念层面理解。**但我们不会深入研究代码或特定实现。相反，我们专注理解用于理解构建这些系统的经济机制以及所有第二层技术之间共同的思维模式。

* * *

### 1. 公用区块链的扩展难题

首先，你要知道“扩展”不是一个单一的、特定的问题，**它涉及了一系列难题，必须解决这些难题才能使以太坊对全球无数用户可用。**

最常讨论的扩展难题是交易通量。目前，以太坊每秒可以处理大约15笔交易，而 Visa 的处理能力则大约在 45,000/tps。在去年，一些应用程序（比如 [Cryptokitties](http://cryptokitties.co)或偶尔的 ICO）已经足够流行以至于“放缓了”网络速度并提升了 [gas（给挖矿者的费用）](https://myetherwallet.github.io/knowledge-base/gas/what-is-gas-ethereum.html) 价格。

**公用区块链（比如以太坊）最关键的缺陷是要求每一笔交易要被网络中的每一个节点处理。**一笔支付，Cryptokitty 的诞生，部署新的 ERC20 合约，每一个以太坊区块链上发生的操作都必须由网络中的每个节点并行执行。这是设计理念决定的，也正是由于这种设计理念才使得公用区块链具有权威性。节点不需要依赖**其他**节点来告诉他们当前区块链的当前状态，它们会自己计算出来。

**这给以太坊的交易通量带来了根本性的限制：**它不能高于我们愿意达到的对于单个节点的要求。

我们**可以**要求每个节点做更多的工作，如果我们将块大小加倍(例如，区块 gas 限制)，这意味着每个节点处理每个区块的工作量大致是之前的两倍。但是这是以分散化为代价的：节点要做更多的工作意味着性能较差的计算机（比如用户设备）可能会从网络中退出，并且挖矿也会更向性能强大的节点运营者集中。

相反，我们需要一种方式使区块链**做更多有用的事**，但并不增加单个节点的工作量。

从概念上来说，[有两种可能解决这个问题的方法](https://blog.ethereum.org/2018/01/02/ethereum-scalability-research-development-subsidy-programs/)：

#### **一. 如果每个节点不必并行处理每个操作，会怎样？**

第一种方法是抛弃我们的前提，如果我们可以构建一个每个节点不必处理每个操作的区块链，会怎样？如果网络分为两个部分代替原有网络，每一个部分都可以独立运行，会怎样？

A 部分可以处理一批交易，而同时 B 部分可以处理另一批。这实际上会使区块链的交易通量翻倍。因为我们的限制现在能够被**两**个节点同时处理。如果我们可以将区块链分为许多不同的部分，那么我们可以将区块链的吞吐量提高很多倍。

这是**分片（sharding）**的思维模式，Vitalik’s [Ethereum Research group](http://ethereumresearch.org/) 和其他社群正在研究的一种扩展方案。一个区块链被分割成叫做 **shards** 的不同部分，每一个部分都可以独立处理交易。因为分片是在以太坊的基础级协议中实现的，所以通常被也称为**第一层（layer 1）**扩展解决方案，如果你想了解更多有关分片的内容，请查看 [extensive FAQ](https://github.com/ethereum/wiki/wiki/Sharding-FAQ) 和[这篇博文](https://medium.com/@icebearhww/ethereum-sharding-and-finality-65248951f649)。

![](https://cdn-images-1.medium.com/max/800/1*mPCgXycICNjuscoFt974fQ.png)

#### **二. 如果我们能够从以太坊现有能力中压榨出更多有用的业务操作**

第二种选择的方向则相反：不是增加以太坊区块链本身的容量，**如果我们可以通过我们已经拥有的能力来做更多的事情，会怎样？**在基础级别以太坊区块链的生产力都是相同的，但是实际上，我们可以做更多对人和应用程序有用的操作，比如交易，游戏中的状态更新，或者简单的计算。

这是 “off-chain” 技术背后的思维逻辑，比如 [**state channels**](https://medium.com/l4-media/generalized-state-channels-on-ethereum-de0357f5fb44)**，**[**Plasma**](http://plasma.io/)**，和** [**Truebit**](http://truebit.io)**。**虽然其中每个解决方案都在解决一个不同的问题，它们都通过执行 “off chain” 操作而不是以太坊区块链运行。同时仍然保证足够的安全性和权威的。

这些也被称为**第二层（layer 2）**解决方案，因为它们建立在以太坊主链“之上”。他们不需要更改基本级别的协议，相反，它们只是作为作为以太坊上的智能合约，用于与 off-chain 软件进行交互。

![](https://cdn-images-1.medium.com/max/800/1*TSKyc_gKn8kj0p-27nGQ-A.png)

### **2. 第二层（layer 2）解决方案是加密经济解决方案**

在深入了解第二层解决方案的细节之前，了解下使其可行的潜在细节是非常重要的。

公用区块链的基本力量在于 [加密经济合约](https://hackernoon.com/making-sense-of-cryptoeconomics-5edea77e4e8d)。通过调整激励措施并用软件和加密措施保护激励，我们可以创建一个就内部状态达成一致的稳定计算机网络。这是[中本聪的白皮书](https://bitcoin.org/bitcoin.pdf)的关键内容，现已应用于许多不同的公用区块链（包括比特币和以太坊）的设计中。

除了一些极端的情况下（比如 51% 攻击），**加密经济合约给了我们一个确定的稳定核心**。我们知道 on-chain 操作（比如支付，智能合约）可以看做写入去执行。

**第二层（layer 2）解决方案背后的关键是我们可以将这个核心内核的确定性用作锚点，一个可以附加其他经济机制的固定点**。这种**第二层**经济机制可以扩展公用区块链的可用性。让我们**脱离**区块链进行交互操作，并且在需要的情况下仍能可靠地重归到核心链上。

这些构建在以太坊“之上”的层并不总是与 on-chain 操作具有相同的保证。但是，它们仍然具备**足够的权威性，安全性已经可用性**，特别是在终端的略微减少时我们能够更快的执行操作或消耗更低的日常成本。

**加密经济并不是随着中本聪的白皮书而开始或结束**，它是最适合我们去学习应用的技术主体。不仅存在于核心协议的设计中，也存在于第二层系统的设计中，它们扩展了底层区块链的功能性。

#### **一. 状态通道（State channels）**

状态通道（State Channel）是一种用于在“链下”执行交易和其他状态更新的技术。可是，一个状态渠道通道“中”发生的事务扔保持了很高的安全性和权威性。如果出现任何问题，我们仍然可以选择重归到“稳固内核”的权威性上，这种权威性是建立在 on-chain 交易基础上的。

大部分读者会熟悉存在多年的概念——**支付通道（payment channel）**，它最近通过[闪电网络（lightning network）](http://lightning.network/)在比特币上实现了。状态通道是支付通道的泛化的形式，它不仅可用于支付，还可用于区块链上任意的“状态更新”，比如智能合约中的更改。在 2015 年，Jeff Coleman [第一次详细介绍](http://www.jeffcoleman.ca/state-channels/)了状态通道。

解释状态通道的运作方式的最佳方法就是看一个样例。请记住这是一个概念性的解释，也就是说我们不会牵涉到具体实现的技术细节。

现在试想一下，爱丽丝和鲍勃想玩一场井字游戏，赢家可以获得一个以太。实现这一目的的最简单方法就是在以太坊上创建一个智能合约，实现井字游戏规则并跟踪每个玩家的动作。每次玩家想要移动时，他们都会向合约发送一个交易。当一名玩家获胜时，会根据规则合约会付给赢家 1 以太。

这样是可行的，但是效率低下且速度慢。爱丽丝和鲍勃正在使用**整个以太网络**处理他们的游戏过程，这对于他们的需求来说有点不合时宜。他们每一步都需要支付挖矿费用（gas），并且还要在下一步之前都要**等待**挖矿完成。

**不过，我们可以设计一个新的系统，它能使爱丽丝和鲍勃在井字游戏的过程中产生尽可能少的 on-chain 操作。**爱丽丝和鲍勃能够以 off-chain 的方式更性游戏状态，同时在需要时仍能将其重归到以太坊主链上。我们将这样一个系统称之为“状态通道”。

首先，我们在以太坊主链上创建一个能够理解井字游戏规则的智能合约 “Judge”，同时它也能够认定爱丽丝和鲍勃是我们游戏中的两位玩家。该合约持有一个以太的奖励。

然后，爱丽丝和鲍勃开始玩游戏。爱丽丝创建并签署一个交易，它描述了她游戏的第一步，然后将其发送给鲍勃，鲍勃也签署了它，并将签名后的版本发回再保留一份副本。然后鲍勃也创建并签署一个描述他第一步的交易，并发送给爱丽丝，她也会签署它并将它返发回再保留一份副本，他们每一次都会这样互相更新游戏的当前状态。每一笔交易都包含一个“随机数”，这样我们就可以直接知道游戏中走棋的顺序。

**到目前为止，还没有发生任何 on-chain 的操作。**爱丽丝和鲍勃只是通过互联网**向彼此**发送交易，但没有任何事情涉及到区块链。但是，所有交易都可以发送给 Judge 合约，也就是说，它们是有效的以太坊交易。你可以把这看做两人在彼此来回写一系列经过区块链认证的支票。**实际上，并没有钱从银行中存入或取出，但是他俩都有一堆可以随时存入的支票。**

当爱丽丝和鲍勃结束游戏时（可能是因为爱丽丝赢了），他们可以通过向 Judge 合约提交最终状态（比如，交易列表）来**关闭**该通道，这样就只用付一次交易费用。Judge 会确定双方都签署了这个“最终状态”，并等待一段时间来确保没人会对结果提出合理质疑，然后向爱丽丝支付 1 以太奖励。

**为什么我们需要设置一个让 Judge 合约等待一下的"质疑时间"**

假设，鲍勃并没有给 Judge 发送一份**真实**的最终状态，而是发送一份**之前**他赢了爱丽丝的状态。这时 Judge 是一个非智能合约，它自己根本无法得知这个状态是否是最近的状态。

而质疑时间给了爱丽丝一个机会能够证明鲍勃提交了虚假的游戏最终状态。如果有更近期的状态，她就会有一份已签名交易的副本，并可以将其提供给 Judge。Judge 可以通过检查随机数来判断爱丽丝的版本是否更新，然后鲍勃盗取胜利的企图就被驳回了。

#### **特性和限制**

State channels are useful in many applications, where they are a strict improvement over doing operations on-chain. However, it’s important to keep in mind the particular tradeoffs that have been made when deciding whether an application is suitable for being channelized:
状态通道在许多应用中都很有用，它对执行 on-chain 操作时有严密的改进。但在决定应用程序是否适合被通道化时，请特别注意已经成立的部分交易：

*   **状态通道依赖于可靠性。**如果爱丽丝在质疑时间内下线了（也许是鲍勃不顾一切地想要赢下奖品而破坏了她家的互联网连接），她可能无法在质疑时间内做出回应。但是，爱丽丝可以向付款给其他人来保存一份她状态的副本并作为她的代表保持可靠性。
*   **They’re particularly useful where participants are going to be exchanging _many_ state updates over a long period of time.** This is because there is an initial cost to _creating_ a channel in deploying the Judge contract. But once it is deployed, the cost per state update inside that channel is extremely low.
*   **State channels are best used for applications with a defined set of participants.** This is because the Judge contract must always know the entities (i.e. addresses) that are part of a given channel. We can add and remove people, but it requires a change to the contract each time.
*   **State channels have strong privacy properties**, because everything is happening “inside” a channel between participants, rather than broadcast publicly and recorded on-chain. Only the opening and closing transactions must be public.
*   **State channels have instant finality**, meaning that as soon as both parties sign a state update, it can be considered final. Both parties have a very high guarantee that, if necessary, they can “enforce” that state on-chain.
*   ****

At L4, we’re building [**Counterfactual**](https://counterfactual.com/)**:** a framework for generalized state channels on ethereum. Our general purpose, modular implementation will let developers use state channels in their application without needing to be state channel experts themselves. You can read more about the project [here](https://medium.com/l4-media/generalized-state-channels-on-ethereum-de0357f5fb44). We’ll be releasing a paper describing our technique in Q1 2018.

The other notable state channels project for ethereum is [Raiden](https://raiden.network/), which is currently focused on building a network of _payment_ channels, using a similar paradigm as the [lightning network](http://lightning.network). This means that rather than have to open up a channel with the specific person(s) you want to transact with, you can open up a single channel with an entity connected to a much larger network of channels, enabling you to make payments to anyone else connected to the same network without additional fees.

In addition to Counterfactual and Raiden, there are several application-specific channel implementations on ethereum. For instance, Funfair has built state channels (which they call “[Fate channels](https://funfair.io/state-channels-in-disguise/)”) for their decentralized gambling platform, Spankchain has built [one-way payment channels](https://twitter.com/SpankChain/status/932801441793585152) for adult performers (they also [used a state channel for their ICO](https://github.com/SpankChain/old-sc_auction)), and [Horizon Games](https://horizongames.co/) is using state channels in their first ethereum-based game.

#### II. Plasma

On August 11 2017, Vitalik Buterin and Joseph Poon released a paper titled [_Plasma: Autonomous Smart Contracts_](http://plasma.io/plasma.pdf). The paper introduced a novel technique that could enable ethereum to reach many more transactions per second than currently possible.

Like state channels, Plasma is a technique for conducting off-chain transactions while relying on the underlying ethereum blockchain to ground its security. **But Plasma takes the idea in a new direction, by allowing for the creation of “child” blockchains attached to the “main” ethereum blockchain.** These child-chains can, in turn, spawn their own child-chains, who can spawn their own child-chains, and so on.

The result is that we can perform many complex operations at the child-chain level, running entire applications with many thousands of users, with only minimal interaction with the ethereum main-chain. **A Plasma child-chain can move faster, and charge lower transaction fees, because operations on it do not need to be replicated across the entire ethereum blockchain.**

![](https://cdn-images-1.medium.com/max/800/0*44PC3oIBMgugPDph.)

plasma.io/plasma.pdf

In order to understand how Plasma works, let’s walk through an example of how it could be used.

Let’s imagine that you’re creating a trading-card game on ethereum. The cards will be ERC 721 non-fungible tokens (like Cryptokitties), but have certain features and attributes that lets users play against each other — like in Hearthstone, or Magic the Gathering. These kinds of complex operations are expensive to do on-chain, so you decide to use Plasma instead for your application.

**First, we create a set of smart-contracts on ethereum main-chain that serve as the “Root” of our Plasma child-chain.** The Plasma root contains the basic “state-transition rules” of our child chain (things like “transactions cannot spend assets that have already been spent”), records hashes of the child-chain’s state, and serves as a kind of “bridge” that lets users move assets between the ethereum main-chain and the child-chain.

Then, we create our child-chain. The child-chain can have its own consensus algorithm — in this example, let’s say that it uses [Proof of Authority (PoA)](https://en.wikipedia.org/wiki/Proof-of-authority), a simple consensus mechanism that relies on trusted block producers (i.e. validators). Block producers are analogous to _miners_ in a “Proof of Work” system — they are the nodes that receive transactions, form blocks, and collect transaction fees. Let’s keep our example simple, and say that you (the company that created the game) are the _only_ entity that is creating blocks — i.e. your company runs a few nodes that are the block producers for our child-chain.

Once the child-chain is created and active, the block producers make periodic commitments to the root contract. This means they are effectively saying “I commit that the most recent block in the child-chain is X”. These commitments are recorded on-chain in the Plasma root as a proof of what has happened in the child-chain.

Now that the child-chain is ready, we can create the basic components of our trading card game. The cards themselves are [ERC721](https://github.com/ethereum/eips/issues/721)’s, initially created on the ethereum main-chain, and then moved onto the child-chain through the plasma root. **This introduces a crucial point: Plasma lets us scale interactions with blockchain-based digital assets, but those assets should be created first on the ethereum-main chain.** Then, we deploy the actual game application smart-contracts on the child-chain, which contains all of the game logic and rules.

**When a user wants to play our game, they are _only interacting with the child chain_.** They can hold assets (the ERC721 cards), buy and trade them for ether, play rounds of the game against other users — whatever our game lets them do — without ever interacting directly with the main-chain. Because only a much smaller number of nodes (i.e. block producers) have to process transactions, fees can be much lower and operations can be faster.

#### **But how can this be safe?**

By moving more operations off the main-chain and onto a child-chain, it’s clear we can perform more operations. But how secure is it? Are transactions that happen on the child-chain actually considered final? After all, we’ve just described a system where _a single entity_ controls the block production for our child chain. Isn’t that centralized? **Can’t the company steal your funds or take your collectible cards whenever it wants?**

The short answer is that _even in a scenario_ where a single entity controls 100% of block production on a child chain, Plasma gives you a basic guarantee that **you can always withdraw your funds and assets back onto the main chain.** If a block producer starts acting maliciously, the worst that can happen is they force you to leave the child-chain.

Let’s walk through a few different ways block producers could behave badly, and see how Plasma deals with those scenarios.

**First, imagine that a block producer tries to cheat you by lying — by creating a _fake_ new block where suddenly your funds are controlled by them.** They are the _only_ block producer, so they’re free to introduce a new block that doesn’t actually follow the rules of our blockchain. Just like other blocks, they will have to publish a commitment to the Plasma root contract containing evidence of this block.

As mentioned above, the user always has an ultimate guarantee that they can withdraw their assets back to main-chain. In this scenario, the user (or rather an application acting on their behalf) would detect the attempted theft, and withdraw before the block producer can try and use the assets they’ve “stolen”.

Plasma also creates a mechanism to prevent fraud short of withdrawing to main-chain. Plasma includes a mechanism whereby anyone — including you — can publish a _fraud proof_ to the root contract, to try and show that the block producer has cheated. This fraud proof would contain information about the previous block, and allows us to show that according to the state-transition rules of the child-chain, the false block doesn’t properly follow from the previous state. If fraud is proven, the child-chain is “rolled back” to the previous block. Even better, we construct a system where any block producer who signed off on the false block is penalized by losing an on-chain deposit.

![](https://cdn-images-1.medium.com/max/800/0*Xgnr1Hv-KhckkbvV.)

plasma.io/plasma.pdf

**But submitting a fraud proof requires having access to the underlying data — i.e. the actual history of blocks that are used to prove the fraud.** What if the block producers are _also_ not sharing information about previous blocks, to prevent Alice from being able to submit a fraud proof to the root contract?

In this case, the solution is for Alice to withdraw her funds and leave the child-chain. Essentially Alice submits a “Proof of Funds” to the root contract. After a delay period during which anyone can challenge her proof (e.g. to show she actually spent those funds in a later valid block), Alice’s funds are moved back to the ethereum main-chain.

![](https://cdn-images-1.medium.com/max/800/0*6b__s1TjsZqrO2zC.)

plasma.io/plasma.pdf

**Lastly, block producers can _censor_ users of the child-chain.** If they wanted, block producers could simply never include certain transactions in their blocks, effectively preventing a user from performing any operations on the child-chain. Once again, the solution is simply to withdraw all of our assets back onto the ethereum main-chain as above.

**Withdrawals themselves pose risks, however.** One concern is what would happen if everyone using a child-chain tried to withdraw at the same time. In the case of a mass withdrawal, there might not be enough capacity on the ethereum main-chain to process everyone’s transactions within the challenge period, [meaning users _could_ lose funds](https://www.reddit.com/r/ethereum/comments/6sqca5/plasma_scalable_autonomous_smart_contracts/dlex5pa/?utm_content=permalink&utm_medium=front&utm_source=reddit&utm_name=ethereum). Although there are many possible techniques for preventing this, e.g. by extending the challenge period in a way that is responsive to demand for withdrawals.

**It’s worth noting that it doesn’t _need_ to be the case that all block producers are controlled by one entity — this is simply the extreme case in our example.** We can create child-chains whose block production is spread among many different entities — i.e. actually decentralized in a way that is more similar to public blockchains. In those cases, there is less risk that block producers would interfere in the way described above, and so less risk that a user would have to move their assets back to the ethereum main-chain.

Now that we’ve covered both state channels and Plasma, it’s worth noting a few points of comparison.

One difference is that state channels can perform _instant withdrawals_ when all of the parties in the channel consent to the withdrawal. If Alice and Bob agree to close out a channel and withdraw their funds, so long as they both agree to the final state they can get their assets out of the channel immediately. This is not possible on Plasma, where users must always go through a withdrawal process that involves a challenge period, as described above.

State channels should also be less expensive per transaction than Plasma, and be faster. **This means that we will** [**_likely build state channels on Plasma child-chains_**](https://www.reddit.com/r/ethereum/comments/7jzx51/scaling_ethereum_hundreds_to_thousands_of/drb930m/?context=1). For example, in an application where two users are exchanging a series of small transactions. Building a state channel at the child-chain level _should_ be cheaper and faster than performing each of those transactions on the child-chain directly.

Finally, it’s worth noting that this is only a partial description that leaves out many details. Plasma itself is in very early stages. If you’re interested in learning more about current work on Plasma, check out Vitalik’s recent proposal for a “[Minimal Viable plasma](https://ethresear.ch/t/minimal-viable-plasma/426)” (i.e. a stripped-down plasma implementation). There’s work being done by a group based in Taiwan, which you can find in [this repo](https://github.com/ethereum-plasma). OmiseGo is working on an implementation for their decentralized exchange — they posted a recent update about their progress [here](https://blog.omisego.network/construction-of-a-plasma-chain-0x1-614f6ebd1612).

#### **III. Truebit**

[Truebit](http://truebit.io) is a technology to help ethereum conduct _heavy_ or _complex_ computation off-chain. This makes it different from state channels and Plasma, which are more useful for increasing the total transaction throughput of the ethereum blockchain. As we discussed in the opening section, scaling is a multi-faceted challenge that requires more than high transaction throughput. **Truebit won’t let us do _more transactions_, but it will let ethereum based applications _do more complex things_ in a way that can still be verified by the main-chain.**

This will let us do operations useful to ethereum applications that are too computationally expensive to do on chain. For instance, validating Simple Payment Verification (SPV) proofs from other blockchains, which could let ethereum smart-contracts “check” whether a transaction has happened on another chain (like bitcoin or [dogecoin](https://twitter.com/Truebitprotocol/status/960662648193888256)).

Let’s walk through an example. Imagine that you have some expensive computation — like an SPV proof — that needs to be performed as part of an ethereum application. You can’t simply do it as part of a smart contract on ethereum main-chain, because SPV proofs are far too computationally expensive. Remember, it’s very costly to perform any computation on ethereum because every node must perform that operation in parallel. Blocks in ethereum have a _maximum gas limit_ that sets a cap on how much computation can be done by all the transactions combined in that block. But an SPV proof is so computationally expensive that it would require many multiples of the _entire gas limit for an individual block_, even if it were the _only_ transaction inside.

**Instead, you pay _someone else_ a small fee to do the computation _off chain_.** The person you paid to do this is called a _solver_.

First, the solver pays a deposit held in a smart contract. Then, you give the solver a description of the computation they need to execute for you. They run the computation, and return the result. If the result is correct (more on that in a second), their deposit is returned. If it turns out that solver did _not_ properly perform the computation — i.e. they cheated or made a mistake — they lose their deposit.

**But how can we tell whether the result was correct, or false?** Truebit uses an economic mechanism called the “verification game”. Essentially, we create an incentive for other parties called _challengers_ to check the solvers’ work. If a challenger is able to prove through the verification game that a solver submitted a false result, then they collect a reward, while the solver loses their deposit.

Because the verification game is performed on-chain, it cannot simply compute the result (which would defeat the entire purpose of the system — if we _could_ do the computation on-chain, we wouldn’t need Truebit). Rather, we force both the solver and challenger to identify the _specific operation_ that they disagree about. **In effect, we are backing both parties into a corner — finding the actual line of code where they disagree about the outcome.**

![](https://cdn-images-1.medium.com/max/800/1*VrRnWxmwPFsszhQiPrx1IQ.png)

Simplified conceptual diagram of Truebit.

Once that specific operation is identified, it’s small enough to actually be executed by the ethereum main-chain. We then execute that operation through a smart-contract on ethereum, which settles once and for all which party was telling the truth and which was lying or mistaken.

If you want to learn more about Truebit, you can read the paper [here](https://people.cs.uchicago.edu/~teutsch/papers/truebit.pdf), or this [blog post](https://medium.com/@simondlr/an-intro-to-truebit-a-scalable-decentralized-computational-court-1475531400c3) by Simon de la Rouviere.

### **Conclusion**

**Layer 2 solutions share a common insight:** once we have the hard kernel of certainty provided by a public blockchain, we can use it as an anchor for cryptoeconomic systems that extend the usefulness of blockchain applications.

Now that we’ve surveyed some examples, we can be more specific about how layer 2 solutions _apply_ this insight. The economic mechanisms used by layer 2 solutions tend to be _interactive games_: they work by creating incentives for different parties to compete against or “check” one another. **A blockchain application can assume that a given claim is likely true, because we’ve created a strong incentive for another party to provide information showing it to be false.**

In state channels, this is how we confirm the final state of the channel — by giving parties a chance to “rebut” each other. In Plasma, it’s how we manage fraud-proofs and withdrawals. In Truebit, it’s how we ensure that solvers’ tell the truth — by giving an incentive to verifiers to prove the solver wrong.

These systems will help address some of the challenges involved in scaling ethereum to a massive global user base. Some, like state channels and Plasma, will increase the transaction throughput of the platform. Others, like Truebit, will make it possible to conduct more _difficult_ computation as part of a smart contract, opening up new use cases.

These three examples represent only a small portion of the possible design space for cryptoeconomic scaling solutions. We’ve not even covered the work being done on “inter-blockchain protocols” like [Cosmos](https://cosmos.network/) or [Polkadot](https://blog.stephantual.com/web-three-revisited-part-two-introduction-to-polkadot-what-it-is-what-it-aint-657782051d34) (although whether these are “layer 2” solutions or something else altogether is a topic for another post). **We should also expect to invent _new and unexpected_ layer 2 systems that improve on existing models or offer new tradeoffs between speed, finality, and overhead.**

More important than any _particular_ layer 2 solution is further development of the underlying techniques and mechanisms that make them possible in the first place: cryptoeconomic design.

**These layer 2 scaling solutions are a powerful argument for the long-term value of programmable blockchains like ethereum.** Building the economic mechanisms underlying layer 2 solutions is only possible when a blockchain is programmable: you need a scripting language to write the programs that enforce the interactive games. This is much more difficult (or in some cases, like Plasma, probably impossible) on blockchains like bitcoin, which offer only limited scripting possibilities.

**Ethereum lets us build layer 2 solutions to access new points on the tradeoff matrix between speed, finality, and overhead cost.** This makes the underlying blockchain more useful for a larger variety of applications, since different types of applications with different threat models will have natural preferences towards different tradeoffs. For high value transactions where we want protection against even nation-states, we use the main chain. For trading digital collectibles where speed is more important, we can use Plasma. Layer 2 lets us make these tradeoffs _without_ compromising the underlying blockchain, preserving decentralization and finality.

Further, it’s very hard to predict in advance what scripting capabilities will be needed for a given scaling solution. **When ethereum was being designed, Plasma and Truebit had not yet been invented.** But because ethereum is fully programmable, it is capable of implementing virtually any economic mechanism we can invent.

The only way to take full advantage of the value of blockchain technology — that core _kernel of certainty_ created by cryptoeconomic consensus — is with a programmable blockchain like ethereum.

_Thanks to Vitalik Buterin, Jon Choi, Matt Condon, Chris Dixon, Hudson Jameson, Denis Nazarov, and Jesse Walden for their comments on an earlier draft of this article._

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
