
> * 原文地址：[What’s So Great About Redux?](https://medium.freecodecamp.org/whats-so-great-about-redux-ac16f1cc0f8b)
> * 原文作者：[Justin Falcone](https://medium.freecodecamp.org/@modernserf)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-so-great-about-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-so-great-about-redux.md)
> * 译者：[ZiXYu](https://github.com/ZiXYu)
> * 校对者：[MJingv](https://github.com/MJingv), [calpa](https://github.com/calpa)

# Redux 有多棒？

![](https://cdn-images-1.medium.com/max/1600/1*BpaqVMW2RjQAg9cFHcX1pw.png)

Redux 能够优雅地处理复杂且难以被 React 组件描述的状态交互。它本质上是一个消息传递系统，就像在面向对象编程中看到的那样，只是 Redux 是通过一个库而不是在语言本身中来实现的。就像在 OOP 中那样，Redux 将控制的责任从调用方转移到了接收方 - 界面并不直接操作状态值，而是发布一条操作消息来让状态解析。

一个 Redux store 是一个对象， reducers 是方法的处理程序，而 actions 是操作消息。`store.dispatch({ type: "foo", payload: "bar" })` 相当于 Ruby 中的 `store.send(:foo, "bar")`。中间件的使用方式类似于面向切面编程 (AOP, Aspect-Oriented Programming) (例如：Rails 中的 `before_action`)。 而 React-Redux 的 `connect` 则是依赖注入。

#### 为什么它值得称赞？

- 上文中控制权限的转移保证了当状态转换的实现变化时， UI 并不需要更新。添加复杂的功能，例如记录日志、撤销操作，甚至是时光穿越调试 (time travel debugging)，将变得非常简单。集成测试只需要确认派发了正确的 actions 即可，剩下的测试都可以通过单元测试来完成。
- React 的组件状态对于那些在 app 中触及多个部分的状态而言非常笨重，例如用户信息和消息通知。Redux 提供了一个独立于 UI 的状态树来处理这些交叉问题。此外，让你的状态存活于 UI 之外使实现数据可持久化之类的功能变得更简单 - 你只需要在一个单独的地方处理 localStorage 和 URL 即可。
- Redux 的 reducer 提供了难以想象的灵活方式来处理 actions - 组合，多次派发，甚至 `method_missing` 式解析

#### 这些都是不常见的情况。在常见情况下呢？

好吧，这就是问题所在。

- 一个 action **可以**被解释为一个复杂的状态转换，但是它们中的绝大对数只是用来设置一个单独的值。Redux 应用倾向于结束这一大堆只用于设置一个值的 action，这里有个用于区分在 Java 中手动写 setter 函数的标志。
- 你**可以**在你 app 的任意一个地方使用状态树的任一部分，但是对于大多数状态来说，它们一对一的对应了某个 UI 中的一部分。将这种状态放在 Redux 中，而不是放在组件里，这只是**间接**而非**抽象**。
- 一个 reducer 函数**可以**做各种奇怪的元编程，但是在绝大多数情况下它只是基于某个 action 类型的单一派发。这在 Elm 和 Erlang 这种语言中是很好实现的，因为在这些语言中，模式匹配是简洁而高效的，但是在 JavaScript 中使用 `switch` 语句来实现就显得格外笨拙。

但是更可怕的事是，当你花费了所有的时间在常见情况下编写代码模板时，你会忘记，在某些特殊情况下会有更好的解决方案**存在**。你遇到了一个复杂的状态转换问题，然后调用了很多用于设置状态值的 action 来解决了它。你在 reducer 中重复定义了很多状态，而不是在 app 中分发同一个子状态。你在很多 reducer 中复制粘贴了各种 switch case 而不是把其中的某些方法抽象成共有的方法。

这很容易把这种错误仅仅当成 “操作员误差” - 是他们没有查看操作手册，就像可怜的工匠责怪他们手上的工具一样 - 但是这种问题出现的频率应当引起一些关注。如果大多数的人都错误的使用一款工具，那我们又该如何评价它呢？

#### 所以我们应该避免在常见情况下使用 Redux，而把它留给特殊情况吗？

这是 Redux 开发团队给你的建议，也是我给我的开发团队成员的建议：除非使用 setState 难以解决问题，不然尽量避免使用 Redux。但是我不能让我自己也遵从我自己的规定，因为总是有**某些**原因让你想要使用 Redux。 可能你有一系列的 `set_$foo` 消息，而且设置这些值**也**会更新 URL，或者重设某些瞬态值。可能你有一些明确和 UI 一对一的状态值，但是你**也**希望纪录或者可以撤销它们。

事实是，我不知道如何写，更不要说**指导写**“好的 Redux”。我曾经参与的每个 app 都充斥着 Redux 的反模式，因为我想不到更好的解决方案或者我无法说服我的队友来改变它。如果一个 Redux “专家” 写出来的代码也如此平庸，那我们还能指望一个新手怎么做呢？无论如何，我只是希望能够平衡一下现在大行其道的 “Redux 完成所有事” 解决方案，希望每个人都能在他们适用的情况下理解 Redux。

#### 所以我们在这种情况下该怎么做呢？

所幸的是，Redux 足够灵活，我们可以使用第三方库集成到 Redux 里来解决常见情况 - 例如 [Jumpstate](https://github.com/jumpsuit/jumpstate)。更清晰地说，我不认为 Redux 专注于处理底层事务是一种错误的行为。但是将这些基础的功能外包给第三方来完成会造成额外的认知和开发负担 - 每个用户都需要从这些部分里构建自己的框架。

#### 有些人执着于此

而我正是其中之一。但并不是所有人都是。个人而言，我爱 Redux，尽可能地使用它，但是我**仍旧**喜爱尝试新的 Webpack 设置。但是我并不代表绝大多数人群。我被实现灵活解决方案的心**驱使**着，在 Redux 的顶层写了很多我自己的抽象方法。但是看着那些一群六个月前就离职的、从来没留下开发记录的开发工程师所写的抽象程序，谁又能有动力呢？

其实很可能你根本**不会**遇到那些 Redux 特别擅长处理的难题，尤其如果你是一个团队里的新人，这些问题基本上会交给更资深的工程师处理。你在 Redux 上累积的经验就是 “用着每个人都在用的垃圾库，把所写的代码都重复写上好几次”。 Redux 简单到你**可以**不深入理解也能机械地使用它，但是那是一种很无聊也没什么提高的体验。

这让我回想起了我之前提出的一个问题：如果大多数的人都在错误的使用一款工具，那我们又该如何评价它呢？一个好的工具不仅仅应该有用且耐用 - 它应该让使用者有个好的使用体验。能舒服使用它的场景就是正确的场景。一个工具的设计不仅仅是为了它要完成的任务，同样也要考虑到它的使用者。一个好的工具可以反映出工具制作者对于使用者的同情心。

[![](https://ws2.sinaimg.cn/large/006tNc79ly1fhzg65gw1bj31280dutam.jpg)](https://twitter.com/stevensacks/status/884947742975377409)

那我们的同情心又在哪呢？为什么我们的反应总是 “你错误地使用了它” 而不是 “我们可以把它设计地更容易去使用” 呢？

这里有个函数式编程界的相关现象，我喜欢叫它 **Monad 指南的诅咒**：解释它们是怎么工作的是非常简单的，但是解释清楚它们这么做是有意义的就出乎意料地困难了。

#### 在这篇文章中你真的要读到一段 monad 指南？

Moand 是一个在 Haskell 常见的开发模式，在计算机中的很多地方都被广泛使用 - 列表，错误处理，状态，时间，输入输出。这里有个语法糖，你可以以 `do` 表达式的形式像输入指令代码一样来输入一系列的 monad 操作，就好像 javascript 中的 generator 可以让异步函数看起来像同步一样。

第一个问题是，用 monad 用来做什么来描述 monad 是不准确的。[Haskell 曾引入 Monad 以解决副作用和顺序计算](http://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf)，但是事实上 monad 作为一个抽象概念并不能解决副作用和顺序化，它们是一系列规则，规定了一组函数如何交互，并没有什么固定的含义。关联性的概念**适用于**算术集合操作、列表合并和 null 传播，但是它完全独立于这些操作。

第二个问题是在一些小问题上，用 monad 来解决问题更繁琐了 - 至少**看起来**更复杂了 - 相比于指令式操作而言。给一个可选类型指定它的 `Maybe Type` 明显比验证一个模糊的 `null` 类型更安全，但是这又会让代码变得更难看。使用 `Either` 类型来进行错误处理通常比那些随处可能 `throw` 错误的代码更容易理解，但是 throw 操作的确比手动传值更简洁。而副作用 - 状态，IO 等 - 在指令式语言中更是微不足道的。函数式编程爱好者们（包括我）会说副作用在函数式语言中**太简单**了，但是让别人相信任何一种语言很简单本身就是一件很难的事。

而 monad 真正的价值只能在宏观尺度体现出来 - 并不是这些用例都遵循着 monad 规则，但是这些用例都遵循着**同样**的规则。能够作用于一个用例的操作就可以作用于**每个**用例：把一对列表压缩成一个存储着对值的列表就和把一对 promise 函数融合成一个处理两个结果的 promise 是“一样的”。

#### 所以呢？

现在 Redux 有同样的问题 - 它很难学习并不是因为它很难反而是因为它太**简单**。理解并不是认知的障碍，而要相信它的核心设计理念，我们才能通过归纳来延伸其它的知识。

这种思想是很难共享的，因为核心思想是无趣的真理（避免副作用）或者做一些无意义的抽象（`(prevState, action) => nextState`）。任何单独的例子都不会对这种理解有任何帮助，因为这些例子只是展示了 Redux 的细节但并不能展现它的核心思想。

一旦我们开始✨接受别人的思想✨，我们中的很多人就会立刻忘掉自己之前的一些想法。我们忘记了我们的理解只能从我们自己一次又一次的失败和误解中获得。

#### 所以你的建议是？

我觉得我们应该承认我们遇到了这个问题。Redux 是一种[简单却不容易](https://www.infoq.com/presentations/Simple-Made-Easy)的语言。这是一种可以理解的设计选择，但是仍旧是一种权衡。对于一门牺牲了某些简单性来让它更便于使用的语言，还是有很多人都会从中获益的。但是，很多大型社区甚至不觉得这是一种已经做出的权衡。

我认为对比 React 和 Redux 是一件很有意思的事，因为广泛来说 React 是更复杂的，它有着明显更多 API 接口，同时它也在某种意义上更容易使用和理解。而 React 唯一必须的 API 接口是 `React.createElement` 和 `ReactDOM.render` - 状态，组件生命周期，甚至 DOM 事件可以在别的地方处理。React 中的这些特性让它变得更复杂，但是也让它变得更*出色*。


“原子化状态”是个抽象概念，在你理解它之后可以指导你的开发，但是不管你理不理解这个概念，你都可以在 React 组件中调用 `setState`，来实现原子化状态管理。这并不是一个完美的解决方案 - 彻底替换状态或者强制更新有着比它更高的效率，而且它是一个异步调用的方法还会产生一些 bug - 但是 React 将 `setState` 作为一个调用的方法而不是一个专业术语是一个很好的做法。

Redux 的开发组和社区都[强烈反对增加 Redux 的 API 数量](https://github.com/reactjs/redux/issues/2295)，但是现在将一堆小型开发库融合在一起的做法对于专家而言是乏味的，而对于新手而言是费解的。如果 Redux 不能内置一些小功能来对常见情况做一些支持，那么我们需要一个“更好”的框架在常见情况下来取代它。[Jumpsuit](https://github.com/jumpsuit/jumpsuit) 可以作为一个不错的开始 - 它将“action”和“state”的概念转化为了可调用的方法，同时保留了它们多对多的特性 - 但是事实上，这个库其实并不关心这个优化本身。

讽刺的是：Redux **存在的意义** 是“开发者体验”：Dan 建立了 Redux 因为他希望理解和重建 Elm 的时光穿越调试。但是随着它开发了它自己的特性 - 进入了 React 生态系统的 OOP 运行环境 - 它牺牲了一些开发者的体验以换取可配置性。这让 Redux 得以蓬勃发展，但是这是个人性化开发框架明显的缺失。我们，Redux 社区，准备好了吗？


---

**感谢** [*Matthew McVickar*](https://medium.com/@matthewmcvickar)*, *[*a pile of moss*](https://medium.com/@whale_eat_squid)*, *[*Eric Wood*](https://medium.com/@eric_b_wood)*, *[*Matt DuLeone*](https://twitter.com/Crimyon)*, 和 *[*Patrick Thomson*](https://twitter.com/importantshock)* review 本文。*

**备注：**

**[1] 为什么要在 React / JS 和 OOP 之间做明显的区分？JavaScript 是面向对象的，但是不是基于类（class-based）的。**

OOP 类似于函数式编程，是一种方法，不是某个语言特性。有些语言对于 OOP **支持**地特别好，或者有一些专门为 OOP 定制的标准库，但是如果你对它的了解够深，你可以用任何语言写出面向对象风格的代码。

JavaScript 有一种数据类型 Object，同时 JS 中**大多数**数据类型可以以 Object 的形式来处理和解析，从这种角度来说你可以对任何数据类型调用某些同样的方法，除了 `null` 和 `undefined`。但是在 ES6 的 Proxy 出现之前，每个 Object 中调用的“方法”类似于一种字典查找，`foo.bar` 总是去查找 foo 对象中的“bar”属性或者它的原型链。而比如在 Ruby 这种语言中，`foo.bat` 会发一条消息 `:bar` 到 foo 对象中 - 这条消息可以被**拦截**或**解析**，它并不是必须做一个字典查找。

Redux 是一种基于 JavaScript 已存在的对象系统上更慢和更复杂的对象系统，reducer 和 middleware 相当于保存着状态的 JavaScript 对象的拦截器和解析器。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
