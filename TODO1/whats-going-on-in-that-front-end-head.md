> * 原文地址：[What’s going on in that front end head?](https://medium.com/front-end-weekly/whats-going-on-in-that-front-end-head-dd443f3fb7d5)
> * 原文作者：[Andreea Macoveiciuc](https://medium.com/@andreea.macoveiciuc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-going-on-in-that-front-end-head.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-going-on-in-that-front-end-head.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[Long Xiong](https://github.com/xionglong58)

# 前端代中的 head 标签里都有些什么？

> 即使负责 SEO 和市场营销的同事没有要求，在我们前端代码中也应该有的必备标签。

![来自 [Natasha Connell](https://unsplash.com/@natcon773?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 的照片](https://cdn-images-1.medium.com/max/8064/1*lgPqPdewofN-QeUyeocZ8w.jpeg)

当我在准备团队内分享的 SEO 研讨会时，我仔细列出了一些我认为我们应该在 \<head> 中使用的标签。但令我惊讶的是，现实代码中有许多标签并未出现，可能是因为这些标签不是必须项。

因此，如果您是一个想要与负责市场营销和 SEO 的同时成为好基友的前端人员，或者是一个想要寻找一些能够快速提高平台搜索性能的产品负责人，请确保您的代码中没有漏掉下面的标签和属性。

## 文档的语言 —— lang 标签

```html
<html lang=”en”>…</html>
```

Google 会忽略 lang 标签，但 Bing 和屏幕阅读器不会，所以，对于可访问性和排名来说，它是一个重要的标签。准确来说，Google 并不是忽略它，而是它是用于识别文档语言并提供翻译服务的。但这对 SEO 来说并不重要。

通常，lang 标签都包含在 \<head> 中，但是也可以用于其他标签，如 \<blockquote> 或 \<p>。当这些元素的语言（实际内容中的语言）发生了变化，就可以使用 lang 标签。

例如：

```html
<blockquote lang="fr" cite="URL">Some french quote here</blockquote>
```

## hreflang 标签

前面我们提到 Google 在检索到不同语言的文档时会忽略 lang 标签，那么 Google 又是使用什么的呢？答案就是 hreflang 标签！

```html
<link rel="alternate" href="https://masterPageURL" hreflang="en-us" />
<link rel="alternate" href="https://DEVersionURL-" hreflang="de-de" />
```

这些标签里面发生了什么?

第一个行告诉 Google，该页面上使用的语言是英语，更准确地说，是针对我们的美国用户的。

第二行告诉 Google，如果有来自德国的用户在浏览，应该加载有 **hreflang=”de-de”** 的标签中 href 属性对应的页面。

如上图所示，hreflang 标签可以在 <head> 中使用，它还可以在 sitemap 中使用。如果您有多种语言的内容，并且希望降低异国用户获取到不相匹配的语言内容的风险，那么此标签非常有用。

但是，注意 lang 和 hreflang 标签都是**参考信息**，而不是指令。这意味着搜索引擎仍然可以显示页面的错误版本。

## canonical 标签

canonical 标签可能是所有标签中最烦人和最令人困惑的，下面是最通俗易懂的解释，这样您就能一劳永逸地理解它们的作用。

canonical 标签长这样：

```html
<link rel="canonical" href="https://masterPageURL" />
```

它有什么用？它告诉搜索引擎在 href 属性中添加的 URL 是主版页，或者是一组重复页面中和主题最相关的。

例如，在一个商城网站中，动态 URL 非常常见。在动态 URL 中，通过添加诸如 ?category= 或会话 ID 之类的参数来表示页面中的需要传递的值。

当这种情况发生时，您需要告诉 Google 哪些参数是应该被主版页索引的。您可以通过添加 canonical 标签并将其指向主版页的 URL 来实现。

请注意，**所有重复的页面**都需要包含此标签并指向主页面。

## Robots meta 标签

它和 robots.txt 文件不同。它是一个像下面这样的标签：

```html
<meta name="robots" content="noindex, nofollow" />
```

它有什么用？这个标签告诉搜索引擎机器人如何爬取一个页面，建立索引或不建立索引，继续爬取或不继续爬取。

与 lang 标签 和 robots.txt 文件不同，robots meta 标签是一个**指令**，因此它为搜索引擎机器人提供严格的指令。

可能的值如下：

* noindex：告诉搜索引擎不索引该页面。
* index：告诉搜索引擎索引该页面。这是默认值，因此如果希望页面被索引，可以跳过不设置它。
* nofollow：告诉爬虫不要继续爬取该页面中的任何链接，也不要传递任何链接权重。
* follow：告诉爬虫继续爬取页面上的链接并传递链接权重（“juice”）。即使页面不能被索引到，也不影响。

## 社交 meta 标签：OG

OG 是 Open Graph Protocol 的缩写，它是一种允许您控制在社交媒体上分享页面时显示什么数据的技术。下面是标签的样子：

```html
<meta property="og:title" content="The title" />
<meta property="og:type" content="website" />
<meta property="og:url" content="http://page.com" />
<meta property="og:image" content="img.jpg" />
```

以上四个标签是必须的，但是您可以添加更多其他标签，您可以在[这里](https://ogp.me/)查看列表。

如果缺少这些，您可能迟早会听到一些抱怨，因为每当同事分享一个页面时，如果 og:image 标签没被指定，将随机选择图像。

## Meta title & meta description 标签

老实说，我认为这些是在 \<head> 中必须存在的。但为了以防万一，您可以点击右键并检查。

这两个 meta 标签非常重要，因为它们告诉搜索引擎和社交平台该页面是关于什么的，并且它们会在搜索结果页面中显示出来。此外，title 将显示在浏览器选项卡中以及在添加书签时的书签中。

下面是标签的样子：

```html
<title>This is the page title<title />
<meta name="description" content="This is the meta description, meaning the text that's displayed in SERP snippets." />
```

现在，您可能想起了一个来自 Google 的老答案，这个答案可以追溯到 2009 年，它说 meta description 标签对 SEO 没有帮助。尽管如此，它们与 meta title 和页面 URL 一起依然是最能说服用户点击页面的元素。所以不管对 SEO 有没有帮助，它们都是非常重要的。

## 用于响应式设计的 meta 标签

这个标签的官方名称是 viewport，它看起来是这样的：

```html
<meta name="viewport" content="width=device-width, initial-scale=1" />
```

将其添加到文档的 /<head> 中，可以使页面是响应式的，并且使页面在移动设备和平板电脑上展示正常。您可能也听说过，Google 会首先扫描和索引移动版本的网站，目的是使网页在移动端更友好。

虽然它在技术上来说并没有把您的网站变成一个移动版本，但是如果搜索引擎没有找到移动优先的设计，它会参考这个标签。因此，当 m.site.com 缺失时，Google 将扫描 web 版本，理想情况下它应该能找到 viewport 标签。不支持移动和响应的页面排名较低。

## 用于展示网站图标的标签

您的同事会因为它高兴的，因为它使浏览器能够在选项卡中显示一个漂亮的图标或徽标，旁边是站点的名称。添加 favicon 的标签是这样的：

```html
<link rel="icon" href="favicon-img.ico" type="image/x-icon" />
```

图片最好以 .ico 的格式保存，在这方面它比 .png 和 .gif 支持得更好。

（我觉得这里可以不翻译了，没读懂作者的意思。看看校对的意见，我再改）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
