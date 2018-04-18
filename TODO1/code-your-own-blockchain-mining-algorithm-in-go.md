> * 原文地址：[Code your own blockchain mining algorithm in Go!](https://medium.com/@mycoralhealth/code-your-own-blockchain-mining-algorithm-in-go-82c6a71aba1f)
> * 原文作者：[Coral Health](https://medium.com/@mycoralhealth?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/code-your-own-blockchain-mining-algorithm-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/code-your-own-blockchain-mining-algorithm-in-go.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[stormluke](https://github.com/stormluke)，[mingxing47](https://github.com/mingxing47)

# 用 Go 编写你自己的区块链挖矿算法！

![](https://cdn-images-1.medium.com/max/800/1*zwlWlWAwTRxaoKkds63rfQ.png)

**如果你对下面的教程有任何问题或者建议，加入我们的** [*Telegram*](https://t.me/joinchat/FX6A7UThIZ1WOUNirDS_Ew) **消息群，可以问我们所有你想问的！**

随着最近比特币和以太坊挖矿大火，很容易让人好奇，这么大惊小怪是为什么。对于加入这个领域的新人，他们会听到一些疯狂的[故事](https://www.coindesk.com/inside-north-americas-8m-bitcoin-mining-operation/)：人们用 GPU 填满仓库，每个月赚取价值数百万美元的加密货币。电子货币挖矿到底是什么？它是如何运作的？我如何能试着编写自己的挖矿算法？

在这篇博客中，我们将会带你解答上述每一个问题，并最终完成一篇教你如何编写自己的挖矿算法的教程。我们将展示给你的算法叫做**工作量证明**，它是比特币和以太坊这两个最流行的电子货币的基础。别急，我们马上将为你解释它是如何运作的。

**什么是电子货币挖矿**

为了有价值，电子货币需要有一定的稀缺性。如果谁都可以随时生产出他们想要的任意多的比特币，那么作为货币，比特币就毫无价值了。（等一下，美国联邦储备不是这么做了么？*打脸*）比特币算法每十分钟将会发放一些比特币给网络中一个获胜成员，这样最多可以供给大约 122 年。由于定量的供应并不是在最一开始就全部发行，这种发行时间表在一定程度上也控制了膨胀。随着时间流逝，发行地速度将越来越慢。

决定胜者是谁并给出比特币的过程需要他完成一定的“工作”，并与同时也在做这个工作的人竞争。这个过程就叫做**挖矿**，因为它很像采矿工人花费时间完成工作并最终（希望）找到黄金。

比特币算法要求参与者，或者说节点，完成工作并相互竞争，来保证比特币不会发行过快。

**挖矿是如何运作的？**

一次谷歌快速搜索“比特币挖矿如何运作？”将会给你很多页的答案，解释说比特币挖矿要求节点（你或者说你的电脑）[**解决一个很难的数学问题**](https://www.bitcoinmining.com/)。虽然从技术上来说这是对的，但是简单的把它称为一个“数学”问题太过有失实质并且太过陈腐。了解挖矿运作的内在原理是非常有趣的。为了学习挖矿运作原理，我们首先要了解一下加密算法和哈希。

**哈希加密的简短介绍**

**单向加密**的输入值是能读懂的明文，像是“Hello world”，并施加一个函数在它上面（也就是，数学问题）生成一个不可读的输出。这些函数（或者说算法）的性质和复杂度各有不同。算法越复杂，逆运算解密就越困难。因此，加密算法能有力保护像用户密码和军事代码这类事物。

让我们来看一个 SHA-256 的例子，它是一个很流行的加密算法。这个[哈希网站](http://www.xorbin.com/tools/sha256-hash-calculator)能让你轻松计算 SHA-256 哈希值。让我们对“Hello world”做哈希运算来看看将会得到什么：

![](https://cdn-images-1.medium.com/max/800/1*_qWZ8MB6pKezY_76qPjEjA.png)

试试对“Hello world”重复做哈希运算。你每次都将会得到同样的哈希值。给定一个程序相同的输入，反复计算将会得到相同的结果，这叫做幂等性。

加密算法一个基本的属性就是（输出值）靠逆运算很难推算输入值，但是（靠输入值）很容易就能验证输出值。例如，用上述的 SHA-256 哈希算法，其他人将 SHA-256 哈希算法应用于“Hello world”很容易的就能验证它确实输出同一个哈希值结果，但是想从这个哈希值结果推算出“Hello world”将会**非常困难**。这就是为什么这类算法被称为**单向**。

比特币采用 **双 SHA-256** 算法，这个算法就是简单的将 SHA-256 **再一次**应用于“Hello world”的 SHA-256 哈希值。在这篇教程中，我们将只应用 SHA-256 算法。

**挖矿**

现在我们知道了加密算法是什么了，我们可以回到加密货币挖矿的问题上。比特币需要找到某种方法，让希望得到比特币参与者“工作”，这样比特币就不会发行的过快。比特币的实现方式是：让参与者不停地做包含数字和字母的哈希运算，直到找到那个以特定位数的“0”开头的哈希结果。

例如，回到[哈希网站](http://www.xorbin.com/tools/sha256-hash-calculator)然后对“886”做哈希运算。它将生成一个前缀包含三个零的哈希值。

![](https://cdn-images-1.medium.com/max/800/1*5l3FgMIR5Gn_AUZ1X5mW9Q.png)

但是，我们怎么知道 “886” 能得出一个开头三个零的结果呢？这就是关键点了。在写这篇博客之前，我们**不知道**。理论上，我们需要遍历所有数字和字母的组合、测试结果，直到得到一个能够匹配我们需求的三个零开头的结果。给你举一个简单的例子，我们其实已经预先做了计算，发现 “886” 的哈希值是三个零开头的。

任何人都可以很轻松的验证 “886” 的哈希结果是三个零前缀，这个事实**证明了**：我做了大量的工作来对很多字母和数字的组合进行测试和检查以获得这个结果。所以，如果我是第一个得到这个结果的人，我就能通过**证明**我做了工作来得到比特币 - 证据就是任何人都能轻松验证 “886” 的哈希结果为三零前缀，正如我宣称的那样。这就是为什么比特币共识算法被称为**工作量证明**。

但是如果我很幸运，我第一次尝试就得到了三零前缀的结果呢？这几乎是不可能的，并且那些偶然情况下第一次就成功挖到了区块（证明他们做了工作）的节点会被那些做了额外工作来找到合适的哈希值的成千上万的其他区块所压倒。试试看，在计算哈希的网站上输入任意其他的字母和数字的组合。我打赌你不会得到一个三零开头的结果。

比特币的需求要比这个复杂很多（更多个零的前缀！），并且能够通过动态调节需求来确保工作不会太难也不会太容易。记住，目标是每十分钟发行一次比特币，所以如果太多人在挖矿，就需要将工作量证明调整的更难完成。这就叫**难度调节（adjusting the difficulty）**。为了达成我们的目的，难度调整就意味着需求更多的零前缀。

现在你就知道了，比特币共识机制比单纯的“解决一个数学问题”要有意思的多！

### **足够多背景介绍了。我们开始编程吧！**

现在我们已经有了足够多的背景知识，让我们用工作量共识算法来建立自己的比特币程序。我们将会用 Go 语言来写，因为我们在 Coral Health 中使用它，并且说实话，[棒极了](https://hackernoon.com/5-reasons-why-we-switched-from-python-to-go-4414d5f42690)。

**开始下一步之前，我建议读者读一下我们之前的博文，**[**Code your own blockchain in less than 200 lines of Go!**](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc)。**并不是硬性需求，但是下面的例子中我们将讲的比较粗略。如果你需要更多细节，可以参考之前的博客。如果你对前面这篇很熟悉了，直接跳到下面的“工作量证明”章节。**

**结构**

![](https://cdn-images-1.medium.com/max/800/1*z0fgOU0iYm7Pjc5Zn5nCjA.png)

我们将有一个 Go 服务，我们就简单的把所有代码就放在一个 `main.go` 文件中。这个文件将会提供给我们所需的所有的区块链逻辑（包括工作量证明算法），并包括所有 REST 接口的处理函数。区块链数据是不可改的，我们只需要 `GET` 和 `POST` 请求。我们将用浏览器发送 `GET` 请求来观察数据，并使用 [Postman](https://www.getpostman.com/apps) 来发送 `POST` 请求给新区块（`curl` 也同样好用）。

**引包**

我们从标准的引入操作开始。确保使用 `go get` 来获取如下的包

`github.com/davecgh/go-spew/spew` 在终端漂亮地打印出你的区块链

`github.com/gorilla/mux` 一个使用方便的层，用来连接你的 web 服务

`github.com/joho/godotenv` 在根目录的 `.env` 文件中读取你的环境变量

让我们在根目录下创建一个 `.env` 文件，它仅包含一个我们一会儿将会用到的环境变量。在 `.env` 文件中写一行：`ADDR=8080`。

对包作出声明，并在根目录的 `main.go` 定义引入：

```
package main

import (
        "crypto/sha256"
        "encoding/hex"
        "encoding/json"
        "fmt"
        "io"
        "log"
        "net/http"
        "os"
        "strconv"
        "strings"
        "sync"
        "time"

        "github.com/davecgh/go-spew/spew"
        "github.com/gorilla/mux"
        "github.com/joho/godotenv"
)
```

如果你读了[在此之前的文章](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc)，你应该记得这个图。区块链中的区块可以通过比较区块的 **previous hash** 属性值和前一个区块的哈希值来被验证。这就是区块链保护自身完整性的方式以及黑客组织无法修改区块链历史记录的原因。

![](https://cdn-images-1.medium.com/max/800/1*VwT5d8NPjUpI7HiwPa--cQ.png)

`BPM` 是你的心率，也就是一分钟心跳次数。我们将会用一分钟内你的心跳次数作为我们放到区块链中的数据。把两个手指放到手腕数一数一分钟脉搏内跳动的次数，记住这个数字。

**一些基础探测**

让我们来添加一些在引入后将会需要的数据模型和其他变量到 `main.go` 文件

```
const difficulty = 1

type Block struct {
        Index      int
        Timestamp  string
        BPM        int
        Hash       string
        PrevHash   string
        Difficulty int
        Nonce      string
}

var Blockchain []Block

type Message struct {
        BPM int
}

var mutex = &sync.Mutex{}
```

`difficulty` 是一个常数，定义了我们希望哈希结果的零前缀数目。需要得到越多的零，找到正确的哈希输入就越难。我们就从一个零开始。

`Block` 是每一个区块的数据模型。别担心不懂 `Nonce`，我们稍后会解释。

`Blockchain` 是一系列的 `Block`，表示完整的链。

`Message` 是我们在 REST 接口用 `POST` 请求传送进来的、用以生成一个新的 `Block` 的信息。

我们声明一个稍后将会用到的 `mutex` 来防止数据竞争，保证在同一个时间点不会产生多个区块。

**Web 服务**

让我们快速连接好网络服务。创建一个 `run` 函数，稍后在 `main` 中调用他来支撑服务。还需要在 `makeMuxRouter()` 中声明路由处理函数。记住，我们只需要用 `GET` 方法来追溯区块链内容， `POST` 方法来创建区块。区块链不可修改，所以我们不需要修改和删除操作。

```
func run() error {
        mux := makeMuxRouter()
        httpAddr := os.Getenv("ADDR")
        log.Println("Listening on ", os.Getenv("ADDR"))
        s := &http.Server{
                Addr:           ":" + httpAddr,
                Handler:        mux,
                ReadTimeout:    10 * time.Second,
                WriteTimeout:   10 * time.Second,
                MaxHeaderBytes: 1 << 20,
        }

        if err := s.ListenAndServe(); err != nil {
                return err
        }

        return nil
}

func makeMuxRouter() http.Handler {
        muxRouter := mux.NewRouter()
        muxRouter.HandleFunc("/", handleGetBlockchain).Methods("GET")
        muxRouter.HandleFunc("/", handleWriteBlock).Methods("POST")
        return muxRouter
}
```

`httpAddr := os.Getenv("ADDR")` 将会从刚才我们创建的 `.env` 文件中拉取端口 `:8080`。我们就可以通过访问浏览器的 `[http://localhost:8080](http://localhost:8080)` 来访问应用。

让我们写 `GET` 处理函数来在浏览器上打印出区块链。我们也将会添加一个简易 `respondwithJSON` 函数，它会在调用接口发生错误的时候，以 JSON 格式反馈给我们错误消息。

```
func handleGetBlockchain(w http.ResponseWriter, r *http.Request) {
        bytes, err := json.MarshalIndent(Blockchain, "", "  ")
        if err != nil {
                http.Error(w, err.Error(), http.StatusInternalServerError)
                return
        }
        io.WriteString(w, string(bytes))
}

func respondWithJSON(w http.ResponseWriter, r *http.Request, code int, payload interface{}) {
        w.Header().Set("Content-Type", "application/json")
        response, err := json.MarshalIndent(payload, "", "  ")
        if err != nil {
                w.WriteHeader(http.StatusInternalServerError)
                w.Write([]byte("HTTP 500: Internal Server Error"))
                return
        }
        w.WriteHeader(code)
        w.Write(response)
}
```

**记住，如果觉得这部分讲解太过粗略，请参考[在此之前的文章](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc)，这里更详细的解释了这部分的每个步骤。**

现在来写 `POST` 处理函数。这个函数就是我们添加新区块的方法。我们用 Postman 发送一个 `POST` 请求，发送一个 JSON 的 body，比如 `{“BPM”:60}`，到 `[http://localhost:8080](http://localhost:8080)`，并且携带你之前测得的你的心率。

```
func handleWriteBlock(w http.ResponseWriter, r *http.Request) {
        w.Header().Set("Content-Type", "application/json")
        var m Message

        decoder := json.NewDecoder(r.Body)
        if err := decoder.Decode(&m); err != nil {
                respondWithJSON(w, r, http.StatusBadRequest, r.Body)
                return
        }   
        defer r.Body.Close()

        //ensure atomicity when creating new block
        mutex.Lock()
        newBlock := generateBlock(Blockchain[len(Blockchain)-1], m.BPM)
        mutex.Unlock()

        if isBlockValid(newBlock, Blockchain[len(Blockchain)-1]) {
                Blockchain = append(Blockchain, newBlock)
                spew.Dump(Blockchain)
        }   

        respondWithJSON(w, r, http.StatusCreated, newBlock)

}
```

注意到 `mutex` 的 lock（加锁） 和 unlock（解锁）。在写入一个新的区块之前，需要给区块链加锁，否则多个写入将会导致数据竞争。精明的读者还会注意到 `generateBlock` 函数。这是处理工作量证明的关键函数。我们稍后讲解这个。

**基本的区块链函数**

在开始工作量证明算法之前，我们先将基本的区块链函数连接起来。我们将会添加一个 `isBlockValid` 函数，来保证索引正确递增以及当前区块的 `PrevHash` 和前一区块的 `Hash` 值是匹配的。

我们也要添加一个 `calculateHash` 函数，生成我们需要用来创建 `Hash` 和 `PrevHash` 的哈希值。它就是一个索引、时间戳、BPM、前一区块哈希和 `Nonce` 的 SHA-256 哈希值（我们稍后将会解释它是什么）。

```
func isBlockValid(newBlock, oldBlock Block) bool {
        if oldBlock.Index+1 != newBlock.Index {
                return false
        }

        if oldBlock.Hash != newBlock.PrevHash {
                return false
        }

        if calculateHash(newBlock) != newBlock.Hash {
                return false
        }

        return true
}

func calculateHash(block Block) string {
        record := strconv.Itoa(block.Index) + block.Timestamp + strconv.Itoa(block.BPM) + block.PrevHash + block.Nonce
        h := sha256.New()
        h.Write([]byte(record))
        hashed := h.Sum(nil)
        return hex.EncodeToString(hashed)
}
```

### 工作量证明

让我们来看挖矿算法，或者说工作量证明。我们希望确保工作量证明算法在允许一个新的区块 `Block` 添加到区块链 `blockchain` 之前就已经完成了。我们从一个简单的函数开始，这个函数可以检查在工作量证明算法中生成的哈希值是否满足我们设置的要求。

我们的要求如下所示：

*   工作量证明算法生成的哈希值必须要以某个特定个数的零开始
*   零的个数由常数 `difficulty` 决定，它在程序的一开始定义（在示例中，它是 1）
*   我们可以通过增加难度值让工作量证明算法变得困难

完成下面这个函数，`isHashValid`：

```
func isHashValid(hash string, difficulty int) bool {
        prefix := strings.Repeat("0", difficulty)
        return strings.HasPrefix(hash, prefix)
}
```

Go 在它的 `strings` 包里提供了方便的 `Repeat` 和 `HasPrefix` 函数。我们定义变量 `prefix` 作为我们在 `difficulty` 定义的零的拷贝。下面我们对哈希值进行验证，看是否以这些零开头，如果是返回 `True` 否则返回 `False`。

现在我们创建 `generateBlock` 函数。

```
func generateBlock(oldBlock Block, BPM int) Block {
        var newBlock Block

        t := time.Now()

        newBlock.Index = oldBlock.Index + 1
        newBlock.Timestamp = t.String()
        newBlock.BPM = BPM
        newBlock.PrevHash = oldBlock.Hash
        newBlock.Difficulty = difficulty

        for i := 0; ; i++ {
                hex := fmt.Sprintf("%x", i)
                newBlock.Nonce = hex
                if !isHashValid(calculateHash(newBlock), newBlock.Difficulty) {
                        fmt.Println(calculateHash(newBlock), " do more work!")
                        time.Sleep(time.Second)
                        continue
                } else {
                        fmt.Println(calculateHash(newBlock), " work done!")
                        newBlock.Hash = calculateHash(newBlock)
                        break
                }

        }
        return newBlock
}
```

我们创建了一个 `newBlock` 并将前一个区块的哈希值放在 `PrevHash` 属性里，确保区块链的连续性。其他属性的值就很明了了：

*   `Index` 增量
*   `Timestamp` 是代表了当前时间的字符串
*   `BPM` 是之前你记录下的心率
*   `Difficulty` 就直接从程序一开始的常量中获取。在本篇教程中我们将不会使用这个属性，但是如果我们需要做进一步的验证并且确认难度值对哈希结果固定不变（也就是哈希结果以 N 个零开始那么难度值就应该也等于 N，否则区块链就是受到了破坏），它就很有用了。

`for` 循环是这个函数中关键的部分。我们来详细看看这里做了什么：

*   我们将设置 `Nonce` 等于 `i` 的十六进制表示。我们需要一个为函数 `calculateHash` 生成的哈希值添加一个变化的值的方法，这样如果我们没能获取到我们期望的零前缀树木，我们就能用一个新的值重新尝试。**这个我们加入到拼接的字符串中的变化的值** `**calculateHash**` **就被称为“Nonce”**
*   在循环里，我们用 `i` 和以 0 开始的 Nonce 计算哈希值，并检查结果是否以常量 `difficulty` 定义的零数目开头。如果不是，我们用一个增量 Nonce 开始下一轮循环做再次尝试。
*   我们添加了一个一秒钟的延迟来模拟解决工作量证明算法的时间
*   我们一直循环计算直到我们得到了我们想要的零前缀，这就意味着我们成功的完成了工作量证明。当且仅当这之后才允许我们的 `Block` 通过 `handleWriteBlock` 处理函数被添加到 `blockchain`。

我们已经写完了所有函数，现在我们来完成 `main` 函数：

```
func main() {
        err := godotenv.Load()
        if err != nil {
                log.Fatal(err)
        }   

        go func() {
                t := time.Now()
                genesisBlock := Block{}
                genesisBlock = Block{0, t.String(), 0, calculateHash(genesisBlock), "", difficulty, ""} 
                spew.Dump(genesisBlock)

                mutex.Lock()
                Blockchain = append(Blockchain, genesisBlock)
                mutex.Unlock()
        }() 
        log.Fatal(run())

}
```

我们使用 `godotenv.Load()` 函数加载环境变量，也就是用来在浏览器访问的 `:8080` 端口。

一个 go routine 创建了创世区块，因为我们需要它作为区块链的起始点

我们用刚才创建的 `run()` 函数开始网络服务。

## 完成了！是时候运行它了！

这里有完整的代码。

- [**mycoralhealth/blockchain-tutorial**: blockchain-tutorial - Write and publish your own blockchain in less than 200 lines of Go_github.com](https://github.com/mycoralhealth/blockchain-tutorial/blob/master/proof-work/main.go)

让我们试着运行这个宝宝！

用 `go run main.go` 来开始程序

然后用浏览器访问 `[http://localhost:8080](http://localhost:8080)`：

![](https://cdn-images-1.medium.com/max/800/1*8QVgGXKcpEzib3aK0tGjVw.png)

创世区块已经为我们创建好。现在打开 Postman 然后发送一个 `POST` 请求，向同一个路由以 JSON 格式在 body 中发送之前测定的心率值。

![](https://cdn-images-1.medium.com/max/800/1*U9MUVrllrqzfV3Sy68QsAg.png)

发送请求之后，**在终端看看发生了什么**。你将会看到你的机器忙着用增加 Nonce 值不停创建新的哈希值，直到它找到了需要的零前缀值。

![](https://cdn-images-1.medium.com/max/800/1*FaQhDF1kr8N4f9tua4zGZQ.png)

当工作量证明算法完成了，我们就会得到一条很有用的 `work done!` 消息，我们就可以去检验哈希值来看看它是不是真的以我们设置的 `difficulty` 个零开头。这意味着理论上，那个我们试图添加 BPM = 60 信息的新区块已经被加入到我们的区块链中了。

我们来刷新浏览器并查看：

![](https://cdn-images-1.medium.com/max/800/1*rVBUxrpTcl-zvarqs0K96Q.png)

**成功了**！我们的第二个区块已经被加入到创世区块之后。这意味着我们成功的在 `POST` 请求中发送了区块，这个请求触发了挖矿的过程，并且当且仅当工作量证明算法完成后，它才会被添加到区块链中。

### 接下来

很棒！刚才你学到的真的很重要。工作量证明算法是比特币，以太坊以及其他很多大型区块链平台的基础。我们刚才学到的并非小事；虽然我们在示例中使用了一个很低的 difficulty 值，但是将它增加到一个比较大的值**就正是**生产环境下区块链工作量证明算法是如何运作的。

现在你已经清楚了解了区块链技术的核心部分，接下来如何学习将取决于你。我向你推荐如下资源：

*   在我们的 [Networking tutorial](https://medium.com/@mycoralhealth/part-2-networking-code-your-own-blockchain-in-less-than-200-lines-of-go-17fe1dad46e1) 教程中学习联网区块链如何工作。
*   在我们的 [IPFS tutorial](https://medium.com/@mycoralhealth/learn-to-securely-share-files-on-the-blockchain-with-ipfs-219ee47df54c) 教程中学习如何以分布式存储大型文件并用区块链通信。

如果你做好准备做另一次技术上的跳跃，试着学习 **股权证明（Proof of Stake）** 算法。虽然大多数的区块链使用工作量证明算法作为共识算法，股权证明算法正获得越来越多的关注。很多人相信以太坊将来会从工作量证明算法切换到股权证明算法。

**想看关于工作量证明算法和股权证明算法的比较教程？在上面的代码中发现了错误？喜欢我们做的事？讨厌我们做的事？**

### **通过** [**加入我们的 Telegram 消息群**](https://t.me/joinchat/FX6A7UThIZ1WOUNirDS_Ew) **让我们知道你的想法**！你将得到本教程作者以及 Coral Health 团队其他成员的热情应答。

想要了解更多关于 Coral Health 以及我们如何使用区块链来改进个人医药研究，访问我们的[网站](https://mycoralhealth.com/)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
