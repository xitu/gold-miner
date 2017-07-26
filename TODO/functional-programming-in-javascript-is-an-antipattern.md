
> * 原文地址：[Functional programming in JavaScript is an antipattern](https://hackernoon.com/functional-programming-in-JavaScript-is-an-antipattern-58526819f21e)
> * 原文作者：[Alex Dixon](https://hackernoon.com/@alexdixon)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-in-javascript-is-an-antipattern.md](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-in-javascript-is-an-antipattern.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[LeviDing](https://github.com/leviding)、[xekri](https://github.com/xekri)

# JavaScript 的函数式编程是一种反模式

---

![](https://cdn-images-1.medium.com/max/1600/1*Y6orLTOgb6JFfjVdANVgCQ.png)

## 其实 Clojure 更简单些

写了几个月 Clojure 之后我再次开始写 JavaScript。就在我试着写一些很普通的东西的时候，我总会想下面这些问题：

> “这是 ImmutableJS 变量还是 JavaScript 变量？”

> “我如何 map 一个对象并且返回一个对象？”

> “如果它是不可变的，要么使用 <这种语法> 的 <这个函数>，否则使用 <不同的语法和完全不同行为> 的 <同一个函数的另一个版本>”

> “一个 React 组件的 state 可以是一个不可变的 Map 吗？”

> “引入 lodash 了吗？”

> “`fromJS` 然后 <写代码> 然后 `.toJS()`？”

这些问题似乎没什么必要。但我猜想我已经思考这些问题上百万次了只是没有注意到，因为这些都是我知道的。

当使用 React、Redux、ImmutableJS、lodash、和像 lodash/fp、ramda 这样的函数式编程库的任意组合写 JavaScript 的时候，我觉得没什么方法能避免这种思考。

我需要一直把下面这些事记在脑海里：

- lodash 的 API、Immutable 的 API、lodash/fp 的 API、ramda 的 API、还有原生 JS 的 API 或一些组合的 API
- 处理 JavaScript 数据结构的可变编程技术
- 处理 Immutable 数据结构的不可变编程技术
- 使用 Redux 或 React 时，可变的 JavaScript 数据结构的不可变编程

就算我能够记住这些东西，我依然会遇到上面那一堆问题。不可变数据、可变数据和某些情况下不能改变的可变数据。一些常用函数的签名和返回值也是这样，几乎每一行代码都有不同的情况要考虑。我觉得在 JavaScript 中使用函数式编程技术很棘手。

按照惯例像 Redux 和 React 这种库需要不可变性。所以即使我不使用 ImmutableJS，我也得记得“这个地方不能改变”。在 JavaScript 中不可变的转换比它本身的使用更难。我感觉这门语言给我前进的道路下了一路坑。此外，JavaScript 没有像 Object.map 这样的基本函数。所以像[上个月 4300 多万人](https://www.npmjs.com/package/lodash)一样，我使用 lodash，它提供大量 JavaScript 自身没有的函数。不过它的 API 也不是友好支持不可变的。一些函数返回新的数值，而另一些会更改已经存在的数据。再次强调，花时间来区分它们是很不划算的。事实大概如此，想要处理 JavaScript，我需要了解 lodash、它的函数名称、它的签名、它的返回值。更糟糕的是，它的[“collection 在先， arguments 在后”](https://www.youtube.com/watch?v=m3svKOdZijA)的方式对函数式编程来说也并不理想。

如果我使用 ramda 或者 lodash/fp 会好一些，可以很容易地组合函数并且写出清晰整洁的代码。但是它不能和 Immutable 数据结构一起使用。我可能还是要写一些参数集合在后而其他时候在前的代码。我必须知道更多的函数名、签名、返回值，并引入更多的基本函数。

当我单独使用 ImmutableJS，一些事变得容易些了。Map.set 返回全新的值。一切都返回全新的值！这就是我想要的。不幸的是，ImmutableJS 也有一些纠结的事情。我不可避免地要处理两套不同的数据结构。所以我不得不清楚 `x` 是 Immutable 的还是 JavaScript 的。通过学习其 API 和整体思维方式，我可以使用 Immutable 在 2 秒内知道如何解决问题。当我使用原生 JS 时，我必须跳过该解决方案，用另一种方式来解决问题。就像 ramda 和 lodash 一样，有大量的函数需要我了解 —— 它们返回什么、它们的签名、它们的名称。我也需要把我所知的所有函数分成两类：一类用于 Immutable 的，另一类用于其它。这往往也会影响我解决问题的方式。我有时会不自主地想到柯里化和组合函数的解决方案。但不能和 ImmutableJS 一起使用。所以我跳过这个解决方案，想想其他的。

当我全部想清楚以后，我才能尝试写一些代码。然后我转移到另一个文件，做一遍同样的事情。

![](https://cdn-images-1.medium.com/max/1600/1*FVBc2DWB09sW6QJwMxm_fw.png)

JavaScript 中的函数式编程。

![](https://cdn-images-1.medium.com/max/1600/1*MVU4TWwrkRMpQlmgkU9TuQ.png)

反模式的可视化。

我已孤立无援，并且把 JavaScript 的函数式编程称为一种反模式。这是一条迷人之路却将我引入迷宫。它似乎解决了一些问题，最终却创造了更多的问题。重点是这些问题似乎没有更高层次的解决方案能避免我一次有又一次地处理问题。

### 这件事的长期成本是什么?

我没有确切的数字，但我敢说如果不必去想“在这里我可以用什么函数？”和“我可否改变这个变量”这样的问题，我可以更高效地开发。这些问题对我想要解决的问题或者我想要增加的功能没有任何意义。它们是语言本身造成的。我能想到避免这个问题的唯一办法就是在路的起点就不要走下去 —— 不要使用 ImmutableJS 、ImmutableJS 数据结构、Redux/React 概念中的不可变数据，以及 ramda 表达式和 lodash。总之就是写 JavaScript 不要使用函数式编程技术，它看似不是什么好的解决方案。

如果你确定并同意我所说的（如果不同意，也很好），那么我认为值得花 5 分钟或一天甚至一周时间来考虑：保持在 JavaScript 路子上相比用一个不同的东西取代，耗费的长期成本是什么？

这个所谓不同的东西对于我来说就是 Clojurescript。它是一门像 ES6 一样的 “compile-to-JS” 语言。大体上说，它是一种使用不同语法的 JavaScript。它的底层是被设计成用于函数式编程的语言，操作不可变的数据结构。对我来说，它比 JavaScript 更容易，更有前途。

![](https://cdn-images-1.medium.com/max/1200/1*_bhmf-j96fW9qSuPm7yEsw.png)

### Clojure/Clojurescript 是什么？

Clojurescript 类似 Clojure，除了它的宿主语言是 JavaScript 而不是 Java。它们的语法完全相同：如果你学 Clojurescript，其实你就在学 Clojure。这意味着如果你了解了 Clojurescript，你就可以写 JavaScript 和 Java。“30 亿的设备上运行着 Java”；我非常确定其他设备上运行着 JavaScript。

和 JavaScript 一样，Clojure 和 Clojurescript 也是动态类型的。你可以 100% 地使用 Clojurescript 语言用 Node 写服务端的全栈应用。与单独编译成 JavaScript 的语言不同，你也可以选择写一个基于 Java 的 servrer 来支持多线程。

作为一个普通的 JavaScript/Node 开发者，学习这门语言及其生态系统对我来说并不困难。

### 是什么使得 Clojurescript 更简单？

![](https://cdn-images-1.medium.com/max/1600/1*cxIhT4wHooj6Cl50sryKIA.gif)

在编辑器中执行任意你想要执行的代码。
1. **你可以在编辑器中一键执行任何代码。** 的确如此，你可以在编辑器中输入任何你想写的代码，选中它（或者把光标放在上面）然后运行并查看结果。你可以定义函数，然后用你想用的参数调用它。你可以在应用运行的时候做这些事。所以，如果你不知道一些东西如何运作，你可以在你的编辑器的 REPL 里求值，看看会发生什么。
2. **函数可以作用于数组和对象。** Map、reduce、filter 等对数组和对象的作用都相同。设计就是如此。我们毋须再纠结于 `map` 对数组和对象作用的不同之处。
3. **不可变的数据结构。** 所有 Clojurescript 数据结构都是不可变的。因此你再也不必纠结一些东西是否可变了。你也不需要切换编程范式，从可变到不可变。你完全在不可变数据结构的领地上。
4. **一些基本函数是语言本身包含的。** 像 map、filter、reduce、compose 和[很多其他](https://clojure.github.io/clojure/)函数都是核心语言的一部分，不需要外界引入。因此你的脑子里不必记着 4 种不同版本的“map”了（Array.map、lodash.map、ramda.map、Immutable.map）。你只需要知道一个。
5. **它很简洁。** 相对于其他任何编程语言，它只需要短短几行的代码就能表达你的想法。（通常少得多）
6. **函数式编程。** Clojurescript 是一门彻底的函数式编程语言 —— 支持隐式返回声明、函数是一等公民、lambda 表达式等等。
7. **使用 JavaScript 中所需的任何内容。** 你可以使用 JavaScript 的一切以及它的生态系统，从 `console.log` 到 npm 库都可以。
8. **性能。** Clojurescript 使用 Google Closure 编译器来优化输出的 JavaScript。Bundle 体积小到极致。用于生产的打包过程不需要从设置优化到 `:advanced` 的复杂配置。
9. **可读的库代码。** 有时候了解“这个库的功能是干嘛的？”很有用。当我使用 JavaScript 中的“跳转到定义处”，我通常都会看到被压缩或错位的源代码。Clojure 和 Clojurescript 的库都直接被显示成写出来的样子，因此不需离开你的编辑器去看一些东西如何工作就很简单，因为你可以直接阅读源码。
10. **是一种 LISP 方言。** 很难列举出这方面的好处，因为太多了。我喜欢的一点是它的公式化，（有这么一种模式可以依靠）代码是用语言的数据结构来表达的。（这使得元编程很容易）。Clojure 不同于 LISP 因为它并不是 100% 的 `()`。它的代码和数据结构中可以使用 `[]` 和 `{}`，就像大多数编程语言那样。
11. **元编程。** Clojurescript 允许你编写生成代码的代码。这一点有我不想掩盖的巨大内涵。其中之一是你可以高效地扩展语言本身。这是一个出自 [Clojure for the Brave and True](http://www.braveclojure.com/writing-macros/) 的例子：

```
(defmacro infix
  [infixed]
  (list (second infixed) (first infixed) (last infixed)))
(infix (1 + 1))
=> 2
(macroexpand '(infix (1 + 1)))
=> (+ 1 1)
; 这个宏把它传入 Clojure，Clojure 可以正确执行，因为是 Clojure 的原生语法。
```

### 为什么它并不流行？

既然说它这么棒，可它怎么不上天呢？有人指出它已经很流行了，它只是不如 lodash、React、Redux 等等那么流行而已。但既然它更好，不应该和它们一样流行吗？为什么偏爱函数式编程、不可变性和 React 的 JS 开发者还没有迁移到 Clojurescript？

**因为缺少工作机会吗？** Clojure 可以编译成 JavaScript 和 Java。它实际上也可以编译成 C#。因此大量的 JavaScript 工作都可以当作 Clojurescript 工作。它是一种函数式语言，用于为所有编译目标完成所有的任务。先不论它的价值如何体现，2017 StackOverflow 的调查表明 [Clojure 开发者的薪资水平是所有语言中全球平均最高的](http://www.techrepublic.com/article/what-are-the-highest-paid-jobs-in-programming-the-top-earning-languages-in-2017/)。

**因为 JS 开发者很懒吗？** 并不是。正如我在上面所展示的，我们做了大量的工作。有个词叫 [JavaScript 疲劳](https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4)，你可能已经听说过了。

**我们很抗拒，不想学点新东西吗？** 并不是。 [我们已经因采用新技术而臭名昭著。](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f)

**因为缺乏熟悉的框架和工具吗？** 这感觉上可能是个原因，但 Javascript 中有的东西， Clojurescript 都有与之对应的： [re-frame](https://github.com/Day8/re-frame) 对应 Redux、[reagent](https://github.com/reagent-project/reagent) 对应 React、[figwheel](https://github.com/bhauman/lein-figwheel) 对应 Webpack/热加载、[leiningen](https://github.com/technomancy/leiningen) 对应 yarn/npm、Clojurescript 对应 Underscore/Lodash。

**是因为括号的问题使得这门语言太难写了吗？** 这方面也许谈的还不够多，但[我们不必自己来区分圆括号方括号](https://shaunlebron.github.io/parinfer/) 。基本上，Parinfer 使得 Clojure 成为了空格语言。

**因为在工作中很难使用？** 可能是吧。它是一种新技术，就像 React 和 Redux 曾经那样，在某些时候也是很难推广的。即使也没什么技术限制 ——  Clojurescript 集成到现有代码库和集成 React 的方式是类似的。你可以把 Clojurescript 加入到已经存在的代码库中，每次重写一个文件的旧代码，新代码依然可以和未更改的旧代码交互。

**没有足够受欢迎？** 很不幸，我想这就是它的原因。我使用 JavaScript 一部分原因就是它拥有庞大的社区。Clojurescript 太小众了。我使用 React 的部分原因是它是由 Facebook 维护的。而 Clojure 的维护者是[花大量时间思考的留着长发的家伙](https://avatars2.githubusercontent.com/u/34045?v=3&amp;s=400)。

有数量上的劣势，我认了。但“人多势众”否决了所有其他可能的因素。

假设有一条路通向 100 美元，它很不受欢迎，而另一条路通向 10 美元，它极其受欢迎，我会选择受欢迎的那条路吗？

恩，也许会的吧！那里有成功的先例。它一定比另一条路安全，因为更多的人选择了它。他们一定不会遇到什么可怕的事。而另一条路听起来美好，但我确定那一定是个陷阱。如果它像看起来那么美好，那么它就是最受欢迎的那条路了。

![](https://cdn-images-1.medium.com/max/1600/1*Y6orLTOgb6JFfjVdANVgCQ.png)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
