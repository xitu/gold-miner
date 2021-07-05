> * 原文地址：[Building a Stories component](https://web.dev/building-a-sidenav-component/)
> * 原文作者：[Adam Argyle](https://web.dev/authors/adamargyle)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-sidenav-component.md](https://github.com/xitu/gold-miner/blob/master/article/2021/webdev-building-a-series/building-a-sidenav-component.md)
> * 译者：
> * 校对者：

# Building a sidenav component

> A foundational overview of how to build a responsive slide out sidenav

![Hero Image](https://web-dev.imgix.net/image/admin/Zo1KkESK9CfEIYpbWzap.jpg?w=1600)

In this post I want to share with you how I prototyped a Sidenav component for the web that is responsive, stateful, supports keyboard navigation, works with and without JavaScript, and works across browsers. Try the [demo](https://gui-challenges.web.app/sidenav/dist/).

If you prefer video, here's a YouTube version of this post:

[Thinking on ways to solve a SIDENAV | GUI Challenges](https://youtu.be/uiZqDLqjGRY).

## Overview

It's tough building a responsive navigation system. Some users will be on a keyboard, some will have powerful desktops, and some will visit from a small mobile device. Everyone visiting should be able to open and close the menu.

![Desktop to mobile responsive layout demo](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/desktop-demo-1080p.gif?raw=true)

![Light and dark theme down on iOS and Android](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/mobile-demo-1080p.gif?raw=true)

## Web Tactics

In this component exploration I had the joy of combining a few critical web platform features:

1. CSS `:target`
2. CSS grid
3. CSS transforms
4. CSS Media Queries for viewport and user preference
5. JS for `focus` UX enhancements

My solution has one sidebar and toggles only when at a "mobile" viewport of `540px` or less. `540px` will be our breakpoint for switching between the mobile interactive layout and the static desktop layout.

### CSS `:target` pseudo-class

One `<a>` link sets the url hash to `#sidenav-open` and the other to empty (`''`). Lastly, an element has the `id` to match the hash:

```html
<a href="#sidenav-open" id="sidenav-button" title="Open Menu" aria-label="Open Menu">

    <a href="#" id="sidenav-close" title="Close Menu" aria-label="Close Menu"></a>

    <aside id="sidenav-open">
        …
    </aside>
```

Clicking each of these links changes the hash state of our page URL, then with a pseudo-class I show and hide the sidenav:

```css
@media (max-width: 540px) {
    #sidenav-open {
        visibility: hidden;
    }

    #sidenav-open:target {
        visibility: visible;
    }
}
```

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/hash-change.gif?raw=true)

### CSS Grid

In the past, I only used absolute or fixed position sidenav layouts and components. Grid though, with its `grid-area` syntax, lets us assign multiple elements to the same row or column.

#### Stacks

The primary layout element `#sidenav-container` is a grid that creates 1 row and 2 columns, 1 of each are named `stack`. When space is constrained, CSS assigns all of the `<main>` element's children to the same grid name, placing all elements into the same space, creating a stack.

```css
#sidenav-container {
    display: grid;
    grid: [stack] 1fr / min-content [stack] 1fr;
    min-height: 100vh;
}

@media (max-width: 540px) {
    #sidenav-container > * {
        grid-area: stack;
    }
}
```

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/responsive-stack-demo-1080p.gif?raw=true)

#### Menu backdrop

The `<aside>` is the animating element that contains the side navigation. It has 2 children: the navigation container `<nav>` named `[nav]` and a backdrop `<a>` named `[escape]`, which is used to close the menu.

```css
#sidenav-open {
    display: grid;
    grid-template-columns: [nav] 2fr [escape] 1fr;
}
```

Adjust `2fr` & `1fr` to find the ratio you like for the menu overlay and its negative space close button.

![A demo of what happens when you change the ratio.](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/overlay-escape-ratio.gif?raw=true)

### CSS 3D transforms & transitions

Our layout is now stacked at a mobile viewport size. Until I add some new styles, it's overlaying our article by default. Here's some UX I'm shooting for in this next section:

* Animate open and close
* Only animate with motion if the user is OK with that
* Animate `visibility` so keyboard focus doesn't enter the offscreen element

As I begin to implement motion animations, I want to start with accessibility top of mind.

#### Accessible motion

Not everyone will want a slide out motion experience. In our solution this preference is applied by adjusting a `--duration` CSS variable inside a media query. This media query value represents a user's operating system preference for motion (if available).

```css
#sidenav-open {
    --duration: .6s;
}

@media (prefers-reduced-motion: reduce) {
    #sidenav-open {
        --duration: 1ms;
    }
}
```

![A demo of the interaction with and without duration applied.](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/prefers-reduced-motion.gif?raw=true)

Now when our sidenav is sliding open and closed, if a user prefers reduced motion, I instantly move the element into view, maintaining state without motion.

#### Transition, transform, translate

##### Sidenav out (default)

To set the default state of our sidenav on mobile to an offscreen state, I position the element with `transform: translateX(-110vw)`.

Note, I added another `10vw` to the typical offscreen code of `-100vw`, to ensure the `box-shadow` of the sidenav doesn't peek into the main viewport when it's hidden.

```css
@media (max-width: 540px) {
    #sidenav-open {
        visibility: hidden;
        transform: translateX(-110vw);
        will-change: transform;
        transition: transform var(--duration) var(--easeOutExpo), visibility 0s linear var(--duration);
    }
}
```

##### Sidenav in

When the `#sidenav` element matches as `:target`, set the `translateX()` position to homebase `0`, and watch as CSS slides the element from its out position of `-110vw`, to its "in" position of `0` over `var(--duration)` when the URL hash is changed.

```css
@media (max-width: 540px) {
    #sidenav-open:target {
        visibility: visible;
        transform: translateX(0);
        transition: transform var(--duration) var(--easeOutExpo);
    }
}
```

#### Transition visibility

The goal now is to hide the menu from screenreaders when it's out, so systems don't put focus into an offscreen menu. I accomplish this by setting a visibility transition when the `:target` changes.

* When going in, don't transition visibility; be visible right away so I can see the element slide in and accept focus.
* When going out, transition visibility but delay it, so it flips to `hidden` at the end of the transition out.

### Accessibility UX enhancements

#### Links

This solution relies on changing the URL in order for the state to be managed. Naturally, the `<a>` element should be used here, and it gets some nice accessibility features for free. Let's adorn our interactive elements with labels clearly articulating intent.

```html
<a href="#" id="sidenav-close" title="Close Menu" aria-label="Close Menu"></a><a href="#sidenav-open" id="sidenav-button" class="hamburger" title="Open Menu" aria-label="Open Menu">
    <svg>...</svg>
</a>
```

![A demo of the voiceover and keyboard interaction UX.](https://github.com/PassionPenguin/gold-miner-images/blob/master/webdev-building-a-series/building-a-sidenav-component/keyboard-voiceover.gif?raw=true)

Now our primary interaction buttons clearly state their intent for both mouse and keyboard.

#### `:is(:hover, :focus)`

This handy CSS functional pseudo-selector lets us swiftly be inclusive with our hover styles by sharing them with focus as well.building-a-sidenav-component

```css
.hamburger:is(:hover, :focus) svg > line {
    stroke: hsl(var(--brandHSL));
}
```

#### Sprinkle on JavaScript

##### Press `escape` to close

The `Escape` key on your keyboard should close the menu right? Let's wire that up.

```js
const sidenav = document.querySelector('#sidenav-open');
sidenav.addEventListener('keyup', event => {
    if (event.code === 'Escape') document.location.hash = '';
});
```

##### Focus UX

The next snippet helps us put focus on the open and close buttons after they open or close. I want to make toggling easy.

```js
sidenav.addEventListener('transitionend', e => {
    const isOpen = document.location.hash === '#sidenav-open';
    isOpen ? document.querySelector('#sidenav-close').focus() : document.querySelector('#sidenav-button').focus();
})
```

When the sidenav opens, focus the close button. When the sidenav closes, focus the open button. I do this by calling `focus()` on the element in JavaScript.

### Conclusion

Now that you know how I did it, how would you?! This makes for some fun component architecture! Who's going to make the 1st version with slots? 🙂

Let's diversify our approaches and learn all the ways to build on the web. Create a [Glitch](https://glitch.com), [tweet me](https://twitter.com/argyleink) your version, and I'll add it to the [Community remixes](#community-remixes) section below.

## Community remixes

* [@\_developit](https://twitter.com/_developit) with custom elements: [demo & code](https://glitch.com/edit/#!/app-drawer)
* [@mayeedwin1](https://twitter.com/mayeedwin1) with HTML/CSS/JS: [demo & code](https://glitch.com/edit/#!/maye-gui-challenge)
* [@a\_nurella](https://twitter.com/a_nurella) with a Glitch Remix: [demo & code](https://glitch.com/edit/#!/sidenav-with-adam)
* [@EvroMalarkey](https://twitter.com/EvroMalarkey) with HTML/CSS/JS: [demo & code](https://evromalarkey.github.io/scrollsnap-drawer/index.html)

## Codelabs

* [Codelab: Building a Sidenav component](/codelab-building-a-sidenav-component/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
