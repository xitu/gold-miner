> * 原文地址：[Enhance JavaScript Security with Content Security Policies](https://blog.bitsrc.io/enhance-javascript-security-with-content-security-policies-5847e5def227)
> * 原文作者：[Ashan Fernando](https://medium.com/@ashan.fernando)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/enhance-javascript-security-with-content-security-policies.md](https://github.com/xitu/gold-miner/blob/master/article/2020/enhance-javascript-security-with-content-security-policies.md)
> * 译者：
> * 校对者：

# Enhance JavaScript Security with Content Security Policies

![Image by [Free-Photos](https://pixabay.com/photos/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=690286) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=690286)](https://cdn-images-1.medium.com/max/3840/1*s3SfHFu0tszfPURFr9mOFQ.jpeg)

How confident you feel that your JavaScript code is secured against the attackers? And why should you be concerned with it? When we look at modern web applications, one thing common is that they all use JavaScript. In some applications, JavaScript spreads its dominance contributing to the larger portion of code. One of the important properties of JavaScript is that the code we write executes in the user's browser where we have limited access.

Though we have minimal control over the execution environment, it's vital to ensure the security of JavaScript and have control over the execution happening there.

> Do you know whether you can instruct the browser to comply with a set of guidelines and execute your JavaScript code?

After reading this article, you’ll come to know the common attributes of Content Security Policies and how you can use them to secure your JavaScript code at runtime.

## Content Security Policy

> **Content Security Policy** ([CSP](https://developer.mozilla.org/en-US/docs/Glossary/CSP)) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting ([XSS](https://developer.mozilla.org/en-US/docs/Glossary/XSS)) and data injection attacks. These attacks are used for everything from data theft to site defacement to distribution of malware.

As the name suggests, CSP is a set of instructions you can send with your JavaScript code to the browser to control its execution. For example, you can set up a CSP to restrict the execution of JavaScript to a set of whitelisted domains and ignore any inline scripts and event handlers to protect from XSS attacks. In addition, you can specify that all the scripts should load via HTTPS to reduce the risk of packet sniffing attacks.

So how should I configure a CSP for a web application?

There are two ways to configure a CSP. One approach is to return a specific HTTP Header`[Content-Security-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy).` The other is to specify a `[\<meta>](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta)` element in your HTML page.

## Let's look at a Sample CSP

Assume that you set the following`Content-Security-Policy` for your web application.

```
Content-Security-Policy: default-src 'self'; script-src 'self' https://example.com;
```

Then, this will **allow** loading JavaScripts like from `https://example.com/js/*` but will **block**[ https://someotherexample.com/js/*](https://otherurl.com/js/*) by the browser as specified in the CSP. Furthermore, any Inline Scripts are also blocked by default, unless you use hashes or nonces to allow them to execute.

> If you haven’t heard of Hashes or Nounces, I would highly recommend to refer [this example link](https://content-security-policy.com/examples/allow-inline-script/) to realize the true potential of it.

In a nutshell, with the hash operation, you can specify the hash of the JavaScript file as an attribute to the Script block where the browser will first validate the hash before executing it.

The same goes for the nonce where we can generate a random number and specify at the CSP header while referring the same nonce at the Script block.

## How do you know if there are any CSP Violations?

The beauty of CSP is that it has covered the scenario of reporting the violations back to you. As a part of CSP, you can define a URL where the users' browser will automatically send a violation report back to your server for further analysis.

For this, you need to set up an endpoint that handles the POST payload sent as the CSP violation report by the browser. The following shows an example of specifying a `/csp-incident-reports` path to receive the violation report payload.

```
Content-Security-Policy: default-src 'self'; report-uri /csp-incident-reports
```

If we include a JavaScript or Style outside the sites own origin (e.g; otherdomain.com), let's say by accident when we visit the site URL (e.g; example.com), the above policy will reject it from loading to the browser and submit the following violation report as the HTTP POST payload.

```json
{
  "csp-report": {
    "document-uri": "http://example.com/index.html",
    "referrer": "",
    "blocked-uri": "http://otherdomain.com/css/style.css",
    "violated-directive": "default-src 'self'",
    "original-policy": "default-src 'self'; report-uri /csp-incident-reports"
  }
}
```

## Browser Support and Tools

![Reference: [https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP#:~:text=Content%20Security%20Policy%20(CSP)%20is,defacement%20to%20distribution%20of%20malware.)](https://cdn-images-1.medium.com/max/2032/1*ODx8xXDOhYNte1UgGThzjQ.png)

As you can see, all the major browsers support the CSP feature. This is good news since the investment we put in creating the CSP addresses a larger user base.

Besides, browsers like Chrome have gone even further by providing tools to validate CSP attributes. For example, if you define the hash of the JavaScripts, Chrome Developer Console will promote the correct hash for developers to rectify any error.

In addition, if you use Webpack to bundle your JavaScripts, you can find a Webpack plugin named [CSP HTML Webpack Plugin](https://www.npmjs.com/package/csp-html-webpack-plugin) to append the hash at build time automate this process.

## Summary

After observing several projects, Content Security Policy is something you often forget to set up mostly due to the awareness gaps. I hope this article has now convinced you how to set up CSP in your ongoing projects.

However, it’s also important to do a proper analysis of all the resources used in the application before creating the CSP. With this, you can create a better restrictive CSP by whitelisting all the known resources and blocking others by default.

I do hope that you will feel free to ask any questions on this or make your suggestions. You can mention them in the comment box below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
