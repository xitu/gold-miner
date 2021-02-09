> * 原文地址：[Why I Still Lisp (and You Should Too)](https://medium.com/better-programming/why-i-still-lisp-and-you-should-too-18a2ae36bd8)
> * 原文作者：[Anurag Mendhekar](https://medium.com/@mendhekar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-i-still-lisp-and-you-should-too.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-i-still-lisp-and-you-should-too.md)
> * 译者：
> * 校对者：

# 为什么我还在用Lisp（而且你也应该用）

> 这种古老的语言可能没有很多人用了，但它仍然是我代码库中的一部分。

![](https://cdn-images-1.medium.com/max/2000/1*BBzSK02LI9pvIGtiT_1IbA.png)

作为 Scheme/Common Lisp/Racket 的长期用户（和积极支持者），我有时会被问到为什么还坚持使用它们。幸运的是，我一直都在领导自己的工程师组织，所以我从来不需要为此向领导层解释。但是还有一个更重要的群体——我的工程是同事们——他们从未体会过使用这些语言的乐趣。就算他们不会让我解释，他们也会出于求知欲提问，而有时候也会想知道我为什么不会对 Python 或 Scala 即将加入的很酷的新特性或者其他风靡一时的东西而神魂颠倒。

虽然我真正使用的 Lisp 方言有很多种（Scheme, Common Lisp, Racket, Lisp-for-Erlang），核心总是保持一致的：一种基于 S-表达式的、动态类型的、主要是函数式的、值传递的基于 λ 演算的语言。

我在十几岁的时候在 ZX Spectrum+上使用 BASIC 真正开始编程，虽然在此之前我就对（手）写Fortran程序略有涉猎。这对我来说是一个决定性的使其，因为它真正定义了我的职业路线。很快我就把语言推到了它的极限，并且尝试写超出这门语言和实现的有限能力的程序。我转到 Pascal 很短的一段时间（在 DOS box 上的 Turbo Pascal），这段时间很有趣，知道我发现了运行在 Unix（Santa Cruz Operation Xenix！）上的 C。它帮助我获得了计算机科学的学士学位，但它总是让我希望能够在程序中拥有更强的表现力。

当我在 Miranda（丑陋的 Haskell 的漂亮妈妈）中发现函数式编程时（感谢 IISc！），它让我大开眼界，想要在程序中追寻**美**。我对编程语言中的表现力的概念的理解有了一个巨大的飞跃。我对程序应该长什么样的概念开始包含简洁，优雅和可读性。

Miranda 并不是一种特别快的语言，因此执行速度是一个问题。Miranda 还是一种具有 Standard-ML 式类型推断功能的静态类型语言。一开始，我迷上了类型系统。 然而，随着时间的推移，我开始鄙视它。虽然它帮助我掌握了一些编译时的东西，但大部分时候都在妨碍我（稍后再介绍）。

大约一年后，我终于在印第安纳大学和丹·弗里德曼（因《The Little LISPer》/《The Little Schemer》而著名）一起学习编程语言。这是我于 Scheme 和 Lisp 世界的起点。我终于知道我找到了表达我的程序的完美媒介。 在过去的25年中，这一点从未改变。

在本文中，我试图解释和探索，为什么会这样。是因为我是一个不会改变自己路径的老恐龙吗？是我对新想法太过傲慢和鄙夷吗？或者我只是累了？答案，我认为，不在这上面几点。我觉得它是完美的，而且还**没有**什么可以推翻这一点。

让我们分解一下。我在几段之前说过：

> 一种基于 S-表达式的、动态类型的、主要是函数式的、值传递的基于 λ 演算的语言。

---

我要开始解释这些——倒序。

## 基于 λ 演算的语言

所有程序中的基本实体都是**函数**。从软件设计过程之初函数就拥有了它们的意向性。你一直在考虑怎样对信息进行操作，它是怎样转换的，以及它是是怎样产生的。我还没有找到一个基本的框架，比 λ 演算更好的捕捉到这一固有意向。

**意向**这个词可能会让你失望。数学有两种方式来理解函数。首先，作为一组有序对：（**输入，输出**）。尽管这是一种证明函数定理的好方法，但在写代码的过程中完全没用。这也被称为函数的**扩展**视图。

第二种方式是把函数看做一个转换规则。例如，将输入和其本身相乘得到输出（这为我们提供了平方函数，每种编程语言都将其缩写为 **sqr**）。这是函数的**意向**视图，λ 演算可以很好地捕捉它，并提供简单的规则来帮助我们证明函数定理，而无需求助于扩展性。

**等一下**，我确信你正在想。**我从未证明过我的函数的什么屎**。我敢打赌，事实上，你有过。而且你会**无时无刻**这么做。你总在说服自己，你的函数正在正常工作。你的代码可能不是正式的证明（可能会导致一些 BUG），但是对代码进行推理是软件开发人员一直在做的事情。他们通过在脑海中回放代码来查看其行为。

基于 λ 演算的语言让在你的脑海中“回放代码”变得**非常**容易。λ 演算的简单规则意味着你只需装更少的东西在你的脑子里，并且代码易于阅读和理解。

编程语言当然是实用的工具，因此必须增强其核心简单性以适应更广泛的目的。这就是为什么我喜欢 Scheme（以及我目前最喜欢的 Scheme，Racket — CS，为那些在意此事的人设计）。它最低限度地引入 λ 演算到核心使其可用。即使是增强功能也遵循 λ 演算的基本原则，所以几乎没有意外。

这当然就意味着，**递归**成为了一种生活方式。如果你是哪种对递归无感的人，或者你依旧相信“递归效率低下”，那么现在是重新审视它的时候了。Scheme（和 Racket）有效地将可能的递归实现为循环。不仅如此，这还是Scheme 标准的**需求**。

这种特性被称为**尾调用优化**（**或 TCO**），已经出现了几十年。在评价编程语言现状的时候发现没有现代语言支持它，这是很令人沮丧的。因为新的语言出现并试图把 JVM 作为运行架构，所以这对于 JVM 更是个问题。JVM 不支持这个特性，所以基于 JVM 构建的语言必须越过障碍来提供部分适用 TCO 的假象。因此，我总是非常怀疑地使用任何面向 JVM 的函数式语言。这也是我没有成为 Clojure 的粉丝的原因。

---

这就是原因之一。Scheme/Racket 是基于 λ 演算的编程语言的合理实现。你可能已经注意到，我没有使用“函数式”一词来描述 Scheme。那是因为虽然它主要是函数式的，但并不会一直偏向不可变性。尽管不鼓励使用它，Scheme 意识到在某些真实环境下可能会需要修改数据，并且它允许在不需要辅助装置的情况下使用它。在这里，我不会与纯粹主义者争论为什么这是或者不是一个好主意，但这与我稍后将在本文中讨论的内容有关。

## 值传递的

Those of you who know the details of the λ-calculus may have recognized why I chose to make this distinction. Remember my history: I cut my functional teeth on Miranda which is a **lazy** functional language (as is Haskell). This means that expressions are evaluated **only** when their values are needed. It is also how the original λ-calculus is defined. This means that arguments to a function are evaluated when they are used, not when the function is called.

This distinction is subtle, and it does have some yummy mathematical properties, but it has far-reaching implications on “playing back the code” in your head. There are many instances where this hits you as a surprise (even for experienced programmers), but there’s one that you might perhaps relate to more than others.

As a programmer, one of the most difficult bugs to deal with in your career are the ones where printing something on the screen makes the bug go away. In a lazy functional language, printing something forces the evaluation of an expression, where in the buggy case, it was perhaps not being evaluated. So, printing values as a debugging tool becomes suspect, since it critically changes how the program is behaving. I don’t know about you, but for me, printing is a tool that someone will have to pry from my cold, dead fingers.

There are other subtleties too about lazy evaluation being used everywhere in the language that makes it a **much less appealing** choice for me. I don’t ever want to guess when a certain expression is being evaluated. Either evaluate it or don’t. Don’t make me guess when, especially if it is going to happen (or not) deep inside some library.

Call-by-value has some implications in how to prove formal theorems about programs, but thankfully there exists a beast called the call-by-value λ-calculus that we can rely on if necessary.

---

Scheme allows you to have **explicit** lazy evaluation, through the use of **thunks** and mutations, which can be conveniently abstracted away so that you have call-by-need when you need it. That brings us to the next bit.

## 主要是函数式的

Functional programming is great. Playing back functional code in your head is simple: The code is easy to read and the lack of mutations reassuring. Except when it isn’t enough.

I’m not a proponent of mutations willy-nilly, but I am a proponent of their judicious use. Like the example of lazy evaluation above, I can fully support the use of mutation to **implement** a functional feature. Mutations exist at the periphery of all software. For some abstractions, the most expressive thing to do might be to pull in the mutation into a nice little abstraction. For example, a message-passing bus is a mutation filled abstraction, but it can have very elegant, purely functional, pieces of code hanging off of them without having to carry around spurious state variables or assistive devices like monads.

Like any tool, non-mutating code taken to the extreme can be harmful. A language that gives me judicious use of mutations to implement a large body of code in a more elegant fashion will always win over a language that forces a (mostly good) construct in every situation.

So, Scheme’s inherent bias towards no-mutations, but its “use it if you must” attitude towards mutations (or **side-effects** as they are called), makes it a much more effective tool for me.

I brought up monads above, so it’s a good idea to talk a little about them since they are the pure-functional way of gaining effects. Having written a Ph. D. thesis about them, I think I have some idea about them. I love the elegance and the sheer beauty of the Eugenio Moggi’s [original conception](https://person.dibris.unige.it/moggi-eugenio/ftp/ic91.pdf) of Monads. The idea of separating a computation from the value produced by that computation and then reifying that computation into a type is **brilliant** in every sense of the word. It’s a great way to mathematically understand the semantics of programming languages.

As a programming tool, I have mixed emotions about it. It’s a complicated way of isolating effects and then threading them through your whole program, when you could easily create simple abstractions that make the rest of your program easier to work with. As an eminent type theorist (who shall remain nameless) once said “Monads are useful only every other Tuesday.”

Monads are assistive devices that are forced on to functional languages to provide a functional fence around side effects. The problem is that the fence is “infectious” and everything that touches the fence must now also be fenced and so on until you reach the end of the playground. So rather than face up to a side-effect and handling it elegantly in an abstraction, you’re now given a complex abstraction that you’re forced to carry with you everywhere. On top of that, they don’t compose very well either.

I’m not arguing that Monads are completely useless. They do work well in some cases (“every other Tuesday”), and I do use them when they work. But when they are the sole mechanism with which to approach computations, they severely cripple the expressiveness of a programming language.

---

This brings us to the next, and perhaps the most controversial opinion I hold.

## 动态类型的

The world today is going on and on about typed languages. TypeScript is considered a savior in the dogged world of JavaScript. Python and JavaScript are decried for their lack of static typing. Types are considered essential to documentation and communication in large programming projects. Engineering managers throw themselves at the feet of type inferencing to protect them from mediocre software engineers producing poor quality code.

There are two types of static typing. “Old-style” static typing is used in C, C++, Java, Fortran where the types are used by a compiler to produce more efficient code. Type checkers here are very restrictive, but don’t pretend to provide any guarantees beyond your basic type checking. They are, at least, **understandable**.

Then there’s the new kind of static typing with its roots in the Hindley-Milner type system which brought on a new beast: type inferencing. This gives you the illusion that not all types need to be declared. If you’re playing by the rules, you’ll get the benefits of old-style static typing, but also some cool new things like polymorphism. This view is also understandable.

But it has taken on a new meaning in the last couple of decades: Static typing is a form of compile-time error checking, so it will help you produce better quality code. It is as if static typing is a magical theorem prover that will verify some deep properties of your program. This is where I call **bullsh*t.** I have never had a static type checker (regardless of how sophisticated it is) help me prevent anything more than an obvious error (which should be caught in testing anyway).

What static type checkers do, however, is get in my way. Always. Without fail. As a programmer, I carry around **invariants** (which is a fancy name for properties about things in my program) in my head all the time. Only **one** of those invariants is its type. Having a tool that can verify that invariant is sort of cool, when you first encounter it (as I did with Miranda).

But it’s a **stupid** tool. It can only do so much. So, you now end up with artificial rules about how to satisfy this tool. And things that I know are perfectly fine to do (and can justify or even formally prove for my use cases) are suddenly not. So now I must redesign my program to meet the needs of a limited tool. Most people are perfectly happy with this tradeoff, and they slowly change the way they think about software to fit within the confines of its limitations.

In old Hindi movies, the censor board would not allow kissing onscreen. So romantic scenes would always cut to flowers bumping against one another or a pair of birds flying away together or something silly like that. This is what static type checkers feel like. We get presented with a beautiful language that promises us the right to freedom of speech, but then we get slapped with a censorship board policing the speech. We end up having to say what we mean with metaphors and symbolism for what is an only marginal benefit.

What a **great** tool would do, is allow me to state and prove **all** my invariants at compile time. This, of course, is ultimately unsolvable. So given the choice between a crappy tool (static type checkers) and no tool, I have always gravitated towards no tool since I prefer to not have any artificial constraints on my programs. Hence dynamic typing.

All programs (statically typed or otherwise) must deal with run-time exceptions. Well written programs run into fewer of those, badly written ones run into more of them. Static type checkers move some from the badly written camp to the somewhat well-written camp. What improves (and guarantees) software quality is **rigorous testing**. To deliver high-quality software, there is no other solution. Whether or not you use static typing has only a marginal effect on the quality of your software. Even that effect vanishes when you have well-designed programs written by thoughtful programmers.

In other words, static typing is pointless. It has, maybe, some documentary value, but it does not substitute documentation on other invariants. For example, your invariant might be that you’re expecting a monotonically increasing array of numbers with a mean value of such and such and a standard deviation of such and such. The best any static type checking will let you do is `array[float]`. The rest of your invariant must be expressed in words documenting the function. So why subject yourself to the misery of `array[float]`?

Dynamic typing allows me to express what I want to express in my programs without getting in my way. I can specify my invariants either as explicit checks or as documentation depending upon the needs of the program.

But, like everything else, sometimes you need to know types statically. For example, I work a lot with images, and it helps to know that they are `array[byte]`, and I have pre-baked operations that will work magically fast on them. Scheme/Lisp/Racket all provide ways of being able to do this **when you need it**. In Scheme it’s implementation dependent, but Racket comes with a `Typed Racket` variant that can be intermixed with the dynamically typed variant. Common Lisp allows for types to be declared in specific contexts, primarily for the compiler to implement optimizations where possible.

---

So, again, Scheme/Lisp/Racket give me the benefits of types **when I need them** but don’t force the constraints on me everywhere. It’s the best of both worlds.

## 基于 S-表达式的

And finally, we come to one of the most important reasons I use Lisp. For those of you who have never heard the term s-expression before, it stands for a peculiar syntactic choice in Lisp and its children. All syntactic forms are either **atoms** or **lists**. Atoms are things like names (symbols), numbers, strings, and booleans. And lists look like “( … )” where the contents of the list are also either lists or atoms, and it is perfectly fine to have an empty list “()”. That’s it.

There are no infix operations, no operator precedence, no associativity, no spurious separators, no dangling else’s, nothing. All function applications are prefix, so instead of saying “(a + b)”, you would say “(+ a b)”, which further allows you the flexibility of saying things like “(+ a b c)”. “+” is simply the name of a function that you can redefine if you wish.

There are “keywords” that direct a given list to be evaluated in a certain way, but the rules of evaluation are hierarchical and well-defined. In other words, s-expressions are effectively tree-based representations of your programs.

This simplicity of syntax is often confusing for newbies. It has probably turned off a lot of programmers who were unfortunate enough to not be exposed to the beauty of this way of writing programs.

The biggest advantage of this form of syntax is a form of minimalism — you don’t need spurious syntactic constructs to convey concepts. Concepts are conveyed entirely by the function names or the syntactic keywords being used. This produces strangely compact code. Not always compact in terms of the number of characters, but compact in terms of the number of concepts you need to keep in mind when reading the code.

That’s not even the half of it. If your programs are trees, you can write programs to manipulate those trees. Lispers (and Schemers and Racketeers) call these things **macros**, or **syntactic extensions**. In other words, you can **extend** the syntax of your language to introduce new abstractions.

---

There are countless cool syntactic extensions written by generations of Lispers, including object systems, language embeddings, special-purpose languages, and so on. I have used this to develop syntactic features that allowed me to use Scheme to build things that span the gamut from sensor networks to digital signal processing, to e-commerce pricing strategies. There is not one other language in the world that even comes close to supporting this level of syntactic extension. It is something that I (and a host of other Lispers) cannot live without.

## 结论

综上所述，就是：

> 一种基于 S-表达式的、动态类型的、主要是函数式的、值传递的基于 λ 演算的语言。

This is why I still use Scheme/Racket/Lisp and will probably use it for the rest of my life. Do I use other languages? Sure — lots of them. None of them hold a candle to these. **Especially the newer ones.** It appears that inventing new languages is an exercise each new generation of ill-informed software engineers goes through when older languages are **much** better than anything they might come up with even in their dreams (I present to you Ruby which although nominally has its roots in Lisp, begs the question: **why didn’t you just use Lisp itself**).

Like every bias, mine has shortcomings too. Prior to about 15 years ago, all third party SDK’s were written entirely in C/C++ which could easily interoperate with Lisp. The coming of Java has put a damper on it since the JVM does not interoperate well with Scheme/Lisp/Racket. This has made it harder and harder to incorporate third-party libraries into my programs without doing a lot of work.

Another shortcoming is that with the rise of APIs on the internet, most vendors release libraries in the common languages of the internet (Java, Ruby, Python, JavaScript, and more recently Go and Rust), but never in Scheme/Lisp/Racket unless it is a community contribution and also equally infrequently in C/C++. That often leaves me in a position of having to build an API layer myself which of course is not very practical. Racket (which is my current favorite), has a pretty active community that does contribute towards the big things, but it is usually behind the times a little and when it comes to the latest and greatest, I’m often left holding the bag. It might be the big reason I adopt Clojure in the future, but that remains to be seen.

It has, of course, not deterred me yet. If anything, it has made me more aware that the Lisp community has to spread its word farther and wider and bring on a new generation of Lispers to fortify the eco-system in a rapidly changing environment.

And lastly, there’s the issue of performance. First, let’s put the common misconception to rest: Lisp is **not** an interpreted language. It is **not** slow, and all implementations come with lots and lots of levers to tweak performance for **most** programs. In some cases, the programs might need assistance from faster languages like **C** and **C++** because they are closer to the hardware, but with faster hardware, even that difference is becoming irrelevant. These languages are perfectly fine choices for production quality code, and are probably more stable than most other choices out there due to decades of work that has gone into them.

I do recognize, learning Scheme/Lisp/Racket is a wee bit harder than learning Python (but a lot easier than learning Java/JavaScript). You will, however, be a much better programmer if you do and you will come to appreciate the beauty of these languages such that nothing else will suffice.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
