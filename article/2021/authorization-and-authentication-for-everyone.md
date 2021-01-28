> * 原文地址：[Authorization and Authentication For Everyone](https://dev.to/kimmaida/authorization-and-authentication-for-everyone-27j3)
> * 原文作者：[Kim Maida](https://dev.to/kimmaida)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/authorization-and-authentication-for-everyone.md](https://github.com/xitu/gold-miner/blob/master/article/2021/authorization-and-authentication-for-everyone.md)
> * 译者：
> * 校对者：

# Authorization and Authentication For Everyone
# 每个人都可以理解的授权访问和身份认证

Authentication and authorization are necessary for many of the applications we build. Maybe you've developed apps and implemented authentication and authorization in them — possibly by importing a third party auth library or by using an identity platform.
我们开发的许多应用程序都需要实现身份认证和授权访问功能。或许你已经开发过应用程序，然后很可能是通过引入第三方库或者是使用一个统一认证平台来实现身份认证和授权访问功能。

Maybe you got the job done, but you really weren't clear on **what** was happening behind the scenes, or **why** things were being done a certain way. If you'd like to build a foundational understanding of what goes on behind the scenes when using OAuth 2.0 and OpenID Connect standards, read on!
或许你已经做完了所有工作，但你一定不清楚一系列操作的背后发生了**什么**，或者是**为什么**能用这样的方式实现特定的功能。如果你想要对 OAuth 2.0 和 OpenID Connect 规范背后的流程有更深的理解，那么就继续读下去吧。

---

**Authentication is hard.** Why is this? Auth standards are well defined — but challenging to get right. And that's okay! We're going to go through it in an approachable way. We'll address the **concepts of identity step by step, building on our knowledge as we go along.** By the time we're done, you should have a foundation and know where you might want to dig deeper.
**身份认证是非常困难的**。为什么这么说？虽然身份认证协议拥有一套完善的定义，但是它也在一直接受挑战。好吧。我们将用可理解的方式来贯穿整个学习过程。我们会**一步一步地了解认证的概念，在深入的过程中构筑自己的知识体系**。在我们结束这一过程的时候，我们将拥有一个很好的基础并且知道哪个知识点是你更想要去深入研究的。

> **This post is meant to be read from beginning to end. We'll build on top of each concept to layer knowledge when it makes sense to introduce new topics. Please keep that in mind if you're jumping around in the content.**
> **这篇文章值得从头读到尾。我们从每个概念的初始入手到知识层，然后引出其他新的题目。如果你想要跳过文章中的某些内容时，请记得我在这里说的话。**

## Introduction
## 序言

When I told family or friends that I "work in identity," they often assumed that meant I was employed by the government issuing driver's licenses, or that I helped people resolve credit card fraud.
当我告诉我的家人、朋友“我在为认证工作”，他们通常认为我受雇于政府机构去检查司机驾驶证或者时帮助人们解决信用卡欺诈的问题。

However, neither were true. I [formerly worked for Auth0](https://auth0.com), a company that manages **digital identity**. (I'm now a member of the [Auth0 Ambassadors program](https://auth0.com/ambassador-program), and a [Google Developer Expert](https://developers.google.com/) in SPPI: Security, Privacy, Payments, and Identity.)
然而，都不是。我之前为 [Auth0](https://auth0.com) 工作，这是一个管理**数字证书**的公司。我现在是 [Auth0 大使计划](https://auth0.com/ambassador-program)的一员，也是 SPPI(安全、隐私、支付、认证) 方向的[谷歌开发专家](https://developers.google.com/)。

#### Digital Identity
#### 数字证书

**Digital identity** refers to a set of attributes that define an individual user in the context of a function delivered by a particular application.
**数字证书**指的是在一个特定应用的某个方法中能够定义一个个人用户身份的一系列属性。

What does that mean?
什么意思？

Say you run an online shoe retail company. The **digital identity** of your app's users might be their credit card number, shipping address, and purchase history. Their digital identity is contextual to **your** app.
好比说，你现在正在经营一个线上鞋靴零售公司。你的用户的**数字证书**可能是他们的信用卡号、收货地址或者购买记录。他们的数字证书内容取决于**你的**应用程序。

This leads us to...
这将引导我们走向下一个概念。

#### Authentication
#### 身份认证

In a broad sense, **authentication** refers to the process of verifying that a user is who they say they are.
广义上来讲，**身份认证**指的是一个验证用户是否具有他自己声称的身份的过程。

Once a system has been able to establish this, we come to...
一旦一个系统能够实现身份认证，我们就来到了下一个概念。

#### Authorization
#### 授权访问

**Authorization** deals with granting or denying rights to access resources.
**授权访问**问题与是否允许对某资源的访问有关。

#### Standards
#### 标准

You may recall that I mentioned that auth is guided by clearly-defined standards. But where do these standards come from in the first place?
你还记得，我在上文中提到过，认证过程是被定义完善的标准所引导的。但是这些标准一开始是怎么来的呢？

There are many different standards and organizations that govern how things work on the internet. Two bodies that are of **particular interest to us in the context of authentication and authorization** are the Internet Engineering Task Force (IETF) and the OpenID Foundation (OIDF).
现在有很多组织和标准来管理互联网上的事情是如何工作的。在讨论身份认证和授权访问的时候，有两个组织是我们尤其感兴趣的--互联网工程任务组(ietf)和OpenID基金会(oidf)。

##### IETF (Internet Engineering Task Force)
##### IETF（互联网工程任务组）

The [IETF](https://ietf.org) is a large, open, international community of network designers, operators, vendors, and researchers who are concerned with the evolution of internet architecture and the smooth operation of the internet.
[互联网工程任务组](https://ietf.org)是一个大型开放的国际组织，由密切关注网络架构的法阵和网络服务的流畅使用的网络服务设计者、操作者、供应商和研究者组成。

Really, that's a fancy way to say that **dedicated professionals cooperate to write technical documents that guide us in how things should be done on the internet.**
说真的，**乐于奉献的专家合作书写技术文档来引导我们功能应该如何以符合互联网规则的方式来完成**是一件很棒的事情。

##### OIDF (OpenID Foundation)
##### OpenID 基金会

The [OIDF](https://openid.net/foundation/) is a non-profit, international organization of people and companies who are committed to enabling, promoting, and protecting OpenID technologies.
[OIDF](https://openid.net/foundation/)是一个非盈利的国际组织。它由致力于实现、优化和提升 OpenID 技术的个人和公司组成。

Now that we are aware of the specs and who writes them, let's circle back around to **authorization** and talk about:
既然我们已经对这些规范和它们的作者有所了解，让我们再回到**授权访问**的概念:

## OAuth 2.0
## OAuth 2.0

[OAuth 2.0](https://tools.ietf.org/html/rfc6749) is one of the most frequently mentioned specs when it comes to the web — and also one that is **often mis-represented or misunderstood**. How so?
当我们谈论 web 规范的时候，[OAuth 2.0](https://tools.ietf.org/html/rfc6749) 是最通常被提到的一个，也是**最容易被误解**的一个，怎么会这样呢？

**OAuth is not an authentication spec.** OAuth deals with **delegated authorization**. Remember that authentication is about verifying the identity of a user. Authorization deals with granting or denying access to resources. OAuth 2.0 grants access to applications on the behalf of users. (Don't worry, we'll get to the authentication part in a little bit!)
**OAuth 不是一个身份认证协议**，它处理的是**授权的资源访问**。请记住，在这里我们提到的身份认证指的是证实用户的身份信息，授权解决的是授予或收回对资源的访问权限。 OAuth 2.0代表用户给应用程序授予权限。（别担心，我们之后就会到身份认证的部分。）

### Before OAuth
### OAuth 之前

To understand the purpose of OAuth, we need to do go back in time. OAuth 1.0 was established in December 2007. Before then, if we needed to **access third party resources**, it looked like this:
为了理解 OAuth 的目的，我们需要及时回顾。 OAuth 1.0在2007年12月出台。在此之前，如果我们需要**访问第三方资源**，就会发生如下过程：

[![Before OAuth](https://res.cloudinary.com/practicaldev/image/fetch/s--aZl2UGDl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/before-oauth.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--aZl2UGDl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/before-oauth.gif)

Let's say you used an app called HireMe123. HireMe123 wants to set up a calendar event (such as an interview appointment) on your (the user's) behalf. HireMe123 doesn't have its own calendar; it wants to use another service called MyCalApp to add events.
好比说你正在使用一个叫做 HireMe123 的应用程序。 HireMe123 想代表你设定一个日历事件（例如面试约会）。HireMe123没有自己的日历，它想要使用另一个叫做 MyCalApp 的服务去添加一个事件。

Once you were logged into HireMe123, HireMe123 would **ask you for your MyCalApp login credentials**. You would enter your MyCalApp username and password into HireMe123's site.
一旦你登录了 HireMe123 ，它就会**向你要 MyCalApp 的登录授权许可**。你就要在 HireMe123 的站点上输入你在 MyCalApp 的用户名和密码。

HireMe123 then used your MyCalApp login to gain access to MyCalApp's API, and could then create calendar events using **your** MyCalApp credentials.
HireMe123 之后就可以使用你在 MyCalApp 的账户登录并访问 MyCalApp 的API，并且能够用你的账户信息创建日历事件。

#### Sharing Credentials is Bad!
#### 证书共享是一件很糟糕的事情！

This approach relied on sharing a user's personal credentials from one app with a completely different app, and this is **not good**. How so?
这种方法依赖于在两个互不相同的应用程序之间共享用户的个人证书，这种方法并不好，为什么？

For one thing, HireMe123 had **much less at stake** in the protection of your MyCalApp login information. If HireMe123 didn't protect your MyCalApp credentials appropriately and they ended up stolen or breached, someone might write some nasty blog articles, but **HireMe123** wouldn't face a catastrophe the way MyCalApp would.
从一个方面来考虑， HireMe123 面临的保护 MyCalApp 登录信息的责任要小的多。如果 HireMe123 没有给你的 MyCalApp 证书提供合适的保护，那它们就有可能被窃取，有的人可能就此窃取事件写一些很可恶的报道，但是**HireMe123**不会面临着 MyCalApp 那样的指责。

HireMe123 also had **way too much access** to MyCalApp. HireMe123 had the same amount of access that you did, because they used your credentials to gain that access. That meant that HireMe123 could read all your calendar events, delete events, modify your calendar settings, etc.
HireMe123 也拥有了对 MyCalApp 过多的访问权限，它基本上享有和你相同的访问权限，因为它们使用你的证书去获取那些权限。这意味着 HireMe123 可以读取你的所有日历事件、删除这些事件或者是修改你的日历设置。

### Enter OAuth
### 来到 OAuth

This leads us to OAuth.
OAuth 协议在这种情况下应运而生。

**OAuth 2.0** is an open standard for performing delegated authorization. It's a specification that tells us how to grant third party access to APIs without exposing credentials.
**OAuth 2.0**是一个开放的用于实现授权访问的标准。作为一个说明书，它能够知道我们如何给第三方应用授权访问某些api而不用暴露个人证书。

Using OAuth, the user can now **delegate** HireMe123 to call MyCalApp on the user's behalf. MyCalApp can limit access to its API when called by third party clients without the risks of sharing login information or providing **too much** access. It does this using an:
使用 OAuth 协议，用户现在可以**授权** HireMe123 代表用户去调用 MyCalApp。 MyCalApp 能够在避免共享登录信息或者提供**太多**访问权限的情况下控制第三方对于API的访问权限。它是像这样工作的：

### Authorization Server
### 授权访问服务器

An **authorization server** is a set of endpoints to interact with the user and issue tokens. How does this help?
**授权访问服务器**是一系列端点的集合，这些端点用于和用户交互并且标记问题。这一过程对我们的授权访问有什么帮助呢？

Let's revisit the situation with HireMe123 and MyCalApp, only now we have OAuth 2.0:
让我们使用 OAuth 2.0重新审视 HireMe123 和 MyCalApp 的例子：

[![Authorization with OAuth 2.0](https://res.cloudinary.com/practicaldev/image/fetch/s--cd8rxwpH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/oauth2.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--cd8rxwpH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/oauth2.gif)

MyCalApp now has an authorization server. Let's assume that HireMe123 has already registered as a known client with MyCalApp, which means that MyCalApp's authorization server recognizes HireMe123 as an entity that may ask for access to its API.
MyCalApp 现在有一台授权访问服务器。我们假定 HireMe123 已经作为一个已知用户登录到了 MyCalApp，这意味着 MyCalApp 的授权访问服务器将 HireMe123 标识为一个能够访问它API的外部实体。

Let's also assume you're already logged in with HireMe123 through whatever authentication HireMe123 has set up for itself. HireMe123 now wants to create events on your behalf.
我们也同样假定无论通过什么授权手段，你已经登录到了 HireMe123 。现在 HireMe123 想要代表你创建一个事件。

HireMe123 sends an **authorization request** to MyCalApp's authorization server. In response, MyCalApp's authorization server prompts you — the user — to log in with MyCalApp (if you're not already logged in). You authenticate with MyCalApp.
HireMe123 向 MyCalApp 的授权访问服务器发送一个授权访问请求。在响应中， MyCalApp 的授权访问服务器允许用户登录（如果你已经登录过）。这个时候，你就拥有了访问 MyCalApp 的授权。

The MyCalApp authorization server then **prompts you for your consent** to allow HireMe123 to access MyCalApp's APIs on your behalf. A prompt opens in the browser and specifically asks for your consent to let HireMe123 **add calendar events** (but no more than that).
之后， MyCalApp 的授权服务器**提示请您同意**允许 HireMe123 代表你来访问 MyCalApp的 API。这一提示在浏览器中弹出，然后请求您的同意允许 HireMe123 **添加日历事件** （但仅限于此了）。

If you say yes and grant your consent, then the MyCalApp authorization server will send an **authorization code** to HireMe123. This lets HireMe123 know that the MyCalApp user (you) did indeed agree to allow HireMe123 to add events using the user's (your) MyCalApp.
如果你同意并且点击确定，之后 MyCalApp 的授权服务器将会发送一个**授权代码**给 HireMe123。这一行为让 HireMe123 知道 MyCalApp 的用户确实同意它代表用户使用 MyCalApp 去添加一个日历事件。

MyCalApp will then issue an **access token** to HireMe123. HireMe123 can use that access token to call the MyCalApp API within the scope of permissions that were accepted by you and create events for you using the MyCalApp API.
然后 MyCalApp 会给 HireMe123 发送一个**访问令牌**。 HireMe123 之后使用这个访问令牌在你能够接受的权限许可的范围内调用 MyCalApp 的 API 并使用 MyCalApp 的API来创建一个事件。

**Nothing insidious is happening now!** **MyCalApp is asking the user to log in with MyCalApp**. HireMe123 is **not** asking for the user's MyCalApp credentials. The issues with sharing credentials and too much access are no longer a problem.
**此处没有什么不可告人的事情发生！** **MyCalApp 正在要求用户登录 MyCalApp** 。 HireMe123 并**没有**请求用户的 MyCalApp 证书。共享证书和过多访问权限再也不能成为问题了。

##### What About Authentication?
##### 什么是身份认证？

At this point, I hope it's been made clear that **OAuth is for delegated access**. It doesn't cover **authentication**. At any point where authentication was involved in the processes we covered above, login was managed by whatever login process HireMe123 or MyCalApp had implemented at their own discretion. OAuth 2.0 **didn't prescribe how** this should be done: it only covered authorizing third party API access.
在这里，我希望**OAuth是一个授权访问协议**已经足够清楚了。它不包含身份认证。在上述过程中的任一环节都不包含有身份认证，登录被 HireMe123 或是 MyCalApp 的登录过程自行控制。 OAuth 2.0 在这里并不规定这个行为应该怎么做：它只是负责授权第三方访问API。

So why are authentication and OAuth so often mentioned in the same breath?
那么为什么身份认证和 OAuth 经常被同时提起呢？

## The Login Problem
## 登录问题

The thing that happened after OAuth 2.0 established a way to access third party APIs was that **apps also wanted to log users in with other accounts**. Using our example: let's say HireMe123 wanted a MyCalApp user to be able to **log into HireMe123 using their MyCalApp account**, despite not having signed up for a HireMe123 account.
在 OAuth 2.0 为第三方服务访问API确立了一个方法之后，接下来的问题就是**应用程序同样想要用户可以使用其他的应用程序的账户登录。**还是用刚才的例子：假如 HireMe123 想要一个 MyCalApp 的用户能够用他在 MyCalApp 的账户登录，虽然这个用户还没有 HireMe123 的账户。

But as we mentioned above, **OAuth 2.0 is for delegated access**. It is **not** an authentication protocol. That didn't stop people from trying to use it like one though, and this presented problems.
但是，正如我们上面所提到的，**OAuth 2.0 是负责授权访问的**，他不是一个身份认证协议。虽然这并没有阻止人们尝试就像一个概念那样使用它，这个过程就带来了问题。

### Problems with Using Access Tokens for Authentication
### 使用访问令牌做身份认证的问题

If HireMe123 assumes successfully calling MyCalApp's API with an access token means the **user** can be considered authenticated with HireMe123, we run into problems because we have no way to verify the access token was issued to a particular individual.
假定 HireMe123 使用访问令牌成功地调用g MyCalApp的 API 意味着当前**用户**等同于 HireMe123 进行了身份认证，我们就面临这样一个问题：我们无法确定当前的访问令牌是属于某个特定用户的。

For example:
例如：

* Someone could have stolen the access token from a different user
* 有人可能会从他人处偷窃访问令牌
* The access token could have been obtained from another client (not HireMe123) and injected into HireMe123
* 

This is called the **confused deputy problem**. HireMe123 doesn't know **where** this token came from or **who** it was issued for. If we recall: **authentication is about verifying the user is who they say they are**. HireMe123 can't know this from the fact that it can use this access token to access an API.

As mentioned, this didn't stop people from misusing access tokens and OAuth 2.0 for authentication anyway. It quickly became evident that formalization of authentication **on top of OAuth 2.0** was necessary to allow logins with third party applications while keeping apps and their users safe.

## OpenID Connect

This brings us to the specification called [OpenID Connect](https://openid.net/specs), or OIDC. OIDC is a spec **on top of OAuth 2.0** that says how to authenticate users. The [OpenID Foundation (OIDF)](https://openid.net/foundation/) is the steward of the OIDC standards.

OIDC is an identity layer for authenticating users with an authorization server. Remember that an authorization server **issues tokens**. **Tokens** are encoded pieces of data for transmitting information between parties (such as an authorization server, application, or resource API). In the case of OIDC and authentication, the authorization server issues **ID tokens**.

### ID Tokens

**ID tokens** provide information about the authentication event and they identify the user. ID tokens are **intended for the client**. They're a fixed format that the client can parse and validate to extract identity information from the token and thereby authenticate the user.

OIDC declares a **fixed format** for ID tokens, which is:

#### JSON Web Token (JWT)

[JSON Web Tokens](https://tools.ietf.org/html/rfc7519), or [JWT](https://jwt.io) (sometimes pronounced "jot"), are composed of three URL-safe string segments concatenated with periods `.`

##### Header Segment

The first segment is the **header segment**. It might look something like this:

`eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9`

The header segment is a JSON object containing a signing algorithm and token type. It is [`base64Url` encoded](https://tools.ietf.org/html/rfc4648#section-5) (byte data represented as text that is URL and filename safe).

Decoded, it looks something like this:  

```
{
  "alg": "RS256",
  "typ": "JWT"
}

```

##### Payload Segment

The second segment is the **payload segment**. It might look like this:

`eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0`

This is a JSON object containing data ****claims****, which are statements about the user and the authentication event. For example:  

```
{
  "sub": "1234567890",
  "name": "John Doe",
  "admin": true,
  "iat": 1516239022
}

```

This is also `base64Url` encoded.

##### Crypto Segment

The final segment is the **crypto segment**, or **signature**. JWTs are signed so they can't be modified in transit. When an authorization server issues a token, it signs it using a key.

When the client receives the ID token, the client **validates the signature** using a key as well. (If an asymmetric signing algorithm was used, different keys are used to sign and validate; if this is case, only the authorization server holds the ability to sign tokens.)

> **Don't worry if this seems confusing. The details of how this works shouldn't trouble you or keep you from effectively using an authorization server with token-based authentication. If you're interested in demystifying the terms, jargon, and details behind JWT signing, check out my article on [Signing and Validating JSON Web Tokens (JWT) for Everyone](https://dev.to/kimmaida/signing-and-validating-json-web-tokens-jwt-for-everyone-25fb).**

#### Claims

Now that we know about the **anatomy** of a JWT, let's talk more about the **claims**, those statements from the **Payload Segment**. As per their moniker, ID tokens provide **identity** information, which is present in the claims.

##### Authentication Claims

We'll start with **[statements about the authentication event](https://openid.net/specs/openid-connect-core-1_0.html#IDToken)**. Here are a few examples of these claims:  

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

Some of the required authentication claims in an ID token include:

* `iss` **(issuer)**: the issuer of the JWT, e.g., the authorization server
* `aud` **(audience)**: the intended recipient of the JWT; for ID tokens, this must be the client ID of the application receiving the token
* `exp` **(expiration time)**: expiration time; the ID token must not be accepted after this time
* `iat` **(issued at time)**: time at which the ID token was issued

A `nonce` **binds the client's authorization request to the token it receives**. The nonce is a [cryptographically random string](https://auth0.com/docs/api-auth/tutorials/nonce) that the client creates and sends with an authorization request. The authorization server then places the nonce in the token that is sent back to the app. The app verifies that the nonce in the token matches the one sent with the authorization request. This way, the app can verify that the token came from the place it requested the token from in the first place.

##### Identity Claims

Claims also include **[statements about the end user](https://openid.net/specs/openid-connect-core-1_0.html#StandardClaims)**. Here are a few examples of these claims:  

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

Some of the standard profile claims in an ID token include:

* `sub` **(subject)**: unique identifier for the user; required
* `email`
* `email_verified`
* `birthdate`
* **etc.**

We've now been through a crash-course on the important specifications ([OAuth 2.0](#oauth-20) and **OpenID Connect**) and it's time to see how to **put our identity knowledge to work**.

## Authentication with ID Tokens

Let's see OIDC authentication in practice.

> **Note that this is a simplified diagram. There are a few different flows depending on your application architecture.**

[![authentication with ID tokens in the browser](https://res.cloudinary.com/practicaldev/image/fetch/s--48HiqoWr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://i.imgur.com/Nl1HyHD.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--48HiqoWr--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://i.imgur.com/Nl1HyHD.gif)

Our entities here are: the **browser**, an **application** running in the browser, and the **authorization server**. When a user wants to log in, the app sends an authorization request to the authorization server. The user's credentials are verified by the authorization server, and if everything checks out, the authorization server issues an ID token to the application.

The client application then decodes the ID token (which is a **JWT**) and verifies it. This includes **validating the signature**, and we must also verify the claims. Some examples of claim verification include:

* issuer (`iss`): was this token issued by the expected authorization server?
* audience (`aud`): is our app the target recipient of this token?
* expiration (`exp`): is this token within a valid timeframe for use?
* nonce (`nonce`): can we tie this token back to the authorization request our app made?

Once we've established the authenticity of the ID token, the user is **authenticated**. We also now have access to the **identity claims** and know **who** this user is.

Now the user is **authenticated**. It's time to interact with an API.

## Accessing APIs with Access Tokens

We talked a bit about access tokens earlier, back when we were looking at how delegated access works with [OAuth 2.0 and authorization servers](#authorization-server). Let's look at some of the **details** of how that works, going back to our scenario with HireMe123 and MyCalApp.

### Access Tokens

**Access tokens** are used for **granting access to resources**. With an access token issued by MyCalApp's authorization server, HireMe123 can access MyCalApp's API.

Unlike **ID tokens**, which **OIDC** declares as **JSON Web Tokens**, **access tokens have no specific, defined format**. They do not have to be (and aren't necessarily) JWT. However, many identity solutions use JWTs for access tokens because the format enables validation.

#### Access Tokens are Opaque to the Client

Access tokens are for the **resource API** and it is important that they are **opaque to the client.** Why?

Access tokens can change at any time. They should have short expiration times, so a user may frequently get new ones. They can also be re-issued to access different APIs or exercise different permissions. The **client** application should never contain code that relies on the contents of the access token. Code that does so would be brittle, and is almost guaranteed to break.

### Accessing Resource APIs

Let's say we want to use an access token to call an API from a Single Page Application. What does this look like?

We've covered **authentication** above, so let's assume the user is logged into our JS app in the browser. The app sends an authorization request to the authorization server, requesting an access token to call an API.

[![Accessing an API with an access token](https://res.cloudinary.com/practicaldev/image/fetch/s--ddk-Mi7p--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/api-access.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--ddk-Mi7p--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/api-access.gif)

Then when our app wants to interact with the API, we attach the access token to the request header, like so:  

```
# HTTP request headers
Authorization: 'Bearer eyj[...]'

```

The authorized request is then sent to the API, which verifies the token using middleware. If everything checks out, then the API returns data (e.g., JSON) to the application running in the browser.

This is great, but there's something that may be occurring to you right about now. Earlier, we stated that **OAuth solves problems with too much access**. So how is that being addressed here?

### Delegation with Scopes

How does the API know what level of access it should give to the application that's requesting use of its API? We do this with **scopes**.

Scopes "[limit what an application can do on the behalf of a user](https://auth0.com/blog/on-the-nature-of-oauth2-scopes)." They **cannot grant privileges the user doesn't already have**. For example, if the MyCalApp user doesn't have permission to set up new MyCalApp enterprise accounts, scopes granted to **HireMe123** won't ever allow the user to set up new enterprise accounts either.

Scopes **delegate access control** to the API or resource. The API is then responsible for **combining incoming scopes with actual user privileges** to make the appropriate access control decisions.

Let's walk through this with an example.

I'm using the HireMe123 app and HireMe123 wants to access the third party MyCalApp API to create events on my behalf. HireMe123 has already requested an **access token** for MyCalApp from MyCalApp's authorization server. This token has some important information in it, such as:

* `sub`: (my MyCalApp user ID)
* `aud`: `MyCalAppAPI` (audience stating this token is intended for the MyCalApp API)
* `scope`: `write:events` (scope saying HireMe123 has permission to use the API to write events to my calendar)

HireMe123 sends a request to the MyCalApp API with the access token in its authorization header. When the MyCalApp API receives this request, it can see that the token contains a `write:events` scope.

But MyCalApp hosts calendar accounts for **hundreds of thousands of users**. In addition to looking at the `scope` in the token, MyCalApp's API middleware needs to check the `sub` subject identifier to make sure this request from HireMe123 is only able to exercise **my** privileges to create events with **my** MyCalApp account.

[![delegated authorization with scopes and API access control](https://res.cloudinary.com/practicaldev/image/fetch/s--nmFY08EM--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/scopes.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--nmFY08EM--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/scopes.gif)

In the context of delegated authorization, scopes express what an application can do on the user's behalf. They're a subset of the user's total capabilities.

#### Granting Consent

Remember when the [authorization server asked the HireMe123 user for their consent](#authorization-server) to allow HireMe123 to use the user's privileges to access MyCalApp?

That consent dialog might look something like this:

[![consent dialog flow: HireMe123 is requesting access to your MyCalApp account to write:calendars](https://res.cloudinary.com/practicaldev/image/fetch/s--YBRcijw1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/consent.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--YBRcijw1--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/consent.gif)

HireMe123 could ask for a variety of different scopes, for example:

* `write:events`
* `read:events`
* `read:settings`
* `write:settings`
* ...etc.

In general, we should avoid overloading scopes with user-specific privileges. Scopes are for delegated permissions for an application. However, it **is** possible to add different scopes to individual users if your authorization server provides [Role-Based Access Control (RBAC)](https://auth0.com/docs/authorization/concepts/rbac).

> **With **RBAC**, you can set up user roles with specific permissions in your authorization server. Then when the authorization server issues access tokens, it can include a specific user's roles in their scopes.**

## Resources and What's Next?

We covered a **lot** of material, and it still wasn't anywhere close to everything. I do hope this was a helpful crash course in identity, authorization, and authentication.

To further demystify JWT, read my article [Signing and Validating JSON Web Tokens for Everyone](https://dev.to/kimmaida/signing-and-validating-json-web-tokens-jwt-for-everyone-25fb).

If you'd like to learn much, much more on these topics, here are some great resources for you to further your knowledge:

### Learn More

The **[Learn Identity](https://auth0.com/docs/videos/learn-identity) video series** in the [Auth0 docs](https://auth0.com/docs) is the lecture portion of the new hire identity training for engineers at [Auth0](https://auth0.com), presented by Principal Architect [Vittorio Bertocci](https://auth0.com/blog/auth0-welcomes-vittorio-bertocci/). If you'd like to learn identity the way it’s done at Auth0, it's completely free and available to everyone (you don't even have to pay with a tweet or email!).

The **OAuth 2.0 and OpenID Connect specifications** are dense, but once you're familiar with the terminology and have foundational identity knowledge, they're helpful, informative, and become much more digestible. Check them out here: [The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749) and [OpenID Connect Specifications](https://openid.net/developers/specs/).

**[JWT.io](https://jwt.io)** is a **JSON Web Token** resource that provides a debugger tool and directory of JWT signing/verification libraries for various technologies.

The **[OpenID Connect Playground](https://openidconnect.net/)** is a debugger that lets developers explore and test **OIDC** calls and responses step-by-step.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。