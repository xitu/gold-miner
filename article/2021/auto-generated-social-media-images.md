> * 原文地址：[Auto-Generated Social Media Images](https://css-tricks.com/auto-generated-social-media-images/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/auto-generated-social-media-images.md](https://github.com/xitu/gold-miner/blob/master/article/2021/auto-generated-social-media-images.md)
> * 译者：[Zz招锦](https://github.com/zenblo)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)、[Chorer](https://github.com/Chorer)

# 简述自动生成的社交媒体图片

我[总是](https://css-tricks.com/tag/social-media-images/)在思考社交媒体图片的问题。当你在 Twitter、Facebook 或 iMessage 等平台分享链接时，这些图片是可以显示出来的。如果没有这些图片，你的链接基本上很难获取用户注意，因为它们能把一个小链接的普通帖子变成一个带有引人注目的图片的帖子，其有一个很大的可点击区域。在网站的所有图片中，社交媒体呈现的图片可能是该网站上浏览量最多、记忆度最高、网络需求量最大、排在首位的图片。

本质上是以下 HTML 使它们起作用：

```html
<meta property="og:image" content="/images/social-media-image.jpg"/>
```

要确保[读懂它](https://css-tricks.com/essential-meta-tags-social-media/)，因为还有一堆其他的 HTML 标签需要弄清楚。

GitHub 似乎有了新的社交媒体卡片，所以我又在思考这个问题了。下面这些是新的卡片：

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-06-at-10.14.23-AM.png?resize=1024%2C952&ssl=1)

[tweet](https://twitter.com/ladyleet/status/1390353733868040196)

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-07-at-10.01.09-AM.png?resize=878%2C1024&ssl=1)

[tweet](https://twitter.com/erikkroes/status/1389889553872392192)

那些 GitHub 的社交媒体图片显然是通过程序生成的。请看[一个示例 URL](https://opengraph.githubassets.com/f55622dadf147f30f9a583a9be18924ac4567e2f8169cab9af601ecb204ec77f/fempire/resources)。

## 自动生成的方式

虽然我知道一个纯手工定制设计的社交媒体图片有很多优点，但这对有很多页面的网站来说并不实用：博客网站、电商网站等。对于这样的网站，最好是通过模板来自动创建。我[以前](https://css-tricks.com/social-cards-as-a-service/)提到过其他人在这方面的做法，让我们回顾一下：

* Drew McLellan：[动态的社交分享图片](https://24ways.org/2018/dynamic-social-sharing-images/)
* Vercel：[开放图谱图片作为服务](https://og-image.vercel.app/)
* Phil Hawksworth：[社交图片生成工具](https://github.com/philhawksworth/social-image-generator)
* Ryan Filler：[自动分享社交图片](https://www.ryanfiller.com/blog/automatic-social-share-images/)

你知道这些都有什么共同点吗？都使用了 [Puppeteer](https://github.com/puppeteer/puppeteer)。

Puppeteer 可以方便地控制无界面 Chrome（headless Chrome）。它有一个[好用到让人难以置信的功能](https://pptr.dev/#?product=Puppeteer&version=v5.2.1&show=api-pagescreenshotoptions)，那就是对浏览器窗口进行截图：`await page.screenshot({path: 'screenshot.png'});`。这就是[我们的编码字体网站进行截图的方式](https://github.com/chriscoyier/coding-fonts/blob/master/takeScreenshots.js)。这种截图的方式让人们想到了一个不错的做法 —— 为什么不在 HTML 和 CSS 中设计一个社交媒体模板，然后让 Puppeteer 对其进行截图，并将其作为社交媒体的图片呢？

我喜欢这个想法，但这意味着它需要访问一个 Node 服务（Puppeteer 在 Node 上运行），这个服务要么一直在运行，要么可以作为 [serverless 功能](https://serverless.css-tricks.com/services/functions)来使用。因此，也难怪这个想法会引起 Jamstack （译者注：Jamstack 是一种使用 SSG 技术、不依赖 Web Server 的前端架构）人群的共鸣，他们早已习惯于做这类事情，如运行构建过程和利用 serverless 功能。

我认为将 serverless 功能托管在一个 URL 上，并通过 URL 参数将截图中包含的动态值传递给它的想法也很聪明。

## 使用 SVG 的方式

我有点喜欢用 SVG 作为社交媒体图片模板的想法，部分原因是我们可以基于非常固定的坐标进行设计，这与我设计社交媒体图片所需的精确尺寸的心智模型相契合。我喜欢 [SVG 的可组合性](https://css-tricks.com/swipey-image-grids/)。

George Francis 在博客中写道：[“创建你自己的 SVG 生成社交媒体图片”](https://georgefrancis.dev/writing/generative-svg-social-images/)，这是一个很好的例子，所有这些都很好地结合在一起，并带有随机性和奇思妙想。我也喜欢可满足的（contenteditable）技巧，使它成为一次性截图的有用工具。

我也参与了动态 SVG 的创作：请查看我们会议网站上的[这个会议页面](https://conferences.css-tricks.com/conferences/2021-magnoliajs/)。

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/CleanShot-2021-05-07-at-10.13.36@2x.png?resize=724%2C719&ssl=1)

不幸的是，SVG 并不是社交媒体图片所支持的图片格式。Twitter 明确声明了以下内容：

> 社交媒体图片中使用图片的 URL。图片必须小于 5MB。支持 JPG、PNG、WEBP 和 GIF 格式。 GIF 动画只有第一帧会被使用。不支持 SVG。
>
> [Twitter 文档](https://developer.twitter.com/en/docs/twitter-for-websites/cards/overview/markup)

不过，用 SVG 进行组合设计也是很不错的。你可以把它转换为另一种格式以便最终使用。一旦你有了 SVG，从 SVG 到 PNG 的转换几乎是轻而易举的。在我的示例中，我使用了 [svg2png](https://www.npmjs.com/package/svg2png) 和在构建过程中运行的[一个很小的 Gulp 任务](https://github.com/CSS-Tricks/conferences/blob/master/tasks/svg2png.js)。

## 使用 WordPress 的方式

我没有为我的 WordPress 网站建立一个程序 —— 至少没有一个在我每次发布或更新文章时运行的程序，但我认为动态的社交媒体图片会让 WordPress **获益最多**（就我个人的情况而言）。

我现在并不是没有这些东西。[Jetpack](https://jetpack.com/support/social/?aff=8638) 在这方面探索了许久。它将帖子的特色图片作为社交媒体图片，允许我预览它，并自动发布到社交网络。[下面是我做的一个视频](https://www.youtube.com/watch?v=WEKRuohH43A)，你可以看到特色图片被加载并很好地显示出来。

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-07-at-12.12.12-PM.png?resize=567%2C533&ssl=1)

但这并不能使它们的创建自动化。有时，单独定制图片也是一种方式（上面那个可能是一个很好的例子），但也许更多时候，一个很好的模板化图片才是正确的方式。

幸运的是，我从 Daniel Post 那里知道了 WordPress 的[社交图片生成器](https://socialimagegenerator.com/)。

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/auto-generated-social-media-images-editor.gif?raw=true)

这正是 WordPress 所需要的！

Daniel 亲自帮我创建了一个专门用于 CSS-Tricks 网站的定制模板。一直以来我都有一个很大的梦想，那就是有一堆模板供我选择，其中包括标题、作者、选定的引文、特色图片和其他东西。到目前为止，我们只确定了两个模板，一个是带有标题和作者的模板，另一个是带有特色图片、标题和作者的模板。图片是根据这些元数据即时创建的：

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-10-at-4.49.26-PM.png?resize=369%2C452&ssl=1)

如此巧妙。

这不是 Puppeteer，甚至不是 PhantomJS 驱动的 svgtopng。这是 PHP 生成的图像! 甚至不是 [ImageMagick](https://imagemagick.org/index.php)，而是[直接的 GD](https://www.php.net/manual/en/intro.image.php)，直接内置于 PHP 中的东西。所以这些图片不是用任何一种语法创建的，对前端开发者来说可能感觉很舒服。你最好只使用其中一个模板，但如果你想看看我的自定义模板是如何编码的（由 Daniel 编写），请告诉我，我可以把代码开源。

很酷的结果，对吧？

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/Screen-Shot-2021-05-12-at-3.39.02-PM.png?resize=558%2C484&ssl=1)

[Tweet](https://twitter.com/css/status/1391758245178511366)

我明白为什么它必须这样建造：它使用的技术将在 WordPress 可以运行的任何地方工作。这非常符合 WordPress 的风格。但它确实让我希望可以用一种更现代的方式来创建模板。想象一下，如果社交媒体图片的模板就像其他模板文件一样，类似于放在主题根部的 `social-image.php`，然后用所有正常的 WordPress API 来设计这个页面，就像一个 [ACF 块](https://www.advancedcustomfields.com/resources/blocks/)一样。之后它还会获取截图并使用。这些岂不是很酷吗？是的，这真的很酷。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
