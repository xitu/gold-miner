
  > * 原文地址：[Why context.Value matters and how to improve it](https://blog.merovius.de/2017/08/14/why-context-value-matters-and-how-to-improve-it.html)
  > * 原文作者：[Axel Wagner](https://twitter.com/TheMerovius)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-context-value-matters-and-how-to-improve-it.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-context-value-matters-and-how-to-improve-it.md)
  > * 译者：[星辰](https://www.zhihu.com/people/tmpbook)
  > * 校对者：[lsvih](https://github.com/lsvih)，[leviding](https://github.com/leviding)

  # 为什么 context.Value 重要，如何进行改进

  **觉得文章太长可以看这里：我认为 context.Value 解决了描写无状态这个重要用例 - 而且它的抽象还是可扩展的。我相信 [dynamic scoping](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping) 可以提供同样的好处，同时解决对当前实现的大多数争议。 因此，我将试图从其具体实施到它的潜在问题进行讨论。**

**这篇博文有点长。我建议你跳过你觉得无聊的部分**

---

最近[这篇博文](https://faiface.github.io/post/context-should-go-away-go2/)已经在几个 Go 论坛上被探讨过。它提出了几个很好的论据来反对 [context-package](https://godoc.org/context)：

- 即使有一些中间函数没有用到它，但它依然要求这些函数包含 `context.Context`。这引起了 API 的混乱的同时还需要广泛的深入修改 API，比如，`ctx context.Context` 会在入参中重复出现多次。
- `context.Value` 不是静态类型安全的，总是需要类型断言。
- 它不允许你静态地表达关于上下文内容的关键依赖。
- 由于需要全局命名空间，它容易出现名称冲突。
- 这是一个以链表形式实现的字典，因此效率很低。

然而，在对 context 被设计来**解决**的问题的探讨中，我认为它做的不够好，它主要探讨的是取消机制，而对于 `Context.Value` 只进行了简单的说明。

> […] 设计你的 API，而不考虑 ctx.Value，可以让你永远有选择的余地。

我认为这个问题提的很不公正。想要关于 context.Value 的论证是理性的，需要双方都参与进来考虑。无论你对当前 API 的看法如何：经验丰富且智慧的工程师们在郑重思考后觉得 `Context.Value` 是需要的，这意味着这个问题值得被关注。

我将尝试描述我对 content 包在尝试解决什么样的问题的看法，目前存在哪些替代方案，以及为什么我找到了它们的不足之处，同时我正在为一种未来的语言演进描述一种替代设计。它将解决相同的问题，同时避免一些学习 content 包时的负面影响。但这并不是意味着它将会是 Go 2 的一个具体方案（我在这的考虑还为时过早），只是为了表现一种平衡的观点，使得语言设计界有更多可能，更容易考虑到全部可能。

---

这些 context 要去解决的问题是将问题抽象为独立执行的、由系统的不同部分处理的单元，以及如何将数据作用域应用到这些单元的某一个上。很难清楚的定义我说的这些抽象，所以我会给出一些例子。

- 当你构建一个可扩展的 web 服务时，你可能会有一个为你做一些类似认证、权鉴和解析等的无状态前端服务。它允许你轻松的扩展外部接口，如果负载增加到后端不能承受，也可以直接在前端优雅的拒绝。
- [微服务](https://en.wikipedia.org/wiki/Microservices)将大型应用分成小的个体分别来处理每个特定的请求，拆分出更多的请求到其它微服务里面。这些请求通常是独立的，可以根据需求轻松的将各个微服务上下的扩展，从而在实例之间进行负载均衡，并解决[透明代理](https://istio.io/)中的一些问题。
- [函数及服务](https://en.wikipedia.org/wiki/Serverless_computing)走的更远一步：你编写一个无状态的方法来转换数据，平台使其可扩展并更效率的执行。 
- 甚至[CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes)，Go 内置的并发模型也可以体现这一方式。即程序员执行单独的『进程』来描述他的问题，运行时则会更效率的执行它。
- [函数式程序设计](https://en.wikipedia.org/wiki/Functional_programming)作为一种范型。函数结果只依赖于入参的这一概念意味着不存在共享态和独立执行。
- 这个 Go 的 [Request Oriented Collector](https://docs.google.com/document/d/1gCsFxXamW8RRvOe5hECz98Ftk-tcRRJcDFANj2VwCB0/edit) 设计也有着完全相同的猜想和理论。

所有这些情况的想法都是想通过减少共享状态的同时保持资源的共享来增加扩展性（无论是分布在机器之间，线程之间或者只是代码中）。

Go 采取了一个措施来靠近这个特性。但它不会像某些函数式编程语言那样禁止或者阻碍可变状态。它允许在线程之间共享内存并与互斥体进行同步，而不完全依赖于通道。但是它也绝对想成为一种（或**唯一**）编写现代可扩展服务的语言。因此，它**需要**成为一种很好的语言来编写无状态的服务，它需要至少在一定程度上能够达到**请求**隔离级别而不是进程隔离。

**（附注：这似乎是上述文章作者的声明，他声称上下文主要对服务作者有用。我不同意。一般抽象发生在很多层面。比如 GUI 的一次点击就像这个请求的抽象一样，作为一个 HTTP 请求。）**

这带来了能在请求级别存储一些数据的需求。一个简单的例子就是[RPC 框架](https://grpc.io)中的身份验证。不同的请求将具有不同的功能。如果一个请求来自于管理员，它应该比未认证用户拥有更高的权限。这是从根本上的**请求作用域**内的数据而不是过程，服务或者应用作用域。RPC 框架应该将这些数据视为不透明的。它是应用程序特指的，不仅是数据看起来有多详细，还有**什么样**的数据是需要的。

就像一个 HTTP 代理或者框架不需要知道它不适用的请求参数和头一样，RPC 框架不应该知道应用程序所需要的请求作用域的数据。

---

让我们来试试在不引入上下文的情况下解决（可能）这个问题，例如，我们来看看编写 HTTP 中间件的问题。我们希望以装饰一个 [http.Handler](https://godoc.org/net/http#Handler)（或其变体）的方式来允许装饰器附加数据给请求。

为了获得静态类型安全性，我们可以试着添加一些类型给我们的 handlers。我们可以有一个包含我们想要保留请求作用域内所有数据的类型，并通过我们的 handler 传递：

```go
type Data struct {
    Username string
    Log *log.Logger
    // …
}

func HandleA(d Data, res http.ResponseWriter, req *http.Request) {
    // …
    d.Username = "admin"
    HandleB(d, req, res)
    // …
}

func HandleB(d Data, res http.ResponseWriter, req *http.Request) {
    // …
}
```

但是，这将阻止我们编写可重用的中间件。任何这样的中间件都需要用 `HandleA` 包好。但是因为它将是可重用的，所以它不应该知道参数的类型。有可以将 `Data` 参数设置为 `interface{}` 类型，并需要类型断言。但这不允许中间件注入自己的数据。你可能觉得接口类型断言可以解决这个问题，但是它们还有[它们自己的一堆问题](https://blog.merovius.de/2017/07/30/the-trouble-with-optional-interfaces.html)没解决。所以结果是，这种方法不能带给你真正的类型安全。

我们可以存储由请求键入的状态。例如身份验证中间件可以实现

```
type Authenticator struct {
    mu sync.Mutex
    users map[*http.Request]string
    wrapped http.Handler
}

func (a *Authenticator) ServeHTTP(res http.ResponseWriter, req *http.Request) {
    // …
    a.mu.Lock()
    a.users[req] = "admin"
    a.mu.Unlock()
    defer func() {
        a.mu.Lock()
        delete(a.users, req)
        a.mu.Unlock()
    }()
    a.wrapped.ServeHTTP(res, req)
}

func (a *Authenticator) Username(req *http.Request) string {
    a.mu.Lock()
    defer a.mu.Unlock()
    return a.users[req]
}
```

这与上下文相比有**一些**好处：

- 它更加类型安全。
- 虽然我们还是不能对认证用户表达要求，但是我们**能**对认证者表达要求。
- 这样不太可能命名冲突了。

然而，我们已经认同它的共享可变状态和相关的锁争用。如果其中一个中间处理程序决定创建一个新的请求，那么可以使用一种很微妙的方式破解，比如 [http.StripPrefix](https://github.com/golang/go/blob/816deacc70f48d14638104e284b3b75d5b1e8036/src/net/http/server.go#L1946) 将要做的那样。

最后我们可能会考虑将这些数据存储在 [*http.Request](https://godoc.org/net/http#Request) 本身中，例如通过将其添加为字符串的 [URL parameter](https://godoc.org/net/url#URL.RawQuery)，但这也有几个缺点。事实上，它基本检测到了 `context.Context` 的每个单独 item 的缺点。表达式是一个链表。即使有那样的优点，它的线程安全也无法忽略，如果该请求被传递给不同的 goroutine 中的程序处理，我们会遇到麻烦。

**（附注：所有的这一切也使我们了解了为什么 context 包被使用链表的方式实现。它允许存储在其中的所有数据都是只读的，因此肯定线程安全，在上下文中保存的共享状态永远不会出现锁争用，因为压根不需要锁。）**


所以我们看到，解决这个问题是非常困难的（如果可以解决），实现在独立执行的处理程序附加数据给请求时，也是优于 `context.Value` 的。无论是否相信这个问题值得解决，它都是有争议的。但是**如果**你想获得这种可扩展的抽象，你将不得不依赖于类似于 `context.Value` 的**东西**。

---

无论你现在相信 `context.Value` 确实无用，或者你仍有疑虑：在这两种情况下，这些缺点显然都不能被忽略。但是我们可以试着找到一些方法去改进它。消除一些缺点，同时保持其有用的属性。

一种方法（在 Go 2 中）将是引入[动态作用域](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping)变量。语义上，每个动态作用域变量表示一个单独的栈，每次你改变它的值，新的值被推入栈。在你方法返回之后它会再次出栈。比如：

```go
// 让我们创造点语法，只一点点哦。
dyn x = 23

func Foo() {
    fmt.Println("Foo:", x)
}

func Bar() {
    fmt.Println("Bar:", x)
    x = 42
    fmt.Println("Bar:", x)
    Baz()
    fmt.Println("Bar:", x)
}

func Baz() {
    fmt.Println("Baz:", x)
    x = 1337
    fmt.Println("Baz:", x)
}

func main() {
    fmt.Println("main:", x)
    Foo()
    Bar()
    Baz()
    fmt.Println("main:", x)
}

// 输出：
main: 23
Foo: 23
Bar: 23
Bar: 42
Baz: 42
Baz: 1337
Bar: 42
Baz: 23
Baz: 1337
main: 23
```

我想到这里的语义有一些需要注意的地方。

- 我只允许在包的作用域声明 `dyn` 这个类型。鉴于没有办法引用不同功能的本地标识符，这似乎是合乎逻辑的。
- 新产生的 goroutine 将会继承其父方法的动态值。如果我们通过链表实现它（像 `context.Context` 一样），共享的数据将是只读的。头指针需要储存在某种类型的 goroutine-local 的存储中。这样，写入只会修改此本地存储（和全局堆），因此不需要特意的同步本次修改。
- 动态作用域将会独立于声明变量的包。也就是说，如果 `foo.A` 修改了一个动态的 `bar.X`，那么这个修改对后来的 `foo.A` 的被调用者都是不可见的，不管它们是否在 `bar` 内。
- 动态作用域的变量不可寻址。否则我们会松动并发安全性和动态作用域界定的清晰『入栈』语义。不过仍然可以声明 `dyn x *int` 来让可变状态传递。
- 编译器将为栈分配必要的内存，初始化到它们的初始化器，并发出必要的指令，以便在写入和返回时 push 和 pop 值。为了对 panic 和过早的返回有个交代，需要类似 `defer` 的机制。
- 这个设计和包作用域有一些令人迷惑的重叠。最值得注意的是，从 `foo.X = Y` 来看，你无法判断 `foo.X` 是否有动态作用域。就我个人而言，我会通过从语言中移除包作用域变量来解决此问题。它们仍然可以通过声明一个动态作用域指针，而不修改它来模仿。那么它的指针就是一个共享变量。但是，大多数包作用域变量的用法就仅仅是使用动态作用域变量。

将此设计同 `context` 的一系列缺点进行比较是很有启发性的。

- 避免了 API 的杂乱，因为请求作用域的数据现在将成为语言的一部分，而不需要明确的传递。
- 动态区域变量是静态类型安全的。每个 `dyn` 声明都有一个明确的类型。
- 仍然不可能对动态作用域变量表达关键的依赖关系。但也不能**没有**。最糟糕的，它们会有零值。
- 命名冲突被消除。标识符就像变量名一样，标识符有恰当的作用域。
- 简单的实现任然非链表莫属，并不会很低效。每个 `dyn` 声明都有它自己的链，只有头指针需要被操作。
- 这个设计在一定程度上仍然很『魔幻』。但是『魔幻』是固有问题（至少如果我正确的理解批评的话）。魔法就是通过 API 边界透明地传递价值的一种可能性。

最后，我想提一下取消机制。索然在上述文章中，作者提到了很多关于取消机制的内容，但我迄今为止都忽略了它。那是因为我相信取消机制在好的 `context.Value` 实现之上是可以实现的。比如：

```
// $GOROOT/src/done
package done

// 当当前执行的上下文（比如请求）被取消时，C 被关闭。
dyn C <-chan struct{}

// 当 C 被关闭或者取消被调用时，CancelFunc 返回一个关闭的通道。
func CancelFunc() (c <-chan struct, cancel func()) {
    // 我们不能在这改变 C，应为它的作用域是动态的，这就是为什么我们返回一个调用者应该储存的新通道。
    ch := make(chan struct)

    var o sync.Once
    cancel = func() { o.Do(close(ch)) }
    if C != nil {
        go func() {
            <-C
            cancel()
        }()
    }
    return ch, cancel
}

// $GOPATH/example.com/foo
package foo

func Foo() {
    var cancel func()
    done.C, cancel = done.CancelFunc()
    defer cancel()
    // Do things
}
```

这种取消机制现在可以从任何想要的库中使用，而不需要确认其 API 明确支持。这让它可以很简单的追加取消的能力。

---

无论你喜不喜欢这个设计，至少我们不应该急于要求删除 `context` 包。删除它只是一种可能解决它缺点的方法之一。

如果移除 `context.Context` 的这一天真的来了，我们应该问的问题是『我们是否想要有一个规范的方法去管理请求作用域的值，其代价又是什么』。只有这样我们才能开始探讨最佳实现会是什么样的，或者是否移除它。


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  