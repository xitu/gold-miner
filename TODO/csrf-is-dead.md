> * 原文链接：[Cross-Site Request Forgery is dead!](https://scotthelme.co.uk/csrf-is-dead/?utm_source=webopsweekly&utm_medium=email)
* 原文作者：[Scott](https://scotthelme.co.uk/author/scott/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

## Cross-Site Request Forgery is dead! ##

After toiling with Cross-Site Request Forgery on the web for, well forever really, we finally have a proper solution. No technical burden on the site owner, no difficult implementation, it's trivially simple to deploy, it's Same-Site Cookies.

#### As old as the Web itself ####

Cross-Site Request Forgery, also known as CSRF or XSRF, has been around basically forever. It stems from the simple capability that a site has to issue a request to another site. Let's say I embed the following form in this very page.

```
<form action="https://your-bank.com/transfer" method="POST" id="stealMoney">  
<input type="hidden" name="to" value="Scott Helme">  
<input type="hidden" name="account" value="14278935">  
<input type="hidden" name="amount" value="£1,000">  
```

Your browser loads this page and as a result the above form which I then submit using a simple piece of JS on my page too.

```
document.getElementById("stealMoney").submit();  

```

This is where the name CSRF comes from. I'm Forging a Request that is being sent Cross-Site to your bank. The real problem here is not that I sent the request but that your browser will send your cookies with it. The request will be sent with the full authority you currently hold at this time, which means if you're logged in to your bank you just donated £1,000 to me. Thanks! If you weren't logged in then the request would be harmless as you can't transfer money without being logged in. There are currently a few ways that your bank can mitigate these CSRF attacks. 

#### CSRF mitigations ####

I won't detail these too much because there are heaps of info available about this topic on the web but I want to quickly cover them to show the technical requirements to implement them.

##### Check the origin #####

When receiving a request we potentially have two pieces of information available to us that indicate where the request came from. These are the Origin header and the Referer header. You can check one or both of these values to see if the request originated from a different origin to your own. If the request was cross-origin you simply throw it away. The Origin and Referer header do get some protection from browsers to prevent tampering but they may not always be present either. 

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

```
<form action="https://report-uri.io/login/auth" method="POST">  
    <input type="hidden" name="csrf_token" value="d82c90fc4a14b01224gde6ddebc23bf0">
    <input type="email" id="email" name="email">
    <input type="password" id="password" name="password">
    <button type="submit" class="btn btn-primary">Login</button>
</form>  
```

#### The Problem ####

The methods above have given us fairly robust protection against CSRF for a long time. Checking the Origin and Referer header isn't 100% reliable and most sites resort to some variation of the Anti-CSRF token approach. The trouble is though that these both put some kind of requirement on the site to implement and maintain the solution. They might not be the most technically complicated things in the world but we're still building a solution to work around the browser doing something that we just don't want it to do. Instead, why don't we just tell the browser to stop doing the thing we don't want it to do?... Now we can!

#### Same-Site Cookies ####

You may have seen Same-Site Cookies mentioned in my recent blog called [Tough Cookies](https://scotthelme.co.uk/tough-cookies/) but I'm going to go a little deeper into it here with some examples too. Essentially, Same-Site Cookies completely and effectively neutralise CSRF attacks. Dead. Finito. Adios! Capturing the essence of what we really need on the web to win the security battle, Same-Site Cookies are simple to deploy, *really* simple. Take your existing cookie:

```
Set-Cookie: sess=abc123; path=/  

```

Simply add the SameSite attribute.

```
Set-Cookie: sess=abc123; path=/; SameSite  

```

You're done. Seriously, that's it! Enabling this attribute on the cookie will instruct the browser to afford this cookie certain protections. There are two modes that you can enable this protection in, Strict or Lax, depending on how  serious you want to get. Specifying the `SameSite` attribute in your cookie with no setting will default to Strict mode but you can also set Strict or Lax explicitly if you wish.

```
SameSite=Strict  
SameSite=Lax  

```

##### Strict #####

Setting your SameSite protections to Strict mode is obviously the preferred choice but the reason we have two options is that not all sites are the same nor do they have the same requirements. When operating in Strict mode the browser will not send the cookie on any cross-origin request, at all, so CSRF is completely dead in the water. The only problem you might come across is that it also won't send the cookie on top-level navigations (changing the URL in the address bar) either. If I presented a link to [https://facebook.com](https://facebook.com) and Facebook had SameSite cookies set to Strict mode, when you clicked that linked to open Facebook you wouldn't be logged in. Whether you were logged in already or not, opened it in a new tab, whatever you did, you wouldn't be logged in to Facebook when visiting from that link. This could be a little annoying and/or unexpected to users but does offer incredibly robust protection. What Facebook would need to do here is similar to what Amazon do, they have 2 cookies. One is kind of a 'basic' cookie that identifies you as a user and allows you to have the logged-in experience but if you want to do something sensitive like make a purchase or change something in your account you need the second cookie, the 'real' cookie that allows you to do important things. The first cookie in this case wouldn't have the SameSite attribute set as it's a 'convenience' cookie, it doesn't really allow you to do anything sensitive and if the attacker can make cross-origin requests with that, nothing happens. The second cookie however, the sensitive cookie, would have the SameSite attribute set and the attacker can't abuse its authority in cross-origin requests. This is the ideal solution both for the user and for security. This isn't always possible though and because we want SameSite cookies to be easy to deploy, there's a second option.

##### Lax #####

Setting the SameSite protections to Lax mode fixes the problem mentioned above in Strict mode of a user clicking on a link and not being logged in on the target site if they were already logged in. In Lax mode there is a single exception to allow cookies to be attached to top-level navigations that use a safe HTTP method. The "safe" HTTP methods are defined in [Section 4.2.1 of RFC 7321](https://tools.ietf.org/html/rfc7231#section-4.2.1) as GET, HEAD, OPTIONS and TRACE, with us being interested in the GET method here. This means that our top-level navigation to [https://facebook.com](https://facebook.com) when the user clicks the link now has SameSite flagged cookies attached when the browser makes the request, maintaining the expected user experience. We're also still completely protected against POST based CSRF attacks. Going back to the example right at the top, this attack still wouldn't work in Lax mode.

```
<form action="https://your-bank.com/transfer" method="POST" id="stealMoney">  
<input type="hidden" name="to" value="Scott Helme">  
<input type="hidden" name="account" value="14278935">  
<input type="hidden" name="amount" value="£1,000"> 
```

Because the POST method isn't considered safe, the browser wouldn't attach the cookie in the request. The attacker is of course free to change the method to a 'safe' method though and issue the same request.

```
<form action="https://your-bank.com/transfer" method="GET" id="stealMoney">  
<input type="hidden" name="to" value="Scott Helme">  
<input type="hidden" name="account" value="14278935">  
<input type="hidden" name="amount" value="£1,000">  
```

As long as we don't accept GET requests in place of POST requests then this attack isn't possible, but it's something to note when operating in Lax mode. Also, if an attacker can trigger a top-level navigation or pop a new window they can also cause the browser to issue a GET request with the cookies attached. This is the trade-off of operating in Lax mode, we keep the user experience intact but there is a small amount of risk to accept as payment.

#### Additional uses ####

This blog is aimed at mitigating CSRF with SameSite Cookies but there are, as you may have guessed, other uses for this mechanism too. The first of those listed in the spec is Cross-Site Script Inclusion (XSSI), which is where the browser makes a request for an asset like a script that will change depending on whether or not the user is authenticated. In the Cross-Site request scenario an attacker can't abuse the ambient authority of a SameSite Cookie to yield a different response. There are also some interesting timing attacks detailed [here](https://www.contextis.com/documents/2/Browser_Timing_Attacks.pdf) that can be mitigated too. 

Another interesting use that isn't detailed is protection against leaking the value of the session cookie in BEAST-style attacks against compression ([CRIME](https://en.wikipedia.org/wiki/CRIME_(security_exploit)), [BREACH](https://en.wikipedia.org/wiki/BREACH_(security_exploit)), [HEIST](https://tom.vg/papers/heist_blackhat2016.pdf), [TIME](https://www.blackhat.com/eu-13/briefings.html#Beery)). This is really high level but the basic scenario is that a MiTM can force the browser to issue requests cross-origin via any mechanism they like and monitor them. By abusing the change in the size of request payloads the attacker can guess the session ID value one byte at a time by altering the requests the browser makes and observing their size on the wire. Using SameSite Cookies the browser would not include cookies in such requests and as a result the attacker cannot guess their value.

#### Browser Support ####

With most new security features in browsers you can expect either Firefox or Chrome to be leading the charge and things are no different here either. Chrome has had support for Same-Site Cookies since v51 which means that Opera, Android Browser and Chrome on Android also has support. You can see details on [caniuse.com](http://caniuse.com/#search=SameSite) that lists current support and Firefox has a [bug](https://bugzilla.mozilla.org/show_bug.cgi?id=795346) open to add support too. Even though support isn't widespread yet we should still add the SameSite attribute to our cookies. Browsers that understand it will respect the setting and afford the cookie extra protection while those that don't will simply ignore it and carry on. There's nothing to lose here and it forms a very nice defence-in-depth approach. It's going to be a long time until we can consider removing traditional anti-CSRF mechanisms but adding SameSite on top of those gives us an incredibly robust defence.
