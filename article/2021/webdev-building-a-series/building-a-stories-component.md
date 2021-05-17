> * 原文地址：[Building a Stories component](https://web.dev/building-a-stories-component/)
> * 原文作者：[Adam Argyle](https://web.dev/authors/adamargyle)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-stories-component/building-a-stories-component.md](https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-stories-component/building-a-stories-component.md)
> * 译者：
> * 校对者：

# Building a Stories component

> A foundational overview of how to build an experience similar to Instagram Stories on the web.

![Hero Image](https://web-dev.imgix.net/image/admin/OghwTxMrgwyEpzqQeuCa.jpg?w=1600)

In this post I want to share thinking on building a Stories component for the web that is responsive, supports keyboard navigation, and works across browsers. [Demo](https://gui-challenges-stories.glitch.me/)

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-stories-component/stories-desktop-demo.gif?raw=true)

If you would prefer a hands-on demonstration of building this Stories component yourself, check out the [Stories component codelab](/codelab-building-a-stories-component).

If you prefer video, here's a YouTube version of this post: [Thinking on ways to solve STORIES | GUI Challenges](https://youtu.be/PzvdREGR0Xw).

## Overview

Two popular examples of the Stories UX are Snapchat Stories and Instagram Stories (not to mention fleets). In general UX terms, Stories are usually a mobile-only, tap-centric pattern for navigating multiple subscriptions. For example, on Instagram, users open a friend's story and go through the pictures in it. They generally do this many friends at a time. By tapping on the right side of the device, a user skips ahead to that friend's next story. By swiping right, a user skips ahead to a different friend. A Story component is fairly similar to a carousel, but allows navigating a multi-dimensional array as opposed to a single-dimensional array. It's as if there's a carousel inside each carousel. 🤯

![Visualized multi-dimensional array using cards. Left to right is a stack of purple borders cards, and inside each card is 1-many cyan bordered cards. List in a list.](https://web-dev.imgix.net/image/tcFciHGuF3MxnTr1y5ue01OGLBn2/0yVm8NC0TiAsl6hcDxys.png?auto=format)

1st carousel of friends  
2nd "stacked" carousel of stories  
👍 List in a list, aka: a multi-dimensional array

## Picking the right tools for the job

All in all I found this component pretty straightforward to build, thanks to a few critical web platform features. Let's cover them!

### CSS Grid

Our layout turned out to be no tall order for CSS Grid as it's equipped with some powerful ways to wrangle content.

#### Friends layout

Our primary `.stories` component wrapper is a mobile-first horizontal scrollview:

```css
.stories {
    inline-size: 100vw;
    block-size: 100vh;

    display: grid;
    grid: 1fr / auto-flow 100%;
    gap: 1ch;

    overflow-x: auto;
    scroll-snap-type: x mandatory;
    overscroll-behavior: contain;
    touch-action: pan-x;
}

/* desktop constraint */
@media (hover: hover) and (min-width: 480px) {
    max-inline-size: 480px;
    max-block-size: 848px;
}
```

![Using Chrome DevTools' [Device Mode](https://developers.google.com/web/tools/chrome-devtools/device-mode) to highlight the columns created by Grid](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-stories-component/stories-overflow-columns.gif?raw=true)

Let's breakdown that `grid` layout:

* We explicitly fill the viewport on mobile with `100vh` and `100vw` and constrain the size on desktop
* `/` separates our row and column templates
* `auto-flow` translates to [`grid-auto-flow: column`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-auto-flow)
* The autoflow template is `100%`, which in this case is whatever the scroll window width is

Note that the location of the `/` separator relative to `auto-flow` is important. If `auto-flow` came before `/` it would be shorthand for `grid-auto-flow: row`.

On a mobile phone, think of this like the row size being the viewport height and each column being the viewport width. Continuing with the Snapchat Stories and Instagram Stories example, each column will be a friend's story. We want friends stories to continue outside of the viewport so we have somewhere to scroll to. Grid will make however many columns it needs to layout your HTML for each friend story, creating a dynamic and responsive scrolling container for us. Grid enabled us to centralize the whole effect.

#### Stacking

For each friend we need their stories in a pagination-ready state. In preparation for animation and other fun patterns, I chose a stack. When I say stack, I mean like you're looking down on a sandwich, not like you're looking from the side.

With CSS grid, we can define a single-cell grid (i.e. a square), where the rows and columns share an alias (`[story]`), and then each child gets assigned to that aliased single-cell space:

```css
.user {
    display: grid;
    grid: [story] 1fr / [story] 1fr;
    scroll-snap-align: start;
    scroll-snap-stop: always;
}
```

```css
.story {
    grid-area: story;
    background-size: cover;
    …
}
```

This puts our HTML in control of the stacking order and also keeps all elements in flow. Notice how we didn't need to do anything with `absolute` positioning or `z-index` and we didn't need to box correct with `height: 100%` or `width: 100%`. The parent grid already defined the size of the story picture viewport, so none of these story components needed to be told to fill it!

### CSS Scroll Snap Points

The [CSS Scroll Snap Points spec](https://www.w3.org/TR/css-scroll-snap-1/) makes it a cinch to lock elements into the viewport on scroll. Before these CSS properties existed, you had to use JavaScript, and it was… tricky, to say the least. Check out [Introducing CSS Scroll Snap Points](https://css-tricks.com/introducing-css-scroll-snap-points/) by Sarah Drasner for a great breakdown of how to use them.

Horizontal scrolling without and with `scroll-snap-points` styles. Without it, users can free scroll as normal. With it, the browser rests gently on each item.

---

##### Parent

```css
.stories {
  display: grid;
  grid: 1fr / auto-flow 100%;
  gap: 1ch;
  overflow-x: auto;
  scroll-snap-type: x mandatory;
  overscroll-behavior: contain;
  touch-action: pan-x;
}
```

Parent with overscroll defines snap behavior.

##### Child

```css
.user {
  display: grid;
  grid: [story] 1fr / [story] 1fr;
  scroll-snap-align: start;
  scroll-snap-stop: always;
}
```

Children opt into being a snap target.

---

I chose Scroll Snap Points for a few reasons:

* **Free accessibility**. The Scroll Snap Points spec states that pressing the Left Arrow and Right Arrow keys should move through the snap points by default.
* **A growing spec**. The Scroll Snap Points spec is getting new features and improvements all the time, which means that my Stories component will probably only get better from here on out.
* **Ease of implementation**. Scroll Snap Points are practically built for the touch-centric horizontal-pagination use case.
* **Free platform-style inertia**. Every platform will scroll and rest in its style, as opposed to normalized inertia which can have an uncanny scrolling and resting style.

## Cross-browser compatibility

We tested on Opera, Firefox, Safari, and Chrome, plus Android and iOS. Here's a brief rundown of the web features where we found differences in capabilities and support.

> **Success**: All of the features chosen were supported and none were buggy.

We did though have some CSS not apply, so some platforms are currently missing out on UX optimizations. I did enjoy not needing to manage these features and feel confident that they'll eventually reach other browsers and platforms.

### `scroll-snap-stop`

Carousels were one of the major UX use cases that prompted the creation of the CSS Scroll Snap Points spec. Unlike Stories, a carousel doesn't always need to stop on each image after a user interacts with it. It might be fine or encouraged to quickly cycle through the carousel. Stories, on the other hand, are best navigated one-by-one, and that's exactly what `scroll-snap-stop` provides.

```css
.user {
    scroll-snap-align: start;
    scroll-snap-stop: always;
}
```

At the time of writing this post, `scroll-snap-stop` is only supported on Chromium-based browsers. Check out [Browser compatibility](https://developer.mozilla.org/docs/Web/CSS/scroll-snap-stop#Browser_compatibility) for updates. It's not a blocker, though. It just means that on unsupported browsers users can accidentally skip a friend. So users will just have to be more careful, or we'll need to write JavaScript to ensure that a skipped friend isn't marked as viewed.

Read more in [the spec](https://www.w3.org/TR/css-scroll-snap-1/#scroll-snap-stop) if you're interested.

### `overscroll-behavior`

Have you ever been scrolling through a modal when all of a sudden you start scrolling the content behind the modal? [`overscroll-behavior`](https://developer.mozilla.org/docs/Web/CSS/overscroll-behavior) lets the developer trap that scroll and never let it leave. It's nice for all sorts of occasions. My Stories component uses it to prevent additional swipes and scrolling gestures from leaving the component.

```css
.stories {
    overflow-x: auto;
    overscroll-behavior: contain;
}
```

Safari and Opera were the 2 browsers that didn't [support](https://caniuse.com/#search=overscroll-behavior) this, and that's totally OK. Those users will get an overscroll experience like they're used to and may never notice this enhancement. I'm personally a big fan and like including it as part of nearly every overscroll feature I implement. It's a harmless addition that can only lead to improved UX.

### `scrollIntoView({behavior: 'smooth'})`

When a user taps or clicks and has reached the end of a friend's set of stories, it's time to move to the next friend in the scroll snap point set. With JavaScript, we were able to reference the next friend and request for it to be scrolled into view. The support for the basics of this are great; every browser scrolled it into view. But, not every browser did it `'smooth'`. This just means it's scrolled into view instead of snapped.

```js
element.scrollIntoView({behavior: 'smooth'})
```

Safari was the only browser not to support `behavior: 'smooth'` here. Check out [Browser compatibility](https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView#Browser_compatibility) for updates.

## Hands-on

Now that you know how I did it, how would you?! Let's diversify our approaches and learn all the ways to build on the web. Create a [Glitch](https://glitch.com), [tweet me](https://twitter.com/argyleink) your version, and I'll add it to the [Community remixes](#community-remixes) section below.

## Community remixes

* [@geoffrich\_](https://twitter.com/geoffrich_) with [Svelte](https://svelte.dev): [demo](https://svelte-stories.glitch.me) & [code](https://github.com/geoffrich/svelte-stories)
* [@GauteMeekOlsen](https://twitter.com/GauteMeekOlsen) with [Vue](https://vuejs.org/): [demo + code](https://stackblitz.com/edit/stories)
* [@AnaestheticsApp](https://twitter.com/AnaestheticsApp) with [Lit](https://lit-element.polymer-project.org/): [demo](https://lit-stories.glitch.me/) & [code](https://github.com/anaestheticsapp/web-stories)

## Codelabs

* [Codelab: Building a Stories component](https://web.dev/codelab-building-a-stories-component/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
