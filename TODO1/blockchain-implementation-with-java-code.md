> * 原文地址：[Blockchain Implementation With Java Code](https://dzone.com/articles/blockchain-implementation-with-java-code)
> * 原文作者：[David Pitt](https://dzone.com/users/2933125/dpittkhs.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/blockchain-implementation-with-java-code.md](https://github.com/xitu/gold-miner/blob/master/TODO1/blockchain-implementation-with-java-code.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[sisibeloved](https://github.com/sisibeloved)

# 用 Java 代码实现区块链

让我们来看看用 Java 代码实现区块链的可能性。我们从基本原理出发，开发一些代码来演示它们是如何融合在一起的。

比特币（Bitcoin）炙手可热 —— **多么的轻描淡写**。虽然数字加密货币的前景尚不明确，但区块链 —— 用于驱动比特币的技术 —— 却非常流行。

区块链的应用领域尚未探索完毕。它也有可能会破坏企业自动化。关于区块链的工作原理，有很多可用的信息。我们有一个深度区块链的[免费白皮书](https://keyholesoftware.com/wp-content/uploads/Blockchain-For-The-Enterprise-Keyhole-White-Paper.pdf)（无需注册）。

本文将重点介绍区块链体系结构，特别是通过简单的代码示例演示“不可变，仅附加”的分布式账本是如何工作的。

作为开发者，阅读代码会比阅读技术文章更容易理解。至少对我来说是这样。那么我们开始吧！

## 简述区块链

首先我们简要总结下区块链。区块包含一些头信息和任意一组数据类型或一组交易。该链从第一个（初始）区块开始。随着交易被添加/扩展，将基于区块中可以存储多少交易来创建新区块。

当超过区块阀值大小时，将创建一个新的交易区块。新区块与前一个区块连接，因此称为区块链。

### 不可变性

因为交易时会计算 SHA-256 哈希值，所以区块链是不可变的。区块链的内容也被哈希则提供了唯一的标识符。此外，相连的前一个区块的哈希也会被在区块的头信息中散列并储存。

这就是为什么试图篡改区块基本上是不可能的，至少以目前的计算能力是这样的。下面是一个展示区块属性的 Java 类的部分定义。

```
...
public class Block&lt;T extends Tx>; {
public long timeStamp;
private int index;
private List<T> transactions = new ArrayList<T>();
private String hash;
private String previousHash;
private String merkleRoot;
private String nonce = "0000";

// 缓存事务用 SHA256 哈希
    public Map<String,T> map = new HashMap<String,T>();
...
```

注意，注入的泛型类型为 `Tx` 类型。这允许交易数据发生变化。此外，`previousHash` 属性将引用前一个区块的哈希值。稍后将描述 `merkleRoot` 和 `nonce` 属性。

### 区块哈希值

每个区块可以计算一个哈希。这实际上是链接在一起的所有区块属性的哈希，包括前一个区块的哈希和由此计算而得的 SHA-256 哈希。

下面是在 `Block.java` 类中定义的计算哈希值的方法。

```
...
public void computeHash() {
     Gson parser = new Gson(); // 可能应该缓存这个实例
     String serializedData = parser.toJson(transactions);  
     setHash(SHA256.generateHash(timeStamp + index + merkleRoot + serializedData + nonce + previousHash));
     }
...
```

交易被序列化为 JSON 字符串，因此可以在哈希之前将其追加到块属性中。

### 链

区块链通过接受交易来管理区块。当到达预定阀值时，就创建一个区块。下面是 `SimpleBlockChain.java` 的部分实现：

```
...
...
public class SimpleBlockchain<T extends Tx> {
public static final int BLOCK_SIZE = 10;
public List<Block<T>> chain = new ArrayList<Block<T>>();

public SimpleBlockchain() {
// 创建初始区块
chain.add(newBlock());
}

...
```

注意，chain 属性维护了一个类型为 `Tx` 的区块列表。此外，`无参构造器` 会在创建初始链表时初始化“初始”区块。下面是 `newBlock()` 方法源码。

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

这个方法将会创建一个新的区块实例，产生合适的值，并分配前一个块的哈希（这将是链头的哈希），然后返回这个实例。

在将区块添加到链中之前，可以通过将新区块的上一个哈希与链的最后一个区块（头）进行比较来验证区块，以确保它们匹配。`SimpleBlockchain.java` 描述了这一过程。

```
....
public void addAndValidateBlock(Block<T> block) {

// 比较之前的区块哈希，如果有效则添加
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

整个区块链通过循环整个链来验证，确保区块的哈希仍然与前一个区块的哈希匹配。

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

你可以看到，试图以任何方式伪造交易数据或任何其他属性都是非常困难的。而且，随着链的增长，它会继续变得非常、非常、非常困难，基本上是不可能的 —— 除非量子计算机可用！

### 添加交易

区块链技术的另一个重要技术点是它是分布式的。区块链只增的特性很好地帮助了它在区块链网络的节点之间的复制。节点通常以点对点的方式进行通信，就像比特币那样，但不一定非得是这种方式。其他区块链实现使用分散的方法，比如使用基于 HTTP 协议的 API。这都是题外话了。

交易可以代表任何东西。交易可以包含要执行的代码（例如，智能合约）或存储和追加有关某种业务交易的信息。

**智能合约**：旨在以数字形式来促进、验证或强制执行合约谈判及履行的计算机协议。

就比特币而言，交易包含所有者账户中的金额和其他账户的金额（例如，在账户之间转移比特币金额）。交易中还包括公钥和账户 ID，因此传输需要保证安全。但这是比特币特有的。

交易被添加到网络中并被池化；它们不在区块中或链本身中。

这是区块链**共识机制**发挥作用的地方。现在有许多经过验证的共识算法和模式，不过那已经超出了本文的范围。

**挖矿**是比特币区块链使用的共识机制。这就是下文讨论的共识类型。共识机制收集交易，用它们构建一个区块，然后将该区块添加到链中。区块链会在新的交易区块被添加之前验证它。

### 默克尔树

交易被哈希并添加到区块中。默克尔树被用来计算默克尔根哈希。默克尔树是一种内部节点的值是两个子节点值的哈希值的平衡二叉树。而默克尔根，就是默克尔树的根节点。

[![](https://i0.wp.com/keyholesoftware.com/wp-content/uploads/Merkle-Root.png?resize=576%2C288&ssl=1)](https://keyholesoftware.com/2018/04/10/blockchain-with-java/merkle-root/)

该树用于区块交易的验证。如果在交易中更改了一些信息，默克尔根将失效。此外，在分布式中，它们还可以加速传输区块，因为该结构只允许添加和验证整个交易区块所需的单个交易哈希分支。

以下是 `Block.java` 类中的方法，它从交易列表中创建了一个默克尔树。

```
...
public List<String> merkleTree() {
ArrayList<String> tree = new ArrayList<>();
// 首先，
// 将所有交易的哈希作为叶子节点添加到树中。
for (T t : transactions) {
tree.add(t.hash());
}
int levelOffset = 0; // 当前处理的列表中的偏移量。
//  当前层级的第一个节点在整个列表中的偏移量。
// 每处理完一层递增，
// 当我们到达根节点时（levelSize == 1）停止。
for (int levelSize = transactions.size(); levelSize > 1; levelSize = (levelSize + 1) / 2) {
// 对于该层上的每一对节点：
for (int left = 0; left < levelSize; left += 2) {
// 在我们没有足够交易的情况下，
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

此方法用于计算区块的默克尔树根。伴随项目有一个默克尔树单元测试，它试图将交易添加到一个区块中，并验证默克尔根是否已经更改。下面是单元测试的源码。

```
...
@Test
public void merkleTreeTest() {

// 创建链，添加交易

SimpleBlockchain<Transaction> chain1 = new SimpleBlockchain<Transaction>();

chain1.add(new Transaction("A")).add(new Transaction("B")).add(new Transaction("C")).add(new Transaction("D"));

// 获取链中的区块
Block<Transaction> block = chain1.getHead();

System.out.println("Merkle Hash tree :" + block.merkleTree());

//从区块中获取交易
Transaction tx = block.getTransactions().get(0);

// 查看区块交易是否有效，它们应该是有效的
block.transasctionsValid();
assertTrue(block.transasctionsValid());

// 更改交易数据
tx.setValue("Z");

//当区块的默克尔根与计算出来的默克尔树不匹配时，区块不应该是有效。
assertFalse(block.transasctionsValid());

}

...
```

此单元测试模拟验证交易，然后通过共识机制之外的方法改变区块中的交易，例如，如果有人试图更改交易数据。

记住，区块链是只增的，当块区链数据结构在节点之间共享时，区块数据结构（包括默克尔根）被哈希并连接到其他区块。所有节点都可以验证新的区块，并且现有的区块可以很容易地被证明是有效的。因此，如果一个挖矿者想要添加一个伪造的区块或者节点来调整原有的交易是不可能的。


### 挖矿和工作量证明

在比特币世界中，将交易组合成区块，然后提交给链中的成员进行验证的过程叫做“挖矿”。

更宽泛地说，在区块链中，这被称为共识。现在有好几种经过验证的分布式共识算法，使用哪种机制取决于你有一个公共的还是私有的区块链。我们的白皮书对此进行了更为深入的描述，但本文的重点是区块链的原理，因此这个例子中我们将使用一个工作量证明（POW）的共识机制。

因此，挖掘节点将侦听由区块链执行的交易，并执行一个简单的数学任务。这个任务是用一个不断改变的一次性随机数（nonce）来生成带有一连串以 0 开头的区块哈希值，直到一个预设的哈希值被找到。

[Java 示例项目](https://github.com/in-the-keyhole/khs-blockchain-java-example)有一个 `Miner.java` 类，其中的 `proofOfWork(Block block)` 方法实现如下所示。

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

同样，这是简化的，但是一旦收到一定量的交易，这个挖矿算法会为区块计算一个工作量证明的哈希。该算法简单地循环并创建块的SHA-256散列，直到产生前导数字哈希。

这可能需要很多时间，这就是为什么特定的GPU微处理器已经被实现来尽可能快地执行和解决这个问题的原因。


### 单元测试

你可以在 GitHub上看到结合了这些概念的 Java 示例的 JUnit 测试。
[![](https://i2.wp.com/keyholesoftware.com/wp-content/uploads/junittestsblockchain.png?resize=782%2C490&ssl=1)](https://keyholesoftware.com/2018/04/10/blockchain-with-java/junittestsblockchain/)

运行一下，看看这个简单的区块链是如何工作的。

另外，如果你是 C# 程序员的话，其实（我不会告诉任何人），我们也有用 C# 写的示例。下面是 C# 区块链实现的[示例](https://github.com/in-the-keyhole/khs-blockchain-csharp-example)。

## 最后的思考

希望这篇文章能让你对区块链技术有一定的了解，并有充足的兴趣继续研究下去。

本文介绍的所有示例都用于我们的[深度区块链白皮书](https://keyholesoftware.com/wp-content/uploads/Blockchain-For-The-Enterprise-Keyhole-White-Paper.pdf) (无需注册即可阅读). 这些例子在白皮书中有更详细的说明。

另外，如果你想在 Java 中看到完整的区块链实现，这里有一个开源项目 BitcoinJ 的[链接](https://github.com/bitcoinj/bitcoinj)。你可以看到上文的概念在实际生产中一一实现。

如果是这样的话，推荐你看看更贴近生产的开源区块链框架。一个很好的示例是 [HyperLedger Fabric](https://www.hyperledger.org/projects/fabric)，这将是我下一篇文章的主题 —— 请持续关注！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
