
> * 原文地址：[What’s So Great About Redux?](https://medium.freecodecamp.org/whats-so-great-about-redux-ac16f1cc0f8b)
> * 原文作者：[Justin Falcone](https://medium.freecodecamp.org/@modernserf)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-so-great-about-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-so-great-about-redux.md)
> * 译者：[ZiXYu](https://github.com/ZiXYu)
> * 校对者：

# What’s So Great About Redux?
Redux 有多棒？

![](https://cdn-images-1.medium.com/max/1600/1*BpaqVMW2RjQAg9cFHcX1pw.png)

Redux elegantly handles complex state interactions that are hard to express with React’s component state. It is essentially a message-passing system, like the kind seen in Object-Oriented programming, but implemented as a library instead of in the language itself[¹](#535d). As in OOP, Redux inverts the responsibility of control from caller to receiver — the UI doesn’t directly manipulate the state but rather sends it a message for the state to interpret.

Redux 能够优雅地处理复杂且难以被 React 组件描述的状态交互。它本质上是一个消息传递系统，就像在面向对象编程中看到的那样，只是 Redux 是通过一个库而不是在语言本身中来实现的。就像在 OOP 中那样，Redux 将控制的责任从调用方转移到了接收方 - 界面并不直接操作状态值，而是发布一条操作消息来让状态解析。

Through this lens, a Redux store is an object, reducers are method handlers, and actions are messages. `store.dispatch({ type: "foo", payload: "bar" })` is equivalent to Ruby's `store.send(:foo, "bar")`. Middleware are used in much the same way Aspect-Oriented Programming (e.g. Rails' `before_action`) and React-Redux's `connect` is dependency injection.

一个 Redux store 是一个对象， reducers 是方法的处理程序，而 actions 是操作消息。`store.dispatch({ type: "foo", payload: "bar" })` 相当于 Ruby 中的 `store.send(:foo, "bar")`。中间件的使用方式类似于面向切面编程 (AOP, Aspect-Oriented Programming) (例如：Rails 中的 `before_action`)。 而 React-Redux 的 `connect` 则是依赖注入。

#### Why is this desirable?

- The inversion of control described above ensures that the UI doesn’t need to be updated if the implementation of state transitions changes. Adding complex features like logging, undo or even time travel debugging are almost trivial. Integration tests are just a matter of testing that the right action is dispatched; the rest can be unit-tested.
- 上文中控制权限的转移保证了当状态转换的实现变化时， UI 并不需要更新。添加复杂的功能，例如记录日志，撤销操作，甚至是时光穿越调试 (time travel debugging)，将变得非常简单。集成测试只需要确认派发了正确的 actions 即可，剩下的测试都可以通过单元测试来完成。
- React’s component state is pretty clunky for state that touches multiple parts of your app, such as user info and notifications. Redux gives you a state tree thats independent of your UI to handle these cross cutting concerns. Furthermore, having your state live outside of the UI makes things like persistence easier — you only need to deal with serializing to localStorage or URLs in a single place.
- React 的组件状态对于那些在 app 中触及多个部分的状态而言非常笨重，例如用户信息和消息通知。Redux 提供了一个独立于 UI 的状态树来处理这些交叉问题。此外，让你的状态存活于 UI 之外使实现数据可持久化之类的功能变得更简单 - 你只需要在一个单独的地方处理 localStorage 和 URL 即可。
- Redux’s titular “reducers” provide incredible flexibility for handling actions — composition, multiple dispatch, even `method_missing`-style parsing.
- Redux 的 reducer 提供了难以想象的灵活方式来处理 actions - 组合，多次派发，甚至 `method_missing` 式解析

#### These are all unusual cases. What about the common cases?
这些都是不常见的情况。在常见情况下呢？

Well, there’s the problem.

好吧，这就是问题所在。

- An action *could* be interpreted as a complex state transition, but most of them set a single value. Redux apps tend to end up with a bunch of actions that set a single value; there’s a distinct reminder of manually writing setter functions in Java.
- 一个 action *可以*被解释为一个复杂的状态转换，但是它们中的绝大对数只是用来设置一个单独的值。Redux 应用倾向于结束这一大堆只用于设置一个值的 action，这里有个用于区分在 Java 中手动写 setter 函数的标志。
- A fragment of state *could* be used all over your app, but most state maps 1:1 with a single part of the UI. Putting that state in Redux instead of component state just adds *indirection* without *abstraction*.
- 你*可以*在你 app 的任意一个地方使用状态树的任一部分，但是对于大多数状态来说，它们一对一的对应了某个 UI 中的一部分。将这种状态放在 Redux 中，而不是放在组件里，这只是*间接*而非*抽象*。
- A reducer function *could* do all sorts of metaprogramming weirdness, but in most cases it’s just single-dispatch on the action’s type field. This is fine in languages like Elm and Erlang, where pattern matching is terse and highly expressive, but rather clunky in JavaScript with `switch` statements.
- 一个 reducer 函数*可以*做各种奇怪的元编程，但是在绝大多数情况下它只是基于某个 action 类型的单一派发。这在 Elm 和 Erlang 这种语言中是很好实现的，因为在这些语言中，模式匹配是简洁而高效的，但是在 JavaScript 中使用 `switch` 语句来实现就显得格外笨拙。

But the really insidious thing is that when you spend all your time doing the boilerplate for common cases, you forget that better solutions for the special cases *even exist*. You encounter a complex state transition and solve it with a function that dispatches a dozen different value-setting actions. You duplicate state in the reducer rather than distributing a single state slice across the app. You copy and paste switch cases across multiple reducers instead of abstracting it into shared functions.

但是更可怕的事是，当你花费了所有的时间在常见情况下编写代码模板时，你会忘记，在某些特殊情况下会有更好的解决方案*存在*。你遇到了一个复杂的状态转换问题，然后调用了很多用于设置状态值的 action 来解决了它。你在 reducer 中重复定义了很多状态，而不是在 app 中分发同一个子状态。你在很多 reducer 中复制粘贴了各种 switch case 而不是把其中的某些方法抽象成共有的方法。

It’s easy to dismiss this as mere “Operator Error” — they didn’t RTFM, A Poor Craftsman Blames His Tools — but the frequency of these problems should raise some concerns. What does it say about a tool if most people are using it wrong?

这很容易把这种错误仅仅当成 “操作员误差” - 是他们没有查看操作手册，就像可怜的工匠责怪他们手上的工具一样 - 但是这种问题出现的频率应当引起一些关注。如果大多数的人都错误的使用一款工具，那我们又该如何评价它呢？

#### So should I just avoid Redux for the common cases and save it for the special ones?
所以我们应该避免在常见情况下使用 Redux，而把它留给特殊情况吗？

That’s the advice the Redux team will give you — and that’s the advice I give to my own team members: I tell them to avoid it until using setState becomes truly untenable. But I can’t bring myself to follow my own rules, ’cause there’s always *some* reason you want to use Redux. You might have a bunch of `set_$foo` actions, but setting any value *also *updates the URL, or resets some more transient value. Maybe you have a clear 1:1 mapping of state to UI, but you *also* want to have logging or undo.
这是 Redux 开发团队给你的建议，也是我给我的开发团队成员的建议：除非使用 setState 难以解决问题，不然尽量避免使用 Redux。但是我不能让我自己也遵从我自己的规定，因为总是有*某些*原因让你想要使用 Redux。 可能你有一系列的 `set_$foo` 方法，而且设置这些值*也*会更新 URL，或者重设某些瞬态值。可能你有一些明确和 UI 一对一的状态值，但是你*也*希望纪录或者可以撤销它们。

The truth is that I don’t know how to write, much less *teach*, “good Redux.” Every app I’ve worked on is full of these Redux antipatterns, either because I couldn’t think of a better solution myself or because I couldn’t convince my teammates to change it. If the code of a Redux “expert” is mediocre, what hope does a novice have? If anything, I’m just trying to counterbalance the prevailing “Redux all the things!” approach in the hope that they will be able to understand Redux on their own terms.
事实是，我不知道如何写，更不要说*指导写*，“好的 Redux”。我曾经参与的每个 app 都充斥着 Redux 的反模式，因为我想不到更好的解决方案或者我无法说服我的队友来改变它。如果一个 Redux “专家” 写出来的代码也如此平庸，那我们还能指望一个新手怎么做呢？无论如何，我只是希望能够平衡一下现在大行其道的 “Redux 完成所有事” 解决方案，希望每个人都能在他们适用的情况下理解 Redux。

#### So what do I do in that case?

Fortunately, Redux is flexible enough that third-party libraries can integrate with it to handle the common cases — [Jumpstate](https://github.com/jumpsuit/jumpstate) for example. And to be clear, I don’t think it’s wrong for Redux to focus on the low-level stuff. But outsourcing these basic features to third parties creates an additional cognitive load and opportunity for bikeshedding — each user needs to essentially build their own framework from these parts.

#### Some people are into that sort of thing.

And I’m one of ‘em! But not everybody is. I personally love Redux and use it for just about everything that I do, but I *also* love trying out new Webpack configurations. I am not representative of the general population. I’m *empowered *by the flexibility to write my own abstractions on top of Redux, but how empowered am I by the abstractions written by some senior engineer who never documented them and quit six months ago?

It’s quite possible to *never* encounter the hard problems that Redux is particularly good at handling, particularly if you’re a junior on a team where those tickets go to the more senior engineers. Your experience of Redux is “that weird library everyone uses where you have to write everything three times.” Redux is simple enough that you *can *use it mechanically, without deep understanding, but that’s a joyless and unrewarding experience.

This brings me back to a question I raised earlier: what does it say about a tool if most people are using it wrong? A quality hand tool isn’t just useful and durable — it feels good to use. The most comfortable place to hold it is the correct place to hold it. It is designed not just for its task but also its user. A quality tool reflects the toolsmith’s empathy for the crafter.

[![](https://ws2.sinaimg.cn/large/006tNc79ly1fhzg65gw1bj31280dutam.jpg)](https://twitter.com/stevensacks/status/884947742975377409)

Where is our empathy? Why is “you’re doing it wrong” our reaction, and not “we could make this easier to use”?

There’s a related phenomenon in functional programming circles I like to call the *Curse of the Monad Tutorial*: explaining how they work is trivial, but explaining why they are valuable is surprisingly difficult.

#### Are you seriously dropping a monad tutorial in the middle of this post?

Monads are a common pattern in Haskell that’s used for working with a wide range of computation — lists, error handling, state, time, IO. There’s syntactic sugar, in the form of `do` notation, that allows you to represent sequences of monadic operations in a way that looks kind of like imperative code, much like how generators in javascript can make asynchronous code look synchronous.

The first problem is that describing monads in terms of what they’re used for is inaccurate. [Monads were introduced to Haskell to handle side effects and sequential computation](http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf), but monads as an abstract concept have nothing to do with side effects or sequences; they’re a set of rules for how a pair of functions should interact and have no inherent meaning. The concept of associativity *applies to* arithmetic and set operations and list concatenation and null propagation but it exists fully independent of them.

The second problem is that any bite-sized example of a monadic approach to X is more verbose — and therefore at least *visually* more complex — than the imperative approach. Explicit option types a la `Maybe` are safer than checking for implicit `null` but result in more, uglier code. Error handling with `Either` types is often simpler to follow than code that can `throw` from anywhere, but throwing is certainly more concise than manually propagating values. And side effects — state, IO, etc. — are trivial in an imperative language. Functional programming enthusiasts (myself included) would argue that side effects are *too easy* in these languages but convincing someone that any kind of programming is too easy is a hard sell.

The real value is only visible at the macro scale — not just that any one of these use cases follows the monad laws, but that all of them follow the *same* laws. A set of operations that works in one case can work in *every* case: zipping a pair of lists into a list of pairs is “the same thing” as merging a pair of promises into a single promise that completes with a pair of results.

#### Is this going somewhere?

The point is that Redux has the same problem — it’s difficult to teach not because it’s difficult but rather because it’s so *simple*. Understanding is not a matter of having knowledge so much as trusting the core idea in such a way that we can derive everything else through induction.

It’s hard to share this understanding because the core ideas are banal truisms (avoid side effects) or abstract to the point of meaninglessness (`(prevState, action) => nextState`). Any single concrete example doesn't help; they showcase Redux's verbosity without demonstrating its expressivity.

Once we are ✨enlightened✨ a lot of us immediately forget what it felt like beforehand. We forget that our enlightenment came only through our own repeated failures and misunderstandings.

#### So what do you propose?

I would like us to admit we have a problem. Redux is [simple, but it is not easy](https://www.infoq.com/presentations/Simple-Made-Easy). This is a valid design choice, but it is nevertheless a tradeoff. Many people would benefit from a tool that traded some of the simplicity for ease-of-use. But large chunks of the community won’t even acknowledge that a tradeoff has been made!

I think it’s interesting to contrast React and Redux because while React is a vastly more complicated piece of software and has a significantly larger API surface, it somehow feels easier to use and understand. The only absolutely necessary API features of react are `React.createElement` and `ReactDOM.render` — state, component lifecycle, even DOM events could have been handled elsewhere. Building these features into React made it more complicated, but they also made it *better*.

“Atomic state” is an abstract concept that can inform your work once you understand it, but `setState` is a method you can call on a React component that does atomic state management on your behalf, whether you understand it or not. It’s not a perfect solution — it’s less efficient than replacing state outright or mutating and forcing an update, and it has some footguns when it’s called asynchronously — but React is vastly better with `setState` as a callable method rather than a vocabulary term.

Both the Redux team and the community are [strongly opposed to expanding Redux’s API surface area](https://github.com/reactjs/redux/issues/2295), but the current approach of gluing a bunch of tiny libraries together is tedious even for experts and incomprehensible for beginners. If Redux cannot expand to have built-in support for the common cases, it needs a “blessed” framework to take that place. [Jumpsuit](https://github.com/jumpsuit/jumpsuit) could be a good start — it reifies the concepts of “actions” and “state” into callable functions while still preserving their many-to-many nature — but the actual library doesn’t matter as much as the act of blessing itself.

The irony in all this is that Redux’s *raison d’etre* is “Developer Experience”: Dan built Redux because he wanted to understand and recreate Elm’s time-traveling debugger. But as it developed its own identity — as it grew into the React ecosystem’s de facto OOP runtime — it gave up some of that focus on DX in exchange for configurability. This allowed the Redux ecosystem to bloom, but there’s a conspicuous absence where a humane, curated framework should be. Are we, the Redux community, ready to create it?

---

*Thanks to *[*Matthew McVickar*](https://medium.com/@matthewmcvickar)*, *[*a pile of moss*](https://medium.com/@whale_eat_squid)*, *[*Eric Wood*](https://medium.com/@eric_b_wood)*, *[*Matt DuLeone*](https://twitter.com/Crimyon)*, and *[*Patrick Thomson*](https://twitter.com/importantshock)* for review.*

*Footnotes:*

**[1] Why do you make a distinction between react / JS and object oriented programming? JavaScript IS object oriented, just not class-based.**

Object-Oriented programming, like functional programming, is a methodology, not a language feature. Some languages *support* this style better than others, or have a standard library that’s designed for the style, but if you’re sufficiently dedicated to the task, you can write in an object-oriented style in any language.

JavaScript has a data structure it calls an Object, and *most* values in the language can be treated like objects, in the sense that there are methods you can call on every value except for `null` and `undefined`. But before Proxies came in ES6, every "method" call on an object was a dictionary lookup; `foo.bar` is always going to find a property named "bar" on foo or its prototype chain. Contrast this with a language like Ruby, where `foo.bar` sends the message `:bar` to foo -- this message can be *intercepted* and *interpreted*, it doesn't have to be a dictionary lookup.

Redux is essentially a slower but more sophisticated object system on top of JavaScript’s existing one, where reducers and middleware act as interpreters and interceptors around the JavaScript object that actually holds the state.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
