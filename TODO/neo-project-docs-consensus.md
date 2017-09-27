
> * 原文地址：[Consensus](https://github.com/neo-project/docs/blob/master/en-us/node/consensus.md)
> * 原文作者：[The Neo Project](https://github.com/neo-project)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/neo-project-docs-consensus.md](https://github.com/xitu/gold-miner/blob/master/TODO/neo-project-docs-consensus.md)
> * 译者：[王子建](https://github.com/Romeo0906)
> * 校对者：[faintz](https://github.com/faintz) [wild-flame](https://github.com/wild-flame)

# 区块链共识机制

## 1 - 术语

* **权益证明机制** `PoS` - 一种使用网络共识来处理容错的算法

* **工作量证明机制** `PoW` - 一种使用计算力来处理容错的算法

* **拜占庭错误** `BF` - 节点可用，但由于其行为不可靠造成的失败

* **改进的拜占庭容错机制** `DBFT` - 在 NEO 区块链内部实现的保证容错的共识算法

* **视图** `v` - NEO `DBFT` 共识行为中使用的数据集

## 2 - 角色

**在 NEO 共识算法中，共识节点由 NEO 持有者选出并对交易合法性进行投票，同时它们也被称作“账本”。但在下文中，它们将被统称为共识节点。**

- <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/nNode.png" width="25"> **共识节点** - 参与共识行为的节点。在共识行为中，共识节点轮流扮演以下两个角色：
- <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/speakerNode.png" width="25"> **发言人**（一个）- **发言人**负责向系统发送区块提案。
- <img style="vertical-align: middle" src="https://github.com/neo-project/docs/raw/master/assets/cNode.png" width="25"> **议员**（多个） - **议员**负责达成交易共识。

## 3 - 简介

区块链之间的一个根本差异就是如何在有缺陷和不诚实行为的网络中保证容错。

使用 PoW 这种传统的实现方法可以保证容错，只要网络中的大部分计算力都是诚实的。然而，因为这种方案对于计算的依赖，使得其效率非常低（计算力耗费能源并且对硬件有一定要求）。这使得 PoW 网络受到很多限制，最主要的就是扩展成本。

DBFT 在 NEO 中的实现利用了一些类似 PoS 的特点（NEO 持有者投票产生**共识节点**），这能保护网络不受拜占庭错误干扰并将消耗的资源最小化，同时也能去其糟粕（指 PoS 实现中的问题，译者注）。这个方案在没有对容错机制造成显著影响的情况下，妥善处理了当下区块链实现中性能与扩展之间的问题。

## 4 - 理论

拜占庭将军问题是分布式计算中的一个经典问题。这个问题中定义多个议员必须在发言人的命令下达成共识，在整个系统中，**发言人**或某些**议员**可能会是叛徒，因此我们要小心行事。最糟糕的情况下，非诚实节点可能会向每个接收者发送不同的信息。该问题的解决办法要求**议员们**组团鉴定**发言人**是否诚实并且鉴别出真实的命令。

为了说明 DBFT 的工作机制，我们将在本部分着重论述为何要在第五部分用 66.6% 的共识率。要记住，非诚实节点并不总是会做出恶意行为，它也可能只是简单地失效了而已。

为了便于讨论，我们设想一些场景，在这些简单的例子中，我们假定每个节点都按照**发言人**的信息发送响应。这种机制也被用在 DBFT 中，并在系统中严格执行。我们只描述正常系统与失效系统之间的区别，若想获取更多内容，请查看参考文献。

### **诚实的发言人**

  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/n3.png" width="300"><br> <b>图 1:</b> 一个 n = 3 的例子，其中包含一个不诚实的<b>议员</b>.</p>

  在**图 1**中，我们只有一个诚实的**议员**（50%），每个**议员**都会从诚实的**发言人**那里获取到相同的信息。然而，因为其中一个**议员**是不诚实的，诚实的**议员**只能判断出存在一个不诚实的节点，但是并不能鉴别该不诚实节点是区块核心（即**发言人**）还是**议员**。因此，**议员**必须放弃投票，放弃改变视图。

  <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/n4.png" width="400"><br> <b>图 2:</b> 一个 n = 4 的例子，其中包含一个不诚实的<b>议员</b>.</p>

  在**图 2**中，我们有两个诚实的**议员**（66％），每个**议员**都会从诚实的**发言人**那里获取到相同的信息，并根据该信息向其它每个**议员**发送验证信息。基于两个诚实的**议员**达到的共识，我们能够判断出系统中的不诚实节点到底是**发言人**还是**议员**。

### **不诚实的发言人**

 <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/g3.png" width="300"><br> <b>图 3:</b> 一个 n = 3 的例子，其中包含一个不诚实的<b>发言人</b>. </p>

 在**图 3**的例子中，由于存在这个不诚实的**发言人**，我们会得到跟**图 1**相同的结论，所有的**议员**都无法判断哪个节点是不诚实的。

 <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/g4.png" width="400"><br> <b>图 4:</b> 一个 n = 4 的例子，其中包含一个不诚实的<b>发言人</b>. </p>

 在**图 4**的例子中，区块从中间节点和右节点接收到了该验证不合法的结果，这将会使得它们首先创建一个新的视图来选择一个新的**发言人**，因为它们占 66% 的比例，属于多数。这个例子中，如果不诚实的**发言人**向其中两个**议员**发送了诚实的数据，区块将通过验证而不需更改视图。

## 5 - 具体实现

NEO 中 DBFT 的具体实现用使用了一种迭代共识的方法来保证达到共识，这个算法的性能取决于诚实节点在系统中的比例。**图 5**中将预期迭代描述为不诚实节点所占比例的一个函数。

需要注意的是，**图 5**中**共识节点**的诚实度并没有低于 66.66%。当**共识节点**诚实度在 66% 和 33% 之间时，这种情况被称为无法达到共识的“无主之地”（No-Man's Land）。如果**共识节点**的诚实度低于 33.33%，不诚实节点（假设它们能够取得共识）就能够达到共识并成为系统中新的事实。

<img src="https://github.com/neo-project/docs/raw/master/assets/consensus.iterations.png" width="800">

**图 5：** DBFT 算法的 Monto-Carlo 模拟图，描绘了达到共识所需的迭代次数，其中有 100 个节点，100,000 个模拟区块和随机选择的诚实节点。

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

### 5.2 - 要求

**在 NEO 内部，有三个主要的共识容错要求：**

1. `s` 个**议员**必须在区块被提交之前对某个交易达成共识。

2. 不诚实的**共识节点**必须不能说服诚实的**共识节点**接受一个错误的交易。

3. 至少有 `s` 个具有相同（`h`, `k`）状态的**议员**才能开始一个共识行为

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

    - **如果提案通过验证则广播:**
      <!-- -->
        <prepareResponse, h, k, i, [block]sigi>
    
    - **如果提案未通过验证则广播：**
      <!-- -->
        <ChangeView, h,k,i,k+1>

   <p align="center"><img src="https://github.com/neo-project/docs/raw/master/assets/consensus4.png" width="500"><br> <b>图 9:</b><b>议员</b>审查区块链提案并响应</p>

7. 在收到 `s` 个 'prepareResponse' 广播后，该**议员**就达成共识并发布一个区块。

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

  - 一旦某个**共识节点**收到了至少 `s` 个广播内容表示要改变该视图，它将会递增视图 `v` 并发起新一轮共识。

## 6 - 参考文献
1. [A Byzantine Fault Tolerance Algorithm for Blockchain](https://www.neo.org/Files/A8A0E2.pdf)
2. [Practical Byzantine Fault Tolerance](http://pmg.csail.mit.edu/papers/osdi99.pdf)
3. [The Byzantine Generals Problem](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/The-Byzantine-Generals-Problem.pdf)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
