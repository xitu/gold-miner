> * 原文地址：[React Performance Fixes on Airbnb Listing Pages](https://medium.com/airbnb-engineering/recent-web-performance-fixes-on-airbnb-listing-pages-6cd8d93df6f4)
> * 原文作者：[Joe Lencioni](https://medium.com/@lencioni?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/recent-web-performance-fixes-on-airbnb-listing-pages.md](https://github.com/xitu/gold-miner/blob/master/TODO/recent-web-performance-fixes-on-airbnb-listing-pages.md)
> * 译者：[木羽 zwwill](https://github.com/zwwill)
> * 校对者：[tvChan](https://github.com/tvChan), [atuooo(史金炜)](https://github.com/atuooo)


# 针对 Airbnb 清单页的 React 性能优化

**简要：可能在某些领域存在一些触手可及的性能优化点，虽不常见但依然很重要。**

* * *

我们一直在努力把 airbnb.com 的核心预订流程迁移到一个使用 [React Router](https://github.com/ReactTraining/react-router) 和 [Hypernova](https://github.com/airbnb/hypernova) 技术的服务端渲染的单页应用。年初，我们推出了登陆页面，搜索结果告诉我们很成功。我们的下一步是将[清单详情页](https://www.airbnb.com/rooms/8357)扩展到单页应用程序里去。

![](https://cdn-images-1.medium.com/max/600/1*E__f8FixGkfXtq7tia8leg.png)

airbnb.com 的清单详情页: [https://www.airbnb.com/rooms/8357](https://www.airbnb.com/rooms/8357)

这是您在确定预订清单时所访问的页面。在整个搜索过程中，您可能会多次访问该页面以查看不同的清单。这是 airbnb 网站访问量最大同时也是最重要的页面之一，因此，我们必须做好每一个细节。

作为迁移到我们的单页应用的一部分，我希望能排查出所有影响清单页交互性能的遗留问题（例如，滚动、点击、输入）。让页面**启动更快并且延迟更短**，这符合我们的目标，而且这会让使用我们网站的人们有更好的体验。

**通过解析、修复、再解析的流程，我们极大地提高了这个关键页的交互性能，使得预订体验更加顺畅，更令人满意**。在这篇文章中，您将了解到我用来解析这个页面的技术，用来优化它的工具，以及在解析结果给出的火焰图表中感受优化的效果。

### 方法

这些配置项通过Chrome的性能工具被记录下来:

1. 打开隐身窗口（这样我的浏览器扩展工具不会干扰我的解析）。
2. 使用 `?react_perf` 在查询字符串中进行配置访问本地开发页面（启用 React 的 User Timing 注释，并禁用一些会使页面变慢的 dev-only 功能，例如 [axe-core](https://www.axe-core.org/)）
3. 点击 record 按钮 ⚫️
4. 操作页面（如：滚动，点击，打字）
5. 再次点击 record 按钮 🔴，分析结果

![](https://cdn-images-1.medium.com/max/800/1*w_bDwdT9s_d25W7qE-DZ1g.gif)

**通常情况下，我推荐在移动设备上进行解析以了解在较慢的设备上的用户体验，比如 Moto C Plus，或者 CPU 速度设置为 6x 减速。然而，由于这些问题已经足够严重了，以至于即使是在没有节流的情况下，在我的高性能笔记本电脑上结果表现也是明显得糟糕。**

### 初始化渲染

在我开始优化这个页面时，我注意到控制台上有一个警告:💀

```
webpack-internal:///36:36 Warning: React attempted to reuse markup in a container but the checksum was invalid. This generally means that you are using server rendering and the markup generated on the server was not what the client was expecting. React injected new markup to compensate which works but you have lost many of the benefits of server rendering. Instead, figure out why the markup being generated is different on the client or server: (client) ut-placeholder-label screen-reader-only" (server) ut-placeholder-label" data-reactid="628"
```

这是可怕的 客户端/服务端 不匹配问题，当服务器渲染不同于客户端初始化渲染时发生。这会迫使你的 Web 浏览器执行那些在使用服务器渲染时不应该做的工作，所以每当发生这种情况时 React 就会给出这样的提醒 ✋ 。

不过，错误信息并没有明确地表明底发生了什么，或者可能的原因是什么，但确实给了我们一些线索。🔎 我注意到一些看起来像 CSS 类的文本，所以我在终端里输入下面的命令：

```
~/airbnb ❯❯❯ ag ut-placeholder-label
app/assets/javascripts/components/o2/PlaceholderLabel.jsx
85:        'input-placeholder-label': true,

app/assets/stylesheets/p1/search/_SearchForm.scss
77:    .input-placeholder-label {
321:.input-placeholder-label,

spec/javascripts/components/o2/PlaceholderLabel_spec.jsx
25:    const placeholderContainer = wrapper.find('.input-placeholder-label');
```

很快地我将搜索范围缩小到了 `o2/PlaceHolderLabel.jsx` 这个文件，一个在顶部渲染的搜索组件。

![](https://cdn-images-1.medium.com/max/800/0*M_D7Zs1HFsSoY7Po.)

事实上，我们使用了一些特征检测，以确保在旧浏览器（如 IE）中可以看到 `placeholder`，如果在当前的浏览器中不支持 `placeholder`，则会以不同的方式呈现 `input`。特征检测是正确的方法（与用户代理嗅探相反），但是由于在服务器渲染时没有浏览器检测功能，导致服务器总是会渲染一些额外的内容，而不是大多数浏览器将呈现的内容。 

这不仅降低了性能，还导致了一些额外的标签被渲染出来，然后每次再从页面上删除。真难伺候！我把渲染的内容转化为 React 的 state，并将其设置到 `componentDidMount`，直到客户端渲染时才呈现。这完美的解决了问题。

![](https://cdn-images-1.medium.com/max/1000/1*Dz_-rY84jnCQrWhrlNkECw.png)

我重新运行了一遍 profiler 发现，`<SummaryContainer>` 在 mounting 后立刻更新。 

![](https://cdn-images-1.medium.com/max/1000/0*ZPHyNBzpm6oT1dqu.)

Redux 连接的 SummaryContainer 重绘消耗了 101.64 ms

更新后会重新渲染一个 `<BreadcrumbList>`、两个 `<ListingTitles>` 和一个 `<SummaryIconRow>` 组件，但是他们前后并没有任何区别，所以我们可以通过使用 `React.PureComponent` 使这三个组件的渲染得到显著的优化。方法很简单，如下

```
export default class SummaryIconRow extends React.Component {
  ...
}
```

改成这样：

```
export default class SummaryIconRow extends React.PureComponent {
  ...
}
```

接下来，我们可以看到 `<BookIt>` 在页面初始载入时也发生了重新渲染的操作。根据火焰图可以看出，大部分时间都消耗在渲染 `<GuestPickerTrigger>` 和 `<GuestCountFilter>` 组件上。

![](https://cdn-images-1.medium.com/max/800/0*0Houn_bWBi4x1rhe.)

BookIt 的重绘消耗了 103.15ms

有趣的是，除非用户操作，这些组件基本是不可见的 👻 。

![](https://cdn-images-1.medium.com/max/800/0*VicFFl6VVoKEvWp1.)

解决这个问题的方法是在不需要的时候不渲染这些组件。这加快了初始化的渲染，清除了一些不必要的重绘。🐎 如果我们进一步地进行优化，增加更多 PureComponents，那么初始化渲染会变得更快。

![](https://cdn-images-1.medium.com/max/800/0*A9Fk9rNQc-hlT4cq.)

BookIt 的重绘消耗了 8.52ms

### 来回滚动

通常我们会在清单页面上做一些平滑滚动的效果，但在滚动时效果并不理想。📜 当动画没有达到平滑的 60 fps（每秒帧），[甚至是 120 fps](https://dassur.ma/things/120fps/)，人们通常会感到不舒服也不会满意。**滚动是一种特殊的动画，是你的手指动作的直接反馈，所以它比其他动画更加敏感**。

稍微分析一下后，我发现我们在滚动事件处理机制中做了很多不必要的 React 组件的重绘！看起来真的很糟糕：

![](https://cdn-images-1.medium.com/max/800/0*CFcV7cUQMP2tuiLb.)

在没做修复之前，Airbnb 上的滚动性能真的很糟糕

我可以使用 `React.PureComponent` 转化 `<Amenity>`、`<BookItPriceHeader>` 和 `<StickyNavigationController>` 这三个组件来解决绝大部分问题。这大大降低了页面重绘的成本。虽然我们还没能达到 60 fps（每秒帧数），但已经很接近了。

![](https://cdn-images-1.medium.com/max/800/0*fV_INfZNo5ochcKA.)

经过一些修改后，Airbnb 清单页面的滚动性能略有改善

另外还有一些可以优化的部分。展开火焰图表，我们可以看到，`<StickyNavigationController>` 也产生了耗时的重绘。如果我们细看他的组件堆栈信息，可以发现四个相似的模块。

![](https://cdn-images-1.medium.com/max/800/0*m34rAJcm9zDr2IWu.)

StickyNavigationController 的重绘消耗了 8.52ms

`<StickyNavigationController>` 是清单页面顶部的一个部分，当我们不同部分间滚动时，它会联动高亮您当前所在的位置。火焰图表中的每一块都对应着常驻导航的四个链接之一。并且，当我们在两个部分间滚动时，会高亮不同的链接，所以有些链接是需要重绘的，就像下图显示的那样。

![](https://cdn-images-1.medium.com/max/800/1*sFbuI4zjaunWiOhINQiV6Q.gif)

现在，我注意到我们这里有四个链接，在状态切换时改变外观的只有两个，但在我们的火焰图表中显示，四个链接每都做了重绘操作。这是因为我们的 `<NavigationAnchors>` 组件每次切换渲染时都创建一个新的方法作为参数传递给 `<NavigationAnchor>`，这违背了我们纯组件的优化原则。

```
const anchors = React.Children.map(children, (child, index) => {      
  return React.cloneElement(child, {
    selected: activeAnchorIndex === index,
    onPress(event) { onAnchorPress(index, event); },
  });
});
```

我们可以通过确保 `<NavigationAnchor>` 每次被 `<NavigationAnchors>` 渲染时接收到的都是同一个 function 来解决这个问题。

```
const anchors = React.Children.map(children, (child, index) => {      
  return React.cloneElement(child, {
    selected: activeAnchorIndex === index,
    index,
    onPress: this.handlePress,
  });
});
```

接下来是 `<NavigationAnchor>`：

```
class NavigationAnchor extends React.Component {
  constructor(props) {
    super(props);
    this.handlePress = this.handlePress.bind(this);
  }

 handlePress(event) {
    this.props.onPress(this.props.index, event);
  }

  render() {
    ...
  }
}
```

在优化后的解析中我们可以看到，只有两个链接被重绘，事半功倍！并且，如果我们这里有更多的链接块，那么渲染的工作量将不再增加。

![](https://cdn-images-1.medium.com/max/800/0*UwwNS6-WeByC0sYm.)

StickyNavigationController 的重绘消耗了 8.52ms

[Dounan Shi](https://medium.com/@dounanshi) 再 [Flexport](https://medium.com/@Flexport) 一直在维护 [Reflective Bind](https://github.com/flexport/reflective-bind)，这是供你用来做这类优化的 Babel 插件。这个项目还处于起步阶段，还不足以正式发布，但我已经对它未来的可能性感到兴奋了。

继续看 Performance 记录的 Main 面板，我注意到我们有一个非常可疑的模块 `handleScroll`，每次滚动事件都会消耗 19ms。如果我们要达到 60 fps 就只有 16ms 的渲染时间，这明显超出太多。

![](https://cdn-images-1.medium.com/max/800/0*xRqIpxSt6fH22tCt.)

`_handleScroll` 消耗了 18.45ms

罪魁祸首的好像是 `onLeaveWithTracking` 内的某个部分。通过代码排查，问题定位到了 `<EngagementWrapper>`。然后在看看他的调用栈，发现大部分的时间消耗在了 React `setState`，但奇怪的是，我们并没有发现期间有产生任何的重绘。

深入挖掘 `<EngagementWrapper>`，我注意到，我们使用了 React 的 state 跟踪了实例上的一些信息。

```
this.state = { inViewport: false };
```

然而，**在渲染的流程中我们从来没有使用过这个 state，也没有监听它的变化来做重绘，也就是说，我们做了无用功**。将所有 React 的此类 state 用法转换为简单的实例变量可以让这些滚动动画更流畅。

```
this.inViewport = false;
```

![](https://cdn-images-1.medium.com/max/800/0*FIGmkF_IXHbb36Rx.)

滚动事件的 handler 消耗了 1.16ms

我还注意到，`<AboutThisListingContainer>` 的重绘导致了组件 `<Amenities>` 高消耗且多余的重绘。

![](https://cdn-images-1.medium.com/max/800/0*jL45wVOeK7404zcb.)

AboutThisListingContainer 的重绘消耗了 32.24ms

最终确认是我们使用的高阶组件 `withExperiments` 来帮助我们进行实验所造成的。HOC 每次都会创建一个新的对象作为参数传递给子组件，整个流程都没有做任何优化。

```
render() {
  ...
  const finalExperiments = {
    ...experiments,
    ...this.state.experiments,
  };
  return (
    <WrappedComponent
      {...otherProps}
      experiments={finalExperiments}
    />
  );
}
```

我通过引入 [reselect](https://github.com/reactjs/reselect) 来修复这个问题，他可以缓存上一次的结果以便在连续的渲染中保持相同的引用。

```
const getExperiments = createSelector(
  ({ experimentsFromProps }) => experimentsFromProps,
  ({ experimentsFromState }) => experimentsFromState,
  (experimentsFromProps, experimentsFromState) => ({
    ...experimentsFromProps,
    ...experimentsFromState,
  }),
);
...
render() {
  ...
  const finalExperiments = getExperiments({
    experimentsFromProps: experiments,
    experimentsFromState: this.state.experiments,
  });
  return (
    <WrappedComponent
      {...otherProps}
      experiments={finalExperiments}
    />
  );
}
```

问题的第二个部分也是相似的。我们使用了 `getFilteredAmenities` 方法将一个数组作为第一个参数，并返回该数组的过滤版本，类似于：

```
function getFilteredAmenities(amenities) {
  return amenities.filter(shouldDisplayAmenity);
}
```

虽然看上去没什么问题，但是每次运行即使结果相同也会创建一个新的数组实例，这使得即使是很单纯的组件也会重复的接收这个数组。我同样是通过引入 `reselect` 缓存这个过滤器来解决这个问题。👻

可能还有更多的优化空间，（比如 [CSS containment](https://developer.mozilla.org/en-US/docs/Web/CSS/contain)），不过现在看起来已经很好了。

![](https://cdn-images-1.medium.com/max/800/1*7vX8RmLIIDkqHPWPzGPOhA.png)

修复后的 Airbnb 清单页的优化滚动表现

### 点击操作

更多地体验过这个页面后，我明显得感觉到在点击「Helpful」按钮时存在延时问题。

![](https://cdn-images-1.medium.com/max/800/0*tMXuKO1LSSx-FGM8.)

我的直觉告诉我，点击这个按钮导致页面上的所有评论都被重新渲染了。看一看火焰图表，和我预计的一样：

![](https://cdn-images-1.medium.com/max/1000/0*qfYVyzrWQRqeDFXQ.)

ReviewsContent 重绘消耗了 42.38ms

在这两个地方引入 `React.PureComponent` 之后，我们让页面的更新更高效。

![](https://cdn-images-1.medium.com/max/800/0*IPNN14uZ5LqOS8B3.)

ReviewsContent 重绘消耗了 12.38ms

### 键盘操作

再回到之前的客户端/服务端不匹配的老问题上，我注意到，在这个输入框里打字确实有反应迟钝的感觉。

![](https://cdn-images-1.medium.com/max/800/0*iWJlliBeKUNDmSu3.)

分析后发现，每次按键操作都会造成整个评论区头部的重绘。这是在逗我吗？😱

![](https://cdn-images-1.medium.com/max/800/0*GCSQEZAZyaSBjgXA.)

Redux-connected ReviewsContainer 重绘消耗 61.32ms

为了解决这个问题，我把头部的一部分提取出来做为组件，以便我可以把它做成一个 `React.PureComponent`，然后再把这个几个 `React.PureComponent` 分散在构建树上。这使得每次按键操作就只能重绘需要重绘的组件了，也就是 `input`。

![](https://cdn-images-1.medium.com/max/800/0*NWzbAAPcfys13iFh.)

ReviewsHeader 重绘消耗 3.18ms

### 我们学到了什么？

* 我们希望页面可以启动得**更快**延迟**更短**
* 这意味着我们需要关注不仅仅是页面交互时间，还需要对页面上的交互进行剖析，比如滚动、点击和键盘事件。
* `React.PureComponent` 和 `reselect` 在我们 React 应用的性能优化工具中是非常有用的两个工具。
* 当实例变量这种轻量级的工具可以完美地满足你的需求时，就不要使用像 React state 这种重量级的工具了。
* 虽然 React 很强大，但有时编写代码来优化你的应用反而更容易。
* 培养分析、优化、再分析的习惯。

* * *

**如果你喜欢做性能优化**，[那就加入我们吧](https://www.airbnb.com/careers/departments/engineering)，**我们正在寻找才华横溢、对一切都很好奇的你。我们知道，Airbnb 还有大优化的空间，如果你发现了一些我们可能感兴趣的事，亦或者只是想和我聊聊天，你可以在 Twitter 上找到我** [_@lencioni_](https://twitter.com/lencioni)。

* * *

着重感谢 [Thai Nguyen](https://medium.com/@thaingnguyen) 在 review 代码和清单页迁移到单页应用的过程中作出的贡献。♨️ 得以实施主要得感谢 Chrome DevTools 团队，这些性能可视化的工具实在是太棒了！另外 Netflix 是第二项优化的功臣。

感谢 [Adam Neary](https://medium.com/@AdamRNeary?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
