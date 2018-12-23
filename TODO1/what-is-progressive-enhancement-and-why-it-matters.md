
> * 原文地址：[What is Progressive Enhancement, and why it matters](https://medium.freecodecamp.org/what-is-progressive-enhancement-and-why-it-matters-e80c7aaf834a)
> * 原文作者：[Praveen Dubey](https://medium.freecodecamp.org/@edubey?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-progressive-enhancement-and-why-it-matters.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-progressive-enhancement-and-why-it-matters.md)
> * 译者：[RicardoCao-Biker](https://github.com/RicardoCao-Biker)
> * 校对者：

# 渐进增强的含义及意义

![](https://cdn-images-1.medium.com/max/2000/0*cs42aEkypTZorYk6)

Photo by [Émile Perron](https://unsplash.com/@emilep) on [Unsplash](https://unsplash.com)

渐进增强（PE）是一个在开发网页应用中十分有效的方法。

这里是官方定义:

> **渐进增强** 是一种网页设计策略，强调首先满足核心网页内容。 然后如果用户的浏览器/互联网连接允许，该策略逐渐在核心内容之上添加更多对浏览器技术支持有更高要求的渲染效果。- 维基百科

这个策略的优点是它允许所有人使用任何浏览器和网络连接能够访问到网页的基础内容和功能，也同时也为高版本和高带宽的用户提供一个增强版本的网页。

简而言之…

…它为我们提供了基本的用户体验，即使在兼容性不同的浏览器中也保证了网页的稳定运行。

​```
let PE = "Progressive Enhancement";
​```

渐进增强策略由以下几个 [核心原则](http://www.wikiwand.com/en/Progressive_enhancement)组成:

*   基本的 **网页内容** 应该能被 **所有的浏览器**访问
*   基本的 **网页功能** 应该能在 **所有的浏览器**中运行
*   稀疏语义标记包含所有内容
*   增强的网页布局由外部引用的css提供
*   增强的网页行为有外部引用的JavaScript提供
*   尊重用户使用的浏览器首选项

所以当你在使用下一代只在 **合适的环境** 下正常工作的JavaScript/CSS框架构建你的下个网站时，这些代码在环境不满足时可能不会工作…. 这并不是一个渐进增强的策略。

相反，在引入更复杂的代码前，我们的开发目标应该是从提供基本功能、稳定的设备兼容性、和无卡顿的体验开始。

### 渐进增强案例

让我们一起来看看一些渐进增强策略的案例是如何运行的。

#### 网页字体

网页字体十分漂亮，但是当用户的网络环境较差时，用户体验一定是受到影响的。在这种情况下，系统字体应该作为渲染网页内容的储备，并且当网页加载时应该能将系统字体用作网页字体。

有内容总比等待加载网页字体或什么也不显示要好得多。

#### 初始化HTML

网页加载脚本，可以是Angular、React或其他框架。当这些脚本负责网页内容的初始渲染时，在低速网络下如果脚本发生错误你的用户可能会在浏览器中看到空白页面。

想一想，初始加载使用HTML渲染总是会比完全依赖脚本来渲染页面有更好的用户体验，而不是等待脚本加载完成。

#### 功能检查

好的网站总是会做这个部分，当使用一个可能不会被其他设备、浏览器支持的功能时，总是在JavaScript中使用它前确保该功能是在指定浏览器中可用的。

[Modernizr](https://modernizr.com/) 是一个受欢迎的功能检测库，也许能帮到你。

你可以在脚本不被指定浏览器、设备支持时加载额外的脚本去支持兼容，这样你可以避免在不必要的时候也加载额外的脚本。

### 现在，为何选择渐进增强？

在构建下一个应用程序之前关注渐进增强策略的重要原因：

#### 坚实的基础

渐进增强关注在你项目的开始阶段在引入更高级的更复杂的功能前使用基础的web技术。所以在任何的情况下你都有支持保证更复杂功能运行的基础。

一旦团队对网站的核心体验已经很有自信，并且在不依赖网速、浏览器、设备时也能运行，这时你就可以开始引入更加复杂的功能和布局。

#### 稳定性

`测试团队` : “ 搜索图标在Safari的offres页面失效 ”

`开发团队` : “ 在我的电脑上可以啊，清缓存再试一下，不行就没办法了”

`测试团队` (来自天堂) : “ 还是不行，你是在Chrome上看的吧，Safari上是不行的”

`开发团队` : “ 我们什么时候开始兼容Safari了 ? 等等…. 修复中………”

​```
if(getBrowsers() == 'safari') {
Patch.magicHelpers.searchIconMagic()
}

Patch.magicHelpers = {
searchIconMagic: function() {
// Can't share magic, doing something
   }
};
​```

“一个小时后…… 在检查一下看看”.

`测试团队`: “ 在Chrome和Safari中可以了，但是Mozilla FireFox中又不行了...啊啊啊 !!!!!”

承认吧，我们都至少经历过这种情况不止一次吧。

项目的稳定性和维护成本也取决于项目是如何开始的。使用框架来配置项目并在后面不停修复可能不是长久之计。

渐进增强策略可以帮你构建一个更有健壮基础的项目，你的HTML，CSS和JS都是可以支持回退的。他们可以保证你不会严重的依赖浏览器的特定功能。

#### **SEO 和可访问性**

每个人都希望自己的应用被列在搜索引擎列表的第一页，但是这需要我们持续的努力提供优秀的应用。你的项目中的健壮的基础保证了你的应用专注于内容优先的方法。

使用渐进增强策略的网页可以保证**基础内容** 能够 **总是** 被搜索引擎的爬虫爬取到并添加到索引。避免任何可能阻碍爬虫抓取网页内容的动态加载。

渐进式Web应用(PWA)无论在任何浏览器中都可以使用所有的用户，因为他们是使用渐进增强原则构建的。

### **总结思考**

渐进增强策略专注于为你的项目提供健壮的基础，这个基础可以在你的产品在长期的计划中提供巨大帮助。

在你的新项目中使用新的JavaScript/CSS框架可能是很容易的，但是那可能会让你去优雅降级。你会不断的修复你的代码以支持那些不支持框架的浏览器和设备。

尽管渐进增强策略也许在项目开始阶段会占用你更多的一点时间，但是它可以保证在最坏的情况下也可以提供最基本的功能。在严重依赖JavaScript实现用户界面展示的情况下可能不适用渐进增强策略，但是对于一个长期的项目，考虑一下渐进增强是值得考虑的。

希望这篇文章能为你提供一些对渐进增强的概略的了解。

更多的关于渐进增强的文章：

- [**Designing with Progressive Enhancement: Building the Web that Works for Everyone**: Progressive enhancement is an approach to web development that aims to deliver the best possible experience to the...](https://www.oreilly.com/library/view/designing-with-progressive/9780321659477/ "https://www.oreilly.com/library/view/designing-with-progressive/9780321659477/")

- [**Unboring.net | Workflow: Applying Progressive Enhancement on a WebVR project**: How I made an interactive content to be embedded on weather.com](https://unboring.net/workflows/progressive-enhancement/ "https://unboring.net/workflows/progressive-enhancement/")

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
