> * 原文地址：[Ten Things you didn't know about WebPageTest.org](https://deanhume.com/ten-things-you-didnt-know-about-webpagetest-org/)
> * 原文作者：[deanhume.com](https://deanhume.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ten-things-you-didnt-know-about-webpagetest-org.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ten-things-you-didnt-know-about-webpagetest-org.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[TUARAN](https://github.com/TUARAN)，[Park-ma](https://github.com/Park-ma)

# 十件你不知道的关于 WebPageTest.org 的事

够标题党吧？既然你点进来了，那我也得说一些干货了！毫无疑问，WebPageTest 是我最喜欢的 Web 性能测试工具之一。它功能强大、完全免费，为世界各地的网页提供测试。

如果你曾经用过 WebPageTest，那你应该知道它是多么的好用：只需要几下点击就能得到你网站加载的详细信息。不过，它还有一些你可能闻所未闻的功能！

最近我在 Santa Clara 参加了 [Velocity Conference](http://conferences.oreilly.com/velocity)，偶遇了 [Pat Meenan](https://github.com/pmeenan)（WebPageTest 的创始人）并问了一些关于 WebPageTest 的问题。在本文中，我将列出 WebPageTest 的 10 个最酷的功能（我自己评的），~~希望你还没有用过它们~~。按照钓鱼文的标准套路，本文章节的标号会从 10 开始数。

## 10. 模拟单点失效

你的网站很可能依赖了一些第三方库来提供额外的功能（包括且不仅限于监控脚本、A/B 测试和广告）。问题就有可能出在这些你使用的部署在别人服务器上的库，这就是[单点失效](https://en.wikipedia.org/wiki/Single_point_of_failure)（SPOF）风险。如果出于某些原因，导致托管这些库的服务器出现故障或响应缓慢，你的网站也会不幸地收到影响。这种事情可能发生在任何人身上！

使用 WebPageTest 模拟单点失效与正常测试网站的设置一模一样，不过你需要将第三方库的域名屏蔽。例如，如果你想对 ccn.com 测试单点失效，可以将以下域名复制并粘贴到 SPOF 选项卡中：

```
cdn3.optimizely.com
a.visualrevenue.com
www.google-analytics.com
pixel.quantserve.com
budgetedbauer.com
```

粘贴好后界面应该如下所示：

![WebPageTest simulate a Single Point of Failure SPOF](https://307a6ed092846b809be7-9cfa4cf7c673a59966ad8296f4c88804.ssl.cf3.rackcdn.com/WebPageTest-TenThings/spof-webpagetest-tab.jpg)

当查看此网站的加载视频时，你会发现 WebPagetest 已经对 SPOF 进行了模拟，导致该网站的加载时间长了不少。在[上述测试](http://www.webpagetest.org/video/compare.php?tests=160705_CE_HJQ,160705_JS_HJR)中，网站最终加载完毕共花了 20 多秒！这个功能是测试你的网站在 SPOF 情况下响应情况的好工具。

## 9. 创建个人 WebPagetest 实例

WebPageTest 公共实例非常方便，你可以免费用它来快速获取需要的信息。不过公共实例有一些限制，比如在某个忙碌的日子里，你可能会需要在排队等待测试结果。如果你将 WebPageTest 用于商业用途，也许需要创建属于自己的私有 WebPageTest 实例。

Pat Meenan 写了一篇名为 [5 分钟上手 WebPagetest 私有实例](http://calendar.perfplanet.com/2014/webpagetest-private-instances-in-five-minutes/)的指南，介绍了在 Amazon EC2 上如何设置自己的实例。代理在所有 EC2 域中以 AMI 的形式提供，如果你需要在公司防火墙内部进行测试，也可以自行配置。

私有实例用起来很方便，因为你可以控制测试的基础架构，并且 API 请求数量没有限制。

## 8. 编写登录脚本

WebPageTest 不仅可以用于测试公开的网站，如果有需要，它也可以通过编写登录网站的脚本测试需要登录的网站。WebPageTest 具有脚本功能，可以自动执行多步测试（比如登录网站和发送电子邮件）。

例如，如果你想为 AOL 网站编写登录步骤的脚本，可以执行类似于以下操作：

```
logData	0

// bring up the login screen
navigate	http://webmail.aol.com

logData	1

// log in
setValue	name=loginId	someuser@aol.com
setValue	name=password	somepassword
submitForm	name=AOLLoginForm
```

请记住不要将重要的登录凭证放在里面！除非你将它们明确设为私有，否则 webpagetest.org 网站上的测试都是公开的。如果你想了解更多有关编写脚本的信息，请查阅此[链接](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/scripting)。

## 7.WebPagetest 发明的 Speed Index 指标

WebPagetest 于 2012 年添加了 Speed Index 指标（速度指数），它可以用于标化页面可视内容的填充速度。你可以尝试将不同的页面相互比较（优化之前与之后、自己的网站与竞品等），并与其他指标（加载时间，开始渲染时刻等）结合，来更好地理解这个对于描述网站性能非常有用的指标。如果你想了解更多有关 Speed Index 的信息，请参阅[此链接](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)。

## 6. 收集自定义指标

WebPageTest 提供了大量有用的统计指标。但你知道吗？你还可以用它来收集你自定义的指标。WebPageTest 可以在测试的最后执行任意的 JavaScript 脚本并收集[自定义指标](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/custom-metrics)。你可以在服务器配置中静态地配置或在每个基础测试进行时配置它。

其实，自定义指标可以覆写内置指标。当你需要通过 JavaScript 验证强制让测试失败时，可以通过自定义指标得到“测试结果”。[HTTP Archive](http://httparchive.org/) 还通过 [自定义指标](https://github.com/HTTPArchive/httparchive/tree/master/custom_metrics) 采集了一些统计数据。

## 5. 将 WebPageTest 整合进你的 CI 测试中

如果你想在每次部署新代码时，都确保新代码不会让你在 Web 性能上的努力前功尽弃，那么 WebPageTest 可以帮上忙！你可以在页面上设置“budget”（预算），如果测试结果超过预算值则会导致测试失败。[Tim Kadlec](https://timkadlec.com/2013/01/setting-a-performance-budget/) 创建了一个有用的 [Grunt任务](https://github.com/tkadlec/grunt-perfbudget)，可以用 WebPagetest 的公开或私有实例对指定的 URL 执行测试。Marcel Duran 还为 NodeJS 创建了一个 [WebPageTest API 包装器](https://github.com/marcelduran/webpagetest-api)，可以让你自定义测试的运行方式。

通过这些方法，每当更新代码时，都能检查网站性能。网页的性能并不是儿戏，而是维系网站生命的重要事项！

## 4. 你可以自定义瀑布图的显示方式

你知道吗？WebPageTest 可以自定义瀑布图的显示方式。运行测试后，单击瀑布图像并向下滚动，可以看到一个“customize waterfall”（自定义瀑布）的链接。

![WebPageTest customize waterfall chart link](https://307a6ed092846b809be7-9cfa4cf7c673a59966ad8296f4c88804.ssl.cf3.rackcdn.com/WebPageTest-TenThings/customize-waterfall-link.jpg)

点击这个链接，可以自定义瀑布图的显示方式。很好用！

![WebPageTest customize the waterfall chart](https://307a6ed092846b809be7-9cfa4cf7c673a59966ad8296f4c88804.ssl.cf3.rackcdn.com/WebPageTest-TenThings/customize-waterfall-webpagetest.jpg)

如果你要在幻灯片里使用瀑布图，这个功能可让你精准地展示需要展示的部分。

## 3. 在测试历史记录中对比多个测试结果

在测试历史记录页面中，你可以查看针对特定实例运行过的测试列表。这个页面可以让你以幻灯片的形式直观地比较多个测试。

![Compare History WebPageTest](https://307a6ed092846b809be7-9cfa4cf7c673a59966ad8296f4c88804.ssl.cf3.rackcdn.com/WebPageTest-TenThings/compare-history.jpg)

选择要进行比较的测试，就能看到一个幻灯片视图，比较所有过去运行过的测试。

![WebPageTest - Compare multiple tests with a filmstrip](https://307a6ed092846b809be7-9cfa4cf7c673a59966ad8296f4c88804.ssl.cf3.rackcdn.com/WebPageTest-TenThings/history-filmstrip-webpagetest.jpg)

需要注意，在运行测试时最好对测试设置标签。这样有助于帮你在历史记录中找到对应的测试，并且在幻灯片、视频视图中显示时也会显示标签。

## 2. 你也可以为 WebPageTest 代码库做贡献

整个 WebPageTest 的代码库都是开源的！代码库位于 [Github](https://github.com/WPO-Foundation/webpagetest)，包括了 Web UI 和可用于在各种浏览器上运行测试的代码。Pat 提到，这个代码库使用的是非常宽松的 BSD 协议，也就是说你可以出于任何的目的（包括商业等用途）使用项目的任何部分。

如果你觉得有些东西可以让社区受益，请务必为这个非常棒的工具做出贡献！

## 1. 检查你的 JavaScript 执行是否导致性能瓶颈

现在 JavaScript 在全世界都非常流行，这也意味着 JavaScript 的执行已经成为了妨碍浏览器性能的一个严重瓶颈。你知道吗？使用 WebPageTest，可以模拟在设备上运行网站，并得到主线程运作的详细情况。

在运行测试前，打开 Chrome 标签，然后勾选“Capture Dev Tools Timeline”（捕获开开发者工具时间轴）。

![Capture JavaScript main thread processing - WebPageTest](https://307a6ed092846b809be7-9cfa4cf7c673a59966ad8296f4c88804.ssl.cf3.rackcdn.com/WebPageTest-TenThings/capture-javascript-webpagetest.jpg)

在测试完成后，点击“Processing Breakdown”（处理详情）按钮，将得到主线程处理过程中的详细视图。通过展示主线程的处理过程的详细情况，可以让你更好地了解网站在真实设备上的确切运行情况。

## 总结

总结：如果你经常使用 WebPageTest，希望这篇文章能帮你了解更多关于它的内容。感谢 [Pat Meenan](http://blog.patrickmeenan.com/) 提供信息并帮忙检查文章！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
