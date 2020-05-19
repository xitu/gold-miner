> * 原文地址：[]()
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/.md](https://github.com/xitu/gold-miner/blob/master/article/2020/.md)
> * 译者：
> * 校对者：

## CSS fix for 100vh in mobile WebKit

Not long ago there was some buzz around how WebKit handles `100vh` in CSS, essentially ignoring the bottom edge of the browser viewport. Some have suggested avoid using `100vh`, others have come up with [different alternatives](https://medium.com/@susiekim9/how-to-compensate-for-the-ios-viewport-unit-bug-46e78d54af0d) to work around the problem. In fact, this issue goes further back a few years when Nicolas Hoizey [filed a bug with WebKit](https://nicolas-hoizey.com/articles/2015/02/18/viewport-height-is-taller-than-the-visible-part-of-the-document-in-some-mobile-browsers/) on the subject (the short of it: WebKit says this is “intentional” 🧐).

The other day I was doing some work with a basic flexbox layout – header, main, sticky footer – the kind we’ve all seen and used many times before:

```html
<header>HEADER GOES HERE</header>
<main>MAIN GOES HERE</main>
<footer>FOOTER GOES HERE</footer>
```

```css
body {
  display: flex; 
  flex-direction: column;
  margin: 0;
  min-height: 100vh;
}

main {
  flex: 1;
}
```

I began running some browser tests on my iPhone, and that’s when I noticed that my sticky footer wasn’t looking so sticky:

![Mobile screen showing sticky footer below Safari's menu bar](/img/posts/2020-05-11-css-fix-for-100vh-in-mobile-webkit-01.png)

The footer was hiding below Safari’s menu bar. This is the `100vh` bug (feature?) that Nicolas originally uncovered and reported. I did a little sleuthing – hoping that maybe by now a non-hacky fix had been found – and that’s when I stumbled upon my own solution (btw, it’s totally hacky):

![image](https://user-images.githubusercontent.com/5164225/82304565-182c2080-99ef-11ea-9a18-c27545f53b87.png)

## Using -webkit-fill-available

The idea behind `-webkit-fill-available` – at least at one point – was to allow for an element to intrinsically fit into a particular layout, i.e., fill the available space for that property. At the moment [intrinsic values](https://caniuse.com/#feat=intrinsic-width) like this aren’t fully supported by the CSSWG.

However, the above problem is specifically in WebKit, which **does** support `-webkit-fill-available`. So with that in mind, I added it to my ruleset with `100vh` as the fallback for all other browsers.

```css
body {
  min-height: 100vh;
  /* mobile viewport bug fix */
  min-height: -webkit-fill-available;
}

html {
  height: -webkit-fill-available;
}

```

**Note:** the above snippet was updated to add `-webkit-fill-available` to the `html` element, as [I was told](https://twitter.com/bfgeek/status/1262459015155441664) Chrome is updating the behavior to match Firefox’s implementation.

And now the sticky footer is right where I want it to be in mobile Safari!

![Mobile screen showing sticky footer at the bottom of the viewport above Safari's menu bar](/img/posts/2020-05-11-css-fix-for-100vh-in-mobile-webkit-02.png)

## Does this really work?

The jury seems to be out on this. I’ve had no problems with any of the tests I’ve run and I’m using this method in production right now. But I did receive a number of responses to my tweet pointing to other possible problems with using this (the effects of rotating devices, Chrome not completely ignoring the property, etc.).

Will `-webkit-fill-available` work in every scenario? Probably not, cuz let’s be honest: this is the web, and it can be damn hard to build. But, if you’re having a problem with `100vh` in WebKit and you’re looking for a CSS alternative, you might want to try this.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
