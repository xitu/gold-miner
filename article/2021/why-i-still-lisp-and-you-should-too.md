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

Miranda 并不是一种特别快的语言，因此执行速度是一个问题。Miranda 还是一种具有 Standard-ML 式类型推断功能的静态类型语言。一开始，我迷上了类型系统。然而，随着时间的推移，我开始鄙视它。虽然它帮助我掌握了一些编译时的东西，但大部分时候都在妨碍我（稍后再介绍）。

大约一年后，我终于在印第安纳大学和丹·弗里德曼（因《The Little LISPer》/《The Little Schemer》而著名）一起学习编程语言。这是我于 Scheme 和 Lisp 世界的起点。我终于知道我找到了表达我的程序的完美媒介。在过去的25年中，这一点从未改变。

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

这种特性被称为**尾调用优化**（**或 TCO**），已经出现了几十年。在评价编程语言现状的时候发现没有现代语言支持它，这是很令人沮丧的。因为新的语言出现并试图把 JVM 作为运行架构，所以这对于 JVM 更是个问题。JVM 不支持这个特性，所以基于 JVM 构建的语言必须越过障碍来提供部分适用 TCO 的假象。因此，我总是非常疑虑地使用任何面向 JVM 的函数式语言。这也是我没有成为 Clojure 的粉丝的原因。

---

这就是原因之一。Scheme/Racket 是基于 λ 演算的编程语言的合理实现。你可能已经注意到，我没有使用“函数式”一词来描述 Scheme。那是因为虽然它主要是函数式的，但并不会一直偏向不可变性。尽管不鼓励使用它，Scheme 意识到在某些真实环境下可能会需要变异（mutation），并且它允许在不需要辅助装置的情况下使用它。在这里，我不会与纯粹主义者争论为什么这是或者不是一个好主意，但这与我稍后将在本文中讨论的内容有关。

## 值传递的

那些知道 λ 演算细节得人可能已经知道我为什么选择做这种区分。Remember my history: 我小试牛刀的 Miranda 是一种**惰性**函数式语言（和 Haskell 一样）。这意味着**只有**在需要表达式的值时才对它们进行求值。这也是 λ 演算最原始的定义。这意味着，函数的参数在使用时进行求值，而非在调用函数时。

这种区别是微妙的，并且确实具有一些很好的数学特性，但是对你再脑海中“回放代码”有着深远的影响。在很多情况下，这种情况会让您感到意外（即使是经验丰富的程序员），但在某些情况下，您可能需要比其他人做更多猜想。

作为程序员，在您的职业生涯中最难处理的 BUG 之一，就是那些在屏幕上打印某些东西会使这个 BUG 消失的情况。在惰性函数式语言中，打印某些内容会强制对表达式进行求值，而在发生 BUG 的情况下，它可能没有被求值。因此，将值打印为调试工具变得令人疑虑，因为它会严重改变程序的行为方式。我不知道你怎么看，但对我来说，打印是必须有人从我冰冷而僵硬的手指上撬下来的工具。

在语言中随处使用惰性求职也有其他一些微妙之处，这使得它对我来说是个**吸引力不大**的选择。我永远都不想猜测何时对某个表达式求值。要么求值，要么不求值。不要让我猜测何时，尤其是如果它会在某个库的深处发生（或不会发生）。

值传递对如何证明有关程序的形式理论有一些意义，但值得庆幸的是，存在一种名为值传递 λ 演算的野兽，我们可以在需要时可以依靠。

---

通过使用 **形式转换**和变异，Scheme 允许您**显式**地进行惰性求值，可以方便地将其抽象化，以便您在需要时进行按需调用。这使我们进入了下一个阶段。

## 主要是函数式的

函数式编程很棒。在您的脑海中回放功能代码很简单：代码易于阅读，并且无需担心变异。除非这还不够。

我不赞成随意变异，但我赞成明智地使用变异。像上面的惰性求值的例子一样，我可以完全支持使用变异来**实现**函数特性。变异存在于所有软件周围。对于某些抽象，最富有表现力的做法可能是将变异引入一个小而美的抽象中。例如，消息传递总线是一种充满变异的抽象，但它可以具有非常优雅，纯函数的代码段，而不必携带伪造的状态变量或诸如单子之类的辅助装置。

像其他任何工具一样，采取极端的非变异编程可能会有害。一种能够明智地使用变异以更优雅的方式实现大量代码的语言，总比在每种情况下都强制使用一种（多数时候不错的）构造的语言要好。

因此，Scheme 内在的倾向于不变异，但是它对变异（或称作**副作用**）的“如果必须用就用”的态度使它成为我更有效的工具。

我在上面提到了单子，因此最好先讨论一下单子，因为它们是产生作用的纯函数方式。在写完有关它们的博士学位论文后，我想我对它们有所了解。我喜欢欧金尼奥·莫吉的单子的[原始概念](https://person.dibris.unige.it/moggi-eugenio/ftp/ic91.pdf)的优雅和纯粹的美。将计算与由该计算产生的值分离出来，然后将该计算归类为一个类型的想法在各个方面上来说都是**才华横溢的**。这是数学上理解编程语言语义的好方法。

作为一种编程工具，我对此百感交集。当您可以轻松创建简单的抽象来简化程序的其余部分时，这是一种分离作用然后将其贯穿整个程序的复杂方法。一位（不愿意透露姓名的）杰出的类型理论家曾经说过：“单子仅在隔周星期二有用。”

单子是一种辅助装置，必须使用函数式语言在副作用外围提供函数围栏。问题在于，围栏是“传染性的”，接触围栏的所有东西现在也必须被围起来，以此类推，直到到达操场的尽头。所以你现在不必面对副作用并优雅地进行抽象处理，而是获得了一个不得不带到各处的复杂的抽象。最重要的是，它们的协作也不太好。

我并不是说单子完全没有用。它们在某些情况下（“隔周星期二”）运行良好，我在工作时也会用它们。但是，当它们是进行计算的唯一机制时，就会严重削弱编程语言的表达能力。

---

这将我们带入下一个观点，也许是我的观点中最具争议的。

## 动态类型的

当今世界正围绕着类型化语言不断发展。TypeScript 被认为是 JavaScript 顽固世界的一个救星。Python 和 JavaScript 因缺乏静态类型而备受诟病。在大型编程项目中，类型被认为对于文档和沟通至关重要。工程经理拜倒在类型推断面前以保护他们原理普通软件工程师产生的劣质代码的侵害。

静态类型有两种。 编译器在 C、C++、Java、Fortran 中使用“老式”静态类型来产生效率更高的代码。这里的类型检查器有严格的限制，但是除了基本的类型检查之外，不要假装提供任何保证。它们至少是**可以理解**的。

然后是一种新的静态类型，它起源于 Hindley-Milner 类型系统，它带来了新的野兽: 类型推断。这给你一种并非所有类型的需要声明的错觉。如果您遵守规则，那么您将获得老式静态类型的好处，以及多态性等新奇事物。 这种观点也是可以理解的。

但是在最近的几十年中它具有了新的含义：静态类型是编译时错误检查的一种形式，因此它将帮助您产生质量更高的代码。就好像静态类型是神奇的定理证明，能够验证程序的某些深层属性一样。这就是我称之为**bullsh*t**的地方。我从未见过任何一种静态类型检查器（无论它有多复杂）能帮助我防止发生明显的错误（你还是应该在测试中捕获它）。

但是，静态类型检查器的作用是妨碍我的。总是成功。从不落空。作为程序员，我一直在脑海里常存**不变式**（这是我程序中有关事物的属性的奇特名称）。这些不变式中只有**一个**是它的类型。当您初次遇到不变性时，拥有一个可以验证它的工具是很酷的（就像我在 Miranda 上做的）。

但这是一个**愚蠢**的工具。 它只能做这么多。 因此，您现在最终获得了有关如何满足此工具的人为规则。而我所知道的完全可以做（并且可以为我的用例辩护，甚至可以正式证明）的事情突然间就不能了。因此，现在我必须重新设计程序，以满足限制工具的需求。大多数人都对这种折衷感到完全满意，并且他们会慢慢改变他们对软件的看法，以适应其局限性。

在老印度电影里，电影检查委员会不允许在银幕上接吻。因此，浪漫的场景总是会被切成花朵相撞，或者成对的鸟儿一起飞走，或者其他像这样的傻事。这就是静态类型检查器的感觉。 我们以一种优美的语言向我们展示，它向我们保证了言论自由的权利，但随后语言检查委员会给了我们一巴掌。我们最终不得不使用隐喻和象征，这是唯一的边际效益。

What a **great** tool would do, is allow me to state and prove **all** my invariants at compile time. This, of course, is ultimately unsolvable. So given the choice between a crappy tool (static type checkers) and no tool, I have always gravitated towards no tool since I prefer to not have any artificial constraints on my programs. Hence dynamic typing.

All programs (statically typed or otherwise) must deal with run-time exceptions. Well written programs run into fewer of those, badly written ones run into more of them. Static type checkers move some from the badly written camp to the somewhat well-written camp. What improves (and guarantees) software quality is **rigorous testing**. To deliver high-quality software, there is no other solution. Whether or not you use static typing has only a marginal effect on the quality of your software. Even that effect vanishes when you have well-designed programs written by thoughtful programmers.

In other words, static typing is pointless. It has, maybe, some documentary value, but it does not substitute documentation on other invariants. For example, your invariant might be that you’re expecting a monotonically increasing array of numbers with a mean value of such and such and a standard deviation of such and such. The best any static type checking will let you do is `array[float]`. The rest of your invariant must be expressed in words documenting the function. So why subject yourself to the misery of `array[float]`?

Dynamic typing allows me to express what I want to express in my programs without getting in my way. I can specify my invariants either as explicit checks or as documentation depending upon the needs of the program.

But, like everything else, sometimes you need to know types statically. For example, I work a lot with images, and it helps to know that they are `array[byte]`, and I have pre-baked operations that will work magically fast on them. Scheme/Lisp/Racket all provide ways of being able to do this **when you need it**. In Scheme it’s implementation dependent, but Racket comes with a `Typed Racket` variant that can be intermixed with the dynamically typed variant. Common Lisp allows for types to be declared in specific contexts, primarily for the compiler to implement optimizations where possible.

---

因此，再次的，Scheme/Lisp/Racket **当我需要它们时**给我类型的优点，但不会在所有地方强加约束。 两全其美。

## 基于 S-表达式的

And finally, we come to one of the most important reasons I use Lisp. For those of you who have never heard the term s-expression before, it stands for a peculiar syntactic choice in Lisp and its children. All syntactic forms are either **atoms** or **lists**. Atoms are things like names (symbols), numbers, strings, and booleans. And lists look like “( … )” where the contents of the list are also either lists or atoms, and it is perfectly fine to have an empty list “()”. That’s it.

There are no infix operations, no operator precedence, no associativity, no spurious separators, no dangling else’s, nothing. All function applications are prefix, so instead of saying “(a + b)”, you would say “(+ a b)”, which further allows you the flexibility of saying things like “(+ a b c)”. “+” is simply the name of a function that you can redefine if you wish.

There are “keywords” that direct a given list to be evaluated in a certain way, but the rules of evaluation are hierarchical and well-defined. In other words, s-expressions are effectively tree-based representations of your programs.

This simplicity of syntax is often confusing for newbies. It has probably turned off a lot of programmers who were unfortunate enough to not be exposed to the beauty of this way of writing programs.

The biggest advantage of this form of syntax is a form of minimalism — you don’t need spurious syntactic constructs to convey concepts. Concepts are conveyed entirely by the function names or the syntactic keywords being used. This produces strangely compact code. Not always compact in terms of the number of characters, but compact in terms of the number of concepts you need to keep in mind when reading the code.

That’s not even the half of it. If your programs are trees, you can write programs to manipulate those trees. Lispers (and Schemers and Racketeers) call these things **macros**, or **syntactic extensions**. In other words, you can **extend** the syntax of your language to introduce new abstractions.

---

几代 Lisper 编写了很多很酷的语法扩展，包括对象系统，语言嵌入，专用语言等等。我用它来开发语法功能，使我可以使用 Scheme 来构建从传感器网络到数字信号处理再到电子商务定价策略的整个领域。世界上甚至没有其他语言可以接近这种对语法扩展的支持。这是我（和其他许多 Lisper）没法放弃的。

## 结论

综上所述，就是：

> 一种基于 S-表达式的、动态类型的、主要是函数式的、值传递的基于 λ 演算的语言。

这就是为什么我仍然使用 Scheme/Racket/Lisp 并可能在我的余生中继续使用的原因。我会使用其他语言吗？当然——很多。他们中没有一个能和前面几位相比。**尤其是比较新的那几个。**看起来发明新的语言对于新一代的孤陋寡闻的软件工程师是一种锻炼当老的语言**远远**好于他们做梦能想到的任何东西(我向你介绍名义上也起源于 List 的 Ruby，但也引出了一个问题：**为什么你不直接用 Lisp 本身**)。

和每一种偏见一样，我的也有短板。在大约 15 年前，所有的第三方 SDK 都是完全使用 C/C++ 编写的，可以轻松与 Lisp 互操作。Java 的到来泼了一盆冷水，因为 JVM 不能很好地与 Scheme/Lisp/Racket 互操作。这使得在不做大量工作的情况下将第三方库合并到我的程序中变得越来越难。

另一个缺点是随着API的在互联网上的崛起，大多数厂商都在为互联网的常见语言（Java、Ruby、Python、JavaScript, and 最近的 Go 和 Rust）发布库，但是从来不会为 Scheme/Lisp/Racket 发布，除非是社区贡献的，在 C/C++ 中也很少。这通常使我不得不自己构建一个 API 层，这当然不是很实用。Racket (这是我目前的最爱)，有一个非常活跃的社区，确实做出了很多巨大的贡献，但是它通常微微落后于时代，在谈到最新和最棒的时候，我罕被人提及。这可能是我将来采用 Clojure 的主要原因，但这仍有待观察。

当然，这还吓不住我。如果非要说有什么的话，就是这使我更加意识到 Lisp 社区必须将其口碑传播得越来越远，并带来新一代的 Lisper，以求在快速演进的环境中强化生态系统。

最后，还有性能问题。首先，让我们解决常见的误解：Lisp**不**是解释语言。它**不**慢，并且所有实现都有很多杠杆来调整**大部分**程序的性能。在某些情况下，程序可能需要诸如 **C** 和 **C++** 之类的更快语言的帮助，因为它们更接近硬件，但是有了更快的硬件，即使这种区别也变得无关紧要了。这些语言是生产质量代码的完美选择，并且由于在此之上数十年的工作，它们可能比现有的大多数其他选择更稳定。

我确实知道，学习 Scheme/Lisp/Racket 比学习Python困难一点点（但是比学习 Java/JavaScript 容易得多）。但是，如果您这样做的话，您将成为一个更好的程序员，并且您将逐渐体会到这些语言的美，以至于再没有其他语言能满足你。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
