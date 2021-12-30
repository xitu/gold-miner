> * 原文地址：[Designing for the web ought to mean making HTML and CSS](https://m.signalvnoise.com/designing-for-the-web-ought-to-mean-making-html-and-css/)
> * 原文作者：[DHH](https://m.signalvnoise.com/author/dhh/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/designing-for-the-web-ought-to-mean-making-html-and-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/designing-for-the-web-ought-to-mean-making-html-and-css.md)
> * 译者：[jerryOnlyZRJ](https://github.com/jerryOnlyZRJ)
> * 校对者：[sunui](https://github.com/sunui)，[acev](https://github.com/acev-online)

# 设计一个页面原则上应该指的是编写 HTML 和 CSS

在 90 年代后期的互联网泡沫期间，我做了一堆 Photoshop 切图工作。如你所知，设计师将 PSD 文件切片后交给切图仔拼接到 HTML 上，这很悲惨。

这些 mock 式的设计总是专注于像素的完美契合，但这却逐渐歪曲和偏离了 web 的本质。间隔像素，还记得吗？我们制作网页的原材料，特别是 HTML，到后来的 CSS，都在做着他们本不该做的事情。

后来很幸运的是我能与真正了解 HTML 和 CSS 的设计师合作。这启示了我，不仅让我感觉设计**是网页的一部分**，而不是**一味的堆叠**，给我的体验始终更好。我们更少地关注它的呈现，更多专注它的作用。

我认为这在很大程度上归功于它是真实的。设计与真实 HTML/CSS 代码协作的反馈回路，因为它注定之后要被部署，为设计师提供来自现实世界的反馈来使其更好。而设计师有能力自己完成工作这一事实将会使反馈的回路更短。如果没有做出改变，就会要求其他人实施改变，思考其有效性，然后不断重复这一过程，这就是改变、检查、改变、往复循环的流程。

有一段时间，我感觉这几乎是常态。局限于 Photoshop 模拟图像的网页设计师变得越来越罕见，他们在使用他们的资源方面变得越来越好。

但正如[巨大的隔阂](https://css-tricks.com/the-great-divide/)一文中指出的那样，退化却始终潜伏着，因为对于设计师这个行业而言直接去编写与 web 相关的工作是很困难的，某些需要使用 JavaScript 的才能实现的想法已经吓跑了一些设计师，这听起来就是一个讽刺。 

在 Basecamp，网页设计师都会编写 HTML、CSS 以及必要的 JavaScript 和 Rails 代码！这意味着他们可以完全独立地在真正的应用程序里复现他们的设计理念！很多时候，JavaScript 和 Rails 代码在与程序员进行简短的咨询后都可以直接上线。

其他时候编程工作涉及更多，专职程序员将与其结对完成要上线的功能。我没法用言语形容与知道页面设计有哪些限制的设计师合作有多么愉快，并且我们可以做完比起任何一个人更多的工作。当你在基本面上重叠时，你会更频繁地在同一页面上。（虽然我们仍然交易让步！）

我们有可能找到这样优秀的独角兽设计师吗？也许，我猜？比如谁呢？斯科特、JZ 、康纳、乔纳斯、瑞安和杰森通过在工作中不断的投入，在今天都成长为了这样的设计师。不要被他人的轻视或者像“这对他们来说太难了”的废话影响。

如今这个问题也与**我们**如何制作网页有关。Basecamp 是著名的，也可以说不太出名的一家，这主要取决于你问的是谁，那是一家不愿意迎接重量级 SPA 的复杂新世界大门的公司。我们使用 [服务器端渲染](https://rubyonrails.org/)，并使用 [Turbolinks](https://github.com/turbolinks/turbolinks) 和 [Stimulus](https://stimulusjs.org) 构建。设计师采用的所有工具都是容易上手和且实际的，因为设计师主要关注的是 HTML 和 CSS，以及一些用于交互的 JavaScript。

它并不像是一个秘密！实际上，我们在 Basecamp 开发的允许设计人员以这种方式工作的框架都已经开源。虽然现在对设计师而言，JavaScript 的环境并不友好，甚至像是一场人为的灾难，但也仍然可以做出不同的选择并达到不同的设计。

有一件事是肯定的：我不会回到过去！不要回到设计师的黑暗时代，他们无法使自己的设计独立工作，无法直接改变，也无法将它们部署上线！

我同样不感兴趣的是回到你需要一个由极少人组成的专家团队来完成任何工作的想法。那种“全栈”在某种程度上是一种讽刺而不是使设计师自给自足。设计师对他们的创造力的概念要求负担过重，他们应该被鼓励去学习如何在使用网站开发的原材料（HTML、CSS 和 JS）去呈现自己的想法。全栈那样的想法就不用了，谢谢！

设计一款现代化的网页，通过令人愉快的设计取悦用户，这并不是难以理解的复杂迷宫。我们正是这样做的！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
