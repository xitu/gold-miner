> * 原文地址：[What’s new in React 16.3(.0-alpha)](https://medium.com/@baphemot/whats-new-in-react-16-3-d2c9b7b6193b)
> * 原文作者：[Bartosz Szczeciński](https://medium.com/@baphemot?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-react-16-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-react-16-3.md)
> * 译者：[pot-code](https://github.com/pot-code)
> * 校对者：

# 也谈 React 16.3(.0-alpha)

React 16.3-alpha  于不久前[推至 npmjs](https://twitter.com/brian_d_vaughn/status/959535914480357376)，你最关心哪些变化呢？

### 亮闪闪的 context API

听人说，尽量不要用 Context API，因为这个 API 还没完全确定下来，说不上哪天就重构了，而且官方还故意不写文档，这给 Context API 蒙上了一层神秘面纱。不过，是时候让它发光发热了，RFC 现在已经[收录了这个技术](https://github.com/reactjs/rfcs/blob/master/text/0002-new-version-of-context.md)，新的 API 代码也已经合并了，反正比以前好用的多，至少在状态管理这方面，不用再受制于 Redux 和 MobX 那一套了。

首先是创建  Context 的语法：`React.createContext()`，调用之后会自动创建两个组件（一个 Provider 组件和一个 Consumer 组件）：

![](https://cdn-images-1.medium.com/max/800/1*HgQMzO2N59Z20NeK5ACGzQ.png)

这个工厂方法返回的对象包含“Provider”和“Consumer”两个属性，即上文提到的两个组件。

Provider 组件用来为其所有子层级组件提供数据，示例如下：

![](https://cdn-images-1.medium.com/max/800/1*R5GQSLcfedGZiTyoSRDVsg.png)

在上图中，将需要接受数据的组件放在 `ThemeContext.Provider` 下，设置其 `value` 属性，用来存放需要传递的数据。当然这个 `value` 也可以是动态变化的（用 `this.setState`）。

接下来设置 Consumer 组件：

![](https://cdn-images-1.medium.com/max/800/1*XhcIeUaD1G1rpV0c8MYZvA.png)

如果你把 Consumer 组件放在了 Provider 组件的外部（不在它的下面），其值会默认使用调用 `createContext` 时传入的值。

PS：

* Consumer 组件只能获取到对应的 Context 或者 Context.Provider 里设置的数据，即使新创建了一个 Context，传入和已有的 Context 一样的参数，不属于这个 Context 的 Consumer 是获取不到它的数据的。所以，不妨把 Context 看成一个组件，相同用途的 Context 只创建一次，再根据需要再作导入导出（export/import）。
* 新的写法采用的是 [child pattern](https://medium.com/merrickchristensen/function-as-child-components-5f3920a9ace9)。
* 新 API 不需要再设置 `contextProps` 了。

`Consumer` 下的 `context` 参数对应了 `Provider` 组件里设置的 `value` 属性，修改 Provider 里设置的数据会导致对应的 Consumer 下的组件重新渲染。

### 杀敌一千，自损八百

因为 RFC 的缘故，有一些个生命周期方法 **正考虑被废除**，同时还会引进了一个新的方法。

这个更新算是逼你使用最佳的异步实践方法（即将被废除的这些生命周期方法在异步场景下会导致一些奇怪的问题，具体可以参考我写的[另一篇文章](https://medium.com/@baphemot/understanding-reactjs-component-life-cycle-823a640b3e8d)）。

具体改变如下：

* `componentWillMount` —— 即将废除，使用 `componentDidMount` 作为替代
* `componentWillUpdate` —— 即将废除，使用 `componentDidUpdate` 作为替代
* `componentWillReceiveProps` —— 即将废除，使用新引进的方法 `static getDerivedStateFromProps`

不要瞎慌，这些方法现在都可以正常使用，不影响，到 16.4 版本才会正式打上“已废除”的标记，真正移除可能要到 17.0 以后。

![](https://cdn-images-1.medium.com/max/800/1*x-Sf7tN3BNWuL4SWMGyFTg.png)

Dan 表示，“故事还长，大家别慌”，然而仍有群众表示恐慌。

如果你开启了 `StrictMode` 或是 `AsyncMode`，它顶多提示你已经废除了，不想看到这些提示信息可以进行压制：

* `UNSAFE_componentWillMount`
* `UNSAFE_componentWillReceiveProps`
* `UNSAFE_componentWillUpdate`

### 静态方法：getDerivedStateFromProps

既然 `componentWillReceiveProps` 要被废除了，那么，我们还能用啥来处理 prop 的更新呢？这里就要用到新引进的那个静态方法了。

这里说的静态和其他语言的概念是一样的，它是存在于类自身的方法，不依赖实例的创建。与一般的类方法的区别在于它不能访问 `this` 关键字，还有就是方法前面有个 `static` 修饰符。

嗯，那行，但是有一个问题，既然访问不到 `this` 了，那还怎么用 `this.setState` 来更新状态呢？答案是，“压根就不需要用这个方法了”。可能你一脸懵逼，待我娓娓道来 —— 你只需要返回新的状态就行了，直接 return 出去，不需要用方法去设置。如果不需要更新状态，返回 `null` 就行了：

![](https://cdn-images-1.medium.com/max/800/1*iIRN5UAvsf-6d84NweGlzQ.png)

此外，返回值的机制和使用 `setState` 的机制是一样的 —— 只需要返回需要更新的那部分数据就完了，其余部分数据都会保留。

#### 敲黑板：

![](https://cdn-images-1.medium.com/max/800/1*xGRcRf9KyVNEm4r_Wt9UMw.png)

说了这么多，还是要提醒下各位记得在构造器里初始化一下 state（在构造器里或者用 class field），不然就会报上面的错误。

* * *

这个方法在组件首次挂载和将要重新渲染的时候会调用，所以你也可以拿它作为构造器的替代。

* * *

![](https://cdn-images-1.medium.com/max/800/1*Wv-6Yyg7Wd5gIIBu2IKH7w.png)

如果同时定义了 `getDerivedStateFromProps` 和 `componentWillReceiveProps`，以 `getDerivedStateFromProps` 为准，同时 React 还会扔你一脸警告信息。

* * *

还有一种情况就是，当状态发生变化的时候需要执行回调，这时候你就可以用 `componentDidUpdate`。

* * *

如果你觉得 `static` 不够优雅，你可以用下面这种方式定义，效果是一样的:

![](https://cdn-images-1.medium.com/max/800/1*nb9hnMETRb8Nc26ogTlX6A.png)

### StrictMode

Strict mode 是新加入的组件，和 `'use strict'` 的良苦用心是一样的 —— 旨在逼你写出最佳实践代码。把需要进行约束的组件簇放在它的下面就完事了:

![](https://cdn-images-1.medium.com/max/800/1*cT32zSlTdDHMDbNDkpOwdw.png)

完全一变相的 `'use strict'`

如果其下的组件不小心用了上文提到的要废除的生命周期方法，控制台会打印出警告信息（开发环境下）:

![](https://cdn-images-1.medium.com/max/800/1*etTOl69nI0EmND_D68W7xA.png)

错误信息提供的链接地址目前指向的是一个 [RFC issue](https://fb.me/react-strict-mode-warnings)，也是提出移除这些生命周期方法的那个。

### AsyncMode

为了配合 `StrictMode`，异步组件支持现在重新命名为 `React.unsafe_AsyncMode`，它也会引发 `StrictMode` 的警告信息。

有关异步组件的使用可以参考以下博文：

* [https://build-mbfootjxoo.now.sh/](https://build-mbfootjxoo.now.sh/)
* [https://github.com/koba04/react-fiber-resources](https://github.com/koba04/react-fiber-resources)

### 新版 React 开发工具

新版本的开发工具也已经跟进，可以识别新加入的组件了。

但是 Chrome 上的插件还没有更新，还要等一段时间，所以 debug 的时候会看到很有趣的东西：

![](https://cdn-images-1.medium.com/max/800/0*VzzTmbTx7dmzll94.png)

React. __SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED（译者注：红头组件，用了你就 GG 了）表示不服。

Firefox 用户就有福了，完全支持：

![](https://cdn-images-1.medium.com/max/800/1*DN9BX9MC4xDjdXKKAAAf7Q.png)

可以看到 `AsyncMode` 组件直接就识别了。

### 后日谈

总之呢，这还只是 alpha 版本，等稳定版本出来的时候可能会有点改动。根据 Dan 的说法，稳定版差不多下周就出：

![](https://cdn-images-1.medium.com/max/800/1*JE0fFrRpCmzCaG-hVEZWpA.png)

讲道理，这不已经过了一个星期吗？

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
