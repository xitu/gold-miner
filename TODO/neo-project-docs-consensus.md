
> * 原文地址：[Consensus](https://github.com/neo-project/docs/blob/master/en-us/node/consensus.md)
> * 原文作者：[The Neo Project](https://github.com/neo-project)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/neo-project-docs-consensus.md](https://github.com/xitu/gold-miner/blob/master/TODO/neo-project-docs-consensus.md)
> * 译者：[王子建](https://github.com/Romeo0906)
> * 校对者：

# Consensus

# 区块链共识机制

## 1 - List of Terms

* **Proof of Stake** `PoS` - A type of algorithm which uses network consensus to handle fault tolerance.

* **Proof of Work** `PoW` - A type of algorithm which uses computing power to handle fault tolerance.

* **Byzantine Fault** `BF` - A failure in which a node remains functional, but operates in a dishonest manner.

* **Delegated Byzantine Fault Tolerance** `DBFT` - A consensus algorithm implemented within the NEO blockchain to guarantee fault tolerance.

* **View** `v` - The dataset used during a consensus activity in NEO `DBFT`

## 1 - 内容导读

* **权益证明机制** `PoS` - 一种使用网络共识来处理容错的算法

* **工作量证明机制** `PoW` - 一种使用计算量来处理容错的算法

* **拜占庭错误** `BF` - 由于在节点可用状态下操作不可靠造成的失败

* **改进的拜占庭容错机制** `DBFT` - 在 NEO 区块链内部实现的保证容错的共识算法

* **视图** `v` - NEO `DBFT` 共识行为中使用的数据集


## 2 - Roles
**In the NEO consensus algorithm, Consensus Nodes are elected by NEO holders and vote on validity of transactions.  These nodes have also been referred to as 'Bookkeepers'.  Moving forward, they will be referred to as Consensus Nodes**.

  - <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/nNode.png" width="25"> **Consensus Node** - This node participates in the consensus activity.  During a consensus activity, consensus nodes take turns assuming the following two roles:
  - <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/speakerNode.png" width="25"> **Speaker** `(One)` - The **Speaker** is responsible for transmitting a block proposal to the system.
  - <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/cNode.png" width="25"> **Delegate** `(Multiple)` - **Delegates** are responsible for reaching a consensus on the transaction.

## 2 - 角色

**在 NEO 共识算法中，共识节点由 NEO 持有者选出并对交易合法性进行投票，同时它们也被作“账本”。但在下文中，它们将被统称为共识节点。**

- <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/nNode.png" width="25"> **共识节点** - 参与共识行为的节点。在共识行为中，共识节点轮流扮演以下两个角色：
- <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/speakerNode.png" width="25"> **发言人**（一个）- **发言人**负责向系统发送区块提案。
- <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/cNode.png" width="25"> **议员**（多个） - **议员**负责达成交易共识。

## 3 - Introduction

One of the fundamental differences between blockchains is how they can guarantee fault tolerance given defective, non-honest activity on the network.

Traditional methods implemented using PoW can provide this guarantee as long as a majority of the network's computational power is honest.  However, because of this schema's dependency on compute, the mechanism can be very inefficient (computational power costs energy and requires hardware).  These dependencies expose a PoW network to a number of limitations, the primary one being the cost of scaling.

NEO implements a Delegated Byzantine Fault Tolerance consensus algorithm which takes advantage of some PoS-like features(NEO holders vote on **Consensus Nodes**) which protects the network from Byzantine faults using minimal resources, while rejecting some of its issues.  This solution addresses performance and scalability issues associated with current blockchain implementations without a significant impact to the fault tolerance.

## 3 - 简介

区块链之间最基本的一个差异就是如何在网络中有缺陷、不诚实的行为中保证容错机制。

传统的实现方法是利用 PoW，前提是网络中的大部分计算力都是诚实的。然而，因为这种方案对于电脑的依赖，使得其效率非常低（计算力耗费能源并且对硬件有一定要求）。这些依赖使得 PoW 网络受到很多限制，最主要的就是扩展成本。

DBFT 在 NEO 中的实现利用了一些类似 PoS 的特点（NEO 持有者投票产生**共识节点**），这能保护网络不受拜占庭错误干扰并将消耗的资源最小化，同时也能去其糟粕（指 PoS 实现中的问题，译者注）。这个方案在没有对容错机制造成显著影响的情况下，妥善处理了当下区块链实现中性能与扩展之间的问题。

## 4 - Theory

The Byzantine Generals Problem is a classical problem in distributed computing.  The problem defines a number of **Delegates** that must all reach a consensus on the results of a **Speaker's** order.  In this system, we need to be careful because the **Speaker** or any number of **Delegates** could be traitorous.  A dishonest node may not send a consistant message to each recipient.  This is considered the most disasterous situation.  The solution of the problem requires that the **Delegates** identify if the **Speaker** is honest and what the actual command was as a group.

For the purpose of describing how DBFT works, we will primarily be focusing this section on the justification of the 66.66% consensus rate used in Section 5.  Keep in mind that a dishonest node does not need to be actively malicious, it could simply not be functioning as intended. 

For the sake of discussion, we will describe a couple scenarios.  In these simple examples, we will assume that each node sends along the message it received from the **Speaker**.   This mechanic is used in DBFT as well and is critical to the system. We will only be describing the difference between a functional system and disfunctional system.  For a more detailed explanation, see the references.

## 4 - 理论

拜占庭将军问题是分布式计算中的一个经典问题。这个问题中定义多个议员必须在发言人的命令下达成共识，在整个系统中，**发言人**或某些**议员**可能会是叛徒，因此我们要小心行事。最糟糕的情况下，非诚实节点可能不会向每个接收者发送与其它节点相同的信息（即共识内容在此节点发生了改变，译者注）。该问题的解决办法要求**议员们**组团鉴定**发言人**是否诚实并且鉴别出真实的命令。

为了说明 DBFT 的工作机制，我们将在本部分着重论述为何要在第五部分用 66.6% 的共识率。要记住，非诚实节点并不总是会做出恶意行为，它也可能只是简单地失效了而已。

为了便于讨论，我们将虚构一些场景，在这些简单的例子中，我们假定每个节点都按照**发言人**的信息发送响应。这种机制也被用在 DBFT 中，并在系统中严格执行。我们只描述正常系统与失效系统之间的区别，请查看参考以获取更详细的内容。


### **Honest Speaker**

  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/n3.png" width="300"><br> <b>Figure 1:</b> An n = 3 example with a dishonest <b>Delegate</b>.</p>
  
  In **Figure 1**, we have a single loyal **Delegate** (50%).  Both **Delegates** received the same message from the honest **Speaker**.  However, because a **Delegate** is dishonest, the honest Delegate can only determine that there is a dishonest node, but is unable to identify if its the block nucleator (The **Speaker**) or the **Delegate**.  Because of this, the **Delegate** must abstain from a vote, changing the view.
  
  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/n4.png" width="400"><br> <b>Figure 2:</b> An n = 4 example with a dishonest <b>Delegate</b>.</p>
  
  In **Figure 2**, we have a two loyal **Delegates** (66%).  All **Delegates** received the same message from the honest **Speaker** and send their validation result, along with the message received from the speaker to each other **Delegate**.  Based on the consensus of the two honest **Delegates**, we are able to determine that either the **Speaker** or right **Delegate** is dishonest in the system.

### **诚实的发言人**

  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/n3.png" width="300"><br> <b>图 1:</b> 一个 n = 3 的例子，其中包含一个不诚实的<b>议员</b>.</p>

  在**图 1**中，我们只有一个诚实的**议员**（50%），每个**议员**都会从诚实的**发言人**那里获取到相同的信息。然而，因为其中一个**议员**是不诚实的，诚实的**议员**只能判断出存在一个不诚实的节点，但是并不能鉴别该不诚实节点是区块核心（即**发言人**）还是**议员**。因此，**议员**必须放弃投票，放弃改变视图。

  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/n4.png" width="400"><br> <b>图 2:</b> 一个 n = 4 的例子，其中包含一个不诚实的<b>议员</b>.</p>

  在**图 2**中，我们有两个诚实的**议员**（66％），每个**议员**都会从诚实的**发言人**那里获取到相同的信息，并根据该信息向其它每个**议员**发送验证信息。基于两个诚实的**议员**达到的共识，我们能够判断出系统中的不诚实节点到底是**发言人**还是**议员**。


### **Dishonest Speaker** 
  
  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/g3.png" width="300"><br> <b>Figure 3:</b> An n = 3 example with a dishonest <b>Speaker</b>. </p>
  
  In the case of **Figure 3**, the dishonest **Speaker**, we have an identical conclusion to those depicted in **Figure 1**.  Neither **Delegate** is able to determine which node is dishonest.
  
  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/g4.png" width="400"><br> <b>Figure 4:</b> An n = 4 example with a dishonest <b>Speaker</b>. </p>
  
  In the example posed by **Figure 4**  The blocks received by both the middle and right node are not validatable.  This causes them to defer for a new view which elects a new **Speaker** because they carry a 66% majority.  In this example, if the dishonest **Speaker** had sent honest data to two of the three **Delegates**, it would have been validated without the need for a view change.

### **不诚实的发言人**

 <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/g3.png" width="300"><br> <b>图 3:</b> 一个 n = 3 的例子，其中包含一个不诚实的<b>发言人</b>. </p>

 在**图 3**的例子中，由于存在这个不诚实的**发言人**，我们会得到跟**图 1**相同的结论，所有的**议员**都无法判断哪个节点是不诚实的。

 <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/g4.png" width="400"><br> <b>图 4:</b> 一个 n = 4 的例子，其中包含一个不诚实的<b>发言人</b>. </p>

 在**图 4**的例子中，区块从中间节点和右节点接收到了该验证不合法的结果，这将会使得它们首先创建一个新的视图来选择一个新的**发言人**，因为它们占 66% 的比例属于多数。这个例子中，如果不诚实的**发言人**向其中两个**议员**发送了诚实的数据，区块将通过验证而不需更改视图。


## 5 - Practical Implementation

The practical implementation of DBFT in NEO uses an iterative consensus method to guarantee that consensus is reached.  The performance of the algorithm is dependent on the fraction of honest nodes in the system.**Figure 5** depicts the
expected iterations as a function of the fraction of dishonest nodes.  

Note that the **Figure 5** does not extend below 66.66% **Consensus Node** honesty.  Between this critical point and 33% **Consensus Node** honesty, there is a 'No-Man's Land' where a consensus is unattainable.  Below 33.33% **Consensus Node** honesty, dishonest nodes (assuming they are aligned in consensus) are able to reach a consensus themselves and become the new point of truth in the system.

<img src="https://github.com/neo-project/docs/raw/master/assets/consensus.iterations.png" width="800">

**Figure 5:** Monto-Carlo Simulation of the DBFT algorithm depicting the iterations required to reach consensus. {100 Nodes; 100,000 Simulated Blocks with random honest node selection}

## 5 - 具体实现

NEO 中 DBFT 的具体实现用到了一种迭代共识的方法来保证达到共识，这个算法的性能取决于诚实节点在系统中的比例。**图 5**中将预期迭代描述为不诚实节点所占比例的一个函数。

需要注意的是，**图 5**中**共识节点**的诚实度并没有低于 66.66%。当**共识节点**诚实度在 66% 和 33% 之间时，这种情况被称为无法达到共识的“无主之地”（No-Man's Land）。如果**共识节点**的诚实度低于 33.33%，不诚实节点（假设它们能够取得共识）就能够达到共识并成为系统中新的事实。

<img src="https://github.com/neo-project/docs/raw/master/assets/consensus.iterations.png" width="800">

**图 5：** DBFT 算法的 Monto-Carlo 模拟图，描绘了达到共识所需的迭代次数，其中有 100 个节点，100,000 个模拟区块和随机选择的诚实节点。


### 5.1 - Definitions

**Within the algorithm, we define the following:**

  - `t`: The amount of time allocated for block generation, measured in seconds.
    - Currently: `t = 15 seconds`
	-  This value can be used to roughly approximate the duration of a single view iteration as the consensus activity and communication events are fast relative to this time constant.

  - `n`: The number of active **Consensus Nodes**.

  - `f`: The minimum threshold of faulty **Consensus Nodes** within the system. 
  	- `f = (n - 1) / 3`

  - `h` : The current block height during consensus activity.

  - `i` : **Consensus Node** index.

  - `v` : The view of a **Consensus Node**.  The view contains the aggregated information the node has received during a round of consensus.  This includes the vote (`prepareResponse` or `ChangeView`) issued by all Delegates.

  - `k` : The index of the view `v`.  A consensus activity can require multiple rounds.  On consensus failure, `k` is incremented and a new round of consensus begins.

  - `p` : Index of the **Consensus Node** elected as the **Speaker**.  This calculation mechanism for this index rotates through **Consensus Nodes** to prevent a single node from acting as a dicator within the system. 
  	- `p = (h - k) mod (n)`

  - `s`: The safe consensus threshold.  Below this threshold, the network is exposed to fault.  
  	- `s = ((n - 1) - f)`

### 5.1 - 定义

**在本算法中，我们有如下定义：**

  - `t` : 区块生成的时间，以秒计。
    - 当前： `t ＝ 15 秒`
  - 这个值可大致近似于单个视图迭代的时间，因为共识行为和通信事件对于该时间常量是非常迅速的。

  - `n` : 活跃的**共识节点**数目。

  - `f` : 系统中错误**共识节点**的最小阈值。
    - `f = (n-1) / 3`

  - `h` : 共识行为中当前区块的高度

  - `i` : **共识节点**索引。

  - `v` : **共识节点**视图。视图包含了在一次共识回合中节点接受到的所有信息，包括所有议员发起的投票（`prepareResponse` 或者 `ChangeView`）。

  - `k` : 视图 `v` 的索引。一次共识行为可能会需要多个共识回合，共识失败时，`k` 会递增并开始一个新的共识回合。

  - `p` : 被选为**发言人**的**共识节点**的索引。该索引的计算机制在**共识节点**中轮流执行，以防止某个节点在系统中产生独裁行为。
    - `p = (h - k) mod (n)`

  - `s` : 安全共识阈值。低于这个阈值，网络将会出现错误。


### 5.2 - Requirements

**Within NEO, there are three primary requirements for consensus fault tolerance:**

1. `s` **Delegates** must reach a consensus about a transaction before a block can be committed.

2. Dishonest **Consensus Nodes** must not be able to persuade the honest consensus nodes of faulty transactions. 

3. At least `s` **Delegates** are in same state (`h`,`k`) to begin a consensus activity

### 5.2 - 要求

**在 NEO 内部，有三个主要的共识容错要求：**

1. `s` 个**议员**必须在区块被提交之前对某个交易达成共识。

2. 不诚实的**共识节点**必须不能说服诚实的**共识节点**接受一个错误的交易。

3. 至少有 `s` 个具有相同（`h`, `k`）状态的**议员**才能开始一个共识行为

	
### 5.3 - Algorithm
**The algorithm works as follows:**

1. A **Consensus Node** broadcasts a transaction to the entire network with the sender's signatures.

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus1.png" width="450"><br> <b>Figure 6:</b> A <b>Consensus Node</b> receives a transaction and broadcasts it to the system. </p>

2. **Consensus Nodes** log transaction data into local memory.

3. The first view `v` of the consensus activity is initialized.

4. The **Speaker** is identified.

	 <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus2.png" width="450"><br> <b>Figure 7:</b> A <b>Speaker</b> has been identified and the view has been set. </p>
	
  **Wait** `t` seconds

5. The **Speaker** broadcasts the proposal :
    <!-- -->
    <prepareRequest, h, k, p, bloc, [block]sigp>

	  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus3.png" width="450"><br> <b>Figure 8:</b> The <b>Speaker</b> mints a block proposal for review by the <b>Delegates</b>. </p>
	 
6. The **Delegates** receive the proposal and validate:

    - Is the data format consistent with the system rules?
    - Is the transaction already on the blockchain?
    - Are the contract scripts correctly executed?
    - Does the transaction only contain a single spend?	(i.e. does the transaction avoid a double spend scenario?)

    - **If Validated Proposal Broadcast:**
	    <!-- -->
	    <prepareResponse, h, k, i, [block]sigi>
	 	
    - **If Invalidated Proposal Broadcast:**
	    <!-- -->
	        <ChangeView, h,k,i,k+1>

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus4.png" width="500"><br> <b>Figure 9:</b> The <b>Delegates</b> review the block proposal and respond. </p>

7. After receiving `s` number of 'prepareResponse' broadcasts, a **Delegate** reaches a consensus and publishes a block.

8. The **Delegates** sign the block.

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus5.png" width="500"><br> <b>Figure 10:</b> A consensus is reached and the approving <b>Delegates</b> sign the block, binding it to the chain. </p>

8. When a **Consensus Node** receives a full block, current view data is purged, and a new round of consensus begins. 
	- `k = 0`

--- 
  
**Note:**

 If after (![timeout](https://github.com/neo-project/docs/raw/master/assets/consensus.timeout.png) ) seconds on the same view without consensus:
  - **Consensus Node** broadcasts:

  <!-- -->
      <ChangeView, h,k,i,k+1>

  - Once a **Consensus Node** receives at least `s` number of broadcasts denoting the same change of view, it increments the view `v`, triggering a new round of consensus.

### 5.3 - 算法

**算法流程如下：**

1. 一个**共识节点**在全网范围内广播一个被发送方签名过的交易。

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus1.png" width="450"><br> <b>图 6:</b> 一个<b>共识节点</b>接收到了一个交易并向全网进行广播</p>

2. 其它**共识节点**在内存中记录交易信息。

3. 共识行为的第一个视图 `v` 被初始化。

4. 确定**发言人**。

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus2.png" width="450"><br> <b>图 7:</b>确定<b>发言人</b>并设置视图</p>
  
  **等待** `t` 秒

5. **发言人**广播提案：
    <!-- -->
    <prepareRequest, h, k, p, bloc, [block]sigp>

    <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus3.png" width="450"><br> <b>图 8:</b><b>发言人</b>建立一个区块提案并由<b>议员</b>审查</p>

6. **议员**收到提案并进行验证：

    - 时间格式是否与系统规则保持一致？
    - 区块链中是否已存在该交易？
    - 合同脚本是否被正确执行？
    - 该交易是否只包单次支付？（也就是说，该交易是否能避免重复支付？）

    - **If Validated Proposal Broadcast:**
      <!-- -->
      <prepareResponse, h, k, i, [block]sigi>
    
    - **If Invalidated Proposal Broadcast:**
      <!-- -->
          <ChangeView, h,k,i,k+1>

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus4.png" width="500"><br> <b>图 9:</b><b>议员</b>审查区块链提案并响应</p>

7. 在收到 `s` 个 'prepareResponse' 广播后，该**议员**就达成了共识并发布了一个区块。

8. 该**议员**对区块进行签名。

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus5.png" width="500"><br> <b>图 10:</b>达成共识，批准该交易的<b>议员</b>对区块签名，并将其绑定到区块链上</p>

9. 当一个**共识节点**接收到整个区块的时候，当前视图的数据将被清除并开始新一轮的共识。
  - `k = 0`

--- 
  
**注意：**

如果在 (![timeout](https://github.com/neo-project/docs/raw/master/assets/consensus.timeout.png) ) 秒之后，没有就该视图达成共识：
  - **共识节点**会广播：

  <!-- -->
      <ChangeView, h,k,i,k+1>

  - 一旦某个**共识节点**收到了至少 `s` 个广播内容表示要改变该视图时，它将会递增视图 `v` 并发起新一轮共识。

## 6 - References
1. [A Byzantine Fault Tolerance Algorithm for Blockchain](https://www.neo.org/Files/A8A0E2.pdf)
2. [Practical Byzantine Fault Tolerance](http://pmg.csail.mit.edu/papers/osdi99.pdf)
3. [The Byzantine Generals Problem](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/The-Byzantine-Generals-Problem.pdf)

## 6 - 参考文献
1. [A Byzantine Fault Tolerance Algorithm for Blockchain](https://www.neo.org/Files/A8A0E2.pdf)
2. [Practical Byzantine Fault Tolerance](http://pmg.csail.mit.edu/papers/osdi99.pdf)
3. [The Byzantine Generals Problem](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/The-Byzantine-Generals-Problem.pdf)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
