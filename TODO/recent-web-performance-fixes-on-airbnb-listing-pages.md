> * 原文地址：[React Performance Fixes on Airbnb Listing Pages](https://medium.com/airbnb-engineering/recent-web-performance-fixes-on-airbnb-listing-pages-6cd8d93df6f4)
> * 原文作者：[Joe Lencioni](https://medium.com/@lencioni?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/recent-web-performance-fixes-on-airbnb-listing-pages.md](https://github.com/xitu/gold-miner/blob/master/TODO/recent-web-performance-fixes-on-airbnb-listing-pages.md)
> * 译者：
> * 校对者：

# React Performance Fixes on Airbnb Listing Pages

# 针对 Airbnb 清单页的 React 性能优化

**_TL;DR:_** _There may be a lot of low-hanging fruit 🥝 affecting performance in areas you might not track very closely but are still very important._

**简要：可能在某些领域存在一些触手可及的性能优化点，虽不常见但依然很重要。**

* * *

We have been hard at work migrating the airbnb.com core booking flow into a single-page server-rendered app using [React Router](https://github.com/ReactTraining/react-router) and [Hypernova](https://github.com/airbnb/hypernova). At the beginning of the year, we rolled this out for the landing page and search results with good success. Our next step is to expand the single-page app to include the [listing detail page](https://www.airbnb.com/rooms/8357).

我们一直在努力迁移 airbnb.com 的核心预订流成到一个使用 [React Router](https://github.com/ReactTraining/react-router) 和 [Hypernova](https://github.com/airbnb/hypernova) 技术的服务端渲染的单页应用。年初，我们推出了登陆页面，搜索引擎表现很好。我们的下一步是将[清单详情页](https://www.airbnb.com/rooms/8357)扩展到单页应用程序里去。

![](https://cdn-images-1.medium.com/max/600/1*E__f8FixGkfXtq7tia8leg.png)

airbnb.com listing detail page: [https://www.airbnb.com/rooms/8357](https://www.airbnb.com/rooms/8357)

airbnb.com 的清单详情页: [https://www.airbnb.com/rooms/8357](https://www.airbnb.com/rooms/8357)

This is the page you visit when deciding which listing to book. Throughout your search, you might visit this page many times to view different listings. This is one of the most visited and most important pages on airbnb.com, so it is critical that we nail all of the details!

这是您在抉择清单时所访问的页面。在整个搜索过程中，您可能会多次访问该页面以查看不同的清单。这是 airbnb 网站访问量最大也最重要的页面之一，因此，我们必须做好每一个细节。

As part of this migration into our single-page app, I wanted to investigate any lingering performance issues affecting interactions on the listing page (e.g. scrolling, clicking, typing). This fits with our goal to make pages _start fast and stay fast_, and generally just makes people feel better about using the site.

作为迁移到我们的单页应用的一部分，我希望能研究出所有影响清单页交互性能的遗留问题(例如，滚动、点击、输入)。这符合我们的目标，让页面**启动更快延迟更短**，而且通常会让人们对使用我们网站的感觉更好。


**Through a process of profiling, making a fix, and profiling again, we dramatically improved the interaction performance of this critical page, which makes the booking experience smoother and more satisfying.** In this post, you’ll learn about the techniques I used to profile this page, the tools I used to optimize it, and see the scale of this impact in the flame charts produced by my profiling.

**通过解析、修复、再解析的流程，我们极大地提高了这个关键页的交互性能，使得预订体验更加顺畅，更令人满意**。在这篇文章中，您将了解到我用来解析这个页面的技术，用来优化它的工具，以及在解析结果给出的火焰图表中感受影响的程度。

### Methodology
### 方法

These profiles were recorded via Chrome’s Performance tool by:

1. Opening an incognito window _(so my browser extensions don’t interfere with my profiling)_
2. Visiting the page in local development I wanted to profile with `?react_perf` in the query string _(to enable React’s User Timing annotations, and to disable some dev-only things we have that happen to slow down the page, like_ [_axe-core_](https://www.axe-core.org/)_)_
3. Clicking the record button ⚫️
4. Interacting with the page _(e.g. scrolling, clicking, typing)_
5. Clicking the record button 🔴 again and interpreting the results

这些配置项通过Chrome的性能工具被记录下来:

1. 打开隐身窗口（这样我的浏览器扩展工具不会干扰我的解析）。
2. 使用 `?react_perf` 在查询字符串中进行配置访问本地开发页面（启用 React 的 User Timing 注释，并禁用一些仅限于 dev-only 的功能，例如 [axe-core](https://www.axe-core.org/)）
3. 点击 record 按钮 ⚫️
4. 操作页面（如：滚动，点击，打字）
5. 再次点击 record 按钮 🔴，分析结果

![](https://cdn-images-1.medium.com/max/800/1*w_bDwdT9s_d25W7qE-DZ1g.gif)

_Normally, I advocate for profiling on mobile hardware like a Moto C Plus or with CPU throttling set to 6x slowdown, to understand what folks on slower devices experience. However, since these problems were bad enough it was plainly obvious what the opportunities were on my super fast laptop even without throttling._

**通常情况下，我推荐在移动硬件上进行解析以了解在较慢的设备上的用户体验，比如 Moto C Plus，或者 CPU 节流设置为 6x 减速。然而，由于这些问题已经够很严重了，以至于在我的高性能笔记本电脑上即使是在没有节流的情况下，结果表现也是明显得糟糕。**

### Initial render
### 初始化渲染

When I started working on this page, I noticed a warning in my console: 💀
在我开始优化这个页面时，我注意到控制台上有一个警告:💀

```
webpack-internal:///36:36 Warning: React attempted to reuse markup in a container but the checksum was invalid. This generally means that you are using server rendering and the markup generated on the server was not what the client was expecting. React injected new markup to compensate which works but you have lost many of the benefits of server rendering. Instead, figure out why the markup being generated is different on the client or server: (client) ut-placeholder-label screen-reader-only" (server) ut-placeholder-label" data-reactid="628"
```

This is the dreaded server/client mismatch, which happens when the server renders something differently than what the client renders on the initial mount. This forces your web browser to do work that it shouldn’t have to do when using server rendering, so React gives you this handy ✋ warning whenever it happens.

这是可怕的 server/client 不匹配问题，当服务器渲染不同于客户端初始化渲染时发生。这会迫使您的 Web 浏览器执行在使用服务器渲染时不应该做的工作，所以每当发生这种情况时 React 就会做出这样的提醒 ✋ 。

Unfortunately, the error message isn’t super clear about exactly where this happens or what the cause might be, but we do have some clues. 🔎 I noticed a bit of text that looked like a CSS class, so I hit the terminal with:

不过，错误信息并不是很清楚的表述到底发生了什么，或者原因可能是什么，但确实给了我们一些线索。🔎 我注意到一些看起来像CSS类的文本，所以我用下面的命令打开了终端：

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

This narrowed down my search pretty quickly to something called `o2/PlaceHolderLabel.jsx`, which is the component that is rendered at the top of the reviews section for searching. 🔍

很快地我将搜索范围缩小了 `o2/PlaceHolderLabel.jsx`，一个在顶部渲染的搜索组件。

![](https://cdn-images-1.medium.com/max/800/0*M_D7Zs1HFsSoY7Po.)

It turned out that we used some feature detection to make sure the placeholder was visible in older browsers, like Internet Explorer, by rendering the input differently if placeholders were not supported in the current browser. Feature detection is the right way to do this (as opposed to user agent sniffing), but since there is no browser to feature detect against when server rendering, the server would always render a little bit of extra content than what most browsers will render.

事实上，我们使用了一些特征检测，以确保在旧浏览器(如 IE)中可以看到 `placeholder`，如果在当前的浏览器中不支持 `placeholder`，则会以不同的方式呈现 `input`。特征检测是正确的方法(与用户代理嗅探相反)，但是由于在服务器渲染时没有浏览器检测功能，导致服务器总是会渲染一些额外的内容，而不是大多数浏览器将呈现的内容。 

Not only did this hurt performance, it also caused an extra label to be visibly rendered and then removed from the page every time. Janky! I fixed this by moving the rendering of this content into React state and set it in `componentDidMount`, which is not run until the client renders. 🥂

这不仅降低了性能，还导致了一些额外的标签被渲染出来，然后每次再从页面上删除。赞！我将此内容的渲染转化为 React 的 state，并将其设置到了 `componentDidMount`，直到客户端渲染时才呈现，解决了问题。

![](https://cdn-images-1.medium.com/max/1000/1*Dz_-rY84jnCQrWhrlNkECw.png)

I ran the profiler again and noticed that `<SummaryContainer>` updates shortly after mounting.

我重新运行了一遍 profiler 发现，`<SummaryContainer>` 在 mounting 后瞬间发生了更新。 

![](https://cdn-images-1.medium.com/max/1000/0*ZPHyNBzpm6oT1dqu.)

101.63 ms spent re-rendering Redux-connected SummaryContainer

Redux 连接的 SummaryContainer 重绘消耗了 101.64 ms

This ends up re-rendering a `<BreadcrumbList>`, two`<ListingTitles>`, and a `<SummaryIconRow>` when it updates. However, none of these have any differences, so we can make this operation significantly cheaper by using `React.PureComponent` on these three components. This was about as straightforward as changing this:

更新后会重新渲染一个 `<BreadcrumbList>`、两个`<ListingTitles>` 和一个 `<SummaryIconRow>` 组件，但是他们前后并没有任何区别，所以我们可以通过使用 `React.PureComponent` 使这三个组件到渲染得到显著的优化。

```
export default class SummaryIconRow extends React.Component {
  ...
}
```

into this:

改成这样：

```
export default class SummaryIconRow extends React.PureComponent {
  ...
}
```

Up next, we can see that `<BookIt>` also goes through a re-render on the initial pageload. According to the flame 🔥 chart, most of the time is spent rendering `<GuestPickerTrigger>` and `<GuestCountFilter>`.

接下来，我们可以看到 `<BookIt>` 在页面初始载入时也发生了重新渲染的操作。根据火焰图可以看出，大部分时间都消耗在渲染 `<GuestPickerTrigger>` 和 `<GuestCountFilter>` 组件上。

![](https://cdn-images-1.medium.com/max/800/0*0Houn_bWBi4x1rhe.)

103.15 ms spent re-rendering BookIt
BookIt 的重绘消耗了 103.15ms


The funny thing here is that these components aren’t even visible 👻 unless the guest input is focused.

有趣的是，除非用户操作，这些组件基本是不可见的 👻 。

![](https://cdn-images-1.medium.com/max/800/0*VicFFl6VVoKEvWp1.)

The fix for this is to not render these components when they are not needed. This speeds up the initial render as well as any re-renders that may end up happening. 🐎 If we go a little further and drop in some more PureComponents, we can make this area even faster.

解决这个问题的方法是在不需要的时候不渲染这些组件。这加快了初始化的渲染清除了一些不必要的重绘。🐎 如果我们进一步地进行优化，产出更多无多余重绘的组件，那么初始化渲染可以变得更快。

![](https://cdn-images-1.medium.com/max/800/0*A9Fk9rNQc-hlT4cq.)

8.52 ms spent re-rendering BookIt
BookIt 的重绘消耗了 8.52ms

### Scrolling around
### 来回滚动

While doing some work to modernize a smooth scrolling animation we sometimes use on the listing page, I noticed the page felt very janky when scrolling. 📜 People usually get an uncomfortable and unsatisfying feeling when animations aren’t hitting a smooth 60 fps (Frames Per Second), [and maybe even when they aren’t hitting 120 fps](https://dassur.ma/things/120fps/). **Scrolling is a special kind of animation that is directly connected to your finger movements, so it is even more sensitive to bad performance than other animations.**

通常我们会在清单页面上做一些平滑滚动的效果，让滚动效果感觉很赞。📜 当动画没有达到平滑的 60 fps(每秒帧)，[甚至是 120 fps](https://dassur.ma/things/120fps/)，人们通常会感到不舒服也不会满意。**滚动是一种特殊的动画，是你的手指动作的直接反馈，所以它比其他动画更加敏感**。

After a little profiling, I discovered that we were doing a lot of unnecessary re-rendering of React components inside our scroll event handlers! This is what really bad jank looks like:

稍微分析一下后，我发现我们在滚动事件处理机制中做了很多不必要的 React 组件的重绘！看起来真的很糟糕：

![](https://cdn-images-1.medium.com/max/800/0*CFcV7cUQMP2tuiLb.)

Really bad scrolling performance on Airbnb listing pages before any fixes
在没做修复之前，Airbnb 上的滚动性能真的很糟糕

I was able to resolve most of this problem by converting three components in these trees to use `React.PureComponent`: `<Amenity>`, `<BookItPriceHeader>`, and `<StickyNavigationController>`. This dramatically reduced the cost of these re-renders. While we aren't quite at 60 fps (Frames Per Second) yet, we are much closer:

我可以使用 `React.PureComponent` 转化 `<Amenity>`、`<BookItPriceHeader>` 和 `<StickyNavigationController>` 这三个组件来解决绝大部分问题。这大大降低了页面重绘的成本。虽然我们还没能达到 60 fps（每秒帧数），但已经很接近了。

![](https://cdn-images-1.medium.com/max/800/0*fV_INfZNo5ochcKA.)

Slightly improved scrolling performance of Airbnb listing pages after some fixes
经过一些修改后，Airbnb 清单页面的滚动性能略有改善

However, there is still more opportunity to improve. Zooming 🚗 into the flame chart a little, we can see that we still spend a lot of time re-rendering `<StickyNavigationController>`. And, if we look down component stack, we notice that there are four similar looking chunks of this:

另外还有一些可以优化的部分。展开火焰图表，我们可以看到，`<StickyNavigationController>` 也产生了耗时的重绘。如果我们细看他的组件堆栈信息，可以发现四个相似的模块。

![](https://cdn-images-1.medium.com/max/800/0*m34rAJcm9zDr2IWu.)

58.80 ms spent re-rendering StickyNavigationController
StickyNavigationController 的重绘消耗了 8.52ms

The `<StickyNavigationController>` is the part of the listing page that sticks to the top of the viewport. As you scroll between sections, it highlights the section that you are currently inside of. Each of the chunks in the flame 🚒 chart corresponds to one of the four links that we render in the sticky navigation. And, when we scroll between sections, we highlight a different link, so some of it needs to re-render. Here's what it looks like in the browser.

`<StickyNavigationController>` 是清单页面顶部的一个部分，当我们滚动两个屏时，它会联动高亮您当前所在的位置。火焰图表中的每一块都对应着常驻导航的四个链接之一。

![](https://cdn-images-1.medium.com/max/800/1*sFbuI4zjaunWiOhINQiV6Q.gif)

Now, I noticed that we have four links here, but only two change appearance when transitioning between sections. But still, in our flame chart, we see that all four links re-render every time. This was happening because our `<NavigationAnchors>` component was creating a new function in render and passing it down to `<NavigationAnchor>` as a prop every time, which de-optimizes pure components.

现在，我注意到我们这里有四个链接，在状态切换时改变外观的只有两个，但在我们的火焰图表中显示，四个连接每都做了重绘操作。

```
const anchors = React.Children.map(children, (child, index) => {      
  return React.cloneElement(child, {
    selected: activeAnchorIndex === index,
    onPress(event) { onAnchorPress(index, event); },
  });
});
```

We can fix this by ensuring that the `<NavigationAnchor>` always receives the same function every time it is rendered by `<NavigationAnchors>`:

我们可以通过确保 `<NavigationAnchor>` 每次被 `<NavigationAnchors>` 渲染时接受到的都是同一个 function。以下是 `<NavigationAnchors>` 中的部分代码：

```
const anchors = React.Children.map(children, (child, index) => {      
  return React.cloneElement(child, {
    selected: activeAnchorIndex === index,
    index,
    onPress: this.handlePress,
  });
});
```

And then in `<NavigationAnchor>`:

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

Profiling after this change, we see that only two links are re-rendered! That's half 🌗 the work! And, if we use more than four links here, the amount of work that needs to be done won’t increase much anymore.

在优化后的解析中我们可以看到，只有两个连接被重绘，事半功倍！并且，如果我们这里有更多的链接块，那么渲染的工作量将不再增加。

![](https://cdn-images-1.medium.com/max/800/0*UwwNS6-WeByC0sYm.)

32.85 ms spent re-rendering StickyNavigationController
StickyNavigationController 的重绘消耗了 8.52ms

[_Dounan Shi_](https://medium.com/@dounanshi) _at_ [_Flexport_](https://medium.com/@Flexport) _has been working on_ [_Reflective Bind_](https://github.com/flexport/reflective-bind)_, which uses a Babel plugin to perform this type of optimization for you. It’s still pretty early so it might not be ready for production just yet, but I’m pretty excited about the possibilities here._

[Flexport](https://medium.com/@Flexport) 的 [Dounan Shi](https://medium.com/@dounanshi) 一直在维护 [Reflective Bind](https://github.com/flexport/reflective-bind)，这是供你用来做这类优化的 Babel 插件。这个项目还处于起步阶段，还不足以正式发布，但我已经对他未来的可能性感到兴奋了。

Looking down at the Main panel in the Performance recording, I notice that we have a very suspicious-looking `_handleScroll` block that eats up 19ms on every scroll event. Since we only have 16ms if we want to hit 60 fps, this is way too much. 🌯

继续看 Performance 记录的 Main 面板，我注意到我们有一个非常可疑的模块 `handleScroll`，每次滚动事件都会消耗 19ms。

![](https://cdn-images-1.medium.com/max/800/0*xRqIpxSt6fH22tCt.)

18.45 ms spent in `_handleScroll`
`_handleScroll` 消耗了 18.45ms

The culprit seems to be somewhere inside of `onLeaveWithTracking`. Through some code searching, I track this down to the `<EngagementWrapper>`. And looking a little closer at these call stacks, I notice that most of the time spent is actually inside of React's `setState`, but the weird thing is that we aren't actually seeing any re-renders happening here. Hmm...

罪魁祸首好像是 `onLeaveWithTracking` 内的某个部位。通过代码排查，问题定位到了 `<EngagementWrapper>`。然后在看看他的调用栈，发现大部分的时间消耗在了 React `setState` 的内部，但奇怪的是，我们并没有发现期间有产生任何重绘。

Digging into `<EngagementWrapper>` a little more, I notice that we are using React state 🗺 to track some information on the instance.

深入挖掘 `<EngagementWrapper>`，我注意到，我们使用了 React 的 state 跟踪了实例上的一些信息。

```
this.state = { inViewport: false };
```

However, **we never use this state in the render path at all and never need these state changes to cause re-renders, so we end up paying an extra cost**. 💸 Converting all of these uses of React state to be simple instance variables really helps us speed up these scrolling animations.

然而，**在渲染的流程中我们从来没有使用过这个 state，也没有监听它的变化来做重绘，也就是说，我们做了无用功**。将所有 React 的此类 state 用法转换为简单的实例变量可以让这些滚动动画更流畅。

```
this.inViewport = false;
```

![](https://cdn-images-1.medium.com/max/800/0*FIGmkF_IXHbb36Rx.)

1.16ms spent in scroll event handler
滚动事件的 handler 消耗了 18.45ms

I also noticed that the `<AboutThisListingContainer>` was re-rendering, which caused an expensive 💰 and unnecessary re-render of the `<Amenities>` component.

我还注意到，`<AboutThisListingContainer>` 的重绘导致了组件 `<Amenities>` 高消耗且多余的重绘。

![](https://cdn-images-1.medium.com/max/800/0*jL45wVOeK7404zcb.)

32.24 ms spent in AboutThisListingContainer re-render
AboutThisListingContainer 的重绘消耗了 32.24ms

This ended up being partly caused by our `withExperiments` higher-order component which we use to help us run experiments. This HOC was written in a way that it always passes down a newly created object as a prop to the component it wraps—deoptimizing anything in its path.

最终确认是我们用来尝试的高阶组件 `withExperiments` 造成的。HOC 每次都会创建一个新的对象作为参数传递给组件，整个流程都没有做任何优化。

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

I fixed this by bringing in [reselect](https://github.com/reactjs/reselect) for this work, which memoizes the previous result so that it will remain referentially equal between successive renders.

我通过引入 [reselect](https://github.com/reactjs/reselect) 来修复这个问题，他可以缓存上一次的结果以便在连续的渲染中保持相同。

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

The second part of the problem was similar. In this code path we were using a function called `getFilteredAmenities` which took an array as its first argument and returned a filtered version of that array, similar to:

问题的第二个部分也是相似的。我们使用了 `getFilteredAmenities` 方法将一个数组作为第一个参数，并返回该数组的过滤版本，类似于：

```
function getFilteredAmenities(amenities) {
  return amenities.filter(shouldDisplayAmenity);
}
```

Although this looks innocent enough, this will create a new instance of the array every time it is run, even if it produces the same result, which will deoptimize any pure components receiving this array as a prop. I fixed this as well by bringing in reselect to memoize the filtering. I don’t have a flame chart for this one because the entire re-render completely disappeared! 👻

虽然看上去没什么问题，但是每次运行即使结果相同也会会创建一个新的数组实例，这使得即使是很单纯的组件也会重复的接收这个数组。我同样是通过引入 `reselect` 缓存这个过滤器来解决这个问题。

There’s probably still some more opportunity here (e.g. [CSS containment](https://developer.mozilla.org/en-US/docs/Web/CSS/contain)), but scrolling performance is already looking much better!

可能还有更多的优化空间，(比如 [CSS containment](https://developer.mozilla.org/en-US/docs/Web/CSS/contain))，不过现在看起来已经很好了。

![](https://cdn-images-1.medium.com/max/800/1*7vX8RmLIIDkqHPWPzGPOhA.png)

Improved scrolling performance on Airbnb listing pages after these fixes
修复后的 Airbnb 清单页的优化滚动表现

### Clicking on things
### 点击操作

Interacting with the page a little more, I felt some noticeable lag ✈️ when clicking on the “Helpful” button on a review.

更多得体验过这个页面后，我明显得感觉到在点击「Helpful」按钮时存在延时问题。

![](https://cdn-images-1.medium.com/max/800/0*tMXuKO1LSSx-FGM8.)

My hunch was that clicking this button was causing all of the reviews on the page to be re-rendered. Looking at the flame chart, I wasn’t too far off:

我的直觉告诉我，点击这个按钮导致页面上的所有评论都被重新渲染了。看一看火焰图表，和我预计的一样：

![](https://cdn-images-1.medium.com/max/1000/0*qfYVyzrWQRqeDFXQ.)

42.38 ms re-rendering ReviewsContent
ReviewsContent 重绘消耗了 42.38ms

After dropping in `React.PureComponent` in a couple of places, we make these updates much more efficient.

在这两个地方引入 `React.PureComponent` 之后，我们让页面的更新更高效。

![](https://cdn-images-1.medium.com/max/800/0*IPNN14uZ5LqOS8B3.)

12.38 ms re-rendering ReviewsContent
ReviewsContent 重绘消耗了 12.38ms

### Typing stuff
### 键盘操作

Going back to our old friend with the server/client mismatch, I noticed that typing in this box felt really unresponsive.

再回到之前的客户端和服务端不匹配的老问题上，我注意到，在这个输入框里打字好像却是有反应迟钝的感觉。

![](https://cdn-images-1.medium.com/max/800/0*iWJlliBeKUNDmSu3.)

In my profiling I discovered that every keypress was causing the entire review section header and every review to be re-rendered! 😱 That is not so Raven. 🐦

分析后发现，每次按键操作都会造成整个评论区头部的重绘。这是在逗我吗？😱

![](https://cdn-images-1.medium.com/max/800/0*GCSQEZAZyaSBjgXA.)

61.32 ms re-rendering Redux-connected ReviewsContainer

Redux-connected ReviewsContainer 重绘消耗 61.32ms

To fix this I extracted part of the header to be its own component so I could make it a `React.PureComponent`, and then sprinkled in a few `React.PureComponent`s throughout the tree. This made it so each keypress only re-rendered the component that needed to be re-rendered: the input.

为了解决这个问题，我把头部的一部分提成自己的组件以便我可以把它做成一个 `React.PureComponent`，然后再把这个几个 `React.PureComponent` 分散在构建树上。这使得每次按键操作就只能重绘需要重绘的组件了，也就是 `input`。

![](https://cdn-images-1.medium.com/max/800/0*NWzbAAPcfys13iFh.)

3.18 ms re-rendering ReviewsHeader
ReviewsHeader 重绘消耗 3.18ms

### What did we learn?
### 我们学到了什么？

* We want pages to start fast and stay _fast_.
* This means we need to look at more than just time to interactive, we need to also profile interactions on the page, like scrolling, clicking, and typing.
* `React.PureComponent` and reselect are very useful tools in our React app optimization toolkit.
* Avoid reaching for heavier tools, like React state, when lighter tools such as instance variables fit your use-case perfectly.
* React gives us a lot of power, but it can be easy to write code that deoptimizes your app.
* Cultivate the habit of profiling, making a change, and then profiling again.

* 我们希望页面可以启动得更快延迟更短
* 这意味着我们需要关注不仅仅是页面交互时间，还需要对页面上的交互进行剖析，比如滚动、点击和键盘事件。
* `React.PureComponent` 和 `reselect` 在我们性能优化的方法中是非常有用的两个工具。
* 当实例变量这种轻量级的工具可以完美地满足你的需求时，就不要使用像 React state 这种重量级的工具了。
* 虽然 React 很强大，但有时编写代码来优化你的应用反而更容易。
* 培养分析优化再分析的习惯。

* * *

_If you enjoyed reading this, we are always looking for talented, curious people to_ [_join the team_](https://www.airbnb.com/careers/departments/engineering)_. We are aware that there is still a lot of opportunity to improve the performance of Airbnb, but if you happen to notice something that could use our attention or just want to talk shop, hit me up on Twitter any time_ [_@lencioni_](https://twitter.com/lencioni)

**如果你喜欢做性能优化**，[那就加入我们吧](https://www.airbnb.com/careers/departments/engineering)，**我们正在寻找才华横溢、对一切都很好奇的你。我们知道，Airbnb 还有大优化的空间，如果你发现了一些我们可能感兴趣的事，亦或者只是想和我聊聊天，你可以在 Twitter 上找到我** [_@lencioni_](https://twitter.com/lencioni)。

* * *

Big shout out to [Thai Nguyen](https://medium.com/@thaingnguyen) for helping to review most of these changes, and for working on bringing the listing page into the core booking flow single-page app. ♨️ Get hyped! Major thanks goes to the team working on Chrome DevTools — these performance visualizations are top-notch! Also, huge props to Netflix for _Stranger Things 2_. 🙃

Thanks to [Adam Neary](https://medium.com/@AdamRNeary?source=post_page).

着重感谢 [Thai Nguyen](https://medium.com/@thaingnguyen) 在 review 代码和清单页迁移到单页应用的过程中作出的贡献。♨️ 得以实施主要得感谢 Chrome DevTools 团队，这些性能可视化的工具实在是太棒了！另外 Netflix 是第二项优化的功臣。

感谢 [Adam Neary](https://medium.com/@AdamRNeary?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
