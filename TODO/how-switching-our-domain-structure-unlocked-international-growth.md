> * 原文地址：[How switching our domain structure unlocked international growth](https://medium.com/@Pinterest_Engineering/how-switching-our-domain-structure-unlocked-international-growth-e00c8184d5dd)
> * 原文作者：[Pinterest Engineering](https://medium.com/@Pinterest_Engineering?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-switching-our-domain-structure-unlocked-international-growth.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-switching-our-domain-structure-unlocked-international-growth.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[anxsec](https://github.com/anxsec)，[Xekin-FE](https://github.com/Xekin-FE)

# 如何修改域名来提高国际增长率

Christian Miranda | Growth 部门软件工程师

在 Pinterest 上的 2 亿月活跃用户中，其中有超过半数的用户在美国之外的地方使用我们的 app。为了给全球用户提供更好的服务，我们将持续改进 Pinterest。我们已经将流量转移到了国家代码顶级域名 (ccTLDs)。例如现在服务于德国的是 [www.pinterest.de](http://www.pinterest.de) 而不再是 [www.pinterest.com.](http://www.pinterest.com.) 这里我们将深入讨论如何帮助提高增长的细节，并讨论在整个过程中遇到的一些工程挑战。

### 一切尽在域名中

Pinterest 自 2010 年成立以来，该网站的每一页都托管在 [www.pinterest.com.](http://www.pinterest.com.) 上。上线几年后，为了让我们的内容可以按国家划分并为 Pinterest 提供本地化和相关体验，我们引进了 country 子域名 (如 de.pinterest.com)。这改善了搜索引擎的优化 (SEO) 和总体增长，因为国家子域名在全球搜索结果中排名更高，更多的人群发现了使用他们语言的相关内容。

下一步是实现 ccTLDs。通过调查，我们了解到一些做出改变的网站所呈现中立或负面增长的现象，尽管业界对 ccTLDs 看法是它在许多搜索引擎算法中提供了一个更强烈的地理定位信号，用户可能会点击以本地域名结尾的结果（这会积极影响搜索排名以导致更高的的点击率）。我们想对它们进行测试，观察他们将如何作用于 Pinterest 和我们多样化的内容目录。

### 不仅仅是重定向：切换域名的挑战

从表面上看，这个项目看起来很简单--我们所要做的就是提供我们想要的新的 ccTLDs 并设置重定向来开始给它们流量。然而很明显，修改我们网站的顶级域名需要对我们的基础设施进行重大的改变。

#### 跨域认证

Pinterest 上的身份验证非常标准。我们有一个处理用户名/密码注册的内部用户服务，对那些第三方（如 Facebook）认证采用 OAuth 开放标准。我们会在用户每次访问 [www.pinterest.com.](http://www.pinterest.com) 时，取回后端返回的令牌并对其进行身份验证。

随着 ccTLDs 的引入，我们需要支持对用户进行身份验证的功能，无论他们访问的是哪个域名。我们的解决方案是建立一个域名中心（accounts.pinterest.com）作为所有登录的唯一验证源。

![](https://cdn-images-1.medium.com/max/800/0*xGzaLMrxl2YDvYf7.)

简而言之，Pinterest ccTLDs 与域名中心通信以确定身份验证状态，并设置客户端 cookie 来提供镜像。下一节将描述这种通信，我们称之为 auth 握手。

#### auth 握手

握手的一般流程是：

1.在注册或登录期间，将从访问域 (例如，[www.pinterest.abc)](http://www.pinterest.abc%29) 调用 API 以确定身份验证状态。
2.如果用户登录了 accounts.plnterest.com,他们将自动登录 [www.pinterest.abc.](http://www.pinterest.abc)。
3.如果用户没有登录 accounts.pintertst.com,我们将生成一个访问令牌，并在这两个域名上的 cookie 中设置它，这引导了域名中心的后续访问，因此可以进行第二步。 

第一步中存在一个问题：同源策略规定“只有当两个网页同源时，一个网页上的脚本才可以访问另一个网页上的数据。”这是互联网安全的支柱，也是阻止恶意网站上 JavaScript 访问个人或敏感信息的手段。在 auth 握手情况下，由于域名不匹配（例如 pinterest**.com** 和 pinterest**.abc**），Pinterest ccTLDs 无法与 accounts.pinterest.com 通信。

为了解决这个问题，我们使用了跨域资源共享（CORS），它为 web 服务器提供跨域访问控制，以支持数据跨域传输安全。这是通过在数据传输中向 HTTP 请求和响应添加 CORS 特定的（响应）头来完成的，并相应地处理它们。

#### 在握手中使用 CORS

我们通过使用 auth 握手在 [www.pinterest.de](http://www.pinterest.de) 上注册 Pinterest 的简化示例来完成这个过程。首先，客户端指定它要使用用户的凭据向 accounts.pinterest.com 提出跨域请求。此时浏览器会自动向请求中添加一个 Origin header，并指定当前域名。

![](https://cdn-images-1.medium.com/max/800/0*-pGIuaxTVuwL0Ckm.)

当请求到达服务器时，我们创建访问令牌，并在 accounts.pinterest.com 上进行用户身份验证。一旦用户登录，握手就会在响应中向客户端发回一个自定义令牌。此令牌可交换为 [www.pinterest.de](http://www.pinterest.de) 可用于身份验证的访问令牌。

服务器跟踪所有 ccTLDs 用于身份验证的白名单。在返回响应之前，我们要检查 Origin request 报头值是否已经存在于白名单中。如果是这样，服务器将添加特殊的 CORS 响应报头。这些报头中最重要的是 Access-Control-Allow-Origin，该报头的存在将向客户端发出是否允许跨域传输的询问信息。

![](https://cdn-images-1.medium.com/max/800/0*3AzyMrdmfwNNLXux.)

当客户端接受到响应时，它会看到 Access-Control-Allow-Origin 的报头值“https://www.pinterest.de”。因为这和客户端同源，所以会继续处理响应。自定义令牌被检索并用于获取访问令牌，允许用户登录 [www.pinterest.de.](http://www.pinterest.de)。

![](https://cdn-images-1.medium.com/max/800/0*p3ob8BR1Q6b4vY72.)

您可以在[ Mozilla 官方文档](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)中阅读到更多关于跨域资源共享和这些请求所涉及的所有抱头内容。

#### 通过 SEO 提高可发现性

一旦我们建立了新的本地域名，下一步就是帮助它们更容易被发现。引导通信量的最简单方法之一是实现对新域名的重定向。在适合情况下，我们使用永久性 (301) 重定向，从旧的现有国家子域名重定向到新的相关 ccTLDs (例如 de.pinterest.com → [www.pinterest.de).](http://www.pinterest.de%29)。使用永久性重定向允许我们将旧域名上的大部分网页排名和权限转移到新的域名中。

我们还使用了一些间接方法来提高新的 ccTLDs 流量质量。Hreflangs 是可以包含在网页标记中的属性，用于告诉爬虫关于其不同语言版本的信息。当搜索引擎看到这个标记时，他们会根据搜索者的区域设置显示与本地相关的页面。我们还使用名为 sitemaps 的文件来帮助提高搜索引擎爬行站点的效率和速度。Sitemaps 是用来列出您网站的网页并告诉搜索引擎您的内容组织结构的文件。通过将这些文件直接提供给搜索机器人，它们可以更容易地找到新的内容来进行爬取和排序。

### 结论

到目前为止，我们已经观察到在我们推出的国家，流量有了积极的增长，点击率和浏览量也有所增加。在这个过程中，一个更有趣的发现是我们可以索引更多的页面，因为不同的顶级域名为搜索机器人打开了一个单独的“爬行预算”。

展望未来，我们将继续在 ccTLDs 中为我们的国际内容投资，并正研究进一步增强 accounts.pinterest.com 作为所有 Pinterest 属性中心的认证中心。

* * *

![](https://cdn-images-1.medium.com/max/800/1*VS-SIyipZqIIfQYxAvva3A.png)

**鸣谢： Devin Lundberg, Josh Enders, Sam Meder, Jess Males, Evan Jones, Jeff Avery, Grey Skold, Julie Trier, Vadim Antonov, Kynan Lalone, Evelyn Obamos 和 International 团队**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
