> * 原文地址：[Blockchain Implementation With Java Code](https://dzone.com/articles/blockchain-implementation-with-java-code)
> * 原文作者：[David Pitt](https://dzone.com/users/2933125/dpittkhs.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/blockchain-implementation-with-java-code.md](https://github.com/xitu/gold-miner/blob/master/TODO1/blockchain-implementation-with-java-code.md)
> * 译者：
> * 校对者：

# Blockchain Implementation With Java Code

Let's take a look at a possible blockchain implementation using Java. We build up from first principles and develop some code to help show how it all fits together.

Bitcoin is hot — _and what an understatement that is_. While the future of cryptocurrency is somewhat uncertain, blockchain — the technology used to drive Bitcoin — is also very popular.

Blockchain has an almost endless application scope. It also arguably has the potential to disrupt enterprise automation. There is a lot of information available covering what and how blockchain works. We have a [free whitepaper](https://keyholesoftware.com/wp-content/uploads/Blockchain-For-The-Enterprise-Keyhole-White-Paper.pdf) that goes into blockchain technology (no registration required).

This article will focus on the blockchain architecture; particularly, demonstrating how the "immutable, append-only" distributed ledger works with simplistic code examples.

As developers, seeing things in code can be much more useful in understanding how it works when compared to simply reading technical articles. At least that's the case for me. So, let's get started!

## Blockchain in a Nutshell

Let's first give a quick summary of blockchain. A block contains some header information and a set or block of transactions of any type of data. The chain starts with a first (Genesis) block. As transactions are added/appended, new blocks are created based on how many transactions can be stored within a block.

When a block threshold size is exceeded, then a new block of transactions is created. The new block is linked to the previous block, hence the term blockchain.

### Immutability

Blockchains are immutable because an SHA-256 hash is computed for transactions. A block's contents are also hashed which provide a unique identifier. Moreover, the hash from the linked, previous block is also stored and hashed in the block header.

This is why trying to tamper with a blockchain block is basically impossible, at least with current computing power. Here's a partial Java class definition showing the properties of the block.

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

// caches Transaction SHA256 hashes
    public Map&lt;String,T&gt; map = new HashMap&lt;String,T&gt;();
...
```

Notice the injected generic type is of type `Tx`. This allows transaction data to vary. Also, the `previousHash` property will reference the previous block's hash. The `merkleRoot` and `nonce` properties will be described in a bit.

### Block Hash

Each block can compute a block hash. This is essentially a hash of all the block's properties concatenated together, including the previous block's hash and a SHA-256 hash computed from that.

Here is the method defined in the `Block.java` class that computes the hash.

```
...
public void computeHash() {
     Gson parser = new Gson(); // probably should cache this instance
     String serializedData = parser.toJson(transactions);  
     setHash(SHA256.generateHash(timeStamp + index + merkleRoot + serializedData + nonce + previousHash));
     }
...
```

The block transactions are serialized to a JSON string so it can be appended to the block properties before hashing.

### The Chain

The blockchain manages blocks by accepting transactions. When a predetermined threshold has been reached, then a block is created. Here is a `SimpleBlockChain.java` partial implementation:

```
...
...
public class SimpleBlockchain<T extends Tx> {
public static final int BLOCK_SIZE = 10;
public List<Block<T>> chain = new ArrayList<Block<T>>();

public SimpleBlockchain() {
// create genesis block
chain.add(newBlock());
}

...
```

Notice that the chain property holds a list of Blocks typed with a `Tx` type. Also, the `no arg` constructor creates an initial "genesis" block when the chain is created. Here is the source for the `newBlock()` method.

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

This new block method will create a new block instance, seed appropriate values, and assign the previous block's hash (which will be the hash of the head of the chain). It will then return the block.

Blocks can be validated before being added to the chain by comparing the new block's previous hash to the last block (head) of the chain to make sure they match. Here's a `SimpleBlockchain.java` method depicting this.

```
....
public void addAndValidateBlock(Block<T> block) {

// compare previous block hash, add if valid
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

The entire blockchain is validated by the looping-over of the chain to ensure a block's hash still matches the previous block's hash.

Here is the `SimpleBlockChain.java validate()` method implementation.

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

You can see that trying to fudge transaction data or any other property in any way is very difficult. And, as the chain grows, it continues to get very, very, very difficult, essentially impossible — that is, until quantum computers are available!

### Adding Transactions

Another significant technical point of blockchain technology is that it is distributed. The fact that they are append-only helps in duplicating the blockchain across nodes participating in the blockchain network. Nodes typically communicate in a peer-to-peer fashion, as is the case with Bitcoin, but it does not have to be this way. Other blockchain implementations use a decentralized approach, like using APIs via HTTP. However, that is a topic for another article.

Transactions can represent just about anything. A transaction could contain code to execute (i.e Smart Contract) or store and append information about some kind of business transaction.

**Smart contract**: Computer protocol intended to digitally facilitate, verify, or enforce the negotiation or performance of a contract.

In the case of Bitcoin, a transaction contains an amount from an owner's account and amount(s) to other accounts (e.g. transferring Bitcoin amounts between accounts). The transaction also includes public keys and account IDs within it, so transferring is done securely. But that's Bitcoin-specific.

Transactions are added to a network and pooled; they are not in a block or the chain itself.

This is where a blockchain **consensus mechanism** comes into play. There are a number of proven consensus algorithm and patterns beyond the scope of this article.

**Mining** is a consensus mechanism that Bitcoin blockchains use. That is the type of consensus discussed further down this article. The consensus mechanism gathers transactions, builds a block with them, and then adds the block to the chain. The chain then validates the new block of transactions before adding to the chain.

### Merkle Trees

Transactions are hashed and added to the block. A Merkle Tree data structure is created to compute a Merkle Root hash. Each block will store the root of the Merkle tree, which is a balanced binary tree of hashes where interior nodes are hashes of the two child hashes, all the way up to the root hash, which is the Merkle Root.

[![](https://i0.wp.com/keyholesoftware.com/wp-content/uploads/Merkle-Root.png?resize=576%2C288&ssl=1)](https://keyholesoftware.com/2018/04/10/blockchain-with-java/merkle-root/)

This tree is used to validate the block transactions. If a single bit of information is changed in any transaction, the Merkle Root will be invalid. Also, they can help with transmitting blocks in a distributed fashion, since the structure allows only a single branch of transaction hashes required to add and validate the entire block of transactions.

Here's the method in the `Block.java` class that creates a Merkle Tree out of the transaction list.

```
...
public List<String> merkleTree() {
ArrayList<String> tree = new ArrayList<>();
// Start by adding all the hashes of the transactions as leaves of the
// tree.
for (T t : transactions) {
tree.add(t.hash());
}
int levelOffset = 0; // Offset in the list where the currently processed
// level starts.
// Step through each level, stopping when we reach the root (levelSize
// == 1).
for (int levelSize = transactions.size(); levelSize > 1; levelSize = (levelSize + 1) / 2) {
// For each pair of nodes on that level:
for (int left = 0; left < levelSize; left += 2) {
// The right hand node can be the same as the left hand, in the
// case where we don't have enough
// transactions.
int right = Math.min(left + 1, levelSize - 1);
String tleft = tree.get(levelOffset + left);
String tright = tree.get(levelOffset + right);
tree.add(SHA256.generateHash(tleft + tright));
}
// Move to the next level.
levelOffset += levelSize;
}
return tree;
}

...
```

This method is used to compute a Merkle Tree root for the block. The companion project has a Merkle Tree unit test that attempts to add a transaction to a block and verify that the Merkle Roots have changed. Here is the source code for the unit test.

```
...
@Test
public void merkleTreeTest() {

// create chain, add transaction

SimpleBlockchain<Transaction> chain1 = new SimpleBlockchain<Transaction>();

chain1.add(new Transaction("A")).add(new Transaction("B")).add(new Transaction("C")).add(new Transaction("D"));

// get a block in chain
Block<Transaction> block = chain1.getHead();

System.out.println("Merkle Hash tree :" + block.merkleTree());

// get a transaction from block
Transaction tx = block.getTransactions().get(0);

// see if block transactions are valid, they should be
block.transasctionsValid();
assertTrue(block.transasctionsValid());

// mutate the data of a transaction
tx.setValue("Z");

// block should no longer be valid, blocks MerkleRoot does not match computed merkle tree of transactions
assertFalse(block.transasctionsValid());

}

...
```

This unit test emulates validating transactions, then changing a transaction in a block outside of the consensus mechanism, e.g. if someone tries to change transaction data.

Remember, blockchains are append-only, and as the blockchain data structure is shared between nodes, block data structure (including the Merkle Root) are hashed and connected to other blocks. All nodes can validate new blocks and existing blocks can be easily proved as valid. So, a miner trying to add a bogus block or a node attempting to adjust older transactions are effectively not possible before the sun grows to a supernova and gives all a really nice tan.

### Mining Proof of Work

The process of combining transactions in into a block, then submitting it for validation by members of the chain, is referred to as "mining" in the Bitcoin world.

More generally, in blockchain speak, this is called consensus. There are different types of proven distributed consensus algorithms. Which mechanism to use is based upon whether you have a public or permissioned blockchain. Our white paper describes this more in depth, but this article is focusing on the blockchain mechanics, so this example we will apply a proof-of-work consensus mechanism.

So, mining nodes will listen for transactions being executed by the blockchain and will perform a simple mathematical puzzle. This puzzle produces block hash with a predetermined set of leading zeros using a nonce value that is changed on every iteration until the leading zero hash is found.

The [example Java project](https://github.com/in-the-keyhole/khs-blockchain-java-example) has a `Miner.java` class with a `proofOfWork(Block block)` method implementation, as shown below.

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

Again, this is simplified, but the miner implementation will perform a proof-of-work hash for the block once a certain number of transactions have been received. The algorithm simply loops and creates an SHA-256 hash of the block until the leading number hash is produced.

This can take a lot of time, which is why specific GPU microprocessors have been implemented to perform and solve this problem as fast as possible.

### Unit Tests

You can see all these concepts pulled together with the Java example project's JUnit tests available on GitHub.
[![](https://i2.wp.com/keyholesoftware.com/wp-content/uploads/junittestsblockchain.png?resize=782%2C490&ssl=1)](https://keyholesoftware.com/2018/04/10/blockchain-with-java/junittestsblockchain/)

Give this a run. It will let you check out how this simple blockchain works.

Also, if you are a C#'er reading, this (we won't tell anyone), we also have these same examples written in C#. Here is [the link](https://github.com/in-the-keyhole/khs-blockchain-csharp-example) to the example C# blockchain implementation.

## Final Thoughts

Hopefully, this post has provided you enough interest and insight to keep researching blockchain technology.

All of the examples introduced in this article are used in our [in-depth blockchain white paper](https://keyholesoftware.com/wp-content/uploads/Blockchain-For-The-Enterprise-Keyhole-White-Paper.pdf) (no registration required to read). These same examples are in more detail in the white paper.

Also, if you want to see a full blockchain implementation in Java, here's [a link](https://github.com/bitcoinj/bitcoinj) to the open-source BitcoinJ project. You'll see these concepts in action in a real production implementation.

If so, next recommended learning steps are to check out a more production-based open-source blockchain framework. A good example is [HyperLedger Fabric](https://www.hyperledger.org/projects/fabric). That will be the subject of my next article — stay tuned!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
