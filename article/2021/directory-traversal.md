> - 原文地址：[Directory Traversal Attacks](https://www.acunetix.com/websitesecurity/directory-traversal/)
> - 原文作者：[Acunetix](https://www.acunetix.com/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/directory-traversal.md](https://github.com/xitu/gold-miner/blob/master/article/2021/directory-traversal.md)
> - 译者：[MoonBall](https://github.com/MoonBall)
> - 校对者：[kamly](https://github.com/kamly)、[江不知](http://jalan.space/)

# 目录遍历攻击

## 什么是目录遍历攻击？

运行一个安全的网站服务最重要的是，需要合理地限制用户可访问的网站内容。目录遍历或[路径遍历](https://www.acunetix.com/blog/articles/path-traversal/)是一种 HTTP 攻击方式，攻击者可利用它们访问不公开的目录，以及在网站服务根目录之外执行命令。

网站服务提供了两种主要的安全机制：

- 访问控制列表（ACLs）
- 服务根目录

访问控制列表用于授权流程中。网站服务管理员通过它表明哪些用户或用户组能在服务器上访问、修改或执行特定文件，也可以将它用于控制其他访问权限。

![什么是目录遍历攻击？](https://www.acunetix.com/wp-content/uploads/2012/10/PTMFOG00000002841.gif "目录遍历攻击")

服务根目录是一个在服务器文件系统中指定的目录，用户被限制在该目录中。用户不能访问服务根目录以外的任何内容。

例如：Windows 系统中 IIS 的默认服务根目录是 `C:\Inetpub\wwwroot`。当使用该默认设置时，用户不能访问 `C:\Windows`，但可以访问 `C:\Inetpub\wwwroot\news` 和任何在服务根目录之下的目录和文件（前提是，用户已经通过了访问控制列表（ACLs）的授权）。

服务根目录阻止用户访问服务器上的其他任何文件，比如 Windows 系统中的 `C:\WINDOWS/system32/win.ini` 文件和 Linux/UNIX 系统中的 `/etc/passwd` 文件。

目录遍历漏洞可能存在于网站服务器软件中，也可能存在于网站应用代码中（译者注：网站服务器软件指 IIS 或 Apache 这类服务端框架）。

攻击者只需要一个浏览器，并知道在什么位置可以找到系统中存在的默认文件和目录，就可以发起目录遍历攻击。

## 攻击者能利用目录遍历漏洞做什么

如果一个系统存在目录遍历漏洞，攻击者可利用该漏洞绕过服务根目录的限制，访问文件系统中的其他部分。这样攻击者就有可能查看受限制的文件。通过这些文件提供的更多信息，攻击者可以对系统做进一步攻击。

根据网站访问权限的设置方式，攻击者将伪装成与“网站服务”相关的用户，并执行命令。因此攻击者能做什么，完全取决于网站用户在系统中有哪些访问权限。（译者注：与“网站服务”相关的用户是指网站服务执行命令时的操作系统用户。比如查看某文件时，需要服务器执行查看命令时，对应的操作系统用户有该文件的读权限。）

## 利用网站应用代码漏洞发起目录遍历攻击的例子

在动态页面的网站应用中，服务端的输入通常是浏览器通过 GET 或 POST 请求发送给服务器的。以下是关于 HTTP GET 请求的例子：

```
GET http://test.webarticles.com/show.asp?view=oldarchive.html HTTP/1.1
Host: test.webarticles.com
```

浏览器通过这个 URL，向服务器请求 `show.asp` 动态页面，并发送值为 `oldarchive.html` 的 `view` 参数。当网站服务器处理该请求时，`show.asp` 将从服务器的文件系统中查看 `oldarchive.html` 文件。服务器渲染 `oldarchive.html` 后，将它发送给浏览器，浏览器最终将其展示给用户。基于此流程，攻击者将假设 `show.asp` 能从文件系统中遍历文件，然后发送以下自定义的 URL：

```
GET http://test.webarticles.com/show.asp?view=../../../../../Windows/system.ini HTTP/1.1
Host: test.webarticles.com
```

该 URL 使动态页面从文件系统中访问 `system.ini` 文件，并将它展示给用户。URL 中的 `../` 作为常用的操作系统命令，用于访问上级目录。尽管攻击者必须猜测出，需要向上多少个上级目录才能找到 `Windows` 目录。但通过试错法，很容易就能得出结果。

## 利用网站服务器漏洞发起目录遍历攻击的例子

除了应用代码中存在的漏洞外，网站服务器软件也可能存在漏洞。漏洞可能存在网站服务器软件代码中，也可能存在于服务器上可访问的示例脚本文件中。

尽管最新版本的网站服务器软件已经修复了这些漏洞，但线上的网站服务可能仍然使用存在漏洞的旧版 IIS 和 Apache 软件。尽管你可能使用的是修复漏洞后的网站服务器软件，你可能仍会暴露一些敏感的默认脚本目录，黑客们通常对这些目录非常熟悉。

例如，以下 URL 请求利用 ISS 脚本目录，实现遍历目录并执行命令：

```
GET http://server.com/scripts/..%5c../Windows/System32/cmd.exe?/c+dir+c:\ HTTP/1.1
Host: server.com
```

该请求将 `C:\` 目录下的所有文件返回给用户。它是通过执行 `cmd.exe` 脚本文件，并在该脚本中执行子命令 `dir c:\`。URL 中 `%5c` 表达式是网站服务器能理解的、代表普通字符的转义码。在该场景中，`%5c` 代表字符 `\`。

新版本的现代网站服务器软件都会校验这些转义码，并阻止它们通过。然而老版本的网站服务器软件，不会过滤这些转义码，这使得攻击者可以绕过服务根目录限制，并执行这些命令。

## 如何检查目录遍历漏洞

检查你的网站和应用程序是否存在目录遍历攻击的最好办法是使用一款网站漏洞扫描器。网站漏洞扫描器将爬取整个网站，自动检查目录遍历攻击漏洞。它将上报漏洞和简单的修复方案。除了目录遍历漏洞外，网站漏洞扫描器还可以检查 SQL 注入、跨站脚本攻击等其他网站漏洞。

## 阻止目录遍历攻击

首先，确保你已经安装了最新版本的网站服务器软件，并确保已经应用了所有的补丁。

其次，高效地过滤任何用户输入。理想情况下，除了已知的没问题的输入外，其他输入都应该被移除，并且还需要过滤用户输入中的元数据。这样就保证了提交给服务器的数据中，每个字段的输入都是合法的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
