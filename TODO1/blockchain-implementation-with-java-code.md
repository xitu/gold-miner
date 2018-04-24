> * 原文地址：[Blockchain Implementation With Java Code](https://dzone.com/articles/blockchain-implementation-with-java-code)
> * 原文作者：[David Pitt](https://dzone.com/users/2933125/dpittkhs.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/blockchain-implementation-with-java-code.md](https://github.com/xitu/gold-miner/blob/master/TODO1/blockchain-implementation-with-java-code.md)
> * 译者：
> * 校对者：

# 用 Java 代码实现区块链

让我们来看看用 Java 代码实现区块链的可能性。我们从第一原则出发，开发一些代码来演示它们是如何融合在一起的。

比特币（Bitcoin）炙手可热 —— **多么的轻描淡写**。虽然加密货币的未来尚不明确，但区块链 —— 用于驱动比特币的技术 —— 却非常流行。

区块链的应用领域尚未探索完毕。它也有可能会破会企业自动化。关于区块链的工作原理，有很多可用的信息。我们有一个深入区块链的[免费白皮书](https://keyholesoftware.com/wp-content/uploads/Blockchain-For-The-Enterprise-Keyhole-White-Paper.pdf)（无需注册）。

本文将重点介绍区块链体系结构，特别是演示“不可变，仅附加”的分布式账本是如何通过简单的代码示例工作的。

作为开发者，与简单地阅读技术文章相比，在理解代码如何工作时，查看代码内容可能会更有用。至少对我来说是这样。那么我们开始吧！

## 简述区块链

首先我们简要总结下区块链。块包含一些头信息和任何类型数据的一组或一组事务。该链从第一个（初始）块开始。随着事务被添加/扩展，将基于块中可以存储多少事务来创建新块。

当超过块阀值大小时，将创建一个新的事务块。新块链接到前一个块，因此称为区块链。

### 不可变性

因为 SHA-256 哈希专注于事务计算，所以区块链是不可变的。区块链的内容也被哈希则提供了唯一的标识符。此外，来自链接的、前一个块的哈希也存储在块头中并进行散列。

这就是为什么试图篡改块基本上是不可能的，至少目前的计算能力是这样的。下面是一个显示块属性的部分 Java 类定义。

```
...
public class Block&lt;T extends Tx&gt; {
public long timeStamp;
private int index;
private List&lt;T&gt; transactions = new ArrayList&lt;T&gt;();
private String hash;
private String previousHash;
private String merkleRoot;
private String nonce = "0000";

// 缓存事务用 SHA256 哈希
    public Map&lt;String,T&gt; map = new HashMap&lt;String,T&gt;();
...
```

注意，注入的泛型类型为 `Tx` 类型。这允许事务数据发生变化。此外，`previousHash` 属性将引用前一个块的哈希值。稍后将描述 `merkleRoot` 和 `nonce` 属性。

### 哈希块

每个块可以计算一个哈希。实际上是链接在一起的所有块属性的哈希，包括前一个块的哈希和由此计算而得的 SHA-256 哈希。

下面是在计算哈希值的 `Block.java` 类中定义的方法。

```
...
public void computeHash() {
     Gson parser = new Gson(); // 可能应该缓存这个实例
     String serializedData = parser.toJson(transactions);  
     setHash(SHA256.generateHash(timeStamp + index + merkleRoot + serializedData + nonce + previousHash));
     }
...
```

块事物被序列化为 JSON 字符串，因此可以在哈希之前将其追加到块属性中。

### 链

区块链通过接受事物来管理区块。当到达预定阀值时，就创建一个块。下面是一个 `SimpleBlockChain.java` 部分实现：

```
...
...
public class SimpleBlockchain<T extends Tx> {
public static final int BLOCK_SIZE = 10;
public List<Block<T>> chain = new ArrayList<Block<T>>();

public SimpleBlockchain() {
// 创建初始块
chain.add(newBlock());
}

...
```

注意,chain 属性拥有 `Tx` 类型键入的区块列表。此外，在创建链时，`no arg` 构造器创建初始化的“初始”块。下面是 `newBlock()` 方法是的源码。

```
...
public Block<T> newBlock() {
int count = chain.size();
String previousHash = "root";

if (count > 0)
previousHash = blockChainHash();

Block<T> block = new Block<T>();

block.setTimeStamp(System.currentTimeMillis());
block.setIndex(count);
block.setPreviousHash(previousHash);
return block;
}
...
```

这个新块将创建一个新块实例，指定适当值，并分配前一个块的哈希（这将是链头的哈希）。然后返回改块。

在将块添加到链中之前，可以通过将新块的上一个哈希与链的最后一个块（头）进行比较来验证块，以确保它们匹配。这里有一个描述这一点 `SimpleBlockchain.java`。

```
....
public void addAndValidateBlock(Block<T> block) {

// 比较之前的块哈希，如果有效则添加
Block<T> current = block;
for (int i = chain.size() - 1; i >= 0; i--) {
Block<T> b = chain.get(i);
if (b.getHash().equals(current.getPreviousHash())) {
current = b;
} else {

throw new RuntimeException("Block Invalid");
}

}

this.chain.add(block);
}
...
```

整个区块链通过链的循环验证来确保区块的哈希仍然与前一个块的哈希匹配。

以下是 `SimpleBlockChain.java validate()` 方法的实现。

```
...
public boolean validate() {

String previousHash = null;
for (Block<T> block : chain) {
String currentHash = block.getHash();
if (!currentHash.equals(previousHash)) {
return false;
}

previousHash = currentHash;

}

return true;

}
...
```

你可以看到，试图以任何方式伪造事务数据或任何其他属性是非常困难的。而且，随着链的增长，它会继续变得非常、非常、非常困难，基本上是不可能的 —— 即，直到量子计算机可用为止！

### 添加事务

区块链技术的另一个重要技术点是它是分布式的。他们只是附加这一事实有助于在参与区块链网络的节点之间复制区块链。节点通常以点对点的方式进行通信，就像比特币那样，但不一定非得是这种方式。其他区块链实现使用分散的方法，比如 HTTP 使用 API。但是，这是另一篇文章的主题。

事务可以代表任何东西。事务可以包含要执行的代码（例如，智能合约）或存储和追加有关某种业务事务的信息。

**智能合约**：旨在以数字式来促进、验证或强制执行合约谈判或履行的计算机协议。

就比特币而言，交易包含所有者账户中的金额和其他账户的金额（例如，在账户之间转移比特币金额）。事务中还包括公钥和账户 ID，因此传输是安全的。但这是比特币特有的。

事务被添加到网络或池中；它们不在区块中或链本身中。

这是区块链**协商一致机制**发挥作用的地方。在本文的范围之外，还有一些经过验证的一致性算法和模式。

**挖矿**是比特币区块链使用的协商一致机制。这就是本文后面讨论的协商一致意见的类型。协商一致机制收集事务，用他们构建一个块，然后将改块添加到链中。然后，再添加到链中之前，该链验证新的事务块。

### Merkle Trees

事务被哈希并添加到区块中。创建 Merkle Tree 数据结构来计算 Merkle Root Hash。每个块都存储 Merkle Tree 树的根，这是一个平衡的哈希二叉树，其中内部节点是一直到根哈希的两个子哈希的哈希，即 Merkle Root。

[![](https://i0.wp.com/keyholesoftware.com/wp-content/uploads/Merkle-Root.png?resize=576%2C288&ssl=1)](https://keyholesoftware.com/2018/04/10/blockchain-with-java/merkle-root/)

该树用于区块事务的验证。如果在事务中更改了一些信息，Merkel Root 将失效。此外，再分布式中，它们还可以加速传输区块，因为该结构只允许添加和验证整个事务块所需的单个事务哈希分支。

以下是 `Block.java` 类中的方法，它从事务列表中创建了一个 Merkle Tree。

```
...
public List<String> merkleTree() {
ArrayList<String> tree = new ArrayList<>();
// 首先，将事务的所有哈希作为
// 树。
for (T t : transactions) {
tree.add(t.hash());
}
int levelOffset = 0; // 当前处理的列表中的偏移量。
// 开始层
// 穿过每一层，当我们到达根部时停止（层大小
// == 1）。
for (int levelSize = transactions.size(); levelSize > 1; levelSize = (levelSize + 1) / 2) {
// 对于该层上的每一对节点：
for (int left = 0; left < levelSize; left += 2) {
// 在我们没有足够事务的情况下，
// 右节点和左节点
// 可以一样。
int right = Math.min(left + 1, levelSize - 1);
String tleft = tree.get(levelOffset + left);
String tright = tree.get(levelOffset + right);
tree.add(SHA256.generateHash(tleft + tright));
}
// 移动至下一层
levelOffset += levelSize;
}
return tree;
}

...
```

此方法用于计算区块的 Merkle Tree 根。伴随项目有一个 Markle Tree 单元测试，它试图将事务添加到一个区块中，并验证 Merle Root 是否已经更改。下面是单元测试的源码。

```
...
@Test
public void merkleTreeTest() {

// 创建链，添加事务

SimpleBlockchain<Transaction> chain1 = new SimpleBlockchain<Transaction>();

chain1.add(new Transaction("A")).add(new Transaction("B")).add(new Transaction("C")).add(new Transaction("D"));

// 得到区块链
Block<Transaction> block = chain1.getHead();

System.out.println("Merkle Hash tree :" + block.merkleTree());

//从区块中获取事务
Transaction tx = block.getTransactions().get(0);

// 查看区块事务是否有效，它们应该是有效的
block.transasctionsValid();
assertTrue(block.transasctionsValid());

// 更改事务数据
tx.setValue("Z");

// 区块失效，区块 Merkle Root 不匹配事务计算的 Merkle 树。
assertFalse(block.transasctionsValid());

}

...
```

此单元测试模拟验证事务，然后在协商一致机制之外的块中更改事务，例如，如果有人试图更改事务数据。

记住，区块链只是附加的，当块区链数据结构在节点之间共享时，区块数据结构（包括 Melk Root）被哈希并连接到其他区块。所有节点都可以验证新的块，并且现有的区块可以很容易地被证明是有效的。因此，在事务交易结束之前试图添加假块或试图调整旧交易的节点，实际上是不可能的。


### 挖矿工作证明

在比特币世界中，将事务组合成区块，然后提交给链中的成员进行验证的过程叫做“挖矿”。

更宽泛地说，在区块链中，这被称为共识。有不同类型的已证明的分布式协商一致算法。使用哪种机制取决于你是否有公共或许可的区块链。我们的白皮是对此进行了深入的描述，但本文的重点是区块链的力学，因此这个例子中我们将应用一个工作证明协商一致机制。

因此，挖掘节点将侦听由区块链执行的事务，并执行一个简单的数学难题。这个谜题使用在迭代中被改变直到前导零散哈希的 nonce 值产生具有一组预定的前导零的区块哈希。

[Java 示例项目](https://github.com/in-the-keyhole/khs-blockchain-java-example) 有一个 `Miner.java` 类，其中的 `proofOfWork(Block block)` 方法实现如下所示。

```
private String proofOfWork(Block block) {

String nonceKey = block.getNonce();
long nonce = 0;
boolean nonceFound = false;
String nonceHash = "";

Gson parser = new Gson();
String serializedData = parser.toJson(transactionPool);
String message = block.getTimeStamp() + block.getIndex() + block.getMerkleRoot() + serializedData
+ block.getPreviousHash();

while (!nonceFound) {

nonceHash = SHA256.generateHash(message + nonce);
nonceFound = nonceHash.substring(0, nonceKey.length()).equals(nonceKey);
nonce++;

}

return nonceHash;

}
```

同样，这是简化的，但是一旦接收到一定数量的事务，矿工将为区块执行一个工作哈希验证的实现。该算法简单地循环并创建块的SHA-256散列，直到产生前导数字哈希。

这可能需要很多时间，这就是为什么特定的GPU微处理器已经被实现来尽可能快地执行和解决这个问题的原因。


### 单元测试

你可以看到所有这些概念与 GitHUb 上可用的 Java 示例项目的 JUnit 测试结合在一起。
[![](https://i2.wp.com/keyholesoftware.com/wp-content/uploads/junittestsblockchain.png?resize=782%2C490&ssl=1)](https://keyholesoftware.com/2018/04/10/blockchain-with-java/junittestsblockchain/)

快跑吧。它会让你检查这个简单的区块链是如何工作的。

另外，如果你是 C# 的读者，这个（我不会告诉任何人），我们也有同样用 C# 写的示例。下面是 C# 区块链实现的示例[地址](https://github.com/in-the-keyhole/khs-blockchain-csharp-example)。

## 最后的思考

希望这篇文章能给你足够的兴趣和洞察力，让你继续研究区块链技术。

本文介绍的所有示例都用于我们的[深度区块链白皮书](https://keyholesoftware.com/wp-content/uploads/Blockchain-For-The-Enterprise-Keyhole-White-Paper.pdf) (no registration required to read). 这些例子在白皮书中有更详细的说明。

另外，如果你想在 Java 中看到完整的区块链实现，这里有一个开源项目 Bitcoin 的[链接](https://github.com/bitcoinj/bitcoinj)。你将在实际的生产实现中看到这些概念的实际应用。

如果是这样的话，接下来推荐的学习步骤是检查一个更基于生成的开源区块链框架。一个很好的示例是 [HyperLedger Fabric](https://www.hyperledger.org/projects/fabric)，这将是我下一篇文章的主题 —— 请持续关注！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
