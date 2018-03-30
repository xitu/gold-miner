> * 原文地址：[React, Inline Functions, and Performance](https://cdb.reacttraining.com/react-inline-functions-and-performance-bdff784f5578)
> * 原文作者：[Ryan Florence](https://cdb.reacttraining.com/@ryanflorence?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-inline-functions-and-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-inline-functions-and-performance.md)
> * 译者：[wznonstop](https://github.com/wznonstop)
> * 校对者：[MechanicianW](https://github.com/MechanicianW)，[sunhaokk](https://github.com/sunhaokk)

# React 的内联函数和性能

我和妻子近期完成了一次声势浩大的装修。我们迫不及待地想向人们展示我们的新意。我们让我的婆婆来参观，她走进那间装修得很漂亮的卧室，抬头看了看那扇构造精巧的窗户，然后说：“居然没有百叶窗？”😐

![](https://raw.githubusercontent.com/wznonstop/wznonstop.github.io/master/images/2018-03-28-0.jpeg)

**我们的新卧室；天哪，它看起来就像一张杂志的照片。而且，没有百叶窗。** 

我发现，当我谈论 React 的时候，会有同样的情绪。我将通过研讨会的第一堂课，展示一些很酷的新特性。总是有人说：“内联函数？ 我听说它们很慢。”

并不总是这样，但最近几个月这个观点每天都会出现。作为一名讲师和代码库的作者，这让人感到精疲力竭。不幸的是，我可能有点傻，之前只知道在 Twitter 上咆哮，而不是去写一些可能对别人来说有深刻见解的东西。所以，我就来尝试一下更好的选择了 😂。

### “内联函数”是什么

在 React 的语境中，内联函数是指在 React 进行 "rendering" 时定义的函数。 人们常常对 React 中 "render" 的两种含义感到困惑，一种是指在 update 期间从组件中获取 React 元素（调用组件的 render 方法）；另一种是渲染更新真实的 DOM 结构。本文中提到的 "rendering"都是指第一种。

下列是一些内联函数的栗子🌰：

```
class App extends Component {
  // ...
  render() {
    return (
      <div>
        
        {/* 1. 一个内联的“DOM组件”事件处理程序 */}
        <button
          onClick={() => {
            this.setState({ clicked: true })
          }}
        >
          Click!
        </button>
        
        {/* 2. 一个“自定义事件”或“操作” */}
        <Sidebar onToggle={(isOpen) => {
          this.setState({ sidebarIsOpen: isOpen })
        }}/>
        
        {/* 3. 一个 render prop 回调 */}
        <Route
          path="/topic/:id"
          render={({ match }) => (
            <div>
              <h1>{match.params.id}</h1>}
            </div>
          )
        />
      </div>
    )
  }
}
```

### 过早的优化是万恶之源

在开始下一步之前，我们需要讨论一下如何对程序进行优化。询问任意一个性能方面的专家他们都会告诉你不要过早地优化你的程序。是的，所有具有丰富的性能调优经验的人，都会告诉你不要过早地优化你的代码。

> 如果你不去进行测量，你甚至不知道你所做的优化是使得程序变好还是变得更糟。

我记得我的朋友 Ralph Holzmann 发表的关于 gzip 如何工作的演讲，这个演讲巩固了我对此的看法。他谈到了一个他用古老的脚本加载库 LABjs 做的实验。你可以观看[这个视频](https://vimeo.com/34164210)的 30:02 到 32:35 来了解它，或者继续阅读本文。

当时 [LABjs](https://github.com/getify/LABjs) 的源码在性能上做了一些令人尴尬的事情。它没有使用普通的对象表示法(`obj.foo`)，而是将键存储在字符串中，并使用方括号表示法来访问对象(`obj[stringForFoo]`)。这样做的想法源于，经过小型化和 gzip 压缩之后，非自然编写的代码将比自然编写的代码体积小。[你可以在这里看到它](https://github.com/getify/LABjs/blob/b23ee3fcad12157cf8f6a291cb54fd7550ac7f3b/LAB.src.js#L7-L34)。

Ralph fork 了源代码，没有去考虑如何优化以实现小型化 和 gzip，而是通过自然地编写代码移除了优化的部分。

事实证明，移除“优化部分”后，文件大小削减了 5.3%！如果你不去进行测量，你甚至不知道你所做的优化是使得程序变好还是变得更糟！

过早的优化不仅会占用开发时间，损害代码的整洁，甚至会产生适得其反的结果**导致**性能问题，就像 LABjs 那样。如果作者一直在进行测量，而不仅仅是想象性能问题，就会节省开发时间，同时能让代码更简洁，性能更好。

不要过早地进行优化。好了，回到 React 。

### 为什么人们说内联函数很慢？

两个原因：内存/垃圾回收问题和 `shouldComponentUpdate` 。

#### 内存和垃圾回收

首先，人们（和 [eslint configs](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-no-bind.md)）担心创建内联函数产生的内存和垃圾回收成本。在箭头函数普及之前，很多代码都会内联地调用 `bind` ，这在历史上表现不佳。例如：

```
<div>
  {stuff.map(function(thing) {
    <div>{thing.whatever}</div>
  }.bind(this)}
</div>
```

`Function.prototype.bind` 的性能问题[在此得到了解决](http://benediktmeurer.de/2015/12/25/a-new-approach-to-function-prototype-bind/)，而且箭头函数要么是原生函数，要么是由 Babel 转换为普通函数；在这两种情况下，我们都可以假定它并不慢。

记住，你不要坐在那里然后想象“我赌这个代码肯定慢”。你应该自然地编写代码，**然后**测量它。如果存在性能问题，就修复它们。我们不需要证明一个内联的箭头函数是快的，也不需要另一些人来证明它是慢的。否则，这就是一个过早的优化。

据我所知，还没有人对他们的应用程序进行分析，表明内联箭头函数很慢。在进行分析之前，这甚至不值得谈论 —— 但无论如何，我会提供一个新思路 😝

如果创建内联函数的成本很高，以至于需要使用 eslint 规则来规避它，那么我们为什么要将该开销转移到初始化的热路径上呢？

```
class Dashboard extends Component {
  state = { handlingThings: false }
  
  constructor(props) {
    super(props)
    
    this.handleThings = () =>
      this.setState({ handlingThings: true })

    this.handleStuff = () => { /* ... */ }

    // bind 的开销更昂贵
    this.handleMoreStuff = this.handleMoreStuff.bind(this)
  }

  handleMoreStuff() { /* ... */ }

  render() {
    return (
      <div>
        {this.state.handlingThings ? (
          <div>
            <button onClick={this.handleStuff}/>
            <button onClick={this.handleMoreStuff}/>
          </div>
        ) : (
          <button onClick={this.handleThings}/>
        )}
      </div>
    )
  }
}
```

因为过早地优化，我们已经将组件的初始化速度降低了 3 倍！如果所有处理程序都是内联的，那么在初始化中只需要创建一个函数。相反的，我们则要创建 3 个。我们没有测量任何东西，所以没有理由认为这是一个问题。

如果你想完全忽略这一点，那么就去制定一个 eslint 规则，来要求在任何地方都使用内联函数来加快初始渲染速度🤦🏾‍♀。

#### PureComponent 和 shouldComponentUpdate

这才是问题真正的症结所在。你可以通过理解两件事来看到真正的性能提升： `shouldComponentUpdate` 和 JavaScript 严格相等的比较。如果不能很好地理解它们，就可能在无意中以性能优化的名义使 React 代码更难处理。

当你调用 `setState` 时，React 会将旧的 React 元素与一组新的 React 元素进行比较（这称为 r_econciliation_ ，你可以在[这里阅读相关资料](https://reactjs.org/docs/reconciliation.html) ），然后使用该信息更新真实的 DOM 元素。有时候，如果你有很多元素需要检查，这个过程就会变得很慢（比如一个大的 SVG ）。React 为这类情况提供了逃生舱口，名叫 `shouldComponentUpdate` 。

```
class Avatar extends Component {
  shouldComponentUpdate(nextProps, nextState) {
    return stuffChanged(this, nextProps, nextState))
  }
  
  render() {
    return //...
  }
}
```

如果你的组件定义了 `shouldComponentUpdate` ，那么在 React 进行新旧元素对比之前，它会询问 `shouldComponentUpdate` 有没有变更发生。如果返回了false，那么React将会直接跳过元素diff检查，从而节省一些时间。如果你的组件足够大，这会对性能产生相当大的影响。

优化组件的最常见方法是扩展 "React.PureComponent" 而不是 "React.Component" 。一个 `PureComponent` 会在 `shouldComponentUpdate` 中比较 props 和 state ，这样你就不用手动执行了。

```
class Avatar extends React.PureComponent { ... }
```

当被要求更新时，`Avatar` 会对它的 props 和 state 使用一个严格相等比较，希望以此来加快速度。

#### 严格相等比较

JavaScript 中有六种基本类型：string, number, boolean, null, undefined, 和 symbol。当你对两个值相同的基本类型进行“严格相等比较”的时候，你会得到一个 `true` 值。举个例子🌰:

```
const one = 1
const uno = 1
one === uno // true
```

当 `PureComponent` 比较 props 时，它会使用严格相等比较。这对内联原始值非常有效: `<Toggler isOpen={true}/>`。

prop 的比较只会在有非原始类型们出现的时候产生问题——啊，说错了，抱歉，是**类型**而不是类型们。只有一种其他类型，那就是 `Object`。你问函数和数组？事实上，它们都是对象（`Object`）。

> 函数是具有附加的可调用功能的常规对象。

> - [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures)

哈哈哈，不愧是 JavaScript。无论如何，对对象使用严格相等检查，即使表面上看起来相等的值，也会被判定为 `false`（不相等）：

```
const one = { n: 1 }
const uno = { n: 1 }
one === uno // false
one === one // true
```

所以，如果你在 JSX 中内联地使用一个对象，它会使 `PureComponent` 的 prop diff 检查失效，转而使用较昂贵的方式对 React 元素进行 diff 检查。元素的 diff 将变为空，这样就浪费了两次进行差异比较的时间。

```
// 第一次 render
<Avatar user={{ id: 'ryan' }}/>

// 下一次 render
<Avatar user={{ id: 'ryan' }}/>

// prop diff 认为有东西发生了变化，因为 {} !== {}
// 元素 diff 检查 (reconciler) 发现没有任何变化
```

由于函数是对象，而且 `PureComponent` 会对 props 进行严格相等的检查，因此，一个内联的函数将**总是**无法通过 prop 的 diff 检查，从而转向 reconciler 中的元素 diff 检查。

可以看出，这不仅仅只关乎内联函数。函数简直就是 object, function, array 三部曲演绎推广的主唱。

为了让 `shouldComponentUpdate` 高兴，你必须保持函数的引用标识。对经验丰富的 JavaScript 开发者来说，这不算糟。但是 [Michael](https://medium.com/@mjackson)  和我领导了一个有3500多人参加的研讨会，他们的开发经验各不相同，而这对很多人来说都并不容易。ES 的类也没有提供引导我们进入各种 JavaScript 路径的帮助：

```
class Dashboard extends Component {
  constructor(props) {
    super(props)
    
    // 使用 bind ？拖慢初始化的速度，看上去不妙
    // 当你有 20 个 bind 的时候（我见过你的代码，我知道）
    // 它会增加打包后文件的大小
    this.handleStuff = this.handleStuff.bind(this)

    // _this 一点也不优雅
    var _this = this
    this.handleStuff = function() {
      _this.setState({})
    }
    
    // 如果你会用 ES 的类，那你很可能会使用箭头
    // 函数（通过 babel ，或使用现代浏览器）。这不是很难但是
    // 把你所有的处理程序都放在构造函数中就
    // 不太好了
    this.handleStuff = () => {
      this.setState({})
    }
  }
  
  // 这个很不错，但它不是 JavaScript ，至少现在还不是，所以现在
  // 我们要讨论的是 TC39 如何工作，并评估我们的草案
  // 阶段风险容忍度
  handleStuff = () => {}
}
```

学习如何保持函数的引用标识将会引出一个令人惊讶的长篇大论。

通常没有理由强迫人们这么做，除非有一个 eslint 配置对他们大喊大叫。我想展示的是，内联函数和提升性能两者可以兼得。但首先，我想讲一个我自己遇到的性能相关的故事。

### 我使用 PureComponent 的经历

当我第一次了解到 `PureRenderMixin`（在 React 的早期版本中叫这个，后来改为 `PureComponent` ）时，我进行了大量的测试，来测试我的应用程序的性能。然后，我将 `PureRenderMixin` 添加到每个组件中。当我采取了一套优化后的测量方法时，我希望有一个关于一切变得有多快的很酷的故事可以讲。

让人大跌眼镜的是，我的应用程序变慢了 🤔。

为什么呢？仔细想想，如果你有一个 `Component` ，会有多少次 diff 检查？如果你有一个 `PureComponent` ，又会有多少次 diff 检查？答案分别是“只有一次”和“至少一次，有时是两次”。如果一个组件**经常**在更新时发生变化，那么 `PureComponent` 将会执行两次 diff 检查而不是一次（props 和 state 在 `shouldComponentUpdate` 中进行的严格相等比较，以及常规的元素 diff 检查）。这意味着**通常**它会变慢，**偶尔**会变快。显然，我的大部分组件大部分时间都在变化，所以总的来说，我的应用程序变慢了。啊哦😯。

在性能方面没有银弹。你必须测量。

### 三种情景

在本文的开头，我展示了三种内联函数。现在我们已经了解了一些背景，让我们来一一讨论一下它们。但是请记住，在你有一个衡量标准来判定之前，请先将 `PureComponent` 束之高阁。

#### DOM 组件事件处理程序

```
<button
  onClick={() => this.setState(…)}
>click</button>
```

通常，在 buttons，inputs，和其他 DOM 组件的事件处理程序中，除了 `setState` 以外，不会做其他的事情。这让内联函数成为了通常情况下最干净的方法。它们不是在文件中跳来跳去寻找事件处理程序，而是把内容放在同一位置。React 社区通常欢迎这种方式。

`button` 组件（以及所有其他的DOM组件）甚至都算不上是 `PureComponent`，所以这里也不存在 `shouldComponentUpdate` 引用标识的问题。

所以，认为这个过程很慢的唯一原因是，你是否认为简单地定义一个函数会产生足以让人担心的开销。我们已经讨论过，这在任何地方都未被证实。这只是纸上谈兵的性能假设。在被证实之前，这样做没问题。

#### 一个“自定义事件”或“操作”

```
<Sidebar onToggle={(isOpen) => {
  this.setState({ sidebarIsOpen: isOpen })
}}/>
```

如果 `Sidebar` 是 `PureComponent`，我们将会打破 prop 的 diff 检查。再一次，由于处理程序很简单，最好把它们都放在同一位置。

对于像 `onToggle` 这样的事件，`Sidebar` 还有什么必要对它执行 diff 检查呢？只有两种情况才需要将 prop 包含在 `shouldComponentUpdate` 的 diff 检查中：

1.  你使用 prop 来进行渲染
2.  你使用 prop 来在 `componentWillReceiveProps`，`componentDidUpdate`，或者 `componentWillUpdate` 中产生一些其他的作用

大多数 `on<whatever>` prop 都不符合这些要求。因此，多数 `PureComponent` 的用法都会导致多次执行 diff 检查，迫使开发人员不必要地维护处理程序的引用标识。

我们只应该对会产生影响的 prop 执行 diff 检查。这样，人们就可以将处理程序放在同一位置，并且仍然可以获得想要寻求的性能提升(而且由于我们关心性能，所以我们希望执行更少次数的 diff 检查！)

对于大多数组件，我建议创建一个 `PureComponentMinusHandlers` 类并从中继承，而不是从 `PureComponent` 中继承。它可以跳过对函数的所有检查。鱼与熊掌兼得。

好吧，差不多是这样的。

如果你接收到一个函数并直接将它传递给另一个组件，它将会无法及时更新。看一下这个：

```
// 1. App 会传递一个 prop 给 From 表单
// 2. Form 将向下传递一个函数给 button
//    这个函数与它从 App 得到的 prop 相接近
// 3. App 会在 mounting 之后 setState，并传递
//    一个**新**的 prop 给 Form
// 4. Form 传递一个新的函数给 Button，这个函数与
//    新的 prop 相接近
// 5. Button 会忽略新的函数, 并无法
//    更新点击处理程序，从而提交陈旧的数据

class App extends React.Component {
  state = { val: "one" }

  componentDidMount() {
    this.setState({ val: "two" })
  }

  render() {
    return <Form value={this.state.val} />
  }
}

const Form = props => (
  <Button
    onClick={() => {
      submit(props.value)
    }}
  />
)

class Button extends React.Component {
  shouldComponentUpdate() {
    // 让我们假装比较了除函数以外的一切东西
    return false
  }

  handleClick = () => this.props.onClick()

  render() {
    return (
      <div>
        <button onClick={this.props.onClick}>这个的数据是旧的</button>
        <button onClick={() => this.props.onClick()}>这个工作正常</button>
        <button onClick={this.handleClick}>这个也工作正常</button>
      </div>
    )
  }
}
```

[这是一个运行该应用程序的沙箱](https://codesandbox.io/s/v38y6zk8ml).

因此，如果你喜欢从 `PureRenderWithoutHandlers` 继承的想法，请确保永远不要将你要在 diff 检查中要忽略的处理程序**直接**传递给其他组件——你需要以某种方式包装它们。

现在，我们要么必须维护引用标识，要么必须避免引用标识！欢迎来到性能优化。至少在这种方法中，必须处理的是优化组件，而不是使用它的代码。

我要坦率地说，这个示例应用程序是我在发布 [Andrew Clark](https://medium.com/@acdlite) 后所做的编辑，它引起了我的注意。在这里，您认为我足够聪明，知道什么时候管理引用标识，什么时候不管理了吧！😂

#### 一个 render prop

```
<Route
  path="/topic/:id"
  render={({ match }) => (
    <div>
      <h1>{match.params.id}</h1>}
    </div>
  )
/>
```

用来渲染的 prop 是一种模式，它用来创建一个用于组成和管理共享状态的组件。（[你可以在这里了解更多](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce)）。它的内容对组件来说是未知的，举个栗子🌰：

```
const App = (props) => (
  <div>
    <h1>Welcome, {props.name}</h1>
    <Route path="/" render={() => (
      <div>
        {/*
          prop.name 是从路由外部传入的，它不是作为 prop 传递进来的，
          因此路由不能可靠地成为一个PureComponent，它
          不知道在组件内部会渲染什么
        */}
        <h1>Hey, {props.name}, let's get started!</h1>
      </div>
    )}/>
  </div>
)
```

这意味着一个内联的用来渲染的 prop 函数不会导致 `shouldComponentUpdate` 的问题：它永远没有足够的信息来成为一个 `PureComponent`。

所以，唯一的反对意见又回到了相信简单地定义一个函数是缓慢的。重复第一个例子：没有证据支持这一观点。这只是纸上谈兵的性能假设。

![](https://raw.githubusercontent.com/wznonstop/wznonstop.github.io/master/images/2018-03-28-1.png)

### 总结

1.  自然地编写代码，设计代码
2.  测量你的交互，找到慢在哪里。[这里是方法](https://reactjs.org/blog/2016/11/16/react-v15.4.0.html#profiling-components-with-chrome-timeline).
3.  仅在需要的时候使用 `PureComponent` 和 `shouldComponentUpdate`，避免使用 prop 函数（除非它们在生命周期的钩子函数中为产生某种作用而使用）。

如果你真的相信过早的优化不是好主意，那么你就不需要证明内联函数是快的，而是需要证明它们是慢的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
