> * 原文地址：[Building a Tabs component](https://web.dev/building-a-tabs-component/)
> * 原文作者：[Adam Argyle](https://web.dev/authors/adamargyle)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-tabs-component.md](https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-tabs-component.md)
> * 译者：
> * 校对者：

# Building a Tabs component

> A foundational overview of how to build a tabs component similar to those found in iOS and Android apps.

![Hero Image](https://web-dev.imgix.net/image/admin/sq79nDAthaQGcdQkqazJ.png?w=1600)

In this post I want to share thinking on building a Tabs component for the web that is responsive, supports multiple device inputs, and works across browsers. Try the [demo](https://gui-challenges.web.app/tabs/dist/).

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/IBDNCMVCysfM9fYC9bnP.gif?raw=true)

If you prefer video, here's a YouTube version of this post: [Thinking on ways to solve TABS | GUI Challenges](https://youtu.be/mMBcHcvxuuA).

## Overview

Tabs are a common component of design systems but can take many shapes and forms. First there were desktop tabs built on `<frame>` element, and now we have buttery mobile components that animate content based on physics properties. They're all trying to do the same thing: save space.

Today, the essentials of a tabs user experience is a button navigation area which toggles the visibility of content in a display frame. Many different content areas share the same space, but are conditionally presented based on the button selected in the navigation.

![the collage is quite chaotic due to the huge diversity of styles the web has applied to the component concept](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/eAaQ44VAmzVOO9Cy5Wc8.png?auto=format)

## Web Tactics

All in all I found this component pretty straightforward to build, thanks to a few critical web platform features:

* `scroll-snap-points` for elegant swipe and keyboard interactions with appropriate scroll stop positions
* [Deep links](https://en.wikipedia.org/wiki/Deep_linking) via URL hashes for browser handled in-page scroll anchoring and sharing support
* Screen reader support with `<a>` and `id="#hash"` element markup
* `prefers-reduced-motion` for enabling crossfade transitions and instant in-page scrolling
* The in-draft `@scroll-timeline` web feature for dynamically underlining and color changing the selected tab

### The HTML

Fundamentally, the UX here is: click a link, have the URL represent the nested page state, and then see the content area update as the browser scrolls to the matching element.

There are some structural content members in there: links and `:target`s. We need a list of links, which a `<nav>` is great for, and a list of `<article>` elements, which a `<section>` is great for. Each link hash will match a section, letting the browser scroll things via anchoring.

![A link button is clicked, sliding in focused content](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/Pr8BrPDjq8ga9NyoHLJk.gif?raw=true)

For example, clicking a link automatically focuses the `:target` article in Chrome 89, no JS required. The user can then scroll the article content with their input device as always. It's complimentary content, as indicated in the markup.

I used the following markup to organize the tabs:

```html
<snap-tabs>
    <header>
        <nav>
            <a></a>
            <a></a>
            <a></a>
            <a></a>
        </nav>
    </header>
    <section>
        <article></article>
        <article></article>
        <article></article>
        <article></article>
    </section>
</snap-tabs>
```

I can establish connections between the `<a>` and `<article>` elements with `href` and `id` properties like this:

```html
<snap-tabs>
    <header>
        <nav>
            <a href="#responsive"></a>
            <a href="#accessible"></a>
            <a href="#overscroll"></a>
            <a href="#more"></a>
        </nav>
    </header>
    <section>
        <article id="responsive"></article>
        <article id="accessible"></article>
        <article id="overscroll"></article>
        <article id="more"></article>
    </section>
</snap-tabs>
```

I next filled the articles with mixed amounts of lorem, and the links with a mixed length and image set of titles. With content to work with, we can begin layout.

### Scrolling layouts

There are 3 different types of scroll areas in this component:

* The navigation **(pink)** is horizontally scrollable
* The content area **(blue)** is horizontally scrollable
* Each article item **(green)** is vertically scrollable.

![3 colorful boxes with color matching directional arrows which outline the scroll areas and show the direction they'll scroll.](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/qVmUKMwbeoCBffP0aY55.png?auto=format)

There's 2 different types of elements involved with scrolling:

1. **A window**  
   A box with defined dimensions that has the `overflow` property style.
2. **An oversized surface**  
   In this layout, it's the list containers: nav links, section articles, and article contents.

#### `<snap-tabs>` layout

The top level layout I chose was flex (Flexbox). I set the direction to `column`, so the header and section are vertically ordered. This is our first scroll window, and it hides everything with overflow hidden. The header and section will employ overscroll soon, as individual zones.

---

#### HTML

```html
<snap-tabs>
    <header></header>
    <section></section>
</snap-tabs>
```

##### CSS

```postcss
snap-tabs {
    display: flex;
    flex-direction: column; /* establish primary containing box */
    overflow: hidden;
    position: relative;

    & > section { /* be pushy about consuming all space */
        block-size: 100%;
    }

    & > header { /* defend against <section> needing 100% */
        flex-shrink: 0; /* fixes cross browser quarks */
        min-block-size: fit-content;
    }
}
```

---

Pointing back to the colorful 3-scroll diagram:

* `<header>` is now prepared to be the **(pink)** scroll container.
* `<section>` is prepared to be the **(blue)** scroll container.

The frames I've highlighted below with [VisBug](https://a.nerdy.dev/gimme-visbug) help us see the **windows** the scroll containers have created.

![the header and section elements have hotpink overlays on them, outlining the space they take up in the component](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/Fyl0rTuETjORBigkIBx5.png?auto=format)

#### Tabs `<header>` layout

The next layout is nearly the same: I use flex to create vertical ordering.

---

##### HTML

```html
<snap-tabs>
    <header>
        <nav></nav>
        <span class="snap-indicator"></span></header>
    <section></section>
</snap-tabs>
```

##### CSS

```postcss
header {
    display: flex;
    flex-direction: column;
}
```

---

The `.snap-indicator` should travel horizontally with the group of links, and this header layout helps set that stage. No absolute positioned elements here!

![the nav and span.indicator elements have hotpink overlays on them, outlining the space they take up in the component](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/EGNIrpw4gEzIZEcsAt5R.png?auto=format)

Next, the scroll styles. It turns out that we can share the scroll styles between our 2 horizontal scroll areas (header and section), so I made a utility class, `.scroll-snap-x`.

```postcss
.scroll-snap-x {
    /* browser decide if x is ok to scroll and show bars on, y hidden */
    overflow: auto hidden;
    /* prevent scroll chaining on x scroll */
    overscroll-behavior-x: contain;
    /* scrolling should snap children on x */
    scroll-snap-type: x mandatory;

    @media (hover: none) {
        scrollbar-width: none;

        &::-webkit-scrollbar {
            width: 0;
            height: 0;
        }
    }
}
```

Each needs overflow on the x axis, scroll containment to trap overscroll, hidden scrollbars for touch devices and lastly scroll-snap for locking content presentation areas. Our keyboard tab order is accessible and any interactions guide focus naturally. Scroll snap containers also get a nice carousel style interaction from their keyboard.

#### Tabs header `<nav>` layout

The nav links need to be laid out in a line, with no line breaks, vertically centered, and each link item should snap to the scroll-snap container. Swift work for 2021 postcss!

---

##### HTML

```html
<nav>
    <a></a>
    <a></a>
    <a></a>
    <a></a>
</nav>
```

##### CSS

```postcss
nav {
    display: flex;

    & a {
        scroll-snap-align: start;
        display: inline-flex;
        align-items: center;
        white-space: nowrap;
    }
}
```

---

Each link styles and sizes itself, so the nav layout only needs to specify direction and flow. Unique widths on nav items makes the transition between tabs fun as the indicator adjusts its width to the new target. Depending on how many elements are in here, the browser will render a scrollbar or not.

![the a elements of the nav have hotpink overlays on them, outlining the space they take up in the component as well as where they overflow](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/P7Vm3EvhO1wrTK1boU6y.png?auto=format)

#### Tabs `<section>` layout

This section is a flex item and needs to be the dominant consumer of space. It also needs to create columns for the articles to be placed into. Again, swift work for postcss 2021! The `block-size: 100%` stretches this element to fill the parent as much as possible, then for its own layout, it creates a series of columns that are `100%` the width of the parent. Percentages work great here because we've written strong constraints on the parent.

---

##### HTML

```html
<section>
    <article></article>
    <article></article>
    <article></article>
    <article></article>
</section>
```

##### CSS

```postcss
section {
    block-size: 100%;
    
    display: grid;
    grid-auto-flow: column;
    grid-auto-columns: 100%;
}
```

---

It's as if we're saying "expand vertically as much as possible, in a pushy way" (remember the header we set to `flex-shrink: 0`: it is a defense against this expansion push), which sets the row height for a set of full height columns. The `auto-flow` style tells the grid to always lay children out in a horizontal line, no wrapping, exactly what we want; to overflow the parent window.

![the article elements have hotpink overlays on them, outlining the space they take up in the component and where they overflow](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/FYroCMocutCGg1X8kfdG.png?auto=format)

I find these difficult to wrap my head around sometimes! This section element is fitting into a box, but also created a set of boxes. I hope the visuals and explanations are helping.

#### Tabs `<article>` layout

The user should be able to scroll the article content, and the scrollbars should only show up if there is overflow. These article elements are in a neat position. They are simultaneously a scroll parent and a scroll child. The browser is really handling some tricky touch, mouse, and keyboard interactions for us here.

---

##### HTML

```html
<article>
    <h2></h2>
    <p></p>
    <p></p>
    <h2></h2>
    <p></p>
    <p></p>
    ...
</article>
```

##### CSS

```postcss
article {
    scroll-snap-align: start;
    
    overflow-y: auto;
    overscroll-behavior-y: contain;
}
```

---

I chose to have the articles snap within their parent scroller. I really like how the navigation link items and the article elements snap to the inline-start of their respective scroll containers. It looks and feels like a harmonious relationship.

![the article element and it's child elements have hotpink overlays on them, outlining the space they take up in the component and the direction they overflow](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/O8gJp7AxBty8yND4fFGr.png?auto=format)

The article is a grid child, and it's size is predetermined to be the viewport area we want to provide scroll UX. This means I don't need any height or width styles here, I just need to define how it overflows. I set overflow-y to auto, and then also trap the scroll interactions with the handy overscroll-behavior property.

#### 3 scroll areas recap

Below I've chosen in my system settings to "always show scrollbars". I think it's doubly important for the layout to work with this setting turned on, as it is for me to review the layout and the scroll orchestration.

![the 3 scrollbars are set to show, now consuming layout space, and our component still looks great](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/6I6TI9PI4rvrJ9lr8T99.png?auto=format)

I think seeing the scrollbar gutter in this component helps clearly show where the scroll areas are, the direction they support, and how they interact with each other. Consider how each of these scroll window frames also are flex or grid parents to a layout.

DevTools can help us visualize this:

![the scroll areas have grid and flexbox tool overlays, outlining the space they take up in the component and the direction they overflow](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/GFJwc3IggHY4G5fBMiu9.png?auto=format)

Chromium Devtools, showing the flexbox nav element layout full of anchor elements, the grid section layout full of article elements, and the article elements full of paragraphs and a heading element.

The scroll layouts are complete: snapping, deep linkable, and keyboard accessible. Strong foundation for UX enhancements, style and delight.

#### Feature highlight

Scroll snapped children maintain their locked position during resize. This means JavaScript won't need to bring anything into view on device rotate or browser resize. Try it out in Chromium DevTools [Device Mode](https://developers.google.com/web/tools/chrome-devtools/device-mode) by selecting any mode other than **Responsive**, and then resizing the device frame. Notice the element stays in view and locked with its content. This has been available since Chromium updated their implementation to match the spec. Here's a [blog post](/snap-after-layout/) about it.

### Animation

The goal of the animation work here is to clearly link interactions with UI feedback. This helps guide or assist the user through to their (hopefully) seamless discovery of all the content. I'll be adding motion with purpose and conditionally. Users can now specify [their motion preferences](/prefers-reduced-motion/) in their operating system, and I thoroughly enjoy responding to their preferences in my interfaces.

I'll be linking a tab underline with the article scroll position. Snapping isn't only pretty alignment, it's also anchoring the start and end of an animation. This keeps the `<nav>`, which acts like a [mini-map](https://en.wikipedia.org/wiki/Mini-map), connected to the content. We'll be checking the user's motion preference from both postcss and JS. There's a few great places to be considerate!

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/D4zfhetqvhqlcPdTRtLZ.gif?raw=true)

#### Scroll behavior

There's an opportunity to enhance the motion behavior of both `:target` and `element.scrollIntoView()`. By default, it's instant. The browser just sets the scroll position. Well, what if we want to transition to that scroll position, instead of blink there?

```postcss
@media (prefers-reduced-motion: no-preference) {
    .scroll-snap-x {
        scroll-behavior: smooth;
    }
}
```

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/Q4JDplhM9gEd4PoiXqs6.gif?raw=true)

Since we're introducing motion here, and motion that the user doesn't control (like scrolling), we only apply this style if the user has no preference in their operating system around reduced motion. This way, we only introduce scroll motion for folks who are OK with it.

#### Tabs indicator

The purpose of this animation is to help associate the indicator with the state of the content. I decided to color crossfade `border-bottom` styles for users who prefer reduced motion, and a scroll linked sliding + color fade animation for users who are OK with motion.

In Chromium Devtools, I can toggle the preference and demonstrate the 2 different transition styles. I had a ton of fun building this.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/NVoLHgjGjf7fZw5HFpF6.gif?raw=true)

```postcss
@media (prefers-reduced-motion: reduce) {
    snap-tabs > header a {
        border-block-end: var(--indicator-size) solid hsl(var(--accent) / 0%);
        transition: color .7s ease, border-color .5s ease;

        &:is(:target,:active,[active]) {
            color: var(--text-active-color);
            border-block-end-color: hsl(var(--accent));
        }
    }

    snap-tabs .snap-indicator {
        visibility: hidden;
    }
}
```

I hide the `.snap-indicator` when the user prefers reduced motion since I don't need it anymore. Then I replace it with `border-block-end` styles and a `transition`. Also notice in the tabs interaction that the active nav item not only has a brand underline highlight, but it's text color also is darker. The active element has higher text color contrast and a bright underlight accent.

Just a few extra lines of postcss will make someone feel seen (in the sense that we're thoughtfully respecting their motion preferences). I love it.

#### `@scroll-timeline`

In the above section I showed you how I handle the reduced motion crossfade styles, and in this section I'll show you how I linked the indicator and a scroll area together. This is some fun experimental stuff up next. I hope you're as excited as me.

```js
const { matches:motionOK } = window.matchMedia(
        '(prefers-reduced-motion: no-preference)'
);
```

I first check the user's motion preference from JavaScript. If the result of this is `false`, meaning the user prefers reduced motion, then we'll not run any of the scroll linking motion effects.

```js
if (motionOK) {
   // motion based animation code
}
```

At the time of writing this, the [browser support for `@scroll-timeline`](https://caniuse.com/postcss-scroll-timeline) is none. It's a [draft spec](https://drafts.postcsswg.org/scroll-animations-1/) with only experimental implementations. It has a polyfill though, which I use in this demo.

##### `ScrollTimeline`

While postcss and JavaScript can both create scroll timelines, I opted into JavaScript so I could use live element measurements in the animation.

```js
const sectionScrollTimeline = new ScrollTimeline({
   scrollSource: tabsection,  // snap-tabs > section
   orientation: 'inline',     // scroll in the direction letters flow
   fill: 'both',              // bi-directional linking
});
```

I want 1 thing to follow another's scroll position, and by creating a `ScrollTimeline` I define the driver of the scroll link, the `scrollSource`. Normally an animation on the web runs against a global time frame tick, but with a custom `sectionScrollTimeline` in memory, I can change all that.

```js
tabindicator.animate({
           transform: [...tabnavitems].map(({offsetLeft}) =>
                   `translateX(${offsetLeft}px)`),
           width: [...tabnavitems].map(({offsetWidth}) =>
                   `${offsetWidth}px`)
        }, {
           duration: 1000,
           fill: 'both',
           timeline: sectionScrollTimeline,
        }
);
```

Before I get into the keyframes of the animation, I think it's important to point out the follower of the scrolling, `tabindicator`, will be animated based on a custom timeline, our section's scroll. This completes the linkage, but is missing the final ingredient, stateful points to animate between, also known as keyframes.

#### Dynamic keyframes

There's a really powerful pure declarative postcss way to animate with `@scroll-timeline`, but the animation I chose to do was too dynamic. There's no way to transition between `auto` width, and there's no way to dynamically create a number of keyframes based on children length.

JavaScript knows how to get that information though, so we'll iterate over the children ourselves and grab the computed values at runtime:

```js
tabindicator.animate({
           transform: ...,
           width: ...,
        }, {
           duration: 1000,
           fill: 'both',
           timeline: sectionScrollTimeline,
        }
);
```

For each `tabnavitem`, destructure the `offsetLeft` position and return a string that uses it as a `translateX` value. This creates 4 transform keyframes for the animation. The same is done for width, each is asked what its dynamic width is and then it's used as a keyframe value.

Here's example output, based on my fonts and browser preferences:

TranslateX Keyframes:

```js
tabindicator.animate({
           transform: [...tabnavitems].map(({offsetLeft}) =>
                   `translateX(${offsetLeft}px)`),
           width: [...tabnavitems].map(({offsetWidth}) =>
                   `${offsetWidth}px`)
        }, {
           duration: 1000,
           fill: 'both',
           timeline: sectionScrollTimeline,
        }
);
```

Width Keyframes:

```js
[...tabnavitems].map(({offsetWidth}) =>
        `${offsetWidth}px`)

// results in 4 array items, which represent 4 keyframe states
// ["121px", "117px", "226px", "67px"]
```

To summarize the strategy, the tab indicator will now animate across 4 keyframes depending on the scroll snap position of the section scroller. The snap points create clear delineation between our keyframes and really add to the synchronized feel of the animation.

![active tab and inactive tab are shown with VisBug overlays which show passing contrast scores for both](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/jV5X2JMkgUQSIpcivvTJ.png?auto=format)

The user drives the animation with their interaction, seeing the width and position of the indicator change from one section to the next, tracking perfectly with scroll.

You may not have noticed, but I'm very proud of the transition of color as the highlighted navigation item becomes selected.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/qoxGO8SR2t6GPuCWhwvu.gif?raw=true)

The unselected lighter grey appears even more pushed back when the highlighted item has more contrast. It's common to transition color for text, like on hover and when selected, but it's next-level to transition that color on scroll, synchronized with the underline indicator.

Here's how I did it:

```js
tabnavitems.forEach(navitem => {
   navitem.animate({
              color: [...tabnavitems].map(item =>
                      item === navitem
                              ? `var(--text-active-color)`
                              : `var(--text-color)`)
           }, {
              duration: 1000,
              fill: 'both',
              timeline: sectionScrollTimeline,
           }
   );
});
```

Each tab nav link needs this new color animation, tracking the same scroll timeline as the underline indicator. I use the same timeline as before: since it's role is to emit a tick on scroll, we can use that tick in any type of animation we want. As I did before, I create 4 keyframes in the loop, and return colors.

```js
[...tabnavitems].map(item =>
        item === navitem
                ? `var(--text-active-color)`
                : `var(--text-color)`)

// results in 4 array items, which represent 4 keyframe states
// [
// "var(--text-active-color)",
//         "var(--text-color)",
//         "var(--text-color)",
//         "var(--text-color)",
// ]
```

The keyframe with the color `var(--text-active-color)` highlights the link, and it's otherwise a standard text color. The nested loop there makes it relatively straightforward, as the outer loop is each nav item, and the inner loop is each navitem's personal keyframes. I check if the outer loop element is the same as the inner loop one, and use that to know when it's selected.

I had a lot of fun writing this. So much.

### Even more JavaScript enhancements

It's worth a reminder that the core of what I'm showing you here works without JavaScript. With that said, let's see how we can enhance it when JS is available.

#### Deep links

Deep links are more of a mobile term, but I think the intent of the deep link is met here with tabs in that you can share a URL directly to a tab's contents. The browser will in-page navigate to the ID that is matched in the URL hash. I found this `onload` handler made the effect across platforms.

```js
window.onload = () => {
   if (location.hash) {
      tabsection.scrollLeft = document
              .querySelector(location.hash)
              .offsetLeft;
   }
}
```

#### Scroll end synchronization

Our users aren't always clicking or using a keyboard, sometimes they're just free scrolling, as they should be able to. When the section scroller stops scrolling, wherever it lands needs to be matched in the top navigation bar.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/syltOES9Gxc0ihOsgTIV.gif?raw=true)

Here's how I wait for scroll end:

```js
tabsection.addEventListener('scroll', () => {
    clearTimeout(tabsection.scrollEndTimer);
    tabsection.scrollEndTimer = setTimeout(determineActiveTabSection, 100);
});
```

Whenever the sections are being scrolled, clear the section timeout if there, and start a new one. When sections stop being scrolled, don't clear the timeout, and fire 100ms after resting. When it fires, call function that seeks to figure out where the user stopped.

```js
const determineActiveTabSection = () => {
    const i = tabsection.scrollLeft / tabsection.clientWidth;
    const matchingNavItem = tabnavitems[i];
    matchingNavItem && setActiveTab(matchingNavItem);
};
```

Assuming the scroll snapped, dividing the current scroll position from the width of the scroll area should result in an integer and not a decimal. I then try to grab a navitem from our cache via this calculated index, and if it finds something, I send the match to be set active.

```js
const setActiveTab = tabbtn => {
    tabnav.querySelector(':scope a[active]').removeAttribute('active');
    tabbtn.setAttribute('active', '');
    tabbtn.scrollIntoView();
};
```

Setting the active tab starts by clearing any currently active tab, then giving the incoming nav item the active state attribute. The call to `scrollIntoView()` has a fun interaction with postcss that is worth noting.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-tabs-component/nsiyMgZ2QGF2fx9gVRgu.gif?raw=true)

```postcss
.scroll-snap-x {
   overflow: auto hidden;
   overscroll-behavior-x: contain;
   scroll-snap-type: x mandatory;

   @media (prefers-reduced-motion: no-preference) {
      scroll-behavior: smooth;
   }
}
```

In the horizontal scroll snap utility postcss, we've [nested](https://drafts.postcsswg.org/postcss-nesting-1/) a media query which applies `smooth` scrolling if the user is motion tolerant. JavaScript can freely make calls to scroll elements into view, and postcss can manage the UX declaratively. Quite the delightful little match they make sometimes.

### Conclusion

Now that you know how I did it, how would you?! This makes for some fun component architecture! Who's going to make the 1st version with slots in their favorite framework? 🙂

Let's diversify our approaches and learn all the ways to build on the web. Create a [Glitch](https://glitch.com), [tweet me](https://twitter.com/argyleink) your version, and I'll add it to the [Community remixes](#community-remixes) section below.

## Community remixes

* [@devnook](https://twitter.com/devnook), [@rob\_dodson](https://twitter.com/rob_dodson), & [@DasSurma](https://twitter.com/DasSurma) with Web Components: [article](https://developers.google.com/web/fundamentals/web-components/examples/howto-tabs)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
