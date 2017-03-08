> * 原文链接：[Cross-Site Request Forgery is dead!](https://scotthelme.co.uk/csrf-is-dead/?utm_source=webopsweekly&utm_medium=email)
* 原文作者：[Scott](https://scotthelme.co.uk/author/scott/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

## Cross-Site Request Forgery is dead! ##
## 跨站请求伪造已死！

After toiling with Cross-Site Request Forgery on the web for, well forever really, we finally have a proper solution. No technical burden on the site owner, no difficult implementation, it's trivially simple to deploy, it's Same-Site Cookies.
在被跨站请求伪造折磨了这么多年后，我们现在终于有了一个合理的解决方案。一个对网站拥有者没有技术负担、实施起来没有难度、部署又非常简单的方案，它就是 Same-Site Coookies。

#### As old as the Web itself ####

Cross-Site Request Forgery, also known as CSRF or XSRF, has been around basically forever. It stems from the simple capability that a site has to issue a request to another site. Let's say I embed the following form in this very page.
跨站请求伪造（又被称为 CSRF 或者 XSRF ）似乎一直都存在着。它源自一个网站不得不向另外一个网站发送请求，就像在页面中嵌入下面的表单代码。

```
<form action="https://your-bank.com/transfer" method="POST" id="stealMoney">  
<input type="hidden" name="to" value="Scott Helme">  
<input type="hidden" name="account" value="14278935">  
<input type="hidden" name="amount" value="£1,000">  
```

Your browser loads this page and as a result the above form which I then submit using a simple piece of JS on my page too.
当你的浏览器载入这个页面之后，上面的表单将会由一个简单的 JS 片段来实现提交。

```
document.getElementById("stealMoney").submit();  

```

This is where the name CSRF comes from. I'm Forging a Request that is being sent Cross-Site to your bank. The real problem here is not that I sent the request but that your browser will send your cookies with it. The request will be sent with the full authority you currently hold at this time, which means if you're logged in to your bank you just donated £1,000 to me. Thanks! If you weren't logged in then the request would be harmless as you can't transfer money without being logged in. There are currently a few ways that your bank can mitigate these CSRF attacks. 
这就是被称作 CSRF 的来历。我伪造了一个跨站到你的银行网站的请求。这个问题的关键不是我发送了请求，而是你的浏览器通过这个请求发送了你都 cookies。此时，你当前拥有的全部验证信息也会通过这个请求发送，这就意味着你登录你的银行账户并且捐助了我 £1,000 。谢谢啊！那么当你没有登录的时候，这个请求对你就没有什么影响了，因为你不登录是无法转账的。不过对于银行来说，他们现在采用的这几种办法可以一定程度上防御 CSRF 攻击。

#### CSRF mitigations ####
#### 缓解 CSRF ####

I won't detail these too much because there are heaps of info available about this topic on the web but I want to quickly cover them to show the technical requirements to implement them.
关于缓解 CSRF 这里就不详细展开讲了，因为网上关于这个话题已经有大量的信息了，但是我仍然会快速的过一遍顺便展示一下实现他们都需要哪些技术。

##### Check the origin #####
##### 检查 origin #####

When receiving a request we potentially have two pieces of information available to us that indicate where the request came from. These are the Origin header and the Referer header. You can check one or both of these values to see if the request originated from a different origin to your own. If the request was cross-origin you simply throw it away. The Origin and Referer header do get some protection from browsers to prevent tampering but they may not always be present either. 
当我们收到一个请求时，关于这个请求的来源有两个地方的信息对我们来说是有用的。一个是 Origin header，另一个是 Referer header。你可以检查他们中的一个或者两个的值来判定对于你的网站来说他们是不是来自一个不同的域。如果这个请求是跨域的，那么你把它丢掉就可以了。Origin 和 Referer header 会在浏览器端做一些保护措施来阻止被纂改，但是这些并不总是有效的。

```
accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8  
accept-encoding: gzip, deflate, br  
cache-control: max-age=0  
content-length: 166  
content-type: application/x-www-form-urlencoded  
dnt: 1  
origin: https://report-uri.io  
referer: https://report-uri.io/login  
upgrade-insecure-requests: 1  
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36  

```

##### Anti-CSRF tokens #####

There are two different ways you can use Anti-CSRF tokens but the principle remains the same. When a visitor requests a page, like the transfer money page in the example above, you embed a random token into the form. When the genuine user submits this form the random token is returned and you can check it matches the one you issued in the form. In the CSRF attack scenario the attacker can never get this value and couldn't get it even if they requested the page because the Same Origin Policy (SOP) would prevent the attacker from reading the response that contains the token. This method works well but requires the site to track the issuance and return of the Anti-CSRF tokens. A similar method is embedding the token into the form and issuing the browser a cookie that contains the same value. When the genuine user submits their form the value in the cookie and the form will match when received by the site. When the attacker sends the forged request the browser won't have the CSRF cookie set and the test will fail.
通常情况下有两个方法你可以实现 Anti-CSRF tokens，但是它们的原理是一样的。当一个游客请求一个页面时，类似于上面提到的转账页面，你可以再表单中嵌入一个随机的token。当真正的用户提交表单的时，将会返回一个随机 token，这样你就可以通过之前嵌入的那个随机 token 来校验了。在 CSRF 攻击场景中，攻击者永远都不可能拿到这个值甚至在攻击者可以请求到页面的情况也无法拿到，因为同源策略（SOP）会阻止攻击者从包含 token 的响应中读取内容。这个方法在实际运用中很不错，但是它需要网站追踪每一个发行并且返回 Anti-CSRF tokens。还有一个类似的在表单中嵌入 token的方法是给浏览器一个包含相同值的 cookie 来实现的。当网站收到真正的用户提交他们的表单时，cookie 中的值和表单中的值将会相匹配。攻击者通过没有 CSRF cookie 的浏览器发送伪造的请求将会失败。

```
<form action="https://report-uri.io/login/auth" method="POST">  
    <input type="hidden" name="csrf_token" value="d82c90fc4a14b01224gde6ddebc23bf0">
    <input type="email" id="email" name="email">
    <input type="password" id="password" name="password">
    <button type="submit" class="btn btn-primary">Login</button>
</form>  
```

#### The Problem ####
#### 存在的问题 ####

The methods above have given us fairly robust protection against CSRF for a long time. Checking the Origin and Referer header isn't 100% reliable and most sites resort to some variation of the Anti-CSRF token approach. The trouble is though that these both put some kind of requirement on the site to implement and maintain the solution. They might not be the most technically complicated things in the world but we're still building a solution to work around the browser doing something that we just don't want it to do. Instead, why don't we just tell the browser to stop doing the thing we don't want it to do?... Now we can!
在很长一段时间，上面的这些方法在面对 CSRF 时给我们提供了强劲的保护。检查 Origin 和 Referer header 并不是 100% 有效的，大部分网站也会通过一些进化的 Anti-CSRF token 方式来防御。问题是，这两种方法都需要网站有一些必要的条件才能实施和维护。虽然这些条件并不是世界上最复杂的技术，但是我们仍然需要建立一个解决办法来让浏览器做一些我们不想做的事情。既然这样的话，那么我们为什么不直接告诉浏览器不要做哪些我们不想让它们做的事情？现在，我们可以了！

#### Same-Site Cookies ####

You may have seen Same-Site Cookies mentioned in my recent blog called [Tough Cookies](https://scotthelme.co.uk/tough-cookies/) but I'm going to go a little deeper into it here with some examples too. Essentially, Same-Site Cookies completely and effectively neutralise CSRF attacks. Dead. Finito. Adios! Capturing the essence of what we really need on the web to win the security battle, Same-Site Cookies are simple to deploy, *really* simple. Take your existing cookie:
你或许已经在我最近的博客（ [Tough Cookies](https://scotthelme.co.uk/tough-cookies/)）上看到了一些关于 Same-Site Cookies 的内容，但是在这里我将会用一些例子来深入的讲一下。从本质上来讲，Same-Site Cookies 可以完全有效的阻止 CSRF 攻击，是的，CSRF 一点机会都没有。我们在互联网上真正需求的本质就是赢得网络安全的战争，Same-Site Cookies非常容易部署，是**真的**非常容易。找到你原来的 cookie ：

```
Set-Cookie: sess=abc123; path=/  

```

Simply add the SameSite attribute.
添加 SameSite 这个属性。

```
Set-Cookie: sess=abc123; path=/; SameSite  

```

You're done. Seriously, that's it! Enabling this attribute on the cookie will instruct the browser to afford this cookie certain protections. There are two modes that you can enable this protection in, Strict or Lax, depending on how  serious you want to get. Specifying the `SameSite` attribute in your cookie with no setting will default to Strict mode but you can also set Strict or Lax explicitly if you wish.
你已经完成了。严格来讲，就是这样！在 cookie 上启用这个属性将会告诉浏览器给予这个 cookie 确切的保护。你可以通过 Strict 和 Lax 这两种模式来启用这个保护，具体用哪种模式取决于你想要的严格程度。如何在你的 cookie 设置中没有指定模式的话默认将会使用 Strict 模式，但是如果你想的话你可以明确的指定是 Strict 还是 Lax。

```
SameSite=Strict  
SameSite=Lax  

```

##### Strict #####

Setting your SameSite protections to Strict mode is obviously the preferred choice but the reason we have two options is that not all sites are the same nor do they have the same requirements. When operating in Strict mode the browser will not send the cookie on any cross-origin request, at all, so CSRF is completely dead in the water. The only problem you might come across is that it also won't send the cookie on top-level navigations (changing the URL in the address bar) either. If I presented a link to [https://facebook.com](https://facebook.com) and Facebook had SameSite cookies set to Strict mode, when you clicked that linked to open Facebook you wouldn't be logged in. Whether you were logged in already or not, opened it in a new tab, whatever you did, you wouldn't be logged in to Facebook when visiting from that link. This could be a little annoying and/or unexpected to users but does offer incredibly robust protection. What Facebook would need to do here is similar to what Amazon do, they have 2 cookies. One is kind of a 'basic' cookie that identifies you as a user and allows you to have the logged-in experience but if you want to do something sensitive like make a purchase or change something in your account you need the second cookie, the 'real' cookie that allows you to do important things. The first cookie in this case wouldn't have the SameSite attribute set as it's a 'convenience' cookie, it doesn't really allow you to do anything sensitive and if the attacker can make cross-origin requests with that, nothing happens. The second cookie however, the sensitive cookie, would have the SameSite attribute set and the attacker can't abuse its authority in cross-origin requests. This is the ideal solution both for the user and for security. This isn't always possible though and because we want SameSite cookies to be easy to deploy, there's a second option.
很显然，将你的 SameSite 保护设置为 Strcit 模式是一个更好的选择，但是我们之所以有两个选项的原因是不是所有的网站都是一样的并且不是所有的网站都有同样的需求。当我们在 Strict 模式下操作时，浏览器在任何跨域请求中都不会携带 cookie，所以说 CSRF 一点机会都没有。但是问题是，顶级导航（直接在地址栏改变 URL ）的请求都不会携带 cookie。比如说有一个链接地址 [https://facebook.com](https://facebook.com) 并且 Facebook 的 SameSite cookies 的模式为 Strict，当你点击链接打开 Facebook 之后你会发现你无法登录。无论你之前是否登录，在新标签中打开，无论你怎么做，当你从那个链接过来时你都无法登录到 Facebook。这就很烦人了，并且我们的用户也不希望我们提供如此蛋疼的保护。这时候 Facebook 要做的就是向 Amazon 学习，使用呢两个 cookie。一种是用来验证用户信息和登录操作的 '基础的' cookie，当你想进行一些类似于支付，改变账户信息的敏感操作时就需要第二种 cookie 了，'真正的' cookie 就可以允许你进行一些重要的操作。在这个案例中第一种 cookie 就是一种 '方便的' 不会设置 SameSite 的 cookie，它真的不回允许你进行任何敏感性的操作，即使攻击者通过它来进行跨站请求，什么都不会发生。第二种 cookie 是一种设置了 SameSite 属性的 '敏感的' cookie，攻击者在跨站请求中不会获取它的权限。这对于用户和安全来说就是一种理想的解决方案。然和这种方式的实施性并不强，因为我们希望 SameSite cookies 可以简单的部署，那么我们就需要第二个选项了。

##### Lax #####

Setting the SameSite protections to Lax mode fixes the problem mentioned above in Strict mode of a user clicking on a link and not being logged in on the target site if they were already logged in. In Lax mode there is a single exception to allow cookies to be attached to top-level navigations that use a safe HTTP method. The "safe" HTTP methods are defined in [Section 4.2.1 of RFC 7321](https://tools.ietf.org/html/rfc7231#section-4.2.1) as GET, HEAD, OPTIONS and TRACE, with us being interested in the GET method here. This means that our top-level navigation to [https://facebook.com](https://facebook.com) when the user clicks the link now has SameSite flagged cookies attached when the browser makes the request, maintaining the expected user experience. We're also still completely protected against POST based CSRF attacks. Going back to the example right at the top, this attack still wouldn't work in Lax mode.
将 SameSite 保护设置为 Lax 模式将会解决上面提到的在 Strict 模式下的用户在已经登录的前提下点击链接仍然无法在目标网站登录的问题。在 Lax 模式下有一个例外，就是在顶级导航中使用一个安全的 HTTP 方法发送的请求可以携带 cookie。所谓 "安全的" 的 HTTP 方法在 [Section 4.2.1 of RFC 7321](https://tools.ietf.org/html/rfc7231#section-4.2.1) 定义为 GET、HEAD、OPTIONS 和 TRACE，在这里我们只关心 GET 方法，就是我们链接到 [https://facebook.com](https://facebook.com) 的顶级导航就是一个 GET 方法。现在当用户点击一个设置了 SameSite 的链接之后，浏览器就会发送携带 cookie 和一些我们希望的用户信息的请求。同时，我们也防范了基于 POST 方法的 CSRF 攻击。在 Lax 模式下，最开始提到的例子中的攻击手段也无法成功。

```
<form action="https://your-bank.com/transfer" method="POST" id="stealMoney">  
<input type="hidden" name="to" value="Scott Helme">  
<input type="hidden" name="account" value="14278935">  
<input type="hidden" name="amount" value="£1,000"> 
```

Because the POST method isn't considered safe, the browser wouldn't attach the cookie in the request. The attacker is of course free to change the method to a 'safe' method though and issue the same request.
因为 POST 方法被认为是一种不安全的方法，浏览器在请求中是不会携带 cookie 的。那么攻击者当然会想到使用一种 '安全的' 方法来完成同样的请求。

```
<form action="https://your-bank.com/transfer" method="GET" id="stealMoney">  
<input type="hidden" name="to" value="Scott Helme">  
<input type="hidden" name="account" value="14278935">  
<input type="hidden" name="amount" value="£1,000">  
```

As long as we don't accept GET requests in place of POST requests then this attack isn't possible, but it's something to note when operating in Lax mode. Also, if an attacker can trigger a top-level navigation or pop a new window they can also cause the browser to issue a GET request with the cookies attached. This is the trade-off of operating in Lax mode, we keep the user experience intact but there is a small amount of risk to accept as payment.
其实只要我们在接收 POST 请求的地方不接受 GET 请求那么这种攻击方法就会失效，但是在 Lax 模式下还有一些需要注意的点。比如，如果一个攻击者触发一个顶级导航或者弹出一个新的窗口，那么他们就可以让浏览器发送一个携带 cookies 的 GET 请求。这就是在 Lax 模式下需要取舍的地方，我们在维持了完整的用户体验的前提下不得不承担一些小的风险。

#### Additional uses ####
#### 额外的用途 ####

This blog is aimed at mitigating CSRF with SameSite Cookies but there are, as you may have guessed, other uses for this mechanism too. The first of those listed in the spec is Cross-Site Script Inclusion (XSSI), which is where the browser makes a request for an asset like a script that will change depending on whether or not the user is authenticated. In the Cross-Site request scenario an attacker can't abuse the ambient authority of a SameSite Cookie to yield a different response. There are also some interesting timing attacks detailed [here](https://www.contextis.com/documents/2/Browser_Timing_Attacks.pdf) that can be mitigated too. 
这篇博客的目标是通过 SameSite Cookies 来缓解 CSRF 攻击，但是，你可能已经猜到了，这种机制还有一些其他的用途。第一个就是跨站脚本包含（XSSI），它是指当浏览器向类似于脚本的资源文件发送请求的时候将会根据用户是否登录而做出改变。在跨站请求的场景中，一个攻击者无法使用 SameSite Cookie 的一些验证信息来造成不同的响应。[这里](https://www.contextis.com/documents/2/Browser_Timing_Attacks.pdf)还有一些有趣的定时攻击的详细信息。

Another interesting use that isn't detailed is protection against leaking the value of the session cookie in BEAST-style attacks against compression ([CRIME](https://en.wikipedia.org/wiki/CRIME_(security_exploit)), [BREACH](https://en.wikipedia.org/wiki/BREACH_(security_exploit)), [HEIST](https://tom.vg/papers/heist_blackhat2016.pdf), [TIME](https://www.blackhat.com/eu-13/briefings.html#Beery)). This is really high level but the basic scenario is that a MiTM can force the browser to issue requests cross-origin via any mechanism they like and monitor them. By abusing the change in the size of request payloads the attacker can guess the session ID value one byte at a time by altering the requests the browser makes and observing their size on the wire. Using SameSite Cookies the browser would not include cookies in such requests and as a result the attacker cannot guess their value.
还有一个有趣的用途（不是很详细）是用来对抗在面对浑水猛兽般的攻击手段下 ([CRIME](https://en.wikipedia.org/wiki/CRIME_(security_exploit)), [BREACH](https://en.wikipedia.org/wiki/BREACH_(security_exploit)), [HEIST](https://tom.vg/papers/heist_blackhat2016.pdf), [TIME](https://www.blackhat.com/eu-13/briefings.html#Beery)) 造成的会话 cookie 的泄露。这些确实是很高级的攻击手段，但是基础的场景是一个 MiTM (中间人攻击) 可以通过任何他们喜欢或监视的机制来强行让浏览器发送跨域请求。通过使用请求载荷的大小的变化，攻击者可以变更浏览器请求并观察每次变更之后的大小就可以猜出一位 session ID 的值。而使用 SameSite Cookies 的话，浏览器在发送这些请求的时候就不会携带 cookies，那么攻击者业就无法猜到他们的值了。

#### Browser Support ####
#### 浏览器支持情况 ####

With most new security features in browsers you can expect either Firefox or Chrome to be leading the charge and things are no different here either. Chrome has had support for Same-Site Cookies since v51 which means that Opera, Android Browser and Chrome on Android also has support. You can see details on [caniuse.com](http://caniuse.com/#search=SameSite) that lists current support and Firefox has a [bug](https://bugzilla.mozilla.org/show_bug.cgi?id=795346) open to add support too. Even though support isn't widespread yet we should still add the SameSite attribute to our cookies. Browsers that understand it will respect the setting and afford the cookie extra protection while those that don't will simply ignore it and carry on. There's nothing to lose here and it forms a very nice defence-in-depth approach. It's going to be a long time until we can consider removing traditional anti-CSRF mechanisms but adding SameSite on top of those gives us an incredibly robust defence.
和很多新的浏览器安全特性一样，我们总是希望 Firefox 和 Chrome 能够引领这些新特性，但是这次情况不一样了。Chrome 自从 v51 就开始支持 SameSite Cookie 了，这意味着 Opera，安卓浏览器和安卓上的 Chrome 都支持这一特性。你可以在 [caniuse.com](http://caniuse.com/#search=SameSite) 上看到当前所有支持该属性的详细信息，Firefox 还有一个开放的 [bug](https://bugzilla.mozilla.org/show_bug.cgi?id=795346) 需要添加支持。虽然目前来看支持并不是很全面，但是我们应该给我们的 cookies 添加 SameSite 这个属性。支持这一特性的浏览器将会按照协议为我们的 cookie 提供额外的保护，而不支持的浏览器会直接无视它。这不但对我们没什么影响，还会提供一种不错的具有深度的防御手段。虽然离我们完全移除传统的反 CSRF 机制还有很长的一段时间，但是添加 SameSite 仍然可以为我们提供一个足够健壮的保护。