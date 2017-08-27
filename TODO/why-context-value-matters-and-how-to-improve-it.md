
  > * 原文地址：[Why context.Value matters and how to improve it](https://blog.merovius.de/2017/08/14/why-context-value-matters-and-how-to-improve-it.html)
  > * 原文作者：[Axel Wagner](https://twitter.com/TheMerovius)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-context-value-matters-and-how-to-improve-it.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-context-value-matters-and-how-to-improve-it.md)
  > * 译者：[星辰](https://www.zhihu.com/people/tmpbook)
  > * 校对者：

  # Why context.Value matters and how to improve it
  # 为什么 context.Value 重要，如何改进

  **tl;dr: I think context.Value solves the important use case of writing stateless - and thus scalable - abstractions. I believe [dynamic scoping](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping) could provide the same benefits while solving most of the criticism of the current implementation. I thus try to steer the discussion away from the concrete implementation and towards the underlying problem.**
  **觉得文章太长可以看这里：我认为 context.Value 解决了描写无状态这个重要用例 - 而且它的抽象还是可扩展的。 我相信[dynamic scoping](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping)可以提供同样的好处，同时解决对当前实现的大多数争议。 因此，我试图将讨论从具体实施转移到潜在的问题。**

*This blog post is relatively long. I encourage you to skip sections you find boring*
**这篇博文有点长。我建议你跳过你觉得无聊的部分**

---

Lately [this blogpost](https://faiface.github.io/post/context-should-go-away-go2/) has been discussed in several Go forums. It brings up several good arguments against the [context-package](https://godoc.org/context):
最近 [这篇博文](https://faiface.github.io/post/context-should-go-away-go2/) 已经在几个 Go 论坛上探讨过。它提出了几个很好的论据来反对 [context-package](https://godoc.org/context)：

- It requires every intermediate functions to include a `context.Context` even if they themselves do not use it. This introduces clutter into APIs and requires extensive plumbing.  Additionally, `ctx context.Context` "stutters".
- 它需要每个中间函数包含 `context.Context`，即使它们自己不使用它。这引起了 API 的混乱的同时还需要广泛的深入修改 API， 比如，`ctx context.Context` 会在入参中重复出现多次。
- `context.Value` is not statically type-safe, requiring type-assertions.
- `context.Value` 不是静态类型安全的，总是需要类型断言。
- It does not allow you to express critical dependencies on context-contents statically.
- 它不允许您静态地表达关于上下文内容的关键依赖。
- It's susceptible to name collisions due to requiring a global namespace.
- 由于需要全局命名空间，它容易出现名称冲突。
- It's a map implemented as a linked list and thus inefficient.
- 这是一个已链表形式实现的字典，因此效率很低。

However, I don't think the post is doing a good enough job to discuss the problems context was designed to *solve*. It explicitly focuses on cancellation. `Context.Value` is discarded by simply stating that
然而，在对 context 被设计来**解决**的问题的探讨中，我不认为它做的足够好。它明确着重说明了取消机制，而 `Context.Value` 只是简单说明了一下。

> […] designing your APIs without ctx.Value in mind at all makes it always possible to come up with alternatives.
> […] 设计你的 API，而不考虑 ctx.Value，可以让你永远有选择的余地。

I think this is not doing this question justice. To have a reasoned argument about context.Value there need to be consideration for both sides involved. No matter what your opinion on the current API is: The fact that seasoned, intelligent engineers felt the need - after significant thought - for `Context.Value` should already imply that the question deserves more attention.
我认为这个问题提的很不公正。想要关于 context.Value 的论证是理性的，需要双方都参与进来考虑。无论你对当前 API 的看法如何：经验丰富且智慧的工程师们在郑重思考后觉得 `Context.Value` 是需要的，这意味着这个问题值得被关注。

I'm going to try to describe my view on what kind of problems the context package tries to address, what alternatives currently exist and why I find them insufficient and I'm trying to describe an alternative design for a future evolution of the language. It would solve the same problems while avoiding some of the learned downsides of the context package. It is not meant as a specific proposal for Go 2 (I consider that way premature at this point) but just to show that a balanced view can show up alternatives in the design space and make it easier to consider all options.
我将尝试描述我对上下文包在尝试解决什么样的问题的看法，目前存在哪些替代方案，以及为什么我发现它们不够，而且我正在为一种未来的语言演进描述一种替代设计。它将解决相同的问题，同时避免一些学习上下文包时的负面影响。但这并不是意味着它将会是 Go 2 的一个具体方案（我在这的考虑还为时过早），只是为了表现一种平衡的观点，使得语言设计界有更多可能，更容易考虑到全部可能。

---

The problem context sets out to solve is one of abstracting a problem into independently executing units handled by different parts of a system. And how to scope data to one of these units in this scenario. It's hard to clearly define the abstraction I am talking about. So I'm instead going to give some examples.
这些 context 要去解决的问题是将问题抽象为独立执行的、由系统的不同部分处理的单元，以及如何将数据作用域应用到这些单元的某一个上。很难清楚的定义我说的这些抽象，所以我会给出一些例子。

- When you build a scalable web service you will probably have a stateless frontend server that does things like authentication, verification and parsing for you. This allows you to scale up the external interface effortlessly and thus also gracefully fall back if the load increases past what the backends can handle. By treating requests as independent from each other you can load-balance them freely between your frontends.
- 当你构建一个可扩展的 web 服务时，你可能会有一个为你做一些类似认证、权鉴和解析等的无状态前端服务。它允许你轻松的扩展外部接口，如果负载增加到后端不能承受，也可以直接在前端优雅的拒绝。
- [Microservices](https://en.wikipedia.org/wiki/Microservices) split a large application into small individual pieces that each process individual requests, each potentially branching out into more requests to other services. The requests will usually be independent, making it easy to scale individual microservices up and down based on demand, to load-balance between instances and to solve problems in [transparent proxies](https://istio.io/).
- [微服务](https://en.wikipedia.org/wiki/Microservices)将大型应用分成小的个体分别来处理每个特定的请求，拆分出更多的请求到其它微服务里面。这些请求通常是独立的，可以根据需求轻松的将各个微服务上下的扩展，从而在实例之间进行负载均衡，并解决 [透明代理](https://istio.io/) 中的一些问题。
- [Functions as a Service](https://en.wikipedia.org/wiki/Serverless_computing) goes one step further: You write single stateless functions that transform data and the platform will make them scale and execute efficiently. - Even [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes), the concurrency model built into Go, can be viewed through that lens. The programmer expresses her problem as individually executing "processes" and the runtime will execute them efficiently.
- [函数及服务](https://en.wikipedia.org/wiki/Serverless_computing)走的更远一步：你编写一个无状态的方法来转换数据，平台使其可扩展并更效率的执行。 - 甚至 [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes)，Go 内置的并发模型也可以体现这一方式。即程序员执行单独的『进程』来描述他的问题，运行时则会更效率的执行它。
- [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming) as a paradigm calls this "purity". The concept that a functions result may only depend on its input parameters means not much more than the absence of shared state and independent execution.
- [函数式程序设计](https://en.wikipedia.org/wiki/Functional_programming)作为一种范型。函数结果只依赖于入参的这一概念意味着不存在共享态和独立执行。
- The design of a [Request Oriented Collector](https://docs.google.com/document/d/1gCsFxXamW8RRvOe5hECz98Ftk-tcRRJcDFANj2VwCB0/edit) for Go plays exactly into the same assumptions and ideas.
- 这个 Go 的[Request Oriented Collector](https://docs.google.com/document/d/1gCsFxXamW8RRvOe5hECz98Ftk-tcRRJcDFANj2VwCB0/edit)设计也有着完全相同的猜想和理论。

The idea in all these cases is to increase scaling (whether distributed among machines, between threads or just in code) by reducing shared state while maintaining shared usage of resources.
所有这些情况的想法都是想通过减少共享状态的同时保持资源的共享来增加扩展性（无论是分布在机器之间，线程之间或者只是代码中）。

Go takes a measured approach to this. It doesn't go as far as some functional programming languages to forbid or discourage mutable state. It allows sharing memory between threads and synchronizing with mutexes instead of relying purely on channels. But it also definitely tries to be a (if not *the*) language to write modern, scalable services in. As such, it *needs* to be a good language to write this kind of stateless services. It needs to be able to make *requests* the level of isolation instead of the process. At least to a degree.
Go 采取了一个措施来靠近这个特性。但它不会像某些函数式编程语言那样禁止或者阻碍可变状态。它允许在线程之间共享内存并与互斥体进行同步，而不完全依赖于通道。但是它也绝对想成为一种（或**唯一**）编写现代可扩展服务的语言。因此，它**需要**成为一种很好的语言来编写无状态的服务，它需要至少在一定程度上能够达到**请求**隔离级别而不是进程隔离。

*(Side note: This seems to play into the statement of the author of above article, who claims that context is mainly useful for server authors. I disagree though. The general abstraction happens on many levels. E.g. a click in a GUI counts just as much as a "request" for this abstraction as an HTTP request)*
**（附注：这似乎是上述文章作者的声明，他声称上下文主要对服务作者有用。我不同意。一般抽象发生在很多层面。比如 GUI 的一次点击就像这个请求的抽象一样，作为一个 HTTP 请求）**

This brings with it the requirement of being able to store some data on a request-level. A simple example for this would be authentication in an [RPC framework](https://grpc.io/). Different requests will have different capabilities. If a request originates from an administrator it should have higher privileges than if it originates from an unauthenticated user. This is fundamentally *request scoped* data. Not process, service or application scoped. And the RPC framework should treat this data as opaque. It is application specific not only how that data looks en détail but also *what kinds* of data it requires.
这带来了能在请求级别存储一些数据的需求。一个简单的例子就是[RPC 框架](https://grpc.io)中的身份验证。不同的请求将具有不同的功能。如果一个请求来自于管理员，它应该比未认证用户拥有更高的权限。这是从根本上的**请求范围**内的数据而不是过程，服务或者应用范围。RPC 框架应该将这些数据视为不透明的。它是应用程序特指的，不仅是数据看起来有多详细，还有**什么样**的数据是需要的。

Just like an HTTP proxy or framework should not need to know about request parameters or headers it doesn't consume, an RPC framework shouldn't know about request scoped data the application needs.
就像一个 HTTP 代理或者框架不应该需要知道请求的参数和它不需要的头一样，RPC 框架不应该知道应用程序所需要的请求范围的数据。

---

Let's try to look at specific ways this problem is (or could be) solved without involving context. As an example, let's look at the problem of writing an HTTP middleware. We want to be able to wrap an [http.Handler](https://godoc.org/net/http#Handler) (or a variation thereof) in a way that allows the wrapper to attach data to a request.
让我们来试试在不引入上下文的情况下解决（可能）这个问题，例如，我们来看看编写 HTTP 中间件的问题。我们希望以装饰一个[http.Handler](https://godoc.org/net/http#Handler)（或其变体）的方式来允许装饰器附加数据给请求。

To get static type-safety we could try to add some type to our handlers. We could have a type containing all the data we want to keep request scoped and pass that through our handlers:
为了获得静态类型安全性，我们可以试着添加一些类型给我们的 handlers。我们可以有一个包含我们想要保留请求范围内所有数据的类型，并通过我们的 handler 传递：

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

However, this would prevent us from writing reusable Middleware. Any such middleware would need to make it possible to wrap `HandleA`. But as it's supposed to be reusable, it can't know the type of the Data parameter. You could make the `Data` parameter an `interface{}` and require type-assertion. But that wouldn't allow the middleware to inject its own data. You might think that interface type-assertions could solve this, but they have [their own set of problems](https://blog.merovius.de/2017/07/30/the-trouble-with-optional-interfaces.html). In the end, this approach won't bring you actual additional type safety.
但是，这将阻止我们编写可重用的中间件。任何这样的中间件都需要用 `HandleA` 包好。但是因为它将是可重用的，所以它不应该知道参数的类型。有可以将 `Data` 参数设置为 `interface{}` 类型，并需要类型断言。但这不允许中间件注入自己的数据。你可能觉得接口类型断言可以解决这个问题，但是它们还有[它们自己的一堆问题](https://blog.merovius.de/2017/07/30/the-trouble-with-optional-interfaces.html)没解决。所以结果是，这种方法不能带给你真正的类型安全。

We could store our state keyed by requests. For example, an authentication middleware could do
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

This has *some* advantages over context:
这与上下文相比有**一些**好处：

- It is more type-safe.
- 它更加类型安全。
- While we still can't express a requirement on an authenticated user statically, we *can* express a requirement on an `Authenticator`
- 虽然我们还是不能对认证用户表达要求，但是我们**能**对认证者表达要求。
- It's not susceptible to name-collisions anymore.
- 这样不太可能命名冲突了。

However, we bought this with shared mutable state and the associated lock contention. It can also break in subtle ways, if one of the intermediate handlers decides to create a new Request - as [http.StripPrefix](https://github.com/golang/go/blob/816deacc70f48d14638104e284b3b75d5b1e8036/src/net/http/server.go#L1946) is going to do soon.
然而，我们已经认同它的共享可变状态和相关的锁争用。如果其中一个中间处理程序决定创建一个新的请求，那么可以使用一种很微妙的方式破解，比如[http.StripPrefix](https://github.com/golang/go/blob/816deacc70f48d14638104e284b3b75d5b1e8036/src/net/http/server.go#L1946)将要做的那样。

Lastly, we might consider to store this data in the [*http.Request](https://godoc.org/net/http#Request) itself, for example by adding it as a stringified [URL parameter](https://godoc.org/net/url#URL.RawQuery). This too has several downsides, though. In fact it checks almost every single item from our list of downsides of `context.Context`. The exception is being a linked list. But even that advantage we buy with a lack of thread safety. If that request is passed to a handler in a different goroutine we get into trouble.
最后我们可能会考虑将这些数据存储在[*http.Request](https://godoc.org/net/http#Request)本身中，例如通过将其添加为字符串的[URL parameter](https://godoc.org/net/url#URL.RawQuery)，但这也有几个缺点。事实上，它基本检测到了 `context.Context` 的每个单独 item 的缺点。表达式是一个链表。即使有那样的优点，它的线程安全也无法忽略，如果该请求被传递给不同的 goroutine 中的程序处理，我们会遇到麻烦。

*(Side note: All of this also gives us a good idea of why the context package is implemented as a linked list. It allows all the data stored in it to be read-only and thus inherently thread-safe. There will never be any lock-contention around the shared state saved in a context.Context, because there will never be any need for locks)*
**（附注：所有的这一切也使我们了解了为什么 context 包被使用链表的方式实现。它允许存储在其中的所有数据都是只读的，因此肯定线程安全，在上下文中保存的共享状态永远不会出现锁争用，因为压根不需要锁）


So we see that it is really hard (if not impossible) to solve this problem of having data attached to requests in independently executing handlers while also doing significantly better than with `context.Value`. Whether you believe this a problem worth solving or not is debatable. But *if* you want to get this kind of scalable abstraction you will have to rely on *something* like `context.Value`.
所以我们看到，解决这个问题是非常困难的（如果可以解决），实现在独立执行的处理程序附加数据给请求时，也是优于 `context.Value` 的。

---

No matter whether you are now convinced of the usefulness of `context.Value` or still doubtful: The disadvantages can clearly not be ignored in either case. But we can try to find a way to improve on it. To eliminate some of the disadvantages while still keeping its useful attributes.
无论你现在确实相信 `context.Value` 的无用，或者你仍有疑虑：在这两种情况下，这些缺点显然不能被忽略。但是我们可以试着找到一些方法去改进它。消除一些缺点，同时保持其有用的属性。

One way to do that (in Go 2) would be to introduce [dynamically scoped](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping) variables. Semantically, each dynamically scoped variable represents a separate stack. Every time you change its value the new one is pushed to the stack.  It is pop'ed off again after your function returns. For example:
一种方法（在 Go 2 中）将是引入[动态范围](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping)变量。语义上，每个动态范围变量表示一个单独的栈，每次你改变它的值，新的值被推入栈。在你方法返回之后它会再次出栈。比如：

```go
// Let's make up syntax! Only a tiny bit, though.
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

// Output:
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

There are several notes about what I would imagine the semantics to be here.
我想到这里的语义有一些需要注意的地方。

- I would only allow `dyn`-declarations at package scope. Given that there is no way to refer to a local identifier of a different function, that seems logical.
- 我只允许在包的范围声明 `dyn` 这个类型。鉴于没有办法引用不同功能的本地标识符，这似乎是合乎逻辑的。
- A newly spawned goroutine would inherit the dynamic values of its parent function. If we implement them (like `context.Context`) via linked lists, the shared data will be read-only. The head-pointer would need to be stored in some kind of goroutine-local storage. Thus, writes only ever modify this local storage (and the global heap), so wouldn't need to be synchronized specifically.
- 新产生的 goroutine 将会继承其父方法的动态值。如果我们通过链表实现它（像 `context.Context` 一样），共享的数据将是只读的。头指针需要储存在某种类型的 goroutine-local 的存储中。这样，写入只会修改此本地存储（和全局堆），因此不需要特意的同步本次修改。
- The dynamic scoping would be independent of the package the variable is declared in. That is, if `foo.A` modifies a dynamic `bar.X`, then that modification is visible to all subsequent callees of `foo.A`, whether they are in `bar` or not.
- 动态范围将会独立于声明变量的包。也就是说，如果 `foo.A` 修改了一个动态的 `bar.X`，那么这个修改对后来的 `foo.A` 的被调用者都是不可见的，不管它们是否在 `bar` 内。
- Dynamically scoped variables would likely not be addressable. Otherwise we'd loose concurrency safety and the clear "down-stack" semantics of dynamic scoping. It would still be possible to declare `dyn x *int` though and thus get mutable state to pass on.
- 动态范围的变量不可寻址。否则我们会松动并发安全性和动态范围界定的清晰『入栈』语义。不过仍然可以声明 `dyn x *int` 来让可变状态传递。
- The compiler would allocate the necessary storage for the stacks, initialized to their initializers and emit the necessary instructions to push and pop values on writes and returns. To account for panics and early returns, a mechanism like `defer` would be needed.
- 编译器将为栈分配必要的内存，初始化到它们的初始化器，并发出必要的指令，以便在写入和返回时推送和弹出值。为了对 panic 和过早的返回有个交代，需要类似 `defer` 的机制。
- There is some confusing overlap with package-scoped variables in this design. Most notably, from seeing `foo.X = Y` you wouldn't be able to tell whether `foo.X` is dynamically scoped or not. Personally, I would address that by removing package-scoped variables from the language. They could still be emulated by declaring a dynamically-scoped pointer and never modifying it. Its pointee is then a shared variable. But most usages of package-scoped variables would probably just use dynamically scoped variables.
- 这个设计和包范围有一些令人迷惑的重叠。最值得注意的是，从 `foo.X = Y` 来看，你无法判断 `foo.X` 是否是动态范围的。就我个人而言，我会通过从语言中移除包范围变量来解决此问题。它们仍然可以通过声明一个动态范围指针，而不修改它来模仿。那么它的指针就是一个共享变量。但是，大多数包范围变量的用法就仅仅是使用动态范围变量。

It is instructive to compare this design against the list of disadvantages identified for `context`.
将此设计同 `context` 的一系列缺点进行比较是很有启发性的。

- API clutter would be removed, as request-scoped data would now be part of the language without needing explicit passing.
- 避免了 API 的杂乱，因为请求范围的数据现在将成为语言的一部分，而不需要明确的传递。
- Dynamically scoped variables are statically type-safe. Every `dyn` declaration has an unambiguous type.
- 动态区域变量是静态类型安全的。每个 `dyn` 声明都有一个明确的类型。
- It would still not be possible to express critical dependencies on dynamically scoped variables but they also couldn't be *absent*. At worst they'll have their zero value.
- 仍然不可能对动态范围变量表达关键的依赖关系。但也不能**没有**。最糟糕的，它们会有零值。
- Name collision is eliminated. Identifiers are, just like variable names, properly scoped.
- 命名冲突被消除。标识符就像变量名一样，标识符有恰当的范围。
- While a naive implementation would still use linked lists, they wouldn't be inefficient. Every `dyn` declaration gets its own list and only the head-pointer ever needs to be operated on.
- 简单的实现任然非链表莫属，并不会很低效。每个 `dyn` 声明都有它自己的链，只有头指针需要被操作。
- The design is still "magic" to a degree. But that "magic" is problem-inherent (at least if I understand the criticism correctly). The magic is exactly the possibility to pass values transparently through API boundaries.
- 这个设计在一定程度上仍然很『魔幻』。但是『魔幻』是固有问题（至少如果我正确的理解批评的话）。魔法就是通过 API 边界透明地传递价值的一种可能性。

Lastly, I'd like to mention cancellation. While the author of above post dedicates most of it to cancellation, I have so far mostly ignored it.  That's because I believe cancellation to be trivially implementable on top of a good `context.Value` implementation. For example:
最后，我想提一下 cancellation。索然在上述文章中，作者提到了很多关于 cancellation 的内容，但我迄今为止都忽略了它。那是因为我相信 cancellation 在好的 `context.Value` 实现之上是可以实现的。比如：

```
// $GOROOT/src/done
package done

// C is closed when the current execution context (e.g. request) should be
// cancelled.
// 当当前执行的上下文（比如请求）被取消时，C 被关闭。
dyn C <-chan struct{}

// CancelFunc returns a channel that gets closed, when C is closed or cancel is
// called.
// 当 C 被关闭或者取消被调用时，CancelFunc 返回一个关闭的通道。
func CancelFunc() (c <-chan struct, cancel func()) {
    // Note: We can't modify C here, because it is dynamically scoped, which is
    // why we return a new channel that the caller should store.
    // 我们不能在这改变 C，应为它是动态范围的，这就是为什么我们返回一个调用者应该储存的新通道。
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

This cancellation mechanism would now be usable from any library that wants it
without needing any explicit support in its API. This would also make it easy
to add cancellation capabilities retroactively.
这种取消机制现在可以从任何想要的库中使用，而不需要确认其 API 明确支持。这让它可以很简单的追加取消的能力。

---

Whether you *like* this design or not, it demonstrates that we shouldn't rush
to calling for the removal of `context`. Removing it is only one possible
solution to its downsides.
无论你喜不喜欢这个设计，至少我们不应该急于要求删除 `context` 包。删除它只是一种可能解决它缺点的方法之一。

If the removal of `context.Context` actually comes up, the question we should
ask is "do we want a canonical way to manage request-scoped values and at what
cost".  Only then should we ask what the best implementation of this would be
or whether to remove the current one.
如果移除 `context.Context` 的这一天真的来了，我们应该问的问题是『我们是否想要有一个规范的方法去管理请求范围的值，其代价又是什么』。只有这样我们才能问最好的实现会是什么样的，或者是否移除现在这个。


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  