  > * 原文地址：[Securing Cookies in Go](https://www.calhoun.io/securing-cookies-in-go/)
  > * 原文作者：[Jon Calhoun](https://www.calhoun.io/hire-me/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/securing-cookies-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO/securing-cookies-in-go.md)
  > * 译者：[lsvih](https://github.com/lsvih)
  > * 校对者：[tmpbook](https://github.com/tmpbook), [Yuuoniy](https://github.com/Yuuoniy)

# 在 Go 语言中增强 Cookie 的安全性
  
在我开始学习 Go 语言时已经有一些 Web 开发经验了，但是并没有直接操作 Cookie 的经验。我之前做过 Rails 开发，当我不得不需要在 Rails 中读写 Cookie 时，并不需要自己去实现各种安全措施。

瞧瞧，Rails 默认就自己完成了大多数的事情。你不需要设置任何 CSRF 策略，也无需特别去加密你的 Cookie。在新版的 Rails 中，这些事情都是它默认帮你完成的。

而使用 Go 语言开发则完全不同。在 Golang 的默认设置中，这些事都不会帮你完成。因此，当你想要开始使用 Cookie 时，了解各种安全措施、为什么要使用这些措施、以及如何将这些安全措施集成到你的应用中是非常重要的事。希望本文能帮助你做到这一点。

**注意：我并不想引起关于 Go 与 Reils 两者哪种更好的论战。两者各有优点，但在本文中我希望能着重讨论 Cookie 的防护，而不是去争论 Rails 和 Go 哪个好。**

## 什么是 Cookie？

在进入 Cookie 防护相关的内容前，我们必须要理解 Cookie 究竟是什么。从本质上说，Cookie 就是存储在终端用户计算机中的键值对。因此，使用 Go 创建一个 Cookie 需要做的事就是创建一个包含键名、键值的 [http.Cookie](https://golang.org/pkg/net/http/#Cookie) 类型字段，然后调用 [http.SetCookie](https://golang.org/pkg/net/http/#SetCookie) 函数通知终端用户的浏览器设置该 Cookie。

写成代码之后，它看起来类似于这样：

```
func someHandler(w http.ResponseWriter, r *http.Request) {
  c := http.Cookie{
    Name: "theme",
    Value: "dark",
  }
  http.SetCookie(w, &c)
}
```

> `http.SetCookie` 函数并不会返回错误，但它可能会静默地移除无效的 Cookie，因此使用它并不是什么美好的经历。但它既然这么设计了，就请你在使用这个函数的时候一定要牢记它的特性。

虽然这好像是在代码中“设定”了一个 Cookie，但其实我们只是在我们返回 Response 时发送了一个 `"Set-Cookie"` 的 Header，从而定义需要设置的 Cookie。我们不会在服务器上存储 Cookie，而是依靠终端用户的计算机创建与存储 Cookie。

我要强调上面这一点，因为它存在非常严重的安全隐患：我们**不能**控制这些数据，而终端用户的计算机（以及用户）才能控制这些数据。

当读取与写入终端用户控制的数据时，我们都需要十分谨慎地对数据进行处理。恶意用户可以删除 Cookie、修改存储在 Cookie 中的数据，甚至我们可能会遇到[中间人攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)，即当用户向服务器发送数据时，另有人试图窃取 Cookie。

## Cookie 的潜在安全问题

根据我的经验，Cookie 相关的安全性问题大致分为以下五大类。下面我们先简单地看一看，本文的剩余部分将详细讨论每个分类的细节问题与解决对策。

**1. Cookie 窃取** - 攻击者会通过各种方式来试图窃取 Cookie。我们将讨论如何防范、规避这些方式，但是归根结底我们并不能完全阻止设备上的物理类接触。

**2. Cookie 篡改** - Cookie 中存储的数据可以被用户有意或无意地修改。我们将讨论如何验证存储在 Cookie 中的数据确实是我们写入的合法数据

**3. 数据泄露** - Cookie 存储在终端用户的计算机上，因此我们需要清楚地意识到什么数据是能存储在 Cookie 中的，什么数据是不能存储在 Cookie 中的，以防其发生数据泄露。

**4. 跨站脚本攻击（XSS）** - 虽然这条与 Cookie 没有直接关系，但是 XSS 攻击在攻击者能获取 Cookie 时危害更大。我们应该考虑在非必须的时候限制脚本访问 Cookie。

**5. 跨站请求伪造（CSRF）** - 这种攻击常常是由于使用 Cookie 存储用户登录会话造成的。因此我们将讨论在这种情景下如何防范这种攻击。

如我前面所说，在下文中我们将分别解决这些问题，让你最终能够专业地将你的 Cookie 装进保险柜。

## Cookie 窃取

Cookie 窃取攻击就和它字面意思一样 —— 某人窃取了正常用户的 Cookie，然后一般用来将自己伪装成那个正常用户。

Cookie 通常是被以下方式中的某种窃取：

1. [中间人攻击](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)，或者是类似的其它攻击方式，归纳一下就是攻击者拦截你的 Web 请求，从中窃取 Cookie。
2. 取得硬件的访问权限。

阻止中间人攻击的终极方式就是当你的网站使用 Cookie 时，使用 SSL。使用 SSL 时，由于中间人无法对数据进行解密，因此外人基本上没可能在请求的中途获取 Cookie。

可能你会觉得“哈哈，中间人攻击不太可能…”，我建议你看看 [firesheep](http://codebutler.com/firesheep)，这个简单的工具，它足以说明在使用公共 wifi 时窃取未加密的 Cookie 是一件很轻松的事情。

如果你想确保这种事情不发生在你的用户中，**请使用 SSL！**试试使用 [Caddy Server](https://caddyserver.com/) 进行加密吧。它经过简单的配置就能投入生产环境中。例如，你可以使用下面四行代码轻松让你的 Go 应用使用代理：

```
calhoun.io {
  gzip
  proxy / localhost:3000
}
```

然后 Caddy 会为你自动处理所有与 SSL 有关的事务。

防范通过访问硬件来窃取 Cookie 是十分棘手的事情。我们不能强制我们的用户使用高安全性系统，也不能逼他们为电脑设置密码，所以总会有他人坐在电脑前偷走 Cookie 的风险。此外，Cookie 也可能被病毒窃取，比如用户打开了某些钓鱼邮件时就会出现这种情况。

不过这些都容易被发现。例如，如果有人偷了你的手表，当你发现表不在手上时你立马就会注意到它被偷了。然而 Cookie 还可以被复制，这样任何人都不会意识到它已经丢了。

虽然不是万无一失，但你还是可以用一些技术来猜测 Cookie 是否被盗了。例如，你可以追踪用户的登录设备，要求他们重新输入密码。你还可以跟踪用户的 IP 地址，当其在可疑地点登录时通知用户。

所有的这些解决方案都需要后端做更多的工作来追踪数据，如果你的应用需要处理一些敏感信息、金钱，或者它的收益可观的话，请在安全方面投入更多精力。

也就是说，对于大多数只是作为过渡版本的应用来说，使用 SSL 就足够了。

## Cookie 篡改（也叫用户伪造数据）

请直面这种情况 —— 可能有一些混蛋突然就想看看你设的 Cookie，然后修改它的值。也可能他是出于好奇才这么做的，但是还是请你为这种可能发生的情况做好准备。

在一些情景中，我们对此并不在意。例如，我们给用户定义一种主题设置时，并不会关心用户是否改变了这个设置。当这个 Cookie 过期时，就会恢复默认的主题设置，并且如果用户设置其为另一个有效的主题时我们可以让他正常使用那个主题，这并不会对系统造成任何损失。

但是在另一些情况下，我们需要格外小心。编辑会话 Cookie 冒充另一个用户产生的危害比改个主题大得多。我们绝不想看到张三假装自己是李四。

我们将介绍两种策略来检测与防止 Cookie 被篡改。

#### 1. 对数据进行数字签名

对数据进行数字签名，即对数据增加一个“签名”，这样能让你校验数据的可靠性。这种方法并不需要对终端用户的数据进行加密或隐藏，只要对 Cookie 增加必要的签名数据，我们就能检测到用户是否修改数据。

这种保护 Cookie 的方法原理是哈希编码 —— 我们对数据进行哈希编码，接着将数据与它的哈希编码同时存入 Cookie 中。当用户发送 Cookie 给我们时，再对数据进行哈希计算，验证此时的哈希值与原始哈希值是否匹配。

我们当然不会想看到用户也创建一个新的哈希来欺骗我们，因此你可以使用一些类似 HMAC 的哈希算法来使用秘钥对数据进行哈希编码。这样就能防范用户同时编辑数据与数字签名（即哈希值）。

> [JSON Web Tokens(JWT)](https://jwt.io/) 默认内置了数字签名功能，因此你可能对这种方法比较熟悉。

在 Go 中，可以使用类似 Gorilla 的 [securecookie](http://www.gorillatoolkit.org/pkg/securecookie) 之类的 package，你可以在创建 `SecureCookie` 时使用它来保护你的 Cookie。

```
// 推荐使用 32 字节或 64 字节的 hashKey
// 此处为了简洁故设为了 “very-secret”
var hashKey = []byte("very-secret")
var s = securecookie.New(hashKey, nil)

func SetCookieHandler(w http.ResponseWriter, r *http.Request) {
  encoded, err := s.Encode("cookie-name", "cookie-value")
  if err == nil {
    cookie := &http.Cookie{
      Name:  "cookie-name",
      Value: encoded,
      Path:  "/",
    }
    http.SetCookie(w, cookie)
    fmt.Fprintln(w, encoded)
  }
}
```

然后你可以在另一个处理 Cookie 的函数中同样使用 SecureCookie 对象来读取 Cookie。

```
func ReadCookieHandler(w http.ResponseWriter, r *http.Request) {
  if cookie, err := r.Cookie("cookie-name"); err == nil {
    var value string
    if err = s.Decode("cookie-name", cookie.Value, &value); err == nil {
      fmt.Fprintln(w, value)
    }
  }
}
```

**以上样例来源于 [http://www.gorillatoolkit.org/pkg/securecookie](http://www.gorillatoolkit.org/pkg/securecookie).**

> 注意：这儿的数据并不是进行了加密，而只是进行了编码。我们会在“数据泄露”一章讨论如何对数据进行加密。

这种模式还需要注意的是，如果你使用这种方式进行身份验证，请遵循 JWT 的模式，将登录过期日期和用户数据同时进行签名。你不能只凭 Cookie 的过期日期来判断登录是否有效，因为存储在 Cookie 上的日期并未经过签名，且用户可以创建一个永不过期的新 Cookie，将原 Cookie 的内容复制进去就得到了一个永远处于登录状态的 Cookie。

#### 2. 进行数据混淆

还有一种解决方案可以隐藏数据并防止用户造假。例如，不要这样存储 Cookie：

```
// 别这么做
http.Cookie{
  Name: "user_id",
  Value: "123",
}
```

我们可以存储一个值来映射存在数据库中的真实数据。通常使用 Session ID 或者 remember token 来作为这个值。例如我们有一个名为 `remember_tokens` 的表，这样存储数据：

```
remember_token: LAKJFD098afj0jasdf08jad08AJFs9aj2ASfd1
user_id: 123
```

在 Cookie 中，我们仅存储这个 remember token。如果用户想伪造 Cookie 也会无从下手。它看上去就是一堆乱码。

之后当用户要登陆我们的应用时，再根据 remember token 在数据库中查询，确定用户具体的登录状态。

为了让此措施正常工作，你需要确保你的混淆值有以下特性：

- 能映射到用户数据（或其它资源）
- 随机
- 熵值高
- 可被无效化（例如在数据库中删除、修改 token 值）

这种方法也有一个缺点，就是在用户访问每个需要校验权限的页面时都得进行数据库查询。不过这个缺点很少有人注意，而且可以通过缓存等技术来减小数据库查询的开销。这种方法的升级版就是 JWT，应用这种方法你可以随时使会话无效化。

**注意：尽管目前 JWT 收到了大多数 JS 框架的追捧，但上文这种方法是我了解的最常用的身份验证策略。**

## 数据泄露

在真正出现数据泄露前，通常需要另一种攻击向量 —— 例如 Cookie 窃取。然而还是很难去正确地判断并提防数据泄露的发生。因为仅仅是 Cookie 发生了泄露并不意味着攻击者也得到了用户的账户密码。

无论何时，都应当减少存储在 Cookie 中的敏感数据。绝不要将用户密码之类的东西存在 Cookie 中，即使密码已经经过了编码也不要这么做。[这篇文章](https://hackernoon.com/your-node-js-authentication-tutorial-is-wrong-f1a3bf831a46#2491) 给出了几个开发者无意间将敏感数据存储在 Cookie 或 JWT 中的实例，由于（JWT 的 payload）是 base64 编码，没有经过任何加密，因此任何人都可以对其进行解码。

出现数据泄露可是犯了大错。如果你担心你不小心存储了一些敏感数据，我建议你使用如 Gorilla 的 [securecookie](http://www.gorillatoolkit.org/pkg/securecookie) 之类的 package。

前面我们讨论了如何对你的 Cookie 进行数字签名，其实 `securecookie` 也可以用于加密与解密你的 Cookie 数据，让你的数据不能被轻易地解码并读取。

使用这个 package 进行加密，你只需要在创建 `SecureCookie` 实例时传入一个“块秘钥”（blockKey）即可。

```
var hashKey = []byte("very-secret")
// 增加这一部分进行加密
var blockKey = []byte("a-lot-secret")
var s = securecookie.New(hashKey, blockKey)
```

其它所有东西都和前面章节的数字签名中的样例一致。

再次提醒，你**不应该**在 Cookie 中存储任何敏感数据，尤其不能存储密码之类的东西。加密仅仅是一项为数据增加一部分安全性，使其成为”半敏感数据“数据的技术而已。

## 跨站脚本攻击（XSS）

[跨站脚本（Cross-site scripting）](https://en.wikipedia.org/wiki/Cross-site_scripting)也经常被记为 XSS，及有人试图将一些不是你写的 JavaScript 代码注入你的网站中。但由于其攻击的机理，你无法知道正在浏览器中运行的 JavaScript 代码到底是不是你的服务器提供的代码。

无论何时，你都应该尽量去阻止 XSS 攻击。在本文中我们不会深入探讨这种攻击的具体细节，但是**以防万一**我建议你在非必要的情况下禁止 JavaScript 访问 Cookie 的权限。在你需要这个权限的时候你可以随时开启它，所以不要让它成为你的网站安全性脆弱的理由。

在 Go 中完成这点很简单，只需要在创建 Cookie 时设置 `HttpOnly` 字段为 true 即可。

```
cookie := http.Cookie{
  // true 表示脚本无权限，只允许 http request 使用 Cookie。
  // 这与 Http 与 Https 无关。
  HttpOnly: true,
}
```

## CSRF（跨站请求伪造）

CSRF 发生的情况为某个用户访问别人的站点，但那个站点有一个能提交到你的 web 应用的表单。由于终端用户提交表单时的操作不经由脚本，因此浏览器会将此请求设为用户进行的操作，将 Cookie 附上表单数据同时发送。

乍一看似乎这没什么问题，但是如果外部网站发送一些用户不希望发送的数据时会发生什么呢？例如，badsite.com 中有个表单，会提交请求将你的 100 美元转到他们的账户中，而 chase.com 希望你在它这儿登录你的银行账户。这可能会导致在终端用户不知情的情况下钱被转走。

Cookie 不会直接导致这样的问题，不过如果你使用 Cookie 作为身份验证的依据，那你需要使用 Gorilla 的 [csrf](http://www.gorillatoolkit.org/pkg/csrf) 之类的 package 来避免 CSRF 攻击。

这个 package 将会提供一个 CSRF token，插入你网站的每个表单中，当表单中不含 token 时，`csrf` package 中间件将会阻止表单的提交，使得别的网站不能欺骗用户在他们那儿向你的网站提交表单。

**更多关于 CSRF 攻击的资料请参阅：**

- [https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF))
- [https://en.wikipedia.org/wiki/Cross-site_request_forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery)

## 在非必要时限制 Cookie 的访问权限

我们要讨论的最后一件事与特定的攻击无关，更像是一种指导原则。我建议在使用 Cookie 时尽量限制其权限，仅在你需要时开发相关权限。

前面讨论 XSS 时我也简单的提到过这点，但一般的观点是你需要尽可能限制对 Cookie 的访问。例如，如果你的 Web 应用没有使用子域名，那你就不应该赋予 Cookie 所有子域的权限。不过这是 Cookie 的默认值，因此其实你什么都不用做就能将 Cookie 的权限限制在某个特定域中。

但是，如果你需要与子域共享 Cookie，你可以这么做：

```
c := Cookie{
  // 根据主机模式的默认设置，Cookie 进行的是精确域名匹配。
  // 因此请仅在需要的时候开启子域名权限！
  // 下面的代码可以让 Cookie 在 yoursite.com 的任何子域下工作：
  Domain: "yoursite.com",
}
```

**欲了解更多有关域的信息，请参阅 [https://tools.ietf.org/html/rfc6265#section-5.1.3](https://tools.ietf.org/html/rfc6265#section-5.1.3)。你也可以在这儿阅读源码，参阅其默认设置：[https://golang.org/src/net/http/cookie.go#L157](https://golang.org/src/net/http/cookie.go#L157).**

**你可以参阅 [这个 stackoverflow 的问题](https://stackoverflow.com/questions/18492576/share-cookie-between-subdomain-and-domain) 了解更多信息，弄明白为什么在为子域使用 Cookie 时不需要提供子域前缀.此外 Go 源码链接中也可以看到如果你提供前缀名的话会被自动去除。**

除了将 Cookie 的权限限制在特定域上之外，你还可以将 Cookie 限制于某个特定的目录路径中。

```
c := Cookie{
  // Defaults 设置为可访问应用的任何路径，但你也可以
  // 进行如下设置将其限制在特定子目录下：
  Path: "/app/",
}
```

还有你也可以对其设置路径前缀，例如 `/blah/`，你可以参阅下面这篇文章了解更多这个字段的使用方法：[https://tools.ietf.org/html/rfc6265#section-5.1.4](https://tools.ietf.org/html/rfc6265#section-5.1.4).

## 为什么我不使用 JWT？

就知道肯定会有人提出这个问题，下面让我简单解释一下。

可能有很多人和你说过，Cookie 的安全性与 JWT 一样。但实际上，Cookie 与 JWT 解决的并不是相同的问题。比如 JWT 可以存储在 Cookie 中，这和将其放在 Header 中的实际效果是一样的。

另外，Cookie 可用于无需验证的数据，在这种情况下了解如何增加 Cookie 的安全性也是必要的。


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
