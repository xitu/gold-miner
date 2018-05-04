> * 原文地址：[Code your own blockchain in less than 200 lines of Go!](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc)
> * 原文作者：[Coral Health](https://medium.com/@mycoralhealth?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/code-your-own-blockchain-in-less-than-200-lines-of-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/code-your-own-blockchain-in-less-than-200-lines-of-go.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH)、[https://github.com/SergeyChang](SergeyChang)

# 用不到 200 行的 GO 语言编写您自己的区块链

![](https://cdn-images-1.medium.com/max/800/1*Elzguv8ycXYcphhD7M95hQ.jpeg)

**如果这不是您第一次读本文，请阅读第 2 部分 —— **[**这里**](https://medium.com/@mycoralhealth/part-2-networking-code-your-own-blockchain-in-less-than-200-lines-of-go-17fe1dad46e1)**！**

本教程改编自这篇关于使用 JavaScript 编写基础区块链的优秀[文章](https://medium.com/@lhartikk/a-blockchain-in-200-lines-of-code-963cc1cc0e54)。我们已经将其移植到 Go 并添加了一些额外的好处 -- 比如在 Web 浏览器上查看您的区块链。如果您对下面的教程有任何疑问，请务必加入我们的  [**Telegram**](https://t.me/joinchat/FX6A7UThIZ1WOUNirDS_Ew)。可向我们咨询任何问题！

本教程中的数据示例将基于您的休息心跳。毕竟我们是一家医疗保健公司 :-) 为了有趣，记录您一分钟的[脉搏数](https://www.webmd.com/heart-disease/heart-failure/watching-rate-monitor#1)（每分钟的节拍）并记住这个数值。  

世界上几乎每个开发者都听说过区块链，但大多数仍然不知道它的工作原理。他们可能仅仅是因为比特币才知道它，又或者是因为他们听说过智能合约之类的东西。这篇文章试图通过帮助您用 Go 编写自己的简单区块链，使用少于 200 行代码来揭开区块链的神秘面纱！到本教程结束时，您将能够编写并在本地运行您自己的区块链，以及在 Web 浏览器中查看它。 

还有什么比通过创建自己的区块链来了解区块链更好的方法呢？

**您将能够做什么**

*   创建您自己的区块链
*   了解 hash 如何维护区块链的完整性
*   了解如何添加新块
*   了解当多个节点生成块时，tiebreakers 如何解决
*   在 web 浏览器中查看区块链
*   写新的块
*   获取区块链的基础知识，以便您可以决定您的旅程将从这里走向何处！

**您不能做的事**

为了保持本文的简单性，我们不会处理更高级的共识概念，比如工作证明和利害关系证明。为了让您查看您的区块链和区块的添加，我们将模拟网络交互，但网络广播作为文章的深度将被保留。

### **让我们开始吧！**

**准备工作**

 既然我们决定用 Go 编写代码，我们假设您已经有了一些 Go 方面的经验，在[安装](https://golang.org/dl/)并配置 Go 之后，我们还需要获取以下软件包：

`go get github.com/davecgh/go-spew/spew`

**Spew** 允许我们在控制台中查看格式清晰的 `structs` 和 `slices`，您值得拥有。

`go get github.com/gorilla/mux`

**Gorilla/mux** 是编写 Web 程序处理的常用包。我们将会使用它。

`go get github.com/joho/godotenv`

**Gotdotenv** 允许我们从根目录中读取 `.env` 文件，这样就不必对 HTTP 端口之类的内容进行硬编码。我们也需要这个。

我们在根目录中创建 `.env` 文件，定义为 http 请求提供服务的端口。只需要该文件添加一行：

`ADDR=8080`

创建 `main.go` 文件。从现在开始，所有的内容都会写进这个文件中，并且将用少于 200 代码进行编码。

**导入**

这是我们需要导入的以及包声明，我们把它们写入 `main.go`

```go
package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/davecgh/go-spew/spew"
	"github.com/gorilla/mux"
	"github.com/joho/godotenv"
)
```

**数据模型**

我们将定义组成区块链的每个块的 `struct` 。别担心，我们会在一分钟内结束所有这些字段的含义。

```go
type Block struct {
	Index     int
	Timestamp string
	BPM       int
	Hash      string
	PrevHash  string
}
```

每个 `Block`  都包含将被写入区块链的数据，并表示当您获取脉搏率时的每一种情况（还记得您在文章的开头就这样做了么？）。

*   `Index` 是数据记录在区块链中的位置
*   `Timestamp` 是自动确定写入数据的时间
*   `BPM` 每分钟节拍数，是您的脉搏率
*   `Hash` 是表示此数据记录的 SHA256 标识符
*   `PrevHash` 是链中上一条记录的 SHA256 标识符

我们也对区块链本身建模，它只是 `Block` 中的 `slice`:

```go
var Blockchain []Block
```

那么散列如何适合于块和区块链呢？我们使用散列表来识别和保持块的正确顺序。通过确保每个 `Block` 中的 `PrevHash` 与前面 `Block` 块中的 `Hash` 相同，我们知道组成链的块的正确顺序。

![](https://cdn-images-1.medium.com/max/800/1*VwT5d8NPjUpI7HiwPa--cQ.png)

**散列和生成新块**

那我们为什么需要散列呢？我们散列数据的两个主要原因：

*   为了节省空间。散列从块上的所有数据派生。在我们的示例中，我们只有几个数据点，但是假设我们有来自数百、数千或者数百万以前的数据块的数据。将数据散列到单个 SHA256 字符串或**散列这些散列表**中要比一遍又一遍地复制前面块中的所有数据高效得多。
*   保护区块链的完整性。通过存储前面的散列，就像我们在上面的图中所做的那样，我们能够确保区块链中的块是按正确的顺序排列的。如果恶意的一方试图操纵数据（例如，改变我们的心率来确定人寿保险的价格），散列将迅速改变，链将“断裂”，每个人都会知道也不再信任这个恶意链。 

让我们编写一个函数，该函数接受 `Block` 数据并创建 i 的 SHA256 散列值。 

```go

func calculateHash(block Block) string {
	record := string(block.Index) + block.Timestamp + string(block.BPM) + block.PrevHash
	h := sha256.New()
	h.Write([]byte(record))
	hashed := h.Sum(nil)
	return hex.EncodeToString(hashed)
}
```

这个 `calculateHash` 函数将 `Block` 的 `Index`、`Timestamp`、`BPM`，我们提供块的 `PrevHash` 链接为一个参数，并以字符串的形式返回 SHA256 散列。现在我们可以用一个新的 `generateBlock` 函数来生成一个包含我们所需的所有元素的新块。我们需要提供它前面的块，以便我们可以得到它的散列以及在 BPM 中的脉搏率。不要担心传入 `BPM int` 参数。我们稍后再讨论这个问题。  

```go
func generateBlock(oldBlock Block, BPM int) (Block, error) {

	var newBlock Block

	t := time.Now()

	newBlock.Index = oldBlock.Index + 1
	newBlock.Timestamp = t.String()
	newBlock.BPM = BPM
	newBlock.PrevHash = oldBlock.Hash
	newBlock.Hash = calculateHash(newBlock)

	return newBlock, nil
}
```

注意当前时间使用 `time.Now()` 自动写入块中的。还请注意，我们之前的 `calculateHash` 函数是被调用的。从上一个块的散列复制到 `PrevHash`。`Index` 从上一个块的索引中递增。

**块校验**

我们需要编写一些函数来确保这些块没有被篡改。我们还通过检查 `Index` 来实现这一点，以确保它们按预期的速度递增。我们还将检查以确保我们的 `PrevHash` 与前一个块的 `Hash` 相同。最后，我们希望通过在当前块上再次运行 `calculateHash` 函数来重新检查当前块的散列。让我们编写一个 `isBlockValid`  函数，它执行所有这些操作并返回一个 `bool`。如果它通过了我们所有的检查，它就会返回  `true`：

```go
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
```

如果我们遇到这样一个问题，即区块链生态系统的两个节点都向它们的链添加了区块，并且我们都收到了它们。我们选择哪一个作为真理的来源？我们选择最长的链条。这是一个经典的区块链问题，与邪恶的演员没有任何关系。

两个有意义的节点可能只是具有不同的链长，因此很自然地，较长的节点将是最新的，并且拥有最新的块。因此，让我们确保我们正在接受的新链要比我们现有的链长。如果是，我们可以用具有新块的新链覆盖我们的链。

![](https://cdn-images-1.medium.com/max/800/1*H1fCp0NLun0Kn0wIy0dyEA.png)

为了实现这一点，我们简单地比较了链片的长度：

```go
func replaceChain(newBlocks []Block) {
	if len(newBlocks) > len(Blockchain) {
		Blockchain = newBlocks
	}
}
```

如果您已经坚持做到这里，就鼓励一下自己！基本上，我们已经用我们需要的各种函数编写了区块链的内部结构。

现在，我们想要一个方便的方式来查看我们的区块链，并写入它，理想情况下是我们可以在一个网络浏览器显示我们的朋友！

**Web 服务器**

我们假设您已经熟悉 Web 服务器的工作方式，并有一些将它们连接到 Go 中的经验。我们现在就带你走一遍这个流程。

我们将使用您之前下载的 [Gorilla/mux](https://github.com/gorilla/mux) 包来为我们完成繁重的任务。

我们在稍后调用的 `run` 函数中创建服务器。

```go
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
```

注意我们选择的端口来自之前创建的 `.env` 文件。我们使用 `log.Println` 为自己提供一个实时的控制台消息来让我们的服务器启动并运行。我们对武器进行了一些配置，然后对 `ListenAndServe` 进行配置。很标准的 Go。

现在我们需要编写 `makeMuxRouter` 函数，该函数将定义所有的处理程序。要在浏览器中查看并写入我们的区块链，我们只需要两个路由，我们将保持它们的简单性。如果我们发送一个 `GET` 请求到 `localhost`，我们将查看到区块链。如果我们发送一 `POST` 请求，我们可以进行写入。

```go
func makeMuxRouter() http.Handler {
	muxRouter := mux.NewRouter()
	muxRouter.HandleFunc("/", handleGetBlockchain).Methods("GET")
	muxRouter.HandleFunc("/", handleWriteBlock).Methods("POST")
	return muxRouter
}
```

这是我们的 `GET` 处理器。

```go
func handleGetBlockchain(w http.ResponseWriter, r *http.Request) {
	bytes, err := json.MarshalIndent(Blockchain, "", "  ")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	io.WriteString(w, string(bytes))
}
```

我们只需以 JSON 格式回写完整的的区块链，就可以通过访问 `localhost:8080` 在任意浏览器中能够查看。我们在 `.env` 文件中将 `ADDR` 变量设置为 8080，如果您更改它，请确保访问您的正确端口。

我们的 `POST` 请求有些复杂（复杂情况并不多）。首先，我们需要一个新的 `Message` `struct`。稍后我们会解释为什么我们需要它。

```go
type Message struct {
	BPM int
}
```

下面是编写新块的处理程序的代码。您看完后我们会带您再看一遍。

```go
func handleWriteBlock(w http.ResponseWriter, r *http.Request) {
	var m Message

	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&m); err != nil {
		respondWithJSON(w, r, http.StatusBadRequest, r.Body)
		return
	}
	defer r.Body.Close()

	newBlock, err := generateBlock(Blockchain[len(Blockchain)-1], m.BPM)
	if err != nil {
		respondWithJSON(w, r, http.StatusInternalServerError, m)
		return
	}
	if isBlockValid(newBlock, Blockchain[len(Blockchain)-1]) {
		newBlockchain := append(Blockchain, newBlock)
		replaceChain(newBlockchain)
		spew.Dump(Blockchain)
	}

	respondWithJSON(w, r, http.StatusCreated, newBlock)

}
```

使用独立 `Message` 结构的原因是接收 JSON POST 请求的请求体，我们将使用它来编写新的块。这允许我们简单地发送带有以下主体的 POST 请求，我们的处理程序将为我们填充该块的其余部分：

`{"BPM":50}`

`50` 是一个以每分钟为单位的脉搏频率的例子。用一个整数值来改变您的脉搏率。 

在将请求体解码成 `var m Message` 结构后，通过传入前一个块并将新的脉冲率传递到前面编写的 `generateBlock` 函数中来创建一个新块。这就是函数创建新块所需的全部内容。我们使用之前创建的 `isBlockValid` 函数，快速检查以确保新块是正常的。 

**一些笔记**

*   `_spew.Dump_` **是一个方便的函数，它可以将我们的结构打印到控制台上。这对调试很有用。**
*    **对于测试 POST 请求，我们喜欢使用** [**Postman**](https://www.getpostman.com/apps)**。`curl`** 效果也很好，如果您不能离开终端的话。

当我们的 POST 请求成功或者失败时，我们希望得到相应的通知。我们使用了一个小包装器函数  `respondWithJSON` 来让我们知道发生了什么。记住，在 Go 中，千万不要忽略它们。[要优雅地处理它们](https://dave.cheney.net/2016/04/27/dont-just-check-errors-handle-them-gracefully)。

```go
func respondWithJSON(w http.ResponseWriter, r *http.Request, code int, payload interface{}) {
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
**快要完成了！**

让我们将所有不同的区块链函数、Web 处理程序和 Web 服务器链接在一个简短、干净的 `main` 函数中：

```go
func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal(err)
	}

	go func() {
		t := time.Now()
		genesisBlock := Block{0, t.String(), 0, "", ""}
		spew.Dump(genesisBlock)
		Blockchain = append(Blockchain, genesisBlock)
	}()
	log.Fatal(run())

}
```

这是怎么回事？

*   `godotenv.Load()` 允许我们从根目录中的 `.env` 文件中读取像端口号这样的变量，这样我们就不必在整个应用程序中对它们进行硬编码（恶心！）。
*   `genesisBlock` 是 `main` 函数中最重要的部分。我们需要为我们的区块链提供一个初始区块，否则新区块将无法将其先前的散列与任何东西比较，因为先前的散列并不存在。
*   我们将初始块隔离到它自己的 Go 例程中，这样我们就可以将关注点从我们的区块链逻辑和 Web 服务器逻辑中分离出来。但它只是以这种没有 Go 例程情况下作更优雅的方式工作。

### **太好了！我们完成了！**

以下是全部代码：

- [**mycoralhealth/blockchain-tutorial**: 区块链-教程 —— 用少于 200 行的 Go 编写并发布您自己的区块链 **github.com**](https://github.com/mycoralhealth/blockchain-tutorial/blob/master/main.go)

**现在来讨论下有趣的事情**。让我们试一下 :-)

使用 `go run main.go` 从终端启动应用程序

在终端中，我们看到 Web 服务器已经启动并运行，我们得到了我们的初始块的打印输出。

![](https://cdn-images-1.medium.com/max/800/1*sAkFOcjHxX9WnjGPud84rQ.png)

现在使用您的端口号来访问 `localhost`，对我们来说是 8080。不出所料，我们看到了相同的初始块。 

![](https://cdn-images-1.medium.com/max/800/1*4HRKAkMy1smgB9xpGLj6RA.png)

现在，让我们发送一些 POST 请求来添加块。使用 Postman，我们将添加一些具有不同 BPM 的新块。

![](https://cdn-images-1.medium.com/max/800/1*eYfFp1lqJUiAS1S6K8ZHbQ.png)

让我们刷新一下浏览器。瞧，我们现在看到链中的所有新块都带有新块的 `PrevHash`与旧块的 `Hash` 相匹配，正如我们预期的那样！

![](https://cdn-images-1.medium.com/max/800/1*Qo4eZ0hQ1gMdXrsvBGSnxg.png)

**下一步**

恭喜！您只是用适当的散列和块验证来编写自己的块链。现在您应该能够控制自己的区块链之旅，并探索更复杂的主题，如工作证明、利益证明、智能合约、Dapp、侧链等等。 

本教程没有讨论的是如何使用工作证明来挖掘新的块。这将是一个单纯的教程，但大量的区块链存在，没有证明工作机制。此外，目前通过在 Web 服务器中写入和查看区块链来模拟广播。本教程中没有 P2P 组件。

如果您想我们添加诸如工作证明和人际关系之类的内容，请务必在我们的 [**Telegram**](https://t.me/joinchat/FX6A7UThIZ1WOUNirDS_Ew) 中告诉我们，并关注我们的 [**Twitter**](https://twitter.com/myCoralHealth)！这是和我们沟通的最好的方式。问我们问题，给出反馈，并建议新教程。我们很想听听您的意见。

### 通过大众需求，我们增加了本教程的后续内容！看看它们！

*   [**区块链网络**](https://medium.com/@mycoralhealth/part-2-networking-code-your-own-blockchain-in-less-than-200-lines-of-go-17fe1dad46e1)。
*   [**编码您自己的区块链挖掘算法！**](https://medium.com/@mycoralhealth/code-your-own-blockchain-mining-algorithm-in-go-82c6a71aba1f)
*   [**了解如何使用 ipfs，通过区块链存储数据。**](https://medium.com/@mycoralhealth/learn-to-securely-share-files-on-the-blockchain-with-ipfs-219ee47df54c)
*   [**编写您自己的树桩算法证明！**](https://medium.com/@mycoralhealth/code-your-own-proof-of-stake-blockchain-in-go-610cd99aa658)

想了解更多关于珊瑚健康的信息，以及我们如何使用区块链来推进个性化用药/治疗研究，请访问我们的[网站](https://mycoralhealth.com/)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
