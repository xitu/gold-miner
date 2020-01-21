> * 原文地址：[5 Easy Steps to Creating a Sitemap For a Website](https://www.quicksprout.com/creating-website-sitemap/)
> * 原文作者：[quicksprout](https://www.quicksprout.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-website-sitemap.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-website-sitemap.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[Chorer](https://github.com/Chorer)，[Gavin](https://github.com/redagavin)

# 5 个简单步骤为您的网站创建 Sitemap

## 创建和提交 sitemap 所需的一切

当您想要让您的网站位居搜索引擎的前列时，您需要利用尽可能多的 SEO 技巧。创建 sitemap 绝对是一种可以帮助[提高您 SEO 策略](https://www.quicksprout.com/university/how-to-optimize-your-robots-txt-file/)的技术。

## 什么是 sitemap？

有些人已经对它很熟悉了。但是，在我向您展示如何建立您自己的 sitemap 之前，我会给您一个关于 sitemap 基础知识的速成课程。

简单来说，sitemap，或者说 XML sitemap，是网站上不同页面的列表。XML是“extensible markup language”的缩写，这是在站点上显示信息的一种方式。 
  
我咨询过很多站长，他们之所以被吓到是因为他们认为 sitemap 是 SEO 的技术组成部分。但实际上，创建 sitemap 并不需要您成为一个技术大牛或是有技术背景的人。看完这篇教程之后，您很快就会发现这实际上并不难。

## 为什么你需要 sitemap？

像 Google 这样的搜索引擎，一直致力于向人们展示任何给定的搜索查询中最相关的结果。为了有效地做到这一点，他们使用站点爬虫来读取、组织和索引互联网上的信息。

XML sitemap 使搜索引擎爬虫更容易读取站点上的内容并相应地为页面建立索引。因此，这增加了[提高您的网站 SEO 排名](https://www.quicksprout.com/ways-to-improve-seo-ranking/)的机会。

您的 sitemap 会告诉搜索引擎您的网站上某个页面的位置，它是何时更新的，更新的频率如何，以及这个网页的重要性根据它和您网站上其他页面的关联。如果没有合适的 sitemap，Google 机器人可能会认为您的网站有重复的内容，这实际上会降低您的 SEO 排名。

如果您已经准备好让您的网站更快地被搜索引擎索引，那么只需遵循以下五个简单的步骤来创建 sitemap。

### 第 1 步: 检查页面的结构

您需要做的第一件事是查看您的网站上的现有内容以及所有内容的结构。

看看这个 [sitemap 模板](https://nationalgriefawarenessday.com/48796/website-sitemap-template)，并弄明白如何用一张表来表示您的网页。

![网页 sitemap 模版](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/website-sitemap-template.png)

这是一个简单易懂的例子。

一切都从主页开始。然后，问问自己主页会链接到哪些页面去。您可能已经根据您网站上的菜单选项找到了答案。

但说到 SEO，并不是所有页面的排名都是一样的。当您处理页面的 SEO 时，您必须记住您网站的深度。要明白一点：离您的网站主页越远的页面排名越靠后。

根据 [搜索引擎日志](https://www.searchenginejournal.com/website-structure-affects-seo/186553/) 这篇文章的说法，您应该致力于创建深度较浅的 sitemap，这意味着只需单击三下即可导航到您网站上的任何页面。对于SEO而言，这会是极好的。

因此，您需要基于页面的重要级别和您希望的它们被索引的方式，来创建一个页面层次结构。按照逻辑层次决定你的内容的优先顺序。如果您不太明白，可以看看这个[例子](https://blog.hubspot.com/marketing/build-sitemap-website)。

![页面层次结构](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/page-hierarchy.png)

正如您所看到的，ABOUT页面链接到 Our Team 页面以及 Mission & Values 页面。然后，Our Team 页面链接到  Management 页面和 Contact Us 页面。

[“关于”页面是最重要的](https://www.quicksprout.com/how-to-create-about-page/)，这就是为什么它位于顶级导航层。将 Management 页面放在与 PRODUCTS 页面、PRICING 页面和 BLOGS 页面同一级别是不合理的，这就是为什么它属于第三级层次。

同样，如果 Basic 页面位于 Compare Packages 页面的上方，则会使逻辑结构被打乱。

所以，请使用这些可视化的 sitemap 模板来确定页面的组织。你们中的有些人可能已经有一个合理的网站结构，只需要进行一些微调即可。

请记住，您应该尽可能实现在三次单击之内就可以到达每个页面。

### 第 2 步：修改您的 URL

现在您已经浏览并确定了每个页面的重要性，也根据重要性安排了网站结构，是时候对这些 URL 进行修改了。

实现这个的方法是使用 XML 标签编排每个 URL 的格式。如果您写过一些 HTML，这对您来说简直是小菜一碟。如前所述，XML 中的 ML 代表”标记语言“（markup language），所以它和 HTML 是类似的。

即使您是第一次接触它，这也并不难。首先打开一个您可以在其中创建 XML 文件的文本编辑器。

就文本编辑器而言，[Sublime Text](https://www.sublimetext.com/) 对您来说会是一个不错的选择。

![Sublime Text 文本编辑器](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/sublime-text-editor.png)

接着，为每个 URL 添加相应的代码。

* 网站地址（location）
* 上一次更新的时间（last changed）
* 更新频率（changed frequency）
* 页面的优先级（priority of page）

下面的一些示例展示了代码的大致样子。

* http://www.examplesite.com/page1
* 2019-1-10
* weekly
* 2

慢慢来，一定要把这件事做好。在添加这段代码时，文本编辑器会使您的工作变得更加轻松，但您仍需保持清晰的头脑。

### 第 3 步：验证代码的正确性

任何您手敲代码的过程，都可能发生人为错误。但是，为了让您的 sitemap 正常运行，您的代码不允许有任何错误。

幸运的是，有一些工具可以帮助验证代码以确保语法的正确。网上有一些软件可以帮助你做到这一点。只要在 Google 上搜索“sitemap validation”（不翻墙的话，就百度搜“sitemap 验证”），您就会发现它们。

我喜欢使用 [XML Sitemap 验证工具](https://www.xml-sitemaps.com/validate-xml-sitemap.html)。

![xml sitemap 生成器](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/xml-sitemap-generator.png)

它将挑出代码中的任何错误。

例如，如果您忘记添加结束标记或者类似的东西，这个工具可以很快地发现并进行修复。

### 第 4 步：将 sitemap 添加到站点根目录和 robots.txt

找到网站的根文件夹，并将 sitemap 文件添加到此文件夹中。

这样做实际上也会将页面添加到您的站点，但这并不会有什么问题。事实上，很多网站都有这个页面。你可以输入一个网址，并在后面添加“/sitemap/”，看看会弹出什么。

这是 [Apple](https://www.apple.com/sitemap/) 网站的一个例子。

![apple 的 sitemap](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/apple-sitemap.png)

注意每个部分的结构和逻辑层次。这与我们在第一步中讨论的内容有关。

现在，我们可以更进一步。您甚至可以通过在 URL 后添加 “/sitemap.xml” 来查看不同网站上的代码。

这是 [HubSpot](https://www.hubspot.com/sitemap.xml) 网站的 sitemap 的样子。

![hubspot 的 sitemap](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/hubspot-sitemap.png)

除了将 sitemap 文件添加到根目录之外，您还需要将其添加到 robots.txt 文件中。您也可以在根文件夹中找到它。

基本上，这可以引导任何索引您网站的爬虫。

robots.txt 文件有两种不同的用法。您可以对其进行设置，以告诉爬虫有哪些 URL 是您不希望他们在搜寻您的网站时进行索引的。

让我们回到 Apple 官网，看看他们的 [robots.txt 页面](https://www.apple.com/robots.txt) 长什么样子。

![robots.txt](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/robots-txt.png)

如您所见，他们 “disallow” 其网站上的多个页面。因此，爬虫会忽略这些网页。

![apple sitemap 文件](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/apple-sitemap-files.png)

同时，Apple 也在这里包含了他们的 sitemap 文件。

事实上，并不是所有人都会建议您将 sitemap 添加到 robots.txt 文件中。因此，您自己决定就好。

话是这样说，但是我是一个遵循成功网站和企业最佳实践的坚定信仰者。所以，如果像 Apple 这样的大公司将 sitemap 写到 robots.txt 页面，这或许对我们来说是一个不错的主意。

### 第 5 步：提交 sitemap 

现在您的 sitemap 已经创建好并添加到您的站点文件中了，是时候将它们提交给搜索引擎了。

您需要通过 [Google Search Console](https://search.google.com/search-console/about) 来提交。有些人可能已经使用过它了。就算没有，您也可以快速上手。

进入 Search Console 控制面板后，导航至 Crawl > Sitemaps。

![Google search console](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/google-search-console.png)

接着，单击屏幕右上角的 Add/Test Sitemap。

这里可以让您在继续下一步之前再次检验 sitemap 是否有错误。显然，您需要修复所发现的任何错误。一旦您的 sitemap 没有错误，点击提交就可以了。Google 将处理这一切。现在爬虫将很容易地索引您的网站，这将提高您的 SEO 排名。

## 代替方案

虽然这五个步骤非常简单明了，但是可能还是会有些人对手动修改网站上的代码感到不舒服。这完全可以理解。幸运的是，还有许多其它的解决方案可以让您不用自己编辑代码也能创建 sitemap。

我将介绍一些最常用的代替方案供您考虑。

### Yoast 插件

如果您有一个 WordPress 网站，您可以安装 [Yoast 插件](https://kb.yoast.com/kb/enable-xml-sitemaps-in-the-wordpress-seo-plugin/)来为您的网站创建 sitemap。

Yoast 可以让您通过简单的拨动开关来打开和关闭 sitemap。插件安装好后，您可以从 WordPress 的 SEO 标签页中找到所有 XML sitemap 选项。

### Screaming Frog

[Screaming Frog](https://www.screamingfrog.co.uk/xml-sitemap-generator/) 是一款桌面软件，它提供了大量的 SEO 工具。只要网站的页面不超过 500 页，您就可以免费使用和生成 sitemap。对于那些拥有大型网站的用户，您就需要升级付费版本了。

Screaming Frog 支持我们前面讨论过的所有代码的更改，而且不需要您自己实际编写代码。相反，您根据提示操作就行了，这个提示更友好，而且是用通俗易懂的英语写的。然后 sitemap 文件的代码将自动更改。下面的截图就是我要表达的意思。

![screaming frog 配置](https://quicksprout-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/screaming-frog-configuration.png)

只需选择标签页，更改设置，sitemap 文件就会相应地进行调整。

### Slickplan

我非常喜欢 Slickplan，因为它有可视化的 sitemap 构建功能。您将有机会使用 sitemap 模板，类似于我们前面看到的网站结构模板。

在这里，您可以拖放不同的页面到模板来组织您的网站结构。完成后，如果您对可视化的 sitemap 感到满意，就可以将其导出为 XML 文件。

Slickplan 是付费软件，但它们提供免费试用。如果您在犹豫是否购买它，可以去试试。

## 总结

如果您打算提升一下您的 SEO 策略，您需要做的就是为您的站点创建一个 sitemap。

对您而言 sitemap 再也不是难题了。因为正如这篇指南所介绍的，只需五个步骤即可轻松创建 sitemap。

1. 检查页面的结构
2. 编辑 URL
3. 验证代码的正确性
4. 将 sitemap 添加到站点根目录和 robots.txt
5. 提交 sitemap

这就完事啦！

对于那些仍然对手动更改网站代码束手无策的人，您还可以选择其它代替方案。尽管互联网上有着大量的 sitemap 相关的资源，但是我推荐的 Yoast 插件，Screaming Frog 和 Slickplan 依然都是很不错的入门选择。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
