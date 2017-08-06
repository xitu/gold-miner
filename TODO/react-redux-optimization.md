
> * 原文地址：[Redux 并不慢，只是你使用姿势不对 —— 一份优化指南](http://reactrocket.com/post/react-redux-optimization/)
> * 原文作者：本文已获原作者 [Julian Krispel](https://twitter.com/juliandoesstuff) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/react-redux-optimization.md](https://github.com/xitu/gold-miner/blob/master/TODO/react-redux-optimization.md)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[sunui](https://github.com/sunui)，[xekri](https://github.com/xekri)

# Redux 并不慢，只是你使用姿势不对 —— 一份优化指南

如何优化使用了 Redux 的 React 应用不是那么显而易见的，但其实又是非常简单直接的。本文即是一份带有若干示例的简短指南。

在优化使用了 Redux 的 React 应用的时候，我经常听人说 Redux 很慢。其实在 99% 的情况下，性能低下都和不必要的渲染有关（这一论断也适用于其他框架），因为 DOM 更新的代价是昂贵的。通过本文，你将学会如何在使用 Redux 的 React 应用中避免不必要的渲染。

一般来讲，要在 Redux store 更新的时候同步更新 React 组件，需要用到[ React 和 Redux 的官方绑定库](https://github.com/reactjs/react-redux)中的 [`connect`](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options) 高阶组件。
`connect` 是一个将你的组件进行包裹的函数，它返回一个高阶组件，该高阶组件会监听 Redux store，当有状态更新时就重新渲染自身及其后代组件。

## React 和 Redux 的官方绑定库 —— react-redux 快速入门

`connect` 高阶组件实际上已经被优化过了。为了理解如何更好地使用它，必须先理解它是如何工作的。

实际上，Redux 和 react-redux 都是非常小的库，因此其源码也并非高深莫测。我鼓励人们通读源码，或者至少读一部分。如果你想更进一步的话，可以自己实现一个，这能让你深入理解为什么它要作如此设计。

闲言少叙，让我们稍微深入地研究一下 react-redux 的工作机制。前面已经提过，react-redux 的核心是 `connect` 高阶组件，其函数签名如下：

    return function connect(
      mapStateToProps,
      mapDispatchToProps,
      mergeProps,
      {
        pure = true,
        areStatesEqual = strictEqual,
        areOwnPropsEqual = shallowEqual,
        areStatePropsEqual = shallowEqual,
        areMergedPropsEqual = shallowEqual,
        ...extraOptions
      } = {}
    ) {
    ...
    }

顺便说一下 —— 只有 `mapStateToProps` 这一个参数是必须的，而且大多数情况下只会用到前两个参数。此处我引用这个函数签名是为了阐明 react-redux 的工作机制。

所有传给 `connect` 函数的参数都用于生成一个对象，该对象则会作为属性传给被包裹的组件。`mapStateToProps` 用于将 Redux store 的状态映射成一个对象，`mapDispatchToProps` 用于产生一个包含函数的对象 —— 这些函数一般都是动作生成器（action creators）。`mergeProps` 则接收 3 个参数：`stateProps`、`dispatchProps` 和 `ownProps`，前两个分别是 `mapStateToProps` 和 `mapDispatchToProps` 的返回结果，最后一个则是继承自组件本身的属性。默认情况下，`mergeProps` 会将上述参数简单地合并到一个对象中；但是你也可以传递一个函数给 `mergeProps`，`connect` 则会使用这个函数为被包裹的组件生成属性。

`connect` 函数的第四个参数是一个属性可选的对象，具体包含 5 个可选属性：一个布尔值 `pure` 以及其他四个用于决定组件是否需要重新渲染的函数（应当返回布尔值）。`pure` 默认为 true，如果设为 false，`connect` 高阶组件则会跳过所有的优化选项，而且那四个函数也就不起任何作用了。我个人认为不太可能有这类应用场景，但是如果你想关闭优化功能的话可以将其设为 false。

`mergeProps` 返回的对象会和上一个属性对象作比较，如果 `connect` 高阶组件认为属性对象所有改变的话就会重新渲染组件。为了理解 `react-redux` 是如何判断属性是否有变化的，请参考 [`shallowEqual` 函数](https://github.com/reactjs/react-redux/blob/master/src/utils/shallowEqual.js)。如果该函数返回 true，则组件不会渲染；反之，组件将会重新渲染。`shallowEqual` 负责进行属性对象的比较，下文是其部分代码，基本表明了其工作原理：

    for (let i = 0; i < keysA.length; i++) {
      if (!hasOwn.call(objB, keysA[i]) ||
          !is(objA[keysA[i]], objB[keysA[i]])) {
        return false
      }
    }

概括来讲，这段代码做了这些工作：

遍历对象 A 中的所有属性，检查对象 B 中是否存在同名属性。然后检查 A 和 B 同名属性的属性值是否相等。如果这些检查有一个返回 false，则对象 A 和 B 便被认为是不等的，组件也就会重新渲染。

这引出一条黄金法则：

## 只给组件传递其渲染所必须的数据

这可能有点难以理解，所以让我们结合一些例子来细细分析一下。

### 将和 Redux 有连接的组件拆分开来

我见过很多人这样做：用一个容器组件监听一大堆状态，然后通过属性传递下去。

    const BigComponent = ({ a, b, c, d }) => (
      <div>
        <CompA a={a} />
        <CompB b={b} />
        <CompC c={c} />
      </div>
    );

    const ConnectedBigComponent = connect(
      ({ a, b, c }) => ({ a, b, c })
    );

现在，一旦 `a`、`b` 或 `c` 中的任何一个发生改变，`BigComponent` 以及 `CompA`、`CompB` 和 `CompC` 都会重新渲染。

其实应该将组件拆分开来，而无需过分担心使用了太多的 `connect`：

    const ConnectedA = connect(CompA, ({ a }) => ({ a }));
    const ConnectedB = connect(CompB, ({ b }) => ({ b }));
    const ConnectedC = connect(CompC, ({ c }) => ({ c }));

    const BigComponent = () => (
      <div>
        <ConnectedA a={a} />
        <ConnectedB b={b} />
        <ConnectedC c={c} />
      </div>
    );

如此一来，`CompA` 只有在 `a` 发生改变后才会重新渲染，`CompB` 只有在 `b` 发生改变后才会重新渲染，`CompC` 也是类似的。如果 `a`、`b`、`c` 更新很频繁的话，那每次更新我们仅仅只是重新渲染一个组件而不是一下渲染三个。就这三个组件来讲区别可能不会很明显，但要是组件再多一些就比较明显了。

### 转变组件状态，使之尽可能地小

这里有一个人为构造（稍有改动）的例子：

你有一个很大的列表，比如说有 300 多个列表项：

    <List>
      {this.props.items.map(({ content, itemId }) => (
        <ListItem
          onClick={selectItem}
          content={content}
          itemId={itemId}
          key={itemId}
        />
      ))}
    </List>

点击一个列表项便会触发一个动作，同时更新 store 中的值 `selectedItem`。每一个列表项都通过 Redux 获取 `selectedItem` 的值：

    const ListItem = connect(
      ({ selectedItem }) => ({ selectedItem })
    )(SimpleListItem);

这里我们只给组件传递了其所必须的状态，这是对的。但是，当 `selectedItem` 发生变化时，所有 `ListItem` 都会重新渲染，因为我们从 `selectedItem` 返回的对象发生了变化，之前是 `{ selectedItem: 123 }` 而现在是 `{ selectedItem: 120 }`。

记住一点，我们使用了 `selectedItem` 的值来检查当前列表项是否被选中了。但是实际上组件只需要知道它有没有被选中即可， 本质上就是个 `Boolean`。布尔值用在这里简直完美，因为它仅仅有 `true` 和 `false` 两种状态。如果我们返回一个布尔值而不是 `selectedItem`，那当那个布尔值发生改变时只有两个组件会被重新渲染，这正是我们期望的结果。`mapStateToProps` 实际上会将组件的 `props` 作为第二个参数，我们可以利用这一点来确定当前组件是否是被选中的那一项。代码如下： 

    const ListItem = connect(
      ({ selectedItem }, { itemId }) => ({ isSelected: selectedItem === itemId })
    )(SimpleListItem);

如此一来，无论 `selectedItem` 如何变化，只有两个组件会被重新渲染 —— 当前选中的 `ListItem` 和那个被取消选择的 `ListItem`。

### 保持数据扁平

[Redux 文档](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html) 中作为最佳实践提到了这点。保持 store 扁平有很多好处。但就本文而言，嵌套会造成一个问题，因为我们希望状态更新粒度尽量小以使应用运行尽量快。比如说我们有这样一种深浅套的状态：

    {
      articles: [{
        comments: [{
          users: [{
          }]
        }]
      }],
      ...
    }

为了优化 `Article`、`Comment` 和 `User` 组件，它们都需要订阅 `articles`，而后在层层嵌套的属性中找到所需要的状态。其实如果将状态展开成这样会更加合理：

    {
      articles: [{
        ...
      }],
      comments: [{
        articleId: ..,
        userId: ...,
        ...
      }],
      users: [{
        ...
      }]
    }

之后用自己的映射函数获取评论和用户信息即可。更多关于状态扁平化的内容可以参阅 [Redux 文档](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html)。

### 福利：两个选择 Redux 状态的库

这一部分完全是可选的。一般来讲上述那些建议足够你编写出高效的 react 和 Redux 应用了。但还有两个可以大大简化状态选择的库：

[Reselect](https://github.com/reactjs/reselect) 是为 Redux 应用编写 `selectors` 所必不可少的工具。根据其官方文档：

- Selectors 可以计算衍生数据，可以让 Redux 做到存储尽可能少的状态。
- Selectors 是高效的，只有在某个参数发生变化时才被重新计算。
- Selectors 是可组合的。它们可以用作其他 selectors 的输入。

对于界面复杂、状态繁多、更新频繁的应用，reselect 可以大大提高应用运行效率。

[Ramda](http://ramdajs.com/) 是一个由许多高阶函数组成、功能强大的函数库。 换句话说，就是许多用于创建函数的函数。由于我们的映射函数也不过只是函数而已，所以我们可以利用 Ramda 方便地创建 selectors。Ramda 可以完成所有 selectors 可以完成的工作，而且还不止于此。[Ramda cookbook](https://github.com/ramda/ramda/wiki/Cookbook) 中介绍了一些 Ramda 的应用示例。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
