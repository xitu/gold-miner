> * 原文地址：[CSS fix for 100vh in mobile WebKit](https://allthingssmitty.com/2020/05/11/css-fix-for-100vh-in-mobile-webkit/)
> * 原文作者：[Matt Smith](https://allthingssmitty.com/about)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/css-fix-for-100vh-in-mobile-webkit.md](https://github.com/xitu/gold-miner/blob/master/article/2020/css-fix-for-100vh-in-mobile-webkit.md)
> * 译者：[z0gSh1u](https://github.com/z0gSh1u)
> * 校对者：[lhd951220](https://github.com/lhd951220)、[Gesj-yean](https://github.com/Gesj-yean)

## 移动端 WebKit 内核浏览器 100vh 问题的 CSS 修复方法

不久以前，有人在讨论 WebKit 是怎么处理 CSS 的 `100vh` 的，本质上就是会忽略浏览器视口的下边沿。有的人建议避免使用 `100vh`，其他人有一些 [不同的替代方法](https://medium.com/@susiekim9/how-to-compensate-for-the-ios-viewport-unit-bug-46e78d54af0d) 来变通解决这个问题。实际上，这个问题可以追溯到几年前 Nicolas Hoizey [向 WebKit 提交的关于该主题的 bug](https://nicolas-hoizey.com/articles/2015/02/18/viewport-height-is-taller-than-the-visible-part-of-the-document-in-some-mobile-browsers/) （概括一下：WebKit 说这种处理是故意的 🧐）。

有一天，我在做一个基本的 Flex 布局 —— header、main 和 sticky footer —— 就是我们经常看到、经常使用的那种：

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

我开始在我的 iPhone 上做一些浏览器测试，正是那时，我发现 sticky footer 并不像预想的那样落在视口最底部：

![sticky footer 显示在 Safari 菜单栏以下的手机屏幕](https://allthingssmitty.com/img/posts/2020-05-11-css-fix-for-100vh-in-mobile-webkit-01.png)

footer 藏在了 Safari 的菜单栏后面。这就是 Nicolas 最初发现并报告的所谓的 `100vh` bug （或者是 feature ？） 。我做了一点调查 —— 希望现在已经找到一种不那么 hack 的解决方案 —— 然后，我找到了我的解决方法 （顺带一提，它完全是一种 hack 的方法）：

![图片](https://user-images.githubusercontent.com/5164225/82304565-182c2080-99ef-11ea-9a18-c27545f53b87.png)

## 使用 -webkit-fill-available

`-webkit-fill-available` 背后的想法 —— 至少有一点 —— 是允许一个元素固有地适合某个特定的布局，也就是说，填满能用的空间。目前，这类 [固有值](https://caniuse.com/#feat=intrinsic-width) 还没有被 CSS 工作组完全支持。

然而，上述问题是 WebKit 内核特有的，而 WebKit 内核恰好支持 `-webkit-fill-available`。所以考虑到这一点，我把它加到了有 `100vh` 的规则集里面，这样其他浏览器可以有 fallback 的选项。

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

**注：**上面的代码段更新了在 `html` 元素中添加 `-webkit-fill-available` 的部分，因为 [我得知](https://twitter.com/bfgeek/status/1262459015155441664) 为了与 Firefox 的实现保持一致，Chrome 正在更新它的行为。

现在，sticky footer 在移动端 Safari 中落到了正确的位置！

![Safari 菜单栏上方视口底部显示有 sticky footer 的手机屏幕](https://allthingssmitty.com/img/posts/2020-05-11-css-fix-for-100vh-in-mobile-webkit-02.png)

## 这真的有用吗？

这个问题有很多争论。我做过的测试都没有什么问题，并且我现在已经在生产环境下应用这种方法了。但是我的推文也收到很多反馈，指出了使用这个方法可能带来的问题（旋转设备的影响、Chrome 有时会忽略这个属性，等等）。

`-webkit-fill-available` 会不会在各种场景下都有用？可能不会，因为坦白地说：这是 Web 开发，要做得好是相当难。但是，如果你遇到了 WebKit 内核浏览器的 `100vh`问题，并在寻求一种 CSS 层面的替代，你可能可以试试这种方法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
