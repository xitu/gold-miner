> * 原文地址：[Jan 20 Creating Your First Blockchain with Java. Part 2 — Transactions](https://medium.com/programmers-blockchain/creating-your-first-blockchain-with-java-part-2-transactions-2cdac335e0ce)
> * 原文作者：[Kass](https://medium.com/@cryptokass?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/creating-your-first-blockchain-with-java-part-2-transactions.md](https://github.com/xitu/gold-miner/blob/master/TODO/creating-your-first-blockchain-with-java-part-2-transactions.md)
> * 译者：
> * 校对者：

# Creating Your First Blockchain with Java. Part 2 — Transactions.

_The aim of this tutorial series, is to help you build a picture of how one could develop blockchain technology. You can find_ [_part 1 here_](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)_._

In this second tutorial we will :

* **Create a simple wallet.**
* **Send signed transactions using our blockchain.**
* **Feel extra cool.**

**All of the above will result in our own crypto coin ! (sorta)**

![](https://cdn-images-1.medium.com/max/800/1*7qqSMkUfrrENWkqPUYVYYQ.gif)

Don’t worry this will actually be pretty bare-bones, but longer than the last tutorial ! tl;dr [Github](https://github.com/CryptoKass/NoobChain-Tutorial-Part-2/tree/master/src/noobchain).

* * *

[Carrying on from last tutorial](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa), we have a basic verifiable Blockchain. But currently our chain only stores rather useless messages. Today we are going to replace this data with transactions ( our block will be able to hold multiple transactions ), allowing us to create a very simple crypto-currency. We will call our new coin : “_NoobCoin_”.

* _This tutorial assumes you have followed the other_ [_tutorial_](https://medium.com/programmers-blockchain/create-simple-blockchain-java-tutorial-from-scratch-6eeed3cb03fa)_._
* **Dependencies: _You will need to import_ **[**_bounceycastle_**](https://www.bouncycastle.org/latest_releases.html)** _(_**[**_here is a mini tutorial on how to do so_**](https://medium.com/@cryptokass/importing-bouncy-castle-into-eclipse-24e0dda55f21)**_) and_ **[**_GSON_**](http://central.maven.org/maven2/com/google/code/gson/gson/2.8.2/gson-2.8.2.jar)**_._**

### 1.Preparing a Wallet

In crypto-currencies, coin ownership is transfered on the Blockchain as transactions, participants have an address which funds can be sent to and from. **In their basic form wallets can just store these addresses, most wallets however, are also software able to make new transactions on the Blockchain.**

![](https://cdn-images-1.medium.com/max/1000/1*ygobWJSoGiJ2uMh-sP0Nig.png)

Don’t worry about the information on the transaction, that will be explained soon :)

So let’s create a **Wallet** C_lass_ to hold our public key and private keys:

```
package noobchain;
import java.security.*;

public class Wallet {
	public PrivateKey privateKey;
	public PublicKey publicKey;
}
```

Be sure to import java.security.* !!!

**_What are the public and private keys for ?_**

For our **_‘noobcoin’_** the _public key_ will act as our address. It’s OK to share this public key with others to receive payment. Our private key is used to **_sign_** our transactions, so that nobody can spend our noobcoins other than the owner of the private key. **Users will have to keep their private key Secret !** We also send our public key along with the transaction and it can be used to verify that our signature is valid and data has not been tampered with.

![](https://cdn-images-1.medium.com/max/1000/1*5bOYYuEgKPBNknyKeQQxNA.png)

The private key is used to sign the data we don’t want to be tampered with. The public key is used to verify the signature.

We generate our private and public keys in a **KeyPair**. We will use [Elliptic-curve cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) to Generate our **KeyPairs**. Let’s append a g_enerateKeyPair()_ method to our **Wallet** _class_ and call it in the constructor:

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
			// Initialize the key generator and generate a KeyPair
			keyGen.initialize(ecSpec, random);   //256 bytes provides an acceptable security level
	        	KeyPair keyPair = keyGen.generateKeyPair();
	        	// Set the public and private keys from the keyPair
	        	privateKey = keyPair.getPrivate();
	        	publicKey = keyPair.getPublic();
		}catch(Exception e) {
			throw new RuntimeException(e);
		}
	}
	
}
```

All you need to understand about this method is it uses Java.security.KeyPairGenerator to generate an Elliptic Curve KeyPair. This methods makes and sets our Public and Private keys. Nifty.

Now that we have the outlines of our wallet class let’s have a look at transactions.

### 2. Transactions & Signatures

Each transaction will carry a certain amount of data:

* The public key(address) of the sender of funds.
* The public key(address) of the receiver of funds.
* The value/amount of funds to be transferred.
* Inputs, which are references to previous transactions that prove the sender has funds to send.
* Outputs, which shows the amount relevant addresses received in the transaction. ( These outputs are referenced as inputs in new transactions )
* A cryptographic signature, that proves the owner of the address is the one sending this transaction and that the data hasn’t been changed. ( for example: preventing a third party from changing the amount sent )

Let’s create this new Transaction class:

```
import java.security.*;
import java.util.ArrayList;

public class Transaction {
	
	public String transactionId; // this is also the hash of the transaction.
	public PublicKey sender; // senders address/public key.
	public PublicKey reciepient; // Recipients address/public key.
	public float value;
	public byte[] signature; // this is to prevent anybody else from spending funds in our wallet.
	
	public ArrayList<TransactionInput> inputs = new ArrayList<TransactionInput>();
	public ArrayList<TransactionOutput> outputs = new ArrayList<TransactionOutput>();
	
	private static int sequence = 0; // a rough count of how many transactions have been generated. 
	
	// Constructor: 
	public Transaction(PublicKey from, PublicKey to, float value,  ArrayList<TransactionInput> inputs) {
		this.sender = from;
		this.reciepient = to;
		this.value = value;
		this.inputs = inputs;
	}
	
	// This Calculates the transaction hash (which will be used as its Id)
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

We should also create empty **TransactionInput** and **TransactionOutput** _classes,_ don’t worry we can fill them in later.

Our transaction class will also contain relevant methods for generating/verifying the signature and verifying the transaction.

_But wait…_

#### What is the purpose of signatures and how do they work ?

**_Signatures_** perform **two** very important tasks on our blockchain: Firstly, they **allow only the owner** to spend **their coins**, secondly, they prevent others from **tampering with their submitted transaction** before a new block is mined (at the point of entry).

> The **private key is used to sign** the data and the **public key can be used to verify** its integrity.

> **_For example:_**Bob wants to send 2 **NoobCoins** to Sally, so their wallet software generates this transaction and submits it to miners to include in the next block. A miner attempts to change the recipient of the 2 coins to John. However, luckily, Bob had signed the transaction data with his private key, allowing anybody to verify if the transaction data has been changed using Bob’s public key (as no other persons public key will be able to verify the transaction).

We can see (from the previous code block,) that our signature will be a bunch of bytes, so let’s create a method to generate them. First thing we will need are a few helper functions in **_StringUtil_** _class_ :

```
//Applies ECDSA Signature and returns the result ( as bytes ).
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
	
	//Verifies a String signature 
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

Don’t worry too much about understanding the contents of these methods. All you really need to know is : applyECDSASig takes in the senders private key and string input, signs it and returns an array of bytes. verifyECDSASig takes in the signature, public key and string data and returns true or false if the signature is valid. getStringFromKey returns encoded string from any key.

Now let’s utilize these signature methods in our **Transaction** _class_, by appending a **_generateSignature()_** and **_verifiySignature()_** _methods_:

```
//Signs all the data we dont wish to be tampered with.
public void generateSignature(PrivateKey privateKey) {
	String data = StringUtil.getStringFromKey(sender) + StringUtil.getStringFromKey(reciepient) + Float.toString(value)	;
	signature = StringUtil.applyECDSASig(privateKey,data);		
}
//Verifies the data we signed hasnt been tampered with
public boolean verifiySignature() {
	String data = StringUtil.getStringFromKey(sender) + StringUtil.getStringFromKey(reciepient) + Float.toString(value)	;
	return StringUtil.verifyECDSASig(sender, data, signature);
}
```

In reality, you may want to sign more information, like the outputs/inputs used and/or time-stamp ( for now we are just signing the bare minimum )

Signatures will be verified by miners as a new transaction are added to a block.

![](https://cdn-images-1.medium.com/max/800/1*hWYSlaQWuak3Wya_81gy2w.gif)

We also can check signatures, when we check the blockchain’s validity.

### 3.Testing the Wallets and Signatures:

Now we are almost halfway done Let’s test a few things are working. In the **_NoobChain_ **_class_ let’s add some new variables and replace the content of our **_main_** _method_ :

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
		//Setup Bouncey castle as a Security Provider
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider()); 
		//Create the new wallets
		walletA = new Wallet();
		walletB = new Wallet();
		//Test public and private keys
		System.out.println("Private and public keys:");
		System.out.println(StringUtil.getStringFromKey(walletA.privateKey));
		System.out.println(StringUtil.getStringFromKey(walletA.publicKey));
		//Create a test transaction from WalletA to walletB 
		Transaction transaction = new Transaction(walletA.publicKey, walletB.publicKey, 5, null);
		transaction.signature = transaction.generateSignature(walletA.privateKey);
		//Verify the signature works and verify it from the public key
		System.out.println("Is signature verified");
		System.out.println(transaction.verifiySignature());
		
	}
```

be sure to remember to add boncey castle as a security provider.

We created two wallets, _walletA_ and _walletB_ then printed _walletA_’s private and public keys. Generated a _Transaction_ and signed it using _walletA_’s public key. ̶_F̶i̶n̶a̶l̶l̶y̶ ̶w̶e̶ ̶c̶r̶o̶s̶s̶e̶d̶ ̶o̶u̶r̶ ̶f̶i̶n̶g̶e̶r̶s̶ ̶a̶n̶d̶ ̶h̶o̶p̶e̶d̶ ̶e̶v̶e̶r̶y̶t̶h̶i̶n̶g̶ ̶w̶o̶r̶k̶e̶d̶ ̶o̶u̶t̶.̶_

Your output should look something like this :

![](https://cdn-images-1.medium.com/max/800/1*60pXu88f-WyPbFYWIXU8iQ.png)
‘Is signature verified’ should be true. Hopefully.

Time to pat your self on the back. Now we just need to create/verify the outputs and inputs and then store the transaction in the Blockchain.

### 4. Inputs & Outputs 1: How crypto currency is owned…

For you to own 1 bitcoin, you have to receive 1 Bitcoin. The ledger doesn’t really add one bitcoin to you and minus one bitcoin from the sender, the sender referenced that he/she previously received one bitcoin, then a transaction output was created showing that 1 Bitcoin was sent to your address. (Transaction inputs are references to previous transaction outputs.).

> Your wallets balance is the sum of all the unspent transaction outputs addressed to you.

From this point on we will follow bitcoins convention and call unspent transaction outputs: **_UTXO_**’s.

So let’s create a **TransactionInput** _Class_:

```
public class TransactionInput {
	public String transactionOutputId; //Reference to TransactionOutputs -> transactionId
	public TransactionOutput UTXO; //Contains the Unspent transaction output
	
	public TransactionInput(String transactionOutputId) {
		this.transactionOutputId = transactionOutputId;
	}
}
```

This class will be used to reference TransactionOutputs that have not yet been spent. The transactionOutputId will be used to find the relevant TransactionOutput, allowing miners to check your ownership.

And a **TransactionOutputs** C_lass_:

```
import java.security.PublicKey;

public class TransactionOutput {
	public String id;
	public PublicKey reciepient; //also known as the new owner of these coins.
	public float value; //the amount of coins they own
	public String parentTransactionId; //the id of the transaction this output was created in
	
	//Constructor
	public TransactionOutput(PublicKey reciepient, float value, String parentTransactionId) {
		this.reciepient = reciepient;
		this.value = value;
		this.parentTransactionId = parentTransactionId;
		this.id = StringUtil.applySha256(StringUtil.getStringFromKey(reciepient)+Float.toString(value)+parentTransactionId);
	}
	
	//Check if coin belongs to you
	public boolean isMine(PublicKey publicKey) {
		return (publicKey == reciepient);
	}
	
}
```

Transaction outputs will show the final amount sent to each party from the transaction. These, when referenced as inputs in new transactions, act as proof that you have coins to send.

![](https://cdn-images-1.medium.com/max/800/1*wylnsMFHeHKd0SNqZgyiYg.gif)

### 5. Inputs & Outputs 2: Processing the transaction…

Blocks in the chain may receive many transactions and the blockchain might be very, very long, it could take eons to process a new transaction because we have to find and check its inputs. To get around this we will keep an extra collection of all unspent transactions that can be used as inputs. In our N**_oobChain_** _class_ add this collection of all **_UTXOs_**:

```
public class NoobChain {
	
	public static ArrayList<Block> blockchain = new ArrayList<Block>();
	public static HashMap<String,TransactionOutputs> UTXOs = new HashMap<String,TransactionOutputs>(); //list of all unspent transactions. 
	public static int difficulty = 5;
	public static Wallet walletA;
	public static Wallet walletB;

	public static void main(String[] args) {
```

HashMaps allow us to use a key to find a value, but you will need to import java.util.HashMap;

Okay, time to get down to the nitty gritty…

Let’s put everything together to process the transaction with a processTransaction _boolean_ _method_ in our **Transaction** _Class:_

```
//Returns true if new transaction could be created.	
public boolean processTransaction() {
		
		if(verifiySignature() == false) {
			System.out.println("#Transaction Signature failed to verify");
			return false;
		}
				
		//gather transaction inputs (Make sure they are unspent):
		for(TransactionInput i : inputs) {
			i.UTXO = NoobChain.UTXOs.get(i.transactionOutputId);
		}

		//check if transaction is valid:
		if(getInputsValue() < NoobChain.minimumTransaction) {
			System.out.println("#Transaction Inputs to small: " + getInputsValue());
			return false;
		}
		
		//generate transaction outputs:
		float leftOver = getInputsValue() - value; //get value of inputs then the left over change:
		transactionId = calulateHash();
		outputs.add(new TransactionOutput( this.reciepient, value,transactionId)); //send value to recipient
		outputs.add(new TransactionOutput( this.sender, leftOver,transactionId)); //send the left over 'change' back to sender		
				
		//add outputs to Unspent list
		for(TransactionOutput o : outputs) {
			NoobChain.UTXOs.put(o.id , o);
		}
		
		//remove transaction inputs from UTXO lists as spent:
		for(TransactionInput i : inputs) {
			if(i.UTXO == null) continue; //if Transaction can't be found skip it 
			NoobChain.UTXOs.remove(i.UTXO.id);
		}
		
		return true;
	}
	
//returns sum of inputs(UTXOs) values
	public float getInputsValue() {
		float total = 0;
		for(TransactionInput i : inputs) {
			if(i.UTXO == null) continue; //if Transaction can't be found skip it 
			total += i.UTXO.value;
		}
		return total;
	}

//returns sum of outputs:
	public float getOutputsValue() {
		float total = 0;
		for(TransactionOutput o : outputs) {
			total += o.value;
		}
		return total;
	}
```

we also added a getInputsValue float method.

…With this method we perform some checks to ensure that the transaction is valid, then gather inputs and generating outputs. (See commented lines in the code for more insight).

Importantly, towards the end, we discard Inputs from our list of _UTXO’_s**,** meaning a **transaction output** can only be used once as an input… Hence the full value of the inputs must be used, so the sender sends ‘change’ back to themselves.

![](https://cdn-images-1.medium.com/max/1000/1*4wZbhhT98hIyt4jtLdePgQ.png)

Red arrows are Outputs. Notice that Green Inputs are references to previous outputs.

Finally let’s update our wallet to:

* Gather our balance ( by looping through the UTXOs list and checking if a transaction output isMine())
* And generate transactions for us…

```
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Wallet {
	
	public PrivateKey privateKey;
	public PublicKey publicKey;
	
	public HashMap<String,TransactionOutput> UTXOs = new HashMap<String,TransactionOutput>(); //only UTXOs owned by this wallet.
	
	public Wallet() {...
		
	public void generateKeyPair() {...
	
  //returns balance and stores the UTXO's owned by this wallet in this.UTXOs
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
	//Generates and returns a new transaction from this wallet.
	public Transaction sendFunds(PublicKey _recipient,float value ) {
		if(getBalance() < value) { //gather balance and check funds.
			System.out.println("#Not Enough funds to send transaction. Transaction Discarded.");
			return null;
		}
    //create array list of inputs
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

Feel free to add some other functionalities to your wallet, like keeping a record of your transaction history.

#### 6. Adding transactions to our blocks:

Now we have a working transaction system, we need to implement it into our blockchain. We should replace the useless data we had in our blocks with an ArrayList of transactions. However there may be 1000s of transactions in a single block, too many to include in our hash calculation… but don’t worry we can use the merkle root of the transactions (you can quickly read about about merkle trees here *soon*).

Let’s add a helper method to generate the merkleroot in StringUtils:

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

*I will replace this soon, with an actual merkleroot but this method will work for now.

Now let’s implement our **Block** _Class_ changes:

```
import java.util.ArrayList;
import java.util.Date;

public class Block {
	
	public String hash;
	public String previousHash; 
	public String merkleRoot;
	public ArrayList<Transaction> transactions = new ArrayList<Transaction>(); //our data will be a simple message.
	public long timeStamp; //as number of milliseconds since 1/1/1970.
	public int nonce;
	
	//Block Constructor.  
	public Block(String previousHash ) {
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
				merkleRoot
				);
		return calculatedhash;
	}
	
	//Increases nonce value until hash target is reached.
	public void mineBlock(int difficulty) {
		merkleRoot = StringUtil.getMerkleRoot(transactions);
		String target = StringUtil.getDificultyString(difficulty); //Create a string with difficulty * "0" 
		while(!hash.substring( 0, difficulty).equals(target)) {
			nonce ++;
			hash = calculateHash();
		}
		System.out.println("Block Mined!!! : " + hash);
	}
	
	//Add transactions to this block
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

Notice we also updated our Block constructor as we no longer need pass in string data and included the merkle root in the calculate hash method.

Our addTransaction _boolean_ method will add the transactions and will only return true if the transaction has been successfully added.

> Hurrah every component we need, to make transactions on our blockchain has now be implemented !

![](https://cdn-images-1.medium.com/max/800/1*QaHN-AsCPEzAlU-3ulbO-Q.gif)

### **7. The Grand Finale (In the beginning there was noobcoin):**

We should test sending coins to and from wallets, and update our blockchain validity check. But first we need a way to introduce new coins into the mix. There are many ways to create new coins, on the bitcoin blockchain for example: miners can include a transaction to themselves as a reward for each block mined. For now though, we will just release all the coins we wish to have, in the first block (the genesis block). Just like bitcoin we will hard code the genesis block.

Let’s update our NoobChain class with everything it needs:

* A Genesis block which release 100 Noobcoins to walletA.
* An updated chain validity check that takes into account transactions.
* Some test transactions to see that everything is working.

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
		//add our blocks to the blockchain ArrayList:
		Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider()); //Setup Bouncey castle as a Security Provider
		
		//Create wallets:
		walletA = new Wallet();
		walletB = new Wallet();		
		Wallet coinbase = new Wallet();
		
		//create genesis transaction, which sends 100 NoobCoin to walletA: 
		genesisTransaction = new Transaction(coinbase.publicKey, walletA.publicKey, 100f, null);
		genesisTransaction.generateSignature(coinbase.privateKey);	 //manually sign the genesis transaction	
		genesisTransaction.transactionId = "0"; //manually set the transaction id
		genesisTransaction.outputs.add(new TransactionOutput(genesisTransaction.reciepient, genesisTransaction.value, genesisTransaction.transactionId)); //manually add the Transactions Output
		UTXOs.put(genesisTransaction.outputs.get(0).id, genesisTransaction.outputs.get(0)); //its important to store our first transaction in the UTXOs list.
		
		System.out.println("Creating and Mining Genesis block... ");
		Block genesis = new Block("0");
		genesis.addTransaction(genesisTransaction);
		addBlock(genesis);
		
		//testing
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
		HashMap<String,TransactionOutput> tempUTXOs = new HashMap<String,TransactionOutput>(); //a temporary working list of unspent transactions at a given block state.
		tempUTXOs.put(genesisTransaction.outputs.get(0).id, genesisTransaction.outputs.get(0));
		
		//loop through blockchain to check hashes:
		for(int i=1; i < blockchain.size(); i++) {
			
			currentBlock = blockchain.get(i);
			previousBlock = blockchain.get(i-1);
			//compare registered hash and calculated hash:
			if(!currentBlock.hash.equals(currentBlock.calculateHash()) ){
				System.out.println("#Current Hashes not equal");
				return false;
			}
			//compare previous hash and registered previous hash
			if(!previousBlock.hash.equals(currentBlock.previousHash) ) {
				System.out.println("#Previous Hashes not equal");
				return false;
			}
			//check if hash is solved
			if(!currentBlock.hash.substring( 0, difficulty).equals(hashTarget)) {
				System.out.println("#This block hasn't been mined");
				return false;
			}
			
			//loop thru blockchains transactions:
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

Those are some long methods… 😮

Our output should look something like this:

![](https://cdn-images-1.medium.com/max/800/1*OV1rMcvs_m_gKF5yyR6PQw.png)

Wallets are now able to securely send funds on your blockchain, only if they have funds to send that is. That means you have your own local cryptocurrency*.

### You’re all done with transactions on your blockchain!

![](https://cdn-images-1.medium.com/max/800/1*9K4pVMSdI7A0YZH-g47I2w.gif)

You have successfully create your own cryptocurrency (sort of!). Your blockchain now:

* Allows users to create wallets with ‘new Wallet();’
* Provides wallets with public and private keys using Elliptic-Curve cryptography.
* Secures the transfer of funds, by using a digital signature algorithm to prove ownership.
* And finally allow users to make transactions on your blockchain with ‘Block.addTransaction(walletA.sendFunds( walletB.publicKey, 20));’

* * *

You can download these project files on [Github](https://github.com/CryptoKass/NoobChain-Tutorial-Part-2/tree/master/src/noobchain).

![](https://cdn-images-1.medium.com/max/800/1*ZbFDb_ml08yDSRXyzhFGxA.gif)

You can **follow to be notified** when next tutorials and other blockchain development articles are posted. Any feedback is also greatly appreciated. Thanks.

### Creating Your First Blockchain with Java. Part 3:

We will cover **Peer2peer Networking**, **consensus algorithms**, **Block storage and databases** next. (coming soon)

_contact:_ kassCrypto@gmail.com**_Questions_**_:_ [https://discord.gg/ZsyQqyk](https://discord.gg/ZsyQqyk) _(I’m on the Blockchain developers Club discord)_


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
