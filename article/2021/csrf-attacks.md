> - 原文地址：[CSRF Attacks: Anatomy, Prevention, and XSRF Tokens](https://www.acunetix.com/websitesecurity/csrf-attacks/)
> - 原文作者：[Acunetix](https://www.acunetix.com/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/csrf-attacks.md](https://github.com/xitu/gold-miner/blob/master/article/2021/csrf-attacks.md)
> - 译者：[MoonBall](https://github.com/MoonBall)
> - 校对者：[Chorer](https://github.com/Chorer)、[KimYangOfCat](https://github.com/KimYangOfCat)

# CSRF 攻击：解析、预防和 CSRF 令牌

跨站请求伪造，也被称为 CSRF、Sea Surf 或者 XSRF。它是一种攻击方式，攻击者利用它诱骗受害者代表他们自己执行操作。受害者持有的权限级别决定了 CSRF 攻击的影响范围。这种攻击利用了一个事实：一旦用户通过网站服务的身份认证，网站就完全信任该用户（译者注：身份认证指 cookie）。

在网络安全领域，通常认为跨站请求伪造攻击是一个沉睡的巨人。尽管可以证明只要合理地发起 CSRF 攻击，它将成为一种隐匿且强大的攻击方式，但它往往没有得到应有的重视。CSRF 攻击是一种常见的攻击方式，这也是它连续多次出现在 [OWASP Top 10](https://www.acunetix.com/blog/articles/owasp-top-10-2017/) 列表中的原因。然而，利用漏洞发起的[跨站脚本攻击（XSS）](https://www.acunetix.com/websitesecurity/cross-site-scripting/)比任何 CSRF 漏洞的风险都高，因为 CSRF 攻击有一个很大的限制，它只能引起状态变更，这使得攻击者无法收到 HTTP 响应的内容

## 如何发起 CSRF 攻击

发起跨站请求伪造攻击需要经过两个步骤。第一步是诱骗受害者点击某个链接或者加载某个页面。这一步一般通过社会工程学或恶意链接实现。第二步是从受害者的浏览器向网站服务器发送一个精心设计的、看似合法的请求。该请求携带了攻击者设置好的参数和受害者在目标网站上的所有 cookie。因此，目标网站知道受害者可以在该网站上执行哪些行为。即使这些请求是受害者在攻击者的诱导下发起的，任何携带 HTTP 认证或 cookie 的请求也都会被目标网站视为合法请求。

当向一个网站发起请求时，受害者的浏览器将检查与该网站的源相关的所有 cookie，然后将这些 cookie 一起发送给网站服务端。因此，所有发送到该网站的请求都将包含这些 cookie。通常 cookie 值包含用户的认证信息，并且代表了用户和服务端的会话。这样做是为了提供流畅的用户体验，用户不必每次访问网页时都进行身份认证。如果网站服务认可会话 cookie 并且认为用户的会话仍然合法，那么攻击者就可以使用 CSRF 攻击发送请求，这些请求就好像是受害者自己发起的一样。因为所有请求都由受害者的浏览器发起，并且都携带了受害者的 cookie，所以网站服务端不能识别哪些请求是攻击者发起的，哪些是受害者自己发起的。CSRF 攻击简单地利用了一个事实：浏览器发起请求时，将自动携带目标站点的 cookie。

跨站请求伪造攻击仅在受害者已经通过身份认证的情况下有效。这意味着受害者必须先登录，然后攻击者才能进行攻击。因为 CSRF 攻击被用作绕过身份认证过程，所以某些资源即使没有保护措施，也不会受到 CSRF 攻击的影响，比如公开可访问的内容。例如，对 CSRF 攻击来说，网站上公开的联系方式表单是安全的。这些 HTML 表单没有要求受害者有权限才能进行表单提交。CSRF 攻击仅应用于受害者能执行某些行为，但又不是所有人都能执行这些行为的场景。

![CSRF](https://www.acunetix.com/wp-content/uploads/2013/04/csrf.png)

## 使用 GET 请求的 CSRF 攻击例子

HTTP GET 本质上是一种幂等请求方法。这意味着这个 HTTP 方法不应该被用作修改状态。发送一个 GET 请求不应该引起任何状态改变。然而，一些网站应用仍然使用 GET 方法修改状态，而不是使用更合适的 POST 方法，比如使用 GET 方法改变密码或添加用户。

当受害者点击攻击者使用社会工程学提供的链接时，受害者便开始访问攻击者的恶意网站。该网站执行一个脚本，该脚本引起用户的浏览器发起一个未经受害者同意的请求。受害者并不会意识到已经发起了该请求。然而，在服务端看来，该请求好像是用户发起的，因为它包含用于验证用户身份的 cookie。

让我们假设 www.example.com 使用带有两个参数的 GET 请求进行转账，这两个参数是：转账数目和收款用户。以下例子展示了一个合法 URL，它请求网站服务端向 Fred 转账 100,000 元钱。

```
http://example.com/transfer?amount=1000000&account=Fred
```

因为该请求包含代表用户身份的 cookie，所以不需要定义转账的源账户。如果普通用户访问该 URL，他们需要先认证身份，以便让应用程序知道从哪个账户转账。使用 CSRF 攻击，当受害者已经登录后，攻击者能诱骗受害者发送该请求。

如果有漏洞的应用期望一个 GET 请求，攻击者可以在他们的网站中包含一个恶意的 `<img>` 标签。该标签向银行的网站发送恶意请求，而不是链接一个图片。

```html
<img data-fr-src="http://example.com/transfer?amount=1000000&account=Fred" />
```

正常情况下，用户的浏览器将自动发送与该站点相关的 cookie。因此攻击者便能代表受害者执行状态变更。在上面的例子中，状态变更指的就是转账操作。

请注意，这个例子非常简单，它必然不能反应真实世界的情形，但是它非常好地展示了 CSRF 攻击的原理。不过在以往流行的软件中的确存在基于 GET 方法的相似漏洞（在[维基百科](https://en.wikipedia.org/wiki/Cross-site_request_forgery#Example_and_characteristics)中阅读更多内容）。

## 使用 POST 请求的 CSRF 攻击

大多数改变状态的请求是使用 HTTP POST 方法实现的。这意味着当状态改变时，应用程序更愿意接受 POST 请求，而不是 GET 请求。使用 POST 请求时，用户浏览器将参数和值置于请求体中，而不是像 GET 请求，将参数和值置于 URL 中。

诱骗受害者发起 POST 请求可能稍微困难一些。使用 GET 请求时，攻击者只需让受害者访问一个带有所有必要信息的 URL。而使用 POST 请求时，必须将请求体附加到请求中。不过攻击者可以设计一个带有 JavaScript 的网站，只要加载该网页就使用户浏览器发送未经授权的 POST 请求。

以下 JavaScript 例子展示了 `onload` 函数，当页面加载时，该函数自动从受害者的浏览器中发送一个请求。

```html
<body onload="document.csrf.submit()">
  <form action="http://example.com/transfer" method="POST" name="csrf">
    <input type="hidden" name="amount" value="1000000" />
    <input type="hidden" name="account" value="Fred" />
  </form>
</body>
```

只要加载网页，JavaScript 中的 `onload` 函数一定会提交隐藏的表单，进而发出 POST 请求。表单包含攻击者设置的两个参数和对应的值。该 POST 请求的目的端（即 example.com）认为该请求是合法的，因为该请求包含了受害者的 cookie。

攻击者也可以通过设置相关属性使 IFrame 隐藏，从而发起攻击。使用相同的 `onload` 函数，攻击者可以加载包含恶意网页的 IFrame。只要 IFrame 被加载，就会发起请求。另一个选择是使用 XMLHttpRequest 技术。

## 防御 CSRF 攻击

安全专家提出了许多防御 CSRF 攻击的机制。例如使用 referer 请求头、使用 `HttpOnly` 标志、使用 jQuery 发送 `X-Requested-With` 自定义请求头等等。不幸的是，这些方法并非适用于所有场景。在某些情况下它们是低效率的，而在其它某些情况下，在一个指定的应用中实现它们有一定的难度，或者会带来副作用。接下来介绍的实现在提供 CSRF 攻击防护的同时，也在很多应用程序中被证明是高效的。查看 OWASP 维护的 [CSRF 攻击防护手册](https://github.com/OWASP/CheatSheetSeries/blob/master/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.md)，了解更多高级的 CSRF 攻击防护方法。

## 什么是 CSRF 令牌

最流行的防止 CSRF 攻击的方法是使用挑战令牌。该令牌与指定的用户相关联，并且在应用程序的每个状态变更的表单中作为隐藏值被发送给用户。这种令牌被称为**抗-CSRF 令牌**（通常简写为 **CSRF 令牌**）或**同步令牌**，其工作原理如下：

- 网站服务生成令牌并存储它
- 将该令牌静态设置到表单的隐藏字段中
- 用户提交表单
- POST 请求体中包含该令牌
- 网站服务将以前生成并存储的令牌和请求体中的令牌进行比较
- 如果令牌匹配，请求合法
- 如果令牌不匹配，请求不合法并且被拒绝

这种 CSRF 防护方法被称为**同步令牌模式**。它能阻止跨站请求伪造攻击的原因是攻击者必须猜中令牌才能成功地诱骗受害者发起合法请求。像 cookie 一样，应该在一段时间后或者用户登出后使令牌无效。在 AJAX 请求中，抗-CSRF 令牌经常作为请求头或请求参数暴露出来。

为了使抗-CSRF 机制有效，它需要进行加密安全处理。令牌不能很容易被猜中，因此不能基于可预测的模式生成令牌。如果可能，我们也推荐使用像 Angular 这样的流行框架中的抗-CSRF 选项，而不是重新创建自己的令牌生成机制。这不仅能避免出错，而且还更快更容易实现。

## 同站 Cookie

CSRF 攻击存在的原因是所有与请求的目标源相关的 cookie 都将跟随请求一起发送到服务端（查看[同源策略](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy))。你可以给 cookie 设置一个标志位，使其成为同站 cookie。同站 cookie 只在发起请求的站点与 cookie 相关（不跨域名）时，才会被发送到服务端。如果 cookie 和请求的协议、端口（译者注：cookie 没有端口）和主机名（不是主机的 IP 地址）都是相同的，那么就认为它们有相同的源。

目前同站 cookie 存在的限制是仅得到了 Chrome 或 Firefox 等浏览器的支持，并非所有的现代浏览器都支持它，而且更老的浏览器不能运行使用了同站 cookie 的网站（[点击这里](http://caniuse.com/#feat=same-site-cookie-attribute)查看支持同站 cookie 的浏览器）。由于这个限制，目前同站 cookie 更适用于作为额外的防御层。因此，你应该将同站 cookie 和其他 CSRF 防御方法一起使用。

## 结论

因为发起每个请求都将自动携带 cookie，所以 cookie 本身就是一个 CSRF 漏洞。它使得攻击者可以很容易地设计恶意请求并发起 CSRF 攻击。尽管攻击者不能拿到响应体或 cookie 本身，但他们能通过受害者持有的更高权限执行操作。一个 CSRF 漏洞的影响范围与受害者拥有的权限有关。尽管获取敏感信息不是 CSRF 攻击的主要内容，但状态修改仍可能对网站造成负面影响。

幸运的是，通过运行 Acunetix 漏洞扫描器对网站进行自动扫描，将非常容易检查你的网站是否存在 CSRF 漏洞和其他漏洞。Acunetix 漏洞扫描器包括专门的 [CSRF 扫描器](https://www.acunetix.com/vulnerability-scanner/csrf-scanner/)模块。[查看示例](https://www.acunetix.com/web-vulnerability-scanner/demo/)并找到更多关于如何通过 CSRF 扫描器保护你的网站和应用的信息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
