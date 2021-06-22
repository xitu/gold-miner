> * 原文地址：[1993: CGI Scripts and Early Server-Side Web Programming](https://webdevelopmenthistory.com/1993-cgi-scripts-and-early-server-side-web-programming/)
> * 原文作者：[ricmac](https://webdevelopmenthistory.com/author/richardricmac-org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/1993-cgi-scripts-and-early-server-side-web-programming.md](https://github.com/xitu/gold-miner/blob/master/article/2021/1993-cgi-scripts-and-early-server-side-web-programming.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)、[Chorer](https://github.com/Chorer)

# 1993 年的 CGI 脚本和早期服务端 Web 编程

![头图](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/1993_cgi_mosaic.jpg)

在 [JavaScript 诞生](https://webdevelopmenthistory.com/1995-the-birth-of-javascript/)的几年前，一个叫做通用网关接口（CGI）的规范为网页提供了一种早期的交互形式。不同于在浏览器内部（也就是客户端）执行交互任务的 JavaScript，CGI 脚本是借助服务器上的外部程序（服务器端的程序）运行的。CGI 脚本在服务器上执行后，结果会以 HTML 代码的形式发回给原网页。因此，虽然 CGI 脚本不像 JavaScript 那样作为浏览器中的动态组件，但它确实允许那些早期的互联网使用者和开发者在 1993 年和 1994 年运行交互式程序。从很多方面来看，Web 应用应该起源于 CGI，而不是 JavaScript。

CGI 于 1993 年诞生于美国国家超级计算应用中心（NCSA），开创性的 Mosaic 网络浏览器也起源于此。Rob McCool 率先编写了 CGI 规范，作为他创建 [NCSA HTTPd](https://en.wikipedia.org/wiki/NCSA_HTTPd) 的后续工作 —— 这是世界上最早的 Web 服务器之一，也是开源 Web 服务器 Apache 的鼻祖。

他的想法是为不同的 Web 服务器（1993 年活跃的其他服务器包括 Tim Berners-Lee 的 CERN httpd 和 Tony Sanders 的 Plexus 服务器）创建一个通用的规范，这样通过网页启动的程序就可以在任何服务器上运行，并将结果发回网页。

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/ncsa_http_homepage_april97-1024x704.jpg)

[NCSA HTTPd 主页](https://web.archive.org/web/19970414055941/http://hoohoo.ncsa.uiuc.edu/)，截图于 1997 年 4 月。

## CGI 的发明

1993 年 11 月 17 日，McCool 在 www-talk 邮件列表中[发送了一条消息](http://1997.webhistory.org/www.lists/www-talk.1993q4/0518.html)。

> "我已经花了一些时间为服务器网关接口写了一份正式的规范，而我希望大家能对这份规范给出一些评论和建议。这是通用网关协议（Common Gateway Protocol）或 CGP 的初步规范。本规范所定义的版本将是 CGP/1.0。"

几天后，在邮件列表中得到一些初步反馈后，[McCool 写道](http://1997.webhistory.org/www.lists/www-talk.1993q4/0540.html)：

> "我想了想，这并不是一个真正的协议，而是一个接口，你们觉得把它改成 CGI/1.0 怎么样？"

有人对"网关"一词持反对态度，[McCool 解释说](http://1997.webhistory.org/www.lists/www-talk.1993q4/0563.html)，它指的是"一个连接外部服务器程序的接口，允许你与通常可能无法访问的服务对接"。

更具体地说，它指的是将一个 Web 服务器连接到一个传统的信息系统 —— 比如数据库。因此，执行 CGI 程序的服务器就是允许在网页上使用（例如）数据库的信息的"网关"。[换一种说法](https://stackoverflow.com/questions/2089271/what-is-common-gateway-interface-cgi)，CGI 告诉 Web 服务器如何用应用程序收发数据。

用现代术语来说，我们可以把 CGI 看作是一个应用程序接口（API）。所以从这个意义上说，正如[一份教程](http://www.whizkidtech.redprince.net/cgi-bin/tutorial)所说的那样，"CGI 就是 Web 服务器的 API"。

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/cgi1-1024x733.png)

通过超链接启动的 CGI 程序；[图源 Michael Grobe](http://condor.cc.ku.edu/~grobe/docs/forms-intro.shtml)，堪萨斯大学的"1994 年的某个时候"

到 [1993 年 12 月初](http://1997.webhistory.org/www.lists/www-talk.1993q4/0685.html)，McCool "将 CGI 规范写成了一套 HTML 文件，网址是 http://hoohoo.ncsa.uiuc.edu/cgi/"。虽然该网页早已从网上消失，但 Wayback Machine 有一份 [1997 年 4 月](https://web.archive.org/web/19970414060000/http://hoohoo.ncsa.uiuc.edu/cgi/)的副本。在那里我们可以看到 McCool 如何定义 CGI。

> "通用网关接口，或者说 CGI，是一个外部网关程序与信息服务器（如 HTTP 服务器）接口的标准。"

在附带的[介绍](https://web.archive.org/web/19971210170704/http://hoohoo.ncsa.uiuc.edu/cgi/intro.html)中，McCool 声称"对于你可以上传到 Web 上的东西，真的是没有限制的"，但他同时也补充了一个注意事项：

> "你唯一需要记住的是，无论你的 CGI 程序做什么，都不应该花太多时间去处理。否则，用户只会盯着他们的浏览器，等待一些事情发生。"

因为 CGI 脚本是可执行的，所以它们通常被放在一个特殊的文件夹里面。正如 McCool 所解释的那样，这是"为了让 Web 服务器知道要执行程序，而不是仅仅将其显示给浏览器"。这也使得网站管理员能够锁定文件夹，以防止人们创建有潜在危险的 CGI 脚本。McCool 建议文件夹名称为 **cgi-bin**，而这很快就成为了标准。在 90 年代以后，像 `http://www.example.com/cgi-bin/helloworld.pl` 这样的 URL 变得很常见。

## Perl 脚本蓬勃发展

McCool 的[规范](https://web.archive.org/web/19971210170807/http://hoohoo.ncsa.uiuc.edu/cgi/interface.html)，即 CGI/1.1，很快就被万维网的早期用户所采纳。开发者可以使用任何编程语言来编写 CGI 脚本，这也促进了它的使用。McCool 在他的介绍中列出了一些支持的语言：

- C/C++
- Fortran
- PERL
- TCL
- 任何的 Unix shell
- Visual Basic
- AppleScript

但实际上，许多 CGI 应用程序是用脚本语言 Perl 编写的（这也是它们被称为 CGI 脚本的部分原因）。事实上，Perl 对 CGI 的创建有很大的影响，正如 Michael Stevenson 在 openource.com 上的[这篇 2016 年的文章](https://opensource.com/life/16/11/perl-and-birth-dynamic-web)所解释的那样。他引用了 Jim Davis 的 [Gateway to the U Mich Geography server](https://lists.w3.org/Archives/Public/www-talk/1992NovDec/0060.html) 一文（于 1992 年 11 月发布到 WWW-talk 邮件列表中）：

> "戴维斯的脚本是用 Perl 写的，实现了一种原始的 Web API，根据格式化的用户查询从另一个服务器上获取数据。"

毫不奇怪，CGI 的第一个用例是专注于将一个应用程序连接到数据库上。因此，CGI 被用来创建像联系表、留言簿、调查或搜索框这样的东西。任何需要用户输入并促使用户从网页到数据库再回到网页的东西，都是使用 CGI 的好选择。

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/cgi2-1024x742.png)

通过在线表格使用 CGI 的例子，图片由 Michael Grobe 提供。

这是 1994 年堪萨斯大学写的一篇[介绍性文章](http://condor.cc.ku.edu/~grobe/docs/forms-intro.shtml)中对上述图表的解释：

> 在这张图中，运行在计算机 A 上的 Web 客户端从运行在计算机 B 上的某个 Web 服务器上获取了一个表单。它会显示该表单，用户输入数据，然后客户端将输入的信息发送到运行在计算机 C 上的 HTTP 服务器上。

与 JavaScript 类似，CGI 脚本可以由非程序员复制并粘贴到网站中。因此，如果你需要一个联系表格，你就会在网上搜索，直到找到一个可以实现这个功能的 CGI 脚本。通常它是一个 Perl 脚本，随着时间的推移，出现了像 [Matt's Script Archive](https://web.archive.org/web/19980709151514/http://scriptarchive.com/)这样的网站来提供这些代码片段。

[Matt Wright](https://web.archive.org/web/19970130232402/http://www.worldwidemart.com/mattw/) 在 1995 年创办 Matt's Script Archive 时，还是科罗拉多州柯林斯堡的一名高中生。他最受欢迎的脚本之一是一个名为 [FormMail](http://www.scriptarchive.com/formmail.html) 的联系表格，该脚本用 Perl 编写，被描述为"一个通用的 HTML 表格连接到电子邮件网关的脚本，支持解析任何表格的结果，并将它们发送给指定的用户"。不过不幸的是，FormMail 本身就不安全，很快就被垃圾邮件发送者利用来发送垃圾邮件。

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/matts_script_archive98-1024x754.jpg)

[Matt's Script Archive](https://web.archive.org/web/19980709151514/http://scriptarchive.com/)，1998 年 7 月版。

FormMail 强调了早年 CGI 脚本的一个问题：由于设计上它们允许让随机的网络用户在你的服务器上运行程序，因此如果脚本编写得不好，就[很容易被黑客攻击](https://web.archive.org/web/20020221182749/http://datacreek.net/webgear/tips/fmailspam.html)。如果成千上万的其他网站所有者复制和粘贴同样的代码，这将成为一个广泛的安全问题（FormMail 就发生过这个问题）。正如[某个计算机编程论坛](http://computer-programming-forum.com/53-perl/f47edf76a5dbbfa4.htm)的一位用户在讨论 Matt Wright 的脚本时相当直白地说：

> "绝大多数下载和运行这些脚本的用户并不具备任何编程知识，因此，他们缺乏对安全风险、Y2K bug 的认知，以及经常出现无法应对错误处理。"

最终，Perl 社区的成员创办了一个名为 [Not Matt's Scripts](http://nms-cgi.sourceforge.net/) 的网站，为 Matt Wright 那日益流行的 CGI 脚本们提供替代品。该网站最后一次更新是在 2004 年。有趣的是，[Matt's Script Archive](http://www.scriptarchive.com/) 的程序什么的更新持续了五年（尽管它现在包含安全警告）。

## 结语

我在以前关于 Netscape 和微软的文章中探讨过 90 年代中期 web 开发的主题之一，就是 web 应用的复杂性越来越高。前端（web 浏览器）越来越多地与后端技术相连，包括微软的操作系统。[到 1997年](https://webdevelopmenthistory.com/1997-netscape-crossware-vs-the-windows-web/)，Netscape 推行了一个叫做 "crossware" 的概念（Marc Andreessen 将其定义为"跨网络和操作系统运行的按需应用程序"），与此同时，微软正在建立其与 Windows 集成的 ActiveX 技术。

但是 CGI 提供了一种简单的方式来通过网页访问后端功能，从而在很多方面都绕开了这种复杂化的运动。网关"实际上只是一个从浏览器到服务器的虚拟管道，它可以执行一个脚本，然后将结果送回浏览器。这种简单性使得 20 世纪 90 年代有影响力的网站，如 Yahoo!、eBay 和 Craigslist 等得以摆脱 Netscape 或微软，获得蓬勃的发展。

但网络发展的另一个主题是，事物不会静止太久! 1994 年出现了一种新的脚本语言，它是基于 CGI 的 —— [PHP](https://www.php.net/manual/en/history.php.php)，一个名字最初是"个人主页工具 "的意思的语言。随着时间的推移，PHP 在很多情况下成为了 Perl CGI 脚本的替代品。我将在本系列关于服务器端 Web 开发的下一篇文章中深入探讨*这个故事*。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
