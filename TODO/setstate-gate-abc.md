> * 原文地址：[setState() Gate](https://medium.com/javascript-scene/setstate-gate-abc10a9b2d82#.z148awo8n)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[1992chenlu](https://github.com/1992chenlu)，[qinfanpeng](https://github.com/qinfanpeng)

# setState() 门事件 #

## React setState() 解惑 ##

> 译注：本文起因于作者的一条推特，他认为应该避免使用 setState()，随后引发论战，遂写此文详细阐明其观点。译者个人认为，本文主要在于“撕逼“，并未深入介绍 setState() 的技术细节，希望从技术层面深入了解 `setState()` 的同学可以参考[[译] React 未来之函数式 setState](https://juejin.im/post/58cfcf6e44d9040068478fc6)。对 `setState()` 不了解的同学可能会感到本文不知所云，特此说明。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YvimnE7n9gk2Oesw_Dmxhg.jpeg">

一切都源于上周。3 位 React 初学者尝试在项目中使用 `setState()` 时遇到了 3 种不同的问题。我指导过很多 React 新手，也为团队提供从其他技术到 React 的架构转型咨询。

其中一位初学者正在开发一个十分适合使用 Redux 的生产项目，所以我没有正面去解决 `setState()` 的同步问题（the timing with `setState()`），而是直接建议他用 Redux 替换掉 `setState()`，因为使用 Redux 能避免 state 在组件渲染的过程中发生改变。Redux 简单地利用来自 store 的 props 来决定如何渲染界面，巧妙地规避了复杂的同步问题。

因此也就有了下面这条推特：


[“React 有个 setState() 问题：让新手使用 setState() 毫无好处（a recipe for headaches）。高手们已经学会了如何避免使用它"](https://twitter.com/_ericelliott)

之后，有些高手就来纠正我了：

[“我是 React 团队的一员。在尝试其他方法之前，请学会使用 setState。”](https://twitter.com/dan_abramov/status/842490428440150017?ref_src=twsrc%5Etfw)

[“那些所谓‘高手’们怕是要落伍了，因为 React 17 将会默认采用异步调度。”](https://twitter.com/acdlite/status/842499250822950912?ref_src=twsrc%5Etfw)

对于第二点：

[“Fiber 有一种用于暂停、切分、重建和取消更新的策略，但如果你脱离了组件 state，那此策略便无法正常工作了。”](https://twitter.com/acdlite/status/842506455232143360?ref_src=twsrc%5Etfw)

貌似都没错，可是码农们就要骂娘了：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YvimnE7n9gk2Oesw_Dmxhg.jpeg">

面对困境“呵呵”两下并无妨，不过千万别呵呵过后就对问题视而不见了。

在和另一个初学者交流的时候，我发现他也对 `setState()` 的工作机制感到困惑。他后来索性放弃了，他把 state 塞在一个闭包里；显而易见，闭包中 state 的改变是不会触发 render 函数自动执行的。

考虑到深感困惑的初学者之多，我还是坚持我上述推文中前半句的观点；但如果可以重来的话，我会对后半句稍作修改，因为确有很多高手在（主要是 Facebook 和 Netfix 的工程师）大量地使用 `setState()`：

> “React 有个 setState() 问题：叫新手使用 setState() 毫无好处，但高手们自有神技。“

当然，推特还是有可能会丧失其集体智慧（lose its collective mind）（译注：个人认为这句应该是指当网络上大多数人持某一观点时，那即使该观点是错的，那你也不能指出其错误，否则就会招致集体攻讦；或者说，真理有时候只掌握在少数人手里）。 毕竟，React 是“**完美的**”， 我们都必须承认 `setState`的美妙优雅是多么的恰如其分，否则只会遭到冷嘲热讽。

如果 `setState()` 令你感到困惑，那都是**你的问题** —— 你要么是疯子，要么是傻瓜。（我好像忘了说 [Javascript 社区的霸凌问题了](https://medium.com/javascript-scene/the-js-community-has-a-bullying-problem-96c10f11c85d#.wagjqz54o) ）

好了，当你嘲笑所有初学者的时候，先反省反省自己吧，别以为掌握了 `setState()` 就可以得意忘形了。

那种行为是荒谬可笑的，是精英主义论的，会让新手们感到十分讨厌。如果人们经常对某个 API 感到困惑的话，那就该改进 API 本身的设计了，或者至少应该改进下文档。

让我们的社区和工具变得更加友好对所有人来说都是件好事。

### setState() 究竟有何问题？ ###

这个问题可以有两个答案：

1. 没啥问题。（大部分情况下）其表现和设计期望一样，足以解决目标问题。
2. 学习曲线问题。对新手而言，一些用原生 JS 和直接的 DOM 操作可以轻松实现的效果，用 React 和 `setState` 实现起来就会困难重重。

React 的设计初衷本是简化应用开发流程，但是：

- 你却不能随心所欲地操作 DOM。
- 你不能随心所欲地（于任何时间、依赖任意数据源）更新 state。
- 在组件的生命周期中，你并不总是能在屏幕上直接观察到渲染后的 DOM 元素，这限制了 `setState()` 的使用时机和方式（因为你有些 state 可能还没有渲染到屏幕上）。

在这几种情况下，困惑都来源于 React 组件生命周期的限制性（这些限制是刻意设计的，是好的）。

#### 从属 State（Dependent State） ####

更新 state 时，更新结果可能依赖于：

- 当前 state
- 同一批次中先前的更新操作
- 当前已渲染的 DOM （例如：组件的坐标位置、可见性、CSS 计算值等等）

当存在这几种从属 state 的时候，如果你还想简单直接地更新 state，那 React 的表现行为会让你大吃一惊，并且是以一种令人憎恶又难以调试的方式。大多数情况下，你的代码根本无法工作：要么 state 不对，要么控制台有错误。

我之所以吐槽 `setState()`，是因为它的这种限制性在 API 文档中并没有详细说明，关于应对这种限制性的各种通用模式也未能阐述清楚。这迫使初学者只能不断试错、Google 或者从其他社区成员那里寻求帮助，但实际上在文档中本该就有更好的新手指南。

当前关于 `setState()` 的文档开头如下：

```
setState(nextState, callback)
```

> 将 nextState 浅合并到当前 state。这是在事件处理函数和服务器请求回调函数中触发 UI 更新的主要方法。

在末尾确实也提到了其异步行为：

> 不保证 `setState` 调用会同步执行，考虑到性能问题，可能会对多次调用作批处理。

这就是很多用户层（userland） bug 的根本原因：

```
// 假设 state.count === 0
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
// state.count === 1, 而不是 3
```

本质上等同于：

```
Object.assign(state,
  {count: state.count + 1},
  {count: state.count + 1},
  {count: state.count + 1}
); // {count: 1}
```

这在文档中并未显式说明（在另外一份特殊指南中提到了）。

文档还提到了另外一种函数式的 `setState()` 语法：

> 也可以传递一个签名为 `function(state, props) => newState` 的函数作为参数。这会将一个原子性的更新操作加入更新队列，在设置任何值之前，此操作会查询前一刻的 state 和 props。

> `...`

> `setState()`  并不会立即改变  `this.state` ，而是会创建一个待执行的变动。调用此方法后访问 `this.state` 有可能会得到当前已存在的 state（译注：指 state 尚未来得及改变）。

API 文档虽提供了些许线索，但未能以一种清晰明了的方式阐明初学者经常遇到的怪异表现。开发模式下，尽管 React 的错误信息以有效、准确著称，但当 `setState()` 的同步问题出现 bug 的时候控制台却没有任何警告。

[![](https://ww2.sinaimg.cn/large/006tKfTcgy1fecsfa9ryhj30jh06qaaq.jpg)](https://twitter.com/JikkuJose/status/842915627899670528?ref_src=twsrc%5Etfw)

[![](https://ww1.sinaimg.cn/large/006tKfTcgy1fecsftg2goj30j406674u.jpg)](https://twitter.com/PierB/status/842590294776451072?ref_src=twsrc%5Etfw)

StackOverflow 上有关 `setState()` 的问题大都要归结于组件的生命周期问题。毫无疑问，React 非常流行，因此那些问题都被[问](http://stackoverflow.com/questions/25996891/react-js-understanding-setstate)[烂](http://stackoverflow.com/questions/35248748/calling-setstate-in-a-loop-only-updates-state-1-time)[了](http://stackoverflow.com/questions/30338577/reactjs-concurrent-setstate-race-condition/30341560#30341560)，也有着各种良莠不齐的回答。

那么，初学者究竟该如何掌握 `setState()` 呢？

在 React 的文档中还有一份名为  [“ state 和生命周期”](https://facebook.github.io/react/docs/state-and-lifecycle.html)的指南，该指南提供了更多深入内容：

> “…要解决此问题，请使用 `setState()` 的第二种形式 —— 以一个函数而不是对象作为参数，此函数的第一个参数是前一刻的 state，第二个参数是 state 更新执行瞬间的 props ：”

```
// 正确用法
this.setState((prevState, props) => ({
  count: prevState.count + props.increment
}));
```

这个函数参数形式（有时被称为“函数式 `setState()`”）的工作机制更像：

```
[
  {increment: 1},
  {increment: 1},
  {increment: 1}
].reduce((prevState, props) => ({
  count: prevState.count + props.increment
}), {count: 0}); // {count: 3}
```

不明白 reduce 的工作机制？ 参见  [“Composing Software”](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c#.7k9w6v9ok) 的 [“Reduce”](https://medium.com/javascript-scene/reduce-composing-software-fe22f0c39a1d#.8d8kw0l40) 教程。

关键点在于**更新函数（updater function）**：

```
(prevState, props) => ({
  count: prevState.count + props.increment
})
```

这基本上就是个 reducer，其中 `prevState` 类似于一个累加器（accumulator），而 `props` 则像是新的数据源。类似于 Redux 中的 reducers，你可以使用任何标准的 reduce 工具库对该函数进行 reduce（包括 `Array.prototype.reduce()`）。同样类似于 Redux，reducer 应该是 [纯函数](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976) 。

> 注意：企图直接修改 `prevState` 通常都是初学者困惑的根源。

API 文档中并未提及更新函数的这些特性和要求，所以，即使少数幸运的初学者碰巧了解到函数式 `setState()` 可以实现一些对象字面量形式无法实现的功能，最终依然可能困惑不解。

### 仅仅是新手才有的问题吗？ ###

直到现在，在处理表单或是 DOM 元素坐标位置的时候，我还是会时不时得掉到坑里去。当你使用 `setState()` 的时候，你必须直接面对组件生命周期的相关问题；但当你使用容器组件或是通过 props 来存储和传递 state 的时候，React 则会替你处理同步问题。

 [**无论你有经验与否**](https://medium.com/@mweststrate/3-reasons-why-i-stopped-using-react-setstate-ab73fc67a42e#.saj7jn6wh) ，处理共享的可变 state 和 state 锁（state locks）都是很棘手的。经验丰富之人只不过是能更加快速地定位问题，然后找出一个巧妙的变通方案罢了。

因为初学者从未遇到过这种问题，更不知规避方案，所以是掉坑里摔得最惨的。

[![](https://ww4.sinaimg.cn/large/006tKfTcgy1fecsglwlldj30jb067wf0.jpg)](https://twitter.com/_ericelliott/status/842546271944564737?ref_src=twsrc%5Etfw)

[![](https://ww1.sinaimg.cn/large/006tKfTcgy1fecshbe5u6j30jl05xdg8.jpg)](https://twitter.com/dan_abramov/status/842548605525331969?ref_src=twsrc%5Etfw)

当问题发生时，你当然可以选择和 React 斗个你死我活；不过，你也可以选择让 React 顺其自然的工作。这就是我说**即使是对初学者而言**，Redux **有时** 都比 `setState` 更简单的原因。

在并发系统中，state 更新通常按其中一种方式进行：

- 当其他程序（或代码）正在访问 state 时，禁止 state 的更新（例如 `setState()`）（译注：即常见的锁机制）
- 引入不可变性来消除共享的可变 state，从而实现对 state 的无限制访问，并且可以在任何时间创建新 state（例如 Redux）

在我看来（在向很多学生教授过这两种方法之后），相比于第二种方法，第一种方法更加容易导致错误，也更加容易令人困惑。当 state 更新被简单地阻塞时（在 `setState` 的例子中，也可以叫批处理化或延迟执行），解决问题的正确方法并不十分清晰明了。

当遇到 `setState()` 的同步问题时，我的直觉反应其实是很简单的：将 state 的管理上移到 Redux（或 MobX） 或容器组件中。基于[多方面原因](https://medium.com/javascript-scene/10-tips-for-better-redux-architecture-69250425af44) ，我自己使用同时也推荐他人使用 Redux，但很显然，这**并不是一条放之四海而皆准的建议**。

Redux 自有其**陡峭**的学习曲线，但它规避了共享的可变 state 以及 state 更新同步等复杂问题。因此我发现，一旦我教会了学生如何避免可变性，接下来基本就**一帆风顺**了。

对于没有任何函数式编程经验的新手而言，学习 Redux 遇到的问题可能会比学习 `setState()` 遇到的更多 —— 但是，Redux 至少有很多其作者亲自讲授的[免费](https://egghead.io/courses/getting-started-with-redux) [教程](https://egghead.io/courses/building-react-applications-with-idiomatic-redux)

React 应当向 Redux 学习：有关 React 编程模式和 `setState()` 踩坑的视频教程定能让 React 主页锦上添花。

#### 在渲染之前决定 State  ####

将 state 管理移到容器组件（或 Redux）中能促使你从另一个角度思考组件 state 问题，因为这种情况下，在组件**渲染之前**，其** state 必须是既定的**（因为你必须将其作为 props 传下去）。

重要的事情说三遍：

> 渲染之前，决定 state！
>
> 渲染之前，决定 state！
>
> 渲染之前，决定 state！

说完三篇之后就可以得到一个显然的推论：在 `render()` 函数中调用 `setState()` 是反模式的。

在 `render` 函数中计算从属 state 是 OK 的（比如说， state 中有 `firstName` 和 `lastName`，据此你计算出 `fullName`，在 `render` 函数中这样做完全是 OK 的），但我还是倾向于在容器组件中计算出从属 state ，然后通过 props 将其传递给展示组件（presentation components）。

### setState()  该怎么治？ ###

我倾向于废弃掉对象字面量形式的 `setState()`，我知道这（表面上看）更加易于理解也更加方便（译者：“这”指对象字面量形式的 `setState()`），但它也是坑之所在啊。用脚指头都能猜到，肯定有人这样写：

```
state.count; // 0
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
this.setState({count: state.count + 1});
```

然后天真就地以为 `{count: 3}`。批量化处理后对象的同名 props 被合并掉的情况几乎不可能是用户所期望的行为，反正我是没见过这种例子。要是真存在这种情况，那我必须说这跟 React 的实现细节耦合地太紧密了，根本不能作为有效参考用例。

我也希望 API 文档中有关 `setState()` 的章节能够加上[“ state 和声明周期”](https://facebook.github.io/react/docs/state-and-lifecycle.html)这一深度指南的链接，这能给那些想要全面学习 `setState()` 的用户更多的细节内容。`setState()` 并非同步操作，也无任何有意义的返回结果，仅仅是简单地描述其函数签名而没有深入地探讨其各种影响和表现，这对初学者是极不友好的。

初学者必须花上大量时间去找出问题：Google 上搜、StackOverflow 上搜、GitHub issues 里搜。

### setState() 为何如此严苛？ ###

setState() 的怪异表现并非 bug，而是特性。实际上，甚至可以说**这是 React 之所以存在的根本原因**。

React 的一大创作动机就是保证确定性渲染：给定应用 state ，渲染出特定结果。理想情况下，给定 state 相同，渲染结果也应相同。

为了达到此目的，当发生变化时，React 通过采取一些限制性手段来**管理**变化。我们不能随意取得某些 DOM 节点然后就地修改之。相反，React 负责 DOM 渲染；当 state 发生改变时，也由React 决定如何重绘。**我们不渲染 DOM，而是由 React 来负责**。

为了避免在 state 更新的过程中触发重绘，React 引入了一条规则：

React 用于渲染的 state 不能在 DOM 渲染的过程中发生改变。**我们不能决定组件 state 何时得到更新，而是由 React 来决定**。

困惑就此而来。当你调用 `setState()` 时，你以为你设置了 state ，其实并没有。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cGqz_qxBGnJTsGygPe8ItQ.jpeg">

“你就接着装逼，你以为你所以为的就是你所以为的吗？”

### 何时使用 setState()？ ###

我一般只在不需要持久化 state 的自包含功能单元中使用 `setState()`，例如可复用的表单校验组件、自定义的日期或时间选择部件（widget）、可自定义界面的数据可视化部件等。

我称这种组件为“小部件（widget）”，它们一般由两个或两个以上组件构成：一个负责内部 state 管理的容器组件，一个或多个负责界面显示的子组件

几条立见分晓的检验方法（litmus tests）：

- 是否有其他组件是否依赖于该 state ？
- 是否需要持久化 state ？（存储于 local storage 或服务器）

如果这两个问题的答案都是“否”的话，那使用 `setState()` 基本是没问题的；否则，就要另作考虑了。

据我所知，Facebook 使用受管于 [Relay container](https://facebook.github.io/relay/) 的 `setState()` 来包装 Facebook UI 的各个不同部分，例如大型 Facebook 应用内部的迷你型应用。于 Facebook 而言，以这种方式将复杂的数据依赖和需要实际使用这些数据的组件放在一起是很好的。

对于大型（企业级）应用，我也推荐这种策略。如果你的应用代码量非常大（十万行以上），那此策略可能是很好的 —— 但这并不意味着这种方式就不能应用于小型应用中。

类似地，并不意味着你不能将大型应用拆分成多个独立的迷你型应用。我自己就结合 Redux为企业级应用这样做过。例如，我经常将分析面板、消息管理、系统管理、团队/成员角色管理以及账单管理等模块拆分成多个独立的应用，每个应用都有其自己的 Redux store。通过 API tokens 和 OAuth，这些应用共享同一个域下的登录/session 管理，感觉就像是一个统一的应用。

对于大多数应用，我建议**默认使用 Redux**。需要指出的是，Dan Abramov（Redux 的作者）在这一点上和我持相反的观点。他喜欢应用尽可能地保持简单，这当然没错。传统社区有句格言如是说：“除非真得感到痛苦，否则就别用 Redux”。

而我的观点是：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*z_XSyNy2GoSEOipCeOVM_g.jpeg">

“不知道自己正走在黑暗中的人是永远不会去搜寻光明的“。

正如我说过的，**在某些情况下**，Redux 比 `setState()` 更简单。通过消除一切和共享的可变 state 以及同步依赖有关的 bug，Redux 简化了 state 管理问题。

`setState()` 肯定要学，但即使你不想使用 Redux，你也应该学学 Redux。无论你采用何种解决方案，它都能让你从新的角度思考去应用的 state 管理问题，也可能能帮你简化应用 state。

对于有大量衍生（derived ） state 的应用而言， [MobX](https://github.com/mobxjs/mobx) 可能会比 `setState()` 和 Redux 都要好，因为它非常擅于高效地管理和组织需要通过计算得到的（calculated ） state 。

得利于其细粒度的、可观察的订阅模型，MobX也很擅于高效渲染大量（数以万计）动态 DOM 节点。因此，如果你正在开发的是一款图形游戏，或者是一个监控所有企业级微服务实例的控制台，那 MobX 可能是个很好的选择，它非常有利于实时地可视化展示这种复杂的信息。

### 接下来 ###

想要全面学习如何用 React 和 Redux 开发软件？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">
](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的**作者**。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN**和**BBC**等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher** , **Frank Ocean** , **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美的女子在一起（译注：这是怕老婆呢还是怕老婆呢还是怕老婆呢？）。
