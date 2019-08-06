> * 原文地址：[HTTP Security Headers - A Complete Guide](https://nullsweep.com/http-security-headers-a-complete-guide/)
> * 原文作者：[Charlie](https://nullsweep.com/charlie/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/http-security-headers-a-complete-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/http-security-headers-a-complete-guide.md)
> * 译者：
> * 校对者：

# HTTP Security Headers - A Complete Guide

[![](https://images.unsplash.com/photo-1489844097929-c8d5b91c456e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjExNzczfQ)](https://nullsweep.com/http-security-headers-a-complete-guide/)

Companies selling "security scorecards" are on the rise, and have started to become a factor in enterprise sales. I have heard from customers who were concerned about purchasing from suppliers who had been given poor ratings, and in at least one case changed a purchasing decision based initially on the rating.

I investigated how these ratings companies calculate company security scores, and it turns out they use a combination of HTTP security header usage and IP reputation.

IP reputation is based on blacklists and spam lists combined with public IP ownership data. These should generally be clean as long as your company doesn't spam and can quickly detect and stop malware infections. HTTP security header usage is calculated similar to how the [Mozilla Observatory](https://observatory.mozilla.org/) works.

Therefore, for most companies, their score is largely determined by the security headers being set on public facing websites.

Setting the right headers can be done quickly (usually without significant testing), can improve website security, and can now help you win deals with security conscious customers.

I am dubious about the value of this test methodology and exorbitant pricing schemes these companies ask. I don't believe it correlates to real product security all that well. However it certainly increases the importance of spending time setting headers and getting them right.

In this article, I will walk through the commonly evaluated headers, recommend security values for each, and give a sample header setting. At the end of the article, I will include sample setups for common applications and web servers.

## Important Security Headers

### Content-Security-Policy

A CSP is used to prevent cross site scripting by specifying which resources are allowed to load. Of all the items in this list, this is perhaps the most time consuming to create and maintain properly and the most prone to risks. During development of your CSP, be careful to test it thoroughly – blocking a content source that your site uses in a valid way will break site functionality.

A great tool for creating a first draft is the [Mozilla laboratory CSP browser extension](https://addons.mozilla.org/en-US/firefox/addon/laboratory-by-mozilla/). Install this in your browser, thoroughly browse the site you want to create a CSP for, and then use the generated CSP on your site.  Ideally, also work to refactor the JavaScript so no inline scripts remain, so you can remove the 'unsafe inline' directive.

CSP's can be complex and confusing, so if you want a deeper dive, see the [official site](https://content-security-policy.com/).

A good starting CSP might be the following (this likely requires a lot of modifications on a real site). Add domains in each section that your site includes somewhere.

```bash
# Default to only allow content from the current site
# Allow images from current site and imgur.com
# Don't allow objects such as Flash and Java
# Only allow scripts from the current site
# Only allow styles from the current site
# Only allow frames from the current site
# Restrict URL's in the <base> tag to current site
# Allow forms to submit only to the current site
Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';
```

### Strict-Transport-Security

This header tells the browser that the site should only be accessed via HTTPS – always enable when your site has HTTPS enabled. If you use subdomains, I also recommend enforcing this on any used sub domains.

```bash
Strict-Transport-Security: max-age=3600; includeSubDomains
```

### X-Content-Type-Options

This header ensures that the MIME types set by the application are respected by browsers. This can help prevent certain types of cross site scripting bypasses.

It also reduces unexpected application behavior where a browser may “guess” some kind of content incorrectly, such as when a developer labels a page “HTML” but the browser thinks it looks like JavaScript and tries to render it as JavaScript. This header will ensure the browser always respects the MIME type set by the server.

```bash
X-Content-Type-Options: nosniff
```

### Cache-Control

This one is a bit trickier than the others because you likely want different caching policies for different content types.

Any page with sensitive data, such as a user page or a customer checkout page, should be set to no-cache. One reason for this is preventing someone on a shared computer from pressing the back button or going through history and being able to view personal information.

However, pages that change rarely, such as static assets (images, CSS files, and JS files), are good to cache. This could be done on a page by page basis, or using regex on the server configuration.

```bash
# Don’t cache by default
Header set Cache-Control no-cache

# Cache static assets for 1 day
<filesMatch ".(css|jpg|jpeg|png|gif|js|ico)$">
    Header set Cache-Control "max-age=86400, public"
</filesMatch>
```

### Expires

This sets the time the cache should expire the current request. It is ignored if the Cache-Control max-age header is set, so we only set it in case a naive scanner is testing for it without considering cache-control.

For security purposes, we will assume that the browser should not cache anything, so we’ll set this to a date that always evaluates to the past.

```bash
Expires: 0
```

### X-Frame-Options

This header indicates whether the site should be allowed to be displayed within an iFrame.

If a malicious site puts your website within an iFrame, the malicious site is able to perform a click jacking attack by running some JavaScript that will capture mouse clicks on the iFrame and then interact with the site on the users behalf (not necessarily clicking where they think they clicked!).

This should always be set to deny unless you are specifically using frames, in which case it should be set to same-origin. If you are using Frames with another site by design, you can white list the other domain here as well.

It should also be noted that this header is superseded by the CSP frame-ancestors directive. I still recommend setting this for now to appease tools, but in the future it will likely be phased out.

```bash
X-Frame-Options: deny
```

### Access-Control-Allow-Origin

Tell the browser which other sites' front end JavaScript code may make requests of the page in question. Unless you need to set this, the default is usually the right setting.

For instance, if SiteA serves up some JavaScript which wants to make a request to siteB, then siteB must serve the response with the header specifying that SiteA is allowed to make this request. If you need to set multiple origins, see the [details page on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin).

This can be a little confusing, so I drew up a diagram to illustrate how this header functions:

![](https://nullsweep.com/content/images/2019/07/Screen-Shot-2019-07-17-at-4.38.37-PM.png)

Data flow with Access-Control-Allow-Origin

```bash
Access-Control-Allow-Origin: http://www.one.site.com
```

### Set-Cookie

Ensure that your cookies are sent via HTTPS (encrypted) only, and that they are not accessible via JavaScript. You can only send HTTPS cookies if your site also supports HTTPS, which it should. You should always set the following flags:

* Secure
* HttpOnly

A sample Cookie definition:

```bash
Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly
```

See the excellent [Mozilla documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie) on cookies for more information.

### X-XSS-Protection

This header instructs browsers to halt execution of detected cross site scripting attacks. It is generally low risk to set, but should still be tested before putting in production.

```bash
X-XSS-Protection: 1; mode=block
```

## Web Server Example Configurations

Generally, it's best to add headers site-wide in your server configuration. Cookies are the exception here, as they are often defined in the application itself.

Before adding any headers to your site, I recommend first checking the observatory or manually looking at headers to see which are set already. Some frameworks and servers will automatically set some of these for you, so only implement the ones you need or want to change.

### Apache Configuration

A sample Apache setting in .htaccess:

```bash
<IfModule mod_headers.c>
    ## CSP
    Header set Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';

    ## General Security Headers
    Header set X-XSS-Protection: 1; mode=block
    Header set Access-Control-Allow-Origin: http://www.one.site.com
    Header set X-Frame-Options: deny
    Header set X-Content-Type-Options: nosniff
    Header set Strict-Transport-Security: max-age=3600; includeSubDomains

    ## Caching rules
    # Don’t cache by default
    Header set Cache-Control no-cache
    Header set Expires: 0

    # Cache static assets for 1 day
    <filesMatch ".(ico|css|js|gif|jpeg|jpg|png|svg|woff|ttf|eot)$">
        Header set Cache-Control "max-age=86400, public"
    </filesMatch>

</IfModule>
```

### Nginx Configuration

```bash
## CSP
add_header Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';

## General Security Headers
add_header X-XSS-Protection: 1; mode=block;
add_header Access-Control-Allow-Origin: http://www.one.site.com;
add_header X-Frame-Options: deny;
add_header X-Content-Type-Options: nosniff;
add_header Strict-Transport-Security: max-age=3600; includeSubDomains;

## Caching rules
# Don’t cache by default
add_header Cache-Control no-cache;
add_header Expires: 0;

# Cache static assets for 1 day
location ~* \.(?:ico|css|js|gif|jpe?g|png|svg|woff|ttf|eot)$ {
    try_files $uri @rewriteapp;
    add_header Cache-Control "max-age=86400, public";
}
```

## Application Level Header Setting

If you don't have access to the web server, or have complex header setting needs, you may want to set these in the application itself. This can usually be done with framework middleware for an entire site, and on a per-response basis for one-off header setting.

I only included one header for brevity in the examples. Add all that are needed via this method in the same way.

### Node and express:

Add a global mount path:

```JavaScript
app.use(function(req, res, next) {
    res.header('X-XSS-Protection', 1; mode=block);    
    next();
});
```

### Java and Spring:

I don't have a lot of experience with Spring, but [Baeldung](https://www.baeldung.com/spring-response-header) has a great guide to header setting in Spring.

### PHP:

I am not familiar with the various PHP frameworks. Look for middleware that can handle requests. For a single response, it is very simple.

```php
header("X-XSS-Protection: 1; mode=block");
```

### Python / Django

Django includes configurable [security middleware](https://docs.djangoproject.com/en/2.2/ref/middleware/) that can handle all these settings for you. Enable those first.

For specific pages, you can treat the response like a dictionary. Django has a special way to handle caching that should be investigated if trying to set cache headers this way.

```python
response = HttpResponse()
response["X-XSS-Protection"] = "1; mode=block"
```

## Conclusions

Setting headers is relatively quick and easy. You will have a fairly significant increase in your site security for data protection, cross site scripting, and click jacking.

You also ensure you don't lose future business deals as a result of company security ratings that rely on this information. This practice seems to be increasing, and I expect it to continue to play a role in enterprise sales in future years.

Did I miss a header you think should be included? Let me know!

[Empathizing With Threat Actors](https://nullsweep.com/empathizing-with-threat-actors/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
