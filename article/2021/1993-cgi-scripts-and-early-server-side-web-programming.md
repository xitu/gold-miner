> * 原文地址：[1993: CGI Scripts and Early Server-Side Web Programming](https://webdevelopmenthistory.com/1993-cgi-scripts-and-early-server-side-web-programming/)
> * 原文作者：[ricmac](https://webdevelopmenthistory.com/author/richardricmac-org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/1993-cgi-scripts-and-early-server-side-web-programming.md](https://github.com/xitu/gold-miner/blob/master/article/2021/1993-cgi-scripts-and-early-server-side-web-programming.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/Hoarfroster)
> * 校对者：

# 1993 年 CGI 脚本和早期服务端 Web 编程

![头图](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/1993_cgi_mosaic.jpg)

在 [JavaScript 被发明](https://webdevelopmenthistory.com/1995-the-birth-of-javascript/)的几年前，一个叫做通用网关接口（CGI）的规范为网页提供了一种早期的交互性形式。不过 JavaScript 是在浏览器内部（也就是客户端）执行交互任务，而 CGI 脚本则是借助服务器上的外部程序（服务器端的程序）运行的。CGI 脚本在服务器上执行后，结果会以 HTML 代码的形式发回给原网页。因此，虽然 CGI 脚本不像是 JavaScript 那样作为浏览器中的动态组件，但它确实允许 1993 年和 1994 年的早期网络用户、开发者运行交互式程序。因此在很多方面是 CGI —— 而不是 JavaScript —— 是网络应用的真正开始。

1993 年，CGI 在美国国家超级计算应用中心（NCSA）被发明出来，开创性的 Mosaic 网络浏览器也起源于此。Rob McCool 率先编写了 CGI 规范，作为他创建 [NCSA HTTPd](https://en.wikipedia.org/wiki/NCSA_HTTPd) 的后续工作 —— 世界上最早的网络服务器之一，也是开源 Apache 网络服务器的直接祖先。

他的想法是为不同的网络服务器（1993 年活跃的其他服务器包括 Tim Berners-Lee 的 CERN httpd 和 Tony Sanders 的 Plexus 服务器）创建一个通用的规范，这样通过网页启动的软件程序就可以在任何服务器上运行，并将结果发回网页。

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/ncsa_http_homepage_april97-1024x704.jpg)

[NCSA HTTPd 主页](https://web.archive.org/web/19970414055941/http://hoohoo.ncsa.uiuc.edu/)，截图于 1997 年 4 月。

## CGI 的发明

1993 年 11 月 17 日，McCool 在 www-talk 邮件列表中[发送了一条消息](http://1997.webhistory.org/www.lists/www-talk.1993q4/0518.html)。

> "我已经花了一些时间为服务器网关接口写了一份正式的规范，而我希望大家能对这份规范作一些评论和建议。这是通用网关协议（Common Gateway Protocol）或 CGP 的初步规范。本规范所定义的版本将是 CGP/1.0。"

几天后，在邮件列表中得到一些初步反馈后，[McCool 写道](http://1997.webhistory.org/www.lists/www-talk.1993q4/0540.html)。=：

> "我想了想，这并不是一个真正的协议，而是一个接口，你们觉得把它改成 CGI/1.0 怎么样？"

在有人对"网关"一词有所小抱怨时，[McCool 澄清说](http://1997.webhistory.org/www.lists/www-talk.1993q4/0563.html)，它指的是"一个连接外部服务器程序的接口，允许你与你通常可能无法访问的服务对接"。

更具体地说，它指的是将一个 Web 服务器连接到一个传统的信息系统--比如数据库。因此，执行 CGI 程序的服务器就是允许在网页上使用（例如）数据库的信息的"网关"。[换一种说法](https://stackoverflow.com/questions/2089271/what-is-common-gateway-interface-cgi)，CGI 告诉 Web 服务器如何向应用程序传递数据和从应用程序传递数据。

用现代术语来说，我们可以把 CGI 看作是一个应用程序接口（API）。所以从这个意义上说，正如[一份教程](http://www.whizkidtech.redprince.net/cgi-bin/tutorial)所说的那样，"CGI 就是 Web 服务器的 API"。

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/cgi1-1024x733.png)

通过超链接启动的 CGI 程序；[图源 Michael Grobe](http://condor.cc.ku.edu/~grobe/docs/forms-intro.shtml)，堪萨斯大学的"1994年的某个时候"

到 [1993 年 12 月初](http://1997.webhistory.org/www.lists/www-talk.1993q4/0685.html)，McCool "将CGI规范写成了一套HTML文件，网址是http://hoohoo.ncsa.uiuc.edu/cgi/"。虽然该网页早已从网上消失，但 Wayback Machine 有一份 [1997 年 4 月](https://web.archive.org/web/19970414060000/http://hoohoo.ncsa.uiuc.edu/cgi/)的副本。在那里我们可以看到 McCool 如何为世界定义 CGI。

> "通用网关接口，或者说 CGI，是一个外部网关程序与信息服务器（如 HTTP 服务器）接口的标准。"

在附带的[介绍](https://web.archive.org/web/19971210170704/http://hoohoo.ncsa.uiuc.edu/cgi/intro.html)中，McCool 声称"对于你可以挂到Web上的东西，真的是没有限制的"，尽管他补充了一个注意事项。

> "你唯一需要记住的是，无论你的CGI程序做什么，都不应该花太多时间去处理。否则，用户只会盯着他们的浏览器，等待一些事情发生。"

因为 CGI 脚本是可执行的，所以它们通常被放在一个特殊的文件夹里面。正如 McCool 所解释的那样，这是 "为了让 Web 服务器知道要执行程序，而不是仅仅将其显示给浏览器"。这也使得网站管理员能够锁定文件夹，以防止人们创建有潜在危险的 CGI 脚本。McCool 建议文件夹名称为 *cgi-bin*，而这很快就成为了标准。在 90 年代以后，像 `http://www.example.com/cgi-bin/helloworld.pl` 这样的 URL 变得很常见。

## Perl Scripts Proliferate

McCool’s [specification](https://web.archive.org/web/19971210170807/http://hoohoo.ncsa.uiuc.edu/cgi/interface.html), CGI/1.1, was soon put to use by the early users of the world wide web. Takeup was helped by the fact that developers could use any programming language to write CGI scripts. McCool listed some in his introduction:

- C/C++
- Fortran
- PERL
- TCL
- Any Unix shell
- Visual Basic
- AppleScript

In practice though, many CGI applications were written in the scripting language, Perl (this is partly why they came to be known as CGI scripts). Indeed, Perl had a big influence on the creation of CGI, as explained in [this 2016 article](https://opensource.com/life/16/11/perl-and-birth-dynamic-web) by Michael Stevenson on opensource.com. He referenced Jim Davis’ [Gateway to the U Mich Geography server](https://lists.w3.org/Archives/Public/www-talk/1992NovDec/0060.html), released to the WWW-talk mailing list in November 1992:

> “Davis’s script, written in Perl, was a kind of proto-Web API, pulling in data from another server based on formatted user queries.”

The first use cases for CGI were, unsurprisingly, focused on connecting an application to a database. So CGI was used to create things like a contact form, a guest book, a survey, or a search box. Anything that required user input, prompting a round trip from web page to database and back to the web page again, was a good candidate for CGI use.

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/cgi2-1024x742.png)

Example of CGI being used via an online form; image by Michael Grobe

Here’s the above diagram explained in [an introductory article](http://condor.cc.ku.edu/~grobe/docs/forms-intro.shtml) written sometime in 1994 at The University of Kansas:

> “In this diagram, the Web client running on Computer A acquires a form from some Web server running on Computer B. It displays the form, the user enters data, and the client sends the entered information to the HTTP server running on Computer C. There, the data is handed off to a CGI program which prepares a document and sends it to the client on Computer A. The client then displays that document.”

Similar to JavaScript, CGI scripts could be copied and pasted into websites by non-programmers. So if you needed a contact form, you’d search the web until you found a CGI script that enabled that. Usually it was a Perl script and over time websites like [Matt’s Script Archive](https://web.archive.org/web/19980709151514/http://scriptarchive.com/) emerged to provide these code snippets.

[Matt Wright](https://web.archive.org/web/19970130232402/http://www.worldwidemart.com/mattw/) was a high school student in Fort Collins, Colorado, when he started Matt’s Script Archive in 1995. One of his most popular scripts was a contact form called [FormMail](http://www.scriptarchive.com/formmail.html), which was written in Perl and described as “a generic HTML form to e-mail gateway that parses the results of any form and sends them to the specified users.” Unfortunately though, FormMail was inherently insecure and was soon exploited by spammers to send junk mail.

![](https://webdevelopmenthistory.com/wp-content/uploads/2021/03/matts_script_archive98-1024x754.jpg)

[Matt’s Script Archive](https://web.archive.org/web/19980709151514/http://scriptarchive.com/), July 1998 version

FormMail highlights a problem with CGI scripts in those early years: because by design they enabled random web users to run programs on your server, these scripts [could easily be hacked](https://web.archive.org/web/20020221182749/http://datacreek.net/webgear/tips/fmailspam.html) if clumsily written. If thousands of other website owners then copied and pasted that same code, it would became a widespread security issue (which happened with FormMail). As a user of [a computer programming forum](http://computer-programming-forum.com/53-perl/f47edf76a5dbbfa4.htm) rather bluntly put it, in a discussion about Wright’s scripts:

> “…the vast majority of people downloading and implementing these scripts have no programming knowledge of their own and, as such, are ‘blissfully’ ignorant of the security risks, Y2K bugs, and the frequent total lack of proper error handling.”

Eventually, members of the Perl community started a website called [Not Matt’s Scripts](http://nms-cgi.sourceforge.net/) to provide alternatives to Wright’s increasingly popular CGI scripts. That website was last updated in 2004. Interestingly, [Matt’s Script Archive](http://www.scriptarchive.com/) lasted five more years (although it now includes security warnings).

## Conclusion

One of the themes of web development in the mid-1990s, which I have explored in previous posts about Netscape and Microsoft, is the increasing complexity of web applications. The frontend (the web browser) was increasingly being connected to backend technologies, including the OS in Microsoft’s case. [By 1997](https://webdevelopmenthistory.com/1997-netscape-crossware-vs-the-windows-web/), Netscape was pushing a concept called “crossware” (which Marc Andreessen defined as “on-demand applications that run across networks and operating systems”), and meanwhile Microsoft was building out its Windows-integrated ActiveX technologies.

But CGI in many ways routed around this movement towards complexity, by providing an easy way to access backend functionality via a web page. The “gateway” was really just that — a virtual pipe from the browser to a server, that executed a script and then sent the result back to the browser. This simplicity enabled influential 1990s websites like Yahoo!, eBay and Craigslist to flourish, without necessarily needing to buy into either of Netscape or Microsoft’s vision for the web.

But another theme of web development is that things don’t stay still for long! 1994 saw the emergence of a new scripting language that was based on CGI: [PHP](https://www.php.net/manual/en/history.php.php), which initially stood for “Personal Home Page Tools.” Over time, PHP became a replacement for Perl CGI scripts in many cases. I’ll delve into *that* story in the next post in this series about server-side web development.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
