
> * 原文地址：[Learn Blockchains by Building One: The fastest way to learn how Blockchains work is to build one](https://hackernoon.com/learn-blockchains-by-building-one-117428612f46)
> * 原文作者：[Daniel van Flymen](https://hackernoon.com/@vanflymen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/learn-blockchains-by-building-one.md](https://github.com/xitu/gold-miner/blob/master/TODO/learn-blockchains-by-building-one.md)
> * 译者：[cdpath](https://github.com/cdpath)
> * 校对者：[atuooo](https://github.com/atuooo) [dubuqingfeng](https://github.com/dubuqingfeng)

# 从零到一用 Python 写一个区块链

![](https://cdn-images-1.medium.com/max/2000/1*zutLn_-fZZhy7Ari-x-JWQ.jpeg)

本文的读者想必跟我一样对数字加密货币的崛起兴奋不已，应该也想了解数字加密货币背后的区块链的工作原理吧。

但是区块链不太好懂，反正我理解起来比较费劲。我看了不少难懂的视频，学了些漏洞百出的教程，找了些少得可怜的例子试了试，都挺让人失望的。

我喜欢在实践中学习。这迫使我搞定在代码层面就至关重要的东西，这才是黏人的地方。如果你和我一样，读完本文你就可以构建一个可以使用的区块链，同时扎实理解其工作原理。

## 背景知识……

要知道区块链是**不可变的，有序的**记录的链，记录也叫做区块。区块可以包含交易，文件或者任何你能想到的数据。不过至关重要的是，它们由**哈希值****链接**在一起。

如果你不知道哈希是什么，先看看 [这篇文章](https://learncryptography.com/hash-functions/what-are-hash-functions)。

**本文的目标读者是谁？** 你应该可以熟练读写基本的 Python 代码，也要基本了解 HTTP 请求的工作原理，因为本文将要实现的区块链依赖 HTTP。

**需要什么环境？** Python 版本不低于 3.6，装有 `pip`。还需要安装 Flask 和绝赞的 Requests 库：

```
pip install Flask==0.12.2 requests==2.18.4
```

哦，你还得有个 HTTP 客户端，比如 Postman 或者 cURL。随便什么都可以。

**那代码在哪里？** 源代码在 [这里](https://github.com/dvf/blockchain)。

## 第一步：创建 Blockchain 类

用你喜欢的编辑器或者 IDE，新建 `blockchain.py` 文件，我个人比较喜欢 [PyCharm](https://www.jetbrains.com/pycharm/)。本文全文都使用这一个文件，但是如果你搞丢了，可以参考[源代码](https://github.com/dvf/blockchain)。

### 表示区块链

创建 `Blockchain` 类，其构造函数会创建两个初始为空的列表，一个存储区块链，另一个存储交易信息。类设计如下：

```
class Blockchain(object):
    def __init__(self):
        self.chain = []
        self.current_transactions = []
        
    def new_block(self):
        # Creates a new Block and adds it to the chain
        pass
    
    def new_transaction(self):
        # Adds a new transaction to the list of transactions
        pass
    
    @staticmethod
    def hash(block):
        # Hashes a Block
        pass

    @property
    def last_block(self):
        # Returns the last Block in the chain
        pass
```

Blockchain 类的设计


`Blockchain` 类负责管理链。它用来存储交易信息，也有一些帮助方法用来将新区块添加到链中。我们接着来实现一些方法。

### 区块长什么样？

每个区块都有其**索引**，**时间戳**（Unix 时间），**交易列表**，**证明**（稍后解释），以及**前序区块的哈希值**。

下面是一个单独区块：

```
block = {
    'index': 1,
    'timestamp': 1506057125.900785,
    'transactions': [
        {
            'sender': "8527147fe1f5426f9dd545de4b27ee00",
            'recipient': "a77f5cdfa2934df3954a5c7c7da5df1f",
            'amount': 5,
        }
    ],
    'proof': 324984774000,
    'previous_hash': "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
}
```

区块链中的区块的例子

到这里**链**的概念就介绍清楚了：每个新区块都包含上一个区块的哈希。**这一重要概念使得区块链的不可变性成为可能**：如果攻击者篡改了链中的前序区块，**所有**的后续区块的哈希都是错的。

理解了吗？如果没有想明白，花点时间思考一下，这是区块链的核心思想。

### 在区块中添加交易信息

此外，还需要在区块中添加交易信息的方法。用 `new_transaction()` 方法来做这件事吧，代码写出来非常直观：

```
class Blockchain(object):
    ...
    
    def new_transaction(self, sender, recipient, amount):
        """
        Creates a new transaction to go into the next mined Block
        :param sender: <str> Address of the Sender
        :param recipient: <str> Address of the Recipient
        :param amount: <int> Amount
        :return: <int> The index of the Block that will hold this transaction
        """

        self.current_transactions.append({
            'sender': sender,
            'recipient': recipient,
            'amount': amount,
        })

        return self.last_block['index'] + 1
```

`new_transaction()` 在列表中添加新交易之后，会返回该交易被加到的区块的**索引**，也就是指向**下一个要挖的区块**。稍后会讲到这对于之后提交交易的用户会有用。

## 创建新区块

实例化 `Blockchain` 类之后，需要新建一个**创始区块**，它没有任何前序区块。此外还要在创始区块中加入**证明**，证明来自挖矿（或者工作量证明）。稍后再来讨论挖矿这件事。

除了要在构造函数中创建**创始区块**，我们还要实现  `new_block()`，`new_transaction()` 和 `hash()`。

```
import hashlib
import json
from time import time


class Blockchain(object):
    def __init__(self):
        self.current_transactions = []
        self.chain = []

        # Create the genesis block
        self.new_block(previous_hash=1, proof=100)

    def new_block(self, proof, previous_hash=None):
        """
        Create a new Block in the Blockchain
        :param proof: <int> The proof given by the Proof of Work algorithm
        :param previous_hash: (Optional) <str> Hash of previous Block
        :return: <dict> New Block
        """

        block = {
            'index': len(self.chain) + 1,
            'timestamp': time(),
            'transactions': self.current_transactions,
            'proof': proof,
            'previous_hash': previous_hash or self.hash(self.chain[-1]),
        }

        # Reset the current list of transactions
        self.current_transactions = []

        self.chain.append(block)
        return block

    def new_transaction(self, sender, recipient, amount):
        """
        Creates a new transaction to go into the next mined Block
        :param sender: <str> Address of the Sender
        :param recipient: <str> Address of the Recipient
        :param amount: <int> Amount
        :return: <int> The index of the Block that will hold this transaction
        """
        self.current_transactions.append({
            'sender': sender,
            'recipient': recipient,
            'amount': amount,
        })

        return self.last_block['index'] + 1

    @property
    def last_block(self):
        return self.chain[-1]

    @staticmethod
    def hash(block):
        """
        Creates a SHA-256 hash of a Block
        :param block: <dict> Block
        :return: <str>
        """

        # We must make sure that the Dictionary is Ordered, or we'll have inconsistent hashes
        block_string = json.dumps(block, sort_keys=True).encode()
        return hashlib.sha256(block_string).hexdigest()
```

上面的代码还是比较直观的，还有一些注释和文档字符串做进一步解释。这样就差不多可以表示区块链了。但是到了这一步，你一定好奇新区块是怎样被创建，锻造或者挖出来的。

### 理解工作量证明

工作量证明算法（PoW）表述了区块链中的新区块是如何创建或者挖出来的。PoW 的目的是寻找符合特定规则的数字。对网络中的任何人来说，从计算的角度上看，该数字必须**难以寻找，易于验证**。这是工作量证明算法背后的核心思想。

下面给出一个非常简单的例子来帮助理解。

不妨规定某整数 `x` 乘以另一个 `y` 的哈希必须以 `0`结尾。也就是 `hash(x * y) = ac23dc...0`。就这个例子而言，不妨将令 `x = 5`。Python 实现如下：

```
from hashlib import sha256
x = 5
y = 0  # We don't know what y should be yet...
while sha256(f'{x*y}'.encode()).hexdigest()[-1] != "0":
    y += 1
print(f'The solution is y = {y}')
```

解就是 `y = 21`。因为这样得到的哈希的结尾是 `0`：

```
hash(5 * 21) = 1253e9373e...5e3600155e860
```

比特币的工作量算法叫做 [`Hashcash`](https://en.wikipedia.org/wiki/Hashcash)。它和上面给出例子非常类似。矿工们争相求解这个算法以便创建新块。总体而言，难度大小取决于要在字符串中找到多少特定字符。矿工给出答案的报酬就是在交易中得到比特币。

而网络可以**轻松地**验证答案。

### 实现基本的工作量证明

接下来为我们的区块链实现一个类似的算法。规则和上面的例子类似：

> 寻找数字 `p`，当它和前一个区块的证明一起求哈希时，该哈希开头是四个 `0`。

```
import hashlib
import json

from time import time
from uuid import uuid4


class Blockchain(object):
    ...
        
    def proof_of_work(self, last_proof):
        """
        Simple Proof of Work Algorithm:
         - Find a number p' such that hash(pp') contains leading 4 zeroes, where p is the previous p'
         - p is the previous proof, and p' is the new proof
        :param last_proof: <int>
        :return: <int>
        """

        proof = 0
        while self.valid_proof(last_proof, proof) is False:
            proof += 1

        return proof

    @staticmethod
    def valid_proof(last_proof, proof):
        """
        Validates the Proof: Does hash(last_proof, proof) contain 4 leading zeroes?
        :param last_proof: <int> Previous Proof
        :param proof: <int> Current Proof
        :return: <bool> True if correct, False if not.
        """

        guess = f'{last_proof}{proof}'.encode()
        guess_hash = hashlib.sha256(guess).hexdigest()
        return guess_hash[:4] == "0000"
```

要调整算法的难度，直接修改要求的零的个数就行了。不过 4 个零足够了。你会发现哪怕多一个零都会让求解难度倍增。

类写得差不多了，可以用 HTTP 请求与之交互了。

## 第二步：将 Blockchain 用作 API

本文使用 Python Flask 框架。Flask 是一个微框架，易于将网络端点映射到 Python 函数。由此可以轻易地借助 HTTP 请求通过网络和区块链交互。

这里需要创建三个方法：

* `/transactions/new` 在区块中新增交易
* `/mine` 通知服务器开采新节点
* `/chain` 返回完整的区块链

### 开始 Flask 吧

这个服务器会构成区块链网络中的一个节点。下面是一些模板代码：

```
import hashlib
import json
from textwrap import dedent
from time import time
from uuid import uuid4

from flask import Flask


class Blockchain(object):
    ...


# Instantiate our Node
app = Flask(__name__)

# Generate a globally unique address for this node
node_identifier = str(uuid4()).replace('-', '')

# Instantiate the Blockchain
blockchain = Blockchain()


@app.route('/mine', methods=['GET'])
def mine():
    return "We'll mine a new Block"
  
@app.route('/transactions/new', methods=['POST'])
def new_transaction():
    return "We'll add a new transaction"

@app.route('/chain', methods=['GET'])
def full_chain():
    response = {
        'chain': blockchain.chain,
        'length': len(blockchain.chain),
    }
    return jsonify(response), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

稍微解释一下：

* **第 15 行:** 初始化节点。更多信息请阅读 [Flask 文档](http://flask.pocoo.org/docs/0.12/quickstart/#a-minimal-application)。
* **第 18 行:** 随机给节点起名。
* **第 21 行:** 初始化 `Blockchain` 类
* **第 24–26 行:** 创建 `/mine` 接口，使用 `GET` 方法。
* **第 28–30 行:** 创建 `/transactions/new` 接口，使用 `POST` 方法，因为要给它发数据。
* **第 32–38 行:** 创建 `/chain` 接口，它会返回整个区块链。
* **第 40–41 行:** 服务器运行在 5000 端口。

### 交易端

下面是交易请求的内容，也就是发给服务器的东西：

```
{
 "sender": "my address",
 "recipient": "someone else's address",
 "amount": 5
}
```

因为已经有类方法将交易加到区块中，剩下的就很简单了。写一个添加交易的函数：

```
import hashlib
import json
from textwrap import dedent
from time import time
from uuid import uuid4

from flask import Flask, jsonify, request

...

@app.route('/transactions/new', methods=['POST'])
def new_transaction():
    values = request.get_json()

    # Check that the required fields are in the POST'ed data
    required = ['sender', 'recipient', 'amount']
    if not all(k in values for k in required):
        return 'Missing values', 400

    # Create a new Transaction
    index = blockchain.new_transaction(values['sender'], values['recipient'], values['amount'])

    response = {'message': f'Transaction will be added to Block {index}'}
    return jsonify(response), 201
```

创建交易的方法

### 挖矿端

挖矿端是见证奇迹的地方。非常简单，只需要做三件事：

1. 计算工作量证明
2. 奖励矿工（这里就是我们），新增一次交易就赚一个币
3. 将区块加入链就可以构建新区块

```
import hashlib
import json

from time import time
from uuid import uuid4

from flask import Flask, jsonify, request

...

@app.route('/mine', methods=['GET'])
def mine():
    # We run the proof of work algorithm to get the next proof...
    last_block = blockchain.last_block
    last_proof = last_block['proof']
    proof = blockchain.proof_of_work(last_proof)

    # We must receive a reward for finding the proof.
    # The sender is "0" to signify that this node has mined a new coin.
    blockchain.new_transaction(
        sender="0",
        recipient=node_identifier,
        amount=1,
    )

    # Forge the new Block by adding it to the chain
    block = blockchain.new_block(proof)

    response = {
        'message': "New Block Forged",
        'index': block['index'],
        'transactions': block['transactions'],
        'proof': block['proof'],
        'previous_hash': block['previous_hash'],
    }
    return jsonify(response), 200
```

注意，挖出来区块的接受方就是节点的地址。这里做的事情基本上就是和 Blockchain 类的方法打交道。代码写到这里就差不多搞定了，下面可以和区块链进行交互了。

## 第三步：和 Blockchain 交互

可以用简洁又古老的 cURL 或者 Postman 来通过网络用 API 和区块链交互。

启动服务器：

```
$ python blockchain.py

* Running on [http://127.0.0.1:5000/](http://127.0.0.1:5000/) (Press CTRL+C to quit)
```

通过 `GET` 请求 `http://localhost:5000/mine` 尝试挖一块新区块。

![Using Postman to make a GET request](https://cdn-images-1.medium.com/max/800/1*ufYwRmWgQeA-Jxg0zgYLOA.png)

通过 `POST` 请求 `http://localhost:5000/transactions/new` 来创建新交易，POST 的数据要包含如下交易结构：

![Using Postman to make a POST request](https://cdn-images-1.medium.com/max/800/1*O89KNbEWj1vigMZ6VelHAg.png)

不用 Postman 的话还可以用等价的 cURL 命令：

```
$ curl -X POST -H "Content-Type: application/json" -d '{
 "sender": "d4ee26eee15148ee92c6cd394edd974e",
 "recipient": "someone-other-address",
 "amount": 5
}' "[http://localhost:5000/transactions/new](http://localhost:5000/transactions/new)"
```

重启服务器后，加上新挖出的两个区块，现在有了三个区块。通过请求 `http://localhost:5000/chain` 来查看全部区块链：

```
{
  "chain": [
    {
      "index": 1,
      "previous_hash": 1,
      "proof": 100,
      "timestamp": 1506280650.770839,
      "transactions": []
    },
    {
      "index": 2,
      "previous_hash": "c099bc...bfb7",
      "proof": 35293,
      "timestamp": 1506280664.717925,
      "transactions": [
        {
          "amount": 1,
          "recipient": "8bbcb347e0634905b0cac7955bae152b",
          "sender": "0"
        }
      ]
    },
    {
      "index": 3,
      "previous_hash": "eff91a...10f2",
      "proof": 35089,
      "timestamp": 1506280666.1086972,
      "transactions": [
        {
          "amount": 1,
          "recipient": "8bbcb347e0634905b0cac7955bae152b",
          "sender": "0"
        }
      ]
    }
  ],
  "length": 3
}
```

## 第四步：共识

非常酷对不对？我们已经构建了基本的区块链，不仅支持交易，还可以挖矿。但是区块链的核心是**去中心化**。但是如果要去中心化，怎么知道每个区块都在同一个链中呢？这就是**共识**问题，如果网络中不只这一个节点，必须实现共识算法。

### 注册新节点

在实现共识算法之前：我们需要让节点知道其所在的网络存在邻居节点。网络中的每一个节点都应该保存网络中其他节点的信息。所以要写几个新接口：

1. `/nodes/register` 接受新节点的列表，形式是 URL。
2. `/nodes/resolve` 来执行共识算法，解决所有冲突，确保节点的链是正确的

下面需要修改 Blockchain 类的构造函数，然后写一下注册节点的方法：

```
...
from urllib.parse import urlparse
...


class Blockchain(object):
    def __init__(self):
        ...
        self.nodes = set()
        ...

    def register_node(self, address):
        """
        Add a new node to the list of nodes
        :param address: <str> Address of node. Eg. 'http://192.168.0.5:5000'
        :return: None
        """

        parsed_url = urlparse(address)
        self.nodes.add(parsed_url.netloc)
```

在网络中注册邻居节点的方法

注意，这里使用了 `set()` 来保存节点列表。这是用来确保添加节点是幂等的的简单方法，也就是说不管某节点被添加了多少次，它只出现一次。

### 实现共识网络

上面提过，冲突就是一个节点的链和其他节点的不同。要解决冲突，我们制定了一个规则：**最长有效链即权威**。也就是说，网络中最长的链就是**事实上**正确的链。有了这个算法，就可以在网络中的多个节点中实现**共识**。

```
...
import requests


class Blockchain(object)
    ...
    
    def valid_chain(self, chain):
        """
        Determine if a given blockchain is valid
        :param chain: <list> A blockchain
        :return: <bool> True if valid, False if not
        """

        last_block = chain[0]
        current_index = 1

        while current_index < len(chain):
            block = chain[current_index]
            print(f'{last_block}')
            print(f'{block}')
            print("\n-----------\n")
            # Check that the hash of the block is correct
            if block['previous_hash'] != self.hash(last_block):
                return False

            # Check that the Proof of Work is correct
            if not self.valid_proof(last_block['proof'], block['proof']):
                return False

            last_block = block
            current_index += 1

        return True

    def resolve_conflicts(self):
        """
        This is our Consensus Algorithm, it resolves conflicts
        by replacing our chain with the longest one in the network.
        :return: <bool> True if our chain was replaced, False if not
        """

        neighbours = self.nodes
        new_chain = None

        # We're only looking for chains longer than ours
        max_length = len(self.chain)

        # Grab and verify the chains from all the nodes in our network
        for node in neighbours:
            response = requests.get(f'http://{node}/chain')

            if response.status_code == 200:
                length = response.json()['length']
                chain = response.json()['chain']

                # Check if the length is longer and the chain is valid
                if length > max_length and self.valid_chain(chain):
                    max_length = length
                    new_chain = chain

        # Replace our chain if we discovered a new, valid chain longer than ours
        if new_chain:
            self.chain = new_chain
            return True

        return False
```

第一个方法 `valid_chain()` 负责检查链的有效性，主要是通过遍历每个区块，验证哈希和工作量证明。

`resolve_conflicts()` 方法会遍历所有邻居节点，**下载**它们的链，用上面的方法来验证。**如果找到了有效链，而且长度比本地的要长，就替换掉本地的链**。

接下来将这两个接口注册到 API 中，一个用来新增邻居节点，另一个来解决冲突：

```
@app.route('/nodes/register', methods=['POST'])
def register_nodes():
    values = request.get_json()

    nodes = values.get('nodes')
    if nodes is None:
        return "Error: Please supply a valid list of nodes", 400

    for node in nodes:
        blockchain.register_node(node)

    response = {
        'message': 'New nodes have been added',
        'total_nodes': list(blockchain.nodes),
    }
    return jsonify(response), 201


@app.route('/nodes/resolve', methods=['GET'])
def consensus():
    replaced = blockchain.resolve_conflicts()

    if replaced:
        response = {
            'message': 'Our chain was replaced',
            'new_chain': blockchain.chain
        }
    else:
        response = {
            'message': 'Our chain is authoritative',
            'chain': blockchain.chain
        }

    return jsonify(response), 200
```

到这一步，如果你愿意，可以用另一台电脑，在网络中启动不同的节点。或者用同一台电脑的不同端口启动进程加入网络。我选择用同一个电脑的不同的端口注册新节点，这样就有了两个节点：`http://localhost:5000` 和 `http://localhost:5001`。

![Registering a new Node](https://cdn-images-1.medium.com/max/800/1*Dd78u-gmtwhQWHhPG3qMTQ.png)

我在 2 号节点挖出了新区块，保证 2 号节点的链更长。然后用 `GET` 调用 1 号节点的 `/nodes/resolve`，可以发现链被通过共识算法替换了：

![Consensus Algorithm at Work](https://cdn-images-1.medium.com/max/800/1*SGO5MWVf7GguIxfz6S8NVw.png)

这样子就差不多完工了。 叫一些朋友来一起试试你的区块链吧。

我希望这个教程可以激发你创建新东西的热情。我迷恋数字加密货币，因为我相信区块链技术会快速改变我们思考经济学，政府以及记录信息的方式。

**更新**：我打算接着写本文的第二部分，继续拓展本文实现的区块链以涵盖交易验证机制并讨论如何让区块链产品化。

> 如果你喜欢这个教程，或者有建议或疑问，欢迎评论。如果你发现了任何错误，欢迎在[这里](https://github.com/dvf/blockchain)为我们贡献代码!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
