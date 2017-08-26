
  > * 原文地址：[Securing Cookies in Go](https://www.calhoun.io/securing-cookies-in-go/)
  > * 原文作者：[Jon Calhoun](https://www.calhoun.io/hire-me/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/securing-cookies-in-go.md](https://github.com/xitu/gold-miner/blob/master/TODO/securing-cookies-in-go.md)
  > * 译者：
  > * 校对者：

  # Securing Cookies in Go

  When I first started learning Go I had experience with web development, but a little less experience working directly with cookies. I was coming from a Rails background, and while I had to read/write cookies in Rails, I didn't actually need to implement all of the security measures myself.

You see, Rails is big on having most things done by default. You don't need to go setup CSRF countermeasures, or do anything special to encrypt your cookies. This is all done by default for you in the newer versions of Rails.

Developing in Go is very different. None of these things are done for you by default, so when you want to start using cookies it is vitally important that you learn about all of these security measures, why they are in place, and how to incorporate them into your own application. This article is meant to be a guide in helping you do that.

*Note: This is not meant to spark an argument/discussion about which route is better. Both have their merits, but I want to instead focus on securing cookies, not Rails vs Go.*

## What are cookies?

Before we jump into the security of cookies, it is important to understand what cookies really are. At their very core, cookies are just key/value pairs stored on an end user's computer. As a result, the only thing you really need to do to create one is to set the Name and Value fields of the [http.Cookie](https://golang.org/pkg/net/http/#Cookie) type, then call the [http.SetCookie](https://golang.org/pkg/net/http/#SetCookie) function to tell the end user's browser to set that cookie.

In code it looks something like this:

```
func someHandler(w http.ResponseWriter, r *http.Request) {
  c := http.Cookie{
    Name: "theme",
    Value: "dark",
  }
  http.SetCookie(w, &c)
}
```

> `http.SetCookie` doesn't return an error, but may instead silently drop an invalid cookie. This isn't an awesome experience, but it is what it is, so definitely keep this in mind when using the function.

While it might appear that we are "setting" a cookie in our code, we are really just sending a `"Set-Cookie"` header back in our response that defines the cookie we want to be set. We don't store cookies on our server, but instead rely on the end user's browser to create and store them.

I want to stress this, because it has very serious security implications. We DO NOT control this data. The end user's computer (and thus the end user) ultimately has control over this data.

When reading and writing data that the end user ultimately controls, we need to be very careful with how we treat that data. A nefarious user could delete a cookie, edit the data stored in it, or we could even run into [man-in-the-middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) where someone attempts to steal cookies when a user sends them to our web server.

## Potential issues with cookies

In my experience I have found that security concerns related to cookies roughly fall into five primary categories. Below we will see each one briefly, and then the rest of this article will be dedicated to discussing each in detail along with countermeasures.

**1. Cookie theft** - Attackers can attempt to steal cookies in various ways. We will discuss how to prevent/mitigate most of these, but at the end of the day we can't completely prevent physical device access.

**2. Cookie tampering** - Whether intentional or not, data in cookies can be altered. We will want to discuss how we can verify the data stored in a cookie is indeed valid data we wrote.

**3. Data leaks** - Cookies are stored on end user's computers, so we should be conscious of what data we store there in case it is leaked.

**4. Cross-site scripting (XSS)** - While not directly related to cookies, XSS attacks are more powerful when they have access to cookies. We should consider limiting our cookies from being accessible to scripts where it isn't needed.

**5. Cross-site Request Forgery (CSRF)** - These attacks often rely on users being logged in with a session stored in a cookie, so we will discuss how to prevent them even when we are using cookies in this manner.

As I stated before, we will address each of these throughout this article and by the end you will be able to lock down your cookies like a pro.

## Cookie theft

Cookie theft is exactly what it sounds like - someone steals a user's cookie, often in order to pretend to be that users.

Cookies are often stolen in one of two ways:

1. [Man in the middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack), or something similar where an attacker intercepts your web request and steals the cookie data from it.
2. Gaining access to the hardware.

Preventing man in the middle attacks basically boils down to always using SSL when your website uses cookies. By using SSL you make it essentially impossible for others to sit in the middle of a request, because they won't be able to decrypt the data.

For those of you thinking, "ahh a man-in-the-middle attack isn't very likely..." I would strongly encourage you to check out [firesheep](http://codebutler.com/firesheep), a simple tool designed to illustrate just how easy it is to steal unencrypted cookies sent over public wifi.

If you want to ensure that this doesn't happen to your users, SET UP SSL!. [Caddy Server](https://caddyserver.com/) makes this a breeze with Let's Encrypt. Just use it. Its really freaking simple to setup for prod environments. For example, you could easily proxy your Go application with 4 lines of code:

```
calhoun.io {
  gzip
  proxy / localhost:3000
}
```

And Caddy will automatically handle everything SSL related for you.

Preventing cookie theft via access to the hardware is a much trickier scenario. We can't exactly force our users to use a security system or to properly password their computer, so there is always the risk that someone will just sit down at their computer and steal some cookies then leave. Cookies could also be stolen via a virus, so if a user clicked on a shady attachment we could be looking at similar circumstances.

What often makes this even more challenging is that it is harder to detect. If someone stole your watch, you would notice when you realized it wasn't on your wrist. Cookies on the other hand can be copied and used often without anyone realizing.

While not a failsafe, you can use a few techniques to detect stolen cookies. For example, you could track what device the user is logging in with and then flag any new hardware, requiring them to reenter their password. You could also track IP addresses, alerting users of suspicious login locations.

All of these solutions require a bit more backend work to track the data, and are things you should work towards if your application deals with sensitive data, money, or is gaining popularity.

That said, for most applications this is likely overkill in the first version and simply using SSL is good enough to release.

## Cookie tampering (aka users faking data)

Let's face it - some people are jerks, and SOMEONE is going to try to look at a cookie you set and try to change its value. Even if only done out of curiosity, it will happen and you need to be ready for it.

In some of these situations we likely don't care. For example, if we let users define a theme preference we likely don't really care if they alter this. When it is invalid we can just revert to a default theme, and if they change it to a valid theme we can just use that theme without doing any harm.

In other cases we likely will care a lot more. Editing session cookies and attempting to impersonate another user is a much bigger deal than changing your theme, and we clearly don't want Joe pretending to be Sally.

We are going to cover two strategies to detect and prevent cookie tampering.

#### 1. Digitally sign the data

Digitally signing data is the act of adding a "signature" to the data so that you can verify it's authenticity. Data doesn't need to be encrypted or masked from the end user, but we do need to add enough data to our cookie so that if a user alters the data we can detect it.

The way this works with cookies is via a hash - we hash the data, then store both the data along with the hash of the data in the cookie. Then later when the user sends the cookie to us, we hash the data again and verify that it matches the original hash we created.

We don't want users also creating new hashes, so you will often see hashing algorithms like HMAC being used so that the data can be hashed using a secret key. This prevents end users from editing both the data and the digital signature (the hash).

> Digitally signing data is built into [JSON Web Tokens (JWT)](https://jwt.io/) by default, so you might already be familiar with this approach.

This can be done in Go using a package like Gorilla's [securecookie](http://www.gorillatoolkit.org/pkg/securecookie), where you provide it with a hash key when creating a `SecureCookie` and then use that object to secure your cookies.

```
// It is recommended to use a key with 32 or 64 bytes, but
// this key is less for simplicity.
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

You could then read this cookie by using the same SecureCookie object in another handler.

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

*Examples adapted from examples at [http://www.gorillatoolkit.org/pkg/securecookie](http://www.gorillatoolkit.org/pkg/securecookie).*

> Note: The data here IS NOT encrypted, but is only encoded. We discuss how to encrypt the data in the "data leaks" section.

One important caveat to this pattern is that if you are doing authentication this way you need to be careful and follow a pattern like JWTs use where you add both user information and an expiration date in the data that is digitally signed. You cannot rely solely on cookie expiration dates because the date stored on the cookie isn't signed, and a user could create a new cookie with no expiration date and copy the signed cookie over to it, essentially creating a cookie that keeps them logged in forever.

#### 2. Obfuscate data

Another solution is to mask your data in a way that makes it impossible for users to fake it. Eg, rather than storing a cookie like:

```
// Don't do this
http.Cookie{
  Name: "user_id",
  Value: "123",
}
```

We could instead store data that maps to the real data in our database. This is often done with session IDs or remember tokens, where we have a table named `remember_tokens` and then store data in it like so:

```
remember_token: LAKJFD098afj0jasdf08jad08AJFs9aj2ASfd1
user_id: 123
```

We would then only store the remember token in the cookie, and even if the user wanted to fake it they wouldn't know what to change it to. It just looks like gibberish.

Later when a user visits our application we would look up the remember token in our database and determine which user they are logged in as.

In order for this to work well, you need to ensure that your obfuscated data is:

- Maps to a user (or some other resource)
- Random
- Has significant entropy
- Can be invalidated (eg delete/change the token stored in the DB)

One downside to this approach is that it requires a database lookup upon every page request that you need to authenticate the user, but this is rarely noticeable and can be mitigated with caching and other similar techniques. An upside to this approach over say JWT is that you can immediately invalidate sessions.

*Note: This is the most common authentication strategy I am aware of, despite JWT gaining popularity recently with all the JS frameworks.*

## Data leaks

Data leaks often require another attack vector - like cookie theft - before they can become a real concern, but it is always good to err on the side of caution. Just because a cookie gets stolen doesn't mean we want to accidentally tell the attacker the user's password as well.

Whenever storing data in cookies, always minimize the amount of sensitive data stored there. Don't store things like a user's password, and be sure that any encoded data also doesn't have this. Articles like [this one](https://hackernoon.com/your-node-js-authentication-tutorial-is-wrong-f1a3bf831a46#2491) point out a few instances where developers have unknowingly stored sensitive data in cookies or JWTs because it was base64 encoded, but in reality anyone can decode this data. It is encoded, NOT encrypted.

This is a pretty big blunder to make, so if you are concerned with accidentally storing something sensitive I suggest you look into packages like Gorilla's [securecookie](http://www.gorillatoolkit.org/pkg/securecookie).

Earlier we discussed how it can be used to digitally sign your cookies, but `securecookie` can also be used to encrypt and decrypt your cookie data so that it can't be decoded and read easily.

To enable encryption with the package, you simply need to pass in a block key when creating your `SecureCookie` instance.

```
var hashKey = []byte("very-secret")
// Add this part for encryption.
var blockKey = []byte("a-lot-secret")
var s = securecookie.New(hashKey, blockKey)
```

Everything else is the same as the samples in the digital signatures section of this article.

It is important to mention here that you still SHOULD NOT store any really sensitive data in a cookie; especially not things like a password. Encryption is simply a technique to help secure things up a little extra in case something semi-sensitive ends up in a cookie.

## Cross-site scripting (XSS)

[Cross-site scripting](https://en.wikipedia.org/wiki/Cross-site_scripting), often denoted as XSS, occurs when someone manages to inject some JavaScript into your site that you didn't write, but because of the way the attack works the browser doesn't know that and runs the JavaScript as if your server did provide the code.

You should be doing your best to prevent XSS in general, and we won't go into too much detail about what it is here, but JUST IN CASE it slips through I suggest disabling JavaScript access to cookies whenever it isn't needed. You can always enable it later if you need it, so don't let that be an excuse to leave yourself vulnerable either.

Doing this in Go is simple enough. You simply set the `HttpOnly` field to true in any cookies you create.

```
cookie := http.Cookie{
  // true means no scripts, http requests only. This has
  // nothing to do with https vs http
  HttpOnly: true,
}
```

## CSRF (Cross Site Request Forgery)

CSRF occurs when a user visits a site that isn't yours, but that site has a form submitting to your web application. Because the end user submits the form and this isn't done via a script, the browser treats this as a user-initiated action and passes cookies along with the form submission.

This doesn't seem too bad at first, but what happens when that external site starts sending over data the user didn't intend? For example, badsite.com might have a form that submits a request to transfer $100 to their bank account to chase.com hoping that you are logged into a bank account there, and this could lead to money being transfered without the end user intending to.

Cookies aren't directly at fault for this, but if you are using cookies for things like authentication you need to prevent this using a package like Gorilla's [csrf](http://www.gorillatoolkit.org/pkg/csrf).

This package works by providing you with a CSRF token you can insert into every web form, and whenever a form is submitted without a token the `csrf` package's middleware will reject the form, making it impossible for external sites to trick users into submitting forms.

*For more on what CSRF is, see the following:*

- [https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF))
- [https://en.wikipedia.org/wiki/Cross-site_request_forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery)

## Limit cookie access where it isn't needed

The last thing we are going to discuss isn't related to a specific attack, but is more of a guiding principle that I suggest when working with cookies - limit access wherever you can, and only provide access when it is needed.

We touched on this briefly when discussing XSS, but the general idea is that you should limit access to your cookies wherever you can. For example, if your web application doesn't use subdomains, you have no reason to give all subdomains access to your cookies. This is the default for cookies, so you don't actually need to do anything to limit to a specific domain.

On the other hand, if you do need share your cookie with subdomains you can do so with something like this:

```
c := Cookie{
  // Defaults to host-only, which means exact subdomain
  // matching. Only change this to enable subdomains if you
  // need to! The below code would work on any subdomain for
  // yoursite.com
  Domain: "yoursite.com",
}
```

*For more information on how the domain is resolved, see [https://tools.ietf.org/html/rfc6265#section-5.1.3](https://tools.ietf.org/html/rfc6265#section-5.1.3). You can also see the source code where this gets its default value at [https://golang.org/src/net/http/cookie.go#L157](https://golang.org/src/net/http/cookie.go#L157).*

*You can also read [this stack overflow question](https://stackoverflow.com/questions/18492576/share-cookie-between-subdomain-and-domain) for more info on why you don't need the period prefix you used to need for subdomain cookies, and the Go code linked also shows that the leading period will be trimmed anyway if you provide it.*

On top of limiting to specific domains, you can also limit your cookies to specific paths.

```
c := Cookie{
  // Defaults to any path on your app, but you can use this
  // to limit to a specific subdirectory. Eg:
  Path: "/app/",
}
```

The TL;DR is you can set path prefixes with something like `/blah/`, but if you would like to read more about how this field works you can check out [https://tools.ietf.org/html/rfc6265#section-5.1.4](https://tools.ietf.org/html/rfc6265#section-5.1.4).

## Why not just use JWTs?

This will inevitably come up, so I'm going to address it briefly.

Despite what many people may tell you, cookies can be just as secure as JWTs. In fact, JWTs and cookies don't really even solve the same issue, as JWTs could be stored inside of cookies and used virtually identical to how they are used when provided as a header.

Regardless, cookies can be used for non-authentication data, and even in those cases I find knowing about proper security measures is useful.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  