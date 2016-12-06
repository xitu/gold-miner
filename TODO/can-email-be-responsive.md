> * 原文地址：[Can Email Be Responsive?](http://alistapart.com/article/can-email-be-responsive)
* 原文作者：[Jason Rodriguez](http://alistapart.com/author/JasonRodriguez)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Hyuni](http://hyuni.cn/)
* 校对者：

# 响应式邮件设计


无论你是否喜欢,HTML邮件的人气是不可否认的. 就像网页一样, 收件箱开始走向移动化,[有一半以上的邮件](https://litmus.com/blog/email-client-market-share-where-people-opened-in-2013) 是在移动设备上被打开.


# Translations

- [意大利语](http://italianalistapart.com/articoli/112-numero-95-29-luglio-2014/472-email-puo-essere-responsive)

[![](//assets.servedby-buysellads.com/p/manage/asset/id/32683)Brief books for people who make websites. Ad via BuySellAds](//srv.buysellads.com/ads/click/x/GTND423YCTSD4KJYCAA4YKQWFTYDK23JCVBICZ3JCEADT2J7CK7DL23KC6BDEK3NCTYDEK3EHJNCLSIZ)

现在的邮件依然设计的很过时. 还记得在Web规范成为…规范之前的编码时光吗? 欢迎来到邮箱设计地狱.

But coding an email doesn’t need to be a lesson in frustration. 现在的邮件设计者还必须使用HTML属性，gsap，行内样式，以及一些前卫的设计师所说的前沿技术来代替老旧的用法来给邮件设计布局。
收到由Ethan Marcotte首次撰写的基于[响应式网页设计]原理的开发(http://alistapart.com/article/responsive-web-design/)的启发，一场逐步逼近现代网页的电子邮件设计风潮开始了。

## 网页邮箱的价值[#section1](#section1)

无论你是否喜欢,网页邮箱在各行各业都是非常重要的工具.在营销方面, 电子邮件一贯[优于](http://www.wired.com/business/2013/07/email-crushing-twitter-facebook/) 其他方式，比如Facebook和Twitter. 更重要的是,电子邮件提供越来越[个性化的方式](http://blog.mailchimp.com/paul-jarvis-likes-trading-stories-with-people/)使[大量的潜在用户](http://blog.getvero.com/email-marketing-statistics/)互相影响.

你可能对电子邮件营销不太积极， 但是作为一名Web设计师或者开发人员，你会使用电子邮件与你的用户定期沟通. 可能是发一条回执, 或者公告新的产品功能给用户, 或者通知他们你最新发的的博文. 无论什么原因, 电子邮件都是一种重要和经常被忽略的媒介.

许多开发者给顾客发送纯文本格式的邮件. 尽管纯文本格式有许多优点 (容易写，兼容性强，下载快等等), 但是HTML格式的电子邮件也有许多优势: 

- 超链接. 你可以通过邮件中链接到外部页面来进行更多交互.
- 设计.及时是在收件箱中，一个设计良好的HTML邮件也能让你强调你的品牌.
- 层次结构. 在HTML邮件中你可以使你的邮件主从分明，让人更容易注意到重要副本或者重要连接.
- 跟踪. HTML邮件允许你去追踪邮件是否被打开和约会接受情况，这些有价值的数据可以用来优化你的营销效率.

By not giving email as much attention as your pixel-perfect app, you are effectively losing out on 1) a valuable branding opportunity, 2) the ability to track opens and interactions in your emails, and 3) the opportunity to provide an amazing user experience outside of your application.

## HTML 邮件很糟糕[#section2](#section2)

传统上，对于网页设计师来说，设计和开发 HTML 邮件有着最坏的体验。 就像进入一个时光机，走进一个地狱般的 90 年代，基于表格布局，行内样式，非语义标记，和客户端 hack 技巧。

这里是一小部分 HTML 邮件痛苦的原因：


- 没有标准。当然，我们使用 HTML 和 CSS，但不像 web，邮件客户端没有真正的标准存在，这导致写出一些疯狂的代码

- 邮件客户端。邮件客户端，比如 Outlook 和 Gmail，经常以不同的方式渲染 HTML and CSS，从而导致...

- 许多 hacks。即使是设计良好的邮件 Even well-designed email campaigns need to rely on client-specific hacks to make things work.

- 没有 JavaScript。邮件中 web 最喜欢的语言, as email clients (rightly) strip it due to security concerns. Goodbye interactivity.

- 行内样式。我跟喜欢使用单独的结构进行描述。不幸的是，大部分邮件客户端强制你依赖行内样式和属性去做邮件中近乎所有的事。

While things likely won’t change anytime soon, there is a movement in the email design community (yes, one *does* exist) to alleviate the misery normally associated with developing email campaigns. A number of companies and individuals are improving the tools and methods of email design, and sharing their knowledge more than ever before.

The company I work for, [Litmus](http://litmus.com), is one of them. We build instruments to make testing and tracking email campaigns as painless as possible. And we’re all-in on spreading information about email marketing in general, and email design specifically. We even started a dedicated [community](http://litmus.com/email-community) to connect email marketers, allowing them to share their knowledge, refine techniques, and learn from both us and each other.

While I reference some of Litmus’ tools and resources in this article, there are a number of other companies and people working hard to improve the art of email design. In particular, both [MailChimp](http://mailchimp.com) and [Campaign Monitor](http://campaignmonitor.com) have excellent blogs and guides. And people like [Anna Yeaman](https://twitter.com/stylecampaign), [Nicole Merlin](https://twitter.com/moonstrips), [Fabio Carneiro](https://twitter.com/flcarneiro), [Elliot Ross](https://twitter.com/iamelliot), and [Brian Graves](https://twitter.com/briangraves) are all working to make email design a true craft.  

## 进化的收件箱[#section3](#section3)

Just like the rest of the web, the inbox is becoming mobile. In 2013, [51 percent of users opened emails on mobile devices](https://litmus.com/blog/email-client-market-share-where-people-opened-in-2013). That number is likely to increase, especially considering that a [growing number of people](http://blogs.hbr.org/2013/05/the-rise-of-the-mobile-only-us/) rely on their mobile device to access the internet, both out of habit and necessity.

The good news is that web designers can adapt their existing skills and apply them to email campaigns, creating a beautiful user experience on a channel vital to most users, but ignored by many designers.

## HTML邮件的原理是什么[#section4](#section4)

Generally speaking, HTML email is just like designing a web page—assuming web design has no knowledge of anything post-[Designing with Web Standards](http://en.wikipedia.org/wiki/Designing_with_Web_Standards). HTML emails rely on three things: tables, HTML attributes, and inline CSS. As you learn to build HTML emails, keep in mind that, due to email client rendering engines, we are working with a very limited subset of HTML and CSS. Campaign Monitor maintains an [excellent chart](http://www.campaignmonitor.com/css/) of what CSS is supported across major email clients.

Let’s briefly go over the basics of HTML email before looking at how to make emails responsive. As an example, I’ve adapted the template we use for our own newsletters at Litmus. Thanks to both Litmus and our wonderful designer, [Kevin Mandeville](http://dribbble.com/KEVINgotbounce), A List Apart readers can learn from and build on the same code we use for most of our campaigns—it’s now hosted on the [A List Apart Github account](https://github.com/alistapart/salted). To see how it performs across clients, you can check out the full range of [Litmus tests](https://litmus.com/pub/d5586ad/screenshots).

### 表格[#section5](#section5)

Most web designers use tags like the `div`, `header`, `section`, `article`, `nav`, and `footer` for building the structure of web pages. Unfortunately, email designers don’t have the luxury of using semantic elements. Instead, you *have* to use HTML tables to lay out your email campaigns. These tables will be nested… deeply.

Basic styling of tables will largely use attributes that most people haven’t used in quite some time: `width`, `height`, `bgcolor`, `align`, `cellpadding`, `cellspacing`, and `border`. Coupled with inline styles like `padding`, `width`, and `max-width`, designers can build robust email layouts.

Here’s an example of what a well-coded table in email looks like:

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

You can see how we nest tables and use the `border`, `cellpadding`, and `cellspacing` attributes to ensure that there aren’t unnecessary gaps in the design. A `bgcolor` is applied on the table-cell level, which is a more reliable method than `background` or `background-color` (although `background-color` does have its place).

One interesting thing to note is that a `div` is used to center the nested table and provide padding around the content. While tables should make up the bulk of your structure, the occasional utility `div` is useful for aligning content blocks, providing padding, and setting up some basic styles. However, they should not be used as the main structure of an email since most email clients have trouble with at least some aspect of the box model, making it unreliable for laying out emails.

### Images[#section6](#section6)

Using images in email is very similar to using them on the web, with one caveat: a number of email clients disable images by default, leaving subscribers looking at a broken, confusing mess.
![](http://alistapart.com/d/395/can-email-be-responsive/can-email-be-responsive-1.png)An email with images disabled
While there is no way to automatically enable those images, we can improve the situation by using alt-text to provide some context for the missing images. What’s more, we can use inline styles on the `img` element to style that alt-text and maintain some semblance of design.

```
<img src="img/fluid-images.jpg" width="240" height="130" style="display: block; color: #666666; font-family: Helvetica, arial, sans-serif; font-size: 13px; width: 240px; height: 130px;" alt="Fluid images" border="0" class="img-max">
```

Using the code above, our missing image now makes a bit more sense:
![](http://alistapart.com/d/395/can-email-be-responsive/can-email-be-responsive-2.png)Alt-text goes a long way
### Calls-to-Action[#section7](#section7)

One of the main advantages of HTML email is the ability to include clickable hyperlinks. Beyond just including links within copy, HTML email allows you to use big, beautiful buttons to entice subscribers.

Many email marketers use linked images for buttons. However, using [bulletproof buttons](http://buttons.cm), designers can craft buttons via code that renders reliably across clients, even with images disabled.

The table below is an example of an all-HTML bulletproof button, which uses borders to ensure the entire button is clickable, not just the text:

```
<table border="0" cellspacing="0" cellpadding="0" class="responsive-table">
	<tr>
		<td align="center"><a href="http://alistapart.com" target="_blank" style="font-size: 16px; font-family: Helvetica, Arial, sans-serif; font-weight: normal; color: #666666; text-decoration: none; background-color: #5D9CEC; border-top: 15px solid #5D9CEC; border-bottom: 15px solid #5D9CEC; border-left: 25px solid #5D9CEC; border-right: 25px solid #5D9CEC; border-radius: 3px; -webkit-border-radius: 3px; -moz-border-radius: 3px; display: inline-block;" class="mobile-button">Learn More →</a></td>
	</tr>
</table>
```

![](http://alistapart.com/d/395/can-email-be-responsive/can-email-be-responsive-3.png)Bulletproof buttons look great with images disabled
Once you have those basics down, it’s time to see how we actually make an email work well across a range of device sizes.

## 响应式邮件的原理是什么[#section8](#section8)

Just like with responsive websites, there are three main components of a responsive email: flexible images, flexible layouts, and media queries.

The only difference between the web and email is in how these three techniques are implemented.

In email design, we have a limited subset of HTML and CSS at our disposal. We can’t rely on properties and values that designers use for responsive sites on the web; margins, floats, and ems don’t work in many email clients. So we have to think of workarounds.

### 弹性布局图片[#section9](#section9)

浮动图片不是最棘手的. 虽然他们的`width` 属性被设定为100%, 除非高度和宽度使用相应的HTML属性定义，否则有些客户端可能在把图片渲染成预期大小时会有问题. 因此, 我们不得不先给他们设定成特定尺寸，之后才敲定具体尺寸.

第一步是确保使用健壮的代码来编码图片. 让我们看一下早先在邮件中的图片的代码.

```
<img src="responsive-email.jpg" width="500" height="200" border="0" alt="Can an email really be responsive?" style="display: block; padding: 0; color: #666666; text-decoration: none; font-family: Helvetica, arial, sans-serif; font-size: 16px;" class="img-max">
```

注意到里面的 `display` 属性了吗? 就像border属性一样， 那是也是应对淘气的客户端的众多hack手段之一.许多电子邮件客户端. Making images block-level will kill that spacing and save your design.
在图片周围增加空白来解决可能出现的行高问题。
现在，当我们想让我们的图片是弹性布局的，我们可以在邮件头部使用媒体查询:

```
img[class="img-max”] {
	width:100% !important;  
	height: auto !important;
}
```

并不是每一个图片都需要是弹性布局.例如logos和社交网站的图标无论设备的大小如何都要保持相同的大小, which is why we target flexible images using a class.

由于我们经常覆盖我们写的行内样式和HTML属性，所以使用important声明使文档渲染的时候确保我们的响应式样式会被优先表现。

现在让我们来跳到有点儿难度的地方吧。

### 弹性布局[#section10](#section10)

大多数Web开发者都对使用 [相对单位](http://alistapart.com/article/fluidgrids) 来定义 [语义化标签](http://alistapart.com/article/semanticsinhtml5) 的大小来开发响应式布局很熟悉，例如百分数，ems，rems. 虽然我们还是可以在电子邮件中使用百分比来进行弹性布局，但是他们在被内联使用时会在表格和其他一些元素上收到一些限制。

The one exception is a container table with specific pixel dimensions to constrain the overall width of the email design to prevent it from blowing out in clients that don’t handle percentages well, typically most versions of Microsoft Outlook.
几乎我们所有的表格都会使用百分比来设置列宽。 但是有一个例外，尤其在大多数Microsoft Outlook的版本中，

让我们从表格容器开始看起:

```
<table border="0" cellpadding="0" cellspacing="0" width="500" class="wrapper">
	<tr>
		<td>…Content…</td>
	</tr>
</table>
```

你看到我们使用 `width` 属性来强制使表格500像素宽。

这个表格容器可以容纳在email中的所有其他表格。 因为容器会逼迫所有元素在500像素内显示，所以我们可以安全的在我们其他表格中使用百分比来设置大小.

但是弹性表格永远是500像素宽有什么好处呢？ 让我们再一次看一下容器表格. 注意我使用的 `wrapper`类. 我们将会通过媒体查询使用这个类选择器使我们的邮件达到真正的响应式.

### 在电子邮件中使用媒体查询[#section11](#section11)

在电子邮件中使用媒体查询与在网页设计中一样。你可以在电子邮件中的头部引用媒体查询，从而使你的样式针对不同的设备属性做出调整。

简单而言, 我们将视窗(viewports)针对在 `max-width`525像素及以下. 然后针对那个wrapper类的表格，我们覆盖他们的HTML属性与内联样式来强制表格水平占满移动设备屏幕。

```
@media screen and (max-width:525px) {
	table[class=“wrapper”] {
		width:100% !important;
	}
}
```

We can also target any nested tables and do the same—effectively stacking content sections for an improved mobile experience. It’s not a bad idea to bump up the size of text and buttons on mobile, either.

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

The main drawback of using media queries is that they are not supported everywhere. While WebKit-based email clients like iOS Mail and the default Android email app work well, older Blackberry devices, Windows Phone 8, and the Gmail app on every platform disregard media queries.

Fortunately, iOS and Android [make up the majority](http://emailclientmarketshare.com) of mobile email audiences, so you can rely on most subscribers seeing your responsive emails as intended.

## Explore email design[#section12](#section12)

The techniques described above are just the beginning. Intrepid email designers are exploring the use of web fonts, SVG, and CSS3 animations in email. Sure, email design is hard and things break constantly, but that shouldn’t prevent you from exploring advanced techniques to see what works for you and your audience.

My one recommendation is to test the hell out of any email you build. Email clients are far worse than browsers in terms of rendering and support for HTML and CSS. Testing both on devices and using an email preview service—be it [Litmus](http://litmus.com), [Email on Acid](http://emailonacid.com), your own [device lab](http://stylecampaign.com/blog/2012/09/mobile-email-testing-rig/), or something else entirely—helps identify problems and allows you to work out issues before sending to a million subscribers.

Aside from testing your code and rendering, track all of your emails and test what [kind of content](http://mailchimp.com/resources/guides/how-to-create-an-email-marketing-plan/html/), copy, design, and [sending cadence](http://www.campaignmonitor.com/guides/planning/qanda/) resonates with your audience.

Above all, don’t disregard email design. It’s a necessary evil, but it’s getting better all the time. A [community is finally forming](https://litmus.com/community) around email design, and techniques are constantly being refined and perfected. Responsive email design is one of them. If you really care about your product and presence on the web, you will take the passion and craft you apply to your app’s interface and transfer it to one of the most widespread and valuable mediums around.
