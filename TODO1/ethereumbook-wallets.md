> * 原文地址：[ethereumbook-wallets](https://github.com/ethereumbook/ethereumbook/blob/develop/wallets.asciidoc)
> * 原文作者：[ethereumbook](https://github.com/ethereumbook)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ethereumbook-wallets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ethereumbook-wallets.md)
> * 译者：[XatMassacrE](https://github.com/XatMassacrE)
> * 校对者：[leviding](https://github.com/leviding)

## 以太坊钱包详解

「钱包」这个词语在以太坊中表示的并不是它本来的意思。

宏观的讲，钱包主要就是为用户提供用户界面的一个应用。它掌管着用户的金钱，管理着密钥和地址，追踪账户余额以及创建交易和签名。除此之外，一些以太坊钱包还可以与智能合约进行交互，例如代币之类的。

而从一个程序员的角度更准确的讲，「钱包」这个词语指的就是存储和管理密钥和地址的系统。每一个「钱包」都有一个密钥管理组件。而对于有些钱包来说，这就是钱包的全部。其他的大部分钱包都是「浏览器」，其实就是基于以太坊的去中心化应用的接口。所以这些各式各样的「钱包」之间并没有什么明确的界限。

接下来让我们先看一看钱包关于密钥管理和私钥容器部分的功能。

### 钱包技术总览

在这个部分我们会总结用于构建用户友好、安全以及灵活的以太坊钱包所需要的各种技术。

关于以太坊有一个最常见的误解就是大部分人认为以太坊钱包包含以太坊和其他代币。而实际上，钱包只包含密钥。以太坊和其他代币都被记录在以太坊的区块链中。用户通过使用他们钱包中的密钥对钱包签名来控制代币。所以从某种意义上讲，以太坊钱包就是一个**钥匙串**。

> **提示**
> 
> 以太坊钱包只包含密钥，而没有以太坊和代币。每一个用户的钱包都包含密钥。钱包就是包含公私钥对的钥匙串。用户使用密钥对交易签名，以此来证明这些以太坊就是属于他们的。而真正的以太坊则存储在区块链上。

目前主要有两种类型的钱包，他们的区别就是所包含的密钥之间是否有关联。

第一种类型叫做**非确定性钱包**，它的每一个密钥都是通过一个随机数独立生成的。密钥之间相互没有关联。这种钱包也叫做 JBOK 钱包（来自 "Just a Bunch Of Keys"）。

第二种钱包叫做**确定性钱包**，它所有的密钥都来源于一个单独的叫做**种子**的主密钥。在这个钱包中所有的密钥都相互关联，并且任何拥有原始种子的人都可以将这些密钥再生成一遍。这种确定性钱包会使用很多不同的密钥派生方法。而其中使用最普遍的则是一种类似树形结构的方法，这样的钱包被称为**分层确定性**或者 HD 钱包。

分层确定性钱包是通过一个种子来初始化的。而为了便于使用，种子会被编码成英语单词（或者其他语言的单词），这些单词被称为**助记词**。

下面的章节将会在更高级的层面介绍这些技术。

### 非确定性（随机）钱包

在第一个的以太坊钱包（以太坊预售时发布的）中，钱包文件会存储一个单独随机生成的私钥。然而这种钱包之后被确定性钱包取代了，因为这种钱包无法管理、备份以及导入私钥。但是随机密钥的缺点是，如果你生成了很多那么你就要把它们全部拷贝下来。每一个密钥都要备份，否则一旦钱包丢失，那些密钥对应的资产也会丢失。进一步讲，以太坊地址的隐私性会因为相互之间关联的多笔交易和地址的重复使用而大大降低。一个类型-0 的非确定性钱包并不是一个好的选择，尤其是当你为了避免地址的重复使用而不得不管理多个密钥并不断频繁的备份它们时。

很多以太坊客户端（包括 go-ethereum 和 geth）都会使用一个**钥匙串**文件，这是一个 JSON 编码的文件，而且它还包含一个单独的（随机生成的）私钥，为了安全性，这个私钥会通过一个密码进行加密。这个 JSON 文件就像下面这样：

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

钥匙串格式使用的是**Key Derivation Function (KDF)**，同时还被成为密码拉伸算法，这个算法可以防止暴力破解、字典攻击以及彩虹表攻击。简单来说就是私钥并不是直接通过密码简单的进行加密的。相反，这个密码是通过不断的重复哈希**拉伸**过的。这个哈希函数会重复 262144 轮，这个数字就是钥匙串 JSON 文件中的 crypto.kdfparams.n 这个参数指定的。一个攻击者试图通过暴力破解的手段来破解密码的话，那么他需要为每一个可能的密码执行 262144 轮哈希，这样对于一个足够复杂和长度的密码来说被破解几乎是不可能的。

这里还有一些软件库可以读取和写入钥匙串格式，例如 JavaScript 的库 keythereum：

<https://github.com/ethereumjs/keythereum>

> **提示**
> 
> 除了一些简单的测试之外，我们是不推荐使用非确定性钱包的。我们推荐使用的是拥有**助记词**种子备份功能的基于行业标准的**HD 钱包**。

### 确定性钱包（种子）钱包

确定性或者说「种子」钱包是指那些所有的私钥都是通过一个普通的种子使用一个单向哈希函数延伸而来的钱包。这个种子是结合一些其他的数据而随机生成的数字，例如利用一个索引数字或者「链码」（查看[HD 钱包(BIP-32/BIP-44)](#hd_钱包)来派生出私钥。在一个确定性钱包中，一个种子就足够恢复出所有派生的密钥，因此只需要在创建的时候做一次备份就可以了。同时，这个种子对于钱包来说也是可以导入导出的，可以让所有用户的密钥在各种不同的钱包之间进行简单的迁移。

### HD 钱包 (BIP-32/BIP-44)

确定性钱包的开发就是为了可以简单的从一个「种子」派生出很多个密钥。而这种确定性钱包最高级的实现就是由比特币的 BIP-32 标准定义的 HD 钱包。HD 钱包包含的密钥来源于一个树形的结构，例如一个父密钥可以派生出一系列子密钥，每一个子密钥又可以派生出一系列孙子密钥，不停的循环往复，没有尽头。这个树形结构的示意图如下：

![HD wallet: a tree of keys generated from a single
seed](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/hd_wallet.png)

HD 钱包相对于随机的（非确定性的）密钥有两个主要的优势。一，树形结构可以表达额外的组织意义，例如当一个子密钥特定的分支用来接收转入支付而另一个不同的分支可以接收转出支付的改变。密钥的分支也可以在一些共同的设置中被使用，例如可以分配不同的分支给部门、子公司、特定的函数或者不同的账单类别。

第二个优势就是用户可以使用 HD 钱包在不利用相关私钥的情况下创建一系列公钥。这样 HD 钱包就可以用来做一个安全的服务或者是一个仅仅用来观察和接收的服务，而钱包本身却没有私钥，所以它也无法花费资金。

### 种子和助记词 (BIP-39)

HD 钱包对于管理多个密钥和地址来说是一个很强力的机制。如果再结合一个从一系列英语单词（或者其他语言的单词）中创建种子的标准化方法的话，那么通过钱包进行抄写、导出和导入都变得更加简单易用。这就是大家所熟知的由标准 BIP-39 定义的**助记词**。今天，很多以太坊钱包（还有其他的数字货币钱包）都在使用这个标准来导入导出种子，并使用共同的助记词来进行备份和恢复。

让我们来从实践的角度看一下。下面哪个种子在抄写、纸上记录以及阅读障碍这几个方面更优秀呢？

**一个 16 进制编码的确定性钱包种子**

    FCCF1AB3329FD5DA3DA9577511F8F137

**一个由 12 个单词组成的助记词的钱包种子**

    wolf juice proud gown wool unfair
    wall cliff insect more detail hub

### 钱包最佳实践

随着数字货币钱包技术的逐渐成熟，也慢慢形成了共同的行业标准，使得钱包在交互性、易用性、安全性和灵活性等方面大幅度提高。这些标准同时也使得钱包可以仅仅从一个单独助记词就为各种不同的数字货币派生出不同的密钥。这些共同的标准就是下面这些：

-   基于 BIP-39 的助记词

-   基于 BIP-32 的 HD 钱包

-   基于 BIP-43 的多用途 HD 钱包结构

-   基于 BIP-44 的多货币多账户钱包

这些标准或许会改变，也或许会被未来的开发者废弃，但是现在它们组成的这一组连锁技术俨然已经成为了大多数数字货币的实际上的钱包标准。

这些标准已经被大部分的软件和硬件钱包所采用，使得这些钱包之间可以相互通用。一个用户可以从这些钱包中的任意一个导出助记词，然后导入到另一个钱包中，并恢复所以的交易、密钥和地址。

很多软件钱包都支持这种标准，例如（按字母 排序）Jaxx, MetaMask, MyEtherWallet (MEW)。硬件钱包则有 Keepkey, Ledger, and Trezor。

下面的章节会详细讲解这些技术。

> **提示**
>
> 如果你要实现一个以太坊钱包，他应该是一个 HD 钱包，种子会被编码成助记词以供备份，BIP-32、BIP-39、BIP-43、和 BIP-44 这些标准会在下面的章节中详细说明。

### 助记词 (BIP-39)

助记词就是代表一个随机数的单词序列，这个助记词会作为种子派生出一个确定性钱包。这个序列的单词能够再次创建种子、钱包和所有派生出的密钥。一个实现了确定性钱包助记词功能的应用将会向在第一次创建钱包的时候向用户展示一组长度为 12 到 24 的单词序列。这个序列就是钱包的备份，它可以在任何兼容的钱包上实现恢复和重建所有的密钥。助记词可以让用户更简单的备份钱包，因为相比于一组随机数助记词可读性更好，抄写的正确率也更高。

> **提示**
> 
> 助记词常常与「大脑钱包」想混淆。但是它们并不是一回事。而其中最主要的区别在于大脑钱包是由用户自己选择的单词组成的，而助记词则是钱包代表用户随机创建的。这个重要的区别使得助记词更加的安全，因为人类随机性的来源少的可怜。
 
助记词编码是在 BIP-39 中定义的。注意 BIP-39 只是助记词编码的一个实现。还有很多不同的标准，比特币钱包 Electrum 就是在 BIP-39 之前**使用了一组不同的单词**。BIP-39 这个标准是由硬件钱包 Trezor 背后的公司提出来的，而且还兼容 Electrum 的实现。但是，BIP-39 现在已经取得了广泛的行业支持，并且兼容十几个相互操作的实现，所以 BIP-39 应该就是现在的行业标准。并且，BIP-39 可以用来生成支持以太坊的多货币钱包，而 Electrum 的种子并不支持。

BIP-39 标准定义了助记词编码和种子的生成过程，也就是接下来的九个步骤。为了表达的更清楚，整个过程分成了两个部分：第一步到第六步在[生成助记词](#generating_mnemonic_words)，第七步到第九步在[助记词到种子](#mnemonic_to_seed)。

#### 生成助记词

助记词是钱包使用 BIP-39 中定义的标准化过程自动生成的。钱包起始于一个熵的源头，然后添加一个校验和并将熵映射到一个单词数组中。

1.  创建一个 128 位到 256 位的随机序列（熵）

2.  通过取 SHA256 的前（熵长度除以 32）位来创建这个随机序列的校验和。

3.  将校验和添加到随机序列的末尾。

4.  将序列分成几个 11 位的部分。

5.  从预定义的 2048 个单词字典中将每一个 11 位的值映射到一个单词上面。

6.  助记词编码就是一系列单词。

[生成熵并编码成助记词](#generating_entropy_and_encoding)将会展示出熵是如何生成助记词的。

![Generating entropy and encoding as mnemonicwords](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39-part1.png)

[助记词编码：熵和单词长度](#table_bip39_entropy) 展示出了熵数据的大小和单词中助记词长度的关系。

<table>
<caption>助记词编码: 熵（entropy）和单词（word）长度</caption>
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

#### 从助记词到种子

助记词代表着长度为 128 到 256 位的熵。这个熵会通过密钥拉伸函数 PBKDF2 生成一个更长的（512 位）种子。这个种子再构建一个确定性钱包并派生出它的密钥。

密钥拉伸函数需要两个参数：助记词和**盐**。盐的目的是为了让暴力破解构建查询表的难度提高。在标准 BIP-39 中，盐还有另外一个目的，那就是密码可以作为一个额外的安全因子来保护种子，这部分会在[BIP-39 中的可选密码](#mnemonic_passphrase)中详细讲述。

第七步到第九步的过程：

7.  密钥拉伸函数 PBKDF2 的第一个参数第六步中生成的助记词。

8.  密钥拉伸函数 PBKDF2 的第二个参数就是**盐**。这个盐由字符串常量 "mnemonic" 和一个额外的用户提供的密码字符串拼接构成。

9.  PBKDF2 使用 HMAC-SHA512 算法进行了 2048 轮哈希运算对助记词和盐进行拉伸，生成一个 512 位的值作为最后的输出。这个 512 位的值就是种子。

[fig\_5\_7] 展示出了一个助记词是如何生成种子的。

![From mnemonic to seed](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39-part2.png)

> **提示**
>
> 密钥拉伸函数以及它的 2048 轮哈希从某种程度上讲对于暴力破解助记词和密码是一个有效的保护。会让其以昂贵的代价（在计算资源上）不停的尝试成千上万种密码和助记词的组合，而这些组合的数量则犹如汪洋大海(2<sup>512</sup>)。


下面的表格分别展示了 \#mnemonic\_128\_no\_pass、\#mnemonic\_128\_w\_pass 和 \#mnemonic\_256\_no\_pass 这几个类型的助记词和他们产生的种子（没有密码）的例子。

<table>
<caption>128 位（bit）熵（entropy）的助记词编码（mnemonic code），无密码生成的种子（seed）</caption>
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
<caption>128 位（bit）熵（entropy）的助记词编码（mnemonic code），有密码生成的种子（seed）</caption>
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
<caption>256 位（bit）熵（entropy）的助记词编码（mnemonic code），无密码生成的种子（seed）</caption>
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

#### BIP-39 中的可选密码

BIP-39 标准允许用户在生成种子的时候使用可选密码。如果没有使用密码，那么助记词就会被一个由常量字符串 "mnemonic" 组成的盐拉伸，然后由给定的助记词产生一个特定的 512 位种子。如果使用了密码，则拉伸函数在使用同一个助记词的情况下会产生一个**不同的**种子。实际上，给定一个助记词，每一个可能的密码都会生成不同的种子。并且基本上没有任何「错误」的 密码。所有的密码都是可用的并且所有的密码都可以生成不同种子，这些不同的助记词会形成一组数量巨大的为初始化的钱包。这些可能的钱包数量是如此之大 (2<sup>512</sup>)，以至于实际情况中暴力破解和意外猜对的可能性几乎为零，只要密码拥有足够的复杂度和长度。

> **提示**
> 
> 在标准 BIP-39 中不存在「错误的」密码。每个密码都会生成一个钱包，如果不是之前使用的密码的话那就是一个新的钱包。

可选密码会产生两个重要的特性：

-   一个需要记忆的第二个因子可以防止助记词的备份被窃取。

-   选择密码的这些貌似拥有可信拒绝能力或者说是「监禁的钱包」使得那些小额资金的钱包经常将攻击者的注意力从那些「真正的」大额资金钱包中分散出来。

但是，需要注意的一点是使用密码会面临密码丢失的风险。

-   如果钱包的主人缺乏行动能力或者去世了，那么就没人知道密码了，也没人知道种子是什么，那么钱包中储存的所有资金就全部丢失了。

-   相反，如果钱包的主人在与种子同样的地方备份了密码，那么它就失去了第二个因素的目的。

虽然密码非常有用，但是也应该结合小心的计划备份和恢复的过程来使用，因为要考虑到钱包主人生还的可能性并可以允许他们的家人来恢复数字货币的资产。


#### 助记词的工作

BIP-39 在很多不同的编程语言中都有实现的库：

[python-mnemonic](https://github.com/trezor/python-mnemonic)  
参考了 SatoshiLabs 团队在 BIP-39 中提议的 Python 版本


[Consensys/eth-lightwallet](https://github.com/ConsenSys/eth-lightwallet)  
用于节点和浏览器（基于 BIP-39）的轻量级 JS 以太坊钱包

[npm/bip39](https://www.npmjs.com/package/bip39)  
比特币 BIP39 的 JavaScript 实现：用于生成确定性密钥的助记词编码

还有一个在单独的网页中实现的 BIP-39 生成器，这个网页在测试和实验中非常有用。[BIP-39 生成器](#a_bip39_generator_as_a_standalone_web_page)展示了一个可以生成助记词、种子以及拓展的私钥的单独的网页。

![A BIP-39 generator as a standalone web page](https://raw.githubusercontent.com/ethereumbook/ethereumbook/develop/images/bip39_web.png)

网页(<https://iancoleman.github.io/bip39/>)可以在浏览器中离线使用（在线当然也可以）。

### 通过种子创建一个 HD 钱包

HD 钱包是通过一个**根种子**来创建的，这个根种子一般是 128、256 或者 512 位的随机数。通常情况下，这个种子是通过一个**助记词**来生成的。

HD 钱包中的每一个密钥都是派生自这个根种子，这样就使得通过这个种子在其他兼容性钱包中重建整个 HD 钱包成为了可能。同时还使得备份、恢复、导出以及导入包含成千上万个密钥的钱包变的非常简单，仅仅通过转移从根种子派生出的助记词就可以了。

\[\[bip32\_bip43/44\]\] ==== 分层确定性钱包 (BIP-32) 和路径 (BIP-43/44)

大多数 HD 钱包都遵循 BIP-32 标准，同时 BIP-32 也是确定密钥生成器的实际上的行业标准。详细的说明可以查看下面的链接：

<https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki>

在这里我们不会讨论 BIP-32，我们只需要理解钱包中使用它的部分就可以了。在其他一些软件库中还有很多关于 BIP-32 彼此协作的实现。

[Consensys/eth-lightwallet](https://github.com/ConsenSys/eth-lightwallet)  
用于节点和浏览器（基于 BIP-39）的轻量级 JS 以太坊钱包

这里还有一个标准 BIP-32 的网页版的生成器，对于测试和实验都非常有用。

<http://bip32.org/>

> **提示**
> 
> 这个单独的 BIP-32 生成器不是一个 HTTPS 的站点。就是为了告诉你使用这个工具不是安全的。只是用来做测试的。你不应该在生产环境中（真实的资金）使用这个网页生成的密钥。
  

#### 拓展公钥和私钥

在 BIP-32 的术语中，一个父密钥可以拓展的生成「儿子」，这个儿子就是**拓展密钥**。如果它是一个私钥，那么它就是一个**拓展私钥**，并通过前缀 **xprv** 来区分：

    xprv9s21ZrQH143K2JF8RafpqtKiTbsbaxEeUaMnNHsm5o6wCW3z8ySyH4UxFVSfZ8n7ESu7fgir8imbZKLYVBxFPND1pniTZ81vKfd45EHKX73

一个**拓展公钥**通过前缀 **xpub** 来区分：

    xpub661MyMwAqRbcEnKbXcCqD2GT1di5zQxVqoHPAgHNe8dv5JP8gWmDproS6kFHJnLZd23tWevhdn4urGJ6b264DfTGKr8zjmYDjyDTi9U7iyT

HD 钱包中一个非常有用的角色就是从父公钥派生出子公钥，**不包含**私钥。这会给我们提供两种方法来派生子公钥：从子私钥或者直接从父公钥来派生。

一个拓展公钥可以在 HD 钱包的结构中派生出所有的**公钥**（也只能是公钥）。

无论什么情况只要部署的服务和应用有一份拓展公钥并且没有私钥，那么这个快捷方式就可以创建非常安全的公钥。这种部署可以生成无穷个公钥和以太坊地址，但是却不能花费任何发送到这些地址的资金。同时，在另外一个更安全的服务器上，拓展私钥可以派生出所有相关的私钥用来给交易签名，并花费资金。

利用这种解决方案的一个常见的应用就是在一个 web 服务器上安装一个拓展公钥，来为电子商务应用服务。这个网页服务器可以使用公钥派生函数为每一笔交易（例如客户的购物车）创造出一个全新的以太坊地址。这个网页服务器没有任何私钥所以盗贼也无法窃取。不使用 HD 钱包的情况下，想做到这个程度唯一的方法就是在一个分割的安全服务器上生成上千个以太坊地址然后在电子商务服务器上预加载他们。这个方法低效笨重，并且需要经常的维护以确保电子商务服务器不会泄露密钥。

还有一个常见的应用就是冷存储和硬件钱包。在这种场景下，拓展私钥可以存储在硬件钱包中，但是拓展公钥可以放在线上。用户可以按照他们的意愿创建接收的地址，私钥则会离线安全的保存。想花掉里面的资金的话，用户可以在离线签名的以太坊客户端或者支持交易签名的硬件钱包上使用拓展私钥。

#### 硬化密钥派生

从 xpub 中派生出一个公钥分支的能力时很有用的，但同时也是具有风险的。知道 xpub 并不意味着知道子密钥。然而，因为 xpub 包含链码，所以如果一个子密钥被别人知道或者暴露了的话，那么它就可以和链码一起派生出所有其他的子密钥。一个单独泄露的子密钥和一个父链码一起可以暴露出所有的子私钥。而更糟糕的是，子私钥和父链码一起还可以推断出父私钥。

为了避免这个风险，HD 钱包使用了另外一种叫做**硬化派生**的派生函数，这个函数可以「破坏」父公钥和子链码的联系。这种硬化派生函数是使用父私钥来派生出子链码的，而不是父公钥。这样会在父或子序列中创造出一个「防火墙」，而这个防火墙并不会威胁到父或者子私钥的安全。

简单的来说就是，如果不想承受泄露你自己链码风险，并且还想要方便的使用 xpub 来派生出公钥分支，那么你应该通过硬化父辈来派生它，而不是一个正常的父辈。这其中的最佳实践就是，为了防止威胁到主要的密钥，主要密钥的 level-1 子辈总是通过硬化派生来派生。

#### 正常派生和硬化派生的指数

BIP-32 中的派生函数使用的是一个 32 位整型的指数。为了方便的区分出正常派生函数和硬化派生函数生成的密钥，这个指数分成了两个区间。0 到 2<sup>31</sup>–1 (0x0 to 0x7FFFFFFF) **只**用来表示正常的派生。2<sup>31</sup> 到 2<sup>32</sup>–1 (0x80000000 to 0xFFFFFFFF) **只**用来表示硬化派生。因此，如果指数小于 2<sup>31</sup>，则子辈是正常的，如果指数大于等于 2<sup>31</sup>，那么子辈就是硬化的。

为了让指数的易读性和显示性更好，硬化子辈的指数是从零开始显示的（有一个素数符合）。第一个正常子密钥则显示为 0，这样第一个硬化子辈（指数为 0x80000000）就会显示为 0&\#x27;。而第二个硬化密钥指数从 0x80000001 开始，并且显示为1&\#x27;，以此类推。当你看到一个 HD 钱包的指数为 i&\#x27; 时，就意味着 2<sup>31</sup>+i。

#### HD 钱包密钥标识符（路径）

一个 HD 钱包中的密钥是通过「路径」命名规则来标识的，对于树的每一个层级都通过斜杠 (/) 这个字符来分隔(查看[HD 钱包路径示例](#hd_path_table))。 从主私钥派生出的私钥都以 "m." 开头。从主公钥派生出的公钥以 "M." 开头。因此主私钥的第一个子私钥就是 m/0。主公钥的第一个子公钥就是 M/0。第一个子辈的第二个孙子就是 m/0/1，以此类推。

一个密钥的「祖先」是从右向左读取的，直到派生出它本身的主密钥为止。举个例子，标识符 m/x/y/z 就是 m/x/y 的第 z 个子密钥、m/x 的第 y 个子密钥、m 的第 x 个子密钥。

<table>
<caption>HD 钱包路径示例</caption>
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
<td align="left"><p>主私钥 m 的第一个（0）儿子私钥</p></td>
</tr>
<tr class="even">
<td align="left"><p>m/0/0</p></td>
<td align="left"><p>第一个子辈（m/0）的第一个孙子私钥</p></td>
</tr>
<tr class="odd">
<td align="left"><p>m/0'/0</p></td>
<td align="left"><p>第一个<em>硬化</em>子辈 (m/0') 的第一个标准孙子</p></td>
</tr>
<tr class="even">
<td align="left"><p>m/1/0</p></td>
<td align="left"><p>第二个子辈（m/1）的第一个孙子私钥</p></td>
</tr>
<tr class="odd">
<td align="left"><p>M/23/17/0/0</p></td>
<td align="left"><p>第 24 个子辈的第 18 个孙子辈的第一个曾孙辈的第一个玄孙的公钥</p></td>
</tr>
</tbody>
</table>

#### HD 钱包的树形结构指南

HD 钱包的树形结构提供了巨大的灵活性。每一个父拓展密钥都可以拥有 40 亿个子辈：20 亿个普通子辈和 20 亿个硬化子辈。每一个子辈都有另外 40 亿个子辈，以此类推。只要你想，这个树形结构就可以一代一代的无限延伸下去。但是这种灵活性又使得对这个无限的树形结构操作变的复杂。尤其是在各种实现之间转移 HD 钱包变的尤为困难，因为这个内部的结构从分支到子分支的可能性是无限的。

现在的两种 BIP 都是通过对 HD 钱包的树形结构创建一些标准来解决这些复杂性的。BIP-43 提议将第一个硬化子指数作为可以表示树形结构「用途」的特殊标识符。而 BIP-43 则认为，HD 钱包应该只使用一个树形结构 level-1 的分支，并通过定义它的用途来让指数来标识结构以及剩余数的命名空间。例如，一个 HD 钱包只使用分支 m/i&\#x27;/，并打算使用它来指明一个特殊的用途，而这个用途就是用指数 "i" 来标识的。

再说明一下这个细则，BIP-44 提议的多货币多账户的结构就是 BIP-43 的「用途」数字 44'。所有的 HD 钱包都遵循 BIP-44 结构，这个结构就是实际中使用树形结构一个分支 m/44'/ 所标识的结构。

BIP-44 还指明了五个预定义的树层级：

    m / purpose' / coin_type' / account' / change / address_index

第一个层级 "purpose" 一直等于 44'。第二个层级 "coin\_type" 指明了数字货币的类型，对于多货币的 HD 钱包来每一个种货币都在第二层级下有他自己的子树。这里有几个在标准文档中定义的货币，叫作 SLIP0044：

<https://github.com/satoshilabs/slips/blob/master/slip-0044.md>

举个例子：以太坊是 m/44&\#x27;/60&\#x27;，以太经典是 m/44&\#x27;/61&\#x27;，比特币是 m/44&\#x27;/0&\#x27;，所有这些货币的测试网络都是 m/44&\#x27;/1&\#x27;。

第三个层级是 "account"，它允许用户把他们的钱包再分成几个逻辑子账户，用于会计或者组织的目的。举例来说，一个 HD 钱包可以包含两个以太坊「账户」：m/44&\#x27;/60&\#x27;/0&\#x27; 和 m/44&\#x27;/60&\#x27;/1&\#x27;。而每个帐户都是它自己子树的根。

因为 BIP-44 一开始是为比特币创造的，所以它包含的 "quirk" 和以太坊一点关系都没有。路径的第四层级是 "change"，一个 HD 钱包有两个子树，一个用来创建接收地址，一个用来创建改变地址。而以太坊中只有「接收」地址，并不需要改变地址。注意，由于上个层级使用了硬化派生，所以这个层级就是普通派生。这是为了让这个层级的树可以在非安全环境下导出可以使用的公钥。可用的地址由 HD 钱包派生出来作为第四层级的子辈，然后形成树第五层级的 "address\_index"。举例来说就是，以太坊的第三个接收地址在主账户中的支付将会是 M/44&\#x27;/60&\#x27;/0&\#x27;/0/2。[BIP-44 HD 钱包的结构示例](#bip44_path_examples)：

<table>
<caption>BIP-44 HD 钱包结构示例</caption>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">HD 路径</th>
<th align="left">密钥描述</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><p>M/44&amp;#x27;/60&amp;#x27;/0&amp;#x27;/0/2</p></td>
<td align="left"><p>主以太坊账户的第三个收到的公钥</p></td>
</tr>
<tr class="even">
<td align="left"><p>M/44&amp;#x27;/0&amp;#x27;/3&amp;#x27;/1/14</p></td>
<td align="left"><p>第四个比特币账户的第 15 个可变地址的公钥</p></td>
</tr>
<tr class="odd">
<td align="left"><p>m/44&amp;#x27;/2&amp;#x27;/0&amp;#x27;/0/1</p></td>
<td align="left"><p>用于签名交易的莱特币主账户的第二个私钥</p></td>
</tr>
</tbody>
</table>

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
