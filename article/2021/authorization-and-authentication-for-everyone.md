> * 原文地址：[Authorization and Authentication For Everyone](https://dev.to/kimmaida/authorization-and-authentication-for-everyone-27j3)
> * 原文作者：[Kim Maida](https://dev.to/kimmaida)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/authorization-and-authentication-for-everyone.md](https://github.com/xitu/gold-miner/blob/master/article/2021/authorization-and-authentication-for-everyone.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[司徒公子](https://github.com/stuchilde)

# 每个人都可以理解的授权访问和身份认证

我们开发的许多应用程序都需要实现身份认证和授权访问功能。或许你已经开发过应用程序，并且通过引入第三方库或者使用身份认证平台来实现这两个功能。

就算你已经做完了所有工作，但你一定不清楚一系列操作的背后发生了**什么**，或者是**为什么**能用特定的方式实现功能。如果你想要对 OAuth 2.0 和 OpenID 连接规范有更深、更基础的理解，那么就请继续读下去吧～

**身份认证是非常困难的**。为什么这么说？虽然身份认证标准拥有一套完善的定义，但要正确使用却很有挑战性。好吧，我们将用易于理解的方式来学习这整个过程。我们会**一步一步地了解认证的概念，在逐步深入的过程中构筑自己的知识体系**。在我们完成的时候，你应该有了一些基础，并知道哪一部分知识是你更想要去深入研究的。

> **这篇文章应该从头读到尾。因为我们会从每个概念的起源入手到原理层面，然后在合适的时机引出其他新的题目。如果你想要跳过文章中的某些内容时，请记得我在这里说的话~**

## 序言

当我告诉我的家人、朋友“我的工作内容和身份认证相关”，他们通常认为我受雇于政府机构发放司机驾驶证或者帮助人们解决信用卡欺诈的问题。

然而，都不是。我之前为 [Auth0](https://auth0.com) 工作，这是一个管理**数字证书**的公司。我现在是 [Auth0 大使计划](https://auth0.com/ambassador-program)的一员，也是 SPPI（安全、隐私、支付、认证）方向的[谷歌开发专家](https://developers.google.com/)。

#### 数字身份

**数字身份**指的是在特定应用的某个方法中能够定义个人用户身份的一系列属性。

这是什么意思？

好比说，你现在正在经营一个线上鞋靴零售公司。用户的**数字身份**可能是他们的信用卡号、配送地址或者购买记录。他们数字证书的具体内容取决于**你的**应用程序。

这就把我们引向了身份认证。

#### 身份认证

广义上来讲，**身份认证**指的是验证用户是否是他们自己声称的那个人的过程。

当一个系统能够实现身份认证之后，我们就要考虑如何为它实现授权访问功能。

#### 授权访问

**授权访问**处理是否允许访问某资源的问题。

#### 标准

你还记得，我在上文中提到过，认证有一套定义完善的标准。但是这些标准一开始从何而来呢？

有许多不同的标准和组织来管理互联网上的工作方式。在讨论身份认证和授权访问的时候，有两个组织是我们**尤其感兴趣的**，它们分别是互联网工程任务组（IETF）和 OpenID 基金会（OIDF）。

##### IETF（互联网工程任务组）

[互联网工程任务组](https://ietf.org)是一个大型开放的国际组织，由网络服务设计者、操作者、供应商和研究人员组成。这些人员密切关注互联网架构的演变，并且希望确保网络服务能够流畅使用。

说真的，有**乐于奉献的专家合作书写技术文档来引导我们以符合互联网规则的方式实现功能**是一件很棒的事情。

##### OIDF （OpenID 基金会）

[OIDF](https://openid.net/foundation/) 是一个非盈利的国际组织。它由致力于实现、优化和维护 OpenID 技术的个人和公司组成。

既然我们已经对这些规范和它们的作者有所了解，让我们再回到**授权访问**的概念:

## OAuth 2.0

当我们谈论 Web 规范的时候，[OAuth 2.0](https://tools.ietf.org/html/rfc6749) 是最常被提及的 Web 规范之一，也是**最容易被误解**的一个，为什么呢？

**OAuth 不是一个身份认证规范**，它处理的是**委托授权访问**。请记住，在这里，身份认证指的是证实用户的身份信息，授权访问指的是授予或拒绝对某资源的访问。 OAuth 2.0 代表用户给应用程序授予权限。（别担心，我们之后会谈到身份认证的部分。）

### 在 OAuth 出现之前

为了理解 OAuth 的目的，我们需要看看它的发展历史。OAuth 1.0 在 2007 年 12 月出台。在此之前，如果我们需要**访问第三方资源**，就会发生如下过程：

[![Before OAuth](https://res.cloudinary.com/practicaldev/image/fetch/s--aZl2UGDl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/before-oauth.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--aZl2UGDl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/before-oauth.gif)

好比说你正在使用一个叫做 HireMe123 的应用程序。HireMe123 想代表你设定一个日历事件（例如面试约会）。但是 HireMe123 没有自己的日历，所以它要使用另一个叫做 MyCalApp 的服务去添加日历事件。

一旦你登录了 HireMe123，它就会**向你请求 MyCalApp 的登录凭证**。你就要在 HireMe123 的站点上输入你在 MyCalApp 的用户名和密码。

HireMe123 之后就可以使用你在 MyCalApp 的账户登录来访问 MyCalApp 的 API，并且能够用你的登录凭证创建日历事件。

#### 共享凭证是一件很糟糕的事情！

这种方法依赖于在两个互不相同的应用程序之间共享用户的个人凭证，这并不是个好方法，为什么？

从一个方面来考虑，HireMe123 承担的保护 MyCalApp 登录信息的责任要小的多。如果 HireMe123 没有给 MyCalApp 的证书提供合适的保护，那它们就有可能被窃取，有的人可能就此窃取事件写一些很可恶的博客文章，但是 **HireMe123** 不会面临着 MyCalApp 那样的指责。

HireMe123 也拥有了对 MyCalApp 过多的访问权限。因为它们使用你的证书去获取那些权限，所以它基本上享有和你相同的访问权限。这意味着 HireMe123 可以读取你的所有日历事件、删除这些事件或者是修改你的日历设置。

### OAuth 协议诞生

OAuth 协议在这种情况下应运而生。

**OAuth 2.0** 是一个开放的用于实现授权访问的标准。作为一个说明书，它能够指导我们如何在不用暴露个人证书的同时给第三方应用授权访问某些 API。

使用 OAuth 协议，用户现在可以**委托** HireMe123 代表用户访问 MyCalApp。MyCalApp 能够在避免共享登录信息或者提供**过多**访问权限的风险的同时控制第三方对于 API 的访问权限。它是像这样工作的：

### 授权访问服务器

**授权服务器**是一组与用户交互并发出令牌的端点。这有什么帮助吗？

让我们使用 OAuth 2.0 重新审视 HireMe123 和 MyCalApp 的例子：

[![Authorization with OAuth 2.0](https://res.cloudinary.com/practicaldev/image/fetch/s--cd8rxwpH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/oauth2.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--cd8rxwpH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/oauth2.gif)

MyCalApp 现在有一台授权访问服务器。我们假定 HireMe123 已经作为已知第三方应用登录到了 MyCalApp，这意味着 MyCalApp 的授权访问服务器认为 HireMe123 可以访问 API。

我们同样假定无论通过什么身份认证方法，你已经登录了 HireMe123 。现在 HireMe123 想要代表你创建一个事件。

HireMe123 向 MyCalApp 的授权访问服务器发送一个授权访问请求。在响应中，MyCalApp 的授权访问服务器允许用户登录（如果你还没有登录过）。这个时候，你就拥有了能够访问 MyCalApp 的权限。

之后，MyCalApp 的授权服务器**提示请您同意**允许 HireMe123 代表你来访问 MyCalApp 的 API。这一提示在浏览器中弹出，然后请求您的同意允许 HireMe123 **添加日历事件** （但仅限于此了）。

如果你同意并且点击确定，之后 MyCalApp 的授权服务器将会发送一个**授权代码**给 HireMe123。这一行为让 HireMe123 知道 MyCalApp 的用户确实同意它代表用户使用 MyCalApp 去添加一个日历事件。

然后 MyCalApp 会给 HireMe123 发送一个**访问令牌**。HireMe123 之后使用这个访问令牌在你同意过的权限许可的范围内调用 MyCalApp 的 API 并使用 API 来创建一个事件。

**此处没有什么不可告人的事情发生！** **MyCalApp 正在要求用户登录 MyCalApp**。HireMe123 并**没有**请求用户的 MyCalApp 证书。共享证书和过多访问权限再也不是问题了。

##### 什么是身份认证？

在这里，我希望 **OAuth 是一个授权访问协议**是一个足够清楚的事实，它不包含**身份认证**。在上述过程中的任一环节都不包含有身份认证，登录被 HireMe123 或是 MyCalApp 上不同的登录过程所控制。OAuth 2.0 在这里**并不规定**这个行为应该怎么做，它只是负责授权第三方访问 API。

那么为什么身份认证和 OAuth 经常被同时提起呢？

## 登录问题

在 OAuth 2.0 为第三方服务访问 API 确立了一个方法之后，接下来的问题就是**应用程序想要用户可以使用其他的应用程序的账户登录**。还是用刚才的例子：假如 HireMe123 想要一个 MyCalApp 的用户**能够用他在 MyCalApp 的账户登录 HireMe123**，即使这个用户还没有 HireMe123 的账户。

但是，正如我们上面所提到的，**OAuth 2.0 是负责授权访问的**，它**不是**一个身份认证协议。但是这并没有阻止人们试图将两个概念当作一个概念对待，这个过程就带来了问题。

### 使用访问令牌做身份认证的问题

假定 HireMe123 使用访问令牌成功地调用 MyCalApp 的 API 意味着当前**用户**通过 HireMe123 进行了身份认证，我们就面临这样一个问题：我们无法确定当前的访问令牌是属于某个特定用户的。

例如：

* 有人可能会从他人处偷窃访问令牌
* 访问令牌可能来自于其他第三方，而不是 HireMe123 ，然后注入到了 HireMe123

这种问题叫做**困惑的副手问题（Confused Deputy Problem）**。HireMe123 不知道这个令牌来自何处或者是这个令牌曾经发行给谁。如果我们还记得一开始的定义：**身份认证是关于确认这个用户是否是他自称的身份**，那么 HireMe123 无法从利用该访问令牌访问 API 的过程中得到这种信息。

正如我们提到过的，这一事实并没能阻止人们继续将访问令牌和将 OAuth 2.0 误用于身份认证。很快我们就会发现，为了在允许使用第三方应用登录的同时确保应用程序和用户安全，我们必须**在 OAuth 2.0 的基础上**构建身份认证协议。

## OpenID 连接

接下来我们要了解的规范叫做 [OpenID 连接](https://openid.net/specs)，也被称作 OIDC。OIDC 是一个**基于 OAuth 2.0** 的规范，它规定了如何认证用户的身份。[OpenID 基金会（OIDF）](https://openid.net/foundation/) 是 OIDC 标准的管理者。

OIDC 是一个使用认证服务器来认证用户身份的认证机制。请记住，认证服务器**发行令牌**，令牌是用于在实体（比如说授权服务器，应用或者是资源 API）之间传递信息的加密过的数据。在使用 OIDC 进行身份认证的情况下，授权服务器发行**ID 令牌**。

### ID 令牌

**ID 令牌**提供关于身份认证的信息并且认定用户身份。ID 令牌是供第三方服务使用的。这些令牌具有固定的格式，第三方能够按照格式解析并且从令牌中提取用户身份信息，因此能够认证用户。

OIDC 声明了一个**固定格式**的 ID 令牌，如下：

#### JSON Web Token（JWT）

[JSON Web Tokens](https://tools.ietf.org/html/rfc7519)，或者说是 [JWT](https://jwt.io) （有时候也被拼成 "jot" ）由三个可以在 URL 中使用的字符串节由`.`连接起来组成的。

##### 头部段

第一个段是**头部段**，它可能看上去类似下面的样子：

`eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9`

头部段是一个包含有签名算法和令牌类型的 JSON 对象，使用 [`base64URL` 编码](https://tools.ietf.org/html/rfc4648#section-5)(字节数据用可以在 URL 和文件名中合法使用的形式表示)

解码后，类似下面：

```
{
  "alg": "RS256",
  "typ": "JWT"
}

```

##### 载荷段

第二个段是**载荷段**。看上去像下面这样：

`eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0`

这是一个包含数据**声明**的 JSON 对象，其中声明了关于用户和身份认证事件的字段，例如：

```
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true,
  "iat": 1516239022
}

```

同样使用 `base64Url` 编码。

##### 加密段

最后一个段叫做**加密段**，或者是**签名**。JWT 是经过签名的，所以不能在传输中篡改它们。当授权服务器发行令牌之后，它就使用密钥来加密令牌。

当第三方收到 ID 令牌之后，第三方同样也使用密钥**验证签名**。（如果使用了非对称加密算法，那么在签名和校验的时候会使用不同的密钥，如果是这样的话，只有授权服务器能够加密令牌。）

> **如果你感到迷惑，别担心。以上一系列工作的细节不应该困扰你或者阻挡你有效的使用基于令牌的授权服务器进行认证。如果你对这些概念、术语以及 JWT 背后的细节很感兴趣，请参考我的文章[人人都能懂的 JWT 签名和验证](https://dev.to/kimmaida/signing-and-validating-json-web-tokens-jwt-for-everyone-25fb)**

#### 字段

既然我们已经知道了 JWT 的组成部分，我们现在要学习的是**字段**。字段是**载荷段**中携带的一系列声明。正如它们的名字所表示的，ID 令牌在字段中提供了**身份认证**信息。

##### 身份认证字段

我们将会从[关于身份认证的字段](https://openid.net/specs/openid-connect-core-1_0.html#IDToken)说起。这里有几个这种字段的例子：

```
{
  "iss": "https://{you}.authz-server.com",
  "aud": "RxHBtq2HL6biPljKRLNByqehlKhN1nCx",
  "exp": 1570019636365,
   "iat": 1570016110289,
   "nonce": "3yAjXLPq8EPP0S",
  ...
}

```

它声明了一些身份认证必须包含的字段，并且包括了一个 ID 令牌：

* `iss` **（发行人）**：JWT 的发行者，例如授权访问服务器。
* `aud` **（接收者）**：JWT 的目标接收者；对于 ID 令牌来说，这个字段一定是接收令牌的应用的 ID。
* `exp` **（过期时间）**：过期时间；在此时间之后 ID 令牌不再有效。
* `iat` **（发行时间）**：ID 令牌发行的时间。

一个 `nonce` 字段**将第三方的授权请求和它接收到的令牌绑定**。nonce 是一个由客户端创建并且随着授权请求一起发送的[加密过的随机字符串](https://auth0.com/docs/api-auth/tutorials/nonce)。之后，授权服务器将 nonce 放在返回给应用程序的令牌中。应用程序检查令牌中的 nonce 是否和它携带在授权请求中的相同。如果相同，这个应用程序就可以确认这个令牌是来自最初指定的授权服务器。

##### 身份字段

字段也包含了[**关于端用户的描述**](https://openid.net/specs/openid-connect-core-1_0.html#StandardClaims)。如下是几个例子：

```
{
  "sub": "google-oauth2|102582972157289381734",
  "name": "Kim Maida",
  "picture": "https://gravatar[...]",
  "twitter": "https://twitter.com/KimMaida",
  "email": "kim@gatsbyjs.com",
  ...
}

```

在 ID 令牌中标准的描述包括如下字段：

* `sub` ** (主题) **: 用户的独特标识符；必填
* `email`
* `email_verified`
* `birthdate`
* **等等...**

我们已经快速地学完了重要规范（[OAuth 2.0](#oauth-20) 和 **OpenID Connect**），现在是时候看看如何**把学到的知识用在实际中**了。

## 使用 ID 令牌的身份认证

让我们在实践中看看 OIDC 身份认证是如何进行的。

> **注意，这只是一个简化的描述。根据你应用程序架构的不同，存在几点差别。**

[![authentication with ID tokens in the browser](https://res.cloudinary.com/practicaldev/image/fetch/s--48HiqoWr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://i.imgur.com/Nl1HyHD.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--48HiqoWr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://i.imgur.com/Nl1HyHD.gif)

在这里我们涉及到的实体有：**浏览器**，一个在浏览器上运行的**应用程序**以及一个**授权服务器**。当一个用户想要登录的时候，应用程序向授权服务器发送一个授权请求。授权服务器检测用户的凭证，如果验证通过，授权服务器就会给应用程序颁发一个 ID 令牌。

客户端应用程序解码 ID 令牌（是一个 **JWT** ）并且校验。这一过程包含了**验签**，并且我们必须校验字段。一些校验字段的例子如下：

* issuer (`iss`)：当前令牌是被特定授权服务器颁发的吗？
* audience (`aud`)：我们的应用程序是这个令牌的指定接收者吗？
* expiration (`exp`)：这个令牌是否在可用的时间段之内？
* nonce (`nonce`)：这个令牌能否匹配到我们应用程序当初创建的授权请求？

一旦我们确认了 ID 令牌的真实性，这个用户就是被**验证**过的。我们同样也得到了**身份声明**并且知道了这个用户是**谁**？

现在，用户是真实的，我们可以和 API 交互了。

## 使用访问令牌访问 API

我们之前谈论过一点访问令牌，在那时我们主要看[ OAuth 2.0 和授权服务器](#authorization-server)是如何授权访问工作的。让我们看看它们工作的**细节**，回到我们 HireMe123 和 MyCalApp 的场景中。

### 访问令牌

**访问令牌**用于**许可对某资源的访问**。用一个 MyCalApp 的授权服务器发行的访问令牌，HireMe123 就可以访问 MyCalApp 的 API。

和 **ID 令牌**将 **OIDC** 声明为 **JSON Web Tokens** 不同，**访问令牌没有明确的、固定的格式**。它们没必要，也不需要局限于 JWT 的格式。然而，许多身份验证解决方案中都将 JWT 格式用于访问令牌，因为这样的格式方便校验。

#### 客户端难以理解访问令牌

访问令牌主要用于**资源 API** 的调用，重要的是它们对客户端是不透明的。为什么？

访问令牌随着时间变化。它们应该有很短的过期时间，所以一个用户可能经常得到新的令牌。它们同样也可以被重新发行用于访问不同的 API 或者是请求不同的许可。**第三方应用程序**不应该包含任何依赖于访问令牌的内容。因为那样的代码是脆弱的，并且基本上一定会有漏洞。

### 访问资源 API

假设我们现在想要使用访问令牌从一个单页面应用去调用 API，这个过程会发生什么呢？

W我们在上面已经讲过了**身份认证**，假设现在用户已经通过浏览器登录在了我们的 JS 应用中。这个应用向授权服务器发送一个授权请求，请求调用某 API 的访问令牌。

[![Accessing an API with an access token](https://res.cloudinary.com/practicaldev/image/fetch/s--ddk-Mi7p--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/api-access.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--ddk-Mi7p--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/api-access.gif)

之后，当我们的应用程序想要和 API 进行交互的时候，我们就把访问令牌添加到请求头中，就像下面这样：

```
# HTTP request headers
Authorization: 'Bearer eyj[...]'

```

这一授权过的请求之后发给 API，在 API 中使用第三方中间件来验证令牌。如果验证通过，API 就返回数据给浏览器中的应用程序。

这很棒，但是可能会有问题。之前我们说过 **OAuth 解决的是访问权限过多的问题**。那么这个问题是如何解决的呢？

### 具有作用域的授权

这个 API 怎么知道它应该给这个发出访问请求的应用程序赋予什么级别的权限呢？我们这里引入一个概念叫做**作用域**。

作用域“[限制了应用程序可以代表用户做什么](https://auth0.com/blog/on-the-nature-of-oauth2-scopes)”。授权过程中不能给用户赋本身没有的权限。例如，如果 MyCalApp 的用户没有新建企业账户的权限，那么授权给 **HireMe123** 的作用域自然也不能允许用户新建企业账户。

作用域**授权访问**对某 API 或者资源。这个 API 之后负责**将传入的作用域和实际用户权限结合起来**确保做出合适的访问控制决定。

让我们继续看这个例子。

我正在使用 HireMe123 并且 HireMe123 想要访问第三方程序 MyCalApp 的 API 来代表我创建一个事件。HireMe123 已经向 MyCalApp 从授权服务器请求了访问令牌**访问令牌**。这个令牌中包含有一些重要信息，比如：

* `sub`：（我的 MyCalApp 用户 ID）
* `aud`：`MyCalAppAPI`（受众字段说明这个令牌是用于访问 MyCalApp 的 API）
* `scope`：`write:events`（作用域说明 HireMe123 有权限使用 API 来在日历中写事件）

HireMe123 向 MyCalApp 的 API 发送一个授权头中包含访问令牌的请求。当 MyCalApp 的 API 接收到这个请求之后，它就知道令牌中包含了 `write:events` 这样的作用域。

但是 MyCalApp 为**成百上千的用户**管理日历事件。除了查看令牌中的 `scope` ，MyCalApp 的 API 还需要检查 `sub` 字段标识符来确定这个来自 HireMe123 的请求仅仅能够使用**我**已有的权限来在**我的**账户上创建事件。

[![delegated authorization with scopes and API access control](https://res.cloudinary.com/practicaldev/image/fetch/s--nmFY08EM--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/scopes.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--nmFY08EM--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/scopes.gif)

在授权访问的背景下，作用域表达了应用程序可以代表用户做什么。它是用户所有权限的子集。

#### 授权许可

还记得什么时候[授权服务器询问 HireMe123 的用户征求他们的同意](#authorization-server)允许 HireMe123 使用用户的权限来访问 MyCalApp 吗？

同意对话框可能像下面这样：

[![consent dialog flow: HireMe123 is requesting access to your MyCalApp account to write:calendars](https://res.cloudinary.com/practicaldev/image/fetch/s--YBRcijw1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/consent.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--YBRcijw1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/consent.gif)

HireMe123 可能要寻求一系列不同的作用域，比如：

* `write:events`
* `read:events`
* `read:settings`
* `write:settings`
* ...等等.

一般来说，我们应该避免使用过多作用域来指定用户权限。作用域用于一个应用程序的授权许可。然而，如果你的授权服务器提供了[基于角色的访问控制 (RBAC) ](https://auth0.com/docs/authorization/concepts/rbac)，那么给个人用户添加不同的作用域确实是**可行**的。

> **使用 RBAC**，你能在授权服务器中给用户角色设置特定的权限。然后，当授权服务器发出访问令牌的时候，它就可以在作用域中包含一个特定的用户角色。

## 资源，接下来是什么？

虽然我们已经看过很多材料了，但我们还远远称不上是了解所有细节。我希望这篇文章可以是一个在身份、授权和认证方面有帮助的速成课。

为了进一步讲明白 JWT，请阅读我的文章[每个人都能懂的 JWT 签名验签](https://dev.to/kimmaida/signing-and-validating-json-web-tokens-jwt-for-everyone-25fb)

如果你想要对这个主题有进一步的了解，这里有一些很好的资源供你进阶学习：

### 了解更多

**[身份认证系列视频](https://auth0.com/docs/videos/learn-identity)** 在 [Auth0 文档](https://auth0.com/docs)中是由主架构师 [Vittorio Bertocci](https://auth0.com/blog/auth0-welcomes-vittorio-bertocci/) 为训练 [Auth0](https://auth0.com) 新入职的认证工程师所制作的讲座。如果你想要根据 Auth0 的标准学习身份认证，这就是完全免费和最容易获得的学习材料，你甚至不需要用推特或邮件进行支付。

**OAuth 2.0 和 OpenID 连接规范**内容很多，但是在你熟悉了术语并且对于认证有了一个基础的理解之后，他们就是非常有帮助、信息丰富并且可理解的材料。点击这里：[ OAuth 2.0 授权框架](https://tools.ietf.org/html/rfc6749) 和 [OpenID 连接规范](https://openid.net/developers/specs/)。

**[JWT.io](https://jwt.io)** 是一个关于 **JSON Web Token** 的资源，主要提供了调试工具和用各种语言实现的 JWT 签名/验签第三方库。

**[OpenID 连接训练场](https://openidconnect.net/)** 是一个允许开发者一步一步调试 **OIDC** 调用和响应的调试器。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
