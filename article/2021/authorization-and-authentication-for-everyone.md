> * 原文地址：[Authorization and Authentication For Everyone](https://dev.to/kimmaida/authorization-and-authentication-for-everyone-27j3)
> * 原文作者：[Kim Maida](https://dev.to/kimmaida)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/authorization-and-authentication-for-everyone.md](https://github.com/xitu/gold-miner/blob/master/article/2021/authorization-and-authentication-for-everyone.md)
> * 译者：
> * 校对者：

# Authorization and Authentication For Everyone

Authentication and authorization are necessary for many of the applications we build. Maybe you've developed apps and implemented authentication and authorization in them — possibly by importing a third party auth library or by using an identity platform.

Maybe you got the job done, but you really weren't clear on **what** was happening behind the scenes, or **why** things were being done a certain way. If you'd like to build a foundational understanding of what goes on behind the scenes when using OAuth 2.0 and OpenID Connect standards, read on!

---

**Authentication is hard.** Why is this? Auth standards are well defined — but challenging to get right. And that's okay! We're going to go through it in an approachable way. We'll address the **concepts of identity step by step, building on our knowledge as we go along.** By the time we're done, you should have a foundation and know where you might want to dig deeper.

> **This post is meant to be read from beginning to end. We'll build on top of each concept to layer knowledge when it makes sense to introduce new topics. Please keep that in mind if you're jumping around in the content.**

## Introduction

When I told family or friends that I "work in identity," they often assumed that meant I was employed by the government issuing driver's licenses, or that I helped people resolve credit card fraud.

However, neither were true. I [formerly worked for Auth0](https://auth0.com), a company that manages **digital identity**. (I'm now a member of the [Auth0 Ambassadors program](https://auth0.com/ambassador-program), and a [Google Developer Expert](https://developers.google.com/) in SPPI: Security, Privacy, Payments, and Identity.)

#### Digital Identity

**Digital identity** refers to a set of attributes that define an individual user in the context of a function delivered by a particular application.

What does that mean?

Say you run an online shoe retail company. The **digital identity** of your app's users might be their credit card number, shipping address, and purchase history. Their digital identity is contextual to **your** app.

This leads us to...

#### Authentication

In a broad sense, **authentication** refers to the process of verifying that a user is who they say they are.

Once a system has been able to establish this, we come to...

#### Authorization

**Authorization** deals with granting or denying rights to access resources.

#### Standards

You may recall that I mentioned that auth is guided by clearly-defined standards. But where do these standards come from in the first place?

There are many different standards and organizations that govern how things work on the internet. Two bodies that are of **particular interest to us in the context of authentication and authorization** are the Internet Engineering Task Force (IETF) and the OpenID Foundation (OIDF).

##### IETF (Internet Engineering Task Force)

The [IETF](https://ietf.org) is a large, open, international community of network designers, operators, vendors, and researchers who are concerned with the evolution of internet architecture and the smooth operation of the internet.

Really, that's a fancy way to say that **dedicated professionals cooperate to write technical documents that guide us in how things should be done on the internet.**

##### OIDF (OpenID Foundation)

The [OIDF](https://openid.net/foundation/) is a non-profit, international organization of people and companies who are committed to enabling, promoting, and protecting OpenID technologies.

Now that we are aware of the specs and who writes them, let's circle back around to **authorization** and talk about:

## OAuth 2.0

[OAuth 2.0](https://tools.ietf.org/html/rfc6749) is one of the most frequently mentioned specs when it comes to the web — and also one that is **often mis-represented or misunderstood**. How so?

**OAuth is not an authentication spec.** OAuth deals with **delegated authorization**. Remember that authentication is about verifying the identity of a user. Authorization deals with granting or denying access to resources. OAuth 2.0 grants access to applications on the behalf of users. (Don't worry, we'll get to the authentication part in a little bit!)

### Before OAuth

To understand the purpose of OAuth, we need to do go back in time. OAuth 1.0 was established in December 2007. Before then, if we needed to **access third party resources**, it looked like this:

[![Before OAuth](https://res.cloudinary.com/practicaldev/image/fetch/s--aZl2UGDl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/before-oauth.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--aZl2UGDl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/before-oauth.gif)

Let's say you used an app called HireMe123. HireMe123 wants to set up a calendar event (such as an interview appointment) on your (the user's) behalf. HireMe123 doesn't have its own calendar; it wants to use another service called MyCalApp to add events.

Once you were logged into HireMe123, HireMe123 would **ask you for your MyCalApp login credentials**. You would enter your MyCalApp username and password into HireMe123's site.

HireMe123 then used your MyCalApp login to gain access to MyCalApp's API, and could then create calendar events using **your** MyCalApp credentials.

#### Sharing Credentials is Bad!

This approach relied on sharing a user's personal credentials from one app with a completely different app, and this is **not good**. How so?

For one thing, HireMe123 had **much less at stake** in the protection of your MyCalApp login information. If HireMe123 didn't protect your MyCalApp credentials appropriately and they ended up stolen or breached, someone might write some nasty blog articles, but **HireMe123** wouldn't face a catastrophe the way MyCalApp would.

HireMe123 also had **way too much access** to MyCalApp. HireMe123 had the same amount of access that you did, because they used your credentials to gain that access. That meant that HireMe123 could read all your calendar events, delete events, modify your calendar settings, etc.

### Enter OAuth

This leads us to OAuth.

**OAuth 2.0** is an open standard for performing delegated authorization. It's a specification that tells us how to grant third party access to APIs without exposing credentials.

Using OAuth, the user can now **delegate** HireMe123 to call MyCalApp on the user's behalf. MyCalApp can limit access to its API when called by third party clients without the risks of sharing login information or providing **too much** access. It does this using an:

### Authorization Server

An **authorization server** is a set of endpoints to interact with the user and issue tokens. How does this help?

Let's revisit the situation with HireMe123 and MyCalApp, only now we have OAuth 2.0:

[![Authorization with OAuth 2.0](https://res.cloudinary.com/practicaldev/image/fetch/s--cd8rxwpH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/oauth2.gif)](https://res.cloudinary.com/practicaldev/image/fetch/s--cd8rxwpH--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_66%2Cw_880/https://kmaida.io/static/devto/authz-authn/oauth2.gif)

MyCalApp now has an authorization server. Let's assume that HireMe123 has already registered as a known client with MyCalApp, which means that MyCalApp's authorization server recognizes HireMe123 as an entity that may ask for access to its API.

Let's also assume you're already logged in with HireMe123 through whatever authentication HireMe123 has set up for itself. HireMe123 now wants to create events on your behalf.

HireMe123 sends an **authorization request** to MyCalApp's authorization server. In response, MyCalApp's authorization server prompts you — the user — to log in with MyCalApp (if you're not already logged in). You authenticate with MyCalApp.

The MyCalApp authorization server then **prompts you for your consent** to allow HireMe123 to access MyCalApp's APIs on your behalf. A prompt opens in the browser and specifically asks for your consent to let HireMe123 **add calendar events** (but no more than that).

If you say yes and grant your consent, then the MyCalApp authorization server will send an **authorization code** to HireMe123. This lets HireMe123 know that the MyCalApp user (you) did indeed agree to allow HireMe123 to add events using the user's (your) MyCalApp.

MyCalApp will then issue an **access token** to HireMe123. HireMe123 can use that access token to call the MyCalApp API within the scope of permissions that were accepted by you and create events for you using the MyCalApp API.

**Nothing insidious is happening now!** **MyCalApp is asking the user to log in with MyCalApp**. HireMe123 is **not** asking for the user's MyCalApp credentials. The issues with sharing credentials and too much access are no longer a problem.

##### What About Authentication?

At this point, I hope it's been made clear that **OAuth is for delegated access**. It doesn't cover **authentication**. At any point where authentication was involved in the processes we covered above, login was managed by whatever login process HireMe123 or MyCalApp had implemented at their own discretion. OAuth 2.0 **didn't prescribe how** this should be done: it only covered authorizing third party API access.

So why are authentication and OAuth so often mentioned in the same breath?

## The Login Problem

The thing that happened after OAuth 2.0 established a way to access third party APIs was that **apps also wanted to log users in with other accounts**. Using our example: let's say HireMe123 wanted a MyCalApp user to be able to **log into HireMe123 using their MyCalApp account**, despite not having signed up for a HireMe123 account.

But as we mentioned above, **OAuth 2.0 is for delegated access**. It is **not** an authentication protocol. That didn't stop people from trying to use it like one though, and this presented problems.

### Problems with Using Access Tokens for Authentication

If HireMe123 assumes successfully calling MyCalApp's API with an access token means the **user** can be considered authenticated with HireMe123, we run into problems because we have no way to verify the access token was issued to a particular individual.

For example:

* Someone could have stolen the access token from a different user
* The access token could have been obtained from another client (not HireMe123) and injected into HireMe123

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
