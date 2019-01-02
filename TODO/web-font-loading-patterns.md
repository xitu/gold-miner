>* 原文链接 : [Web Font Loading Patterns](https://www.bramstein.com/writing/web-font-loading-patterns.html)
* 原文作者 : [Bram Stein](https://www.bramstein.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [SHENXN](https://github.com/shenxn)
* 校对者: [hikerpig](https://github.com/hikerpig), [L9m](https://github.com/L9m)

# 网页端字体加载优化

网络字体加载看起来也许非常复杂，但如果你使用本文的字体加载模式的话，这也并不是一件复杂的事情。你可以将这些模式组合起来，创建一个兼容所有浏览器的字体加载方式。

这些模式的代码样例都使用了 [Font Face Observer](https://github.com/bramstein/fontfaceobserver)，一个精简的网络字体加载器。Font Face Observer 将会根据浏览器的兼容情况使用最高效的方式来加载字体，所以这是一个非常棒的网络字体加载方式，同时你不需要为跨浏览器的兼容性而操心。

1.  [基础字体加载模式](#basic-font-loading)
2.  [分组字体加载模式](#loading-groups-of-fonts)
3.  [限制字体加载时间](#loading-fonts-with-a-timeout)
4.  [队列加载模式](#prioritised-loading)
5.  [自定义字体显示行为](#custom-font-display)
6.  [为缓存优化](#optimise-for-caching)

不存在一种普适所有情况的单一模式。选择一种适合你自己网站的字体加载模式才是最好的。

## [](#basic-font-loading)基础字体加载模式

Font Face Observer 使用一种基于 Promise（译者注：Promise 对象是用于进行延迟或者异步运算的，一个 Promise 代表一个尚未执行，但是将会执行的操作） 的接口来提供对网络字体加载的完整控制。你字体放在哪里并不重要：你可以自行放置，也可以使用 [Google Fonts](http://www.google.com/fonts)、[Typekit](http://typekit.com/)、[Fonts.com](https://fonts.com/)、[Webtype](http://webtype.com/) 等服务。

为了保持模式示例的精简，这篇文章假设你将网络字体放在自己的服务器上。这意味着你的 CSS 文件中应该有一个或多个 `@font-face` 来定义你希望通过 Font Face Observer 加载的字体。为了简洁，`@font-face` 不会出现在所有的模式中，但是你应该假设它们存在。

    @font-face {
      font-family: Output Sans;
      src: url(output-sans.woff2) format("woff2"),
           url(output-sans.woff) format("woff");
    }

最基础的模式就是加载一个或多个独立的字体。你可以通过为每个字体创建一个单独的 `FontFaceObserver` 实例，并调用它们的 `load` 方法来实现。

    var output = new FontFaceObserver('Output Sans');
    var input = new FontFaceObserver('Input Mono');

    output.load().then(function () {
      console.log('Output Sans has loaded.');
    });

    input.load().then(function () {
      console.log('Input Mono has loaded.');
    });

通过这种方式，每个网络字体将会被独立加载，这在字体间没有依赖关系且应该渐进渲染（即在加载完成后就渲染）时非常有用。与 [原生字体加载接口](https://www.w3.org/TR/css-font-loading/) 不同，你不需要将字体的 URL 传递给 Font Face Observer，它会使用 CSS 文件中已经定义的 `@font-face` 规则来加载字体。这样你就可以在使用 JavaScript 手动加载字体的同时，还能优雅降级到利用 CSS 的实现。

## [](#loading-groups-of-fonts)分组字体加载模式

你也可以在加载多个字体的时候将它们分组：一个组内的字体只能全部加载成功或是全部加载失败。如果你加载的字体文件属于同一个字体族，且你希望仅在它们全部加载成功时才进行渲染，那么这种方式将会非常实用。这可以阻止浏览器在没能成功加载整个字体族时渲染出糟糕的网页。

    var normal = new FontFaceObserver('Output Sans');
    var italic = new FontFaceObserver('Output Sans', {
      style: 'italic'
    });

    Promise.all([
      normal.load(),
      italic.load()
    ]).then(function () {
      console.log('Output Sans family has loaded.');
    });

你可以使用 `Promise.all` 来对字体进行分组。只有在所有字体都成功加载后 Promise 才会被解析，一旦有某个字体加载失败，Promise 就会被拒绝。

将字体分组的另一个用途是减少页面布局的重新计算渲染。如果你逐步加载和渲染所有字体，浏览器将会因为网络字体和降级字体之间不同的尺寸而多次重新计算布局。将字体分组可以把多次计算布局优化为一次。

## [](#loading-fonts-with-a-timeout)限制字体加载时间

有些时候字体需要很长时间来加载，但由于字体通常是用于渲染网站的主要内容——文字，长时间的加载就会造成问题。无限制地等待一个字体的加载是不可接受的。你可以通过向字体加载添加一个计时器来解决这个问题。

如下的辅助函数创建了一个计时器，超时后会返回一个被拒绝的 Promise.

    function timer(time) {
      return new Promise(function (resolve, reject) {
        setTimeout(reject, time);
      });
    }

通过使用 `Promise.race`，我们可以让字体加载和计时器“竞速”。举个例子，如果字体在计时器触发前加载完成，字体就胜利了，Promise 将会被解析。如果计时器在字体加载完成前触发，Promise 就会被拒绝。

    var font = new FontFaceObserver('Output Sans');

    Promise.race([
      timer(1000),
      font.load()
    ]).then(function () {
      console.log('Output Sans has loaded.');
    }).catch(function () {
      console.log('Output Sans has timed out.');
    });

在这个例子中，字体与一个1秒的计时器竞速。除了与单个字体竞速，计时器还可以与一组字体竞速。这是一种简单而且有效的限制字体加载时间的方法。

## [](#prioritised-loading)队列加载模式

通常情况下，只有部分字体对于渲染首屏内容来说是必要的。在加载其它可选字体之前先加载这些字体，将会极大程度地改善你网站的性能。你可以使用队列加载模式来实现。

    var primary = new FontFaceObserver('Primary');
    var secondary = new FontFaceObserver('Secondary');

    primary.load().then(function () {
      console.log('Primary font has loaded.')

      secondary.load().then(function () {
        console.log('Secondary font has loaded.')
      });
    });

队列加载模式将会使次要字体依赖于主要字体。如果主要字体加载失败，次要字体将不会被加载。这会是一个非常重要的特性。

举个例子，你可以使用队列加载模式来加载一个小的主要字体以提供有限的支持，之后再加载一个更大的次要字体来提供更多特征和样式。因为主要字体非常小，它的加载和渲染将会非常快。如果主要字体加载失败，你可能也不希望加载次要字体，因为其很可能也会加载失败。

如果需要更详细的关于队列加载模式的信息，请参阅 Zach Leatherman 的文章 [Flash of Faux Text](http://www.zachleat.com/web/foft/) 以及 [Web Font Anti-Patterns: Data URIs](http://www.zachleat.com/web/web-font-data-uris/)。

## [](#custom-font-display)自定义字体显示行为

浏览器显示网络字体前需要先通过网络下载字体，这通常需要一定的时间，并且不同的浏览器在下载网络字体时有不同的行为。一些浏览器在加载字体时隐藏文字，而另一些浏览器会先显示降级字体。这两种方法通常被称为 Flash Of Invisible Text（FOIT）和 Flash Of Unstyled Text（FOUT）。

![](http://ww1.sinaimg.cn/large/a490147fgw1f3aa9x12itj21540lraf4.jpg)

IE 和 Edge 使用 FOUT，即在网络字体加载完成之前显示降级字体。所有其他的浏览器都使用 FOIT，即在网络字体加载时隐藏文本。

一个新的 CSS 属性 `font-display`（[CSS Font Rendering Controls](https://tabatkins.github.io/specs/css-font-display/)）是用于控制这个行为的。然而，该特性依然处于开发阶段并尚未被任何浏览器支持（当前在 Chrome 和 Opera 中可以手动开启）。然而，我们可以使用 [Font Face Observer](https://github.com/bramstein/fontfaceobserver) 在所有的浏览器中实现相同的功能。

你可以通过仅在字体栈中放入加载完成的字体来使得使用 FOIT 的浏览器在加载网络字体时使用降级字体渲染。如果正在下载的字体不在字体栈中，那些浏览器就不会试图隐藏文本。

最简单的实现方法是在 `html` 元素上为三个网络字体加载状态设置不同的 class：loading（加载中），loaded（加载完成），以及 failed（加载失败）。

    var font = new FontFaceObserver('Output Sans');
    var html = document.documentElement;

    html.classList.add('fonts-loading');

    font.load().then(function () {
      html.classList.remove('fonts-loading');
      html.classList.add('fonts-loaded');
    }).catch(function () {
      html.classList.remove('fonts-loading');
      html.classList.add('fonts-failed');
    });

使用这三个 class 和一些简单的 CSS，你就可以在所有浏览器中实现 FOUT。我们为所有将要使用网络字体的元素定义降级字体。当 `fonts-loaded` class 出现在 `html` 元素上时，我们通过改变元素的字体栈来应用网络字体。这将会要求浏览器加载网络字体，但是因为这些字体已经下载完成了，渲染操作将能在瞬间完成。

    body {
      font-family: Verdana, sans-serif;
    }

    .fonts-loaded body {
      font-family: Output Sans, Verdana, sans-serif;
    }

使用这种方法来加载网络字体可能会让你想到渐进增强（progressive enhancement），这不是一个巧合。FOUT 就是一种渐进增强。默认的体验是使用降级字体渲染，然后使用网络字体来增强体验。

实现 FOIT 同样简单。只要在网络字体开始加载时隐藏使用这些字体的内容，当字体加载完成后再重新显示。注意要记得处理加载失败的情况，即使网络字体加载失败，你的内容应该依然可见。

    .fonts-loading body {
      visibility: hidden;
    }

    .fonts-loaded body,
    .fonts-failed body {
      visibility: visible;
    }

这样隐藏内容是否让你感到不适？对，隐藏内容应该在非常特殊的情况下才被使用，比如你的网络字体没有合适的降级字体，或者你知道字体已经被缓存了。

## [](#optimise-for-caching)为缓存优化

其他的字体加载模式允许你自定义你加载字体的时间和方式。通常情况下，如果字体已经在缓存中，你会希望以不同的方式渲染字体。比如说，当字体已经被缓存时，就不需要先渲染降级字体了。我们可以通过使用 session storage 跟踪缓存情况的方式来实现。

当一个字体被加载后，我们在 session 中创建一个布尔型标记。这个标记将会保持在整个会话过程中，所以这会是判断文件是否在浏览器缓存中的一个很好的方法。

    var font = new FontFaceObserver('Output Sans');

    font.load().then(function () {
      sessionStorage.fontsLoaded = true;
    }).catch(function () {
      sessionStorage.fontsLoaded = false;
    });

然后你就可以使用这个信息以在字体被缓存时改变字体加载策略。比如说，你可以在 `head` 元素中插入如下的 JavaScript 片段来直接渲染网络字体。

    if (sessionStorage.fontsLoaded) {
      var html = document.documentElement;

      html.classList.add('fonts-loaded');
    }

如果你使用这种方式加载字体，用户会在第一次访问你的网站时体验到 FOUT，但是随后的页面将会直接渲染网络字体。这样你既有渐进增强，又不会破坏重复访问者的体验。
