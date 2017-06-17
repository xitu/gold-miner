> * 原文地址：[Designing Design System for Complex Products](https://uxdesign.cc/designing-design-system-for-complex-products-5ff2d3051fa1)
> * 原文作者：[Wen Wang](https://uxdesign.cc/@wenwang)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Changkun Ou](https://github.com/changkun/)
> * 校对者：[horizon13th](https://github.com/horizon13th), [osirism](https://github.com/osirism)

# 为复杂产品制定设计规范 #

## 设计规范的好处及构建方法 ##

> 译者注：本文部分术语有意译，具体为：设计规范（design system）、设计准则（design guidelines）、风格指南（style guide）、实时风格指南（live style guides）、实时库（live library）。
>

![](https://cdn-images-1.medium.com/max/2000/1*Foh-OxZWLDg_WjojpavgaA.png)

> Bypass 的设计规范理念

在我的上一篇文章 **『[如何从设计规范起步](https://medium.com/@wenwang/how-to-get-a-head-start-on-design-system-8a217676c1f9#.v42j4b53c)』** 中，我谈到了当我缺少资源时如何开始构建简单的风格指南。这次我将分享更多关于构建复杂产品设计规范（如 SaaS Web 应用）的知识。在文章的最后，我还会分享一些有用的资源。

### 我们为什么开始 ###

回到 2014 年初，我刚加入 Bypass 时，由于我们的产品非常复杂，出现了大量风格不一致的情况。有不同的按钮、不同的输入框、相同的元素不同的布局、相同的流程不同的交互。我们浪费了很多时间来辩论设计的细节，只是因为我们的产品没有固定的规则。这些不一致也给我们的用户带来了糟糕的体验：他们为此感到困惑，从而难以理解并学习这个产品。

在开发方面，由于代码库里已有的样式过多，总是很难找到「对应的代码」。这种情况下，很多时候开发者不是复用原先的旧代码，而是写下新的代码，从而导致更多的不一致性。这是一个恶性循环，随着时间的推移，我们的团队也越来越大，沟通和产品交付也变得越发的难以把控。

### 我们面临的问题 ###

**1. 五十度灰:** 由于我们的产品非常复杂，总是难以保持一致。系统中有许多界面风格不一致的地方，包括不同的颜色、字体、字体大小等等。

**2. 规则的匮乏:** 当我们的设计师正在构建一个新功能时，我们就很容易深陷细节困境。甚至连一些简单的问题诸如「我应该使用哪个组件？」和「我们应该引导用户进入新的页面，还是弹出对话框呢？」这样的问题都需要花费很多时间来进行决策。

**3. 交付质量差:** 由于缺乏设计规则，不同的团队互相沟通是非常困难的。我曾经为了向开发者展示竟可能多的细节，会在设计稿中标注很多带有详细描述的参考「红线」。然而这并不是一种有效的手段，有时开发者并没有遵循我所有的设计细节。

想象一下，你的团队上线了一个新的项目而且其他所有人都在庆祝，但是你却看到了一大堆设计错误。你必须保持和其他人一样开心，是还是不是？

![](https://cdn-images-1.medium.com/max/800/1*jSQ79eaoZwXK1PfAneOoSw.gif)

> 「开心的你」

**4. 不一致的代码库:** 由于没有制定规则，有时候开发者们在一个新项目中只会直接复用基础代码库中已实现的相似代码；而有时候，他们却会去实现一个风格完全不同的全新组件，这进一步使代码复杂化了。

**5. 用户困惑:** 我们的用户需要一条有逻辑的路径来学习产品的使用并构建关于它的心理模型。然而我们做出的这些不一致性会让他们在得不到预期反馈时感到困惑并且沮丧。

### 如何构建一个设计规范 ###

#### 1.从设计准则开始 ###

风格指南是设计规范的基础设施，要了解更多关于它的细节，可以参考我之前的文章 **『[如何从设计规范起步](https://medium.com/@wenwang/how-to-get-a-head-start-on-design-system-8a217676c1f9#.tf4xqdc8e)』** 。

#### *可选项: 构建一个实时库 ###

![](https://cdn-images-1.medium.com/max/800/1*Yiyf4mk5mkfcqPWrgYi_VQ.png)

> Lightining 设计规范

如果你有一个做前端的朋友，或者你可以自己写代码，一个实时库可以让每个人的生活变得更加轻松。它是一个高效的让前端开发者避免错误、加快开发过程并保持一致的工具。[Lightning Design](https://www.lightningdesignsystem.com/) 的设计规范和 [Angular material](https://material.angularjs.org/latest/) 都是非常好的实时库例子。

给你自己找一个关心设计细节的**前端朋友**。然后再和他/她讨论风格指南里的组件，并找到最好的方法来构建他们。有时候他们会冒出一些你从未考虑过的惊人的想法，因此聆听你朋友的想法，然后记录每个组件的代码，并确保开发人员可以轻松地了解和复用他们。

![](https://cdn-images-1.medium.com/max/800/1*PMfV38WM5jb3GXHoI_WrSQ.gif)

> 发现那些关心 CSS 的开发者 #uxreactions via [@uxreactions](http://twitter.com/uxreactions)

#### 2. 从风格指南到设计规范 ####

![](https://cdn-images-1.medium.com/max/800/1*NNNOKwfGHTy_AenCXzLLEA.png)

> iOS 设计准则

在构建风格指南的过程中，你还会获得关于这个产品的更多知识。风格指南完成后，你可以继续收入准则、原则和规则。

你可以记录一些非常详细的规则。例如你可以有一个章节专门介绍「**如何删除一个对象**」，在这里介绍「**编辑对象、触发编辑面板、删除对象、弹出确认对话框、确认删除对象、使用『对象已删除』作为返回后的索引**」。

![](https://cdn-images-1.medium.com/max/800/1*bj_72i4q0C_126MFFsAm6Q.png)

你还可以为每个设计模式添加「应该」和「不应该」的例子。它将帮助人们清楚地了解如何复用这些组件。并且你还可以在哪种情况下描述哪种条件设计师应该使用哪种设计模式。


### 拥有设计规范的优势 ###

#### 产品人员的有效工具 ####

设计规范是帮助设计师顺利流畅运作「厨房」的食谱。使用相同的购置食材，设计师可以持续向客户提供优秀的「佳肴」。设计师可以在这个设计规范的库中找到什么原料，以及它们应该搭配什么样的时间和地点进行使用。同时它也是一个非常好的交接工具，以确保大家想法一致。

#### 开发人员的有效工具 ####

一个具有全局组件的实时库能够加快开发过程。它允许开发者能复制和粘贴代码，并让他们的工作更加简单、高效并减少错误。每个开发者也可以为这个库做贡献，使其成为一个「不断进化的规范」。

#### **平滑的交接工具** ####

随着公司的发展，合作和转换工作变得越来越难。通过设计规范，交接变得更加容易和平滑。有三类人可以从中获益。

**对于 QA 人员来说，**他们知道要测试什么，以及交付是否符合设计规则。对于**设计师**来说，全局交互上已经无可争辩了。此外，设计师可以在其他设计师的设计文件上工作，且不会有任何混淆。对于**开发者**而言，他们可以清楚的理解设计文件，并以正确的方式构建他们。

#### 质量交付，一致的界面及期望 ####

由于一致的组件和设计规则，我们获得了高质量且全面的结果。对于我们的用户来说，他们更加容易学习及操作。现在他们可以很容易的学习这个规范，并且每次都能够获得预期的反馈。

### 当设计规范实现后 ###

给生活带来一个伟大的设计规范就像是这样：

![](https://cdn-images-1.medium.com/max/800/1*3g_2gFQcimSuR_pHRN_OdA.gif)

>  **重新设计一个旧的应用程序** #uxreactions via [@uxreactions](http://twitter.com/uxreactions)

而且你公司里的每个人大抵都是这种状态：

![](https://cdn-images-1.medium.com/max/800/1*stS5w9PQ4ibBRSsDVPyfDA.gif)

### 风格指南的资源和工具 ###

以下是我用于构建我们的设计规范时的资源和工具列表，它们对初学者都非常有帮助。

感谢 @[Ignacio Giri](https://medium.com/@nacho?source=post_header_lockup) 对我上一篇关于风格规范工具文章中的评论。考虑不同的用法，我还将附上一些 CMS 工具。如果你具备任何配置和前端知识，这些工具可以帮助你和你的团队非常简单地构建实时库。

#### CMS 工具集 ####

**[1]**[**Github**](https://github.com/)

Github 是一个来管理实时风格指南的开发者友好的工具。这里有一些非常有帮助的文章讨论了如何使用 GitHub 来管理风格指南：[Shyp 的设计指南的管理](https://medium.com/shyp-design/managing-style-guides-at-shyp-c217116c8126#.kvncovr64)

**[2]**[**Statamic**](https://statamic.com/)

Statamic 是一个强大的可以由设计师和开发人员使用的工具。一旦你安装并学习了使用它的正确方法，你就可以快速建立一个实时库。对于你和你的团队来说它的版本控制能力也非常强大。

**[3]**[**Cloudcannon**](http://cloudcannon.com/)

如果你知道如何使用 HTML, JavaScript, CSS 及任何静态内容，Cloudcannon 就是一个能够帮助你去做正确的事情的工具。它与你在 Squarespace 中定制你的个人网站类似，对于同时负责同时显示海量内容的代理设计师来说，它尤其强大。

#### 无需编码经验的工具集 ####

1 [**Craft**](https://www.invisionapp.com/craft)

Craft 是一个 Sketch 插件，可以帮助设计师们通过云端的设计库进行合作。设计师们可以通过它互相配合来构建风格指南以及组件符号库。

2 [**frontify.com**](https://frontify.com/)

Frontify 是一个在线样式指南文档工具。它对初学者非常友好。

3 [**Confluence**](https://www.atlassian.com/software/confluence) 是一个团队文档工具，通常用于记录产品的所有内容，包括设计原则、规则等等。

### 设计规范的例子 ###

#### [Material Design](https://material.io/guidelines/) ####

这是 Google 公布的著名的设计规范，它包括介绍、风格、动作、布局、组件、模式、成长和沟通、可用性和资源。如果你希望以 Google 的 Material Design 样式创建产品、或者你的团队正在使用任何 Material Design 的设计框架，那么这会非常有用。

Material Design 的设计规范没有包含任何代码库，但却有一些基于 Material Design 建立的第三方资源。比如：[Angular Material](https://material.angularjs.org/latest/), [Material Design Lite](https://getmdl.io/), [Material for Bootstrap](http://fezvrasta.github.io/bootstrap-material-design/) 和 [Material UI](http://www.material-ui.com/#/).

#### [Lightning Design](https://lightningdesignsystem.com/) ####

Lightning Design 是为 Saleforce SaaS 产品而建立的一套设计规范。它包含了指南、组件、设计口令、图标和相关资源。设计人员可以将组件名称放在设计交付上，然后开发人员便能轻松正确地构建组件。

例如，如果设计师说：「我想要对这个卡片施加一个阴影效果」。那么草图中卡片的参数就会是 `0px 2px 2px 0px rgba(0,0,0,.16)`。 他们可以将实物模型的类命名为 `$elevation-shadow-2`，这就可以帮助开发人员构建设计师真正想要的卡片。

#### 其他例子: ####

[iOS 人机界面指南](https://developer.apple.com/ios/human-interface-guidelines/overview/design-principles/)

[IBM 设计语言](http://www.ibm.com/design/language/)

[Styleguide.io](http://styleguides.io/) (你可以在这个网站里找到大量的例子)

[风格指南的灵感来源](https://medium.muz.li/style-guide-inspirations-dfb77c4bb13b#.kez5ifoif) by *Muzli*

### 相关文章 ###

[这些毋庸置疑的最炫酷的 Sketch 技巧](https://medium.com/ux-power-tools/this-is-without-a-doubt-the-coolest-sketch-technique-youll-see-all-day-ddefa65ea959#.2b1ax4tjx) *by Jon Moore*

[Shyp 的设计指南的管理](https://medium.com/shyp-design/managing-style-guides-at-shyp-c217116c8126#.kvncovr64) *by Micah Sivitz*

[构建视觉语言](http://airbnb.design/building-a-visual-language/) *by Airbnb design team*

[我们如何在 GoCardless 设计团队中使风格指南保持最新 ](https://medium.com/gocardless-design/design-style-guide-post-b48b546f928#.4z4aptcdx)*by Sam Wills*

[设计规范中的动画](https://24ways.org/2016/animation-in-design-systems/) *by Sarah Drasner*

感谢你的阅读！

如果你喜欢我的文章，欢迎给我打个❤️ :)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
