> * 原文地址：[Google Search Operators: The Complete List (42 Advanced Operators)](https://ahrefs.com/blog/google-advanced-search-operators/)
> * 原文作者：[Joshua Hardwick](https://ahrefs.com/blog/author/joshua-hardwick/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-advanced-search-operators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-advanced-search-operators.md)
> * 译者：[cdpath](https://github.com/cdpath)
> * 校对者：[JackEggie (Jack Tang)](https://github.com/JackEggie), [nettee (William Liu)](https://github.com/nettee)

# 谷歌搜索操作符大全（42 个高级操作符）

接触过 SEO 的人都对谷歌高级搜索操作符有所了解，也就是一些比普通搜索更进阶的特殊搜索命令。

比如这个搜索操作符你可能比较熟悉：

![ahrefs site search](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-site-search.gif)

`site:` 操作符只返回指定网站内的搜索结果。

大多数操作符都不难记。就像是脑子里的快捷命令。

不过会高效利用却没那么简单。

SEO 从业者大多只知皮毛，鲜有精通者。

我会在这篇文章中介绍十五个行之有效的小技巧，助你掌握 SEO 搜索操作符。包括：

1.  [查找索引错误](#1-查找索引错误)
2.  [查找不安全的页面（没有启用 https）](#2-查找不安全的页面没有启用-https)
3.  [查找重复的内容](#3-查找重复的内容)
4.  [查找网站中不需要的文件和网页](#4-查找域名下的奇怪文件你自己可能都忘了)
5.  [寻找投稿的机会](#5-寻找投稿的机会)
6.  [查找加入资源页的机会](#6-查找加入资源页的机会)
7.  [查找主打信息图的网站…… 这样就可以推销自己的](#7-查找主打信息图的网站-这样就可以推销自己的)
8.  [寻求更多链接机会…… 并检查他们的相关性到底如何](#8-寻求更多链接机会-并检查他们的相关性到底如何)
9.  [寻找潜在客户的社交媒体账号](#9-寻找潜在客户的社交媒体账号)
10.  [寻找内链机会](#10-寻找内链机会)
11.  [通过搜索提及竞争对手的内容发现公关（PR）机会](#11-通过搜索提及竞争对手的内容发现公关pr机会)
12.  [寻找赞助文章机会](#12-寻找赞助文章机会)
13.  [查找和你的内容相关的问答帖](#13-查找和你的内容相关的问答帖)
14.  [查找竞争对手更新内容的频率](#14-查找竞争对手更新内容的频率)
15.  [查找链接到竞争对手的网站](#15-查找链接到竞争对手的网站)

不过我们先回顾一下全部谷歌搜索操作符及其功能。

## 谷歌搜索操作符大全

你知道谷歌在不断[废弃有用的搜索操作符](https://searchengineland.com/google-drops-another-search-operator-tilde-for-synonyms-164403)吗？

所以说大多数谷歌搜索操作符大全都过时了，不怎么准确。

本文中我测试了能找到的所有操作符。

下面是所有可用的，被废弃的，以及时好时坏的 2018 版谷歌高级搜索操作符清单。

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/working-operators.png)

### “整词搜索”

强制进行精准匹配搜索。可以用来改善模糊的搜索结果，或者在搜索单词时排除同义词的结果。

**例子**: [“steve jobs”](https://www.google.com/search?&q=%22steve+jobs%22)

### OR

搜索 X **或** Y。会得到与 X, Y 或者和两者都有关的结果。**注意**：可以用管道操作符（`|`）代替 OR。

**例子**: [jobs OR gates](https://www.google.com/search?&q=jobs+OR+gates) / [jobs | gates](https://www.google.com/search?&q=jobs+%7C+gates)

### AND

搜索 X **且** Y。返回结果与 X **和** Y 都有关。**注意**：实际和常规搜索没什么区别，因为谷歌默认使用 `AND` 操作符。但是和其他操作符组合使用时 `AND` 还是有用的。

**例子**: [jobs AND gates](https://www.google.com/search?&q=jobs+AND+gates)

### -

排除一个词或短语。下面这个例子只会返回与苹果公司**无关**的 jobs 结果。

**例子**: [jobs -apple](https://www.google.com/search?q=jobs+-apple)

### *

通配符，匹配任意词或短语。

**例子**: [steve * apple](https://www.google.com/search?q=%22steve+*+apple)

### ( )

组合多个词或搜索操作符，控制搜索的行为。

**例子**: [(ipad OR iphone) apple](https://www.google.com/search?q=%28ipad+OR+iphone%29+apple)

### $

搜索价格。欧元符号（€）也行。但是英镑（£）不行。🙁

**例子**: [ipad $329](https://www.google.com/search?q=ipad+%24329)

### define:

基本就是查询谷歌内置词典。就是在搜索结果页（SERP）上的卡片中展示词义。

**例子**: [define:entrepreneur](https://www.google.com/search?q=define%3Aentrepreneur)

### cache:

得到网页的最新缓存（当然前提是网页已被索引）。

**例子**: [cache:apple.com](http://webcache.googleusercontent.com/search?q=cache%3Aapple.com)

### filetype:

只展示特定文件类型的搜索结果。比如，PDF，DOCX，TXT，PPT 等。**注意**：等价于 `ext:` 操作符。

**例子**: [apple filetype:pdf](https://www.google.com/search?q=apple+filetype%3Apdf) / [apple ext:pdf](https://www.google.com/search?q=apple+ext%3Apdf)

### site:

只展示来自特定网站的结果。

**例子**: [site:apple.com](https://www.google.com/search?q=site%3Aapple.com)

### related:

查找和特定域名相关的网站。

**例子**: [related:apple.com](https://www.google.com/search?q=related%3Aapple.com)

### intitle:

查找标题中带有特定词语的网页。下面的例子只返回标题中含有 “apple” 的网页。

**例子**: [intitle:apple](https://www.google.com/search?q=intitle%3Aapple)

### allintitle:

和 intitle 类似，不过只返回标题带有**所有**指定关键字的网页。

**例子**: [allintitle:apple iphone](https://www.google.com/search?q=allintitle%3Aapple+iphone)

### inurl:

查找 URL 中带有关键字的网页。比如下面的例子只返回 URL 中有 “apple” 的网页。

**例子**: [inurl:apple](https://www.google.com/search?q=inurl%3Aapple)

### allinurl:

和 inurl 类似，不过只返回 URL 带有**所有**关键字的网页。

**例子**: [allinurl:apple iphone](https://www.google.com/search?q=allinurl%3Aapple+iphone)

### intext:

查找网页内容中带有关键字的网页。比如下面的例子，返回网页内容中有 “apple” 的结果。

**例子**: [intext:apple](https://www.google.com/search?q=intext%3Aapple)

### allintext:

和 intext 类似，不过只返回内容中含有**全部**关键字的网页。

**例子**: [allintext:apple iphone](https://www.google.com/search?q=allintext%3Aapple+iphone)

### AROUND(X)

临近搜索。查找两个关键字的距离不超过 X 的网页。例子中，返回结果中的 “apple” 和 “iphone” 必须同时出现在网页内容中，而且两个单词之间的单词不超过 4 个。

**例子**: [apple AROUND(4) iphone](https://www.google.com/search?q=apple+AROUND(4))

### weather:

查阅指定地点的天气。结果会展示在天气小部件中，不过也会返回其他天气网站的结果。

**例子**: [weather:san francisco](https://www.google.com/search?q=weather%3Asan+francisco)

### stocks:

查阅指定的股票信息（比如价格等）。

**例子**: [stocks:aapl](https://www.google.com/search?q=stocks%3Aaapl)

### map:

强制返回指定地点的地图结果。

**例子**: [map:silicon valley](https://www.google.com/search?q=map%3Asilicon+valley)

### movie:

查阅指定电影信息。如果电影在附近上映，还会告诉你开场时间。

**例子**: [movie:steve jobs](https://www.google.com/search?q=movie%3Asteve+jobs)

### in

单位换算。支持货币，重量，温度等的换算。

**例子**: [$329 in GBP](https://www.google.com/search?q=%24329+in+GBP)

### source:

在谷歌新闻搜索的指定网站中搜索关键字。

**例子**: [apple source:the_verge](https://www.google.com/search?q=apple+source%3Athe_verge&tbm=nws)

### _

准确地讲这个不算是搜索操作符。它的作用是充当谷歌自动补全的通配符。

**Example**: apple CEO _ jobs

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/hit-and-miss-operators.png)

下面是一些我测试时时好时坏的操作符：

### #..#

搜索数字范围。下面的例子会返回 2010 年到 2014 年的 “WWDC videos” 结果，不包括 2015 年及以后的结果。

**例子**: [wwdc video 2010..2014](https://www.google.com/search?q=wwdc+video+2010..2014)

### inanchor:

查找被指定锚文字（anchor text）指向的网页。下面例子返回指向这些页面的锚文字中出现 ”apple“ 或者 ”iphone“ 的结果。

**例子**: [inanchor:apple iphone](https://www.google.com/search?q=inanchor%3Aapple+iphone)

### allinanchor:

和 inanchor 类似，不过只返回指向这些页面的锚文字含有**全部**关键字的结果。

**例子**: [allinanchor:apple iphone](https://www.google.com/search?q=allinanchor%3Aapple+iphone)

### blogurl:

查找指定域名下的博客 URL。这个本用于谷歌博客搜索，不过我测试发现在常规搜索时也有用。

**例子**: [blogurl:microsoft.com](https://www.google.com/search?q=blogurl%3Amicrosoft.com)

旁注：

谷歌博客搜索在 2011 年被废弃。

### loc:placename

返回指定地域的搜索结果。

**例子**: [loc:”san francisco” apple](https://www.google.com/search?q=loc%3A%22san+francisco%22+apple)

旁注：

没有被官方废弃，不过结果时好时坏。

### location:

返回指定地域的谷歌新闻搜索结果。

**例子**: [loc:”san francisco” apple](https://www.google.com/search?q=loc%3A%22san+francisco%22+apple)

旁注：

没有被官方废弃，不过结果时好时坏。

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/not-working-operators.png)

下面是已废弃失效的搜索操作符。🙁

### +

强制精准匹配单词或词组。

**例子**: [jobs +apple](https://www.google.com/search?q=jobs+%2Bapple)

旁注：

可以用双引号代替。

### ~

包含同义词。没有什么效果是因为谷歌默认就会返回同义词结果。（**提示：用双引号排除同义词。**）

**例子**: [~apple](https://www.google.com/search?q=~apple)

### inpostauthor:

查找指定作者的博文。只在谷歌博客搜索有效，不适用于谷歌搜索。

**例子**: inpostauthor:”steve jobs”

旁注：

谷歌博客搜索在 2011 年被废弃。

### allinpostauthor:

和 `inpostauthor` 类似，不过不需要再用引号了（如果你想要连名带姓地搜索指定作者。）

**例子**: allinpostauthor:steve jobs

### inposttitle:

查找标题中含有关键字的博文。不能用了，因为这个操作符只对已废弃的谷歌博客搜索有效。

**例子**: intitle:apple iphone

### link:

查找指向特定域名或 URL 的网页。谷歌在 2017 年废弃了这个操作符，不过这个操作符还是会返回一些结果 —— 只是结果不是特别精确。(**[于 2017 年被废弃](https://searchengineland.com/google-officially-killed-off-link-command-267454)**)

**例子**: [link:apple.com](https://www.google.com/search?q=link%3Aapple.com)

### info:

查阅指定网页的相关信息，包括最近的缓存，类似的网站等（**[于 2017 年被废弃](https://searchengineland.com/google-changes-info-command-search-operator-dropping-useful-links-286422)**）。**注意**：可以用 `id:` 操作符代替，结果一样。

旁注：

尽管这个操作符的原始功能被废弃了，在查找标准的、被索引的 URL 时还是挺有用的。感谢 [@glenngabe](https://twitter.com/glenngabe) 的说明。

**例子**: [info:apple.com](https://www.google.com/search?q=info%3Aapple.com) / [id:apple.com](https://www.google.com/search?q=id%3Aapple.com)

### daterange:

查找指定时间范围内的结果。出于某些原因，需要使用[儒略日格式](http://www.longpelaexpertise.com/toolsJulian.php)。

**例子**: [daterange:11278–13278](https://www.google.com/search?q=steve+jobs+daterange%3A11278-13278)

旁注：

没有被官方废弃，但是好像不能用了。

### phonebook:

查找某人的电话号码。(**[于 2010 年被废弃](https://searchengineland.com/google-drops-phonebook-search-operator-56173)**)

**例子**: [phonebook:tim cook](https://www.google.com/search?q=phonebook%3Atim+cook)

### #

搜索 #话题标签（hashtag）。由 Google+ 引入，现已废弃。

**例子**: [\#apple](https://www.google.com/search?q=%23apple)

## 谷歌搜索操作符实战十五例

现在来实战一下这些操作符。

我的目的是给你展示用谷歌高级操作符就几乎可以实现任何操作，前提是你知道如何高效地组合使用。

不要担心，放手去尝试，超出下文给出的例子也没有关系。说不定还会有新的收获。

读不下去了？

可以看看 [Sam Oh 的视频](https://www.youtube.com/watch?v=yWLD9139Ipc)，介绍了 9 个可操作的谷歌搜索操作符技巧。

[https://www.youtube.com/watch?v=yWLD9139Ipc](https://www.youtube.com/watch?v=yWLD9139Ipc)

开始吧！

### 1. 查找索引错误

大多数网站都会遇到谷歌索引错误。

有时候是应该被索引的网页没有索引。也有可能不该被索引的网页被索引了。

用 `site:` 操作符看看谷歌索引了多少个 **ahrefs.com** 网页。

![ahrefs site 操作符索引数](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-site-operator-index.jpg)

大约 1,040。

旁注：

用这个操作符谷歌只告诉你[大致的结果](https://searchengineland.com/what-you-can-learn-from-googles-site-operator-14052)。要完整信息，请查阅[谷歌搜索控制台](https://www.google.com/webmasters/tools/home?hl=en)。

那么这些页面中有多少个博文页面呢？

我们查查看。

![ahrefs blog 博文索引](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-blog-posts-index.jpg)

约 249。 差不多是 ¼.

我对 Ahrefs 博客太了解了，所以我知道这个数字比我们的博文数量要多。

进一步调查。

![ahrefs blog 奇怪的索引](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-blog-weird-indexation.jpg)

好吧，看上去有一些奇怪的页面也被索引了。

**(这个页面根本无法访问，就是个 404 页面)**

应该用 [noindex](https://support.google.com/webmasters/answer/93710?hl=en) 把这些页面从搜索结果页中移除。

还可以把结果限制在子域名下，看看结果。

![ahrefs 子域名索引数](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-index-subdomains.jpg)

旁注：

这里用到了通配符（\*）来查找主域名下的所有子域名，同时使用了排除操作符（\-）来去除常规的 www 结果。

约 731 个结果。

下面就是在子域名中，但是**绝对**不应该被索引到的例子。它会返回 404 错误。

![ahrefs 索引错误](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-indexation-error.jpg)

还有一些方法用谷歌操作符来发现索引错误。

*   `site:yourblog.com/category` — 查找 WordPress 博客分类页；
*   `site:yourblog.com inurl:tag` — 查找 WordPress 标签页。

### 2. 查找不安全的页面（没有启用 https）

HTTPs **不可或缺**，尤其对于[商业网站](https://ahrefs.com/blog/ecommerce-seo/)。

不过你知道可以用 `site:` 操作符查找不安全页面吗？

用 **asos.com** 举个例子吧。

![asos unsecure 1](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-unsecure-1.jpg)

天，大概有 247 万个不安全页面。

看上去 ASOS 还没有启用 SSL —— 对于这么大的网站来说实在不应该。

![asos unsecure](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-unsecure.jpg)

旁注：

Asos 的用户不要担心，Asos 的结算页面还是安全的。 🙂

不过还有个比较扯淡的事情：

ASOS 可以同时用 **https** 和 **http** 访问。

![asos http https](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-http-https.gif)

所有这些信息都可以通过 `site:` 获取。

旁注：

我发现，有时候用这个技巧找到了没有 https 的页面，如果你点进去，会被重定向到 https 版本。所以不要因为出现在搜索结果中就认为网页不安全。记得点几个搜索结果确认一下。

推荐阅读

*   [We Analyzed the HTTPS Settings of 10,000 Domains and How It Affects Their SEO — Here’s What We Learned](https://ahrefs.com/blog/ssl/)
*   [HTTP vs. HTTPS for SEO: What You Need to Know to Stay in Google’s Good Graces](https://ahrefs.com/blog/http-vs-https-for-seo/)

### 3. 查找重复的内容

内容重复是件坏事。

这里有一个 [ASOS 上的 A&F 牛仔裤的页面](http://www.asos.com/abercrombie-fitch/abercrombie-fitch-slim-fit-jeans-in-destroyed-black-wash/prd/8459420?clr=black&SearchQuery=&cid=4208&gridcolumn=1&gridrow=1&gridsize=4&pge=1&pgesize=72&totalstyles=1)，带有品牌说明：

![asos abercrombie and fitch](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-abercrombie-and-fitch.jpg)

像这种第三方品牌说明经常被各种网站复制来复制去。

不过首先，我想知道在 **asos.com** 上这段文字重复了多少次。

![abercrombie and fitch 同域名下的重复](https://ahrefs.com/blog/wp-content/uploads/2018/05/abercrombie-and-fitch-ahrefs-duplicate-same-domain.jpg)

约 4200 次。

现在我想知道这段文字是不是 ASOS 独有的。

看一下结果。

![abercrombie and fitch asos 重复](https://ahrefs.com/blog/wp-content/uploads/2018/05/abercrombie-and-fitch-asos-duplicate.jpg)

并不是。

还有其他 15 个网站用了一摸一样的文字，也就是说重复内容。

有时候相似产品页面也会饱受重复内容问题的困扰。

比如，产品类似或相同，但是数量不同。

下面是 ASOS 的例子：

![asos 袜子数量不同时的重复](https://ahrefs.com/blog/wp-content/uploads/2018/05/asos-socks-quantities-duplicate.gif)

可以看到，除去数量不同外，所有产品页内容都是雷同的。

不过重复内容并不仅仅是电商网站会出现的问题。

如果你经营一个博客，就会有人未经允许抄袭你的内容。

下面来看一下是否有人抄袭了我们的文章，[SEO 技巧清单](https://ahrefs.com/blog/seo-tips/)。

![seo 技巧一文被抄袭的内容](https://ahrefs.com/blog/wp-content/uploads/2018/05/seo-tips-stolen-content.jpg)

约 17 个结果。

旁注：

注意到我用排除操作符去除了来自 **ahrefs.com** 的结果，保证原创内容不会出现在搜索结果中。我同样排除了关键字 pinterest。因为我看到结果中有太多 Pinterest 结果，实际上和我们的目的无关。我本可以直接排除 pinterest.com (-pinterest.com)，不过 Pinterest 有太多 ccTLDs（国家顶级域名），这个操作符就无效了。所以排除关键字 pinterest 就是最好的清理方法。

大部分都**可能是**内容聚合站。

不过仍然有必要检查一番确保使用了你的内容的人添加了原文链接。

轻松查找被剽窃的内容

**[Content Explorer](https://ahrefs.com/content-explorer) \> In title > 输入网页或博文标题 > 排除自己的网站**

![content explorer 聚合搜索](https://ahrefs.com/blog/wp-content/uploads/2018/05/content-explorer-syndication-search.jpg)

你就会看到和你的网页/博文标题一摸一样的网页（来自我们数据库中超过 9 亿个网页内容）。

这个例子有 5 个结果。

![content explorer 给出 5 个结果](https://ahrefs.com/blog/wp-content/uploads/2018/05/5-results-content-explorer.jpg)

然后在 “Highlight unlinked domains”（高亮没有原文链接的域名） 输入你的域名。

这个操作会高亮出没有回链你的网站。

![高亮没有原文链接的域名](https://ahrefs.com/blog/wp-content/uploads/2018/05/highlight-unlinked-domains.gif)

然后你就可以联系这些网站，要求他们加上你的原文链接了。

补充一点，这个过滤器实际上在域名层面上查找链接，而不是在页面层面。也就是说，这些网站有可能已经在其他页面中加上了原始链接。

### 4. 查找域名下的奇怪文件（你自己可能都忘了）

想要跟踪网站的一切相当困难。

**（对大网站尤其如此）**

所以很容易忘了你上传过的旧文件。

PDF 文件；Word 文档；PPT 演示文稿；文本文件；等等等等。

我们用 `filetype:` 操作符在 **ahrefs.com** 上试试看。

![filetype 操作符 pdf](https://ahrefs.com/blog/wp-content/uploads/2018/05/filetype-operator-pdf.jpg)

旁注：

记住，还可以用 `ext:` 操作符，结果是一样的。

下面是其中的一个文件：

![ahrefs 索引中的 pdf 文件](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-pdf-file-in-index.jpg)

我从来没见过这个东西。你见过吗？

不过我们还能更进一步，不仅仅是 PDF 文件。

通过组合几个操作符，可以一次性得到所有支持的文件类型的结果。

![filetype 操作符检索所有文件类型](https://ahrefs.com/blog/wp-content/uploads/2018/05/filetype-operator-all-types.jpg)

旁注：

filetype 操作符还支持 **.asp， .php， .html** 等格式。

如果你不想让其他人看到这些文件，删除或不索引（noindex）它们。

### 5. 寻找投稿的机会

有太多方法可以找到当合作作者的机会，比如：

![寻找合作作者的操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-operator-write-for-us.jpg)

不过这个方法你已经知道了，对吧？😉

旁注：

对于不太清楚的读者这里再赘述一下，这个方法可以找出所谓的“为我们写作”页面，很多人在积极寻找合作作者的时候会创建这种页面。

还可以更有创造力一点。

首先：不要只使用 “为我们写作”

还可以用：

*   `“become a contributor"` （成为贡献者）
*   `“contribute to”` （为之贡献）
*   `“write for me”` （为我写作）（是的，一些个人博客主也在找合作作者）
*   `“guest post guidelines”` （投稿指南）
*   `inurl:guest-post`
*   `inurl:guest-contributor-guidelines`
*   等等

这里还有一个大多数人都会忽略的小技巧：

你可以一次性搜索所有这些内容。

![寻找合作作者的多关键字操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-multi-search-operator.jpg)

旁注：

是否注意到我用了管道操作符（`|`）而不是 OR？记住，这俩其实是一个东西。🙂

你甚至可以同时搜索多个线索和多个关键字。

![寻找合作作者的多线索和多关键字操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/guestpost-operator-multiple-footprints-and-keywords.jpg)

想寻找指定国家的写作机会？

只需加上 `site:.tld` 操作符

![寻找合作作者的国别域名操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-operators-cctld.jpg)

还有一个思路：

如果你知道系列文章的博主的话，试试这个：

![ryan stewart intext inurl author](https://ahrefs.com/blog/wp-content/uploads/2018/05/ryan-stewart-intext-inurl-author.jpg)

会找到这个人发表作品的所有网站。

旁注：

不要忘了排除作者自己的网站，让结果更清楚！

如何找到更多合作作者的博文

**[Content Explorer](https://ahrefs.com/content-explorer) \> 搜索作者 \> 排除作者自己的网站**

以我们网站的 [Tim Soulo](https://ahrefs.com/tim) 为例。

![用 content explorer 搜索作者](https://ahrefs.com/blog/wp-content/uploads/2018/05/guest-post-author-content-explorer.jpg)

厉害吧。17 个结果。这些都可能是投稿文章。

下面是我输入 Content Explorer 的搜索操作符，供你参考。

`author:”tim soulo” -site:ahrefs.com -site:bloggerjet.com`

基本上就是搜索了 Tim Soulo 的博文。但是同时排除了 ahrefs.com 和 bloggerjet.com（Tim 自己的博客）的结果。

**注意**：有时候会得到错误结果。这取决于你搜索的人名有多常见。

不要止步于此：

你还可以用 Content Explorer 发现你所在领域中还没有链接过你的网站。

**Content Explorer \> 选择主题 \> 每个域名一个文章 \> 高亮未链接过你的域名**

下面就是一个还没有链接到 ahrefs.com 的域名。

![未链接过的域名](https://ahrefs.com/blog/wp-content/uploads/2018/05/unlinked-domains.png)

也就是说 **marketingprofs.com** 还没有链接过我们。

尽管这个搜索不能告诉我们搜索结果中是否有“为我们写作”页面。不过也没有关系。事实是，大多数网站都乐于接受文章投稿，只要你拿得出高质量的内容。所以完全有必要主动伸手联系这些网站。

另外一个使用 [Content Explorer](https://ahrefs.com/content-explorer) 的好处是，你可以看到每个网页的统计数据，包括：

*   \# of RDs（提及的域名数量）;
*   DR（域名排名）;
*   流量统计；
*   社交媒体分享数；
*   等等。

导出这些数据同样很简单。🙂

最后，如果你想知道指定网站是否接受文章投稿，试试这个：

![特定网站是否接受投稿](https://ahrefs.com/blog/wp-content/uploads/2018/05/specific-site-guest-contribution.jpg)

旁注：

你应该尝试更多的搜索关键字——比如，‘这是篇不错的投稿文章’——到括号中。我只写了两个是为了演示时比较简洁。

### 6. 查找加入资源页的机会

“资源页”汇总了特定主题下的最好资源。

下面是一个所谓的“资源页”的样子：

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/broken-link-building.gif)

你看到的所有链接都是指向其他站点的资源。

**（考虑到这个页面的主题（如何修复失效的链接），讽刺的是，它的大部分链接都失效了）**

推荐阅读

*   [A Simple (But Complete) Guide to Broken Link Building](https://ahrefs.com/blog/broken-link-building/)
*   [How to Find and Fix Broken Links (to Reclaim Valuable “Link Juice”)](https://ahrefs.com/blog/fix-broken-links/)

如果你的网站上有很棒的资源，你可以：

1.  寻找有关的资源页
2.  请求加入你的资源

下面是找到资源页的一个方法：

![fitness 资源页操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/fitness-resources-operator.jpg)

不过结果可能大都是垃圾信息。

有一个很棒的方法可以缩小范围：

![fitness resources url title operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fitness-resources-url-title-operator.jpg)

还可以更进一步缩小范围：

![intitle fitness numbers resources operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/intitle-fitness-numbers-resources-operator.jpg)

旁注：

用 `allintitle:` 保证标题同时含有 fitness 和 resources，而且有 5 到 15 的数字。

\#..\# 操作符的说明

我知道你在想什么：

为什么不用 `#..#` 操作符，非得用一连串的数字呢？

好问题！

我们来试一下：

![fail operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fail-operator.gif)

有点乱？问题出在这里：

这个操作符和其他大部分操作符都无法组合工作。

单独使用时都不一定总是有效 —— 它完全就是时好时坏。

所以我建议使用一连串用 OR 或管道操作符（`|`）隔开的数字。

有点啰嗦，不过有效。

### 7. 查找主打信息图的网站…… 这样就可以推销自己的

信息图的名声不太好。

很大可能是不少人只做了不少质量差的廉价信息图，根本没有什么用处，只是为了“吸引链接”。

但是信息图不总是坏的。

下面是信息图的通用策略：

1.  创作信息图
2.  **推销信息图**
3.  被推荐，被链接 (而且被 PR!)

但是要向谁推销信息图呢？

只是你熟悉的领域内的旧网站吗？

**不。**

你需要向那些**实际上**很可能以你的信息图为卖点的网站推销。

最好的办法是寻找曾经以信息图为卖点的网站。

方法如下：

![fitness infographic operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/fitness-infographic-operator.jpg)

旁注：

在搜索中加上最近的时间范围也挺好的，比如最近 3 个月。如果一个网站两年前曾主推信息图，不代表它现在仍然重视信息图。然而如果一个网站最近几个月就在力推信息图的话，他们很可能仍然以此为卖点。不过由于 daterange 操作符已经无效了，你必须使用谷歌搜索内置的过滤器。

不过还是要强调，这个方法可以去除很多垃圾站。

简单总结一下：

1.  用上面的搜索来查找制作精良且相关的信息图（比如设计良好的等等）
2.  查找特定的信息图

举个例子：

![reddit guide to fitness infographic](https://ahrefs.com/blog/wp-content/uploads/2018/05/reddit-guide-to-fitness-infographic.jpg)

会找到最近 3 个月的大概 2 个结果。所有时间的话则有 450 多个结果。

对几个信息图如此搜索一番，就会找到几个不错的潜在目标。

谷歌给的结果不太好？试试这个。

你有没有发现网站如果有信息图的话，站长一般会在标题中加入括号括起来的 infographic？

**比如：**

![infographic title tag](https://ahrefs.com/blog/wp-content/uploads/2018/05/infographic-title-tag.jpg)

不过谷歌搜索会忽略方括号（即使用引号都不行）。

但是 Content Explorer 不会忽略。

**[Content Explorer](https://ahrefs.com/content-explorer) \> search query \> “AND [infographic]”**

![content explorer infographic](https://ahrefs.com/blog/wp-content/uploads/2018/05/content-explorer-infographic.jpg)

可以看到，你可以在 CE 中使用高级搜索操作符来一次性搜索多个词。上面的搜索会找到标题中含有 SEO，keyword search，link building 或者 “[infographic]” 的结果。

同样，结果可以导出（附带相关信息）。

推荐阅读

*   [The Visual Format You Should be Using for Link Building (No, It’s NOT Infographics)](https://ahrefs.com/blog/visual-link-building/)
*   [6 Linkable Asset Types (And EXACTLY How to Earn Links With Them)](https://ahrefs.com/blog/linkable-assets/)
*   [Deconstructing Linkbait: How to Create Content That Attracts Backlinks](https://ahrefs.com/blog/link-bait/)

### 8. 寻求更多链接机会…… 并检查他们的相关性**到底**如何

假设你找到了一个网站，希望可以链接到你。

已经手动检查了相关性，而且结果不错。

下面是查找类似的网站或网页的方法：

![谷歌搜索操作符 related](https://ahrefs.com/blog/wp-content/uploads/2018/05/related-google-search-operator.jpg)

大概有 49 个结果，都是类似的网站。

旁注：

在上例中，我们找的是和 Ahrefs 博客相似的网站，不是和 Ahrefs 整体相似的网站。

想要对特定网页也做类似的操作？没问题

以我们的[链接构建指南](https://ahrefs.com/blog/link-building/)为例。

![related link building 谷歌操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/related-link-building-google-operator.gif)

大概有 45 个结果，大部分都**非常**相似。🙂

这里是其中一个结果：**‌yoast.com/seo-blog**

我和 Yoast 相当熟，所以我知道这是个高度相关的网站。

但是如果我对这个站一点都不了解，要如何检查呢？

方法如下：

1.  搜索 `site:domain.com`，记下结果数量
2.  搜索 `site:domain.com [领域]`，记下结果数量
3.  第二个数除以第一个数，如果大于 0.5，结果不错，比较相关；如果大于 0.75 就说明非常相关。

用 **yoast.com** 试试。

下面是 `site:` 搜索的结果数量：

![yoast simple site search](https://ahrefs.com/blog/wp-content/uploads/2018/05/yoast-simple-site-search.jpg)

`site: [领域]` 的结果数量：

![yoast site niche search](https://ahrefs.com/blog/wp-content/uploads/2018/05/yoast-site-niche-search.jpg)

结果是 **3,950 / 3,330 = ~0.84**。


**（记住，大于 0.75 通常意味着高度相关）**

再用一个我知道不怎么相关的网站，**‌greatist.com**，试一下。

**`site:greatist.com` 的结果数量：约 18,000。**

**`site:greatist.com SEO` 的结果数量：约 7 个。**

**(18,000 / 7 = ~0.0004 = 完全无关的网站)**

**重要提示！**这是个快速评估相关性的好方法，但是不是绝对可靠 —— 有时候会得到奇怪或者完全没有用的结果。我还想强调，没有哪种方法可以完全取代手工检查网站。你总是应该先全面检查网站再和他们取得联系。如果做不到就意味着制造[垃圾邮件](https://ahrefs.com/blog/outreach/)。

还有一个方法查找相似域名…

**[Site Explorer](https://ahrefs.com/site-explorer) \> relevant domain \> Competing Domains**

比如，假设我在找更多和 SEO 相关的链接。

在 Site Explorer 中输入**‌ahrefs.com/blog**

然后勾选 Competing Domains

![competing domains](https://ahrefs.com/blog/wp-content/uploads/2018/05/competing-domains.jpg)

这样就可以找到竞争同一关键字的域名。

### 9. 寻找潜在客户的社交媒体账号

心里已经有了要联系的人选？

试试这个技巧来找到联系信息：

![tim soulo google search social profiles](https://ahrefs.com/blog/wp-content/uploads/2018/05/tim-soulo-google-search-social-profiles.jpg)

旁注：

你需要知道他们的名字。通常在大多数网站上都不难找 —— 只是联系信息可能不太好找。

下面是前 4 个结果：

![tim soulo social profiles](https://ahrefs.com/blog/wp-content/uploads/2018/05/tim-soulo-social-profiles.jpg)

不错。

现在可以在社交媒体上直接联系他们了。

或者用[这篇文章](https://ahrefs.com/blog/find-email-address/)中的第 4 条和第 6 条方法来找到他们的电子邮件地址。

推荐阅读

*   [9 Actionable Ways To Find Anyone’s Email Address [Updated for 2018]](https://ahrefs.com/blog/find-email-address/)
*   [11 Ways to Find ANY Personal Email Address](https://www.youtube.com/watch?v=TZFMRl3Yqwc)

### 10. 寻找内链机会

内链很重要。

可以帮助访问者熟悉你的网站。

还对 SEO 颇有帮助（如果[使用得当](https://ahrefs.com/blog/technical-seo/)的话）。

不过你要确保只有在内容相关时才添加内链。

比如说你刚发表了一个关于 [SEO 技巧](https://ahrefs.com/blog/seo-tips/)的清单。

如果能在其他谈到了 SEO 技巧的博文中插入内链岂不妙哉？

**当然。**

只是要找到相关的地点来加入内链有时比较困难 —— 尤其是对于大网站来说。

不妨试试这个技巧：

![seo tips internal links](https://ahrefs.com/blog/wp-content/uploads/2018/05/seo-tips-internal-links.jpg)

如果你还不太清楚这些搜索操作符的作用，解释如下：

1.  将搜索结果限制在指定网站内；
2.  排除你想加入内链的网页/博文本身；
3.  在内容中查找关键字或词组。

下面就是我找到的一个结果：

![seo tips internal link](https://ahrefs.com/blog/wp-content/uploads/2018/05/seo-tips-internal-link.jpg)

只花了 3 秒钟就找到了。🙂

### 11. 通过搜索提及竞争对手的内容发现公关（PR）机会

下面这个页面提及了我们的一个竞争对手 —— Moz。

![how to use moz](https://ahrefs.com/blog/wp-content/uploads/2018/05/how-to-use-moz.jpg)

通过高级搜索可以找到：

![competitor search](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-search.jpg)

但是为什么没有提 Ahrefs？🙁

用 `site:` 和 `intext:`，可以发现这个网站曾经提过几次我们网站。

![ahrefs mentions](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-mentions.gif)

但是他们没有写任何关于我们的工具集的文章，他们却写了 Moz 的。

这就是个机会。

主动联系，建立关系，**也许**他们会写一写 Ahrefs。

还有一个不错的搜索技巧可以寻找竞争对手的评论：

![allintitle review search google](https://ahrefs.com/blog/wp-content/uploads/2018/05/allintitle-review-search-google.jpg)

旁注：

因为用到了 `allintitle` 而不是 `intitle`，只会返回标题中同时有 “review“ 和竞争对手名字的结果。

你可以和这些人发展关系让他们也评价一下你们的产品/服务。

用 Content Explorer 更进一步

你还可以用 CE 的 “In title” 搜索来寻找对竞争对手的评论

我用 Ahrefs 试了试，有 795 个结果。

![competitor review](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-review.png)

具体来说，我用了这个搜索：

`review AND (moz OR semrush OR majestic) -site:moz.com -site:semrush.com -site:majestic.com`

不过你还可以通过高亮没有链接到的推荐进一步调查。

这会高亮出从来没有链接过你的网站，所以你可以考虑优先联系他们。

下面就是一个从来没有链接过 Ahrefs 的网站，他们却评论过我们的竞争对手：

![hobo web no link](https://ahrefs.com/blog/wp-content/uploads/2018/05/hobo-web-no-link.png)

可以看到这是个域名排名（DR）79 的网站，所以如果能被他们评论再好不过了。

还有一个不错的技巧：

谷歌的 `daterange:` 操作符被废弃了。但是你仍然通过添加时间过滤器来寻找最近对竞争对手的评论。

直接用内置的过滤器就行。

**Tools \> Any time \> select time period**

![daterange filter competitor mention](https://ahrefs.com/blog/wp-content/uploads/2018/05/daterange-filter-competitor-mention.gif)

看上去上个月有大概 34 个关于我们竞争对手的评论。

想实时获得竞争对手评论的提醒吗？可以这样做。

**[Alerts](https://ahrefs.com/alerts) \> Mentions \> Add alert**

输入竞争对手的名字…… 或者随便什么想检索的东西。

选择模式（标题中或者任意地方），添加要排除的域名，输入收件人。

![ahrefs alerts mention](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-alerts-mention.jpg)

将时间间隔设置为实时（或者你喜欢的时间间隔）。

点击“保存”。

现在只要有关于你的竞争对手的评论出现，你就会受到邮件通知。

### 12. 寻找赞助文章机会

赞助贴是宣传你的品牌，产品或服务的收费文章。

并不是构建链接的机会。

[谷歌指导手册](https://support.google.com/webmasters/answer/66356?hl=en)说过：

> **买卖已通过 PageRank 的链接。包括购买链接或含有链接的文章；用商品或服务换链接；或给某人寄送免费产品以求评论并带上链接**

这就是为什么你永远要停止关注（nofollow）赞助文章中的链接。

但是赞助文章的真正价值从来都和链接无关。

它会影响 PR，也就是让你的品牌出现在对的人面前。

下面是用谷歌搜索操作符寻找赞助文章机会的方法：

![sponsored post results](https://ahrefs.com/blog/wp-content/uploads/2018/05/sponsored-post-results.jpg)

大概 151 个结果。还不错。

还有一些组合操作符可用：

*   `[niche] intext:”this is a sponsored post by”`
*   `[niche] intext:”this post was sponsored by”`
*   `[niche] intitle:”sponsored post”`
*   `[niche] intitle:”sponsored post archives” inurl:”category/sponsored-post”`
*   `“sponsored” AROUND(3) “post”`

旁注：

上面的例子就只是**例子**。当然还有其他线索来寻找这类帖子。你还可以试试其他点子。

想知道这些网站的流量如何？这样做。

用这个 [Chrome 书签小工具](https://www.chrisains.com/seo-tools/extract-urls-from-web-serps/)来提取谷歌搜索结果。

**[Batch Analysis](https://ahrefs.com/batch-analysis) \> 粘贴 URLs \> 选择 “domain/\*” 模式 \> 按搜索流量排序**

![batch analysis organic search traffic](https://ahrefs.com/blog/wp-content/uploads/2018/05/batch-analysis-organic-search-traffic.png)

现在你得到了流量最大的网站的清单，通常就意味着最好的机会。

### 13. 查找和你的内容相关的问答帖

论坛和问答网站非常有助于宣传你的内容。

旁注：

宣传不等于制造垃圾邮件。不要只为了加入你的链接就参与垃圾站点。提供有价值的内容，同时，偶尔在回答中放一些自己的链接。

可以想到的一个网站就是 Quora。

你可以在 Quora 的回答中放链接。

![quora answer](https://ahrefs.com/blog/wp-content/uploads/2018/05/quora-answer.jpg)

一个带有 SEO 博客链接的 Quora 答案。

当然这些链接是被设置为 nofollow 的。

不过我们又不是要在这里创建链接 —— 纯粹是为了 PR！

还有一个找到相关帖子的方法：

![寻找 Quora 问答贴的谷歌操作符](https://ahrefs.com/blog/wp-content/uploads/2018/05/find-quora-threads-google-operator.jpg)

不过不要只用 Quora。

任何论坛或问答站点都可以。

对于 Warrior 论坛可以用类似的搜索：

![warrior 论坛帖子搜索](https://ahrefs.com/blog/wp-content/uploads/2018/05/warrior-forum-thread-search.jpg)

我还知道 Warrior 论坛有搜索引擎优化版块。

该版块的每个帖子的 URL 中都有 “.com/search‐engine‐optimization/”。

所以我可以用 `inurl:` 操作符进一步优化搜索结果。

![warrior 论坛 inurl 搜索](https://ahrefs.com/blog/wp-content/uploads/2018/05/warrior-forum-inurl-search.jpg)

我发现用这种搜索操作符得到的论坛帖子搜索结果比大多数站内搜索的粒度都要细致。

还有一个好点子……

**[Site Explorer](https://ahrefs.com/site-explorer) \> quora.com \> Organic Keywords \> 搜索相关关键词**

现在你可以看到按月流量排序的相关 Quora 帖子。

![Screen Shot 2018 05 07 at 19 39 26](https://ahrefs.com/blog/wp-content/uploads/2018/05/Screen_Shot_2018-05-07_at_19_39_26.png)

回答这些帖子会带来不错的推荐流量（referral traffic）。

### 14. 查找竞争对手更新内容的频率

大多数博客都位于子目录或者子域名中。

**例子:**

*   [ahrefs.com/blog](https://ahrefs.com/blog/)
*   blog.hubspot.com
*   blog.kissmetrics.com

鉴于此很容易得到竞争对手更新内容的频率。

以我们的竞争对手 SEMrush 为例。

![competitor blog search](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-search.png)

看上去他们大概有 4500 篇博文。

不过这并不准确。因为包含了同一博客的多语言版本，同样位于子域名内。

![competitor blog subdomains](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-subdomains.png)

过滤一下。

![](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-search.jpg)

这才像话。大概 2200 篇文博文。

现在我们知道竞争对手（SEMrush）总共有大概 2200 篇博文。

现在看看上个月他们发表了多少文章。

因为 `daterange:` 已经不能用了，要用谷歌内置的过滤器。

**Tools \> Any time \> select time period**

![competitor blog posts month](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-blog-posts-month.gif)

旁注：

任何时间段都可以。只需选择“自定义”。

大约 29 篇。有意思。

另外说一句，比我们更新速度快了差不多 4 倍。而且他们文章总数比我们多十五倍。

不过我想补充一句，我们的流量更多，大概是 2 倍。😉

![ahrefs vs competitor](https://ahrefs.com/blog/wp-content/uploads/2018/05/ahrefs-vs-competitor.jpg)

[质量比数量更重要](https://ahrefs.com/blog/increase-blog-traffic/)，对吧！？

还可以用结合 `site:` 操作符的搜索查看竞争对手就某一话题发表的内容数量。

![competitor site topic operator](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-site-topic-operator.gif)

### 15. 查找链接到竞争对手的网站

竞争对手的链接数在增长？

如果你也能获得这些链接呢？

谷歌的 `link:` 操作符在 2017 年被正式废弃了。

不过我发现这个操作符还是会返回一些结果。

![competitor links search](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-links-search.gif)

旁注：

使用这个方法时记得用 `site` 操作符排除掉竞争对手自己的网站。如果不排除掉，他们内部的链接也会被算进来。

大概 90 万个链接。

想看到更多链接吗？

谷歌的数据被严重简化了。

所以也不太准确。

[Site Explorer](https://ahrefs.com/site-explorer) 可以提供关于竞争对手更全面的链接报告。

![competitor backlinks site explorer](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-backlinks-site-explorer.png)

大概 150 万个回链。

这比谷歌的结果多多了。

这也是个说明时间段过滤器很有用的好例子。

过滤只看最近的一个月的结果，我发现 Moz 增加了 18000 多个新回链。

![competitor links month](https://ahrefs.com/blog/wp-content/uploads/2018/05/competitor-links-month.gif)

非常有用吧。不过数据真的很不准确。

Site Explorer 在同时间段发现了 35000 多个链接。

![35k links site explorer](https://ahrefs.com/blog/wp-content/uploads/2018/05/35k-links-site-explorer.png)

基本上**加倍了**！

推荐阅读

*   [7 Actionable Ways to Loot Your Competitors’ Backlinks](https://ahrefs.com/blog/get-competitors-backlinks/)
*   [The Ultimate Guide to Reverse Engineering Your Competitor’s Backlinks](https://ahrefs.com/blog/the-ultimate-guide-to-reverse-engineering-your-competitors-backlinks/)

## 总结

谷歌高级搜索操作符**强大到变态**。

你只需要知道如何使用这些操作符。

不过我得承认，尤其就 SEO 而言，一些操作符比其他的更有用。我基本上每天都在用 `site:`，`intitle:`，`intext:` 和 `inurl:`。不过我很少会用到 `AROUND(X)`，`allintitle:` 以及其他更默默无闻的操作符。

我要补充一点，不少操作符在和其他操作符组合使用时才有用，单独用的话就没什么用了。

放手去玩，试试这些操作符，告诉我你都想到了什么好主意。

我愿意把你发现的操作符组合用法补充到本文中。🙂

![Joshua Hardwick](https://ahrefs.com/blog/wp-content/uploads/2018/04/photo-of-me-425x425.jpg)

[Joshua Hardwick](https://ahrefs.com/blog/author/joshua-hardwick/ "Posts by Joshua Hardwick")

Ahrefs 的内容主管（说人话就是，我的职责就是保证我们的每一篇文章都非常赞）。[The SEO Project](http://www.theseoproject.org) 的创始人。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
