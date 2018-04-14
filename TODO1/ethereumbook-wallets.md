> * 原文地址：[ethereumbook-wallets](https://github.com/ethereumbook/ethereumbook/blob/develop/wallets.asciidoc)
> * 原文作者：[ethereumbook](https://github.com/ethereumbook)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

## Wallets
## 以太坊钱包详解

walletsdefined definedThe word "wallet" is used to describe a few
different things in Ethereum.
『钱包』这个词语在以太坊中被用来描述一些不同的事情。

At a high level, a wallet is an application that serves as the primary
user interface. The wallet controls access to a user’s money, managing
keys and addresses, tracking the balance, and creating and signing
transactions. In addition, some Ethereum wallets can also interact with
contracts, such as tokens.
从高级的层面讲，钱包就是提供用户界面的一个应用。它掌管着用户的金钱，管理着
密钥和地址，追踪账户余额以及创建交易和签名。除此之外，一些以太坊钱包还可以
与智能合约进行交互，例如代币之类的。

More narrowly, from a programmer’s perspective, the word "wallet" refers
to the system used to store and manage a user’s keys. Every "wallet" has
a key management component. For some wallets, that’s all there is. Other
wallets are part of a much broader category, that of "browsers," which
are interfaces to Ethereum-based decentralized applications or "DApps".
There are no clear lines of distinction between the various categories
that are conflated under the term "wallet".
从一个程序员的角度更准确的讲就是，『钱包』这个词语指的就是存储和管理
密钥和地址的系统。每一个『钱包』都有一个密钥管理组件。而对于有些钱包来
说，这就是钱包的全部。其他的大部分钱包都是『浏览器』，其实就是基于以太坊
的去中心化应用的接口。所以这些各式各样的『钱包』之间并没有
什么明确的界限。

In this section we will look at wallets as containers for private keys,
and as systems for managing keys.
接下来让我们先看一看钱包关于密钥管理和私钥容器部分的功能。

### Wallet Technology Overview
### 钱包技术总览

In this section we summarize the various technologies used to construct
user-friendly, secure, and flexible Ethereum wallets.
在这个部分我们会总结用于构建用户友好、安全以及灵活的以太坊钱包所需要的
各种技术。

walletscontents of contents ofA common misconception about Ethereum is
that Ethereum wallets contain ether or tokens. In fact, the wallet
contains only keys. The ether or other tokens are recorded in the
Ethereum blockchain. Users control the tokens on the network by signing
transactions with the keys in their wallets. keychainsIn a sense, an
Ethereum wallet is a *keychain*.
关于以太坊有一个最常见的误解就是以太坊钱包包含以太坊和其他代币。而实际上，
钱包只包含密钥。
以太坊和其他代币都是被记录在以太坊的区块链中。
用户通过使用他们钱包中的密钥对钱包签名来控制代币。
所以从某种意义上讲，以太坊钱包就是一个钥匙链。

> **Tip**
>
> Ethereum wallets contain keys, not ether or tokens. Each user has a
> wallet containing keys. Wallets are really keychains containing pairs
> of private/public keys (see [private\_public\_keys]). Users sign
> transactions with the keys, thereby proving they own the ether. The
> ether is stored on the blockchain.

> **提示**
> 
> 以太坊钱包只包含钥匙，而没有以太坊和代币。每一个用户的钱包都包含密钥。
> 钱包就是包含公私钥对的钥匙串。
> 用户使用密钥对交易签名，以此来证明这些以太坊就是属于他们的。
>  而真正的以太坊则存储在区块链上。

walletstypes ofprimary distinctions types ofprimary distinctions primary
distinctionsThere are two primary types of wallets, distinguished by
whether the keys they contain are related to each other or not.
目前主要有两种类型的钱包，他们的区别就是所包含的密钥之间是否有关系。

JBOK walletsseealso=wallets seealso=walletswalletstypes ofJBOK wallets
types ofJBOK wallets JBOK walletsnondeterministic walletsseealso=wallets
seealso=walletsThe first type is a *nondeterministic wallet*, where each
key is independently generated from a random number. The keys are not
related to each other. This type of wallet is also known as a JBOK
wallet from the phrase "Just a Bunch Of Keys."
第一种类型叫做**非确定性钱包**，它的每一个密钥都是通过一个随机数独立生成的。
密钥之间相互没有关系。这种钱包也叫做 JBOK 钱包（来自 "Just a Bunch Of Keys"）。

deterministic walletsseealso=wallets seealso=walletsThe second type of
wallet is a *deterministic wallet*, where all the keys are derived from
a single master key, known as the *seed*. All the keys in this type of
wallet are related to each other and can be generated again if one has
the original seed. key derivation methodsThere are a number of different
*key derivation* methods used in deterministic wallets. hierarchical
deterministic (HD) walletsseealso=wallets seealso=walletsThe most
commonly used derivation method uses a tree-like structure and is known
as a *hierarchical deterministic* or *HD* wallet.
第二种钱包叫做**确定性钱包**，它所有的密钥都来源于一个单独的叫做**种子**
的主密钥。在这个钱包中所有的密钥都相互关联，并且任何拥有原始种子的人都可
以将这些密钥在生成一遍。这种确定性钱包会使用很多不同的密钥衍生方法。
而其中使用最普遍的则是一种类似树形结构的方法，这样的钱包被称为**分层确定性**或
者 HD 钱包。

mnemonic code wordsDeterministic wallets are initialized from a seed. To
make these easier to use, seeds are encoded as English words (or words
in other languages), also known as *mnemonic code words*.
分层确定性钱包是通过一个种子来初始化的。
而为了便于使用，种子会被编码成英语单词（或者其他语言的单词），
这些单词被称为**助记词**。

The next few sections introduce each of these technologies at a high
level.
下面的章节将会在更高级的层面介绍这些技术。

### Nondeterministic (Random) Wallets
### 非确定性（随机）钱包

walletstypes ofnondeterministic (random) wallets types
ofnondeterministic (random) wallets nondeterministic (random) walletsIn
the first Ethereum wallet (produced by the Ethereum pre-sale), wallet
files stored a single randomly generated private key. Such wallets are
being replaced with deterministic wallets because they are cumbersome to
manage, back up, and import. The disadvantage of random keys is that if
you generate many of them you must keep copies of all of them. Each key
must be backed up, or the funds it controls are irrevocably lost if the
wallet becomes inaccessible. Furthermore, Ethereum address reuse reduces
privacy by associating multiple transactions and addresses with each
other. A Type-0 nondeterministic wallet is a poor choice of wallet,
especially if you want to avoid address reuse because it means managing
many keys, which creates the need for frequent backups.
在第一个的以太坊钱包（以太坊预售时发布的）中，钱包文件会存储
一个单独随机生成的私钥。然而这种钱包之后被确定性钱包取代了，因为
这种钱包无法管理、备份以及导入私钥。但是随机密钥的缺点是，如果你
生成了很多那么你就要把它们全部拷贝下来。每一个密钥都要备份，否则一旦
钱包丢失，那些密钥对应的资产也会丢失。进一步讲，以太坊地址的隐私性会
因为相互之间关联的多笔交易和地址的重复使用而大大降低。
一个类型-0 的非确定性钱包并不是一个好的选择，
尤其是当你为了避免地址的重复使用而不得不管理多个密钥并
不断频繁的备份它们时。

Many Ethereum clients (including go-ethereum or geth) use a *keystore*
file, which is a JSON-encoded file that contains a single (randomly
generated) private key, encrypted by a passphrase for extra security.
The JSON file contents look like this:
很多以太坊客户端（包括 go-ethereum 和 geth）都会使用一个**钥匙串**文件，
这是一个 JSON 编码的文件，而且它还包含一个单独的（随机生成的）私钥，
为了安全性，这个私钥会通过一个密码进行加密。
这个 JSON 文件就像下面这样：

    {
        "address": "001d3f1ef827552ae1114027bd3ecf1f086ba0f9",
        "crypto": {
            "cipher": "aes-128-ctr",
            "ciphertext": "233a9f4d236ed0c13394b504b6da5df02587c8bf1ad8946f6f2b58f055507ece",
            "cipherparams": {
                "iv": "d10c6ec5bae81b6cb9144de81037fa15"
            },
            "kdf": "scrypt",
            "kdfparams": {
                "dklen": 32,
                "n": 262144,
                "p": 1,
                "r": 8,
                "salt": "99d37a47c7c9429c66976f643f386a61b78b97f3246adca89abe4245d2788407"
            },
            "mac": "594c8df1c8ee0ded8255a50caf07e8c12061fd859f4b7c76ab704b17c957e842"
        },
        "id": "4fcb2ba4-ccdb-424f-89d5-26cce304bf9c",
        "version": 3
    }

The keystore format uses a *Key Derivation Function (KDF)* also known as
a password stretching algorithm, which protects against brute-force,
dictionary, or rainbow table attacks against the passphrase encryption.
In simple terms, the private key is not encrypted by the passphrase
directly. Instead, the passphrase is *stretched*, by repeatedly hashing
it. The hashing function is repeated for 262144 rounds, which can be
seen in the keystore JSON as parameter crypto.kdfparams.n. An attacker
trying to brute-force the passphrase would have to apply 262144 rounds
of hashing for every attempted passphrase, which slows down the attack
sufficiently as to make it infeasible for passphrases of sufficient
complexity and length.
钥匙串格式使用的是**Key Derivation Function (KDF)**，同时还被成为
密码拉伸算法，这个算法可以防止暴力破解、字典攻击以及彩虹表攻击。
简单来说就是私钥并不是直接通过密码简单的进行加密的。相反，这个密码是
通过不断的重复哈希**拉伸**过的。
这个哈希函数会重复 262144 轮，这个数字就是钥匙串 JSON 文件中的 crypto.kdfparams.n 这
个参数指定的。一个攻击者
试图通过暴力破解的手段来破解密码的话，那么他需要为每一个可能的密码
执行 262144 轮哈希，这样对于一个足够复杂和长度的密码来说被破解
几乎是不可能的。

There are a number of software libraries that can read and write the
keystore format, such as the JavaScript library keythereum:
这里还有一些软件库可以读取和写入钥匙串的
格式，例如 JavaScript 的库 keythereum：

<https://github.com/ethereumjs/keythereum>

> **Tip**
>
> The use of nondeterministic wallets is discouraged for anything other
> than simple tests. They are simply too cumbersome to back up and use.
> Instead, use an industry-standard–based *HD wallet* with a *mnemonic*
> seed for backup.
> **提示**
> 除了一些简单的测试之外，我们是不推荐使用非确定性钱包的。
> 我们推荐使用的是拥有**助记词**种子备份功能的
> 基于工业标准的**HD 钱包**。

### Deterministic (Seeded) Wallets
### 确定性钱包（种子）钱包

walletstypes ofdeterministic (seeded) wallets types ofdeterministic
(seeded) wallets deterministic (seeded) walletsDeterministic, or
"seeded," wallets are wallets that contain private keys that are all
derived from a common seed, through the use of a one-way hash function.
The seed is a randomly generated number that is combined with other
data, such as an index number or "chain code" (see
[section\_title](#hd_wallets)) to derive the private keys. In a
deterministic wallet, the seed is sufficient to recover all the derived
keys, and therefore a single backup, at creation time, is sufficient.
The seed is also sufficient for a wallet export or import, allowing for
easy migration of all the user’s keys between different wallet
implementations.
确定性或者说『种子』钱包是指那些所有的私钥都是通过一个普通的种子
使用一个单向哈希函数延伸而来的钱包。
这个种子是结合一些其他的数据而随机生成的数字，
例如利用一个索引数字或者『链码』（查看[HD 钱包(BIP-32/BIP-44)](#hd_钱包)
来衍生出私钥。
在一个确定性钱包中，一个种子就足够恢复出所有衍生的密钥，
因此只需要在创建的时候做一次备份就可以了。
同时，这个种子对于钱包来说也是可以导入导出的，
可以让所有用户的密钥在各种不同的钱包之间进行简单的迁移。

### HD Wallets (BIP-32/BIP-44)
### HD 钱包 (BIP-32/BIP-44)

walletstypes ofhierarchical deterministic (HD) wallets types
ofhierarchical deterministic (HD) wallets hierarchical deterministic
(HD) walletshierarchical deterministic (HD) walletsBitcoin improvement
proposalsHierarchical Deterministic Wallets (BIP-32/BIP-44) Hierarchical
Deterministic Wallets (BIP-32/BIP-44)Deterministic wallets were
developed to make it easy to derive many keys from a single "seed." The
most advanced form of deterministic wallets is the HD wallet defined by
Bitcoin’s BIP-32 standard. HD wallets contain keys derived in a tree
structure, such that a parent key can derive a sequence of children
keys, each of which can derive a sequence of grandchildren keys, and so
on, to an infinite depth. This tree structure is illustrated in
[hd\_wallet].
确定性钱包的开发就是为了可以简单的从一个『种子』衍生出很多个密钥。
而这种确定性钱包最高级的实现就是由比特币的 BIP-32 标准定义的 HD 钱包。
HD 钱包包含的密钥来源于一个树形的结构，例如一个父密钥可以衍生出
一系列子密钥，每一个子密钥又可以衍生出一系列孙子密钥，
不停的循环往复，没有尽头。
这个树形结构的示意图如下：

![HD wallet: a tree of keys generated from a single
seed](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/hd_wallet.png)

HD wallets offer two major advantages over random (nondeterministic)
keys. First, the tree structure can be used to express additional
organizational meaning, such as when a specific branch of subkeys is
used to receive incoming payments and a different branch is used to
receive change from outgoing payments. Branches of keys can also be used
in corporate settings, allocating different branches to departments,
subsidiaries, specific functions, or accounting categories.
HD 钱包相对于随机的（非确定性的）密钥有两个主要的优势。
一，树形结构可以表达额外的组织意义，例如当一个子密钥特定的分支
用来接收转入支付而另一个不同的分支可以接收转出支付的改变。
密钥的分支也可以在一些共同的设置中被使用，
例如可以分配不同的分支给部门、子公司、特定的函数或者不同的账单类别。

The second advantage of HD wallets is that users can create a sequence
of public keys without having access to the corresponding private keys.
This allows HD wallets to be used on an insecure server or in a
watch-only or receive-only capacity, where the wallet doesn’t have the
private keys that can spend the funds.
第二个优势就是用户可以使用 HD 钱包在不利用相关私钥的
情况下创建一系列公钥。
这样 HD 钱包就可以用来做一个安全的服务或者是
一个仅仅用来观察和接收的服务，而钱包本身却没有私钥，
所以它也无法花费资金。

### Seeds and Mnemonic Codes (BIP-39)
### 种子和助记词 (BIP-39)

walletstechnology ofseeds and mnemonic codes technology ofseeds and
mnemonic codes seeds and mnemonic codesmnemonic code wordsBitcoin
improvement proposalsMnemonic Code Words (BIP-39) Mnemonic Code Words
(BIP-39)HD wallets are a very powerful mechanism for managing many keys
and addresses. They are even more useful if they are combined with a
standardized way of creating seeds from a sequence of English words (or
words in another language) that are easy to transcribe, export, and
import across wallets. This is known as a *mnemonic* and the standard is
defined by BIP-39. Today, many Ethereum wallets (as well as wallets for
other cryptocurrencies) use this standard and can import and export
seeds for backup and recovery using interoperable mnemonics.
HD 钱包对于管理多个密钥和地址来说是一个很强力的机制。
如果再结合一个从一系列英语单词（或者其他语言的单词）中创建种子的标准化
方法的话，那么通过钱包进行抄写、导出和导入都变得更加简单易用。
这就是大家所熟知的由标准 BIP-39 定义的**助记词**。
今天，很多以太坊钱包（还有其他的数字货币钱包）都在使用这个标准
来导入导出种子，并使用共同的助记词来进行备份和恢复。

Let’s look at this from a practical perspective. Which of the following
seeds is easier to transcribe, record on paper, read without error,
export, and import into another wallet?
让我们来从实践的角度看一下。
下面哪个种子在抄写、纸上记录以及阅读障碍这几个方面更优秀呢？

**A seed for a deterministic wallet, in hex.**
**一个 16 进制编码的确定性钱包种子**

    FCCF1AB3329FD5DA3DA9577511F8F137

**A seed for a deterministic wallet, from a 12-word mnemonic.**
**一个由 12 个单词组成的助记词的钱包种子**

    wolf juice proud gown wool unfair
    wall cliff insect more detail hub

### Wallet Best Practices
### 钱包最佳实践

walletsbest practices for best practices forBitcoin improvement
proposalsMultipurpose HD Wallet Structure (BIP-43) Multipurpose HD
Wallet Structure (BIP-43)As cryptocurrency wallet technology has
matured, certain common industry standards have emerged that make
wallets broadly interoperable, easy to use, secure, and flexible. These
standards also allow wallets to derive keys for multiple different
cryptocurrencies, all from a single mnemonic. These common standards
are:
随着数字货币钱包技术的逐渐成熟，也慢慢形成了共同的工业标准，
使得钱包在交互性、易用性、安全性和灵活性等方面大幅度提高。
这些标准同时也使得钱包可以仅仅从一个单独助记词
就为各种不同的数字货币衍生出不同的密钥。
这些共同的标准就是下面这些：

-   Mnemonic code words, based on BIP-39

-   HD wallets, based on BIP-32

-   Multipurpose HD wallet structure, based on BIP-43

-   Multicurrency and multiaccount wallets, based on BIP-44

-   基于 BIP-39 的助记词

-   基于 BIP-32 的 HD 钱包

-   基于 BIP-43 的多用途 HD 钱包结构

-   基于 BIP-44 的多货币多账户钱包

These standards may change or may become obsolete by future
developments, but for now they form a set of interlocking technologies
that have become the de-facto wallet standard for most cryptocurrencies.
这些标准或许会改变，也或许会被未来的开发者废弃，
但是现在它们组成的这一组连锁技术俨然已经成为了
大多数数字货币的实际上的钱包标准。

The standards have been adopted by a broad range of software and
hardware wallets, making all these wallets interoperable. A user can
export a mnemonic generated on one of these wallets and import it in
another wallet, recovering all transactions, keys, and addresses.
这些标准已经被大部分的软件和硬件钱包所采用，
使得这些钱包之间可以相互通用。
一个用户可以从这些钱包中的任意一个导出助记词，
然后导入到另一个钱包中，
并恢复所以的交易、密钥和地址。

Some example of software wallets supporting these standards include
(listed alphabetically) Jaxx, MetaMask, MyEtherWallet (MEW). hardware
walletshardware walletssee=also wallets see=also walletsExamples of
hardware wallets supporting these standards include (listed
alphabetically) Keepkey, Ledger, and Trezor.
很多软件钱包都支持这种标准，例如（按字母 排序）
Jaxx, MetaMask, MyEtherWallet (MEW)。
硬件钱包则有 Keepkey, Ledger, and Trezor。

The following sections examine each of these technologies in detail.
下面的章节会详细讲解这些技术。

> **Tip**
>
> If you are implementing an Ethereum wallet, it should be built as a HD
> wallet, with a seed encoded as mnemonic code for backup, following the
> BIP-32, BIP-39, BIP-43, and BIP-44 standards, as described in the
> following sections.

> **提示**
>
> 如果你要实现一个以太坊钱包，他应该是一个 HD 钱包，
> 种子会被编码成助记词以供备份，
> BIP-32、BIP-39、BIP-43、和 BIP-44 这些标准会在下面的
> 章节中详细说明。

### Mnemonic Code Words (BIP-39)
### 助记词 (BIP-39)

walletstechnology ofmnemonic code words technology ofmnemonic code words
mnemonic code wordsmnemonic code wordsid=mnemonic05 id=mnemonic05bitcoin
improvement proposalsMnemonic Code Words (BIP-39)id=BIP3905 Mnemonic
Code Words (BIP-39)id=BIP3905 id=BIP3905Mnemonic code words are word
sequences that represent (encode) a random number used as a seed to
derive a deterministic wallet. The sequence of words is sufficient to
re-create the seed and from there re-create the wallet and all the
derived keys. A wallet application that implements deterministic wallets
with mnemonic words will show the user a sequence of 12 to 24 words when
first creating a wallet. That sequence of words is the wallet backup and
can be used to recover and re-create all the keys in the same or any
compatible wallet application. Mnemonic words make it easier for users
to back up wallets because they are easy to read and correctly
transcribe, as compared to a random sequence of numbers.
助记词就是代表一个随机数的单词序列，这个助记词会
作为种子派生出一个确定性钱包。
这个序列的单词能够再次创建种子、钱包和所有衍生出的密钥。
一个实现了确定性钱包助记词功能的应用将会向
在第一次创建钱包的时候向
用户展示一组长度为 12 到 24 的单词序列。
这个序列就是钱包的备份，它可以在任何兼容的钱包
上实现恢复和重建所有的密钥。
助记词可以让用户更简单的备份钱包，
因为相比于一组随机数助记词可读性更好，
抄写的正确率也更高。

> **Tip**
>
> brainwalletsMnemonic words are often confused with "brainwallets."
> They are not the same. The primary difference is that a brainwallet
> consists of words chosen by the user, whereas mnemonic words are
> created randomly by the wallet and presented to the user. This
> important difference makes mnemonic words much more secure, because
> humans are very poor sources of randomness.

> **提示**
> 
> 助记词常常与『大脑钱包』想混淆。
> 但是它们并不是一回事。而其中最主要的区别在于
> 大脑钱包是由用户自己选择的单词组成的，
> 而助记词则是钱包代表用户随机创建的。
> 这个重要的区别使得助记词更加的安全，
> 因为人类随机性的来源少的可怜。
 
Mnemonic codes are defined in BIP-39. Note that BIP-39 is one
implementation of a mnemonic code standard. There is a different
standard, *with a different set of words*, used by the Electrum bitcoin
wallet and predating BIP-39. BIP-39 was proposed by the company behind
the Trezor hardware wallet and is incompatible with Electrum’s
implementation. However, BIP-39 has now achieved broad industry support
across dozens of interoperable implementations and should be considered
the de-facto industry standard. Furthermore, BIP-39 can be used to
produce multicurrency wallets supporting Ethereum, whereas Electrum
seeds cannot.
助记词编码是在 BIP-39 中定义的。注意 BIP-39 只是助记词编码的
一个实现。还有很多不同的标准，比特币钱包 Electrum 就是
在 BIP-39 之前**使用了一组不同的单词**。BIP-39 这个标准是
由 Trezor 硬件钱包背后的公司提出来的，而且还兼容 Electrum 的
实现。然而，BIP-39 现在已经取得了广泛的行业支持，并且
兼容十几个相互操作的实现，所以 BIP-39 应该就是现在的行业标准。
而且，BIP-39 可以用来生成支持以太坊的多货币钱包，
而 Electrum 的种子并不支持。

BIP-39 defines the creation of a mnemonic code and seed, which we
describe here in nine steps. For clarity, the process is split into two
parts: steps 1 through 6 are shown in
[section\_title](#generating_mnemonic_words) and steps 7 through 9 are
shown in [section\_title](#mnemonic_to_seed).
BIP-39 定义了助记词编码和种子的生成，也就
是接下来的九个步骤。为了表达的更清楚，整个过程
分成了两个部分：第一步到第六步在[生成助记词](#generating_mnemonic_words)，
第七步到第九步在[助记词到种子](#mnemonic_to_seed)。

#### Generating mnemonic words
#### 生成助记词

Mnemonic words are generated automatically by the wallet using the
standardized process defined in BIP-39. The wallet starts from a source
of entropy, adds a checksum, and then maps the entropy to a word list:
助记词是钱包使用 BIP-39 中定义的标准化过程自动生成的。
钱包起始于一个熵的来源，添加一个校验和并
将熵映射到一个单词数组中。

1.  Create a random sequence (entropy) of 128 to 256 bits.

2.  Create a checksum of the random sequence by taking the
    first (entropy-length/32) bits of its SHA256 hash.

3.  Add the checksum to the end of the random sequence.

4.  Divide the sequence into sections of 11 bits.

5.  Map each 11-bit value to a word from the predefined dictionary of
    2048 words.

6.  The mnemonic code is the sequence of words.

1.  创建一个 128 位到 256 位的随机序列（熵）

2.  通过取 SHA256 的前（熵长度除以 32）位来创建一个随机序列的校验和。

3.  将校验和添加到随机序列的末尾。

4.  将序列分成几个 11 位的部分。

5.  从预定义的 2048 个单词字典中将每一个 11 位的值映射到一个单词上面。

6.  助记词编码是一系列单词。

[figure\_title](#generating_entropy_and_encoding) shows how entropy is
used to generate mnemonic words.
[生成熵并编码成助记词](#generating_entropy_and_encoding)将会展示
出熵是如何生成助记词的。

![Generating entropy and encoding as mnemonic
words](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39-part1.png)

[table\_title](#table_bip39_entropy) shows the relationship between the
size of the entropy data and the length of mnemonic codes in words.
[助记词编码：熵和单词长度](#table_bip39_entropy) 展示出了
熵数据的大小和单词中助记词长度的关系。

<table>
<caption>Mnemonic codes: entropy and word length</caption>
<colgroup>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Entropy (bits)</th>
<th align="left">Checksum (bits)</th>
<th align="left">Entropy <strong>+</strong> checksum (bits)</th>
<th align="left">Mnemonic length (words)</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>128</p></td>
<td align="left"><p>4</p></td>
<td align="left"><p>132</p></td>
<td align="left"><p>12</p></td>
</tr>
<tr class="even">
<td align="left"><p>160</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>165</p></td>
<td align="left"><p>15</p></td>
</tr>
<tr class="odd">
<td align="left"><p>192</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>198</p></td>
<td align="left"><p>18</p></td>
</tr>
<tr class="even">
<td align="left"><p>224</p></td>
<td align="left"><p>7</p></td>
<td align="left"><p>231</p></td>
<td align="left"><p>21</p></td>
</tr>
<tr class="odd">
<td align="left"><p>256</p></td>
<td align="left"><p>8</p></td>
<td align="left"><p>264</p></td>
<td align="left"><p>24</p></td>
</tr>
</tbody>
</table>

#### From mnemonic to seed
#### 从助记词到种子

key-stretching functionPBKDF2 functionThe mnemonic words represent
entropy with a length of 128 to 256 bits. The entropy is then used to
derive a longer (512-bit) seed through the use of the key-stretching
function PBKDF2. The seed produced is then used to build a deterministic
wallet and derive its keys.
助记词代表着长度为 128 到 256 位的熵。
这个熵会通过密钥拉伸函数 PBKDF2 生成
一个更长的（512 位）种子。
这个种子再构建一个
确定性钱包并衍生出它的密钥。

saltspassphrasesThe key-stretching function takes two parameters: the
mnemonic and a *salt*. The purpose of a salt in a key-stretching
function is to make it difficult to build a lookup table enabling a
brute-force attack. In the BIP-39 standard, the salt has another
purpose—it allows the introduction of a passphrase that serves as an
additional security factor protecting the seed, as we will describe in
more detail in [section\_title](#mnemonic_passphrase).
密钥拉伸函数需要两个参数：
助记词和**盐**。盐的目的是为了
让暴力破解构建查询表的难度提高。
在标准 BIP-39 中，盐还有另外一个目的，
那就是密码介绍可以作为一个
额外的安全因子来保护种子，
这部分会在[BIP-39 中的可选密码](#mnemonic_passphrase)中
详细讲述。

The process described in steps 7 through 9 continues from the process
described previously in [section\_title](#generating_mnemonic_words):
第七步到第九步的过程：

The first parameter to the PBKDF2 key-stretching function is the
mnemonic
produced from step 6.
The second parameter to the PBKDF2 key-stretching function is a
salt
. The salt is composed of the string constant "
mnemonic
" concatenated with an optional user-supplied passphrase string.
PBKDF2 stretches the mnemonic and salt parameters using 2048 rounds of
hashing with the HMAC-SHA512 algorithm, producing a 512-bit value as its
final output. That 512-bit value is the seed.

7.  密钥拉伸函数 PBKDF2 的第一个参数第六步中生成的助记词。

8.  密钥拉伸函数 PBKDF2 的第二个参数就是**盐**。
    这个盐由字符串常量 "mnemonic" 和一个额外的用户提供的
    密码字符串拼接构成。

9.  PBKDF2 使用 HMAC-SHA512 算法进行了 2048 轮哈希运算
    对助记词和盐进行拉伸，生成一个 512 位的值作为最后的输出。
    这个 512 位的值就是种子。

[fig\_5\_7] shows how a mnemonic is used to generate a seed.
[fig\_5\_7] 展示出了一个助记词是如何生成种子的。

![From mnemonic to seed](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39-part2.png)

> **Tip**
>
> The key-stretching function, with its 2048 rounds of hashing, is a
> somewhat effective protection against brute-force attacks against the
> mnemonic or the passphrase. It makes it costly (in computation) to try
> more than a few thousand passphrase and mnemonic combinations, while
> the number of possible derived seeds is vast (2<sup>512</sup>).

> **提示**
>
> 密钥拉伸函数以及它的 2048 轮哈希从
> 某种程度上讲对于暴力破解助记词和密码
> 是一个有效的保护。会让其以昂贵的代价（在计算资源上）
> 不停的尝试成千上万种密码和助记词的组合，
> 而这些组合的数量则犹如汪洋大海(2<sup>512</sup>)。


Tables \#mnemonic\_128\_no\_pass, \#mnemonic\_128\_w\_pass, and
\#mnemonic\_256\_no\_pass show some examples of mnemonic codes and the
seeds they produce (without any passphrase).
下面的表格分别展示了 \#mnemonic\_128\_no\_pass、\#mnemonic\_128\_w\_pass 和 
\#mnemonic\_256\_no\_pass 这几个类型的助记词和他们产生
的种子（没有密码）的例子。

<table>
<caption>128-bit entropy mnemonic code, no passphrase, resulting seed</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong><strong>Entropy input (128 bits)</strong></strong></p></td>
<td align="left"><p>0c1e24e5917779d297e14d45f14e1a1a</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Mnemonic (12 words)</strong></strong></p></td>
<td align="left"><p>army van defense carry jealous true garbage claim echo media make crunch</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong><strong>Passphrase</strong></strong></p></td>
<td align="left"><p>(none)</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Seed (512 bits)</strong></strong></p></td>
<td align="left"><p>5b56c417303faa3fcba7e57400e120a0ca83ec5a4fc9ffba757fbe63fbd77a89a1a3be4c67196f57c39 a88b76373733891bfaba16ed27a813ceed498804c0570</p></td>
</tr>
</tbody>
</table>

<table>
<caption>128-bit entropy mnemonic code, with passphrase, resulting seed</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong><strong>Entropy input (128 bits)</strong></strong></p></td>
<td align="left"><p>0c1e24e5917779d297e14d45f14e1a1a</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Mnemonic (12 words)</strong></strong></p></td>
<td align="left"><p>army van defense carry jealous true garbage claim echo media make crunch</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong><strong>Passphrase</strong></strong></p></td>
<td align="left"><p>SuperDuperSecret</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Seed (512 bits)</strong></strong></p></td>
<td align="left"><p>3b5df16df2157104cfdd22830162a5e170c0161653e3afe6c88defeefb0818c793dbb28ab3ab091897d0 715861dc8a18358f80b79d49acf64142ae57037d1d54</p></td>
</tr>
</tbody>
</table>

<table>
<caption>256-bit entropy mnemonic code, no passphrase, resulting seed</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<tbody>
<tr class="odd">
<td align="left"><p><strong><strong>Entropy input (256 bits)</strong></strong></p></td>
<td align="left"><p>2041546864449caff939d32d574753fe684d3c947c3346713dd8423e74abcf8c</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Mnemonic (24 words)</strong></strong></p></td>
<td align="left"><p>cake apple borrow silk endorse fitness top denial coil riot stay wolf luggage oxygen faint major edit measure invite love trap field dilemma oblige</p></td>
</tr>
<tr class="odd">
<td align="left"><p><strong><strong>Passphrase</strong></strong></p></td>
<td align="left"><p>(none)</p></td>
</tr>
<tr class="even">
<td align="left"><p><strong><strong>Seed (512 bits)</strong></strong></p></td>
<td align="left"><p>3269bce2674acbd188d4f120072b13b088a0ecf87c6e4cae41657a0bb78f5315b33b3a04356e53d062e5 5f1e0deaa082df8d487381379df848a6ad7e98798404</p></td>
</tr>
</tbody>
</table>

#### Optional passphrase in BIP-39
#### BIP-39 中的可选密码

passphrasesThe BIP-39 standard allows the use of an optional passphrase
in the derivation of the seed. If no passphrase is used, the mnemonic is
stretched with a salt consisting of the constant string "mnemonic",
producing a specific 512-bit seed from any given mnemonic. If a
passphrase is used, the stretching function produces a *different* seed
from that same mnemonic. In fact, given a single mnemonic, every
possible passphrase leads to a different seed. Essentially, there is no
"wrong" passphrase. All passphrases are valid and they all lead to
different seeds, forming a vast set of possible uninitialized wallets.
The set of possible wallets is so large (2<sup>512</sup>) that there is
no practical possibility of brute-forcing or accidentally guessing one
that is in use, as long as the passphrase has sufficient complexity and
length.
BIP-39 标准允许用户在生成种子的时候使用可选的密码。
如果没有使用密码，那么助记词
就会被一个由常量字符串 "mnemonic" 组成的盐拉伸，
然后由给定的助记词产生一个特定的 512 位种子。
如果使用了密码，则拉伸函数在使用同一个助记词的
情况下会产生一个**不同的**种子。实际上，给定一个助记词，
每一个可能的密码都会生成不同的种子。并且基本上
没有任何『错误』的 密码。所有的密码都是可用的
并且所有的密码都可以生成不同种子，这些不同的助记词
会形成一组数量巨大的为初始化的钱包。
这些可能的钱包数量是如此之大 (2<sup>512</sup>)，以至于
实际情况中暴力破解和意外猜对的可能性几乎为零，
只要密码拥有足够的复杂度和长度。

> **Tip**
>
> There are no "wrong" passphrases in BIP-39. Every passphrase leads to
> some wallet, which unless previously used will be empty.

> **提示**
> 
> 在标准 BIP-39 中不存在『错误的』密码。每个密码
> 都会生成一个钱包，如果不是之前使用的密码的话那就是一个新的钱包。

The optional passphrase creates two important features:
可选的密码会产生两个重要的特性：

-   A second factor (something memorized) that makes a mnemonic useless
    on its own, protecting mnemonic backups from compromise by a thief.

-   A form of plausible deniability or "duress wallet," where a chosen
    passphrase leads to a wallet with a small amount of funds used to
    distract an attacker from the "real" wallet that contains the
    majority of funds.

-   一个需要记忆的第二个因子可以防止
    助记词的备份被窃取。

-   

However, it is important to note that the use of a passphrase also
introduces the risk of loss:
然而，有一个比较重要的就是使用密码会面临
密码丢失的风险。

-   If the wallet owner is incapacitated or dead and no one else knows
    the passphrase, the seed is useless and all the funds stored in the
    wallet are lost forever.

-   Conversely, if the owner backs up the passphrase in the same place
    as the seed, it defeats the purpose of a second factor.

-   如果钱包的主人缺乏行动能力或者去世了，那么就没人知道密码了，
    也没人知道种子是什么，那么钱包中
    储存的所有资金就全部丢失了。

-   相反，如果钱包的主人在种子的地方备份了密码，
    那么它就是第二个因素的目的。

While passphrases are very useful, they should only be used in
combination with a carefully planned process for backup and recovery,
considering the possibility of surviving the owner and allowing his or
her family to recover the cryptocurrency estate.
虽然密码非常有用，但是也应该结合小心的计划备份
和恢复的过程来使用，
因为要考虑到钱包主人生还的可能性并
可以允许他们的家人来恢复数字货币的资产。


#### Working with mnemonic codes
#### 助记词的工作

BIP-39 is implemented as a library in many different programming
languages:
BIP-39 在很多不同的编程语言中
都有实现的库：

[python-mnemonic](https://github.com/trezor/python-mnemonic)  
The reference implementation of the standard by the SatoshiLabs team
that proposed BIP-39, in Python


[Consensys/eth-lightwallet](https://github.com/ConsenSys/eth-lightwallet)  
Lightweight JS Ethereum Wallet for nodes and browser (with BIP-39)

[npm/bip39](https://www.npmjs.com/package/bip39)  
JavaScript implementation of Bitcoin BIP39: Mnemonic code for generating
deterministic keys

There is also a BIP-39 generator implemented in a standalone webpage,
which is extremely useful for testing and experimentation.
[figure\_title](#a_bip39_generator_as_a_standalone_web_page) shows a
standalone web page that generates mnemonics, seeds, and extended
private keys.
还有一个在单独的网页中实现的 BIP-39 生成器，
这个网页在测试和实验中非常有用。
[BIP-39 生成器](#a_bip39_generator_as_a_standalone_web_page)展示了
一个可以生成助记词、种子以及拓展的私钥的单独的网页。

![A BIP-39 generator as a standalone web page](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39_web.png)

startref=mnemonic05 startref=mnemonic05startref=BIP3905
startref=BIP3905The page (<https://iancoleman.github.io/bip39/>) can be
used offline in a browser, or accessed online.
网页(<https://iancoleman.github.io/bip39/>)可以在
浏览器中离线使用（在线当然也可以）。

### Creating an HD Wallet from the Seed
### 通过种子创建一个 HD 钱包

walletstechnology ofcreating HD wallets from root seed technology
ofcreating HD wallets from root seed creating HD wallets from root
seedroot seedshierarchical deterministic (HD) walletsHD wallets are
created from a single *root seed*, which is a 128-, 256-, or 512-bit
random number. Most commonly, this seed is generated from a *mnemonic*
as detailed in the previous section.
HD 钱包是通过一个**根种子**来创建的，这个根种子
一般是 128、256 或者 512 位的随机数。
通常情况下，这个种子是通过一个**助记词**来生成的。

Every key in the HD wallet is deterministically derived from this root
seed, which makes it possible to re-create the entire HD wallet from
that seed in any compatible HD wallet. This makes it easy to back up,
restore, export, and import HD wallets containing thousands or even
millions of keys by simply transferring only the mnemonic that the root
seed is derived from.
HD 钱包中的每一个密钥都是衍生自这个根种子，
这样就使得通过这个种子在其他兼容性钱包中
重建整个 HD 钱包成为了可能。同时还使得
备份、恢复、导出以及导入包含成千上万个密钥的
钱包变的非常简单，仅仅通过转移从根种子衍生
出的助记词就可以了。

\[\[bip32\_bip43/44\]\] ==== Hierarchical Deterministic Wallets (BIP-32)
and paths (BIP-43/44)
\[\[bip32\_bip43/44\]\] ==== 分层确定性钱包 (BIP-32) 和路径 (BIP-43/44)

Most HD wallets follow the BIP-32 standard, which has become a de-facto
industry standard for deterministic key generation. You can read the
detailed specification in:
大多数 HD 钱包都遵循 BIP-32 标准，同时 BIP-32 也是
确定密钥生成器的实际上的行业标准。
详细的说明可以查看下面的链接：

<https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki>

We won’t be discussing the details of BIP-32 here, only the components
necessary to understand how it is used in wallets. There are dozens of
interoperable implementations of BIP-32 offered in many software
libraries:
在这里我们不会讨论 BIP-32，我们只需要理解钱包中使用它
的部分就可以了。在其他一些软件库中
还有很多关于 BIP-32 彼此协作的实现。

[Consensys/eth-lightwallet](https://github.com/ConsenSys/eth-lightwallet)  
Lightweight JS Ethereum Wallet for nodes and browser (with BIP-32)

There is also a BIP-32 standalone web page generator that is very useful
for testing and experimentation with BIP-32:
这里还有一个标准 BIP-32 的网页版的生成器，
对于测试和实验都非常有用。

<http://bip32.org/>

> **Note**
>
> The standalone BIP-32 generator is not an HTTPS site. That’s to remind
> you that the use of this tool is not secure. It is only for testing.
> You should not use the keys produced by this site in production (with
> real funds).

> **提示**
> 
> 这个单独的 BIP-32 生成器不是一个 HTTPS 的站点。
> 就是为了告诉你使用这个工具不是安全的。只是用来做测试的。
> 你不应该在生产环境中（真实的资金）使用
> 这个网页生成的密钥。
  

#### Extended public and private keys
#### 拓展公钥和私钥

In BIP-32 terminology, a parent key that can be extended to produce
"children," is called an *extended key*. If it is a private key, it is
an *extended private key* distinguished by the prefix *xprv*:
在 BIP-32 的术语中，一个父密钥可以拓展的生成『儿子』，
这个儿子就是**拓展密钥**。如果它是一个私钥，那么
它就是一个**拓展私钥**，并通过前缀 **xprv** 来区分：

    xprv9s21ZrQH143K2JF8RafpqtKiTbsbaxEeUaMnNHsm5o6wCW3z8ySyH4UxFVSfZ8n7ESu7fgir8imbZKLYVBxFPND1pniTZ81vKfd45EHKX73

An *extended public key* is distinguished by the prefix *xpub*:
一个**拓展公钥**通过前缀 **xpub** 来区分：

    xpub661MyMwAqRbcEnKbXcCqD2GT1di5zQxVqoHPAgHNe8dv5JP8gWmDproS6kFHJnLZd23tWevhdn4urGJ6b264DfTGKr8zjmYDjyDTi9U7iyT

A very useful characteristic of HD wallets is the ability to derive
public child keys from public parent keys, *without* having the private
keys. This gives us two ways to derive a child public key: either from
the child private key, or directly from the parent public key.
HD 钱包中一个非常有用的角色就是从父公钥衍生出子公钥，
**不包含**私钥。
这会给我们提供两种方法来衍生子公钥：
从子私钥或者直接从父公钥来衍生。

An extended public key can be used, therefore, to derive all of the
*public* keys (and only the public keys) in that branch of the HD wallet
structure.
一个拓展公钥可以在 HD 钱包的结构中
衍生出所有的**公钥**（也只能是公钥）。

This shortcut can be used to create very secure public key–only
deployments where a server or application has a copy of an extended
public key and no private keys whatsoever. That kind of deployment can
produce an infinite number of public keys and Ethereum addresses, but
cannot spend any of the money sent to those addresses. Meanwhile, on
another, more secure server, the extended private key can derive all the
corresponding private keys to sign transactions and spend the money.
无论什么情况只要部署的服务和应用有一份
拓展公钥并且没有私钥，那么
这个快捷方式就可以创建非常安全的公钥。
这种部署可以生成无穷个公钥和以太坊地址，
但是却不能花费任何发送到这些地址的资金。
同时，在另外一个更安全的服务器上，拓展私钥可以衍生
出所有相关的私钥用来给交易签名，并花费资金。

One common application of this solution is to install an extended public
key on a web server that serves an e-commerce application. The web
server can use the public key derivation function to create a new
Ethereum address for every transaction (e.g., for a customer shopping
cart). The web server will not have any private keys that would be
vulnerable to theft. Without HD wallets, the only way to do this is to
generate thousands of Ethereum addresses on a separate secure server and
then preload them on the e-commerce server. That approach is cumbersome
and requires constant maintenance to ensure that the e-commerce server
doesn’t "run out" of keys.
利用这种解决方案的一个常见的应用就是
在一个 web 服务器上安装一个拓展公钥，
来为电子商务应用服务。
这个网页服务器可以使用公钥衍生函数为每一笔交易（例如客户的购物车）创造出
一个全新的以太坊地址。这个网页服务器没有任何私钥所以盗贼也无法窃取。
不使用 HD 钱包的情况下，想做到这个程度唯一的方法就是
在一个分割的安全服务器上生成上千个以太坊地址
然后在电子商务服务器上预加载他们。
这个方法低效笨重，并且需要经常的维护以确保
电子商务服务器不会泄露密钥。

cold storagestoragecold storage cold storagehardware walletsAnother
common application of this solution is for cold-storage or hardware
wallets. In that scenario, the extended private key can be stored on a
hardware wallet, while the extended public key can be kept online. The
user can create "receive" addresses at will, while the private keys are
safely stored offline. To spend the funds, the user can use the extended
private key on an offline signing Ethereum client or sign transactions
on the hardware wallet device.
还有一个常见的应用就是冷存储和硬件钱包。
在这种场景下，拓展私钥可以存储在硬件钱包中，
但是拓展公钥可以放在线上。
用户可以按照他们的意愿创建接收的地址，
私钥则会离线安全的保存。
想花掉里面的资金的话，用户可以在
离线签名的以太坊客户端或者支持交易签名的硬件钱包上
使用拓展私钥。

#### Hardened child key derivation
#### 硬化密钥衍生

public and private keyshardened child key derivation hardened child key
derivationhardened derivationThe ability to derive a branch of public
keys from an xpub is very useful, but it comes with a potential risk.
Access to an xpub does not give access to child private keys. However,
because the xpub contains the chain code, if a child private key is
known, or somehow leaked, it can be used with the chain code to derive
all the other child private keys. A single leaked child private key,
together with a parent chain code, reveals all the private keys of all
the children. Worse, the child private key together with a parent chain
code can be used to deduce the parent private key.
从 xpub 中衍生出一个公钥分支的能力时很有用的，
但同时也是具有风险的。
知道 xpub 并不意味着知道子密钥。
然而，因为 xpub 包含链码，所以如果一个子密钥
被别人知道或者暴露了的话，那么它就可以
和链码一起衍生出所有其他的子密钥。
一个单独泄露的子密钥和一个父链码一起可以暴露出
所有的子私钥。而更糟糕的是，子私钥和父链码一起
还可以推断出父私钥。

To counter this risk, HD wallets use an alternative derivation function
called *hardened derivation*, which "breaks" the relationship between
parent public key and child chain code. The hardened derivation function
uses the parent private key to derive the child chain code, instead of
the parent public key. This creates a "firewall" in the parent/child
sequence, with a chain code that cannot be used to compromise a parent
or sibling private key.
为了避免这个风险，HD 钱包使用了另外一种叫做**硬化衍生**的
衍生函数，这个函数可以『破坏』父公钥和子链码的联系。
这种硬化衍生函数是使用父私钥来衍生出子链码的，而不是
父公钥。
这样会在父或子序列中创造出一个『防火墙』，而这个防火墙
并不会威胁到父或者子私钥的安全。

In simple terms, if you want to use the convenience of an xpub to derive
branches of public keys, without exposing yourself to the risk of a
leaked chain code, you should derive it from a hardened parent, rather
than a normal parent. As a best practice, the level-1 children of the
master keys are always derived through the hardened derivation, to
prevent compromise of the master keys.
简单的来说就是，如果不想承受泄露你自己链码风险，并且还
想要方便的使用 xpub 来衍生出公钥分支，那么你应该通过
硬化父辈来衍生它，而不是一个正常的父辈。
这其中的最佳实践就是，为了防止威胁到主要的密钥，
主要密钥的 level-1 子辈
总是通过硬化衍生来衍生。

#### Index numbers for normal and hardened derivation
#### 正常衍生和硬化衍生的指数

The index number used in the BIP-32 derivation function is a 32-bit
integer. To easily distinguish between keys derived through the normal
derivation function versus keys derived through hardened derivation,
this index number is split into two ranges. Index numbers between 0 and
2<sup>31</sup>–1 (0x0 to 0x7FFFFFFF) are used *only* for normal
derivation. Index numbers between 2<sup>31</sup> and 2<sup>32</sup>–1
(0x80000000 to 0xFFFFFFFF) are used *only* for hardened derivation.
Therefore, if the index number is less than 2<sup>31</sup>, the child is
normal, whereas if the index number is equal or above 2<sup>31</sup>,
the child is hardened.
BIP-32 中的衍生函数使用的是一个 32 位整型的指数。
为了方便的区分出正常衍生函数和硬化衍生函数生成的密钥，
这个指数分成了两个区间。
0 到 2<sup>31</sup>–1 (0x0 to 0x7FFFFFFF) **只**用来表示
正常的衍生。2<sup>31</sup> 到 2<sup>32</sup>–1 (0x80000000 to 0xFFFFFFFF) 
**只**用来表示硬化衍生。
因此，如果指数小于 2<sup>31</sup>，则子辈是正常的，
如果指数大于等于 2<sup>31</sup>，那么子辈就是硬化的。

To make the index number easier to read and display, the index number
for hardened children is displayed starting from zero, but with a prime
symbol. The first normal child key is therefore displayed as 0, whereas
the first hardened child (index 0x80000000) is displayed as 0&\#x27;. In
sequence then, the second hardened key would have index 0x80000001 and
would be displayed as 1&\#x27;, and so on. When you see an HD wallet
index i&\#x27;, that means 2<sup>31</sup>+i.
为了让指数的易读性和显示性更好，硬化子辈
的指数是从零开始显示的（有一个素数符合）。
第一个正常子密钥则显示为 0，这样
第一个硬化子辈（指数为 0x80000000）就会显示为 0&\#x27;。
而第二个硬化密钥指数从 0x80000001 开始，并且显示为1&\#x27;，
以此类推。当你看到
一个 HD 钱包的指数为 i&\#x27; 时，就意味着 2<sup>31</sup>+i。

#### HD wallet key identifier (path)
#### HD 钱包密钥标识符（路径）

hierarchical deterministic (HD) walletsKeys in an HD wallet are
identified using a "path" naming convention, with each level of the tree
separated by a slash (/) character (see [table\_title](#hd_path_table)).
Private keys derived from the master private key start with "m." Public
keys derived from the master public key start with "M." Therefore, the
first child private key of the master private key is m/0. The first
child public key is M/0. The second grandchild of the first child is
m/0/1, and so on.
一个 HD 钱包中的密钥是通过『路径』命名规则来标识的，对于树的
每一个层级都通过斜杠 (/) 这个字符来分隔(查看[HD 钱包路径示例](#hd_path_table))。 
从主私钥衍生出的私钥都以 "m." 开头。
从主公钥衍生出的公钥以 "M." 开头。
因此主私钥的第一个子私钥就是 m/0。
主公钥的第一个子公钥就是 M/0。
第一个子辈的第二个孙子就是 m/0/1，以此类推。

The "ancestry" of a key is read from right to left, until you reach the
master key from which it was derived. For example, identifier m/x/y/z
describes the key that is the z-th child of key m/x/y, which is the y-th
child of key m/x, which is the x-th child of m.
一个密钥的『祖先』是从右向左读取的，直到衍生出它本身的主密钥为止。
举个例子，标识符 m/x/y/z 就是 
m/x/y 的第 z 个子密钥、m/x 的第 y 个子密钥、m 的第 x 个子密钥。

<table>
<caption>HD wallet path examples</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">HD path</th>
<th align="left">Key described</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>m/0</p></td>
<td align="left"><p>The first (0) child private key from the master private key (m)</p></td>
</tr>
<tr class="even">
<td align="left"><p>m/0/0</p></td>
<td align="left"><p>The first grandchild private key of the first child (m/0)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>m/0'/0</p></td>
<td align="left"><p>The first normal grandchild of the first <em>hardened</em> child (m/0')</p></td>
</tr>
<tr class="even">
<td align="left"><p>m/1/0</p></td>
<td align="left"><p>The first grandchild private key of the second child (m/1)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>M/23/17/0/0</p></td>
<td align="left"><p>The first great-great-grandchild public key of the first great-grandchild of the 18th grandchild of the 24th child</p></td>
</tr>
</tbody>
</table>

#### Navigating the HD wallet tree structure
#### HD 钱包的树形结构指南

The HD wallet tree structure offers tremendous flexibility. Each parent
extended key can have 4 billion children: 2 billion normal children and
2 billion hardened children. Each of those children can have another 4
billion children, and so on. The tree can be as deep as you want, with
an infinite number of generations. With all that flexibility, however,
it becomes quite difficult to navigate this infinite tree. It is
especially difficult to transfer HD wallets between implementations,
because the possibilities for internal organization into branches and
subbranches are endless.
HD 钱包的树形结构提供了巨大的灵活性。
每一个父拓展密钥都可以拥有 40 亿个子辈：20 亿
个普通子辈和 20 亿个硬化子辈。每一个子辈都有另外 40 亿个子辈，
以此类推。只要你想，这个树形结构就可以一代一代的无限延伸下去。
但是这种灵活性又使得对这个无限的树形结构操作变的复杂。
尤其是在各种实现之间转移 HD 钱包变的尤为困难，
因为这个内部的结构从分支到子分支的可能性是无限的。

Two BIPs offer a solution to this complexity by creating some proposed
standards for the structure of HD wallet trees. BIP-43 proposes the use
of the first hardened child index as a special identifier that signifies
the "purpose" of the tree structure. Based on BIP-43, an HD wallet
should use only one level-1 branch of the tree, with the index number
identifying the structure and namespace of the rest of the tree by
defining its purpose. For example, an HD wallet using only branch
m/i&\#x27;/ is intended to signify a specific purpose and that purpose
is identified by index number "i."
现在的两种 BIP 都是通过对 HD 钱包的树形结构创建一些标准
来解决这些复杂性的。BIP-43 提议将第一个硬化子指数作为
可以表示树形结构『用途』的特殊标识符。
而 BIP-43 则认为，HD 钱包应该只使用一个树形结构 level-1 的
分支，并通过定义它的用途来让指数来标识结构以及
剩余数的命名空间。
例如，一个 HD 钱包只使用分支 m/i&\#x27;/，并打算使用它来指明一个特殊的用途，
而这个用途就是用指数 "i" 来标识的。

Extending that specification, BIP-44 proposes a multicurrency
multiaccount structure as "purpose" number 44' under BIP-43. All HD
wallets following the BIP-44 structure are identified by the fact that
they only used one branch of the tree: m/44'/.
再说明一下这个细则，BIP-44 提议的多货币多账户的结构
就是 BIP-43 的『用途』数字 44'。
所有的 HD 钱包都遵循 BIP-44 结构，这个结构就是
实际中使用树形结构一个分支 m/44'/ 所标识的结构。

BIP-44 specifies the structure as consisting of five predefined tree
levels:
BIP-44 还指明了五个预定义的树层级：

    m / purpose' / coin_type' / account' / change / address_index

The first-level "purpose" is always set to 44'. The second-level
"coin\_type" specifies the type of cryptocurrency coin, allowing for
multicurrency HD wallets where each currency has its own subtree under
the second level. There are several currencies defined in a standards
document, called SLIP0044:
第一个层级 "purpose" 一直等于 44'。第二个
层级 "coin\_type" 指明了数字货币的类型，对于
多货币的 HD 钱包来每一个种货币都在
第二层级下有他自己的子树。这里有几个在标准文档中定义的货币，
叫作 SLIP0044：

<https://github.com/satoshilabs/slips/blob/master/slip-0044.md>

A few examples: Ethereum is m/44&\#x27;/60&\#x27;, Ethereum Classic is
m/44&\#x27;/61&\#x27;, Bitcoin is m/44&\#x27;/0&\#x27;, and Testnet for
all currencies is m/44&\#x27;/1&\#x27;.
举个例子：以太坊是 m/44&\#x27;/60&\#x27;，以太经典
是 m/44&\#x27;/61&\#x27;，比特币是 m/44&\#x27;/0&\#x27;，所有
这些货币的测试网络都是 m/44&\#x27;/1&\#x27;。

The third level of the tree is "account," which allows users to
subdivide their wallets into separate logical subaccounts, for
accounting or organizational purposes. For example, an HD wallet might
contain two Ethereum "accounts": m/44&\#x27;/60&\#x27;/0&\#x27; and
m/44&\#x27;/60&\#x27;/1&\#x27;. Each account is the root of its own
subtree.
第三个层级是 "account"，它允许用户把他们的钱包再分成几个
逻辑子账户，用于会计或者组织的目的。
举例来说，一个 HD 钱包可以包含两个以太坊『账户』：
m/44&\#x27;/60&\#x27;/0&\#x27; 和 m/44&\#x27;/60&\#x27;/1&\#x27;。
而每个帐户都是它自己子树的根。

keys and addressessee=also public and private keys see=also public and
private keysBecause BIP-44 was created originally for bitcoin, it
contains a "quirk" that isn’t relevant in the Ethereum world. On the
fourth level of the path, "change," an HD wallet has two subtrees, one
for creating receiving addresses and one for creating change addresses.
Only the "receive" path is used in Ethereum, as there is no such thing
as a change address. Note that whereas the previous levels used hardened
derivation, this level uses normal derivation. This is to allow this
level of the tree to export extended public keys for use in a
non-secured environment. Usable addresses are derived by the HD wallet
as children of the fourth level, making the fifth level of the tree the
"address\_index." For example, the third receiving address for Ethereum
payments in the primary account would be
M/44&\#x27;/60&\#x27;/0&\#x27;/0/2. [table\_title](#bip44_path_examples)
shows a few more examples.
因为 BIP-44 一开始是为比特币创造的，所以它包含
的 "quirk" 和以太坊一点关系都没有。
路径的第四层级是 "change"，一个 HD 钱包有两个子树，
一个用来创建接收地址，一个用来创建改变地址。
而以太坊中只有『接收』地址，并不需要改变地址。
注意，由于上个层级使用了硬化衍生，所以这个层级就是普通衍生。
这是为了让这个层级的树可以在非安全环境下导出可以使用的公钥。
可用的地址由 HD 钱包衍生出来作为第四层级的子辈，然后形成树
第五层级的 "address\_index"。
举例来说就是，以太坊的第三个接收地址在
主账户中的支付将会是 M/44&\#x27;/60&\#x27;/0&\#x27;/0/2。
[BIP-44 HD 钱包的结构示例](#bip44_path_examples)：

<table>
<caption>BIP-44 HD wallet structure examples</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">HD path</th>
<th align="left">Key described</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>M/44&amp;#x27;/60&amp;#x27;/0&amp;#x27;/0/2</p></td>
<td align="left"><p>The third receiving public key for the primary Ethereum account</p></td>
</tr>
<tr class="even">
<td align="left"><p>M/44&amp;#x27;/0&amp;#x27;/3&amp;#x27;/1/14</p></td>
<td align="left"><p>The fifteenth change-address public key for the fourth bitcoin account</p></td>
</tr>
<tr class="odd">
<td align="left"><p>m/44&amp;#x27;/2&amp;#x27;/0&amp;#x27;/0/1</p></td>
<td align="left"><p>The second private key in the Litecoin main account, for signing transactions</p></td>
</tr>
</tbody>
</table>

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
