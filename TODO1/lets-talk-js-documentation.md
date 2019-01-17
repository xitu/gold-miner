> * 原文地址：[Let's talk JS ⚡: documentation](https://areknawo.com/lets-talk-js-documentation/)
> * 原文作者：[Arek Nawo](https://areknawo.com/author/areknawo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lets-talk-js-documentation.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lets-talk-js-documentation.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[wznonstop](https://github.com/wznonstop), [SHERlocked93](https://github.com/SHERlocked93)

# 讨论 JS ⚡：文档

如果你曾经参与过开源项目，或大到需要文档的项目，那么你应该知道编写一个合格的文档是多么的重要。此外，文档需要始终保持最新，并且应包含所有公共 API。因此，如何制作**完美的文档呢**？本文的目标就是用 JS 的风格来解决这个问题！⚡  

![two person holding ceramic mugs](https://images.unsplash.com/photo-1521798552185-ee955b1b91fa?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjExNzczfQ)

Photo by [rawpixel](https://unsplash.com/@rawpixel?utm_source=ghost&utm_medium=referral&utm_campaign=api-credit) / [Unsplash](https://unsplash.com/?utm_source=ghost&utm_medium=referral&utm_campaign=api-credit)

## 而且只有两种方法...

为你的项目编写文档的方法只有两种。即：**自己写**或者**自动生成**。这里没有黑魔法，也别无他法.

那么，我们先开始研究“自己写文档”。在这个场景中，你可以轻松地创建漂亮的文档站点。当然，这将需要你做更多的工作，但如果你认为这是值得的，那就去做吧。👍当然，你需要考虑保持你的文档的实时性，这也会造成额外的时间花费。可定制化是最大的优势。你的文档可能会使用 **markdown**（最常见的 [**GFM**](https://guides.github.com/features/mastering-markdown)）编写的 — 它只是一种标准。你可以让它看起来很漂亮，如果你正在创建 OSS 的话，这一点很重要。有一些库可以帮助你完成这项任务，之后我们将会深入了解它们。

接下来，我们可以选择从代码本身生成文档。很明显，这也不是那么直截了当的事情。首先，你必须使用像 [**JSDoc**](http://usejsdoc.org) 这样的工具，以 **JavaDoc-like** 注释的形式编写文档。所以，并不是说可以直接就生成文档。现在 **JSDoc** 已经很优秀了。我的意思是，看看它的官方文档，看看你能使用多少标签。此外，现代代码编辑器将获取你的类型定义和其他描述，在开发过程中帮助你使用自动完成和弹出文档的功能。在你写简单的 markdown 时，是不会实现这种效果的。当然，你需要单独写诸如 **README** 这样的文件，而生成的文档则会有些程序化，但我认为这不是什么大问题。

## 选择正确的工具...

因此，假设你已经决定手动创建文档（或者应该说是用键盘），而且是使用 markdown（或者你只是从其他地方了解到了 markdown）。现在，你可能需要一个称为 **renderer** 的工具，它将把你的 MD（markdown）转换成 HTML、CSS 等漂亮的组合。这是在你不仅仅想把它发布到 GitHub、GitHub 的 wiki 上时的方案。或者你想让 MD 附加一个额外的 **reader**（[就像这样](https://typora.io)）。现在，为了解决这个任务（IMHO），我将为你列出一些最好的工具。😉

### [Docsify](https://docsify.js.org)

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-19-27-21.png)

Docsify 登录界面

**Docsify** 是**一个神奇的文档站点生成器**。它很好地完成了文档生成的任务。重要的是，它可以**动态地**呈现你的文档，这意味着你无需将 MD 解析为 HTML — 只需要将你的文件放在正确的位置即可！除此以外，Docsify 有大量插件和一些主题可供选择。它也有很好的文档记录（就像文档生成器一样）。当[我自己项目的文档](https://areknawo.github.io/Rex)使用这个工具时，我可能会有些偏见。它唯一的问题是（至少对我来说）与 IE 10（正如其在主页上所说）的兼容性不是很好（但是他们正在尝试进行兼容），而且它对**相关链接缺少必要的支持**。

### [Docute](https://docute.org)

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-19-49-19.png)

Docute v4 文档

**Docute** 是一个类似于 Docsify 的工具，但它有一个**可爱的名字**。最新的版本（v4）相比[上一个版本](https://v3.docute.org)要少一些文档，同时也进行了一定程度的简化。生成的文档看起来简约而优雅。可以使用 **CSS 变量** 定制主题。Docute 不像 Docsify 那样拥有强大的插件系统，但它有着自己的优势。它建立在 Vue.js 之上，这导致包的大小相比于 Docsify 要大些，但扩展性好了很多。比如，在你的 MD 文件中，你可以使用一些内置的 Vue 组件，甚至你自己的组件。

### [Slate](https://github.com/lord/slate)

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-20-19-16.png)

Slate 文档

**Slate** 可能是在 GitHub 上记录你的项目以及小星星数量的领头羊（**~25,000**）。它的文档清晰，语法可读性好，且有 everything-on-one-page 的特点。还具有非常可靠的 GH wiki 文档。它允许[深度主题化](https://github.com/lord/slate/wiki/Custom-Slate-Themes) ，但因为文档提供的信息不多，所以你需要自己去源码挖掘。遗憾的是，它的可扩展性很差，但胜在功能丰富，对于那些需要 **REST** API 文档的人来说，这似乎是一个不错的选择。请记住，Slate 生成的是静态 HTML 文件，而不是在运行中动态生成文件

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-20-35-03.png)

Docusaurus 登录界面

### [Docusaurus](https://docusaurus.io)

**Docusaurus** 是一个**易于维护开源文档生成网站**的工具。它是由 Facebook 创建的，使用的是 — 没错，就是它 — React。它可以将 React 组件和库轻松地转换或集成为一个整体来创建自定义页面。无需其他工具，它还可以建立额外的 **blog** 直接整合到你的文档网站，甚至无需其他工具！它可以与 [Algolia DocSearch](https://community.algolia.com/docsearch) 很好地集成，使你的文档易于导航。就像 Slate 一样，它会生成静态 HTML 文件。

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-21-27-48.png)

VuePress 登录界面

### [VuePress](https://vuepress.vuejs.org)

**VuePress** 是一个 **Vue 驱动的静态站点生成器**，由 Vue.js 的创始人开发。这也是生成 Vue.js 官方文档的可靠工具。作为一个生成器，它有非常友好的文档。它还具有一个强大的插件和主题系统，当然也继承了优秀的 Vue.js。uePress 宣称其对 SEO 友好，这是因为它生成并输出的是 HTML 文件。

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-21-39-29.png)

GitBook 登录界面

### [GitBook](https://www.gitbook.com)

**GitBook** 是用于编写 MD 文档和文本的工具。它为你提供了一个在线编辑器和免费 **.gitbook.io** 域名体验。毫无疑问，在线编辑器很棒，但是涉及到布局，它并没有太多的可定制性。该编辑器还有它的遗留桌面版本。但除非你是在做一个开源的项目，否则你需要为此付费。

## 生成器！

既然我们已经介绍了最好的文档制作工具，那我们接下来开始使用生成器，好不？生成器主要允许你从带注释的代码中创建文档。

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-21-54-31.png)

JSDoc 登录页面

### [JSDoc](http://usejsdoc.org)

**JSDoc** 可能是 JS 最明显和最有名的文档生成器。它支持非常多的标签，并且对几乎所有的编辑器和 IDE 自动完成功能友好。它的输出可以使用多种主题进行定制。并且主题的种类非常多。更有意思的是，使用这个和其他生成器，你可以输出 **markdown**，以便之后与上面所列的任何文档工具一起使用。

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-14-22-01-26.png)

TypeDoc 登录页面

### [TypeDoc](https://typedoc.org)

**TypeDoc** 可视为 [TypeScript](https://www.typescriptlang.org) 的 JSDoc。它榜上有名的主要原因是，支持 TS 类型的文档生成器很少（或者说没有）。通过使用该工具，你可以基于 TypeScript 类型系统来生成文档，包括接口和枚举等结构。遗憾的是，它只支持一小部分 JSDoc 标记，没有 JSDoc 这样的大社区。因此，它没有太多的主题，文档匮乏。IMO 有效使用该工具的最佳方法是使用 **markdown** 主题插件，并使用其中一个文档工具。 

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-09-44-43.png)

ESDoc 登录界面

### [ESDoc](https://esdoc.org)

**ESDoc** 在功能上与 JSDoc 相似。它支持类似于 JSDoc 的注释标签。它对文档代码风格测试或覆盖测试提供了可选的支持。它有大量的插件集合。此外，还有一些针对 TypeScript、Flow 和 markdown 输出的概念验证插件。

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-09-54-29.png)

### [Documentation.js](https://documentation.js.org)

**Documentation.js** 是现代文档生成器，它可以输出 HTML、JSON 或 markdown，具有极大的灵活性。它支持 ES 2017、JSX、Vue 模版和 Flow 类型。他还能进行**类型推断**以及原生 — JSDoc 标记。它有基于 underscore 模版的深度主题选项。遗憾的是，（对我来说）它不支持 TypScript。😕

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-10-14-11.png)

DocumentJS 登录界面

### [DocumentJS](https://documentjs.com)

**DocumentJS** 是文档生成的解决方案，它不像上面的竞争对手那么受欢迎。支持大多数 JSDoc 和 Google 闭包编译器标记，还能够添加自定义的附加功能。它默认只生成可主题化的 HTML，但具有很强的扩展性。

## 不一样的内容。。。

上面我列出了一些标准文档工具和生成器。当然，它们可以一起用来创建好的文档。但是我想再给你推荐一个工具。你听说过 **literate programming** 么？也就是说，你可以**使用 markdown 语法**来写注释，并通过它来生成代码。它真的把你的代码变成了诗。

![](https://areknawo.com/content/images/2018/12/Screenshot-from-2018-12-15-10-33-58.png)

Docco 登录界面

然后，你使用像 **[Docco](http://ashkenas.com/docco)** 这样的工具将你的 markdown 注释代码转换为带有代码片段的 markdown。我可以说这是新的尝试。😁

## 你都知道了 😉

我希望这篇文章至少能让你在创建文档时轻松一点。上面这个清单包含了质量顶尖并且维护良好（到目前为止）的项目。如果你喜欢这篇文章，请考虑分享它，你可以在 Twitter 上关注我，或者订阅下面的邮件列表来获取更多优秀的文章。🦄

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
