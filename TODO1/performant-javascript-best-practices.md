> * 原文地址：[Performant JavaScript Best Practices](https://levelup.gitconnected.com/performant-javascript-best-practices-c5a49a357e46)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/performant-javascript-best-practices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/performant-javascript-best-practices.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[niayyy-S](https://github.com/niayyy-S), [xionglong58](https://github.com/xionglong58)

# 高性能 JavaScript 最佳实践

![Photo by [Jason Chen](https://unsplash.com/@ja5on?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5760/0*UyQ42ciE79LF-bK4)

与其它程序一样，如果我们不细心编写代码，JavaScript 程序的运行速度可能会变得很慢。

在本文中，我们将介绍一些关于编写高性能 JavaScript 程序的最佳实践。

## 通过宿主对象 (Host Object) 与用户的浏览器来减少 DOM 操作

DOM 操作是缓慢的。我们操作得越多，其速度就越慢。由于 DOM 操作是同步的，因此每个操作都是一次性完成的，同一时间程序的其它操作就被挂起了。

所以，我们应该尽量减少正在执行的 DOM 操作。

加载 CSS 和 JavaScript 会阻塞 DOM。 不过，图像是不会阻塞渲染的，因此加载图像不会耽搁页面加载。

但是，我们仍然希望能尽可能降低图像的大小。

可以通过 Google 的网页加载速度检测工具 (Google PageSpeed Insights) 检测阻塞渲染的 JavaScript 代码，它会告诉我们有多少段阻塞渲染的 JavaScript 代码。

任何内联的 CSS 都会阻塞整个页面的渲染。它们是分散在页面中，使用 `style` 属性的样式。

我们应该将它们全部移动到其所属的样式表中，放在 `style` 标签内，并放在 body 元素下方。

为了减少要加载的样式表数量及其大小，CSS 应该进行合并和压缩。

我们也能通过媒体查询将 `link` 标签标记为不渲染的部分。例如，我们能通过编写以下代码来实现：

```html
<link href="portrait.css" rel="stylesheet" media="orientation:portrait">
```

这样它就只会在页面纵向显示的时候被加载。

我们应该将样式操作移到 JavaScript 以外，并通过将样式放入样式表文件内它们所属的类中，以达到将样式放入 CSS 中的目的。

例如，我们可以编写以下代码，以在 CSS 文件中添加一个类：

```css
.highlight {
  background-color: red;
}
```

然后我们可以通过 `classList` 对象添加一个类，如下所示：

```js
const p = document.querySelector('p');
p.classList.add('highlight');
```

我们将 `p` 元素的 DOM 对象设置为常量，这样就可以缓存它，以便在任何地方复用，然后调用 `classList.add` 方法来给它添加 `hightlight` 类。

我们也可以在不使用的时候删掉它。这样，就不用在 JavaScript 代码中进行很多不必要的 DOM 操作了。

如果我们的脚本没有依赖其它脚本，则可以异步地加载它们，这样它们就不会阻塞其它脚本的加载了。

我们只需将 `async` 放进我们的脚本标签中，就可以实现异步加载了，如下所示：

```html
<script async src="script.js"></script>
```

现在 `script.js` 将能够异步加载。

我们也可以通过 `defer` 指令来延迟脚本的加载。它还保证了脚本会按照页面上出现的顺序执行。

如果希望我们的脚本按顺序地加载，并且不阻塞其它加载，这是一个更好的选择。

在将我们的代码投入生产之前，压缩脚本也是一项必做的工作。为此，我们使用像 Webpack 和 Parcel 这样的模块化打包工具，它会为我们自动地创建并打包项目。

同样的，Vue 和 Angular 框架的命令行工具也会自动进行压缩代码的工作。

## 最小化我们的应用程序使用的依赖数量

我们应该尽量最小化所使用的脚本和库，无用的依赖应该删除掉。

例如，如果我们为了操作数组而使用 Lodash 库的方法，那么我们可以使用原生的 JavaScript 数组方法替换之，效果同样好。

一旦删除依赖，我们同时应该从 `package.json` 中将其删除，并且运行 `npm prune` 命令，将这些依赖从我们的系统中清除。

![Photo by [Tim Carey](https://unsplash.com/@baudy?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6154/0*9Qx9V9XpyjsjvSME)

## 糟糕的事件处理

复杂的事件处理代码总是很慢。我们可以通过减少调用栈的深度来提高性能。

这意味着我们将尽可能地少调用方法。如果我们在事件处理中操作样式的话，尽量将样式操作放入 CSS 样式表中。

尽量少调用方法，例如使用 `**` 操作符来代替 `Math.pow` 方法。

## 结论

我们应该尽可能减少依赖的数量，并异步地加载它们。

另外，我们应该减少代码中的 CSS，并将它们挪到各自所属的样式表中。

我们还可以添加媒体查询，以便样式表不会在每种设备都加载。

最后，我们应该减少代码中方法被调用的次数。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
