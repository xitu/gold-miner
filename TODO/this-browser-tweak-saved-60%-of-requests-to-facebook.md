> * 原文地址：[This browser tweak saved 60% of requests to Facebook](https://code.facebook.com/posts/557147474482256)
* 原文作者：[Nate Schloss ](https://www.facebook.com/n8s) [Ben Maurer ](https://www.facebook.com/bmaurer)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[vuuihc](https://github.com/vuuihc)
* 校对者：[lorinlee](https://github.com/lorinlee)、[Airmacho](https://github.com/Airmacho)

# 这项浏览器调整使 Facebook 收到的网络请求减少了 60% #

在过去两年里，我们 Facebook 一直与浏览器厂商合作，以求改进浏览器的缓存效果。合作的成果是，Chrome 和 Firefox 最近推出的功能使其缓存机制在我们和整个网络上的效率显著提高。在这些改进的帮助下，发向我们服务器的静态资源请求数量减少了 60％，因此大大提高了网页加载时间。（静态资源是指服务器从磁盘上读取的文件，服务器不用运行任何额外的代码便能对外提供它们）这篇文章将详细说明为了得到这样的效果，我们联合 Chrome 和 Firefox 做了什么 —— 不过我们需要先定义一些概念和语义环境，这有助于解释我们需要解决的问题。首先要讲的是 —— 重新验证。

## 每次重新验证意味着另一个请求 ##

当你浏览网页时，浏览器经常会重复使用相同的资源，例如不同页面中相同的 logo 或 JavaScript 代码。如果浏览器需要重复地下载这些资源，是非常浪费的。

为了避免重复下载，HTTP 服务器可以为每个请求指定过期时间和验证机制，这可以指示浏览器在资源过期之前不需要重复下载。过期时间通过 HTTP header 中的 Cache-Control 字段发送，它告诉浏览器可以在什么时间内重复使用最新的响应。而验证机制允许响应即使过期也可以被浏览器重复使用。它允许浏览器向服务器确认资源是否仍然有效，是否可重复使用之前的响应。验证机制通过HTTP header 中的 Last-Modified 或 Etag 字段定义。

下面这个示例中的资源会一个小时后过期，同时它具有 Last-Modified 验证机制。

```
    $ curl https://example.com/foo.png
    > GET /foo.png
    
    < 200 OK
    < last-modified: Mon, 17 Oct 2016 00:00:00 GMT
    < cache-control: max-age=3600
    <image data>
```

在这个示例中，在接下来的一小时内，接收到此响应的浏览器可以重复使用它，无需再向 example.com 发送请求。之后，浏览器必须通过发送条件请求来重新验证资源，以确认图片是否仍是最新的：

```
    $ curl https://example.com/foo.png -H 'if-modified-since: Mon, 17 Oct 2016 00:00:00 GMT'
    > GET /foo.png
    > if-modified-since: Mon, 17 Oct 2016 00:00:00 GMT
    
    如果图片没被修改，返回：
    < 304 Not Modified
    < last-modified: Mon, 17 Oct 2016 00:00:00 GMT
    
    < cache-control: max-age=3600
    如果图片被修改了，则返回：
    < 200 OK
    < last-modified: Tue, 18 Oct 2016 00:00:00 GMT
    < cache-control: max-age=3600
    <image data>
```

如果资源未被修改，则服务器会发送未修改（304）响应。这比再次传输整个资源要好，因为要传输的数据更少，但是它不会消除浏览器与服务器通信带来的延迟。每次服务器返回未修改（304）响应时，浏览器早已拥有了它想要的资源。我们希望通过允许客户端缓存更长时间来避免这些浪费的重新验证。

## 指示长时间内无需重新下载 ##

重新验证让我们面对一个棘手的问题：过期时间应该是多久？如果你设定一个小时的过期时间，浏览器将必须每小时都与服务器通信，以确认资源是否被修改。许多像 logo 或 JavaScript 代码这类的资源很少改变; 在这些情况下每小时检查是不必要的。另一方面，如果过期时间很长，浏览器将一直从缓存中获取资源，就有可能会显示过期的资源。

为了解决这个问题，Facebook 使用内容定址 URL 的概念。我们的 URL 不是描述逻辑资源的 URL（如『logo.png』，『library.js』），而是我们内容的哈希。每次发布网站时，对每个静态资源进行哈希。我们维护一个数据库来存储这些哈希值并将哈希值映射到它们的内容。当服务器提供资源时，我们创建一个具有哈希值的 URL，而不是按名称提供。例如，如果 logo.png 的哈希是 abc123，我们使用URL http://www.facebook.com/rsrc.php/abc123.png。 

因为该方案使用文件内容的哈希作为 URL，所以它提供了重要的保证：内容定址 URL 的指向的内容从不改变。因此，我们为所有内容定址 URL 提供很长的过期时间（目前一年）。此外，因为 URL 的内容永远不会改变，对于所有有关静态资源的条件请求，我们的服务器将始终响应 304 未修改。这节省了CPU周期，同时让我们更快地响应此类请求。

## **刷新**带来的问题 ##

浏览器的刷新按钮使得用户可以获取当前页面的更新的版本。当点击刷新时，即使该网页尚未过期，浏览器也会重新验证当前所在的网页。然而除此之外，还会重新验证页面上的所有子资源 —— 如图像和 JavaScript 文件。

![](https://fb-s-b-a.akamaihd.net/h-ak-xft1/v/t39.2365-6/16180599_874188502721113_3142477830743392256_n.jpg?oh=9c4bf394a5afd5a0131ba067d08276d7&oe=59014047&__gda__=1497375933_9340577d36aaabad4acd088c4fc18028) 

子资源的重验证意味着即使用户已经访问过他们正在刷新的站点，每个子资源仍必须请求到服务器重验证一次。在使用内容定址 URL （如Facebook）的网站上，这些重新验证请求是徒劳的。 内容定址 URL 的内容从不改变，因此重新验证总是得到 304 未修改响应。 换句话说，重新验证、请求和花费在整个过程上的资源在一开始就是不必要的。 

## **条件请求**太多 ##

2014 年，我们发现 60％ 的静态资源请求会得到 304 响应。由于内容定址 URL 永远不会改变，这意味着有机会优化掉 60％ 的静态资源请求。 在 [Scuba](https://www.facebook.com/notes/facebook-engineering/under-the-hood-data-diving-with-scuba/10150599692628920/) 的帮助下 ，我们开始研究条件请求的数据。我们注意到，不同浏览器的表现之间存在巨大差异。

![](https://fb-s-c-a.akamaihd.net/h-ak-xat1/v/t39.2365-6/16180519_427963810928354_1151983436504760320_n.jpg?oh=1ac60c43dd09ea9cabfeab1066c2d1ed&oe=58FDE361&__gda__=1493046161_b41dc531b43ad09f295b50d434b0fd5e)

发现 Chrome 浏览器有最多的 304 响应之后，我们开始与他们合作，想搞清楚为什么它发送这么多的条件请求。

## Chrome ##

[Chrome 的一行源码](https://l.facebook.com/l.php?u=https%3A%2F%2Fchromium.googlesource.com%2Fchromium%2Fsrc%2F%2B%2F540d0cca0eba6e24679387bb67e49d459969e6e9%2Fthird_party%2FWebKit%2FSource%2Fcore%2Ffetch%2FResourceFetcher.cpp%23694&amp;h=ATO2x3tC1sAclxR_QrD21IcupxuN2NbANCU78fkU46N01s58gKPyZh4mtvMiF7I5gLkyTtC4ZPorIb3D36SnOmYCKMGvCCJfe0yiBDxkUMIr-48kqo4HVmUJe76xQv-OkQ&amp;s=1) 回答了我们的问题。这一行代码列出了几个 Chrome 可能会要求重新验证页面上的资源的原因，包括了用户点击刷新。其中一个例子是，我们发现 Chrome 会重新验证 POST 请求返回的网页上的所有资源。Chrome 团队告诉我们，这样做的理由是，POST 请求往往是发生在更改网页信息的情况（例如进行购买或发送电子邮件），此时用户希望拥有最新的网页。但是，像Facebook这样的网站在登录过程中会使用 POST 请求。每次用户登录到 Facebook 时，浏览器都会忽略其缓存，并重新验证所有以前下载的资源。我们与 Chrome 的产品经理和工程师合作，确定了此行为是 Chrome 独有的，而且是不必要的。在修正这一点后，Chrome 的条件请求占所有请求的比例从 63％ 降低到了 24％。

![](https://fb-s-c-a.akamaihd.net/h-ak-xta1/v/t39.2365-6/16179999_1203000506482917_4550616913532682240_n.jpg?oh=78c4419eacba0b55767eb83d06d46bcd&oe=593AADEE&__gda__=1496929877_0d2c692fdd8cb12489a92c13a520d3c0)

我们与 Chrome 在登录问题上的合作是一个很好的例子，展现了 Facebook 如何和浏览器团队合作来快速解决一个错误。一般来说，当我们查看数据时，我们经常按浏览器分开查看。如果我们发现一个浏览器的数据异常，它表明这个浏览器中的某些东西可以优化。 然后，我们可以与浏览器厂商一起解决问题。

虽然有些成果，但来自 Chrome 的条件请求的百分比仍然高于其他浏览器，这表明仍然有一些改进的机会。我们开始研究刷新的过程，结果发现 Chrome 将同址访问视为刷新，而其他浏览器则不会这样。同址访问是指用户在地址栏输入当前已加载网页的网址并尝试访问。Chrome 修复了同址访问的问题，但我们没有看到很大的提升效果。我们开始跟 Chrome 小组讨论改变刷新按钮的行为。

改变刷新按钮的重新验证机制是对 Web 上的长期设计的更改。然而，讨论到这个问题，我们意识到开发者不可能会依赖这种机制。网站的最终用户不知道资源过期时间和条件请求是什么。虽然一些用户可能在他们想要更新页面时按下刷新按钮，但 Facebook 的统计数据显示，大多数用户都不使用刷新按钮。因此，如果开发人员正在更改过期时间为 X 的资源，则开发人员必须情愿用户使用旧的数据直至其过期，或者用户必须修改 URL。如果开发人员已经更改了资源，那么没有理由重新验证子资源。

业界对于如何处理这个问题有一些争论，我们提出了一个折中的方案，max-age 较大的资源永远不被重新验证，但是对于 max-age 较短的资源将使用旧的策略。Chrome 团队考虑这个问题之后决定对所有资源进行应用新的策略。你可以在 [这里](https://l.facebook.com/l.php?u=https%3A%2F%2Fblog.chromium.org%2F2017%2F01%2Freload-reloaded-faster-and-leaner-page_26.html&amp;h=ATM_ZozpQRZEWgHaKWKNv4OdlqdB-_GfKB2c_SkvV9sXFcPB8GCAHq9o1i-8mfvcG1vINh49zimRYr4jkmvew54-gpW9Vftqw0No-D-zYywwjLVHcCuq7WyfsZrQAmRv3g&amp;s=1) 查看他们的处理过程。由于 Chrome 的一揽子方针，所有开发人员和网站自身无需任何改变就可受益于这一改进。

![](https://fb-s-b-a.akamaihd.net/h-ak-xtp1/v/t39.2365-6/16327422_662197940655602_5747554978155724800_n.jpg?oh=a3e0473f124544ff94d2f2f85080d92e&oe=59342FE7&__gda__=1496491292_e0d6d4e4f83041883f1ebddba4455f61) 

在这个例子中可以看到，以前在刷新的页面上每个子资源都需要一个网络请求，而现在不同，可以直接从缓存中读取每个文件，从而不会被网络请求阻塞。

Chrome 发布这个终极改进之后，来自 Chrome 浏览器的条件请求的百分比急剧下降 —— 对于 Facebook 和用户是一个皆大欢喜的事情，服务器需要响应的 304 未修改的请求减少了，用户则能够更快地刷新网页。

## Firefox ##

解决了 Chrome 的问题后，我们开始与其他浏览器厂商讨论刷新按钮的行为。我们向 Firefox [提交了一个 bug](https://l.facebook.com/l.php?u=https%3A%2F%2Fbugzilla.mozilla.org%2Fshow_bug.cgi%3Fid%3D1267474&amp;h=ATMZWq3XILESCXL2Uo0bOYK533wWyDAAKD69lM0YUVqNXRjzNWDov_sp0BQof83Fsl52mBvwlvz22SSldeAv-UDG9lpZrsbjcMN4mGIuDrceTqp7-CZtrD3i--RFcltAuA&amp;s=1) ，但是他们选择不改变刷新按钮长期以来默认的行为。相反，他们团队实现了我们的工程师提出的一个[方案](https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.ietf.org%2Fmail-archive%2Fweb%2Fhttpbisa%2Fcurrent%2Fmsg25463.html&amp;h=ATPDjZ49Z-nBPp_GzP9c6-ZBmvCdvij1zMObscv3RPpz5Pw5om726NFaOzB4xc-5W5qbZaitgKQdMf534Lgv4bG8-I8CM59tgSMq26urQRjo6Ix626fJ77q5tK-_XhnWmQ&amp;s=1)，给某些资源添加新的 Cache-Control header，告诉浏览器这个资源永远不需要被重新验证。这个 header 背后的想法是，它是开发人员给予浏览器的一个额外的承诺，承诺这个资源在其最大生命周期内永远不会改变。Firefox选择以 `cache-control:immutable`  header 的形式实现这个指令。

有了这个添加的 header，现在向 Facebook 请求资源时将会得到类似下面这样的响应：

```
$ curl https://example.com/foo.png
> GET /foo.png
    
< 200 OK
< last-modified: Mon, 17 Oct 2016 00:00:00 GMT
< cache-control: max-age=3600, immutable
<image data>
```

Firefox 很快实现了 `cache-control:immutable` 这一机制，并在 Chrome 全面发行其对刷新行为的终极改进的时候推出了这一机制。你可以在 [这里](https://l.facebook.com/l.php?u=https%3A%2F%2Fhacks.mozilla.org%2F2017%2F01%2Fusing-immutable-caching-to-speed-up-the-web%2F&amp;h=ATPlpvy6viRY3IThq2PSQFIuzSkd6fGeHb26V6X7kf8LWPShGs1CaOVLU7heN6SCS4yEBEFQSgv1phHYMZoT8v3aRo_P1xc6n_KhkyvOg6mJKNcmcf0NJ4-py-mhnQBqXg&amp;s=1) 阅读更多关于 Firefox 的改进的内容。

按照 Firefox 的方案，我们会有些开发成本。但是我们修改服务端代码添加 immutable header 后，得到了一些很好的结果。

## 改进之后 ##

Chrome 和 Firefox 的改进措施使得从这些现代浏览器发出的重新验证请求大大减少。这减少了我们服务器的带宽压力，更重要的是提高了访问 Facebook 的用户的加载速度。

不幸的是，这种改变是难以准确测量改进效果的 —— 浏览器的新版本包含如此多的改进，几乎不可能隔离特定改进的影响。不过，在测试此改进时，Chrome 团队执行 A/B 测试后发现使用 3G 网络的手机用户，所有网站中 90% 的刷新速度提高了 1.6 秒。

## 总结 ##

这是一项棘手的工作，因为我们要求改变长期存在的网络行为。但它表明了 Web 浏览器**可以**而且**已经**与 Web 开发人员共同努力，为每个人创造更好地网络环境。我们很高兴在 Chrome 和 Firefox 团队中有与我们建立良好的合作关系的朋友，并对我们能够持续合作以改善每个人的网络而感到兴奋。