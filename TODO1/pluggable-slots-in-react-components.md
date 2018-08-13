> * 原文地址：[Pass Multiple Children to a React Component with Slots](https://daveceddia.com/pluggable-slots-in-react-components/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pluggable-slots-in-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pluggable-slots-in-react-components.md)
> * 译者：
> * 校对者：

# 如何向带有插槽的 React 组件传递多个 Children 

![](https://daveceddia.com/images/slots@2x.png)

假如你需要写一个可以重复使用的组件。可是呢，名为 `children` 的 prop 不能解决这个需求。这个组件得有能力接收**不止一个** children，而且这些 children 的放置还不是相邻的，而是按照需求而定。

可能你在写的是带有一个标题、一个边栏和一个内容区块的名为 `Layout` 的组件。又或者你正巧在写一个带有左右两侧动态边栏的 `NavBar` 组件。

以上这些任务都可以轻松地借助 “插槽” 模式完成，换言之就是传递 JSX 到一个 prop 中去。

**小结**：你可以把 JSX 传向**任何**而不只是叫 `children` 的prop，也并不局限于通过在一个组件的标签里嵌入 JSX —— 从而在简化数据传递的同时呢，也让组件有更多被重复使用的价值。 

## 快速回顾 React 里的 Children

咱们得先共同了解这样一个事实：React 能够让你通过在 JSX 标签之间嵌套 **children** 的方式来向组件传递 **children**。这些元素 （零个、一个或多个）在那个组件里将以名为 `children` 的 prop 的形式存在。 React 的名为 `children` 的 prop 其实相当于 Angular 的 transclusion 还有 Vue 的 `<slot>`。

这里有一个向 `Button` 组件传递 children 的例子：

```
<Button>
  <Icon name="dollars"/>
  <span>BUY NOW</span>
</Button>
```

咱们详细地探究一下 `Button` 这个组件的实现，并看看它对 children 都做了什么：

```
function Button(props) {
    return (
    <button>
        {props.children}
    </button>
    );
}
```

`Button` 有效地将你之前传的东西用一个 `button` 元素封装了起来。到这一步虽然没有什么石破天惊的，但这却是一个实用的能力。它让接收信息的组件得以把 children 放置在布局的任何位置，或是为了变换风格样式而将其封装在一个The `className` 里。被渲染之后的 HTML 代码看起来会是这样子：

```
<button>
    <i class="fa fa-dollars"></i>
    <span>BUY NOW</span>
</button>
```

（顺便一提，这里咱们假设 `Icon` 组件渲染出了 `<i>` 标签。）

### Children 也是一个普通的 Prop

React 针对 children 的这个用法挺炫的：被嵌套的元素可以指定成名为 `children` 的 prop，然而这并不是一个神奇而特殊的 prop 。你可以给一个 prop 指定任何其他的元素。且看：

```
// 这行代码其实 ——
<Button children={<span>Click Me</span>} />

// 相当于以下的代码。
<Button>
  <span>Click Me</span>
</Button>
```

所以你不仅能够像传递一个普通的 prop 那样去传递 `children`，还可以往 prop 里传递 JSX 代码。意不意外？没错，这个功能并不专属于名为“children”的 prop！

## 以命名的卡槽来使用 Props 

如果我告诉你，你可以向任何 prop 传递 JSX 代码，你会咋想？

（你已经知道这个秘密了，不是吗？）
这里有一个使用这些 “卡槽” 的 props 的例子 —— 以 3 个 props 调用一个名为 `Layout` 的组件：

```
<Layout
  left={<Sidebar/>}
  top={<NavBar/>}
  center={<Content/>}
/>
```

在这个名为 `Layout` 的组件之中，它可以随心所欲地使用 `left` ，`top` 以及 `center` 这三个 prop。以下是一个简单的例子：

```
function Layout(props) {
  return (
    <div className="layout">
      <div className="top">{props.top}</div>
      <div className="left">{props.left}</div>
      <div className="center">{props.center}</div>
    </div>
  );
}
```

试想一下， `Layout` 组件内的代码可以变得十分复杂，它可以拥有很多嵌套的 `div` 或 Bootstrap 类名等等。这个组件亦可以给更细致的组件传递信息。 无论 `Layout` 需要做什么，它的使用者只需要知道如何传递 `left`，`top` 以及 `center` 这三个 prop 就够了。

### 使用 Children 来直接传递 Props

关于传递 children还有一个很不错的特性（无论使用的 prop 是否为 `children` ）：当你打算传递 child prop 的时候，正好在 **parent** 的作用域内，这时你可以向下传递任何你所需要的信息。

这就好比 **跃过了一个层级**。举个例子：与其去传递一个 “user” 给 Layout 组件，然后让 Layout 再将 “user” 传向 NavBar 组件，还不如直接创建一个 NavBar（已经设好 user ）然后把整个 NavBar 传向 Layout。
这可以帮助避免 “prop 钻井” 的问题，你不必再费心地将一个 prop 放进好多个组件的层级。

```
function App({ user }) {
  return (
    <div className="app">
      <Nav>
        <UserAvatar user={user} size="small" />
      </Nav>
      <Body
        sidebar={<UserStats user={user} />}
        content={<Content />}
      />
    </div>
  );
}

// 接收 children 并渲染它（们）
const Nav = ({ children }) => (
  <div className="nav">
    {children}
  </div>
);

// Body 需要一个侧边栏和内容，如果像下面这样写的话，
// 他们可以做任何事
const Body = ({ sidebar, content }) => (
  <div className="body">
    <Sidebar>{sidebar}</Sidebar>
    {content}
  </div>
);

const Sidebar = ({ children }) => (
  <div className="sidebar">
    {children}
  </div>
);

const Content = () => (
  <div className="content">main content here</div>
);
```

现在和下面这个写法比较一下，Nav 和 Body 都接受名为 `user` 的 prop，然后它们负责手动将 prop 传递给 children。在那之后，它们的 children 必须给更细一层的 children 传递下去……

```
function App({ user }) {
  return (
    <div className="app">
      <Nav user={user} />
      <Body user={user} />
    </div>
  );
}

const Content = () => <div className="content">main content here</div>;

const Sidebar = ({ user }) => (
  <div className="sidebar">
    <UserStats user={user} />
  </div>
);

const Body = ({ user }) => (
  <div className="body">
    <Sidebar user={user} />
    <Content user={user} />
  </div>
);

const Nav = ({ user }) => (
  <div className="nav">
    <UserAvatar user={user} size="small" />
  </div>
);
```

没有之前那个写法方便，不是吗？用这种方法向下传递 prop （又称 “prop 钻井”）会让组件之间被太多你可能不想要的麻烦所羁绊 —— 并不一定总是坏事，但你最好搞清楚它们之间都是怎么连接的。上面第一种使用 children 的写法可以避免对更复杂解决办法的需求，比如说可能要用到 context， Redux 或 MobX (还有好多别的）。

### 要当心 PureComponent 或 shouldComponentUpdate

如果你需要在一个带有 children 的组件上实现 `shouldComponentUpdate` （抑或 `PureComponent` ），用来防止二次渲染，同时 children 也无法被渲染出来。所以要注意这一点。在实际操作中，带有 “插槽” 的组件很有可能体积小而且渲染速度快，所以不太会需要性能方面的调整。 

不过如果你遇到了**确实**需要调整 “插槽” 组件的性能的情况，那么可以考虑把表现性能过慢的部分代码提取出来，单独放进一个组件，然后进行调整。

学习 React 有时会很痛苦 —— 代码库和工具实在太多啦！
想听我的意见吗？那就是将那些代码库和工具通通忽略掉 ：）  
若阁下想要步步为营的引导，就请阅读我写的书吧 —— [Pure React](https://daveceddia.com/pure-react/?utm_campaign=after-post)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
