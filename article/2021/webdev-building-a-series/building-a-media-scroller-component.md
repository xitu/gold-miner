> * 原文地址：[Building a Stories component](https://web.dev/building-a-media-scroller-component/)
> * 原文作者：[Adam Argyle](https://web.dev/authors/adamargyle)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-media-scroller-component.md](https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-media-scroller-component.md)
> * 译者：
> * 校对者：

# Building a media scroller component

> A foundational overview of how to build a responsive horizontal scrollview for TVs, phones, desktops, etc.

![Hero Image](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/I83Y9EaBPBXbE6TywvLg.png?w=1600)

In this post I want to share thinking on ways to create horizontal scrolling experiences for the web that are minimal, responsive, accessible and work across browsers and platforms (like TVs!). Try the [demo](https://gui-challenges.web.app/media-scroller/dist/).

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-media-scroller-component/kFXDbQeTKLcAX0ivOwdt.gif?raw=true)

If you prefer video, here's a YouTube version of this post: [Thinking on ways to solve a MEDIA SCROLLER | GUI Challenges](https://youtu.be/jmLdZY_Lo1k).

## Overview

We'll be building a horizontal scroll layout meant for hosting thumbnails of media or products. The component begins as a humble <ul> list but is transformed with CSS into a satisfying and smooth scroll experience, showcasing images and snapping them to a grid. JavaScript is added to facilitate roving-index interactions, helping keyboard users skip traversing 100+ items. Plus an experimental media query, prefers-reduced-data, is used to turn the media scroller into a lightweight title scroller experience.

## Start with accessible markup

A media scroller is made of just a couple of core components, a list with items. A list, in its simplest form, can travel all over the world and be clearly consumed by all. A user landing at this page can browse a list and click a link to view an item. This is our accessible base.

Deliver a list with a `<ul>` element:

```html
<ul class="horizontal-media-scroller">
  <li></li>
  <li></li>
  <li></li>
  ...
<ul>
```

Make the list items interactive with an `<a>` element:

```html
<li>
  <a href="#">
    ...
  </a>
</li>
```

Use a `<figure>` element to semantically represent an image and its caption:

```html
<figure>
  <picture>
    <img alt="..." loading="lazy" src="https://picsum.photos/500/500?1">
  </picture>
  <figcaption>Legends</figcaption>
</figure>
```

Notice the `alt` and `loading` attributes on the `<img>`. Alt text for a media scroller is a **UX opportunity** to help bring the thumbnail extra context, or as fallback text if the image didn't load, or it provides a spoken UI for users relying on assistive technology like a screen reader. Learn more with [Five golden rules for compliant alt text](https://abilitynet.org.uk/news-blogs/five-golden-rules-compliant-alt-text).

The `loading` attribute accepts the keyword `lazy` as a way to signal this image source should be fetched only when the image is within the viewport. This can be really nice for large lists, as users will only download images for items they scrolled into view.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-media-scroller-component/3YF8UackZ1Lan5ykXBvG.gif?raw=true)

### Support the user's color scheme preference

Use `color-scheme` as a `<meta>` tag to signal to the browser that your page wants both the light and dark provided user-agent styles. It's a free dark mode or light mode, depending on how you look at it:

```html
<meta name="color-scheme" content="dark light">
```

The meta tag provides the earliest signal possible, so the browser can select a dark default canvas color if the user has a dark theme preference. This means that navigations between pages of the site won't flash a white canvas background between loads. Seamless dark theme between loads, much nicer on the eyes.

Learn much more from [Thomas Steiner](https://web.dev/authors/thomassteiner/) at [https://web.dev/color-scheme/](https://web.dev/color-scheme/).

### Add content

Given the above content structure of `ul > li > a > figure > picture > img`, the next task is to add images and titles to scroll through. I've packed the demo with static placeholder images and text, but feel free to power this from your favorite data source.

## Add style with CSS

Now it's time for CSS to take this generic list of content and turn it into an experience. Netflix, App stores and many more sites and apps use horizontal scrolling areas to pack the viewport with categories and options.

### Creating the scroller layout

It's important to avoid cutting off content in layouts or leaning on text truncation with ellipsis. Many television sets have media scrollers just like this one, but all too often resort to ellipsing content. This layout does not! It also lets the media content override the column size, making 1 layout flexible enough to handle many interesting combinations.

![2 scrolling rows shown. One has no ellipsis, which means it's taller and each title is fully legible. The other is shorter and many titles are cutoff with ellipsis.](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/VFIcWLB6bnyYAszFzoE8.png?w=1600)

The container allows overriding the column size by providing the default size as a custom property. This grid layout is opinionated about column size, it's managing spacing and direction only:

```css
.horizontal-media-scroller {
  --size: 150px;

  display: grid;
  grid-auto-flow: column;
  gap: calc(var(--gap) / 2); /* parent owned value for children to be relative to*/
  margin: 0;
}
```

The custom property is then used by the `<picture>` element to create our base aspect ratio: a box:

```scss
.horizontal-media-scroller {
  --size: 150px;

  display: grid;
  grid-auto-flow: column;
  gap: calc(var(--gap) / 2);
  margin: 0;

  & picture {
    inline-size: var(--size);
    block-size: var(--size);
  }
}
```

With only a few more minor styles, complete the barebones of the media scroller:

```scss
.horizontal-media-scroller {
  --size: 150px;

  display: grid;
  grid-auto-flow: column;
  gap: calc(var(--gap) / 2); 
  margin: 0;

  overflow-x: auto;
  overscroll-behavior-inline: contain;
  
  & > li {
    display: inline-block; /* removes the list-item bullet */
  }

  & picture {
    inline-size: var(--size);
    block-size: var(--size);
  }
}
```

Setting `overflow` sets the `<ul>` up to allow scrolling and keyboard navigation through its list, then each direct child `<li>` element has its `::marker` removed by getting a new display type of `inline-block`.

The images aren't responsive yet though, and burst right out of the boxes they're inside. Tame them with some sizes, fit, and border styles, and a background gradient for when they're lazy loading:

```css
img {
  /* smash into whatever box it's in */
  inline-size: 100%;
  block-size: 100%;

  /* don't squish but do cover the space */
  object-fit: cover;

  /* soften the edges */
  border-radius: 1ex;
  overflow: hidden;

  /* if empty, show a gradient placeholder */
  background-image: 
    linear-gradient(
      to bottom, 
      hsl(0, 0%, 40%), 
      hsl(0, 0%, 20%)
    );
}
```

### Scroll padding

Alignment to page content, plus an edge-to-edge scrolling surface area, are critical to a harmonious and minimal component.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-media-scroller-component/hClUoh402H88dexfTpqS.gif?raw=true)

To accomplish the edge-to-edge scroll layout which aligns with our typography and layout lines, use `padding` that matches the `scroll-padding`:

```css
.horizontal-media-scroller {
  --size: 150px;

  display: grid;
  grid-auto-flow: column;
  gap: calc(var(--gap) / 2);
  margin: 0;

  overflow-x: auto;
  overscroll-behavior-inline: contain;

  padding-inline: var(--gap);
  scroll-padding-inline: var(--gap);
  padding-block: calc(var(--gap) / 2); /* make space for scrollbar and focus outline */
}
```

> I've simplified the example CSS here to only the logical properties. The hosted demo linked in this post has fallbacks for browsers without support for these logical shorthands.

**Horizontal scroll padding bug fix** The above shows how easy it should be to pad a scroll container, but there's outstanding compatibility issues with it (fixed in Chromium 91+ though!). See [here](https://bugs.chromium.org/p/chromium/issues/detail?id=1069614) for a bit of the history, but the short version is that padding wasn't always accounted for in a scroll view.

![A box is highlighted on the inline-end side of the last list item, showing the padding and element have the same width as to create the desired alignment.](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/jpOZQeMvnHwqiH0jatl7.png?w=1600)

To trick browsers into putting the padding at the end of the scroller I'll target the last figure in each list and append a pseudo element that's the amount of padding desired.

```scss
.horizontal-media-scroller > li:last-of-type figure {
  position: relative;

  &::after {
    content: "";
    position: absolute;

    inline-size: var(--gap);
    block-size: 100%;

    inset-block-start: 0;
    inset-inline-end: calc(var(--gap) * -1);
  }
}
```

Using logical properties enables the media scroller to work in any writing mode and document direction.

### Scroll snapping

A scrolling container with overflow can become a snapping viewport with one line of CSS, then it's on children to specify how they'd like to align with that viewport.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-media-scroller-component/hClUoh402H88dexfTpqS.gif?raw=true)

```scss
.horizontal-media-scroller {
  --size: 150px;

  display: grid;
  grid-auto-flow: column;
  gap: calc(var(--gap) / 2);
  margin: 0;

  overflow-x: auto;
  overscroll-behavior-inline: contain;

  padding-inline: var(--gap);
  scroll-padding-inline: var(--gap);
  padding-block-end: calc(var(--gap) / 2); 

  scroll-snap-type: inline mandatory;

  & figure {
    scroll-snap-align: start;
  }
}
```

### Focus

The inspiration for this component comes from its massive popularity on TVs, in App Stores, and more. Many video game platforms use a media scroller very similar to this one, as their primary home screen layout. Focus is a huge UX moment here, not just a small addition. Imagine using this media scroller from your couch with a remote, give that interaction some small enhancements:

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-media-scroller-component/5i0or9qst3oRA5Dqe3rA.gif?raw=true)

```scss
.horizontal-media-scroller {
  display: inline-block;
  outline-offset: 12px;

  &:focus {
    outline-offset: 7px;
  }

  @media (prefers-reduced-motion: no-preference) {
    & {
      transition: outline-offset .25s ease;
    }
  }
}
```

This sets the focus outline style `5px` away from the box, giving it some nice space. If the user has no motion preferences around reducing motion, the offset is transitioned, giving subtle motion to the focus event.

> This focus state is an opportunity for unique and brand defining micro-interaction UX

### Roving index

Gamepad and keyboard users need special attention in these longs lists of scrolling content and options. The common pattern for solving this is called [roving index](https://web.dev/control-focus-with-tabindex/). It's when a container of items is keyboard focused but only 1 child is allowed to hold focus at a time. This single focusable item at a time experience is designed to allow bypassing the potentially long list of items, as opposed to pressing tab 50+ times to reach the end.

There's 300 items in that first scroller of the demo. We can do better than make them traverse all of them to reach the next section.

To create this experience, JavaScript needs to observe keyboard events and focus events. I created [a small open source library on npm](https://github.com/argyleink/roving-ux) to help make this user experience easy to achieve. Here's how to use it for the 3 scrollers:

```js
import {rovingIndex} from 'roving-ux';

rovingIndex({
  element: someElement
});
```

This demo queries the document for the scrollers and for each of them calls the `rovingIndex()` function. Pass the `rovingIndex()` the element to get the roving experience, like a list container, and a target query selector, in case the focus targets aren't direct descendants.

```js
document.querySelectorAll('.horizontal-media-scroller')
  .forEach(scroller => 
    rovingIndex({
      element: scroller,
      target: 'a',
}))
```

To learn more about this effect, see the open source library [roving-ux](https://github.com/argyleink/roving-ux).

### Aspect-ratio

As of writing this post, the [support for `aspect-ratio`](https://caniuse.com/mdn-css_properties_aspect-ratio) is behind a flag in Firefox but available in Chromium browsers or set top boxes. Since the media scroller grid layout only specifies direction and spacing, the sizing can change inside a media query which feature checks for aspect-ratio support. Progressive enhancement into some more dynamic media scrollers.

![A box with 4:4 aspect ratio is shown next to the other design ratios used of 16:9 and 4:3](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/ffm4hCXrnxKiLcBNNigP.png?w=1600)

```scss
@supports (aspect-ratio: 1) {
  .horizontal-media-scroller figure > picture
    inline-size: auto; /* for a block-size driven ratio */
    aspect-ratio: 1; /* boxes by default */

    @nest section:nth-child(2) & {
      aspect-ratio: 16/9;
    }

    @nest section:nth-child(3) & {
      /* double the size of the others */
      block-size: calc(var(--size) * 2);
      aspect-ratio: 4/3;

      /* adjust size to fit more items into the viewport */
      @media (width <= 480px) {
        block-size: calc(var(--size) * 1.5);
      }
    }
  }
}
```

If the browser supports `aspect-ratio` syntax, the media scroller pictures are upgraded to `aspect-ratio` sizing. Using the draft nesting syntax, each picture changes its aspect ratio depending if it's the first, second, or third rows. The [nest syntax](https://drafts.csswg.org/css-nesting-1/) also allows setting some small viewport adjustments, right there with the other sizing logic.

With that CSS, as the feature is available in more browser engines, an easy to manage but more visually appealing layout will render.

### Prefers reduced data

While this next technique is only available [behind a flag](chrome://flags/#enable-experimental-web-platform-features) in [Canary](https://www.google.com/chrome/canary/), I wanted to share how I could save a considerable amount of page load time and data use with a few lines of CSS. The `prefers-reduced-data` media query from [level 5](https://drafts.csswg.org/mediaqueries-5/) allows asking if the device is in any reduced data states, like a data saver mode. If it is, I can modify the document, and in this case, hide the images.

![](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/PRhulaSe06O9XbM9V2hb.png?w=1600)

```scss
figure {
  @media (prefers-reduced-data: reduce) {
    & {
      min-inline-size: var(--size);

      & > picture {
        display: none;
      }
    }
  }
}
```

The content is still navigable but without the cost of the heavy images being downloaded. Here's the site before adding the `prefers-reduced-data` CSS:

(7 requests, 100kb of resources in 131ms)

![](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/63Zcpf05AN5sarJxTHE9.png?w=1600)

Here's the site performance after adding the `prefers-reduced-data` CSS:

![](https://web-dev.imgix.net/image/vS06HQ1YTsbMKSFTIPl2iogUQP73/nhNncPluLqgEabbRkKaG.png?w=1600)

(71 requests, 1.2mb of resources in 1.07s)

64 fewer requests, that would be the ~60 images within the viewport (tests taken on a wide screen display) of this browser tab, a page load boost of ~80%, and 10% of the data over the wire. Pretty powerful CSS.

## Conclusion

Now that you know how I did it, how would you?! 🙂

Let's diversify our approaches and learn all the ways to build on the web. Create a Codepen or host your own demo, tweet me with it, and I'll add it to the Community remixes section below.

**Source**
- [GUI Challenges source on GitHub](https://github.com/argyleink/gui-challenges)
- [Media scroller Codepen starter](https://codepen.io/argyleink/pen/bGgyOGP)

## Community remixes

*Nothing to see here yet!*

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
