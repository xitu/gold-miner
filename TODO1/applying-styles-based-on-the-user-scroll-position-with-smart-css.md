> * 原文地址：[Applying Styles Based on the User Scroll Position with Smart CSS](https://pqina.nl/blog/applying-styles-based-on-the-user-scroll-position-with-smart-css/)
> * 原文作者：[Rik Schennink](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fpqina.nl%2Fblog%2Fapplying-styles-based-on-the-user-scroll-position-with-smart-css%2F&ref_src=twsrc%5Etfw&region=follow_link&screen_name=rikschennink&tw_p=followbutton)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/applying-styles-based-on-the-user-scroll-position-with-smart-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/applying-styles-based-on-the-user-scroll-position-with-smart-css.md)
> * 译者：
> * 校对者：

# Applying Styles Based on the User Scroll Position with Smart CSS

By mapping the current scroll offset to an attribute on the `html` element we can style elements on the page based on the current scroll position. We can use this to build, for example, a floating navigation component.

This is the HTML we’ll work with, a nice `<header>` component that we want to float on top of the content when we scroll down.

```
<header>I'm the page header</header>
<p>Lot's of content here...</p>
<p>More beautiful content...</p>
<p>Content...</p>
```

As a start, we’ll listen for the `'scroll'` event on the `document` and we’ll request the current `scrollY` position each time the user scrolls.

```
document.addEventListener('scroll', () => {
  document.documentElement.dataset.scroll = window.scrollY;
});
```

We have the scroll position stored in a data attribute on the `html` element. If you view the DOM using your dev tools it would look like this `<html data-scroll="0">`.

Now we can use this attribute to style elements on the page.

```
/* Make sure the header is always at least 3em high */
header {
  min-height: 3em;
  width: 100%;
  background-color: #fff;
}

/* Reserve the same height at the top of the page as the header min-height */
html:not([data-scroll='0']) body {
  padding-top: 3em;
}

/* Switch to fixed positioning, and stick the header to the top of the page */
html:not([data-scroll='0']) header {
  position: fixed;
  top: 0;
  z-index: 1;

  /* This box-shadow will help sell the floating effect */
  box-shadow: 0 0 .5em rgba(0, 0, 0, .5);
}
```

This is basically it, the header will now automatically detach from the page and float on top of the content when scrolling down. The JavaScript code doesn’t care about this, it’s task is simply putting the scroll offset in the data attribute. This is nice as there is no tight coupling between the JavaScript and the CSS.

There are still some improvements to make, mostly in the performance area.

But first, we have to fix our script for situations where the scroll position is not at the top when the page loads. In those situations, the header will render incorrectly.

When the page loads we’ll have to quickly get the current scroll offset. This ensures we’re always in sync with the current state of affairs.

```
// Reads out the scroll position and stores it in the data attribute
// so we can use it in our stylesheets
const storeScroll = () => {
  document.documentElement.dataset.scroll = window.scrollY;
}

// Listen for new scroll events
document.addEventListener('scroll', storeScroll);

// Update scroll position for first time
storeScroll();
```

Next we’re going to look at some performance improvements. If we request the `scrollY` position the browser will have to calculate the positions of each and every element on the page to make sure it returns the correct position. It’s best if we not force it to do this each and every scroll interaction.

To do this, we’ll need a debounce method, this method will queue our request till the browser is ready to paint the next frame, at that point it has already calculate the positions of all the elements on the page so it won’t do it again.

```
// The debounce function receives our function as a parameter
const debounce = (fn) => {

  // This holds the requestAnimationFrame reference, so we can cancel it if we wish
  let frame;

  // The debounce function returns a new function that can receive a variable number of arguments
  return (...params) => {
    
    // If the frame variable has been defined, clear it now, and queue for next frame
    if (frame) { 
      cancelAnimationFrame(frame);
    }

    // Queue our function call for the next frame
    frame = requestAnimationFrame(() => {
      
      // Call our function and pass any params we received
      fn(...params);
    });

  } 
};

// Reads out the scroll position and stores it in the data attribute
// so we can use it in our stylesheets
const storeScroll = () => {
  document.documentElement.dataset.scroll = window.scrollY;
}

// Listen for new scroll events, here we debounce our `storeScroll` function
document.addEventListener('scroll', debounce(storeScroll));

// Update scroll position for first time
storeScroll();
```

By marking the event as `passive` we can tell the browser that our scroll event is not going to be canceled by a touch interaction (for instance when interacting with a plugin like Google Maps). This allows the browser to scroll the page immediately as it now knows that the event won’t be canceled.

```
document.addEventListener('scroll', debounce(storeScroll), { passive: true });
```

With the performance issues resolved we now have a stable way to feed data obtained with JavaScript to our CSS and can use this to start styling elements on the page.

[Live Demo on CodePen](https://codepen.io/rikschennink/pen/yZYbwQ)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
