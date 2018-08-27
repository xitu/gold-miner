> * 原文地址：[Can Email Be Responsive?](http://alistapart.com/article/can-email-be-responsive)
* 原文作者：[Jason Rodriguez](http://alistapart.com/author/JasonRodriguez)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Hyuni](http://hyuni.cn/)
* 校对者：[phxnirvana](https://github.com/phxnirvana)，[Tina92](https://github.com/Tina92)

# 响应式邮件设计

无论你是否喜欢，HTML 邮件的人气是不可否认的。就像网页一样，收件箱开始走向移动化，[有一半以上的邮件](https://litmus.com/blog/email-client-market-share-where-people-opened-in-2013) 是在移动设备上打开。

# 翻译版本

- [意大利语](http://italianalistapart.com/articoli/112-numero-95-29-luglio-2014/472-email-puo-essere-responsive)

[![](//assets.servedby-buysellads.com/p/manage/asset/id/32683)Brief books for people who make websites. Ad via BuySellAds](//srv.buysellads.com/ads/click/x/GTND423YCTSD4KJYCAA4YKQWFTYDK23JCVBICZ3JCEADT2J7CK7DL23KC6BDEK3NCTYDEK3EHJNCLSIZ)

现在的邮件依然设计的很过时。还记得在 Web 标准成为……标准之前的编码时光吗？欢迎来到邮件设计地狱。

但是编写一个邮件还没有那么多的挫折。现在的邮件设计者仍在使用 HTML 属性，先让我喘口气，内联样式，众多先驱设计者们却已开始在古老的电子邮件设计上使用 web 前沿技术。

受到由 Ethan Marcotte 首次撰写的基于 [响应式网页设计](http://alistapart.com/article/responsive-web-design/) 原理的开发的启发，一场逐步逼近现代网页的电子邮件设计革命开始了。订阅者不会再遇到糟糕的阅读体验，难以触摸的目标，和小小的字体。

## 网页邮箱的价值

无论你是否喜欢网页邮箱，它在几乎所有行业里都是非常重要的工具。在营销方面，电子邮件一贯 [优于](http://www.wired.com/business/2013/07/email-crushing-twitter-facebook/) 其他方式，比如 Facebook 和 Twitter 。更重要的是，电子邮件提供越来越 [个性化的方式](http://blog.mailchimp.com/paul-jarvis-likes-trading-stories-with-people/) 使 [大量的潜在用户](http://blog.getvero.com/email-marketing-statistics/) 互相影响。

你可能对电子邮件广告不太积极，碰巧的是，作为一名 Web 设计师或者开发人员，你会使用电子邮件与你的用户定期沟通。可能是发一条回执，或者公告新的产品功能给用户，或者通知他们你最新发的的博文。无论什么原因，电子邮件都是一种重要和经常被忽略的媒介。

许多开发者给顾客发送纯文本格式的邮件。尽管纯文本格式有许多优点（方便写，兼容性强，下载快等等），但是 HTML 格式的电子邮件也有许多优势：

- 超链接。你可以通过邮件中链接到外部页面来进行更多交互。
- 设计。即使是在收件箱中，一个设计良好的 HTML 邮件能让你突出你的品牌。
- 层次结构。在 HTML 邮件中你可以使你的邮件主从分明，让人更容易注意到重要副本或者重要连接。
- 跟踪。HTML 邮件允许你去追踪邮件是否被打开和约会接受情况，这些有价值的数据可以用来优化你的营销效率。

如果不像设计精良的 APP 一样要求你的邮件，你就会失去 1) 树立品牌形象的机会 2) 追踪邮件是否被打开与用户行为的能力的机会 3) 在你的应用之外给用户一份极好的用户体验的机会

## HTML 邮件很糟糕

传统上，对于网页设计师来说，设计和开发 HTML 邮件有着最坏的体验。就像乘坐时光机返回充满表格布局，内联样式，非语义标签，和客户端 hack 技巧的地狱般的 90 年代。

这只是一小部分 HTML 邮件痛苦的原因：

- 没有标准。当然，我们使用 HTML 和 CSS，但不像网页，邮件客户端没有真正的标准存在，这是一些杂乱的代码存在的原因。
- 邮件客户端。邮件客户端，比如 Outlook 和 Gmail，经常以不同的方式渲染 HTML 和 CSS，而且总是这么离谱。从而导致……
- 许多 hack。即使是设计良好的邮件广告也需要针对不同的客户端 hack 来保证质量。
- 没有 JavaScript。电子邮件中 web 中最受欢迎的语言在电子邮件丝毫没有地位，因为电子邮件客户端会（正当地）出于安全因素而禁用它。这样就没有交互性了。
- 内联样式。我更喜欢使用单独的结构进行描述。不幸的是，大部分邮件客户端强制你依赖内联样式和属性去做邮件中近乎所有的事。

当一切趋于稳定时，在电子邮件设计社区（是的，确实 **有** 一个）中开始有关于减轻开发电子邮件促销广告的痛苦的动向。许多公司与个人开发者开始优化电子邮件设计的工具与方法，并且开始更多的分享他们的见解。

我所在的公司，[Litmus](http://litmus.com)，就是其中一个。我们构建了测试与跟踪电子邮件活动的工具。我们都收到了电子邮件营销，尤其是电子邮件设计的影响。我们甚至专门创建了一个 [社区](http://litmus.com/email-community) 来聚集这些邮件营销人员，给他们提供一个分享知识，提高技能，互相学习的平台。

虽然我在本文中提及了一些 Litmus 的工具和资源，但还有许多公司与个人在努力提高电子邮件设计的艺术。尤其是，[MailChimp](http://mailchimp.com) 和 [Campaign Monitor](http://campaignmonitor.com) 都有非常出色的 blog 和说明。还有像 [Anna Yeaman](https://twitter.com/stylecampaign)、[Nicole Merlin](https://twitter.com/moonstrips)、[Fabio Carneiro](https://twitter.com/flcarneiro)、[Elliot Ross](https://twitter.com/iamelliot) 和 [Brian Graves](https://twitter.com/briangraves) 这样的人都在致力于使电子邮件设计成为一门真正的工艺。

## 进化的收件箱

就像Web的其他部分一样，收件箱也开始走向移动化。在2013年，[51%的用户在移动设备上打开邮件](https://litmus.com/blog/email-client-market-share-where-people-opened-in-2013)。而且还考虑到 [越来越多人](http://blogs.hbr.org/2013/05/the-rise-of-the-mobile-only-us/) 使用移动设备来连接互联网，无论出于爱好与习性，这一数字还在持续增长。

好消息是，Web 设计人员现有的创造一个对大多数用户所重视的良好的用户体验的技能也适用于邮件广告，这也是被许多设计者忽略的。

## HTML邮件的原理是什么

通常来讲，假设 web 设计与 [遵循Web标准的设计](http://en.wikipedia.org/wiki/Designing_with_Web_Standards) 无关，那么 HTML 邮件与网页设计很类似。HTML 邮件基于三样东西：表格，HTML 属性，内联样式。在你学习写 HTML 邮件的时候要知道。由于电子邮件客户端渲染引擎的限制，我们只能使用 HTML 与 CSS 中非常有限的一部分子集。Campaign Monitor 在维护一份有关大多数主流邮件客户端所支持的 CSS 属性的 [非常好的图表](http://www.campaignmonitor.com/css/)。

在我们讲如何构建自适应的邮件前我们先回顾一下 HTML 邮件的基础。举个例子，我曾改编过我们在 Litmus 中通讯用的邮件模板。多亏了 Litmus 和我们出色的设计师 [Kevin Mandeville](http://dribbble.com/KEVINgotbounce)，A List Apart 的读者们可以学习并且使用我们在许多电子邮件广告中使用的代码，这些现在都在 [A List Apart 的 Github 账号](https://github.com/alistapart/salted) 上。你可以查看 [Litmus tests](https://litmus.com/pub/d5586ad/screenshots) 的全部示例来看他在跨客户端中的表现。

### 表格

许多 Web 开发者喜欢使用 **div**、**header**、**section**、**article**、**nav** 和 **footer** 这样的标签来构建 Web 页面的架构。不幸的是，电子邮件开发者没有闲工夫去使用语义化标签。相反，你**必须**使用表格来给你的电子邮件布局。这些表格会嵌套的非常……深。

设置表格的基本样式会用到许多人平常不会用到的属性：**width**、**height**、**bgcolor**、**align**、**cellpadding**、**cellspacing** 和 **border**。结合像 **padding**、**width**和 **max-width** 这样的属性，设计者可以构建出更健壮的邮件布局。

一个编码良好的表格示例在邮件中是看起来是这样的：

```
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td bgcolor="#333333">
			<div align="center" style="padding: 0px 15px 0px 15px;">
				<table border="0" cellpadding="0" cellspacing="0" width="500" class="wrapper">
					<tr>
						<td>…Content…</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
```

你可以看到我们如何嵌套表格并且使用 **border**、**cellpadding** 和 **cellspacing** 属性来确保设计中没有多余的空隙。在表格单元层中使用比 **background** 和 **background-color** 更可靠的 **bgcolor** 属性（尽管 **background-color** 也很有地位）。

有一个有趣的事情是，div 标签被用来剧中表格并且给内容提供内边距。虽然表格应该承担大部分的结构，但是偶尔使用 **div** 标签给内容定位，提供内边距和设置一些基本样式是非常实用的。无论如何，因为大多数邮件客户端解析盒子模型都有一些问题，所以在邮件中使用 div 构建主要架构会使邮件布局变得非常不可靠。

### 图片

在邮件中使用图片与在 Web 页面是使用图片非常类似，但是有一个警告：大多数邮件客户端默认禁用图片导致许多订阅者只能看到些无意义占位图。
![](http://alistapart.com/d/395/can-email-be-responsive/can-email-be-responsive-1.png)

图片被禁用的邮件

尽管没有办法自动显示那些图片，我们可以使用提示文字（ alt-text ）来改善一下现有情况。我们甚至可以通过给 **img** 标签设置内联样式来给提示文字设置样式来维持与原设置的相似外观。

```
<img src="img/fluid-images.jpg" width="240" height="130" style="display: block; color: #666666; font-family: Helvetica, arial, sans-serif; font-size: 13px; width: 240px; height: 130px;" alt="Fluid images" border="0" class="img-max">
```

通过使用上述代码可以使我们缺失的图片现在看起来有了一定意义:
![](http://alistapart.com/d/395/can-email-be-responsive/can-email-be-responsive-2.png)

提示文字还有待被普及

### 发起互动

HTML 邮件的主要优势之一就是可以使用超链接。HTML 邮件允许你使用又大又优美的按钮取缔传统的副本链接来吸引订阅者。

许多邮件营销人员使用图片作为链接按钮。然而，如果使用 [Bulletproof buttons](http://buttons.cm)，即使是在图片被禁用的情况下也可以允许设计人员通过代码来渲染出可靠的跨平台按钮。

下面是一个用纯 HTML 制作的按钮，这个按钮通过边框来确保整个按钮不光是文字，而是整个按钮都是可以点击的:

```
<table border="0" cellspacing="0" cellpadding="0" class="responsive-table">
	<tr>
		<td align="center"><a href="http://alistapart.com" target="_blank" style="font-size: 16px; font-family: Helvetica, Arial, sans-serif; font-weight: normal; color: #666666; text-decoration: none; background-color: #5D9CEC; border-top: 15px solid #5D9CEC; border-bottom: 15px solid #5D9CEC; border-left: 25px solid #5D9CEC; border-right: 25px solid #5D9CEC; border-radius: 3px; -webkit-border-radius: 3px; -moz-border-radius: 3px; display: inline-block;" class="mobile-button">Learn More →</a></td>
	</tr>
</table>
```

![](http://alistapart.com/d/395/can-email-be-responsive/can-email-be-responsive-3.png)

即使图片被禁用，Bulletproof buttons依旧表现良好。

一旦你掌握了这些基础，我们就可以继续了解如何让邮件在一系列不同的设备尺寸上依旧表现良好。

## 响应式邮件的原理是什么

与响应式网页一样，响应式邮件也有三大组件：弹性图片，弹性布局和媒体查询。

网页与邮件唯一不同的是这三种技术的实现方式。

在邮件设计中，我们只能使用 HTML 和 CSS 的一部分。我们不能依靠使用在响应式网页中的那些属性；margin，float和 em 在许多客户端上无效。所以我们必须另辟蹊径。

### 弹性布局图片

弹性布局图片不是最棘手的。虽然他们的 **width** 属性被设定为100%，除非高度和宽度使用相应的 HTML 属性定义，否则有些客户端可能在把图片渲染成预期大小时会有问题。因此，我们不得不先给他们设定成特定尺寸，之后才敲定具体尺寸。

第一步是确保使用健壮的代码来编码图片。让我们看一下早先在邮件中的图片的代码。

```
<img src="responsive-email.jpg" width="500" height="200" border="0" alt="Can an email really be responsive?" style="display: block; padding: 0; color: #666666; text-decoration: none; font-family: Helvetica, arial, sans-serif; font-size: 16px;" class="img-max">
```

注意到里面的 **display** 属性了吗? 就像 border 属性一样，那是也是应对淘气的邮件客户端的众多 hack 手段之一。许多电子邮件客户端给图片设置块级布局也可以消除那些空隙并完成你的布局。在图片周围增加空白来解决可能出现的行高问题。
现在，当我们想让我们的图片是弹性布局的时候，我们可以在邮件头部使用媒体查询:

```
img[class="img-max”] {
	width:100% !important;
	height: auto !important;
}
```

并不是每一个图片都需要是弹性布局。例如 logo 和社交网站的图标无论设备的大小如何都要保持相同的大小，这就是我们用类名来标记需要弹性布局图片的原因。

由于我们经常覆盖我们写的内联样式和 HTML 属性，所以使用 important 声明使文档渲染的时候确保我们的响应式样式会被优先表现。

现在让我们来跳到有点儿难度的地方吧。

### 弹性布局

大多数 Web 开发者都对使用 [相对单位](http://alistapart.com/article/fluidgrids) 来定义 [语义化标签](http://alistapart.com/article/semanticsinhtml5) 的大小来开发响应式布局很熟悉，例如百分数、ems、rems。虽然我们还是可以在电子邮件中使用百分比来进行弹性布局，但是他们在被内联使用时会在表格和其他一些元素上收到一些限制。

几乎所有的表格都会使用百分数来设置宽度。但是在那些处理百分数上效果不太好的客户端上有一个例外，尤其在大多数 Microsoft Outlook 的版本中，使用一个固定宽度的表格来做容器容纳所有的邮件内容以防止内容超出布局范围时效果不佳。

让我们从表格容器开始看起：

```
<table border="0" cellpadding="0" cellspacing="0" width="500" class="wrapper">
	<tr>
		<td>…Content…</td>
	</tr>
</table>
```

你看到我们使用 **width** 属性来强制使表格500像素宽。

这个表格容器可以容纳在 email 中的所有其他表格。因为容器会逼迫所有元素在500像素内显示，所以我们可以安全的在我们其他表格中使用百分比来设置大小。

但是弹性表格永远是500像素宽有什么好处呢？让我们再一次看一下容器表格。注意我使用的 **wrapper** 类。我们将会通过媒体查询使用这个类选择器使我们的邮件达到真正的响应式。

### 在电子邮件中使用媒体查询

在电子邮件中使用媒体查询与在网页设计中一样。你可以在电子邮件中的头部引用媒体查询，从而使你的样式针对不同的设备属性做出调整。

简单而言，我们将视窗（viewports）针对在 **max-width** 525像素及以下。然后针对那个容器表格，我们覆盖他们的 HTML 属性与内联样式来强制表格水平占满移动设备屏幕。

```
@media screen and (max-width:525px) {
	table[class=“wrapper”] 
		width:100% !important;
	}
}
```

我们也可以其他任何嵌套在内层的表格设置一样的效果来给内容节点布局以提升在移动设备上的体验。在移动设备上增加文字和按钮的大小也是个好主意。

```
@media screen and (max-width:525px) {
	body, table, td, a {
		font-size:16px !important;
	}	
	table[id=“responsive-table”] {
		width:100% !important;
	}
}
```

使用媒体查询的唯一缺点是媒体查询的兼容性并不太好。虽然像 iOS Mail 和 Android 默认客户端那样的基于 WebKit 渲染引擎的邮件客户端上没问题，但是在老旧的黑莓设备、Windows Phone 8 和所有平台的 Gmail 应用都会无视媒体查询。

幸运的是，iOS 和 Android  在移动邮件收发设备中 [占据了大多数](http://emailclientmarketshare.com)，所以大多数订阅者都可以按照你的设计看到你的响应式邮件。

### 探索电子邮件设计

上述的这些技巧都仅仅是入门。前卫的邮件开发者正在研究在邮件中使用 Web 字体，SVG，和 CSS3 动画。当然，邮件设计依旧十分困难而且常常违背预期，但是这不应该阻止你去探索更多能提高你和你的用户体验的技术。

我唯一的建议是非常严格地测试你的邮件。从渲染能力和对HTML/CSS的支持程度，邮件客户端还远不及浏览器。既要在真机测试，也要使用邮件预览服务测试。邮件预览服务例如 [Litmus](http://litmus.com)、[Email on Acid](http://emailonacid.com)，你自己的 [测试环境](http://stylecampaign.com/blog/2012/09/mobile-email-testing-rig/)，或者其他一些能在你发送给海量订阅者前帮助你找到并修复问题的工具。

非常严格的测试你编写的任意邮件，还要跟踪你的用户对 [哪种内容](http://mailchimp.com/resources/guides/how-to-create-an-email-marketing-plan/html/)、副本、设计和 [发送频率](http://www.campaignmonitor.com/guides/planning/qanda/) 的满意程度。

综上所述，别小看邮件设计。它现在很糟糕，但是会变得越来越好。一个关于邮件设计的 [社区终于建好了](https://litmus.com/community)，这方面的技术在逐渐提高。响应式邮件只是主题之一。如果你真的关心在你的网络上的产品，你会把你的热情与工艺应用到你的界面上并把它转化成最普及和最有价值的媒体工具。