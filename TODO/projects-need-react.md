> * 原文地址：[Which Projects Need React? All Of Them!](https://css-tricks.com/projects-need-react/)
> * 原文作者：本文已获原作者 [SACHA GREIF](https://css-tricks.com/author/sachagreif/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[LeviDing](https://github.com/leviding)、[Shangbin Yang](https://github.com/rccoder)

# 哪些项目需要 React？都需要！

项目什么时候需要 React 框架呢？这是 Chris Coyier 在[最近一篇博文](https://github.com/xitu/gold-miner/blob/master/TODO/project-need-react.md)中提出的问题。我是 Chris 博客的粉丝，所以我好奇他要说什么。

简而言之，Chris 提出了一系列使用 React（或其他类似的当代 JavaScript 库）的优势和劣势。虽然我并不反对他的观点，但我依然发现自己得出了不同的结论。

所以今天我想说的是，对于“项目什么时候需要 React 框架”的答案不是“要看情況”，而是“**任何时候**”。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/tools.jpg)

### React vs Vue vs Angular vs… ###

首先，说点题外话：在他的文章中，Chris 选择 React 作为一般意义上“前端库”的代表，那么我也一样。况且 React 是我维护的仓库 [VulcanJS](http://vulcanjs.org)（一个 React 和 GraphQL 框架）中最熟悉的东西。

话虽如此，我的观点也适用于任何提供 React 相同特性的其他库。

### 锤子的力量 ###

> 如果你手里只有一把锤子， 所有东西看上去都像钉子。

这则谚语长久以来都被用于谴责一刀切看问题的人。

但我们假设有一段时间，你的确生活在布满钉子的世界（听起来有点起鸡皮疙瘩），那么你信任的锤子能够解决你遇到的任何问题。

想想**每次重复使用相同工具**的好处：

- 无需花时间决定使用哪一个工具。
- 花更少的时间学习新工具。
- 拥有更多的时间来更好地挥舞你选择的工具。

所以 React 会是这种工具吗？我觉得它可能是的！

### 复杂度谱 ###

首先，我们来看看最常见的反对“一切皆 React”的观点。我直接引用 Chris 原话：

> 举个例子，一个博客也许没什么复杂的逻辑，一点也不符合应该使用 React 框架的情况。既然在这种情况下 React 框架不是很合适，那么在这用 React 框架就不是好的选择。因为这么做引入了复杂的技术，依赖了很多根本没用到的东西。

说的很在理。一个简单的博客不**需要** React。毕竟即使你需要一点 Javascript 处理注册表单，你也可以仅仅使用 jQuery。

什么？你需要在不同页面的多个地方使用那个表单？还要只在某些条件下才显示？也要加上动画？等等，打住…

我用这个小情景想表达的主旨就是复杂性并不是一个或是或非的问题，现代网站生活在一个连续的频谱上，从静态页面一直到丰富的单页应用。

所以可能**现在**你的项目正舒服地生活在“简单”的这一头，但这一路下去六个月后呢？与其陷入鸽子洞式的糟糕实践，选择一种留有成长空间的技术岂不更好？

### React 的优势 ###

> 过早优化是万恶之源。

这是程序员中流行的另一则言语。毕竟，当胶带就能做的很好的时候，谁会需要锤子和钉子呢！

但这里做了一个假设就是“过早优化”是一个长期的少有成效的艰难过程。并且我觉得这个不适于 React。

虽然 React 需要一些时间来习惯，但一旦了解了其[基本概念](https://medium.freecodecamp.com/the-5-things-you-need-to-know-to-understand-react-a1dbd5d114a3)，您就能像使用传统的前端工具一样快速上手。

事实上，也许更多的是因为 React 使用了非常强大的**组件**概念。就像 CSS 鼓励你考虑可重用的类和样式一样，React 带来了一个灵活的模块化前端架构，从简单的静态主页到交互式后端仪表板，为每一个用例带来好处。

### JavaScript， 随处都是 JavaScript ###

我们生存在 JavaScript 的世界。就像 Chris 所说：

> 你通过 Node.js 构建服务端，也有很多项目可以通过 JavaScript 处理 CSS。现在通过 React 框架，你还可以在 JavaScript 里写 HTML。
>
> 万物归于 JavaScript！JavaScript 万岁！

Chris 不是很相信，但我相信。JavaScript 本身并不一定完美，但能够访问整个现代 NPM 生态系统太棒了。

过去安装一个 jQuery 插件要找到它的官网，下载下来，拷贝到你的项目目录，加一个 `<script>` 标签，然后期望记得每过几个月检查一下新版本。现在，安装和 React 包同样的插件只是 npm install 命令的问题。

使用像 [styled-components](https://medium.freecodecamp.com/a-5-minute-intro-to-styled-components-41f40eb7cd55) 这样的新库，甚至 CSS 现在也被连带着尖叫着进入未来。

相信我，一旦你习惯了那种全世界都在说的语言，那就很难再回归到以前的方式了。

### 不会有人想到用户！

我知道你在想什么：目前为止我一直在推销 React 给开发者带来的好处，却小心翼翼的提及终端用户的体验。

并且这仍然是反对使用当代库的关键论点：缓慢臃肿的 JavaScript 站点却只是为了显示单个“奇迹淫巧”的广告。

此外还有一个小秘密：**你可以完全不引用 JavaScript 而获得 React 的所有优势**！

我想说的是在**服务端**渲染 React。事实上， 像 [Gatsby](https://github.com/gatsbyjs/gatsby)（还有 [Next.js](https://github.com/zeit/next.js/) 等等）这样的工具可以把你的 React 组建编译进静态 HTML 文件中，这样你可以托管在 GitHub pages 上面。

举个例子，[我自己的个人站点](http://sachagreif.com/) 就是一个 Gatsby-generated React 应用，没有加载任何的 JavaScript（除了一个 Google Analytics 片段）。 我在开发中发挥了 React 的所有优势（全 JavaScript，拥抱 NPM 生态，styled-components 等），而最终得到了纯 HTML 和 CSS 的最终产品。

### 总结

概括一下，这是我认为 React 是**任何**项目的可行选择的四个原因：

- 即使是最简单的网站，也很难保证你永远不会需要交互功能，如标签、表单等。
- React 基于组件的方式即使相比于基于内容的静态站，也有巨大的优势。
- 拥抱现代 JavaScript 生态系统是又一个巨大的优势。
- 现代服务端渲染工具可以消除终端用户使用 React 的劣势。

所以 Chris，您觉得呢？我的观点否足够令人信服？还是您依然保持怀疑？

那么你呢，亲爱的读者？你觉得像 Chris 所说每一个工具都有它的用处，还是同意我的观点“锤子时间”就在眼前？评论起来让我知道你们的观点吧！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
