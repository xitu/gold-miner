> * 原文地址：[Enhance JavaScript Security with Content Security Policies](https://blog.bitsrc.io/enhance-javascript-security-with-content-security-policies-5847e5def227)
> * 原文作者：[Ashan Fernando](https://medium.com/@ashan.fernando)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/enhance-javascript-security-with-content-security-policies.md](https://github.com/xitu/gold-miner/blob/master/article/2020/enhance-javascript-security-with-content-security-policies.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[HurryOwen](https://github.com/HurryOwen)

# 内容安全策略提升 JavaScript 安全性

![Image by [Free-Photos](https://pixabay.com/photos/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=690286) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=690286)](https://cdn-images-1.medium.com/max/3840/1*s3SfHFu0tszfPURFr9mOFQ.jpeg)

您对自己的 JavaScript 代码遭受攻击时的安全性有多自信？而且，为什么要为此担心呢？当我们研究现代 Web 应用程序时，它们的共同点之一是都使用 JavaScript。在某些应用程序中，JavaScript 发挥了其优势，从而贡献了大部分代码。JavaScript 的重要属性之一是，我们编写的代码在我们访问受限的用户浏览器中执行。

尽管我们对执行环境的控制很少，但至关重要的是确保 JavaScript 的安全性并对执行的操作进行控制。

> 您是否可以确保操作浏览器遵守一系列准则并执行 JavaScript 代码？

阅读本文之后，您将了解内容安全策略的常见属性，以及如何使用它们在运行时保护 JavaScript 代码。

## 内容安全策略

> **内容安全策略** （[CSP](https://developer.mozilla.org/en-US/docs/Glossary/CSP)）是安全性的附加层，有助于检测和缓解某些类型的攻击，包括跨站点脚本（[XSS](https://developer.mozilla.org/en-US/docs/Glossary/XSS)）和数据注入攻击。这些攻击可用于从盗窃数据、破坏站点到分发恶意软件等所有方面。

顾名思义，CSP 是可以与 JavaScript 代码一起发送到浏览器以控制其执行的一组指令。例如，您可以设置 CSP 以将 JavaScript 的执行限制在一组列入白名单的域中，而忽略任何内联脚本和事件处理程序以防止受到 XSS 攻击。此外，您可以指定所有脚本都应通过 HTTPS 加载，以降低数据包嗅探攻击的风险。

那么我应该如何为 Web 应用程序配置 CSP？

有两种配置 CSP 的方法：一种方法是返回包含特定[内容安全策略](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)的 HTTP 标头，另一种方法是在 HTML 页面中指定一个 [\<meta>](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta) 元素。

## 让我们看一个 CSP 示例

假设您为 Web 应用程序设置了以下内容安全策略：

```
内容安全策略：default-src'self'; script-src'self'https ://example.com;
```

然后，这将允许加载 JavaScript，例如来自 `https://example.com/js/*` 但会被 CSP 中指定的浏览器阻止 [https://someotherexample.com/js/*](https://otherurl.com/js/*)。此外，默认情况下，所有内联脚本也都被阻止，除非您使用哈希或随机数允许它们执行。

> 如果您还没有听说过哈希或随机数，我强烈建议您[参考此示例](https://content-security-policy.com/examples/allow-inline-script/)以了解其真正的潜力。

简而言之，通过散列操作，您可以将 JavaScript 文件的散列指定为 Script 块的属性，在该脚本块中，浏览器将在执行散列之前首先对其进行验证。

对于随机数也是如此，我们可以生成一个随机数并在 CSP 标头中指定，同时在 Script 块中引用相同的随机数。

## 如何判断是否存在任何违反 CSP 的行为？

CSP 的优点在于它涵盖了将违规情况报告给您的情况。作为 CSP 的一部分，你可以定义一个URL，用户浏览器将会自动根据URL发送违规报告给你的服务器以进行进一步分析。

为此，您需要设置一个端点来处理由浏览器作为 CSP 违规报告发送的 POST 负载。以下显示了指定 `/csp-incident-reports` 接收违规报告有效负载的路径的示例。

```
内容安全策略：default-src'self'; report-uri / csp-incident-reports
```

如果我们在网站本身的来源（例如 otherdomain.com）之外包含 JavaScript 或样式，那么当我们访问网站 URL（例如 example.com）时，上述政策将拒绝将其加载到浏览器并提交以下违规报告作为 HTTP POST 负载。

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

## 支持的浏览器和工具

![Reference: [https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP#:~:text=Content%20Security%20Policy%20(CSP)%20is,defacement%20to%20distribution%20of%20malware.)](https://cdn-images-1.medium.com/max/2032/1*ODx8xXDOhYNte1UgGThzjQ.png)

如您所见，所有主流浏览器都支持 CSP 功能。这是个好消息，因为我们在创建 CSP 上的投入可以满足更大的用户群。

此外，Chrome 之类的浏览器通过提供验证 CSP 属性的工具而走得更远。例如，如果您定义 JavaScript 的哈希值，Chrome 开发者控制台将为开发人员推广正确的哈希值，以纠正所有错误。

另外，如果使用 Webpack 捆绑 JavaScript，则可以找到一个名为 [CSP HTML Webpack Plugin](https://www.npmjs.com/package/csp-html-webpack-plugin) 插件在构建时附加哈希值，从而使此过程自动化。

## 总结

在观察了多个项目之后，由于意识上的差距，您常常忘记设置内容安全策略。我希望本文已经说服您如何在进行中的项目中设置 CSP。

但是，在创建 CSP 之前，对应用程序中使用的所有资源进行适当的分析也很重要。这样，您可以通过将所有已知资源列入白名单并默认阻止其他资源来创建更好的限制性 CSP。

我希望您可以随时提出任何问题或提出建议。您可以在下面的评论框中提及它们。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
