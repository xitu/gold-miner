> * 原文地址：[Applying Styles Based on the User Scroll Position with Smart CSS](https://pqina.nl/blog/applying-styles-based-on-the-user-scroll-position-with-smart-css/)
> * 原文作者：[Rik Schennink](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fpqina.nl%2Fblog%2Fapplying-styles-based-on-the-user-scroll-position-with-smart-css%2F&ref_src=twsrc%5Etfw&region=follow_link&screen_name=rikschennink&tw_p=followbutton)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/applying-styles-based-on-the-user-scroll-position-with-smart-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/applying-styles-based-on-the-user-scroll-position-with-smart-css.md)
> * 译者：
> * 校对者：

# 使用智能 CSS 基于用户滚动位置应用样式

通过将当前滚动偏移量添加到到 `html` 元素的属性上，我们可以根据当前滚动位置设置页面上的元素样式。我们可以使用它来构建一个浮动在页面顶部的导航组件。

这是我们将使用的 HTML，`<header>` 组件是我们希望当我们向下滚动时，始终浮动在页面顶部的一个组件。

```
<header>I'm the page header</header>
<p>Lot's of content here...</p>
<p>More beautiful content...</p>
<p>Content...</p>
```

首先，我们将监听 `document` 上的 `'scroll'` 事件，并且每次用户滚动时我们都会取出当前的 `scrollY` 值。

```
document.addEventListener('scroll', () => {
  document.documentElement.dataset.scroll = window.scrollY;
});
```

我们将滚动位置存储在 `html` 元素的数据属性中。如果您使用开发工具查看 DOM，它将如下所示：`<html data-scroll="0">`

现在我们可以使用此属性来设置页面上的元素样式。

```
/* 保证 header标签始终高于 3em */
header {
  min-height: 3em;
  width: 100%;
  background-color: #fff;
}

/* 在页面顶部保留与 header 的 min-height 相同的高度 */
html:not([data-scroll='0']) body {
  padding-top: 3em;
}

/* 将 header 标签切换成 fixed 定位模式，并且将它固定在页面顶部 */
html:not([data-scroll='0']) header {
  position: fixed;
  top: 0;
  z-index: 1;

  /* box-shadow 属性能够增强浮动的效果 */
  box-shadow: 0 0 .5em rgba(0, 0, 0, .5);
}
```

基本上就是这样，当用户向下滚动时，header 标签将自动从页面中分离并浮动在内容之上。JavaScript 代码并不关心这一点，它的任务就是将滚动偏移量放在数据属性中。这很完美，因为 JavaScript 和 CSS 之间没有紧密耦合。

但仍有一些可以改进的地方，主要是在性能方面。

首先，我们必须修改 JavaScript 脚本，以适应页面加载时滚动位置不在顶部的情况。在这样的情况下，header 标签将呈现错误的样式。

页面加载时，我们必须快速获取当前的滚动偏移量，这样确保了我们始终与当前的页面的状态同步。

```
// 读出当前页面的滚动位置并将其存入 document 的 data 属性中
// 因此我们就可以在我们的样式表中使用它
const storeScroll = () => {
  document.documentElement.dataset.scroll = window.scrollY;
}

// 监听滚动事件
document.addEventListener('scroll', storeScroll);

// 第一次打开页面时就更新滚动位置
storeScroll();
```

接下来我们将看一些性能方面改进。如果我们想要获取 `scrollY` 滚动位置，浏览器将必须计算页面上每个元素的位置，以确保它返回正确的位置。如果我们不强制它每次滚动都取值才是最好的做法。

要做到这一点，我们需要一个 debounce（防抖动）方法，这个方法会将我们的取值请求加入一个队列中，在浏览器准备好绘制下一帧之前都不会重新取值，此时它已经计算出了页面上所有元素的位置，所以它不会不断重复相同的工作。

```
// 防抖动函数接受一个我们自定义的函数作为参数
const debounce = (fn) => {

  // 这包含了对 requestAnimationFrame 的引用，所以我们可以在我们希望的任何时候停止它
  let frame;
  
  // 防抖动函数将返回一个可以接受多个参数的新函数
  return (...params) => {
    
    // 如果 frame 的值存在，那就清除对应的回调
    if (frame) { 
      cancelAnimationFrame(frame);
    }

    // 使我们的回调在浏览器下一帧刷新时执行
    frame = requestAnimationFrame(() => {
      
      // 执行我们的自定义函数并传递我们的参数
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

通过标记事件为 `passive` 状态，我们可以告诉浏览器我们的滚动事件不会被触摸交互阻止（例如与谷歌地图等插件交互时）。这允许浏览器立即滚动页面，因为它现在知道该事件不会被阻止。

```
document.addEventListener('scroll', debounce(storeScroll), { passive: true });
```

解决了性能问题后，我们现在可以通过稳定的方式使用 JavaScript 将获取的数据提供给 CSS，并可以使用它来为页面上的元素添加样式。

[Live Demo on CodePen](https://codepen.io/rikschennink/pen/yZYbwQ)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
