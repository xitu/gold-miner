> * 原文地址：[React Performance Fixes on Airbnb Listing Pages](https://medium.com/airbnb-engineering/recent-web-performance-fixes-on-airbnb-listing-pages-6cd8d93df6f4)
> * 原文作者：[Joe Lencioni](https://medium.com/@lencioni?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/recent-web-performance-fixes-on-airbnb-listing-pages.md](https://github.com/xitu/gold-miner/blob/master/TODO/recent-web-performance-fixes-on-airbnb-listing-pages.md)
> * 译者：
> * 校对者：

# React Performance Fixes on Airbnb Listing Pages

**_TL;DR:_** _There may be a lot of low-hanging fruit 🥝 affecting performance in areas you might not track very closely but are still very important._

* * *

We have been hard at work migrating the airbnb.com core booking flow into a single-page server-rendered app using [React Router](https://github.com/ReactTraining/react-router) and [Hypernova](https://github.com/airbnb/hypernova). At the beginning of the year, we rolled this out for the landing page and search results with good success. Our next step is to expand the single-page app to include the [listing detail page](https://www.airbnb.com/rooms/8357).

![](https://cdn-images-1.medium.com/max/600/1*E__f8FixGkfXtq7tia8leg.png)

airbnb.com listing detail page: [https://www.airbnb.com/rooms/8357](https://www.airbnb.com/rooms/8357)

This is the page you visit when deciding which listing to book. Throughout your search, you might visit this page many times to view different listings. This is one of the most visited and most important pages on airbnb.com, so it is critical that we nail all of the details!

As part of this migration into our single-page app, I wanted to investigate any lingering performance issues affecting interactions on the listing page (e.g. scrolling, clicking, typing). This fits with our goal to make pages _start fast and stay fast_, and generally just makes people feel better about using the site.

**Through a process of profiling, making a fix, and profiling again, we dramatically improved the interaction performance of this critical page, which makes the booking experience smoother and more satisfying.** In this post, you’ll learn about the techniques I used to profile this page, the tools I used to optimize it, and see the scale of this impact in the flame charts produced by my profiling.

### Methodology

These profiles were recorded via Chrome’s Performance tool by:

1. Opening an incognito window _(so my browser extensions don’t interfere with my profiling)_
2. Visiting the page in local development I wanted to profile with `?react_perf` in the query string _(to enable React’s User Timing annotations, and to disable some dev-only things we have that happen to slow down the page, like_ [_axe-core_](https://www.axe-core.org/)_)_
3. Clicking the record button ⚫️
4. Interacting with the page _(e.g. scrolling, clicking, typing)_
5. Clicking the record button 🔴 again and interpreting the results

![](https://cdn-images-1.medium.com/max/800/1*w_bDwdT9s_d25W7qE-DZ1g.gif)

_Normally, I advocate for profiling on mobile hardware like a Moto C Plus or with CPU throttling set to 6x slowdown, to understand what folks on slower devices experience. However, since these problems were bad enough it was plainly obvious what the opportunities were on my super fast laptop even without throttling._

### Initial render

When I started working on this page, I noticed a warning in my console: 💀

```
webpack-internal:///36:36 Warning: React attempted to reuse markup in a container but the checksum was invalid. This generally means that you are using server rendering and the markup generated on the server was not what the client was expecting. React injected new markup to compensate which works but you have lost many of the benefits of server rendering. Instead, figure out why the markup being generated is different on the client or server: (client) ut-placeholder-label screen-reader-only" (server) ut-placeholder-label" data-reactid="628"
```

This is the dreaded server/client mismatch, which happens when the server renders something differently than what the client renders on the initial mount. This forces your web browser to do work that it shouldn’t have to do when using server rendering, so React gives you this handy ✋ warning whenever it happens.

Unfortunately, the error message isn’t super clear about exactly where this happens or what the cause might be, but we do have some clues. 🔎 I noticed a bit of text that looked like a CSS class, so I hit the terminal with:

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

![](https://cdn-images-1.medium.com/max/800/0*M_D7Zs1HFsSoY7Po.)

It turned out that we used some feature detection to make sure the placeholder was visible in older browsers, like Internet Explorer, by rendering the input differently if placeholders were not supported in the current browser. Feature detection is the right way to do this (as opposed to user agent sniffing), but since there is no browser to feature detect against when server rendering, the server would always render a little bit of extra content than what most browsers will render.

Not only did this hurt performance, it also caused an extra label to be visibly rendered and then removed from the page every time. Janky! I fixed this by moving the rendering of this content into React state and set it in `componentDidMount`, which is not run until the client renders. 🥂

![](https://cdn-images-1.medium.com/max/1000/1*Dz_-rY84jnCQrWhrlNkECw.png)

I ran the profiler again and noticed that `<SummaryContainer>` updates shortly after mounting.

![](https://cdn-images-1.medium.com/max/1000/0*ZPHyNBzpm6oT1dqu.)

101.63 ms spent re-rendering Redux-connected SummaryContainer

This ends up re-rendering a `<BreadcrumbList>`, two`<ListingTitles>`, and a `<SummaryIconRow>` when it updates. However, none of these have any differences, so we can make this operation significantly cheaper by using `React.PureComponent` on these three components. This was about as straightforward as changing this:

```
export default class SummaryIconRow extends React.Component {
  ...
}
```

into this:

```
export default class SummaryIconRow extends React.PureComponent {
  ...
}
```

Up next, we can see that `<BookIt>` also goes through a re-render on the initial pageload. According to the flame 🔥 chart, most of the time is spent rendering `<GuestPickerTrigger>` and `<GuestCountFilter>`.

![](https://cdn-images-1.medium.com/max/800/0*0Houn_bWBi4x1rhe.)

103.15 ms spent re-rendering BookIt

The funny thing here is that these components aren’t even visible 👻 unless the guest input is focused.

![](https://cdn-images-1.medium.com/max/800/0*VicFFl6VVoKEvWp1.)

The fix for this is to not render these components when they are not needed. This speeds up the initial render as well as any re-renders that may end up happening. 🐎 If we go a little further and drop in some more PureComponents, we can make this area even faster.

![](https://cdn-images-1.medium.com/max/800/0*A9Fk9rNQc-hlT4cq.)

8.52 ms spent re-rendering BookIt

### Scrolling around

While doing some work to modernize a smooth scrolling animation we sometimes use on the listing page, I noticed the page felt very janky when scrolling. 📜 People usually get an uncomfortable and unsatisfying feeling when animations aren’t hitting a smooth 60 fps (Frames Per Second), [and maybe even when they aren’t hitting 120 fps](https://dassur.ma/things/120fps/). **Scrolling is a special kind of animation that is directly connected to your finger movements, so it is even more sensitive to bad performance than other animations.**

After a little profiling, I discovered that we were doing a lot of unnecessary re-rendering of React components inside our scroll event handlers! This is what really bad jank looks like:

![](https://cdn-images-1.medium.com/max/800/0*CFcV7cUQMP2tuiLb.)

Really bad scrolling performance on Airbnb listing pages before any fixes

I was able to resolve most of this problem by converting three components in these trees to use `React.PureComponent`: `<Amenity>`, `<BookItPriceHeader>`, and `<StickyNavigationController>`. This dramatically reduced the cost of these re-renders. While we aren't quite at 60 fps (Frames Per Second) yet, we are much closer:

![](https://cdn-images-1.medium.com/max/800/0*fV_INfZNo5ochcKA.)

Slightly improved scrolling performance of Airbnb listing pages after some fixes

However, there is still more opportunity to improve. Zooming 🚗 into the flame chart a little, we can see that we still spend a lot of time re-rendering `<StickyNavigationController>`. And, if we look down component stack, we notice that there are four similar looking chunks of this:

![](https://cdn-images-1.medium.com/max/800/0*m34rAJcm9zDr2IWu.)

58.80 ms spent re-rendering StickyNavigationController

The `<StickyNavigationController>` is the part of the listing page that sticks to the top of the viewport. As you scroll between sections, it highlights the section that you are currently inside of. Each of the chunks in the flame 🚒 chart corresponds to one of the four links that we render in the sticky navigation. And, when we scroll between sections, we highlight a different link, so some of it needs to re-render. Here's what it looks like in the browser.

![](https://cdn-images-1.medium.com/max/800/1*sFbuI4zjaunWiOhINQiV6Q.gif)

Now, I noticed that we have four links here, but only two change appearance when transitioning between sections. But still, in our flame chart, we see that all four links re-render every time. This was happening because our `<NavigationAnchors>` component was creating a new function in render and passing it down to `<NavigationAnchor>` as a prop every time, which de-optimizes pure components.

```
const anchors = React.Children.map(children, (child, index) => {      
  return React.cloneElement(child, {
    selected: activeAnchorIndex === index,
    onPress(event) { onAnchorPress(index, event); },
  });
});
```

We can fix this by ensuring that the `<NavigationAnchor>` always receives the same function every time it is rendered by `<NavigationAnchors>`:

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

![](https://cdn-images-1.medium.com/max/800/0*UwwNS6-WeByC0sYm.)

32.85 ms spent re-rendering StickyNavigationController

[_Dounan Shi_](https://medium.com/@dounanshi) _at_ [_Flexport_](https://medium.com/@Flexport) _has been working on_ [_Reflective Bind_](https://github.com/flexport/reflective-bind)_, which uses a Babel plugin to perform this type of optimization for you. It’s still pretty early so it might not be ready for production just yet, but I’m pretty excited about the possibilities here._

Looking down at the Main panel in the Performance recording, I notice that we have a very suspicious-looking `_handleScroll` block that eats up 19ms on every scroll event. Since we only have 16ms if we want to hit 60 fps, this is way too much. 🌯

![](https://cdn-images-1.medium.com/max/800/0*xRqIpxSt6fH22tCt.)

18.45 ms spent in `_handleScroll`

The culprit seems to be somewhere inside of `onLeaveWithTracking`. Through some code searching, I track this down to the `<EngagementWrapper>`. And looking a little closer at these call stacks, I notice that most of the time spent is actually inside of React's `setState`, but the weird thing is that we aren't actually seeing any re-renders happening here. Hmm...

Digging into `<EngagementWrapper>` a little more, I notice that we are using React state 🗺 to track some information on the instance.

```
this.state = { inViewport: false };
```

However, **we never use this state in the render path at all and never need these state changes to cause re-renders, so we end up paying an extra cost**. 💸 Converting all of these uses of React state to be simple instance variables really helps us speed up these scrolling animations.

```
this.inViewport = false;
```

![](https://cdn-images-1.medium.com/max/800/0*FIGmkF_IXHbb36Rx.)

1.16ms spent in scroll event handler

I also noticed that the `<AboutThisListingContainer>` was re-rendering, which caused an expensive 💰 and unnecessary re-render of the `<Amenities>` component.

![](https://cdn-images-1.medium.com/max/800/0*jL45wVOeK7404zcb.)

32.24 ms spent in AboutThisListingContainer re-render

This ended up being partly caused by our `withExperiments` higher-order component which we use to help us run experiments. This HOC was written in a way that it always passes down a newly created object as a prop to the component it wraps—deoptimizing anything in its path.

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

```
function getFilteredAmenities(amenities) {
  return amenities.filter(shouldDisplayAmenity);
}
```

Although this looks innocent enough, this will create a new instance of the array every time it is run, even if it produces the same result, which will deoptimize any pure components receiving this array as a prop. I fixed this as well by bringing in reselect to memoize the filtering. I don’t have a flame chart for this one because the entire re-render completely disappeared! 👻

There’s probably still some more opportunity here (e.g. [CSS containment](https://developer.mozilla.org/en-US/docs/Web/CSS/contain)), but scrolling performance is already looking much better!

![](https://cdn-images-1.medium.com/max/800/1*7vX8RmLIIDkqHPWPzGPOhA.png)

Improved scrolling performance on Airbnb listing pages after these fixes

### Clicking on things

Interacting with the page a little more, I felt some noticeable lag ✈️ when clicking on the “Helpful” button on a review.

![](https://cdn-images-1.medium.com/max/800/0*tMXuKO1LSSx-FGM8.)

My hunch was that clicking this button was causing all of the reviews on the page to be re-rendered. Looking at the flame chart, I wasn’t too far off:

![](https://cdn-images-1.medium.com/max/1000/0*qfYVyzrWQRqeDFXQ.)

42.38 ms re-rendering ReviewsContent

After dropping in `React.PureComponent` in a couple of places, we make these updates much more efficient.

![](https://cdn-images-1.medium.com/max/800/0*IPNN14uZ5LqOS8B3.)

12.38 ms re-rendering ReviewsContent

### Typing stuff

Going back to our old friend with the server/client mismatch, I noticed that typing in this box felt really unresponsive.

![](https://cdn-images-1.medium.com/max/800/0*iWJlliBeKUNDmSu3.)

In my profiling I discovered that every keypress was causing the entire review section header and every review to be re-rendered! 😱 That is not so Raven. 🐦

![](https://cdn-images-1.medium.com/max/800/0*GCSQEZAZyaSBjgXA.)

61.32 ms re-rendering Redux-connected ReviewsContainer

To fix this I extracted part of the header to be its own component so I could make it a `React.PureComponent`, and then sprinkled in a few `React.PureComponent`s throughout the tree. This made it so each keypress only re-rendered the component that needed to be re-rendered: the input.

![](https://cdn-images-1.medium.com/max/800/0*NWzbAAPcfys13iFh.)

3.18 ms re-rendering ReviewsHeader

### What did we learn?

* We want pages to start fast and stay _fast_.
* This means we need to look at more than just time to interactive, we need to also profile interactions on the page, like scrolling, clicking, and typing.
* `React.PureComponent` and reselect are very useful tools in our React app optimization toolkit.
* Avoid reaching for heavier tools, like React state, when lighter tools such as instance variables fit your use-case perfectly.
* React gives us a lot of power, but it can be easy to write code that deoptimizes your app.
* Cultivate the habit of profiling, making a change, and then profiling again.

* * *

_If you enjoyed reading this, we are always looking for talented, curious people to_ [_join the team_](https://www.airbnb.com/careers/departments/engineering)_. We are aware that there is still a lot of opportunity to improve the performance of Airbnb, but if you happen to notice something that could use our attention or just want to talk shop, hit me up on Twitter any time_ [_@lencioni_](https://twitter.com/lencioni)

* * *

Big shout out to [Thai Nguyen](https://medium.com/@thaingnguyen) for helping to review most of these changes, and for working on bringing the listing page into the core booking flow single-page app. ♨️ Get hyped! Major thanks goes to the team working on Chrome DevTools — these performance visualizations are top-notch! Also, huge props to Netflix for _Stranger Things 2_. 🙃

Thanks to [Adam Neary](https://medium.com/@AdamRNeary?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
