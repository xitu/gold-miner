> * 原文地址：[Creating Your First Blockchain with Java. Part 1](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)
> * 原文作者：[Kass](https://medium.com/@cryptokass?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/create-simple-blockchain-java-tutorial-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO/create-simple-blockchain-java-tutorial-from-scratch.md)
> * 译者：
> * 校对者：

# Creating Your First Blockchain with Java. Part 1.

The aim of this tutorial series, is to help you build a picture of how one could develop blockchain technology.

In this tutorial we will :

* Create your first (very) **basic ‘blockchain’**.
* Implement a simple **proof of work** ( mining ) system.
* **Marvel at the possibilities**.

( I will assume you have a basic understanding of [Object Oriented Programming](https://docs.oracle.com/javase/tutorial/java/concepts/) )

_It’s worth noting that this wont be a fully functioning, ready for production block chain. Instead this is a proof of concept implementation to help you understand what a blockchain is for future tutorials._

You can support this and future tutorials :)
_btc: 17svYzRv4XJ1Sfi1TSThp3NBFnh7Xsi6fu_

* * *

### Setting Up.

We will be using Java but you should be able to follow along in any [OOP](https://en.wikipedia.org/wiki/Object-oriented_programming) language. I’ll be using Eclipse but you can use any new fancy text editor ( though you’ll miss out on a lot of good bloat ).

You will need:

* Java and JDK installed. ( duh ).
* Eclipse ( or another IDE/Text Editor ).

![](https://cdn-images-1.medium.com/max/800/1*3rE0ahnLzfQ7JHyxNJAH7Q.gif)

Don’t worry if your eclipse looks different to mine. I’ll be using a dark theme in eclipse because ^

Optionally, you can grab [GSON library by google](https://repo1.maven.org/maven2/com/google/code/gson/gson/2.6.2/gson-2.6.2.jar) (_who are they ???_). This will allow us to turn an object into Json \o/. It’s a super useful library that we will also be using further down the line for peer2peer stuff, but feel free to use an alternate method.

In Eclipse create a (file > new > ) Java project. I’ll call my Project “**noobchain**” and create a new _Class_ by the same name (**NoobChain**).

![](https://cdn-images-1.medium.com/max/800/1*VPKiJWgOiZszGvLgPNiqLA.png)

Don’t be copying my project name now ( ͠° ͟ ͜ʖ ͡°)

Now you’re good to go :)

* * *

### Making the Blockchain.

A blockchain is just a chain/list of blocks. Each block in the blockchain will have its own digital signature, contain digital signature of the previous block, and have some data ( this data could be transactions for example ).

![](https://cdn-images-1.medium.com/max/800/1*627BG-7qMtaXNsX0n41C6Q.png)

I sure hope Nakamoto never sees this.

> **_Hash = Digital Signature._**

**Each block doesn’t just contain the hash of the block before it, but its own hash is in part, calculated from the previous hash**. If the previous block’s data is changed then the previous block’s hash will change ( since it is calculated in part, by the data) in turn affecting all the hashes of the blocks there after. **Calculating and comparing the hashes allow us to see if a blockchain is invalid.**

What does this mean ? …Changing any data in this list, will change the signature and **break the chain**.

#### So Firsts lets create class **Block** that make up the blockchain:

```
import java.util.Date;

public class Block {

	public String hash;
	public String previousHash;
	private String data; //our data will be a simple message.
	private long timeStamp; //as number of milliseconds since 1/1/1970.

	//Block Constructor.
	public Block(String data,String previousHash ) {
		this.data = data;
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
	}
}
```

As you can see our basic **Block** contains a `String hash` that will hold our digital signature. The variable `previousHash` to hold the previous block’s hash and`String data` to hold our block data.

#### **Next we will need a way to generate a digital signature**,

there are many cryptographic algorithms you can choose from, however SHA256 fits just fine for this example. We can `import java.security.MessageDigest;` to get access to the SHA256 algorithm.

We need to use SHA256 later down the line so lets create a handy helper method in a new **StringUtil** ‘utility’ _class_ :

```
import java.security.MessageDigest;

public class StringUtil {
	//Applies Sha256 to a string and returns the result. 
	public static String applySha256(String input){		
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");	        
			//Applies sha256 to our input, 
			byte[] hash = digest.digest(input.getBytes("UTF-8"));	        
			StringBuffer hexString = new StringBuffer(); // This will contain hash as hexidecimal
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

This is mostly a carbon copy of the [http://www.baeldung.com/sha-256-hashing-java](http://www.baeldung.com/sha-256-hashing-java)

**Don’t worry too much if you don’t understand the contents of this helper method**, _all you need to know is that it takes a string and applies SHA256 algorithm to it, and returns the generated signature as a string._

Now lets use our **applySha256** helper, in a new method in the **Block** _class_, to calculate the hash. We must calculate the hash from all parts of the block we don’t want to be tampered with. So for our block we will include the `previousHash`, the `data` and `timeStamp`.

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

and lets add this method to the **Block** _constructor_…

```
	public Block(String data,String previousHash ) {
		this.data = data;
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
		this.hash = calculateHash(); //Making sure we do this after we set the other values.
	}
```

#### **Time for some testing…**

In our main **NoobChain** class lets create some blocks and print the hashes to the screen to see that everything is in working order.

![](https://cdn-images-1.medium.com/max/800/1*I6k_gZJ0KRZYR4KU22Okig.gif)

Lets test this…

The first block is called the genesis block, and because there is no previous block we will just enter “0” as the previous hash.

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

The output should look similar to this:

![](https://cdn-images-1.medium.com/max/800/0*uRnxW_CqB6FqWiUd.png)

Your values will be different because your timestamp will be different.

Each block now has its own digital signature based on its information and the signature of the previous block.

Currently it’s not much of a block**chain,** so lets store our blocks in an _ArrayList_ and also import gson to view it as Json. _(_[_click here to find out how to import the gson library_](https://medium.com/@cryptokass/importing-gson-into-eclipse-ec8cf678ad52)_)_

```
import java.util.ArrayList;
import com.google.gson.GsonBuilder;

public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>(); 

	public static void main(String[] args) {	
		//add our blocks to the blockchain ArrayList:
		blockchain.add(new Block("Hi im the first block", "0"));		
		blockchain.add(new Block("Yo im the second block",blockchain.get(blockchain.size()-1).hash)); 
		blockchain.add(new Block("Hey im the third block",blockchain.get(blockchain.size()-1).hash));
		
		String blockchainJson = new GsonBuilder().setPrettyPrinting().create().toJson(blockchain);		
		System.out.println(blockchainJson);
	}

}
```

Now our output should look something closer to what we expect a blockchain to look like.

#### Now we need a way to check the integrity of our blockchain.

Lets create an **isChainValid()** _Boolean_ method in the **NoobChain** _class_, that will loop through all blocks in the chain and compare the hashes. This method will need to check the hash variable is actually equal to the calculated hash, and the previous block’s hash is equal to the **previousHash** variable.

```
public static Boolean isChainValid() {
	Block currentBlock; 
	Block previousBlock;
	
	//loop through blockchain to check hashes:
	for(int i=1; i < blockchain.size(); i++) {
		currentBlock = blockchain.get(i);
		previousBlock = blockchain.get(i-1);
		//compare registered hash and calculated hash:
		if(!currentBlock.hash.equals(currentBlock.calculateHash()) ){
			System.out.println("Current Hashes not equal");			
			return false;
		}
		//compare previous hash and registered previous hash
		if(!previousBlock.hash.equals(currentBlock.previousHash) ) {
			System.out.println("Previous Hashes not equal");
			return false;
		}
	}
	return true;
}
```

Any change to the blockchain’s blocks will cause this method to return false.

On the bitcoin network nodes share their blockchains and the **longest valid chain is accepted** by the network. What’s to stop someone tampering with data in an old block then creating a whole new longer blockchain and presenting that to the network ? **Proof of work**. The _hashcash_ proof of work system means it takes considerable time and computational power to create new blocks. Hence the attacker would need more computational power than the rest of the peers combined.

![](https://cdn-images-1.medium.com/max/800/1*R_bfhtxuHqM6aJYCZiQA9g.gif)

hashcash, much wow.

### Lets start mining blocks !!!

We will require _miners_ to do proof-of-work by **trying different variable values in the block until its hash starts with a certain number of 0’s.**

Lets add an _int_ called **nonce** to be included in our **calculateHash()** method, and the much needed **mineBlock()** method :

```
import java.util.Date;

public class Block {
	
	public String hash;
	public String previousHash; 
	private String data; //our data will be a simple message.
	private long timeStamp; //as number of milliseconds since 1/1/1970.
	private int nonce;
	
	//Block Constructor.  
	public Block(String data,String previousHash ) {
		this.data = data;
		this.previousHash = previousHash;
		this.timeStamp = new Date().getTime();
		
		this.hash = calculateHash(); //Making sure we do this after we set the other values.
	}
	
	//Calculate new hash based on blocks contents
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
		String target = new String(new char[difficulty]).replace('\0', '0'); //Create a string with difficulty * "0" 
		while(!hash.substring( 0, difficulty).equals(target)) {
			nonce ++;
			hash = calculateHash();
		}
		System.out.println("Block Mined!!! : " + hash);
	}
}
```

In reality each miner will start iterating from a random point. Some miners may even try random numbers for nonce. Also it’s worth noting that at the harder difficulties solutions may require more than integer.MAX_VALUE, miners can then try changing the timestamp.

The **mineBlock()** method takes in an int called difficulty, this is the number of 0’s they must solve for. Low difficulty like 1 or 2 can be solved nearly instantly on most computers, i’d suggest something around 4–6 for testing. At the time of writing Litecoin’s difficulty is around 442,592.

Lets add the difficulty as a static variable to the NoobChain class :

```
public static int difficulty = 5;
```

We should update the **NoobChain** _class_ to trigger the **mineBlock()** _method_ for each new block. The **isChainValid**() _Boolean_ should also check if each block has a solved ( by mining ) hash.

```
import java.util.ArrayList;
import com.google.gson.GsonBuilder;

public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>();
	public static int difficulty = 5;

	public static void main(String[] args) {	
		//add our blocks to the blockchain ArrayList:
		
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
		
		//loop through blockchain to check hashes:
		for(int i=1; i < blockchain.size(); i++) {
			currentBlock = blockchain.get(i);
			previousBlock = blockchain.get(i-1);
			//compare registered hash and calculated hash:
			if(!currentBlock.hash.equals(currentBlock.calculateHash()) ){
				System.out.println("Current Hashes not equal");			
				return false;
			}
			//compare previous hash and registered previous hash
			if(!previousBlock.hash.equals(currentBlock.previousHash) ) {
				System.out.println("Previous Hashes not equal");
				return false;
			}
			//check if hash is solved
			if(!currentBlock.hash.substring( 0, difficulty).equals(hashTarget)) {
				System.out.println("This block hasn't been mined");
				return false;
			}
		}
		return true;
	}
}
```

Notice we also check and print _isChainValid_.

Running this your results should look like :

![](https://cdn-images-1.medium.com/max/800/1*qzjPDdgOESJSwDSP0peEEg.png)

Mining each block took some time! ( around 3 seconds ) You should mess around with the difficulty value to see how that effects the time it takes to mine each block ;)

If someone were to **tamper** 😒 with the data in your blockchain system:

* Their blockchain would be invalid.
* They would not be able to create a longer blockchain.
* Honest blockchains in your network will have a time advantage on the longest chain.

**A tampered blockchain will not be able to catch up with a longer & valid chain. ***

*unless they have vastly more computation speed than all other nodes in your network combined. A future quantum computer or something.

### You’re all done with your basic blockchain!

![](https://cdn-images-1.medium.com/max/800/1*9K4pVMSdI7A0YZH-g47I2w.gif)

Go on pat yourself on the back.

Your blockchain:
**> Is made up of blocks that store data.
> Has a digital signature that chains your blocks together.
> Requires proof of work mining to validate new blocks.
> Can be check to see if data in it is valid and unchanged.**

You can download these project files on [Github](https://github.com/CryptoKass/NoobChain-Tutorial-Part-1).

![](https://cdn-images-1.medium.com/max/800/1*ZbFDb_ml08yDSRXyzhFGxA.gif)

You can **follow to be notified** when next tutorials and other blockchain development articles are posted. Any feedback is also greatly appreciated. Thanks.

### [Creating Your First Blockchain with Java. Part 2:](https://medium.com/programmers-blockchain/creating-your-first-blockchain-with-java-part-2-transactions-2cdac335e0ce)

We cover **Transactions, Signatures** and **Wallets**.

_contact:_ kassCrypto@gmail.com

**_Questions_**_:_ [https://discord.gg/ZsyQqyk](https://discord.gg/ZsyQqyk) _(I’m on the Blockchain developers Club discord)_


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
