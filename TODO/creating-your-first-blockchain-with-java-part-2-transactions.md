> * 原文地址：[Jan 20 Creating Your First Blockchain with Java. Part 2 — Transactions](https://medium.com/programmers-blockchain/creating-your-first-blockchain-with-java-part-2-transactions-2cdac335e0ce)
> * 原文作者：[Kass](https://medium.com/@cryptokass?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/creating-your-first-blockchain-with-java-part-2-transactions.md](https://github.com/xitu/gold-miner/blob/master/TODO/creating-your-first-blockchain-with-java-part-2-transactions.md)
> * 译者：[IllllllIIl](https://github.com/IllllllIIl)
> * 校对者：[jaymz1439](https://github.com/jaymz1439)，[NeoyeElf](https://github.com/NeoyeElf)

# 用 Java 创造你的第一个区块链之第二部分 —— 交易

这一系列教程的目的是帮助你们对区块链开发技术有一个大致的蓝图，你可以在这里找到教程的[**第一部分**](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)。

在教程的第二部分我们会：

* **生成一个简单的钱包。**
* **使用我们的区块链发送带有签名的交易。**
* **自我陶醉。**

**以上这些最终会造出我们自己的加密货币（类似那样吧）！**

![](https://cdn-images-1.medium.com/max/800/1*7qqSMkUfrrENWkqPUYVYYQ.gif)

不用担心这篇文章只是空谈，怎么说都比上一篇教程有更多干货！文长不看的话，可以直接看源码 [Github](https://github.com/CryptoKass/NoobChain-Tutorial-Part-2/tree/master/src/noobchain)。

***

[上一篇教程](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)我们说到，我们有了一个基本的可验证区块链。但是现在我们的区块链只能存储相当没用的数据信息。今天我们要将这些无用数据替换为交易数据（我们的区块将能够存储多次交易），这样我们便可以创造一个十分简单的加密货币。我们把这种新币叫做：“菜鸟币”（英文原文：noobcoin）。

* 这个教程假设你已经阅读过另一篇[教程](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)。
* 依赖：你需要导入 [**bounceycastle**](https://www.bouncycastle.org/latest_releases.html)（[**这是一个简单的操作教程**](https://medium.com/@cryptokass/importing-bouncy-castle-into-eclipse-24e0dda55f21)）和 [**GSON**](http://central.maven.org/maven2/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar)。

### 1.准备一个钱包

在加密货币中，货币所有权以交易的方式在区块链中转移，交易参与者持有资金的发送方和接收方的地址。**如果只是钱包的基本形式，钱包可以只存储这些地址信息。然而，大多数钱包在软件层面上也能够生成新的交易。**

![](https://cdn-images-1.medium.com/max/1000/1*ygobWJSoGiJ2uMh-sP0Nig.png)

不用担心关于交易部分的知识，我们很快会解释这些。

让我们创建一个 **Wallet** 类来持有我们的公钥和私钥信息：

```
package noobchain;
import java.security.*;

public class Wallet {
	public PrivateKey privateKey;
	public PublicKey publicKey;
}
```

请确保导入了 java.security.* 包 ！

**这些公钥和私钥是用来干嘛的？**

对于我们的“菜鸟币”来说，公钥就是作为我们的地址。你可以与他人分享公钥以便能收到付款。而我们的私钥是用来对我们的交易进行签名，这样除了私钥的主人就没人可以偷花我们的菜鸟币。 **用户必须保管好自己的私钥！** 我们在交易的过程中也会发送出我们的公钥，公钥也可以用来验证我们的签名是否合法和数据是否被篡改。

![](https://cdn-images-1.medium.com/max/1000/1*5bOYYuEgKPBNknyKeQQxNA.png)

私钥是用来对我们的数据进行签名，防止被篡改。公钥是用来验证这个签名。

我们以一对 **KeyPair** 的形式生成私钥和公钥。我们会采用[椭圆曲线密码学](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography)去生成我们的 **KeyPairs**。 我们在 Wallet 类中添加一个 _generateKeyPair()_ 方法，并且在构造方法中调用它：

```
package noobchain;
import java.security.*;

public class Wallet {
	
	public PrivateKey privateKey;
	public PublicKey publicKey;
	
	public Wallet(){
		generateKeyPair();	
	}
		
	public void generateKeyPair() {
		try {
			KeyPairGenerator keyGen = KeyPairGenerator.getInstance("ECDSA","BC");
			SecureRandom random = SecureRandom.getInstance("SHA1PRNG");
			ECGenParameterSpec ecSpec = new ECGenParameterSpec("prime192v1");
			// 初始化 KeyGenerator 并且生成一对 KeyPair
			keyGen.initialize(ecSpec, random);   //256 字节大小是可接受的安全等级
	        	KeyPair keyPair = keyGen.generateKeyPair();
	        	// 从 KeyPair中获取公钥和私钥
	        	privateKey = keyPair.getPrivate();
	        	publicKey = keyPair.getPublic();
		}catch(Exception e) {
			throw new RuntimeException(e);
		}
	}
	
}
```

关于这个方法你所需要了解的就是它使用了 Java.security.KeyPairGenerator 去生成一个应用椭圆曲线密码学的 KeyPair。这个方法生成公钥和私钥并赋值到对应的公钥私钥对象。它很实用。

既然我们对 Wallet 类有了大致的认识，接下来看一下交易的部分。

### 2. 交易和签名

每一个交易都包含一定大小的数据：

* 资金发送方的公钥（地址）。
* 资金接受方的公钥（地址）。
* 要转账的资金数额。
* 输入，是上一次交易的引用，证明发送方有资金可以发送出去。
* 输出，是在交易中接收方收到的金额。 （在新交易中这些输出也会被当作是输入）
* 一个加密的签名，证明地址的所有者是发送这个交易的人并且发送的数据没有被篡改。（例如，阻止第三方更改发送出去的数额）

让我们写一个新的 Transaction 类：

```
import java.security.*;
import java.util.ArrayList;

public class Transaction {
	
	public String transactionId; // 这个也是交易的哈希值
	public PublicKey sender; // 发送方地址/公钥
	public PublicKey reciepient; // 接受方地址/公钥
	public float value;
	public byte[] signature; // 用来防止他人盗用我们钱包里的资金
	
	public ArrayList<TransactionInput> inputs = new ArrayList<TransactionInput>();
	public ArrayList<TransactionOutput> outputs = new ArrayList<TransactionOutput>();
	
	private static int sequence = 0; // 对已生成交易个数的粗略计算 
	
	// 构造方法： 
	public Transaction(PublicKey from, PublicKey to, float value,  ArrayList<TransactionInput> inputs) {
		this.sender = from;
		this.reciepient = to;
		this.value = value;
		this.inputs = inputs;
	}
	
	// 用来计算交易的哈希值（可作为交易的 id）
	private String calulateHash() {
		sequence++; //increase the sequence to avoid 2 identical transactions having the same hash
		return StringUtil.applySha256(
				StringUtil.getStringFromKey(sender) +
				StringUtil.getStringFromKey(reciepient) +
				Float.toString(value) + sequence
				);
	}
}
```

我们应该也写一个空的 **TransactionInput** 类和 **TransactionOutput** 类，我们之后会把它们补上。

我们的交易类也包含了生成/验证签名和验证交易的相关方法。

但等一下。。。

#### 这些签名的目的和工作方式是什么？

**签名**在我们区块链中起到的**两个**很重要的工作就是： 第一，它们允许所有者去花他们的钱，第二，防止他人在新的一个区块被挖出来之前（进入到整个区块链），篡改他们已提交的交易。

> 私钥用来对数据进行签名，公钥用来验证它的合法性。

> **例如：**Bob 想给 Sally 两个菜鸟币，所以他们的钱包客户端生成这个交易并且递交给矿工，使其成为下一个区块的一部分。有一个矿工尝试把这两个币的接受人篡改为 John。然而，很幸运地是，Bob 已经用他的私钥把交易数据签名了，任何人使用 Bob 的公钥就能验证这个交易的数据是否被篡改了（其他人的公钥无法校验此交易）。

（从之前的代码中）我们可以看到我们的签名会包含很多字节的信息，所以我们创建一个生成这些信息的方法。首先我们在 **StringUtil** 类中写几个辅助方法：

```
//采用 ECDSA 签名并返回结果（以字节形式）
		public static byte[] applyECDSASig(PrivateKey privateKey, String input) {
		Signature dsa;
		byte[] output = new byte[0];
		try {
			dsa = Signature.getInstance("ECDSA", "BC");
			dsa.initSign(privateKey);
			byte[] strByte = input.getBytes();
			dsa.update(strByte);
			byte[] realSig = dsa.sign();
			output = realSig;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return output;
	}
	
	//验证一个字符串签名
	public static boolean verifyECDSASig(PublicKey publicKey, String data, byte[] signature) {
		try {
			Signature ecdsaVerify = Signature.getInstance("ECDSA", "BC");
			ecdsaVerify.initVerify(publicKey);
			ecdsaVerify.update(data.getBytes());
			return ecdsaVerify.verify(signature);
		}catch(Exception e) {
			throw new RuntimeException(e);
		}
	}

	public static String getStringFromKey(Key key) {
		return Base64.getEncoder().encodeToString(key.getEncoded());
	}
```

不用过分地去弄懂这些方法具体怎么工作的。你真正要了解的是： applyECDSASig 方法接收发送方的私钥和字符串输入，进行签名并返回一个字节数组。verifyECDSASig 方法接收签名，公钥和字符串，根据签名的有效性返回 true 或 false。getStringFromKey 方法就是接受任何一种私钥，返回一个加密的字符串。

现在我们在 **Transaction** 类中使用这些签名相关的方法，添加 **generateSignature()** 和 **verifiySignature()** 方法。

```
//对所有我们不想被篡改的数据进行签名
public void generateSignature(PrivateKey privateKey) {
	String data = StringUtil.getStringFromKey(sender) + StringUtil.getStringFromKey(reciepient) + Float.toString(value)	;
	signature = StringUtil.applyECDSASig(privateKey,data);		
}
//验证我们已签名的数据
public boolean verifiySignature() {
	String data = StringUtil.getStringFromKey(sender) + StringUtil.getStringFromKey(reciepient) + Float.toString(value)	;
	return StringUtil.verifyECDSASig(sender, data, signature);
}
```

实际上，你可能想对更多信息加入签名，像输出/输入或是时间戳（但现在我们只想对最基本的信息进行签名）。

签名可以由矿工进行验证，就像一个新交易被验证后添加到一个区块中。

![](https://cdn-images-1.medium.com/max/800/1*hWYSlaQWuak3Wya_81gy2w.gif)

当检查区块链的合法性的时候，我们同样也可以检查签名。

### 3.测试钱包和签名：

现在我们快完成一半的工作量了，去测试一下吧。在 **NoobChain** 类中，添加一些新变量并替换掉 **main** 方法中的相应内容：

```
import java.security.Security;
import java.util.ArrayList;
import java.util.Base64;
import com.google.gson.GsonBuilder;

public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>();
	public static int difficulty = 5;
	public static Wallet walletA;
	public static Wallet walletB;

	public static void main(String[] args) {	
		//设置 Bouncey castle 作为 Security Provider
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider()); 
		//创建新的钱包 
		walletA = new Wallet();
		walletB = new Wallet();
		//测试公钥和私钥
		System.out.println("Private and public keys:");
		System.out.println(StringUtil.getStringFromKey(walletA.privateKey));
		System.out.println(StringUtil.getStringFromKey(walletA.publicKey));
		//生成从 WalletA 到 walletB 的测试交易 
		Transaction transaction = new Transaction(walletA.publicKey, walletB.publicKey, 5, null);
		transaction.signature = transaction.generateSignature(walletA.privateKey);
		//验证签名是否起作用并结合公钥验证
		System.out.println("Is signature verified");
		System.out.println(transaction.verifiySignature());
		
	}
```

请务必记得把 boncey castle 添加为 security provider。

我们创建了两个钱包，walletA 和 walletB，然后打印出 walletA 的私钥和公钥。生成了一个 Transaction 并使用 walletA 的公钥对其签名。然后就是希望一切能正常工作吧。

你的输出应该像这样子：

![](https://cdn-images-1.medium.com/max/800/1*60pXu88f-WyPbFYWIXU8iQ.png)
签名按照预想应该被验证为 true。

应该小小地表扬下自己了。现在我们只需创建/验证输出和输入，然后把交易存储在区块链中。

### 4. 输入和输出 1：自己是怎么持有加密货币的

如果你想拥有一个比特币，那你要先收到一个比特币。交易账单不会真的把一个比特币加给你，也不会从发送方那里减去一个比特币。发送方有标识证明他/她之前收到过一个比特币，然后交易输出就会生成，显示一个比特币已经发送到你的地址（交易中的输入来源于之前交易的输出）。

> 你的钱包余额是你所有的未花费的交易输出。

在这点上我们会跟比特币的叫法一样，把未花费的交易输出称为：**UTXO**。

我们再写一个 **TransactionInput** 类：

```
public class TransactionInput {
	public String transactionOutputId; //把 TransactionOutputs 标识为对应的transactionId
	public TransactionOutput UTXO; //包括了所有未花费的交易输出
	
	public TransactionInput(String transactionOutputId) {
		this.transactionOutputId = transactionOutputId;
	}
}
```

这个类会被用作未花费的 TransactionOutputs 的引用。transactionOutputId 被用来查找相关的 TransactionOutput，允许矿工检查你的所有权。

还有 **TransactionOutputs** 类：

```
import java.security.PublicKey;

public class TransactionOutput {
	public String id;
	public PublicKey reciepient; //这些币的新持有者
	public float value; //他们持有币的总额
	public String parentTransactionId; //生成这个输出的之前交易的 id
	
	//构造方法
	public TransactionOutput(PublicKey reciepient, float value, String parentTransactionId) {
		this.reciepient = reciepient;
		this.value = value;
		this.parentTransactionId = parentTransactionId;
		this.id = StringUtil.applySha256(StringUtil.getStringFromKey(reciepient)+Float.toString(value)+parentTransactionId);
	}
	
	//检查币是否属于你
	public boolean isMine(PublicKey publicKey) {
		return (publicKey == reciepient);
	}
	
}
```

交易输出会显示最终发送给各接收方的金额。这些输出，在新交易中会被当作输入，作为你有资金可以发送出去的凭据。

![](https://cdn-images-1.medium.com/max/800/1*wylnsMFHeHKd0SNqZgyiYg.gif)

### 5. 输入和输出 2：处理交易

区块可能收到很多交易并且区块链长度可能会很长，这样会花非常长时间去处理一个新的交易，因为需要去查找和检查它的输入。为了处理这个问题，我们要再写一个可用作输出的未花费交易集合。在 **NoobChain** 类中，加入 **_UTXOs_** 集合：

```
public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>();
	public static HashMap<String,TransactionOutputs> UTXOs = new HashMap<String,TransactionOutputs>(); //未花费交易的 list 
	public static int difficulty = 5;
	public static Wallet walletA;
	public static Wallet walletB;

	public static void main(String[] args) {
```

HashMaps 通过 key 去找到 value，但你需要引入 java.util.HashMap。

好，接下来就是重点了。

把处理交易的方法 processTransaction 放到 **Transaction** 类里面：

```
//如果新交易可以生成，返回 true	
public boolean processTransaction() {
		
		if(verifiySignature() == false) {
			System.out.println("#Transaction Signature failed to verify");
			return false;
		}
				
		//整合所有交易输入（确保是未花费的）
		for(TransactionInput i : inputs) {
			i.UTXO = NoobChain.UTXOs.get(i.transactionOutputId);
		}

		//检查交易是否合法
		if(getInputsValue() < NoobChain.minimumTransaction) {
			System.out.println("#Transaction Inputs to small: " + getInputsValue());
			return false;
		}
		
		//生成交易输出
		float leftOver = getInputsValue() - value; //获取剩余的零钱
		transactionId = calulateHash();
		outputs.add(new TransactionOutput( this.reciepient, value,transactionId)); //send value to recipient
		outputs.add(new TransactionOutput( this.sender, leftOver,transactionId)); //把剩下的“零钱“发回给发送方		
				
		//添加输出到未花费的 list 中
		for(TransactionOutput o : outputs) {
			NoobChain.UTXOs.put(o.id , o);
		}
		
		//从 UTXO list里面移除已花费的交易输出
		for(TransactionInput i : inputs) {
			if(i.UTXO == null) continue; //if Transaction can't be found skip it 
			NoobChain.UTXOs.remove(i.UTXO.id);
		}
		
		return true;
	}
	
//返回输入(UTXOs) 值的总额
	public float getInputsValue() {
		float total = 0;
		for(TransactionInput i : inputs) {
			if(i.UTXO == null) continue; //if Transaction can't be found skip it 
			total += i.UTXO.value;
		}
		return total;
	}

//返回输出总额
	public float getOutputsValue() {
		float total = 0;
		for(TransactionOutput o : outputs) {
			total += o.value;
		}
		return total;
	}
```

同样再添加一个 getInputsValue 方法。

通过这个方法进行一些检查，去验证交易合法性，然后整合输入并生成输出（看看代码里的注释会清楚点）。

重要的一点，在最后，我们把 Inputs 从 _UTXO_ list里面移除了，说明一个**交易输出**作为一个输入只能使用一次。因此，输入的总数值必须都花出去，这样发送方才有剩余“零钱”可拿回来。

![](https://cdn-images-1.medium.com/max/1000/1*4wZbhhT98hIyt4jtLdePgQ.png)

红色箭头是输出。注意绿色的输入来自之前的输出。

最后更新我们的钱包：

* 收集我们的余额（通过循环 UTXO list并检查一个交易输出是否是自己的钱币）
* 为我们生成交易

```
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Wallet {
	
	public PrivateKey privateKey;
	public PublicKey publicKey;
	
	public HashMap<String,TransactionOutput> UTXOs = new HashMap<String,TransactionOutput>(); //只是这个钱包拥有的 UTXO 
	
	public Wallet() {...
		
	public void generateKeyPair() {...
	
  //返回余额并存储这个钱包的 UTXO 
	public float getBalance() {
		float total = 0;	
        for (Map.Entry<String, TransactionOutput> item: NoobChain.UTXOs.entrySet()){
        	TransactionOutput UTXO = item.getValue();
            if(UTXO.isMine(publicKey)) { //if output belongs to me ( if coins belong to me )
            	UTXOs.put(UTXO.id,UTXO); //add it to our list of unspent transactions.
            	total += UTXO.value ; 
            }
        }  
		return total;
	}
	//从这个钱包生成并返回一个新的交易
	public Transaction sendFunds(PublicKey _recipient,float value ) {
		if(getBalance() < value) { //gather balance and check funds.
			System.out.println("#Not Enough funds to send transaction. Transaction Discarded.");
			return null;
		}
    //生成输入的 ArrayList
		ArrayList<TransactionInput> inputs = new ArrayList<TransactionInput>();
    
		float total = 0;
		for (Map.Entry<String, TransactionOutput> item: UTXOs.entrySet()){
			TransactionOutput UTXO = item.getValue();
			total += UTXO.value;
			inputs.add(new TransactionInput(UTXO.id));
			if(total > value) break;
		}
		
		Transaction newTransaction = new Transaction(publicKey, _recipient , value, inputs);
		newTransaction.generateSignature(privateKey);
		
		for(TransactionInput input: inputs){
			UTXOs.remove(input.transactionOutputId);
		}
		return newTransaction;
	}
	
}
```

自己想的话可以再给钱包添加其它的功能，例如记录交易历史。

#### 6. 添加交易到我们的区块：

现在我们有一个运作的交易系统，需要把它整合到区块链中。我们应该用交易的 ArrayList 替换掉之前在区块中占位的无用数据。然而，在一个区块中就可能有 1000 个交易，多到我们的哈希计算无法承受。但是不怕，我们可以使用交易的 merkle root 进行处理（你很快就会读到关于 merkle tree 的东西）。

在 StringUtils 添加一个方法去生成 merkleroot：

```
//Tacks in array of transactions and returns a merkle root.
public static String getMerkleRoot(ArrayList<Transaction> transactions) {
		int count = transactions.size();
		ArrayList<String> previousTreeLayer = new ArrayList<String>();
		for(Transaction transaction : transactions) {
			previousTreeLayer.add(transaction.transactionId);
		}
		ArrayList<String> treeLayer = previousTreeLayer;
		while(count > 1) {
			treeLayer = new ArrayList<String>();
			for(int i=1; i < previousTreeLayer.size(); i++) {
				treeLayer.add(applySha256(previousTreeLayer.get(i-1) + previousTreeLayer.get(i)));
			}
			count = treeLayer.size();
			previousTreeLayer = treeLayer;
		}
		String merkleRoot = (treeLayer.size() == 1) ? treeLayer.get(0) : "";
		return merkleRoot;
	}
```

*我会很快用一个能返回真正 merkleroot 的方法替换掉当前方法，但这个方法先暂时顶替下。

现在来完成 **Block** 类中需要修改的地方：

```
import java.util.ArrayList;
import java.util.Date;

public class Block {
	
	public String hash;
	public String previousHash; 
	public String merkleRoot;
	public ArrayList<Transaction> transactions = new ArrayList<Transaction>(); //我们的数据就是一个简单的信息
	public long timeStamp; //从1970/1/1到现在经过的毫秒时间
	public int nonce;
	
	//构造方法  
	public Block(String previousHash ) {
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
		
		this.hash = calculateHash(); //确保设置了其它值之后再计算哈希值
	}
	
	//基于区块内容计算新的哈希值
	public String calculateHash() {
		String calculatedhash = StringUtil.applySha256( 
				previousHash +
				Long.toString(timeStamp) +
				Integer.toString(nonce) + 
				merkleRoot
				);
		return calculatedhash;
	}
	
	//哈希目标达成的话，增加 nonce 值
	public void mineBlock(int difficulty) {
		merkleRoot = StringUtil.getMerkleRoot(transactions);
		String target = StringUtil.getDificultyString(difficulty); //Create a string with difficulty * "0" 
		while(!hash.substring( 0, difficulty).equals(target)) {
			nonce ++;
			hash = calculateHash();
		}
		System.out.println("Block Mined!!! : " + hash);
	}
	
	//添加交易到区块
	public boolean addTransaction(Transaction transaction) {
		//process transaction and check if valid, unless block is genesis block then ignore.
		if(transaction == null) return false;		
		if((previousHash != "0")) {
			if((transaction.processTransaction() != true)) {
				System.out.println("Transaction failed to process. Discarded.");
				return false;
			}
		}
		transactions.add(transaction);
		System.out.println("Transaction Successfully added to Block");
		return true;
	}
	
}
```

我们也更新了 Block 的构造方法，因为我们不用再传入字符串，还有在计算哈希值方法中也加入了 merkle root 部分。

addTransaction 方法会添加交易而且只在交易成功添加时返回 true。

> 哈哈！每个想要的我们都造出来了，现在我们的区块链上已经能进行交易了！

![](https://cdn-images-1.medium.com/max/800/1*QaHN-AsCPEzAlU-3ulbO-Q.gif)

### **7. 厉害地总结下(一开始的时候只有菜鸟币)：**

现在应该测试从钱包里发送出去菜鸟币或通过钱包接收菜鸟币，并更新区块链的合法性检查。但首先我们要找到如何把新挖的菜鸟币整合到系统中的办法，有很多途径去生成新币，拿比特币的区块链来说：矿工可以把一个交易变成自己的一部分，作为区块被挖出来时的奖励。现在的话，我们就只是在第一个区块（创始区块）放出一定数量的币，满足我们项目需要即可。像比特币一样，我们会硬编码创始区块，写一个固定的值。

让我们完整地更新 NoobChain 类：

* 一个创始区块，发了 100 个菜鸟币给钱包 A。
* 因为增加了交易部分，更新了区块链的合法性检查。
* 一些测试类交易去验证是否正常运作。

```
public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>();
	public static HashMap<String,TransactionOutput> UTXOs = new HashMap<String,TransactionOutput>();
	
	public static int difficulty = 3;
	public static float minimumTransaction = 0.1f;
	public static Wallet walletA;
	public static Wallet walletB;
	public static Transaction genesisTransaction;

	public static void main(String[] args) {	
		//添加我们的区块到区块链 ArrayList中
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider()); //设置 Bouncey castle 为 Security Provider
		
		//生成钱包
		walletA = new Wallet();
		walletB = new Wallet();		
		Wallet coinbase = new Wallet();
		
		//生成创始交易，内容是发送100个菜鸟币到 walletA
		genesisTransaction = new Transaction(coinbase.publicKey, walletA.publicKey, 100f, null);
		genesisTransaction.generateSignature(coinbase.privateKey);	 //手动对创始交易签名
		genesisTransaction.transactionId = "0"; //手动设置交易 id
		genesisTransaction.outputs.add(new TransactionOutput(genesisTransaction.reciepient, genesisTransaction.value, genesisTransaction.transactionId)); //手动添加交易输出
		UTXOs.put(genesisTransaction.outputs.get(0).id, genesisTransaction.outputs.get(0)); //在 UTXO list 里面保存第一个交易很重要
		
		System.out.println("Creating and Mining Genesis block... ");
		Block genesis = new Block("0");
		genesis.addTransaction(genesisTransaction);
		addBlock(genesis);
		
		//测试
		Block block1 = new Block(genesis.hash);
		System.out.println("\nWalletA's balance is: " + walletA.getBalance());
		System.out.println("\nWalletA is Attempting to send funds (40) to WalletB...");
		block1.addTransaction(walletA.sendFunds(walletB.publicKey, 40f));
		addBlock(block1);
		System.out.println("\nWalletA's balance is: " + walletA.getBalance());
		System.out.println("WalletB's balance is: " + walletB.getBalance());
		
		Block block2 = new Block(block1.hash);
		System.out.println("\nWalletA Attempting to send more funds (1000) than it has...");
		block2.addTransaction(walletA.sendFunds(walletB.publicKey, 1000f));
		addBlock(block2);
		System.out.println("\nWalletA's balance is: " + walletA.getBalance());
		System.out.println("WalletB's balance is: " + walletB.getBalance());
		
		Block block3 = new Block(block2.hash);
		System.out.println("\nWalletB is Attempting to send funds (20) to WalletA...");
		block3.addTransaction(walletB.sendFunds( walletA.publicKey, 20));
		System.out.println("\nWalletA's balance is: " + walletA.getBalance());
		System.out.println("WalletB's balance is: " + walletB.getBalance());
		
		isChainValid();
		
	}
	
	public static Boolean isChainValid() {
		Block currentBlock; 
		Block previousBlock;
		String hashTarget = new String(new char[difficulty]).replace('\0', '0');
		HashMap<String,TransactionOutput> tempUTXOs = new HashMap<String,TransactionOutput>(); //对给定的区块状态，一个临时的未花费交易输出list
		tempUTXOs.put(genesisTransaction.outputs.get(0).id, genesisTransaction.outputs.get(0));
		
		//循环区块链去检查哈希值
		for(int i=1; i < blockchain.size(); i++) {
			
			currentBlock = blockchain.get(i);
			previousBlock = blockchain.get(i-1);
			//比较当前区块存储的哈希值和计算得出的哈希值
			if(!currentBlock.hash.equals(currentBlock.calculateHash()) ){
				System.out.println("#Current Hashes not equal");
				return false;
			}
			//比较前一个区块的哈希值和当前区块中存储的上一个区块哈希值
			if(!previousBlock.hash.equals(currentBlock.previousHash) ) {
				System.out.println("#Previous Hashes not equal");
				return false;
			}
			//检查哈希值是否解出来了
			if(!currentBlock.hash.substring( 0, difficulty).equals(hashTarget)) {
				System.out.println("#This block hasn't been mined");
				return false;
			}
			
			//循环区块链交易
			TransactionOutput tempOutput;
			for(int t=0; t <currentBlock.transactions.size(); t++) {
				Transaction currentTransaction = currentBlock.transactions.get(t);
				
				if(!currentTransaction.verifiySignature()) {
					System.out.println("#Signature on Transaction(" + t + ") is Invalid");
					return false; 
				}
				if(currentTransaction.getInputsValue() != currentTransaction.getOutputsValue()) {
					System.out.println("#Inputs are note equal to outputs on Transaction(" + t + ")");
					return false; 
				}
				
				for(TransactionInput input: currentTransaction.inputs) {	
					tempOutput = tempUTXOs.get(input.transactionOutputId);
					
					if(tempOutput == null) {
						System.out.println("#Referenced input on Transaction(" + t + ") is Missing");
						return false;
					}
					
					if(input.UTXO.value != tempOutput.value) {
						System.out.println("#Referenced input Transaction(" + t + ") value is Invalid");
						return false;
					}
					
					tempUTXOs.remove(input.transactionOutputId);
				}
				
				for(TransactionOutput output: currentTransaction.outputs) {
					tempUTXOs.put(output.id, output);
				}
				
				if( currentTransaction.outputs.get(0).reciepient != currentTransaction.reciepient) {
					System.out.println("#Transaction(" + t + ") output reciepient is not who it should be");
					return false;
				}
				if( currentTransaction.outputs.get(1).reciepient != currentTransaction.sender) {
					System.out.println("#Transaction(" + t + ") output 'change' is not sender.");
					return false;
				}
				
			}
			
		}
		System.out.println("Blockchain is valid");
		return true;
	}
	
	public static void addBlock(Block newBlock) {
		newBlock.mineBlock(difficulty);
		blockchain.add(newBlock);
	}
}
```

这些是比较长的方法 。。。

我们的输出应该是像这样的：

![](https://cdn-images-1.medium.com/max/800/1*OV1rMcvs_m_gKF5yyR6PQw.png)

现在钱包已经可以在你的区块链上安全地发送资金，当然前提是得有钱。这意味着你已经拥有了自己的本地化加密货币了。

### 你现在已经实现了你区块链的交易部分！

![](https://cdn-images-1.medium.com/max/800/1*9K4pVMSdI7A0YZH-g47I2w.gif)

你已经成功造出你自己的加密货币（部分完成）。 你现在的区块链可以：

* 允许用户用 new Wallet() 的方式生成钱包。
* 提供采用椭圆曲线加密方式对公钥和私钥进行加密的钱包。
* 通过一个数字签名算法证明资金所有权，保护资金的传输过程。
* 最后允许用户通过 Block.addTransaction(walletA.sendFunds( walletB.publicKey, 20)) 在你的区块链上发起交易。

* * *

你可以在 [Github](https://github.com/CryptoKass/NoobChain-Tutorial-Part-2/tree/master/src/noobchain) 上面下载这个项目。

![](https://cdn-images-1.medium.com/max/800/1*ZbFDb_ml08yDSRXyzhFGxA.gif)

你可以**关注我**，以便下一个教程或其它区块链开发文章发布的时候**收到通知**。很重视你们的任何反馈意见。谢谢。 

### 用 Java 实现你的第一个区块链。 第三部分:

我们接下来会讲 P2P 网络的部分，**共识算法**，**区块存储和数据库**。(很快就会发布)

联系我： kassCrypto@gmail.com **问题交流**：[https://discord.gg/ZsyQqyk](https://discord.gg/ZsyQqyk)（我在 discord 上面的区块链开发者俱乐部）


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
