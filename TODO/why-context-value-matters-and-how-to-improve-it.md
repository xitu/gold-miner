
  > * 原文地址：[Why context.Value matters and how to improve it](https://blog.merovius.de/2017/08/14/why-context-value-matters-and-how-to-improve-it.html)
  > * 原文作者：[Axel Wagner](https://twitter.com/TheMerovius)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/why-context-value-matters-and-how-to-improve-it.md](https://github.com/xitu/gold-miner/blob/master/TODO/why-context-value-matters-and-how-to-improve-it.md)
  > * 译者：
  > * 校对者：

  # Why context.Value matters and how to improve it

  **tl;dr: I think context.Value solves the important use case of writing stateless - and thus scalable - abstractions. I believe [dynamic scoping](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping) could provide the same benefits while solving most of the criticism of the current implementation. I thus try to steer the discussion away from the concrete implementation and towards the underlying problem.**

*This blog post is relatively long. I encourage you to skip sections you find boring*

---

Lately [this blogpost](https://faiface.github.io/post/context-should-go-away-go2/) has been discussed in several Go forums. It brings up several good arguments against the [context-package](https://godoc.org/context):

- It requires every intermediate functions to include a `context.Context` even if they themselves do not use it. This introduces clutter into APIs and requires extensive plumbing.  Additionally, `ctx context.Context` "stutters".
- `context.Value` is not statically type-safe, requiring type-assertions.
- It does not allow you to express critical dependencies on context-contents statically.
- It's susceptible to name collisions due to requiring a global namespace.
- It's a map implemented as a linked list and thus inefficient.

However, I don't think the post is doing a good enough job to discuss the problems context was designed to *solve*. It explicitly focuses on cancellation. `Context.Value` is discarded by simply stating that

> […] designing your APIs without ctx.Value in mind at all makes it always possible to come up with alternatives.

I think this is not doing this question justice. To have a reasoned argument about context.Value there need to be consideration for both sides involved. No matter what your opinion on the current API is: The fact that seasoned, intelligent engineers felt the need - after significant thought - for `Context.Value` should already imply that the question deserves more attention.

I'm going to try to describe my view on what kind of problems the context package tries to address, what alternatives currently exist and why I find them insufficient and I'm trying to describe an alternative design for a future evolution of the language. It would solve the same problems while avoiding some of the learned downsides of the context package. It is not meant as a specific proposal for Go 2 (I consider that way premature at this point) but just to show that a balanced view can show up alternatives in the design space and make it easier to consider all options.

---

The problem context sets out to solve is one of abstracting a problem into independently executing units handled by different parts of a system. And how to scope data to one of these units in this scenario. It's hard to clearly define the abstraction I am talking about. So I'm instead going to give some examples.

- When you build a scalable web service you will probably have a stateless frontend server that does things like authentication, verification and parsing for you. This allows you to scale up the external interface effortlessly and thus also gracefully fall back if the load increases past what the backends can handle. By treating requests as independent from each other you can load-balance them freely between your frontends.
- [Microservices](https://en.wikipedia.org/wiki/Microservices) split a large application into small individual pieces that each process individual requests, each potentially branching out into more requests to other services. The requests will usually be independent, making it easy to scale individual microservices up and down based on demand, to load-balance between instances and to solve problems in [transparent proxies](https://istio.io/).
- [Functions as a Service](https://en.wikipedia.org/wiki/Serverless_computing) goes one step further: You write single stateless functions that transform data and the platform will make them scale and execute efficiently. - Even [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes), the concurrency model built into Go, can be viewed through that lens. The programmer expresses her problem as individually executing "processes" and the runtime will execute them efficiently.
- [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming) as a paradigm calls this "purity". The concept that a functions result may only depend on its input parameters means not much more than the absence of shared state and independent execution.
- The design of a [Request Oriented Collector](https://docs.google.com/document/d/1gCsFxXamW8RRvOe5hECz98Ftk-tcRRJcDFANj2VwCB0/edit) for Go plays exactly into the same assumptions and ideas.

The idea in all these cases is to increase scaling (whether distributed among machines, between threads or just in code) by reducing shared state while maintaining shared usage of resources.

Go takes a measured approach to this. It doesn't go as far as some functional programming languages to forbid or discourage mutable state. It allows sharing memory between threads and synchronizing with mutexes instead of relying purely on channels. But it also definitely tries to be a (if not *the*) language to write modern, scalable services in. As such, it *needs* to be a good language to write this kind of stateless services. It needs to be able to make *requests* the level of isolation instead of the process. At least to a degree.

*(Side note: This seems to play into the statement of the author of above article, who claims that context is mainly useful for server authors. I disagree though. The general abstraction happens on many levels. E.g. a click in a GUI counts just as much as a "request" for this abstraction as an HTTP request)*

This brings with it the requirement of being able to store some data on a request-level. A simple example for this would be authentication in an [RPC framework](https://grpc.io/). Different requests will have different capabilities. If a request originates from an administrator it should have higher privileges than if it originates from an unauthenticated user. This is fundamentally *request scoped* data. Not process, service or application scoped. And the RPC framework should treat this data as opaque. It is application specific not only how that data looks en détail but also *what kinds* of data it requires.

Just like an HTTP proxy or framework should not need to know about request parameters or headers it doesn't consume, an RPC framework shouldn't know about request scoped data the application needs.

---

Let's try to look at specific ways this problem is (or could be) solved without involving context. As an example, let's look at the problem of writing an HTTP middleware. We want to be able to wrap an [http.Handler](https://godoc.org/net/http#Handler) (or a variation thereof) in a way that allows the wrapper to attach data to a request.

To get static type-safety we could try to add some type to our handlers. We could have a type containing all the data we want to keep request scoped and pass that through our handlers:

```
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

We could store our state keyed by requests. For example, an authentication middleware could do

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

- It is more type-safe.
- While we still can't express a requirement on an authenticated user statically, we *can* express a requirement on an `Authenticator`
- It's not susceptible to name-collisions anymore.

However, we bought this with shared mutable state and the associated lock contention. It can also break in subtle ways, if one of the intermediate handlers decides to create a new Request - as [http.StripPrefix](https://github.com/golang/go/blob/816deacc70f48d14638104e284b3b75d5b1e8036/src/net/http/server.go#L1946) is going to do soon.

Lastly, we might consider to store this data in the [*http.Request](https://godoc.org/net/http#Request) itself, for example by adding it as a stringified [URL parameter](https://godoc.org/net/url#URL.RawQuery). This too has several downsides, though. In fact it checks almost every single item from our list of downsides of `context.Context`. The exception is being a linked list. But even that advantage we buy with a lack of thread safety. If that request is passed to a handler in a different goroutine we get into trouble.

*(Side note: All of this also gives us a good idea of why the context package is implemented as a linked list. It allows all the data stored in it to be read-only and thus inherently thread-safe. There will never be any lock-contention around the shared state saved in a context.Context, because there will never be any need for locks)*

So we see that it is really hard (if not impossible) to solve this problem of having data attached to requests in independently executing handlers while also doing significantly better than with `context.Value`. Whether you believe this a problem worth solving or not is debatable. But *if* you want to get this kind of scalable abstraction you will have to rely on *something* like `context.Value`.

---

No matter whether you are now convinced of the usefulness of `context.Value` or still doubtful: The disadvantages can clearly not be ignored in either case. But we can try to find a way to improve on it. To eliminate some of the disadvantages while still keeping its useful attributes.

One way to do that (in Go 2) would be to introduce [dynamically scoped](https://en.wikipedia.org/wiki/Scope_(computer_science)#Dynamic_scoping) variables. Semantically, each dynamically scoped variable represents a separate stack. Every time you change its value the new one is pushed to the stack.  It is pop'ed off again after your function returns. For example:

```
// Let's make up syntax! Only a tiny bit, though.
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

- I would only allow `dyn`-declarations at package scope. Given that there is no way to refer to a local identifier of a different function, that seems logical.
- A newly spawned goroutine would inherit the dynamic values of its parent function. If we implement them (like `context.Context`) via linked lists, the shared data will be read-only. The head-pointer would need to be stored in some kind of goroutine-local storage. Thus, writes only ever modify this local storage (and the global heap), so wouldn't need to be synchronized specifically.
- The dynamic scoping would be independent of the package the variable is declared in. That is, if `foo.A` modifies a dynamic `bar.X`, then that modification is visible to all subsequent callees of `foo.A`, whether they are in `bar` or not.
- Dynamically scoped variables would likely not be addressable. Otherwise we'd loose concurrency safety and the clear "down-stack" semantics of dynamic scoping. It would still be possible to declare `dyn x *int` though and thus get mutable state to pass on.
- The compiler would allocate the necessary storage for the stacks, initialized to their initializers and emit the necessary instructions to push and pop values on writes and returns. To account for panics and early returns, a mechanism like `defer` would be needed.
- There is some confusing overlap with package-scoped variables in this design. Most notably, from seeing `foo.X = Y` you wouldn't be able to tell whether `foo.X` is dynamically scoped or not. Personally, I would address that by removing package-scoped variables from the language. They could still be emulated by declaring a dynamically-scoped pointer and never modifying it. Its pointee is then a shared variable. But most usages of package-scoped variables would probably just use dynamically scoped variables.

It is instructive to compare this design against the list of disadvantages identified for `context`.

- API clutter would be removed, as request-scoped data would now be part of the language without needing explicit passing.
- Dynamically scoped variables are statically type-safe. Every `dyn` declaration has an unambiguous type.
- It would still not be possible to express critical dependencies on dynamically scoped variables but they also couldn't be *absent*. At worst they'll have their zero value.
- Name collision is eliminated. Identifiers are, just like variable names, properly scoped.
- While a naive implementation would still use linked lists, they wouldn't be inefficient. Every `dyn` declaration gets its own list and only the head-pointer ever needs to be operated on.
- The design is still "magic" to a degree. But that "magic" is problem-inherent (at least if I understand the criticism correctly). The magic is exactly the possibility to pass values transparently through API boundaries.

Lastly, I'd like to mention cancellation. While the author of above post dedicates most of it to cancellation, I have so far mostly ignored it.  That's because I believe cancellation to be trivially implementable on top of a good `context.Value` implementation. For example:

```
// $GOROOT/src/done
package done

// C is closed when the current execution context (e.g. request) should be
// cancelled.
dyn C <-chan struct{}

// CancelFunc returns a channel that gets closed, when C is closed or cancel is
// called.
func CancelFunc() (c <-chan struct, cancel func()) {
    // Note: We can't modify C here, because it is dynamically scoped, which is
    // why we return a new channel that the caller should store.
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

---

Whether you *like* this design or not, it demonstrates that we shouldn't rush
to calling for the removal of `context`. Removing it is only one possible
solution to its downsides.

If the removal of `context.Context` actually comes up, the question we should
ask is "do we want a canonical way to manage request-scoped values and at what
cost".  Only then should we ask what the best implementation of this would be
or whether to remove the current one.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  