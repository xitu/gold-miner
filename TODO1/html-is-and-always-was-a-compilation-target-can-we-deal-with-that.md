> * 原文地址：[HTML is and always was a compilation target – can we deal with that?](https://christianheilmann.com/2019/01/28/html-is-and-always-was-a-compilation-target-can-we-deal-with-that/)
> * 原文作者：[Christian Heilmann](https://christianheilmann.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/html-is-and-always-was-a-compilation-target-can-we-deal-with-that.md](https://github.com/xitu/gold-miner/blob/master/TODO1/html-is-and-always-was-a-compilation-target-can-we-deal-with-that.md)
> * 译者：[CodeMing](https://github.com/coderming)
> * 校对者：[jerryOnlyZRJ](https://github.com/jerryOnlyZRJ)，[Fengziyin1234](https://github.com/Fengziyin1234)

# HTML 一直是我们编译的目标 – 我们可以解决好它吗？

每隔几周，Web 开发者的 Twitter 圈都会因为糟糕的 HTML 代码而吵到疯狂。但 HTML 只是一些带有各种各样属性的 div 和 span 而已。有些 HTML 不仅缺乏任何可见的接口，例如锚点或按钮，也缺乏任何结构，例如头部和列表。啊，这就是非语义的 HTML，不可读的 HTML。

HTML 的定义很清晰，由于它的语法有着很高的容错率，它也很健壮。在XHTML时代，我们试图让HTML降低容错率，但是网络环境不允许我们这样做。开发者犯下的错不应让用户背锅，而应该让浏览器宽容 HTML 同时在渲染时自动修复错误。这个问题应让我们产生担忧：我们被迫忍受多年来浏览器的糟糕决定。这就是为什么 HTML 不像其它语言那样（进步得很快）—— 因为浏览器太臃肿和缓慢了。

## HTML 允许我们犯错

首先，HTML 的高容错率帮助了 web 世界存活下来。它确保了现代浏览器也可以显示很老的内容，而无需进行更改。很多年的 Flash 内容现在都无法使用了，这件事证明在网络这样波动很大的环境中，容错率高是一件正确的事情。

> 但是, 这确实意味着对非语义 HTML 没有可感知到的错误。用 div、span 来实现 table 布局仍然可以正常工作（说的就是这个网站：[hackernews](https://news.ycombinator.com/)）

展示给我们所有内容的浏览器让我们感到担心，因为它让“干净整洁“和“语义化”的 HTML 变成了一种少数人拥有的特殊技能。HTML 作为网络创作的文字，其书法千千万，其中有大多数的内容都像是随意涂写的涂鸦。

语义化的 HTML 是很棒的，我们可以确保它没有问题。你可以从语义化的 HTML 中得到很多显而易见的好处。它往往表现得更好，它通常也意味着没有第三方依赖，也容易阅读和理解。我们中的很多人学习 web 知识是通过阅读其他 web 站点的源码，这个方法已经过时了，[我几个月前写了这篇文章](https://christianheilmann.com/2018/07/09/different-views-on-view-source/)。

现在是时候开始在更成熟的层面上处理这个问题，而不是每隔几个月就重复同样的抱怨了。

> HTML 一直都是一个编译目标。“手写 HTML” 的玩法仅仅适用于一小部分吵闹的爱好者。

我是那些吵闹的爱好者中的一员，至今我已经写了 14 年博客了。我热爱这个对所有人都开放的 web 世界。你只需要一个编辑器，一些（工具的）使用文档就可以在 web 世界上发布你的作品。

## 手写的 HTML 是稀有品，它应该是收藏品

大约20年前，当我开始成为一名 web 开发者的时候，（用工具编译 HTML）并不是人们的工作方式。那个时候没有什么特别大的 web 产品被创造出来——事实上，一个职位需求中没有要求“手写 HTML/CSS/JS 的能力“都是很反常的。那时关注 HTML 规范化的是一个精英汇聚、兴趣浓厚的团体。如果你可以让 web 世界变得更加清晰，更加语义化，那么你就是一个很棒的人。但是我们到底要改变什么呢？

web 世界的大部分都是基于除了 HTML 以外的其他技术：

*   服务端基础（记得 .shtml 页面吗）
*   CGI/Perl 模版引擎
*   用内容管理系统和我们自定义的模版语言来生成 HTML
*   用来生成一些类似于 HTML 的 WYSIWYG（所见即所得）编辑器
*   模版语言，例如 PHP、ColdFusion、Template Toolkit、ASP 以及其它
*   在线编辑器和页面生成器，例如 Geocities
*   论坛和博客编辑器有时拥有自己的语言（还记得 BBCode 吗？）（译者注：BBCode 是一类标记语言，类似于 Markdown。wiki：https://zh.wikipedia.org/wiki/BBCode）

这些技术没有一件是在 web 上发布产品所必需的。但在我工作过的一些大型公司中，他们的内容管理系统是及其复杂和庞大的，但人们却选择用它。因为它提供了一个更简单、更明确、更清晰的 web 内容发布途径。他们解决的是开发人员和产品经理之间的问题, 而不是最终用户体验。Geocities 及类似的服务让人们在网络上发布作品更加容易，因为这些服务使得人们甚至不需要编写任何代码。

> 你在浏览器里看到的几乎不会是源代码。如果你想去提高代码质量，你需要去追溯到代码的源头。

即使我们选择看网页的源代码，那也不是某个人写的代码，而是由服务端代码处理各种数据甚至是优化后返回给浏览器的代码。

这样做是有其道理的。有很多不同的公共组件允许人们同时使用它们。一般情况下，你的网站导航是全球性的，甚至是由其他部门或公司编写和维护的。你甚至无法修改 HTML，如果幸运的话，你可以解决网站 CSS 的一些问题。

## HTML 是一个编译目标

我们回到现在。HTML 并不是一个很酷的东西，各类模版语言（例如 Markdown Pug、Jade 以及其它）层出不穷。这些模版语言都希望能让我们从 HTML 在不同环境下的可靠性和兼容性问题中解脱出来。

> HTML 有一个在某处可用，却不能确保其它地方可用的坏名声。比起只能确保兼容老旧技术的框架，一个能提供更强功能且与时俱进的框架会更加令人兴奋。

web 世界不应该受到我们的控制，但是我们需要去满足用户的需求。对于他们来说，在规定时间内给出了被需求的接口才是他们的任务。我们应该改变这个现状！

HTML 看起来不是我们所需要担心的东西——它在一个容错率高的环境中运行。它通常被看作是更好地利用你的时间来学习更高的抽象。人们不希望建立一个单纯意义上的网站，而是想构建一个应用程序。尽管大多数情况下，他们并不需要一个应用。我们在保证 HTML 的趣味性上犯错误了。我们希望网络能给我们更多的功能，让其可以与手机上的原生代码并驾齐驱。但这总是导致我们的应用有更高的复杂度。[构建可扩展 web 的宣言](https://extensiblewebmanifesto.org/) 基本证明了网络上的发布者需要有比实体的作家或出版商更多的开发者思维。我们想要控制，我们想要负责。现在我们是这样做了。

这样做让我们剩下了什么？首先，我们需要去兼容现在 web 世界中现有的由服务器处理过的代码。查看最终结果、感叹其代码质量是没有意义的。没有人写过这些代码，意味着它是不可读的。

我不会放弃语义化 HTML 及其优点，但我明白，我们不会通过告诉开发者他们的产品是可怕的来说服他们。我们需要与框架开发人员合作，这些开发人员是组件的创建者。我们需要帮助模板源代码，这些模板源代码是框架渲染器。我们需要确保转换阶段产生良好的 HTML 代码——而不是简单的 HTML。

同时我们需要和工具开发者合作来确保人们了解语义化的价值。集成在编辑器内的代码 Lint 和自动化有很大的发展潜力。现在我们有了更多的工具可供选择，以确保开发人员做正确的事情，而不必考虑它。我喜欢这个主意，它让我们从源头上解决问题，而不是抱怨症状。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
