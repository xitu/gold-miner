> * 原文地址：[Code your own blockchain mining algorithm in Go!](https://medium.com/@mycoralhealth/code-your-own-blockchain-mining-algorithm-in-go-82c6a71aba1f)
> * 原文作者：[Coral Health](https://medium.com/@mycoralhealth?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/code-your-own-blockchain-mining-algorithm-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/code-your-own-blockchain-mining-algorithm-in-go.md)
> * 译者：
> * 校对者：

# Code your own blockchain mining algorithm in Go!

![](https://cdn-images-1.medium.com/max/800/1*zwlWlWAwTRxaoKkds63rfQ.png)

_If you have any questions or comments about the following tutorial, make sure to join our_ [**_Telegram_**](https://t.me/joinchat/FX6A7UThIZ1WOUNirDS_Ew) _chat. Ask us anything!_

With all the recent craze in Bitcoin and Ethereum mining it’s easy to wonder what the fuss is all about. For newcomers to this space, they hear wild [stories](https://www.coindesk.com/inside-north-americas-8m-bitcoin-mining-operation/) of people filling up warehouses with GPUs making millions of dollars worth of cryptocurrencies a month. What exactly is cryptocurrency mining? How does it work? How can I try coding my own mining algorithm?

We’ll walk you through each of these questions in this post, culminating in a tutorial on how to code your own mining algorithm. The algorithm we’ll be showing you is called **Proof of Work**, which is the foundation to Bitcoin and Ethereum, the two most popular cryptocurrencies. Don’t worry, we’ll explain how that works shortly.

**What is cryptocurrency mining?**

Cryptocurrencies need to have scarcity in order to be valuable. If anyone could produce as many Bitcoin as they wanted at anytime, Bitcoin would be worthless as a currency (wait, doesn’t the Federal Reserve do this? *facepalm*). The Bitcoin algorithm releases some Bitcoin to a winning member of its network every 10 minutes, with a maximum supply to be reached in about 122 years. This release schedule also controls inflation to a certain extent, since the entire fixed supply isn’t released at the beginning. More are slowly released over time.

The process by which a winner is determined and given Bitcoin requires the winner to have done some “work”, and competed with others who were also doing the work. This process is called _mining_, because it’s analogous to a gold miner spending some time doing work and eventually (and hopefully) finding a bit of gold.

The Bitcoin algorithm forces participants, or nodes, to do this work and compete with each other to ensure Bitcoin aren’t released too quickly.

**How does mining work?**

A quick Google search of “how does bitcoin mining work?” fills your results with a multitude of pages explaining that Bitcoin mining asks a node (you, or your computer) to [_solve a hard math problem_](https://www.bitcoinmining.com/). While technically true, simply calling it a “math” problem is incredibly hand-wavy and hackneyed. How mining works under the hood is a lot of fun to understand. We’ll need to understand a bit of cryptography and hashing to learn how mining works.

**A brief introduction to cryptographic hashes**

_One-way cryptography_ takes in a human readable input like “Hello world” and applies a function to it (i.e. the math problem) to produce an indecipherable output. These functions (or algorithms) vary in nature and complexity. The more complicated the algorithm, the harder it is to reverse engineer. Thus, cryptographic algorithms are very powerful in securing things like user passwords and military codes.

Let’s take a look at an example of SHA-256, a popular cryptographic algorithm. This [hashing website](http://www.xorbin.com/tools/sha256-hash-calculator) lets you easily calculate SHA-256 hashes. Let’s hash “Hello world” and see what we get:

![](https://cdn-images-1.medium.com/max/800/1*_qWZ8MB6pKezY_76qPjEjA.png)

Try hashing “Hello world” over and over again. You get the same hash every time. In programming getting the same result again and again given the same input is called _idempotency_.

A fundamental property of cryptographic algorithms is that they should be extremely hard to reverse engineer to find the input, but extremely easy to verify the output. For example, using the SHA-256 hash above, it should be trivial for someone else to apply the SHA-256 hash algorithm to “Hello world” to check that it indeed produces the same resultant hash, but it should be _very hard_ to take the resultant hash and get “Hello world” from it. This is why this type of cryptography is called _one way_.

Bitcoin uses _Double SHA-256_, which is simply applying SHA-256 _again_ to the SHA-256 hash of “Hello world”. For our examples throughout this tutorial we’ll just use SHA-256.

**Mining**

Now that we understand what cryptography is, we can get back to cryptocurrency mining. Bitcoin needs to find some way to make participants who want to earn Bitcoin “work” so Bitcoins aren’t released too quickly. Bitcoin achieves this by making the participants hash many combinations of letters and numbers until the resulting hash contains a specific number of leading “0”s.

For example, go back to the [hash website](http://www.xorbin.com/tools/sha256-hash-calculator) and hash “886”. It produces a hash with 3 zeros as a prefix.

![](https://cdn-images-1.medium.com/max/800/1*5l3FgMIR5Gn_AUZ1X5mW9Q.png)

But how did we know that “886” produced something with 3 zeros? That’s the point. Before writing this blog, we _didn’t_. In theory, we would have had to work through a whole bunch combinations of letters and numbers and tested the results until we got one that matched the 3 zeros requirement. To give you a simple example, we already worked in advance to realize the hash of “886” produced 3 leading zeros.

The fact that anyone can easily check that “886” produces something with 3 leading zeros **proves** that we did the grunt work of testing and checking a large combination of letters and numbers to get to this result. So if I’m the first one who got this result, I would have earned the Bitcoin by _proving_ I did this work — the proof is that anyone can quickly check that “886” produces the number of zeros I claim it does. This is why the Bitcoin consensus algorithm is called **Proof-of-Work**.

But what if I just got lucky and I got the 3 leading zeros on my first try? This is extremely unlikely and the occasional node that successfully mines a block (proves that they did the work) on their first try is outweighed by millions of others who had to work extra to find the desired hash. Go ahead and try it. Type in any other combination of letters and numbers in the hash website. We bet you won’t get 3 leading zeros.

Bitcoin’s requirements are a bit more complex than this (many more leading zeros!) and it is able to adjust the requirements dynamically to make sure the work required isn’t too easy or too hard. Remember, it aims to release Bitcoin every 10 minutes so if too many people are mining, it needs to make the proof of work harder to compensate. This is called _adjusting the difficulty_. For our purposes, adjusting the difficulty will just mean requiring more leading zeros.

So you can see the Bitcoin consensus algorithm is much more interesting than just “solving a math problem”!

### **Enough background. Let’s get coding!**

Now that we have the background we need, let’s build our own Blockchain program with a Proof-of-Work algorithm. We’ll write it in Go because we use it here at Coral Health and frankly, it’s [awesome](https://hackernoon.com/5-reasons-why-we-switched-from-python-to-go-4414d5f42690).

**Before proceeding, we recommend reading our original blog post,** [**Code your own blockchain in less than 200 lines of Go!**](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc) **It’s not a requirement but some of the examples below we’ll be running through quickly. Refer to the original post if you need more detail. If you’re already familiar with this original post, skip to the “Proof of Work” section below.**

**Architecture**

![](https://cdn-images-1.medium.com/max/800/1*z0fgOU0iYm7Pjc5Zn5nCjA.png)

We’ll have a Go server, where for simplicity we’ll put all our code in a single `main.go` file. This file will provide us all the blockchain logic we need (including Proof of Work) and will contain all the handlers for our REST APIs. This blockchain data is immutable; we only need `GET` and `POST` requests. We’ll make requests through the browser to view the data through `GET` and we’ll use [Postman](https://www.getpostman.com/apps) to `POST` new blocks (`curl` works fine too).

**Imports**

Let’s start with our standard imports. Make sure to grab the following packages with `go get`

`github.com/davecgh/go-spew/spew` pretty prints your blockchain in Terminal

`github.com/gorilla/mux` a convenience layer for wiring up your web server

`github.com/joho/godotenv` read your environmental variables from a `.env` file in your root directory

Let’s create a `.env` file in our root directory that just stores one environment variable that we’ll need later. Put one line in your `.env` file:`ADDR=8080`

Make your package declaration and define your imports in `main.go` in your root directory:

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

If you read our [original article](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc), you’ll remember this diagram. Blocks in a blockchain are verified by comparing the _previous hash_ in a block against the _hash_ of the previous block. This is how the integrity of the blockchain is preserved and how a malicious party can’t change the history of the blockchain.

![](https://cdn-images-1.medium.com/max/800/1*VwT5d8NPjUpI7HiwPa--cQ.png)

`BPM` is your pulse rate, or beats per minute. We’ll be using the beats per minute of your pulse as the data we put in our blocks. Just put two fingers on the inside of your wrist and count how many times you get a beat in a minute, and remember this number.

**Some basic plumbing**

Let’s add our data model and other variables we’ll need under our imports in `main.go`

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

`difficulty` is a constant that defines the number of 0s we want leading the hash. The more zeros we have to get, the harder it is to find the correct hash. We’ll just start with 1 zero.

`Block` is the data model of each block. Don’t worry about `Nonce`, we’ll explain that shortly.

`Blockchain` is a slice of `Block` which represents our full chain.

`Message` is what we’ll send in to generate a new `Block` using a `POST` request in our REST API.

We’re declaring a `mutex` that we’ll use later to prevent data races and make sure blocks aren’t generated at the same time.

**Web server**

Let’s quickly wire up our web server. Let’s create a `run` function that we’ll call from `main` later that scaffolds our server. We’ll also declare our routes handlers in `makeMuxRouter()`. Remember, all we need are `GET` to retrieve the blockchain, and `POST` to add new blocks. Blockchains are immutable so we don’t need to edit or delete.

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

The `httpAddr := os.Getenv("ADDR")` will pull port `:8080` from our `.env` file we created earlier. We’ll be able to access our app through `[http://localhost:8080](http://localhost:8080)` in our browser.

Let’s write our `GET` handler to print our blockchain to our browser. We’ll also add a quick `respondwithJSON` function that gives us back error messages in JSON format if any of our API calls produces an error.

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

_Remember, if we’re going a bit too quickly, please refer to our_ [_original post_](https://medium.com/@mycoralhealth/code-your-own-blockchain-in-less-than-200-lines-of-go-e296282bcffc) _that explains each of these steps in more detail._

Now we write our `POST` handler. This is how we add new blocks. We make a `POST` request using Postman by sending a JSON body e.g.`{“BPM”:60}`to `[http://localhost:8080](http://localhost:8080)` with your pulse rate you took earlier.

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

Note the `mutex` lock and unlock. We need to lock it before writing a new block, or else multiple writes will create a data race. The perceptive reader will notice the `generateBlock` function. This is our key function that will handle our Proof of Work. We’ll get to it shortly.

**Basic blockchain functions**

Let’s wire up our basic blockchain functions before we hit Proof of Work. We’ll add a `isBlockValid` function that makes sure our indices are incrementing correctly and our `PrevHash` of our current block and `Hash` of the previous block match.

We’ll also add a `calculateHash` function that generates the hashes we need to create `Hash` and `PrevHash`. This is just a SHA-256 hash of our concatenated index, timestamp, BPM, previous hash and `Nonce` (we’ll explain what that is in a second).

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

### Proof of Work

Let’s get to the mining algorithm, or Proof of Work. We want to make sure the Proof of Work is complete before we’ll allow a new `Block` to get added to the `blockchain`. Let’s start off with a simple function that checks if the hash generated during our Proof of Work meets the requirements we set out.

Our requirements will be as follows:

*   The hash that is generated by our Proof of Work must start with a specific number of zeros
*   The number of zeros is determined by the constant `difficulty` that we defined at the start of our program (in our case, 1)
*   We can make the Proof of Work harder to solve by increasing the difficulty

Write up this function, `isHashValid`:

```
func isHashValid(hash string, difficulty int) bool {
        prefix := strings.Repeat("0", difficulty)
        return strings.HasPrefix(hash, prefix)
}
```

Go provides convenient `Repeat` and `HasPrefix` functions in its `strings` package. We define the variable `prefix` as a repeat of zeros defined by our `difficulty`. Then we check if the hash starts with those zeros and return `True` if it does and `False` if it doesn’t.

Now let’s create our `generateBlock` function.

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

We create a `newBlock` that takes the hash of the previous block and puts it in `PrevHash` to make sure we have continuity in our blockchain. Most of the other fields should be apparent:

*   `Index` increments
*   `Timestamp` is the string representation of the current time
*   `BPM` is your pulse rate you took earlier
*   `Difficulty` is simply taken from the constant at the top of our program. We won’t use this field in this tutorial but it’s useful to have if we’re doing further verification and we want to make sure the difficulty is consistent with the hash results (i.e. the hash result has N prefixed zeros so Difficulty should also equal N, or the chain is compromised)

The `for` loop is the critical piece in this function. Let’s walk through what’s happening here:

*   We’ll take the hex representation of `i` and set `Nonce` equal to it. We need a way to append a changing value to our hash that we create from our `calculateHash` function so if we don’t get the leading number of zeros we want, we can try again with a new value. **This changing value we add to our concatenated string in** `**calculateHash**` **is called a “Nonce”**
*   In our loop, we calculate the hash with `i` and Nonce starting at 0 and check if the result starts with the number of zeros as defined by our constant `difficulty`. If it doesn’t, we invoke the next iteration of the loop with an incremented Nonce and try again.
*   We added a 1 second sleeper to simulate taking some time to solve the Proof of Work
*   We keep looping until we get the number of leading zeros we want, which means we’ve successfully completed our Proof of Work. Then and only then do we allow our `Block` to get added to `blockchain` via our `handleWriteBlock` handler

We’re done writing all our functions so let’s complete our `main` function now:

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

With `godotenv.Load()` we load up our environment variable, which is just the `:8080` port we’ll access from our browser.

A go routine creates our genesis block since we need to supply our blockchain with a starting point.

We fire up our web server with our `run()` function we created earlier.

### We’re done! Time to take it for a spin!

Here’s the finished code in full.

- [**mycoralhealth/blockchain-tutorial**: blockchain-tutorial - Write and publish your own blockchain in less than 200 lines of Go_github.com](https://github.com/mycoralhealth/blockchain-tutorial/blob/master/proof-work/main.go)

Let’s give this baby a try!

Start up your program with `go run main.go`

Then visit `[http://localhost:8080](http://localhost:8080)` in your browser:

![](https://cdn-images-1.medium.com/max/800/1*8QVgGXKcpEzib3aK0tGjVw.png)

Our genesis block has been created for us. Now open Postman and let’s send a `POST` request to the same route with our BPM (pulse rate) we took earlier in a JSON body.

![](https://cdn-images-1.medium.com/max/800/1*U9MUVrllrqzfV3Sy68QsAg.png)

After we send the request **watch what’s happening in your terminal**. You’ll see your machine chugging away creating new hashes with incrementing Nonce values until it finally finds a result that has the required number of leading zeros!

![](https://cdn-images-1.medium.com/max/800/1*FaQhDF1kr8N4f9tua4zGZQ.png)

When the Proof of Work is solved we get a helpful message saying `work done!` and we can check the hash to see that it indeed starts with the number of zeros we set in `difficulty`. This means that in theory, the new block we tried to add with BPM = 60 should now have been added to our blockchain.

Let’s refresh our browser and check:

![](https://cdn-images-1.medium.com/max/800/1*rVBUxrpTcl-zvarqs0K96Q.png)

**SUCCESS!** Our second block has been added to our genesis block. This means we successfully sent our block in a `POST` request, which triggered the mining process and ONLY when the Proof of Work was solved did it get added to our blockchain!

### Next steps

Great job! What you just learned is a really big deal. Proof of Work is the foundation to Bitcoin, Ethereum and many of the biggest blockchain platforms around. What we just went through is not trivial; while we used a low difficulty for demonstration purposes, increasing the difficulty to a high number is **exactly** how production-ready Proof of Work blockchains work.

Now that you intimately understand a key component of blockchain technology, where you go from here is up to you. We recommend the following:

*   Learn how blockchain networking works in our [Networking tutorial](https://medium.com/@mycoralhealth/part-2-networking-code-your-own-blockchain-in-less-than-200-lines-of-go-17fe1dad46e1)
*   Learn how to store large files in a distributed manner and communicate with the blockchain in our [IPFS tutorial](https://medium.com/@mycoralhealth/learn-to-securely-share-files-on-the-blockchain-with-ipfs-219ee47df54c)

If you’re ready to take another leap, try learning about _Proof of Stake_. While most blockchains use Proof of Work as their consensus algorithm, Proof of Stake is gaining more and more attention. It is widely believed that Ethereum will be migrating away from Proof of Work to Proof of Stake in the future.

**Want to see a tutorial on Proof of Work vs. Proof of Stake? See any bugs in the code above? Love what we’re doing? Hate what we’re doing?**

### **Let us know by** [**joining our Telegram chat**](https://t.me/joinchat/FX6A7UThIZ1WOUNirDS_Ew)**! You’ll have a blast engaging with the authors of this tutorial and the rest of the Coral Health team!**

To learn more about Coral Health and how we’re using the blockchain to advance personalized medicine research, visit our [website](https://mycoralhealth.com/).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
