> * 原文地址：[React, Inline Functions, and Performance](https://cdb.reacttraining.com/react-inline-functions-and-performance-bdff784f5578)
> * 原文作者：[Ryan Florence](https://cdb.reacttraining.com/@ryanflorence?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-inline-functions-and-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-inline-functions-and-performance.md)
> * 译者：[wznonstop](https://github.com/wznonstop)
> * 校对者：

# React，内联函数和性能

我和妻子近期完成了一次声势浩大的装修。我们迫不及待地想向人们展示我们的新意。我们让我的婆婆来参观，她走进那间装修得很漂亮的卧室，抬头看了看那扇构造精巧的窗户，然后说："居然没有百叶窗？"😐

![](https://cdn-images-1.medium.com/max/1000/1*_WL8zajmqcczto2bjiBqpw.jpeg)

**我们的新卧室；天哪，它看起来就像一张杂志的照片。而且，没有百叶窗。** 

我发现，当我谈论React的时候，会有同样的情绪。我将通过研讨会的第一堂课，展示一些很酷的新OSS。总是有人说："内联函数？ 我听说它们很慢。"

并不总是这样，但最近几个月这个观点每天都会出现。作为一名讲师和代码库的作者，这让人感到精疲力竭。不幸的是，我可能有点傻，之前只知道在Twitter上咆哮，而不是去写一些可能对别人来说有深刻见解的东西。所以，我就来尝试一下更好的选择了 😂。

### "内联函数"是什么

在React的领域里，一个内联函数是指在React进行"rendering"时定义的函数。 人们常常对 React 中"render"的两种含义感到困惑，一种是指在 update 期间从组件中获取 React 元素（调用组件的 render 方法）；另一种是渲染更新真实的DOM结构。本文中提到的"rendering"都是指第一种。

下列是一些内联函数的栗子🌰：

```
class App extends Component {
  // ...
  render() {
    return (
      <div>
        
        {/* 1. 一个内联的"DOM组件"事件处理程序 */}
        <button
          onClick={() => {
            this.setState({ clicked: true })
          }}
        >
          Click!
        </button>
        
        {/* 2. 一个"自定义事件"或"操作" */}
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

在我们开始下一步之前，我们需要讨论一下如何优化一个程序。询问任意一个性能方面的专家他们都会告诉你不要过早地优化你的程序。所有人，是的，他们中的每一个人，100% 有着性能相关的丰富的经验的人，都会告诉你不要过早地优化你的代码。

> 如果你不去进行测量，你甚至不知道你做的优化工作是否真的实现了性能的优化，更不会知道它们是否让事情变得更糟。

我记得我的朋友 Ralph Holzmann 发表的关于 gzip 如何工作的演讲，这个演讲巩固了我对此的看法。他谈到了一个他用古老的脚本加载库 LABjs 做的实验。你可以观看[这个视频](https://vimeo.com/34164210)的 30:02 到 32:35 来了解它，或者继续阅读本文。

当时 [LABjs](https://github.com/getify/LABjs)的源码在性能上做了一些令人尴尬的事情。它没有使用普通的对象表示法(`obj.foo`)，而是将键存储在字符串中，并使用方括号表示法来访问对象(`obj[stringForFoo]`)。这样做的想法源于，经过小型化和gzip压缩之后，非自然编写的代码将比自然编写的代码体积小。 [你可以在这里看到它](https://github.com/getify/LABjs/blob/b23ee3fcad12157cf8f6a291cb54fd7550ac7f3b/LAB.src.js#L7-L34)。

Ralph fork了源代码，通过自然地编写代码移除了优化的部分，没有去考虑如何优化以实现小型化和gzip。

事实证明，移除"优化部分"后，文件大小削减了 5.3% ！如果你不去进行测量，你甚至不知道你做的优化工作是否真的实现了性能的优化，更不会知道它们是否让事情变得更糟！

过早的优化不仅会占用开发时间，损害代码的整洁，甚至会产生适得其反的结果 _导致_ 性能问题，就像LABjs那样。如果作者一直在进行测量，而不仅仅是想象性能问题，就会节省开发时间，同时能让代码更简洁，性能更好。

不要过早地进行优化。好了，回到React。

### 为什么人们说内联函数很慢？

两个原因：内存/垃圾回收问题和`shouldComponentUpdate`。

#### 内存和垃圾回收

首先，人们（和[eslint configs](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-no-bind.md)）担心创建内联函数产生的内存和垃圾回收成本。在箭头函数普及之前，很多代码都会内联地调用`bind`，这在历史上表现不佳。例如：

```
<div>
  {stuff.map(function(thing) {
    <div>{thing.whatever}</div>
  }.bind(this)}
</div>
```

`Function.prototype.bind`的性能问题[在此得到了解决](http://benediktmeurer.de/2015/12/25/a-new-approach-to-function-prototype-bind/)，而且箭头函数要么是原生函数，要么是由Babel转换为普通函数；在这两种情况下，我们都可以假定它并不慢。

记住，你不要坐在那里然后想象"我赌这个代码肯定慢"。你应该自然地编写代码， _然后_ 测量它。如果存在性能问题，就修复它们。我们不需要证明一个内联的箭头函数是快的，也不需要另一些人来证明它是慢的。否则，这就是一个过早的优化。

据我所知，还没有人对他们的应用程序进行分析，表明内联箭头功能很慢。在此之前，这甚至不值得谈论——但无论如何，我会提供一个更多的想法 😝

如果创建内联函数的成本很高，以至于需要使用eslint规则来规避它，那么我们为什么要将该开销转移到初始化的热路径上呢？

```
class Dashboard extends Component {
  state = { handlingThings: false }
  
  constructor(props) {
    super(props)
    
    this.handleThings = () =>
      this.setState({ handlingThings: true })

    this.handleStuff = () => { /* ... */ }

    // bind的开销更昂贵
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

因为过早地优化，我们已经将组件的初始化速度降低了3倍！如果所有处理程序都是内联的，那么在初始化中只需要创建一个函数。相反的，我们则要创建3个。我们没有测量任何东西，所以没有理由认为这是一个问题。

如果你想完全忽略这一点，那么就去制定一个eslint规则，来要求在任何地方都使用内联函数来加快初始渲染速度🤦🏾‍♀。

#### PureComponent 和 shouldComponentUpdate

这才是问题真正的症结所在。你可以通过理解两件事来看到真正的性能提升：`shouldComponentUpdate` 和JavaScript严格相等的比较。如果不能很好地理解它们，就可能在无意中以性能优化的名义使React代码更难处理。

当你调用`setState`时，React会将旧的React元素与一组新的React元素进行比较（这称为r_econciliation_，你可以在[这里阅读相关资料](https://reactjs.org/docs/reconciliation.html) ），然后使用该信息更新真实的DOM元素。有时候，如果你有很多元素需要检查，这个过程就会变得很慢（比如一个大的SVG）。React为这类情况提供了逃生舱口，名叫`shouldComponentUpdate`。

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

如果你的组件定义了 `shouldComponentUpdate` ，那么在React进行新旧组件对比之前，它会询问`shouldComponentUpdate`有没有变更发生。如果返回了false，那么React将会直接跳过元素diff检查，从而节省一些时间。如果你的组件足够大，这会对性能产生相当大的影响。

优化组件的最常见方法是扩展"React.PureComponent"而不是"React.Component"。一个`PureComponent`会在`shouldComponentUpdate`中比较props和state，这样你就不用手动执行了。

```
class Avatar extends React.PureComponent { ... }
```

当被要求更新时，`Avatar`会对它的props和state使用一个严格相等比较，希望以此来加快速度。

#### 严格相等比较

JavaScript中有六种基本类型：string, number, boolean, null, undefined, 和 symbol。当你对两个值相同的基本类型进行"严格相等比较"的时候，你会得到一个`true`值。举个例子🌰:

```
const one = 1
const uno = 1
one === uno // true
```

当`PureComponent`比较props时，它会使用严格相等比较。这对内联原始值非常有效: `<Toggler isOpen={true}/>`。

prop的比较只会在有非原始类型们出现的时候产生问题——啊，说错了，抱歉，是 _类型_ 而不是类型们。只有一种其他类型，那就是 `Object`。你问函数和数组？事实上，它们都是对象（`Object`）。

> 函数是具有附加的可调用功能的常规对象。

> - [https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures)

哈哈哈，好吧JavaScript。无论如何，对对象使用严格相等检查，即使表面上看起来相等的值，也会被判定为`false`（不相等）：

```
const one = { n: 1 }
const uno = { n: 1 }
one === uno // false
one === one // true
```

所以，如果你在JSX中内联地使用一个对象，它会使`PureComponent`的prop diff检查失效，转而使用较昂贵的方式对React元素进行diff检查。元素的diff将变为空，这样就浪费了两次进行差异比较的时间。

```
// 第一次 render
<Avatar user={{ id: ‘ryan’ }}/>

// 下一次 render
<Avatar user={{ id: ‘ryan’ }}/>

// prop diff 认为有东西发生了变化，因为 {} !== {}
// 元素diff检查 (reconciler) 发现没有任何变化
```

由于函数是对象，而且`PureComponent`会对props进行严格相等的检查，因此，一个内联的函数将 _总是_ 无法通过prop 的diff检查，从而转向reconciler中的元素diff检查。

可以看出，这不仅仅只关乎内联函数。函数简直就是object, function, array三部曲演绎推广的主唱。

为了让`shouldComponentUpdate`高兴，你必须保持函数的引用身份。对经验丰富的JavaScript开发者来说，这不算糟。但是[Michael](https://medium.com/@mjackson) 和我领导了一个有3500多人参加的研讨会，他们的开发经验各不相同，而这对很多人来说都并不容易。ES的类也没有提供引导我们进入各种JavaScript路径的帮助：

```
class Dashboard extends Component {
  constructor(props) {
    super(props)
    
    // 使用bind？拖慢初始化的速度，看上去不妙
    // 当你有20个bind的时候（我见过你的代码，我知道）
    // 它会增加打包后文件的大小
    this.handleStuff = this.handleStuff.bind(this)

    // _this 一点也不优雅
    var _this = this
    this.handleStuff = function() {
      _this.setState({})
    }
    
    // 如果你会用ES的类，那你很可能会使用箭头
    // 函数（通过babel，或使用现代浏览器）。这不是很难但是
    // 把你所有的处理程序都放在构造函数中就
    // 不太好了
    this.handleStuff = () => {
      this.setState({})
    }
  }
  
  // 这个很不错，但它不是JavaScript，至少现在还不是，所以现在
  // 我们要讨论的是 TC39 如何工作，并评估我们的
  // 阶段风险容忍度
  handleStuff = () => {}
}
```

学习如何保持函数的引用身份将会引出一个令人惊讶的长篇大论。

通常没有理由强迫人们这么做，除非有一个eslint配置对他们大喊大叫。我想展示的是，你可以兼得内联函数和提升性能两者。但首先，我想讲一个我自己遇到的性能相关的故事。

### 我使用 PureComponent 的经历

当我第一次了解到`PureRenderMixin`（在React的早期版本中叫这个，后来改为`PureComponent`）时，我进行了大量的测试，来测试我的应用程序的性能。然后，我将`PureRenderMixin`添加到每个组件中。当我采取了一套优化后的测量方法时，我希望有一个关于一切变得有多快的很酷的故事可以讲。

让人大跌眼镜的是，我的应用程序变慢了 🤔。

为什么呢？仔细想想，如果你有一个`Component`，会有多少次diff检查？如果你有一个`PureComponent`，又会有多少次diff检查？答案分别是"只有一次"和"至少一次，有时是两次"。如果一个组件 _经常_ 在更新时发生变化，那么`PureComponent`将会执行两次diff检查而不是一次（props和state在`shouldComponentUpdate`中进行的严格相等比较，以及常规的元素diff检查）。这意味着 _通常_ 它会变慢， _偶尔_ 会变快。显然，我的大部分组件大部分时间都在变化，所以总的来说，我的应用程序变慢了。啊哦😯。

在性能方面没有银弹。你必须测量。

### The three scenarios

At the start of the article I showed three types of inline functions. Now that we have some background, let’s talk about each one them. But please remember to keep `PureComponent` on the shelf until you have a measurement to justify it.

#### DOM component event handler

```
<button
  onClick={() => this.setState(…)}
>click</button>
```

It’s common to do nothing more than `setState` inside of event handlers for buttons, inputs, and other DOM components. This often makes an inline function the cleanest approach. Instead of bouncing around the file to find the event handlers, they’re colocated. The React community generally welcomes colocation.

The `button` component (and every other DOM component) can’t even be a `PureComponent`, so there are no `shouldComponentUpdate` referential identity concerns here.

So, the only reason to think this is slow is if you think simply defining a function is a big enough expense to worry about. We’ve discussed that there is no evidence anywhere that it is. It’s simply armchair performance postulation. These are fine until proven otherwise.

#### A “custom event” or “action”

```
<Sidebar onToggle={(isOpen) => {
  this.setState({ sidebarIsOpen: isOpen })
}}/>
```

If `Sidebar` is a `PureComponent` we will be breaking the prop diff. Again, since the handler is simple, the colocation can be preferable.

With an event like `onToggle`, why is `Sidebar` even diffing it? There are only two reasons to include a prop in the `shouldComponentUpdate` diff:

1.  You use the prop to render.
2.  You use the prop to perform a side-effect in `componentWillReceiveProps`, `componentDidUpdate`, or `componentWillUpdate`.

Most `on<whatever>` props do not meet either of these requirements. Therefore, most `PureComponent` usages are over-diffing, forcing developers to maintain referential identity of the handler needlessly.

We should only diff the props that matter. That way people can colocate handlers and still get the performance gains you’re seeking (and since we’re concerned about performance, we’re diffing less!).

For most components, I’d recommend creating a `PureComponentMinusHandlers` class and inherit from that instead of inheriting from `PureComponent`. It could just skip all checks on functions. Have your cake and eat it too.

Well, almost.

If you receive a function and pass that function directly into another component, it’ll get stale. Check this out:

```
// 1. App will pass a prop to Form
// 2. Form is going to pass a function down to button
//    that closes over the prop it got from App
// 3. App is going to setState after mounting and pass
//    a *new* prop to Form
// 4. Form passes a new function to Button, closing over
//    the new prop
// 5. Button is going to ignore the new function, and fail to
//    update the click handler, submitting with stale data

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
    // lets pretend like we compared everything but functions
    return false
  }

  handleClick = () => this.props.onClick()

  render() {
    return (
      <div>
        <button onClick={this.props.onClick}>This one is stale</button>
        <button onClick={() => this.props.onClick()}>This one works</button>
        <button onClick={this.handleClick}>This one works too</button>
      </div>
    )
  }
}
```

[Here’s a codesandbox running that app](https://codesandbox.io/s/v38y6zk8ml).

So, if you like the idea of inheriting from a `PureRenderWithoutHandlers`, make sure you don’t ever pass your ignored handlers _directly_ to other components — you need to wrap them one way or another.

Now we either have to maintain referential identity, or we have to avoid referential identity! Welcome to performance optimization. At least with this approach it’s the optimized component that has to deal with it, not the code using it.

I’m going to be candid, that example app is an edit I made after publishing that [Andrew Clark](https://medium.com/@acdlite) brought to my attention. And here you thought I was smart enough to know when to manage referential identity and when not to! 😂

#### A render prop

```
<Route
  path=”/topic/:id”
  render={({ match }) => (
    <div>
      <h1>{match.params.id}</h1>}
    </div>
  )
/>
```

Render props are a pattern used to create a component that exists to compose and manage shared state. ([You can read more about them here](https://cdb.reacttraining.com/use-a-render-prop-50de598f11ce).) The contents of the render prop are unknowable to the component. For example:

```
const App = (props) => (
  <div>
    <h1>Welcome, {props.name}</h1>
    <Route path=”/” render={() => (
      <div>
        {/*
          props.name is from outside of Route and it’s not passed in
          as a prop, so Route can’t reliably be a PureComponent, it
          has no knowledge of what is rendered inside here.
        */}
        <h1>Hey, {props.name}, let’s get started!</h1>
      </div>
    )}/>
  </div>
)
```

That means an inline render prop function won’t cause problems with `shouldComponentUpdate`: It can’t ever know enough to be a `PureComponent.`

So, the only other objection is back to believing that simply defining functions is slow. Repeating from the first example: there’s no evidence to support that. It’s simply armchair performance postulation.

![Snipaste_2018-03-22_18-47-55.png](https://i.loli.net/2018/03/22/5ab389e694b03.png)

### In summary

1.  Write your code naturally, code to the design.
2.  Measure your interactions to find slow paths. [Here’s how](https://reactjs.org/blog/2016/11/16/react-v15.4.0.html#profiling-components-with-chrome-timeline).
3.  Use `PureComponent` and `shouldComponentUpdate` only when you need to, skipping prop functions (unless they are used in lifecycle hooks for side-effects).

If you really believe that premature optimization is bad practice, then you won’t need proof that inline functions are fast, you need proof that they are slow.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
