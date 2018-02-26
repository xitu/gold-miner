> * 原文地址：[Creating Your First Blockchain with Java. Part 1](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)
> * 原文作者：[Kass](https://medium.com/@cryptokass?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/create-simple-blockchain-java-tutorial-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO/create-simple-blockchain-java-tutorial-from-scratch.md)
> * 译者：[NeoyeElf](https://github.com/NeoyeElf)
> * 校对者：[yankwan](https://github.com/yankwan)

# 用 Java 创造你的第一个区块链，第一部分。

这系列文章旨在帮助你了解如何使用开发区块链技术。

本文会讲到：

* 创造你的第一个（十分）**基础的‘区块链’**。
* 实现一个简单的**验证性**（挖矿）系统。
* **奇迹是有可能发生的**.

( 本文假设你对于[面向对象编程](https://docs.oracle.com/javase/tutorial/java/concepts/)已经有了基本的了解 )

_值得注意的是，文中讲到的并不是一个功能完整，可以上线的区块链系统。相反，这只是一个概念验证性工作，来帮助你理解什么是区块链以便阅读未来的教程._

你可以通过以下方式来支持本文和将来的教程 :)

_btc: 17svYzRv4XJ1Sfi1TSThp3NBFnh7Xsi6fu_

* * *

### 准备工作.

本文准备使用 Java 作为开发语言，但是你应该能够使用任何[面向对象](https://en.wikipedia.org/wiki/Object-oriented_programming)语言来跟着一起学习。我会使用 Eclipse，不过你也可以使用任何其他喜欢的编辑器（ 虽然你会错过很多方便的功能 ）。

你需要：

* 安装 Java 和 JDK。
* Eclipse ( 或者其他 IDE/编辑器 ).

![](https://cdn-images-1.medium.com/max/800/1*3rE0ahnLzfQ7JHyxNJAH7Q.gif)

你的 eclipse 界面也许会看起来和我的不一样，不过没关系，那是因为我使用了深色主题。

你可以安装 [GSON library by google](https://repo1.maven.org/maven2/com/google/code/gson/gson/2.6.2/gson-2.6.2.jar) (_这是什么 ???_)，当然这是可选项。它可以让我们将 object 转换成 Json \o/。这是一个超级实用的库，在后面我们也将它用到 peer2peer 上，但你随时可以用一个类似的方法去替换它。

在 Eclipse 中 创建一个 Java 项目(file > new > )。我将我的项目命名为“**noobchain**”，接着创建一个新的同名 _Class_ （**NoobChain**）。

![](https://cdn-images-1.medium.com/max/800/1*VPKiJWgOiZszGvLgPNiqLA.png)

不要想着立马复制我的项目名称哦 ( ͠° ͟ ͜ʖ ͡°)

我们开了个不错的头，可以往下继续了 :)

* * *

### 创造区块链

一个区块链只是一个个区块的链接/列表。区块链中的每一个区块都会有自己的数字签名，前一个区块的数字签名和一些数据（例如一些交易数据）。

![](https://cdn-images-1.medium.com/max/800/1*627BG-7qMtaXNsX0n41C6Q.png)

我希望中本聪永远都不会看到这个.

> **_Hash = Digital Signature._**

**每一个区块不仅仅包含前一个区块的 hash 值，其自己的 hash 值，有一部分是根据前一个区块的 hash 值计算出来的**。如果前一个区块的数据发生了变化，那么前一个区块的 hash 值也会随之变化（因为它有一部分是根据区块的数据进行计算的），并会依次影响所有区块的 hash 值。**通过计算和比较 hash 值，我们可以判断区块链是否合法。**

这意味着什么？修改链中的任意数据，都会改变数字签名，进而**破坏整个区块链**。

#### 那么首先让我们来创建组成区块链的 **Block** 类：

```
import java.util.Date;

public class Block {

	public String hash;
	public String previousHash;
	private String data; //我们的数据是一条简单的消息
	private long timeStamp; //从 1/1/1970 起至现在的总毫秒数.

	//Block 类的构造方法.
	public Block(String data,String previousHash ) {
		this.data = data;
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
	}
}
```

你可以看到，我们的基础 **Block** 类包含一个 `String hash`，它代表了数字签名。`previousHash` 变量为前一个区块的 hash 值，它和 `String data` 组成了这个区块的数据。

#### **接着我们需要一种方法去生成数字签名**，

有很多加密算法可供我们选择，当然 SHA256 算法正好适合我们这个例子。我们可以通过 `import java.security.MessageDigest;` 来使用 SHA256 算法。

我们在 **StringUtil** ‘工具’ _类_ 中创建了一个方便使用的方法，以便在接下来去使用 SHA256 算法：

```
import java.security.MessageDigest;

public class StringUtil {
	//使用 Sha256 算法加密一个字符串，返回计算结果
	public static String applySha256(String input){		
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");	        
			//对输入使用 sha256 算法
			byte[] hash = digest.digest(input.getBytes("UTF-8"));	        
			StringBuffer hexString = new StringBuffer(); // 它会包含16进制的 hash 值
			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexString.append('0');
				hexString.append(hex);
			}
			return hexString.toString();
		}
		catch(Exception e) {
			throw new RuntimeException(e);
		}
	}	
}
```

上面基本上是复制的这篇文章中的方法 [http://www.baeldung.com/sha-256-hashing-java](http://www.baeldung.com/sha-256-hashing-java)

**如果你不理解这个辅助方法的内容，也不用担心。** _你只需要知道，它接受一个字符串作为输入，并对其使用 SHA256 算法，最后将返回的字符串作为数字签名。_ 

现在让我们在 **Block** _class_ 中的一个新方法里使用 **applySha256** 辅助方法来计算 hash 值。我们必须根据区块中那些不想被篡改的数据来计算 hash 值。对于本文中的区块，我们会包含 `previousHash`、`data` 和 `timeStamp`。

```
public String calculateHash() {
	String calculatedhash = StringUtil.applySha256( 
			previousHash +
			Long.toString(timeStamp) +
			data 
			);
	return calculatedhash;
}
```

让我们把这个方法加入到 **Block** _构造方法_ 中去...

```
	public Block(String data,String previousHash ) {
		this.data = data;
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
		this.hash = calculateHash(); //Making sure we do this after we set the other values.
	}
```

#### **是时候做些测试了...**

让我们在主类 **NoobChain** 中新建一些区块对象并将其 hash 值打印到屏幕上，来确保一切工作正常有序。

![](https://cdn-images-1.medium.com/max/800/1*I6k_gZJ0KRZYR4KU22Okig.gif)

开始测试...

第一个区块被命名为起始区块，由于它前面没有区块，所以我们用 “0” 作为其前一个区块的 hash 值。

```
public class NoobChain {

	public static void main(String[] args) {
		
		Block genesisBlock = new Block("Hi im the first block", "0");
		System.out.println("Hash for block 1 : " + genesisBlock.hash);
		
		Block secondBlock = new Block("Yo im the second block",genesisBlock.hash);
		System.out.println("Hash for block 2 : " + secondBlock.hash);
		
		Block thirdBlock = new Block("Hey im the third block",secondBlock.hash);
		System.out.println("Hash for block 3 : " + thirdBlock.hash);
		
	}
}
```

这段程序的输出应该长下面这样：

![](https://cdn-images-1.medium.com/max/800/0*uRnxW_CqB6FqWiUd.png)

由于时间戳不一样，你的 hash 值和我的应该会不同。

现在，每一个区块应该拥有自己的基于区块数据和前一个区块签名计算出来的数字签名

目前，这还并不是区块**链**，所以让我们将区块存储在一个 _ArrayList_ 中并导入 gson 库来将其输出为 Json 字符串。_(_[_点击这里查看如何导入 gson 库_](https://medium.com/@cryptokass/importing-gson-into-eclipse-ec8cf678ad52)_)_

```
import java.util.ArrayList;
import com.google.gson.GsonBuilder;

public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>(); 

	public static void main(String[] args) {	
		//将我们的区块加入到区块链 ArrayList 中：
		blockchain.add(new Block("Hi im the first block", "0"));		
		blockchain.add(new Block("Yo im the second block",blockchain.get(blockchain.size()-1).hash)); 
		blockchain.add(new Block("Hey im the third block",blockchain.get(blockchain.size()-1).hash));
		
		String blockchainJson = new GsonBuilder().setPrettyPrinting().create().toJson(blockchain);		
		System.out.println(blockchainJson);
	}

}
```

现在我们的输出应该更加接近我们期望的区块链的样子。

#### 现在我们需要一种方法来检查区块链的完整合法性

让我们在 **NoobChain** _类_ 中新建一个返回值为 _Boolean_ 的 **isChainValid()** 方法，它会循环链中所有的区块并比较其 hash 值。这个方法需要能够检查当前区块的 hash 值和计算出来的 hash 值是否相等以及前一个区块的 hash 值是否等于当前区块存储的 **previousHash** 值。

```
public static Boolean isChainValid() {
	Block currentBlock; 
	Block previousBlock;
	
	//循环区块链并检查 hash 值：
	for(int i=1; i < blockchain.size(); i++) {
		currentBlock = blockchain.get(i);
		previousBlock = blockchain.get(i-1);
		//比较当前区块存储的 hash 值和计算出来的 hash 值：
		if(!currentBlock.hash.equals(currentBlock.calculateHash()) ){
			System.out.println("Current Hashes not equal");			
			return false;
		}
		//比较前一个区块存储的 hash 值和当前区块存储的 previousHash 值：
		if(!previousBlock.hash.equals(currentBlock.previousHash) ) {
			System.out.println("Previous Hashes not equal");
			return false;
		}
	}
	return true;
}
```

对链中的区块做任何改变都会导致这个方法返回 false。

在比特币网络中，区块链被每个节点所共享，最长的合法链会被接受。那么靠什么去阻止某人篡改旧区块中的数据，然后创建一个全新的更长的区块链并将其分享到网络中？**答案是区块链的合法性验证工作量**。 _hashcash_ 的验证工作意味着计算机需要大量的时间和计算能力来创建新的区块。因此，攻击者需要比其他同行拥有更多的计算能力。

![](https://cdn-images-1.medium.com/max/800/1*R_bfhtxuHqM6aJYCZiQA9g.gif)

hashcash, 那需要很大的工作量哦.

### 开始挖矿吧！！！

我们要求 _miners_ 去做验证性工作，**通过在区块中尝试不同的参数值直到其 hash 值以若干个 0 开头。**

让我们新增一个 _int_ 类型的 **nonce** 变量，并将其使用到 **calculateHash()** 方法和十分重要的 **mineBlock()** 方法中：

```
import java.util.Date;

public class Block {
	
	public String hash;
	public String previousHash; 
	private String data; //我们的数据是一条简单的消息
	private long timeStamp; //从 1/1/1970 起至现在的总毫秒数.
	private int nonce;
	
	//Block 类构造方法.  
	public Block(String data,String previousHash ) {
		this.data = data;
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
		
		this.hash = calculateHash(); //Making sure we do this after we set the other values.
	}
	
	//根据区块内容计算其新 hash 值
	public String calculateHash() {
		String calculatedhash = StringUtil.applySha256( 
				previousHash +
				Long.toString(timeStamp) +
				Integer.toString(nonce) + 
				data 
				);
		return calculatedhash;
	}
	
	public void mineBlock(int difficulty) {
		String target = new String(new char[difficulty]).replace('\0', '0'); //创建一个用 difficulty * "0" 组成的字符串
		while(!hash.substring( 0, difficulty).equals(target)) {
			nonce ++;
			hash = calculateHash();
		}
		System.out.println("Block Mined!!! : " + hash);
	}
}
```

实际上，每个挖矿者会从一个随机点开始迭代计算。一些挖矿者甚至会尝试使用随机数作为 nonce。值得注意的是，更复杂的解决方案的计算值可能会超过 integer 最大值，这时挖矿者可以尝试更改时间戳。

**mineBlock()** 方法接受一个 int 类型的 difficulty 参数，这是程序需要计算处理的 0 的数量。像 1 或 2 这样低难度的 difficulty 值，也许一台计算机就可以解决了。所以我建议将 difficulty 的值设置为 4-6 来做测试。现在莱特币挖矿的 difficulty 值约为 442,592。

让我们在 NoobChain 类中新增一个静态变量 difficulty：

```
public static int difficulty = 5;
```

我们应该更新 **NoobChain** _类_ 去触发每个新区块的 **mineBlock()** _方法_。 返回 _布尔值_ 的 **isChainValid()** 还应检查每个区块（通过挖矿）计算出来的 hash 是否合法。

```
import java.util.ArrayList;
import com.google.gson.GsonBuilder;

public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>();
	public static int difficulty = 5;

	public static void main(String[] args) {	
		//将我们的区块添加至区块链 ArrayList 中：
		
		blockchain.add(new Block("Hi im the first block", "0"));
		System.out.println("Trying to Mine block 1... ");
		blockchain.get(0).mineBlock(difficulty);
		
		blockchain.add(new Block("Yo im the second block",blockchain.get(blockchain.size()-1).hash));
		System.out.println("Trying to Mine block 2... ");
		blockchain.get(1).mineBlock(difficulty);
		
		blockchain.add(new Block("Hey im the third block",blockchain.get(blockchain.size()-1).hash));
		System.out.println("Trying to Mine block 3... ");
		blockchain.get(2).mineBlock(difficulty);	
		
		System.out.println("\nBlockchain is Valid: " + isChainValid());
		
		String blockchainJson = new GsonBuilder().setPrettyPrinting().create().toJson(blockchain);
		System.out.println("\nThe block chain: ");
		System.out.println(blockchainJson);
	}
	
	public static Boolean isChainValid() {
		Block currentBlock; 
		Block previousBlock;
		String hashTarget = new String(new char[difficulty]).replace('\0', '0');
		
		//循环区块链来检查 hash 值的合法性：
		for(int i=1; i < blockchain.size(); i++) {
			currentBlock = blockchain.get(i);
			previousBlock = blockchain.get(i-1);
			//比较当前区块存储的 hash 值和计算出来的 hash 值：
			if(!currentBlock.hash.equals(currentBlock.calculateHash()) ){
				System.out.println("Current Hashes not equal");			
				return false;
			}
			//比较前一个区块存储的 hash 值和当前区块存储的 previousHash 值：
			if(!previousBlock.hash.equals(currentBlock.previousHash) ) {
				System.out.println("Previous Hashes not equal");
				return false;
			}
			//检查 hash 值是否已经存在
			if(!currentBlock.hash.substring( 0, difficulty).equals(hashTarget)) {
				System.out.println("This block hasn't been mined");
				return false;
			}
		}
		return true;
	}
}
```

同时我们还检查了 _isChainValid_ 值，并将其打印出来。

运行这个程序的输出应该像下面这样：

![](https://cdn-images-1.medium.com/max/800/1*qzjPDdgOESJSwDSP0peEEg.png)

对每个区块的计算都需要花费一些时间！ （大约3秒）你应该仔细研究下 difficulty 值，看看它是如何影响每个区块的计算时间的 :)

如果有人试图去**篡改** 😒 你系统中区块链的数据：

* 他们的区块链会变得不合法。
* 他们将无法创建一个更长的区块链。
* 网络中合法的区块链在链长度上将会具有时间优势。

**一个被篡改的区块链不会同时合法且具有长度优势的。***

*除非它们的计算速度远远超过网络中所有其他节点的总和。比如有一台未来量子计算机之类的。

### 恭喜你，你已经实现了自己的基础区块链！

![](https://cdn-images-1.medium.com/max/800/1*9K4pVMSdI7A0YZH-g47I2w.gif)

拍拍你自己的肩膀把。

你的区块链：

**> 是由存储数据的一个个区块组成的。**

**> 有一个将你所有的区块串连起来的数字签名。**

**> 对于新加入的区块，需要一系列的挖矿验证性工作去检查其合法性。**

**> 可以检查数据是否合法和是否被篡改。**

你可以在 [Github](https://github.com/CryptoKass/NoobChain-Tutorial-Part-1) 上下载本文的项目。

![](https://cdn-images-1.medium.com/max/800/1*ZbFDb_ml08yDSRXyzhFGxA.gif)

你可以**关注我**，当下个教程和其他区块链开发文章发布时便可以及时得到通知。十分欢迎任何反馈信息。谢谢。

### [Creating Your First Blockchain with Java. Part 2:](https://medium.com/programmers-blockchain/creating-your-first-blockchain-with-java-part-2-transactions-2cdac335e0ce)

下个教程的内容将涉及区块链的**交易**，**签名**和**钱包**。

联系: kassCrypto@gmail.com

**提问**：[https://discord.gg/ZsyQqyk](https://discord.gg/ZsyQqyk) (我在 discord 上的区块链开发者俱乐部)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

